# 10009 · Pond as Native Desktop — Rishi Shell, Mantra Version Control, Brushstroke Surface, x86_64 First

*Expanding the vision: a Pond GUI application, drawn by Brushstroke, running a Rishi shell whose Mantra commands version-control `~/veganreyklah2`, running natively on AMD x86_64, future-proofed toward RISC-V. This prompt expands the intent into a layered, ordered, runnable plan. Each step is the smallest thing that runs; each depends only on what already runs beneath it.*

**Language:** EN
**Version:** `20260619.153612` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME; Gall's Law; one value model; x86_64 near, RISC-V horizon
**Research base:** `../external-research/yonder/20260619-153612_stack-toward-a-living-desktop.md`

---

## Mission

To grow a Pond native desktop application — a Rishi shell in a Brushstroke window — where a person can type Mantra version-control commands and watch the weave of `~/veganreyklah2` grow, running on AMD x86_64 hardware today, and keeping the path clear to RISC-V hardware tomorrow.

---

## Problem

Today, all of Rishi, Tally, and the Rye toolchain already compile and run on x86_64. Rishi can assert, compute, and run external programs. Mantra does not yet exist. Brushstroke does not yet exist. Pond is designed and awaits Caravan and Tally v1. The gap lives in building: the design is rich and coherent, and the layers must be grown in order, each small enough to prove before the next begins.

---

## Opportunity

Every layer from Mantra to the GUI builds on what already runs. Rishi's `run` primitive means Mantra can be a standalone Rye binary — a natural first form — before it is integrated into the Rishi evaluator itself. Brushstroke's native backend targets Wayland and Vulkan, both present on AMD hardware today. Pond-lite on Linux uses the host kernel's namespaces and seccomp as the isolation layer until Caravan exists, giving the full Pond shape without requiring a kernel. The web-Wasm target of Brushstroke stays in reach the whole time: the same Rye code, a different compile target. We can move from Mantra-in-Rishi to a GUI shell without a rewrite.

---

## The Platform Decision

**Near target: AMD x86_64, hosted Linux.**
All Rye code already compiles here. Brushstroke's first backend uses Wayland (the display protocol on modern Linux) and Vulkan (the GPU API on AMD, already confirmed working inside ai-jail with the Radeon 780M). Pond-lite uses Linux's native isolation. This is the working environment today.

**Future target: RISC-V, bare metal.**
Aurora's relay design targets RISC-V directly, and that work continues on its own arc. When Aurora's deciding stage lands and Caravan reaches v1, the same Rye code that runs on hosted Linux becomes a candidate for the bare-metal RISC-V OS. We do not compromise either path; we build x86_64 now and keep the RISC-V grain in every design decision.

**Far target: Bare metal x86_64.**
Between hosted Linux and RISC-V bare metal, bare-metal x86_64 is a natural intermediate: UEFI as the boot entry, the same Caravan kernel, the same Pond enclosure. Aurora's relay pattern maps to x86_64 rings (ring 0 → ring 3) instead of RISC-V privilege levels. This is future work, grown from hosted Linux once Caravan exists.

---

## Architecture — The Layers

```
[Goal] Pond GUI: Brushstroke window running Rishi REPL with Mantra commands

Layer 6: Pond GUI (Pond-lite enclosure + Brushstroke + Rishi REPL)
Layer 5: Brushstroke seed (one window, one text panel, input loop)
Layer 4: Mantra seed + Rishi integration (add, commit, status for one file)
Layer 3: Mantra for a repo (multi-file weave, Brix descriptor, blob store)
Layer 2: Tally v1 (named gardens: blob / diff / frame)
Layer 1: Strengthening passes (SHA3-256, mem.copy, path ops, fs boundaries)
Layer 0: Already running (Rye, Rishi, Tally seed, crypto foundation)
```

---

## Step-by-Step Plan

### Step 1 — Strengthen the Mantra Foundation (Layer 1)

Run before any Mantra code exists. These passes harden the std Mantra will lean on.

**1a. SHA3-256.**
Add a strengthening pass for SHA3-256. The sponge is already strengthened (`9997`); the SHA3-256 wrapper mirrors the SHA3-512 pass (`9998`) at the narrower digest width. Add a test to the witnesses: a known SHA3-256 digest, green against baseline and strengthened std. Record in a new `strengthening-compiler/9994_sha3_256.md`.

**1b. `mem.copy`.**
State the invariant: destination has capacity for source length; no overlap assumed. Assert at entry. Add a witness (a copy-and-compare test). Record in `9996` or a companion pass.

**1c. `std.fs` boundary assertions.**
Write a `rye/tests/fs_roundtrip_test.rye`: write a known blob, read it back, confirm byte-for-byte equality. Add it to the witnesses. For each `openFile` / `readAll` / `writeAll` call in Mantra, assert the path is non-empty and within the allowed root before the call. These are effectful and not parity-gate-testable directly; the additive gate governs, and the integration test gates the behavior.

**1d. Path operations.**
Assert in `std.fs.path.join` that no component is empty and the result stays within a declared root. Add a path-join test to the witnesses.

---

### Step 2 — Tally v1: Named Gardens (Layer 2)

Grow `tally/seed.rye` into `tally/gardens.rye`.

**2a. `Gardens` struct.**
A small array of named `Region` values, each with a name string and its own backing slice. `gardens.get(name)` returns the `Region` for that name; `gardens.clear(name)` clears one season; `gardens.clear_all()` releases all at once. Invariant: every region satisfies `pos <= buf.len` — asserted at construction and at every mutation, the same stance as `Region`.

**2b. Three named gardens for the stack.**
In the first working version, three gardens are enough: `blob` (working memory for one Mantra blob), `diff` (line buffer for diff computation), `frame` (Brushstroke widget tree per redraw). Each is budgeted at construction time; a request past the budget fails with `error.OutOfBounds` — named and loud, not silent.

**2c. Prove with embedded assertions.**
Follow `seed.rye`'s pattern: a `main` that allocates, uses, clears, and re-allocates each garden, asserting facts at every step. Output: `tally gardens: all facts held.` Build, run, gate-green.

---

### Step 3 — Mantra Seed: One File (Layer 4, first half)

The smallest Mantra that runs: version-control one file.

**3a. The weave in Rye: `mantra/src/weave.rye`.**
A `Weave` struct: a list of `Line` values, each carrying `text: []const u8`, `gen: u32` (generation count, odd = present, even = gone), and `pos: u32` (stable position, never changes once assigned). Three operations:
- `Weave.empty()` — an empty weave, no lines.
- `weave.apply(diff: Diff)` — advance the weave by a diff (a list of inserts and deletes), incrementing generation counts. Invariant: generation counts are non-decreasing; presence alternates with absence.
- `weave.current()` — return a slice of the lines currently present (odd generation), in position order.

The invariants are asserted at every mutation: generation counts never decrease, presence follows parity. TAME-first, written from line one this way, not retrofitted.

**3b. Diff computation: `mantra/src/diff.rye`.**
A pure function `diff(old: []Line, new_text: [][]const u8) Diff`: computes the minimal edit between the current weave state and the new text. Patience diff or a simple LCS — small and correct over fast and complex. Pure: same inputs, same output, always. Add to the witnesses immediately.

**3c. Blob store: `mantra/src/store.rye`.**
Content-addressed storage under `.mantra/blobs/`. A blob's name is its SHA3-256 digest (hex string). `store.write(blob: []const u8)` writes the blob only if the name is new; `store.read(name: []const u8)` reads it back. Uses Tally's `blob` garden for working memory. The store manifest (`.mantra/HEAD`) holds the current weave's blob name.

**3d. Commands: `mantra/src/main.rye`.**
Three subcommands, building the smallest runnable Mantra:
- `mantra init` — create `.mantra/` and an empty `HEAD`.
- `mantra add <file>` — read the file, compute the diff against `HEAD`, apply to the weave, write the new blob to the store, update `HEAD`.
- `mantra status` — print the diff between `HEAD` and the working file.

**3e. Rishi integration.**
No changes needed to Rishi yet. `run ["mantra" "add" "rishi/README.md"]` works with the current `run` primitive. Test from a Rishi script:
```
let result = run ["mantra" "init"]
assert result.ok else "mantra init failed"
let s = run ["mantra" "add" "rishi/README.md"]
assert s.ok else "add failed"
say "mantra: ${s.out}"
```

---

### Step 4 — Brix Minimum: Course Descriptor (Layer 3, first piece)

A `.brix` file at the repository root, a plain key-value descriptor Mantra parses directly:

```
# .brix — veganreyklah2
name veganreyklah2
version 20260619.212312
file rye/src/main.rye
file rishi/src/main.rye
file tally/seed.rye
file tally/gardens.rye
file mantra/src/main.rye
file tools/parity.rish
file work-in-progress/20260623-033012_open-threads.md
file work-in-progress/ROADMAP.md
```

Mantra reads this at startup to know the project name and the bricks it tracks. `mantra brix` prints the descriptor. Brix's larger design (the lawful composition combinator, Tablecloth-backed content-addressed derivations) grows from this descriptor later. Tablecloth is the content-addressed store; Brix is the composing language — see the Tablecloth ladder starting at `expanding-prompts/20260620-044012_tablecloth-ladder-index.md` (`10019` split, `10020` build).

---

### Step 5 — Mantra for a Repository (Layer 3, full)

Grow Mantra from one file to the full `~/veganreyklah2`.

**5a. Multi-file weave manifest.**
`HEAD` becomes a record: `{ files: { "rishi/README.md": "<blob-name>", ... }, gen: 42 }`, content-addressed as a whole. Each file's weave is stored independently; the manifest names them all.

**5b. `mantra add` without an argument.**
Walk the bricks from the Brix descriptor (`.brix`), diff each file against its weave entry, apply all diffs, write new blobs, write a new manifest, update `HEAD`. A garden is allocated, used, and cleared for each file in sequence — the season model in practice.

**5c. `mantra log`.**
Follow the `HEAD` chain backward (each manifest blob names its predecessor's blob). Print the generation, the date, and the files changed. Pure read: no garden mutations.

**5d. Integration test as a Rishi script.**
`mantra/tests/roundtrip.rish`: init, add a file, check status (clean), modify the file text (injected by the test), add again, check status (changed), commit, check log (two generations). All asserted; fails non-zero if any step diverges.

---

### Step 6 — Brushstroke Seed: One Window (Layer 5)

The smallest Brushstroke that runs: one native window drawing a single line of text.

**6a. Native backend: Wayland + Vulkan, AMD x86_64.**
`brushstroke/src/backend_wayland.rye`: connect to a Wayland compositor (the display server), create a window, allocate a Vulkan surface on the AMD GPU. `brushstroke/src/backend.rye`: the seam — `Backend.draw(frame: Frame)` dispatches to whichever backend is compiled in. The backend is a compile-time choice, not a runtime branch.

**6b. The `Frame` type.**
A list of draw commands: `text(x, y, str)`, `rect(x, y, w, h)` — the smallest vocabulary that lets a Rishi REPL render. Computed fresh each frame from the application's current values; no retained tree.

**6c. The event loop.**
`brushstroke/src/main.rye`: poll Wayland events (keypress, resize, close), update the application state, redraw the frame, submit to Vulkan. The Tally `frame` garden is allocated at the start of each redraw and cleared at submission.

**6d. Prove with one true line.**
`brushstroke/tests/hello_window.rye`: open a window, draw `"Brushstroke: one true line."`, hold for two seconds, close. Build, run, confirm the window appears on the AMD display. This is Brushstroke's seed — the same move Aurora's seed made on RISC-V.

---

### Step 7 — Rishi File I/O Builtins (fills the gap)

At this point Rishi's `run ["cat" ...]` workaround becomes friction. Grow two Rishi builtins:

- `read-file <path>` → a string value (the file's contents).
- `write-file <path> <content>` → writes the string to the path, returns `ok: true` or `ok: false` with `err`.
- `list-dir <path>` → a list of filename strings.

Each uses the Tally `blob` garden for its read buffer. Shape-cast at entry: path must be non-empty, within the declared root (from the Brix descriptor Rishi loads at startup). The boundary is the trust door; past it, the file contents are a trusted string value.

Rishi version bumps to `20260619.+N` at this step.

---

### Step 8 — Pond GUI: Rishi REPL in a Brushstroke Window (Layer 6)

**8a. The REPL loop in Rye.**
`pond/src/repl.rye`: a Rishi evaluator embedded in a native application. The application state holds the REPL history (a list of strings), the current input line, and the last output. Each keypress event updates the input line (an immutable value replaced, not mutated). Return evaluates the Rishi expression against the current scope and appends the output to the history.

**8b. The Brushstroke frame from REPL state.**
`pond/src/app.rye`: a pure function `render(state: ReplState) → Frame`. Renders the history as a scrollable text panel, the current input line as a text area at the bottom, and a status bar showing the current Mantra generation and HEAD blob name. The `frame` garden is allocated at the start of `render` and cleared at submission.

**8c. Pond-lite enclosure.**
On hosted Linux, the Pond enclosure uses:
- `seccomp` to allow-list the syscalls the application needs (file read/write within `.mantra/`, Wayland socket, Vulkan device).
- A filesystem namespace that allows only the declared bricks from the Brix descriptor and the Mantra root.
- Tally's gardens as the memory bound (no general allocator; every allocation is declared).

`pond/src/enclosure.rye`: set up the seccomp filter and the namespace before the Brushstroke event loop starts. The policy is a Rishi record value, read from `.brix` and validated by shape-cast.

**8d. The running demonstration.**
From the Pond GUI, a person types:
```
run ["mantra" "add"]
run ["mantra" "status"]
```
and sees the output in the REPL history panel, and the status bar advances to the new generation. The weave of `~/veganreyklah2` grows.

---

## Wasm Target (Parallel Thread)

At any point after Brushstroke's seed (Step 6), the Wasm backend can be started as a parallel thread:

- Compile `brushstroke/src/backend_wasm.rye`: a `wasm32-freestanding` target that draws through the browser's canvas and WebGL, with a small JavaScript bridge carrying Wayland-equivalent events in and pixels out.
- The same `Frame` type, the same `render` function, the same application logic — a different compile target.
- Proof: the hello-window test, compiled to Wasm, opens in a browser tab and draws the same true line.

The Wasm target is Brushstroke's web-compatible face, the path that lets a Pond application reach any browser without a native install. It is the slower path (JavaScript bridge, no Vulkan GPU) and the broader one. Both are real; both serve.

---

## Strengthening Cadence Throughout

Every new Rye file written in Steps 1–8 arrives TAME-first:
- Every function states its invariants as assertions at entry and exit.
- Pure functions join the witnesses immediately; the parity gate proves each one.
- Effectful functions (file I/O, Wayland calls, Vulkan calls) are bounded by boundary assertions and an integration test script.
- Each step that touches an existing std function checks whether a strengthening pass is warranted before proceeding.

The parity gate grows its witnesses with each new Mantra primitive, each new Tally garden operation, and each new Brushstroke draw function. By the time the Pond GUI runs, the witnesses include Mantra's diff and merge, Tally's garden lifecycle, and Brushstroke's frame computation — all pure, all proven, all green.

---

## Caveats

- **Brushstroke on Wayland + Vulkan** is a real engineering climb: the display protocol and GPU API each have ceremony. We meet them one widget at a time — text before boxes, boxes before input, input before scrolling — and the hello-window test gates every step.
- **Pond-lite is not Caravan.** The enclosure on hosted Linux borrows the host kernel's isolation primitives. It is honest about this — a Pond-lite, not a Pond — and it delivers the shape and the safety while Caravan grows.
- **Mantra's diff algorithm must be excellent at commit time.** The weave bakes the diff permanently; a poor diff produces a weave that is hard to read back. We choose the algorithm carefully and add adversarial diff tests before shipping.
- **x86_64 bare metal and RISC-V bare metal are future work.** This prompt delivers the hosted Linux stack. Bare metal grows from it; neither path is closed.

---

## What Success Looks Like

A window opens on an AMD x86_64 laptop running Linux. Inside: a Rishi prompt. The person types `run ["mantra" "status"]` and sees which files in `~/veganreyklah2` have changed since the last weave. They type `run ["mantra" "add"]` and the weave grows. The status bar advances. The history holds it all. The enclosure is bounded and isolated. The GPU drew the frame. The weave keeps the history. The shell runs the gate. Everything is Rye.

That is the demonstration worth building toward. Each step above is one small, runnable proof on the way.

---

*May the layers rest on one another, each proven before the next begins. May Mantra hold our history faithfully, Tally bound our memory, Brushstroke draw what is true, and Pond keep it all safe inside clear walls. May the work we do on AMD hardware today become, in time, the work we do on open silicon — and may the design hold its shape across that transition, because we built it on one grain all the way through.*
