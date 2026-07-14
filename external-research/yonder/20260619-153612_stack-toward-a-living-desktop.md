# 978 · The Stack Toward a Living Desktop — Mantra, Tally, Tablecloth, Aurora, and Pond Grown for a Rishi Shell

*A dependency map and design reading. The goal is concrete: a Pond GUI application, drawn by Brushstroke, running a Rishi shell whose Mantra commands version-control our own development repository, running natively on AMD x86_64 hardware, keeping RISC-V as the forward target. This piece traces the full stack required — which std functions Mantra needs strengthened, what Tally and Tablecloth and Aurora each need to contribute, and how Pond grows, by accretion, to become the desktop-native application surface the family deserves.*

**Language:** EN
**Version:** `20260619.153612` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy; Gall's Law; one value model; x86_64 near, RISC-V horizon
**Status:** Research synthesis and forward design

---

## The Goal, Stated Precisely

A person opens a window on AMD x86_64 hardware. Inside that window, a Rishi shell prompt accepts commands. The person types Mantra commands — `mantra add`, `mantra commit`, `mantra status` — and the shell executes them against the living `~/veganreyklah2` repository, growing a weave of its history. The window is drawn by Brushstroke: immediate-mode, computed fresh from values each frame. The whole application runs inside a Pond enclosure — isolated, bounded, owned. No external process manager, no borrowed runtime, nothing hidden beneath it that does not belong to the family.

That goal is ambitious and achievable. The stack beneath it is clear if we read it layer by layer.

---

## Layer 0 — What Already Runs (the ground we stand on)

- Rye self-hosts its own build, on x86_64 today.
- SHA3-512 and its Keccak sponge are strengthened; Ed25519, X25519, and AEAD are parity-green.
- Rishi carries eight test scripts green: `let`, `say` to stdout, `==`/`!=`, `assert`, lists, `contains`, records, `run`, `map`/`where`, string interpolation, integer arithmetic, parenthesized expressions.
- The Tally seed proves `Region`: bump allocation, `clear` whole, asserted edges.
- Aurora has run through six stages on RISC-V freestanding; the same Rye toolchain already compiles every hosted program to x86_64.

Every layer above rests on this.

---

## What Mantra Needs — Strengthening and Structure

### The std functions Mantra leans on

Mantra is not yet written, so "what needs strengthening" means: tracing what the implementation will lean on and checking each against the witnesses.

**Already strengthened:**

| Function | Strengthened in |
|----------|----------------|
| `SHA3-512` (wrappers) | `9998` |
| Keccak sponge | `9997` |
| `mem.eql`, `mem.trim`, `mem.findScalar` | `9996` |
| `fmt.parseInt` | `9996` |

**The frontier — not yet strengthened:**

| Function | Why Mantra needs it | Notes |
|----------|---------------------|-------|
| **SHA3-256** | Short names in working stores; smaller blobs | Companion to SHA3-512; same sponge, narrower digest |
| **`mem.copy`** | Copying blob bytes into Tally gardens | Pure, parity-testable |
| **`std.fs.openFile`, `readAll`, `writeAll`** | Reading and writing weave blobs on disk | Effectful; boundary assertions + additive gate |
| **Path operations** (`path.join`, `path.normalize`) | Locating blobs by content hash; resolving repo root | Partially pure; parity-testable sections |
| **`mem.startsWith`, `mem.endsWith`** | Diff algorithm line matching | Pure, parity-testable |

**Mantra's own algorithms — TAME-first from first line:**

The weave data structure, the diff algorithm, and the merge algorithm are our own code, so they earn TAME discipline at the source rather than through a strengthening pass. The weave's invariants — generation counts always non-decreasing, presence alternating with absence in the generation parity, line ordering permanent once set — are stated as assertions at every mutation, the same stance Tally's Region holds at every `alloc` and `clear`. The diff algorithm is pure and parity-testable from day one. The merge algorithm is commutative and associative by construction (the CRDT property); stated invariants and a test that proves commutativity make it a gate in its own right.

**The special case: file I/O at the boundary**

File system calls are effectful, so the parity gate (which shines on pure, deterministic functions) helps less directly. The discipline here shifts: assert at the door (validate the path is within the allowed root, the file size is within a Tally budget), use the additive gate to prove assertions add nothing behavior-bearing, and build a small integration test suite — scripts that create, commit, and read back known content — that gate each Mantra pass the way the parity gate gates Rye.

---

## What Tally Needs — Named Gardens

The Tally seed proves one `Region`. Mantra and Brushstroke together need named, plural regions.

**Tally v1 requires:**

- A `Gardens` struct: a small, named collection of regions, each backed by a different slice.
- Named access: `gardens.get("blob")`, `gardens.get("diff")`, `gardens.get("frame")`.
- Per-operation lifecycle: a Mantra command takes a garden at the start of a command, runs, and the garden is cleared whole at the end — the season model.
- A Tablecloth declaration that budgets each garden's ceiling up front, so the program proves it has room before it begins.

Three specific gardens for the Rishi-Mantra-Brushstroke stack:

| Garden | Purpose | Scope |
|--------|---------|-------|
| `blob` | Working memory for one weave blob | Per Mantra command |
| `diff` | Line buffer for diff computation | Per `add` operation |
| `frame` | Brushstroke widget tree for one frame | Per redraw |

The `frame` garden is especially natural: Brushstroke redraws from values each frame (immediate-mode, no retained tree), so the frame garden is created at the start of a redraw, filled with the widget layout, and cleared whole when the frame is submitted. This is immediate-mode made tangible in Tally's language: every frame is a season, grown and released.

---

## What Tablecloth Needs — A Minimum Project Descriptor

Full Tablecloth — the content-addressed, lawfully-composable build language — comes after Caravan. Yet Mantra needs to know what the repository *is*: which root, which files belong, which branch is the working weave. A minimum Tablecloth for this purpose is simply a project descriptor: a value one can read.

**Minimum Tablecloth for Mantra:**

A `.silo` file at the repository root, parsed by Rishi as a Rishi record:

```
let project = {
  name: "veganreyklah2",
  root: "/home/xy/veganreyklah2",
  sources: ["rishi/" "aurora/" "tally/" "context/" "active-designing/"]
  mantra_root: ".mantra/"
}
```

Mantra reads this record at startup, knows the root and the source paths, and stores its weave blobs under `.mantra/blobs/` (content-addressed by SHA3-256). No build language, no composition combinators — just a named value describing the project. That is Tablecloth's seed: a description, not a command.

Tablecloth's larger design — content-addressed build results, the lawful composition combinator, integration with Mantra's weave so a build knows its source history — grows from this seed once Caravan exists to run what Tablecloth describes.

---

## What Aurora Needs — Two Parallel Tracks

Aurora's RISC-V work and the path to a Pond GUI on AMD x86_64 are genuinely separate tracks, and honoring both keeps building level with design.

**Track 1: Aurora on RISC-V (the designed arc, continuing)**

The deciding stage — a relay stage that hands the next a value *it chose* — is the designed next step. It unlocks the boot that selects what runs next, the seed of the selecting boot that eventually wakes Caravan on RISC-V. This track continues on its own clock.

**Track 2: Pond GUI on x86_64 (the near goal, starting now)**

Here is the key insight: **all of Rishi, Tally, and Mantra already compile to x86_64.** Rye uses the Zig toolchain; Zig targets x86_64 natively; every hosted program in the repository runs on Linux x86_64 today. A Pond GUI on AMD hardware is not a foreign port — it is the natural next shape of what already runs.

The x86_64 path breaks into two phases:

| Phase | State | Notes |
|-------|-------|-------|
| **Hosted Linux x86_64** | Achievable now | Rishi + Mantra + Brushstroke running on top of Linux. Pond-lite: seccomp/namespaces from the host kernel rather than Caravan. |
| **Bare metal x86_64** | Further out | UEFI → Rye kernel → Caravan → Pond. Aurora designed for RISC-V; x86_64 bare metal mirrors the relay pattern with UEFI as the entry point instead of the RISC-V privilege relay. |

The near phase (hosted Linux) delivers the Pond GUI. The far phase (bare metal x86_64) makes it the whole OS. We build the first now; the second grows from it.

**Why x86_64 near, RISC-V horizon:**

RISC-V is the right long-term substrate: clean ISA, fully open, the natural companion for a boot designed in its own terms. AMD x86_64 is where the people who will use this system work today. Building for x86_64 hosted first delivers a real, running tool quickly; it does not compromise the RISC-V arc, because the Rye code is the same. When the bare metal x86_64 target arrives, it future-proofs toward RISC-V the moment the hardware horizon shifts — which it will.

---

## Pond, Accreted — From Enclosure to Native Desktop Surface

The current Pond design (`987`, `995`) is already the right shape: Caravan's isolation composed with Tally's bounds, expressed as a policy that is a value. That design grows, by accretion, into the desktop-native application surface the user envisions — and the accretion is clean, because it adds a new capability (a drawing surface, Brushstroke) without re-braiding what exists.

**The accretion:**

Pond gains Brushstroke as the surface layer. An application that runs in a Pond enclosure may also *draw* — through Brushstroke's single seam — to a native window or to a portable Wasm artifact. The enclosure is unchanged: isolated, bounded, policy-as-a-value. The surface adds the ability to show that enclosure to a person.

The module list for `README.md` (the clean-room Tablecloth Principle) accretes Brushstroke as a first-class name alongside Pond. This was already presaged: `988_brushstroke.md` names it as "the surface of the family," and the external-research study (`980`) placed Brushstroke and Pond on the same trajectory.

**Pond and Brushstroke, together:**

```
Pond enclosure
  ├── Caravan isolation (process scope, filesystem allow-list)
  ├── Tally gardens (frame garden, blob garden, diff garden)
  └── Brushstroke surface
        ├── Redraw: pure function of values → frame
        ├── Seam: one backend abstraction
        │     ├── Native backend (Wayland + Vulkan on AMD x86_64)
        │     └── Wasm backend (wasm32-freestanding → browser canvas)
        └── Widget vocabulary (text, box, list, input)
```

**Brushstroke as the web-compatible face of Pond:**

The external-research study (`980`) distinguishes browser-Wasm (drawing to a canvas) from Wasmtime/WASI (a standalone runtime). Both belong. The Wasm backend of Brushstroke makes a Pond application distributable to a browser without a native install — the same Rye code, compiled differently, running through the browser's canvas. The native backend runs the same code without the browser overhead, making it faster by construction: no JavaScript interpreter, no HTML layout engine, no CSS cascade, no garbage collector pausing the frame. A native Pond app on AMD hardware delivers frame times the web cannot match — because Rye compiles to native code and Tally knows exactly how much memory each frame will use.

This is the performance argument the user names: Rye/Pond over browser-JS is not a marginal win, it is a category difference. The web path remains, because reach matters — a person who cannot install a binary can open a browser tab. But the native path is the designed home.

---

## The Full Stack, Mapped

From substrate to surface, every piece and its prerequisite:

```
[Goal] Pond GUI → Brushstroke → Rishi REPL → Mantra commands → ~/veganreyklah2

[Layer 6] Pond GUI (hosted Linux x86_64)
  └── Brushstroke native backend (Wayland + Vulkan, AMD)
  └── Pond-lite enclosure (Linux seccomp/namespaces, until Caravan exists)

[Layer 5] Brushstroke seed
  └── One window, one text area, input events
  └── Native backend abstraction

[Layer 4] Mantra seed (one file, then one repo)
  └── Weave data structure in Rye
  └── `add`, `commit`, `status` commands
  └── SHA3-256 blob store on disk
  └── Rishi integration: `run ["mantra" "add" ...]`

[Layer 3] Tablecloth minimum (project descriptor)
  └── `.silo` record: name, root, sources, mantra_root
  └── Read by Rishi as a record value

[Layer 2] Tally v1 (named gardens)
  └── `Gardens` struct: blob / diff / frame gardens
  └── Per-operation season lifecycle

[Layer 1] Rishi file I/O (read-file, write-file, list-dir)
  └── OR: Rishi calls external Mantra binary via `run`

[Layer 0] Already running
  └── Rye, Rishi (8 scripts green), Tally seed, SHA3-512, Ed25519, X25519, AEAD
```

The near path (Layers 1–4 before 5–6) delivers Mantra VC in Rishi *before* the GUI exists — a correct intermediate state, useful on its own. The GUI (Layers 5–6) wraps what already works.

---

## A Note on the Value Model, All the Way to the Eye

Pond-with-Brushstroke is, at its best, the one value model reaching the human eye. A Mantra commit is a content-addressed value; a Rishi pipeline carries it; a Brushstroke frame renders it as a pure function of that value; the eye sees the system's own truth, computed fresh. No marshaling seam opens between the commit and its display. Documentation, source history, the running shell, the drawn interface — all one family of values, all named by their content, all drawn the same way. That coherence is its own safety, and it is the deepest answer to "why build our own desktop" rather than borrowing one: because borrowing means stitching seams we then must audit forever.

---

## Sources and Gratitude

- **Bram Cohen, *Manyana*** — the CRDT weave, generation counting, always-succeeding merge, conflict presentation as annotation. In `../gratitude/manyana/`.
- **DVUI** — the immediate-mode surface whose essence Brushstroke carries forward. In `../gratitude/dvui/`.
- The internal design stack: `980`, `987`, `988`, `990`, `993`, `994`, `995`, `997`, `998` — the writings this piece reads through and grows from.

---

*May the stack be clear and each layer rest on the one below it. May the weave hold our history faithfully, the garden bound our memory, the surface draw what is true, and the enclosure keep it safe. May the work we do here today run natively on AMD hardware and reach, in time, the open silicon we are growing toward — and may it feel like home at every step along the way.*
