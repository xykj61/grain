# Cursor Pass — SLC-1 Version and Recall, the Width Seam Made Honest, and TAME Hardening of the Named Seeds

*A gated runbook. The ground builds clean against pristine std, the first ring grows from type-and-run to version-and-recall, the width lint comes into agreement with its own doctrine, and the named seeds — Mantra, Brix, Caravan, Tally — earn a little more TAME, with Aurora held in a careful light touch. Each phase proposes before it applies.*

**Stamp:** `20260629.004912`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Discipline:** TAME (see `context/TAME_STYLE.md`) · SLC (see `context/SIMPLE_LOVABLE_COMPLETE.md`)
**For:** Cursor Composer 2.5, running inside the ai-jail sandbox
**Bridge:** Kaeden carries this into the jail, runs the metal, and rules every open question.

*Written together by Kaeden and Reya 2.*

---

## Orientation — Read These First

Read your home before you build. `context/REYA2.md` for who you are, then the disciplines that govern this pass: `context/TAME_STYLE.md` for the code, `context/RADIANT_STYLE.md` for the voice, `context/SIMPLE_LOVABLE_COMPLETE.md` for scope. The plan lives in `work-in-progress/ROADMAP.md` (why and order) and `work-in-progress/TASKS.md` (what-now). The ring you are growing has a hammock scope note at `active-designing/20260628-071012_slc-1-rishi-mantra-shell.md` — build cites that note. The width seam is documented in the Rye supplement of `context/TAME_STYLE.md` and in `tools/width-check.rish`. The exemplar to mirror is `tally/seed.rye`.

---

## How We Work This Pass

Propose, then apply. Show the diff for each phase and wait for Kaeden's confirmation before you write it. Move one phase at a time, in the order below.

Hold an honest definition of done. A change is **verified-by-running** only when it truly runs; everything else is **verified-by-inference**, and you say which. Anything that needs the `rye` wrapper or the built `rishi`/`mantra` binaries runs on Kaeden's metal — the sandbox panics on `rye`'s DWARF limit. You can still typecheck `.rye` against pristine std with the pinned Zig toolchain the seed headers document, and you run every non-`rye` gate you can. Mark each item **[sandbox-verifiable]** or **[metal-gated]** plainly.

Gate before every irreversible move. Build in TAME order — safety, then performance, then the joy of the craft. Grow from the running seed; never design the whole at once.

---

## What This Snapshot Shows — the ground I verified

- **SLC-1 Step 1 is sealed and pushed.** `rishi repl` carries bindings forward; Berry gratitude at tip (`7223831`).
- **Witness suite ran green on metal** (`2026-06-28`): 116 `rye run` witnesses + `slc1_repl_step1.rish`; `parity-selftest.rish` green. Task **1f** (register Step 1 witness in `tools/parity.rish`) is **done in the working tree** — commit and push pending. Build env: `HOME=/home/xy/veganreyklah2/.build-home` (host `/home/xy` tmpfs full).
- **Pristine std** at `vendor/zig-toolchain` names the process arena **`init.arena`**. **`rishi/src/main.rye`** and **`rye/src/main.rye`** already migrated. **Nine** authored seeds still say **`init.garden`** (listed in Phase 1).
- **`width-check.rish` flags the very seam TAME prescribes.** It substring-greps `usize`, so it counts the sanctioned inherited-std seam casts (`const start: usize = @intCast(self.pos);`) as violations. By that measure it is currently red on `tally/seed.rye`, `tally/gardens.rye`, all four `caravan/*`, `mantra/src/main.rye`, `comlink/hosted_wire.rye`, and `aurora/src/deciding.rye`. This wants a ruling — Phase 4 holds it.
- **`.brix` points at two files that no longer exist** — `work-in-progress/995_open_threads.md` and `work-in-progress/996_roadmap.md`. So `mantra add` (from `.brix`) fails on them and `mantra brix` reports a stale truth. Phase 6 mends it.
- **Aurora is freestanding** and carries its own bare-metal `assert(ok: bool) void { if (!ok) unreachable; }` in each seed, with no `std` beneath it. It must stay that way. Phase 7 holds the guardrail.

---

## The Order of Work

1. **Ground** — `init.garden` → `init.arena`, so everything compiles against pristine std. **[sandbox-verifiable]**
2. **SLC-1 Step 2 — version.** **[metal-gated to run; sandbox-verifiable to typecheck]**
3. **SLC-1 Step 3 — recall.** **[metal-gated to run]**
4. **The width seam made honest** (a ruling), then **Phase 1b width migration of `mantra/*`**. **[sandbox-verifiable]**
5. **First TAME assert lint** + Mantra brought into compliance. **[sandbox-verifiable]**
6. **Brix descriptor honesty.** **[sandbox-verifiable]**
7. **Aurora — name the invariants** (light touch). **[sandbox-verifiable]**

Then gates, commit, push, and a session log.

---

## Phase 1 — Ground: `init.garden` → `init.arena`

The pristine std exposes the season allocator as `init.arena`. Migrate the nine remaining call sites so the seeds compile.

**Change, in each file:** replace `init.garden.allocator()` with `init.arena.allocator()`. **Keep the local variable name as it stands** (`allocator`, `garden`, whatever the file already uses) — Rishi's own precedent is `const garden = init.arena.allocator();`, a warm local name over the honest std field.

**Files:**

```
caravan/seed.rye
caravan/chain.rye
caravan/bounded.rye
caravan/twin.rye
mantra/src/main.rye
brushstroke/seed.rye
brushstroke/wayland_seed.rye
comlink/hosted_wire.rye
tools/enrich_strengthening_docs.rye
```

(`rishi/src/main.rye` and `rye/src/main.rye` already use `init.arena`.)

**Verify:** typecheck each touched seed against pristine std with the pinned toolchain the seed headers document. **[sandbox-verifiable]**

**Flag for Kaeden:** `context/TAME_STYLE.md` still instructs authors to reach for `init.garden`. Reality at the pristine seam is `init.arena`. This is the standing **garden-and-arena lexicon** question. Recommendation, unchanged from the handoff: keep `arena` at the std seam where honesty matters, let `garden` live as a free local name and as Tally's own future concept, and mint a `garden` type only when Tally graduates to own the allocator the seeds use. Do not edit the discipline doc this pass — surface it, and let Kaeden rule on a short `context/` lexicon note.

---

## Phase 2 — SLC-1 Step 2: Version

**Hammock scope:** [`active-designing/20260629-004912_slc-1-step-2-version.md`](../active-designing/20260629-004912_slc-1-step-2-version.md) — build cites that note. Persist the session into Mantra's store. Mantra stays a **separate seed** the loop drives — composition, never absorption.

**Two structures, each bounded and each honest.**

1. **The session ring buffer** — a bounded, in-memory record of the last *N* input lines, for `:history` and (Phase 3) `:recall`. Name the bound the way `Env` does:

   ```zig
   const max_history: u32 = 50; // last N input lines kept in the session ring
   ```

   Mirror `Env`'s shape: a fixed array, a `u32` count, an assert that the count never exceeds capacity, a bind that fails loudly at the edge rather than wrapping.

2. **The transcript** — an append-only text file at `.mantra/session.log` in the current directory, the durable trail `mantra add` weaves. Append one record per evaluated line.

   **Transcript scope for v1 (a ruling — see the close):** record the **prompt, the input line, and any caught evaluation error** — all three available centrally in the loop today. Capturing arbitrary builtin **stdout** into the transcript would mean threading a writer through every `do*` helper; that is out of scope for this ring and noted as a clean horizon. State this edge in a comment so the next reader meets the reason.

**Meta-commands this step adds:**

- `:history` — print the numbered entries of the session ring buffer.
- `:version` — on first use in the session, ensure `.mantra/` exists; then weave the transcript. Report the new HEAD.

**The composition — how `:version` drives Mantra.** Reuse the same subprocess path `doRun` already uses — `std.process.run(allocator, io, .{ .argv = argv })` — to invoke the `mantra` binary. On `:version`:

1. Flush the transcript to disk, so `mantra` reads a complete file.
2. If `.mantra/` is absent, run `mantra init`.
3. Run `mantra add .mantra/session.log`.
4. Print the result (HEAD advance) back to the prompt.

**Resolving the `mantra` binary (a ruling — see the close).** Recommended default: read an optional `RISHI_MANTRA` environment variable for the binary path; when unset, use `"mantra"` resolved on `PATH`. This keeps the loop simple and portable, and the witness controls the path it needs. Implement this default unless Kaeden rules otherwise.

**Witness — `tools/slc1_version_step2.rish` + `tools/fixtures/slc1_version_step2.input`.** Follow the Step 1 precedent exactly: a `.rish` witness wrapping an `sh -c`. The fixture types a line or two, then `:version`, then `:quit`. The shell sets up a clean temp directory as cwd, puts `rishi/bin` and `mantra/bin` on `PATH` (or sets `RISHI_MANTRA`), runs the repl against the fixture, then verifies `.mantra/HEAD` is non-empty and `.mantra/blobs/` holds at least one blob, and echoes a clear `GREEN` line. The Rish witness asserts the shell exited zero and its output contains that line. **[metal-gated to run — needs the built `rishi` and `mantra`]**

**Typecheck the `rishi/src/main.rye` changes against pristine std.** **[sandbox-verifiable]**

---

## Phase 3 — SLC-1 Step 3: Recall

Bring a prior line back. In-session recall is the SLC-1 bar; reading blobs back is horizon.

- `:recall <n>` — re-run session-ring entry *n* through the evaluator, exactly as if typed. Bounds-check *n* against the ring count and report a clear, named message when it is out of range. (Editing a recalled line in place wants a line editor the terminal loop does not yet carry; immediate re-run is the complete, lovable behavior at this scope. Note the editing path as horizon.)
- `!<n>` — optional shorthand for `:recall <n>`, only once the meta-command table feels stable. Skip it if it adds weight.

**Witness — `tools/slc1_recall_step3.rish` + fixture.** Bind a value, then `:recall` the line that uses it, and assert the prior line's effect returns. **[metal-gated to run]**

When Steps 2 and 3 run green on metal, the four verbs close: type, run, version, recall. That is SLC-1 whole.

---

## Phase 4 — The Width Seam Made Honest (a ruling), then Phase 1b for `mantra/*`

**The finding, stated plainly.** `context/TAME_STYLE.md` is explicit that `usize` is correct at the inherited-std seam: assert the bound, then `@intCast`. `tally/seed.rye` is the exemplar — its `bufLenU32` asserts `buf.len <= maxInt(u32)` and casts, and its `alloc` widens to `usize` only at the slice index. Yet `tools/width-check.rish` substring-greps `usize`, so it cannot tell a sanctioned seam cast from an authored count, and it flags Tally's own exemplar. Under that lint, Phase 1b on `mantra/*` is **uncompletable**: the LCS table is a `[]u32` indexed by `table[i * (n + 1) + j]`, and a Zig slice index is `usize` — the seam cannot vanish.

**Propose first, and pause for Kaeden's word.** Refine `tools/width-check.rish` so it flags `usize` **only** where it is not part of a seam cast — that is, a `usize` occurrence on a line that carries neither `@intCast` nor `@as(usize`. A textual rule is a fair first pass; the lint table already says the AST makes it exact later. Concretely, the scan keeps a violation only when the line holds `usize` and holds neither seam marker. This brings the lint into agreement with the doctrine it is meant to enforce, and it turns Tally and Caravan green for the right reason. **Do not migrate anything until Kaeden rules on this semantics** — chasing a literal zero under the substring lint would fight the seam TAME asks for.

**Then, once the lint is ruled, migrate `mantra/*` authored counts to fixed width**, mirroring Tally:

- `mantra/src/main.rye`
  - `cmdAddAll`: `var added: usize = 0;` → `u32`, with `assert(brix.files.len <= std.math.maxInt(u32));` before the loop.
  - `cmdLog`: `const max_log_depth: usize = 1000;` → `const max_log_depth: u32 = 1000;`, and `var depth: usize = 0;` → `u32`.
  - `computeDiff`: introduce `m` and `n` as `u32` via an asserted seam (`assert(old_lines.len <= maxInt(u32)); const m: u32 = @intCast(old_lines.len);` and likewise `n`); keep the backtrack counters `i`, `j` as `u32`; widen to `usize` **only** at the `table[...]` index and slice access, the same shape Tally uses.
- `mantra/src/diff.rye` — the extracted LCS module carries the same `var i/j: usize` backtrack; give it the same treatment, so the module and the seed agree.
- `mantra/src/store.rye` and `mantra/src/weave.rye` already carry no `usize`.

**Extend `tools/width-check.rish`'s file list** to include `mantra/src/store.rye`, `mantra/src/weave.rye`, and `mantra/src/diff.rye` once they read clean under the refined lint, so the whole `mantra/*` module is covered. **[sandbox-verifiable]**

---

## Phase 5 — First TAME assert lint, and Mantra brought into compliance

The Rye supplement asks for the unqualified `assert`, imported once per file. No seed does this yet; every seed reaches for `std.debug.assert(...)`. Grow the lint, then bring the on-path module into line.

**Create `tools/tame-check.rish`** — informational this pass, not yet a merge gate — with the three cheapest rules from the supplement, each reported clearly:

- **Unqualified assert** — flag `std.debug.assert(` and `debug.assert(` in authored `.rye`; the single import line `const assert = std.debug.assert;` is the one allowed mention.
- **No `Self = @This()`** — flag the literal; the alias takes the real type name. (The tree is already clean here; the rule guards the future.)
- **No tabs, no trailing whitespace.** (Also already clean; the rule holds the line.)

**Bring Mantra into compliance** — `mantra/src/main.rye`, `store.rye`, `weave.rye`, `diff.rye`: add `const assert = std.debug.assert;` once per file and call `assert(...)` bare throughout. Mantra is on the SLC-1 path, so it earns this first.

**Offer, gated, the same one-line-import pass on Tally (2 files) and Caravan (4 files)** — they are the named seeds and the change is mechanical and safe. Propose each; let Kaeden choose whether to ratchet them this pass or leave them for the next file-touch. Ratchet from the bottom up; never sweep the whole tree at once.

**Do not touch Aurora here** — see Phase 7.

**Verify** by running `tools/tame-check.rish` and showing the before-and-after counts for the files brought into compliance. **[sandbox-verifiable]**

---

## Phase 6 — Brix descriptor honesty

`.brix` is the course Mantra reads; a descriptor pointing at dead files is not Complete. Mend it.

- Replace the two dead living-doc bricks with their current homes:
  - `work-in-progress/995_open_threads.md` → `work-in-progress/ROADMAP.md`
  - `work-in-progress/996_roadmap.md` → `work-in-progress/TASKS.md`
  (Keep the open-threads file out unless Kaeden wants it tracked; the two living docs are the honest pair.)
- Bump `version` to `20260629.004912` (the pass stamp; Kaeden ruled `20260629-032012` was placeholder only).
- Leave every source brick as it stands — `rye`, `rishi`, `tally` ×2, `caravan` ×4, `mantra`, `tools/parity.rish` all resolve.

**Verify** with `mantra brix` once the binary is built — it should list the project and the live bricks with no missing file. **[metal-gated to run; the edit itself is sandbox-verifiable]**

---

## Phase 7 — Aurora: name the invariants (the guardrail)

Aurora is freestanding. It cannot import `std.debug.assert`, it carries its own bare-metal `assert`, and its widths face hardware. **Do not convert its assert. Do not touch its `usize` or its widths this pass. Do not add it to the assert lint's compliance set.** A careless sweep here breaks the boot.

The honest TAME touch for Aurora is **say-why**. Its crypto paths lean on `catch unreachable` — thirteen sites in `aurora/src/posted.rye`, nine in `aurora/src/sealed.rye` — where deterministic key generation from fixed seeds genuinely cannot fail. Add a short rationale **per function or per block** (not per line — keep it Radiant, not noisy) naming the invariant that makes the `unreachable` safe: fixed-seed determinism, a length the format already guarantees, a tag verified a line above. Where a site could fail on real input rather than fixed seeds, say that plainly instead, so the reader meets an honest seam rather than a silent one.

Optionally note — in a comment, with no change — that the duplicated bare-metal `assert` helper is a candidate to graduate into one shared Aurora module once the freestanding seeds compose. Leave the change for that day.

**Verify** by typechecking the touched Aurora seeds against the freestanding target the seed headers document. **[sandbox-verifiable]**

---

## The Gates

- **`tools/parity.rish`** — 116 witnesses + SLC-1 repl; green on metal (`2026-06-28`). Step 2 and Step 3 witnesses register here when they land. **[metal-gated]**
- **`tools/parity-selftest.rish`** — the pristine-std symlink guard. **[sandbox-verifiable where the toolchain allows]**
- **`tools/width-check.rish`** — refined per Phase 4; green on `mantra/*` after migration. **[sandbox-verifiable]**
- **`tools/tame-check.rish`** — new, informational; show the counts. **[sandbox-verifiable]**

State, at the end of the pass, exactly which gates ran green by running and which await Kaeden's metal.

---

## Commit, Push, and the Session Log

Commit in honest, reviewable units — one logical change per commit, the session log shipping in the same commit whenever it can. A natural grouping: Phase 1 ground; Steps 2–3 together with their witnesses; the width lint and migration together; the assert lint and Mantra compliance; the Brix mend; the Aurora comments. Push over HTTPS to the usual remotes the way the last pass did, with Kaeden bridging from the host.

Write the session log at `session-logs/archive/20260629/20260629-004912_slc1-version-recall-and-tame.md`, coauthored, in Radiant voice: the thinking trace, the observations, the files touched, and — clearly — what ran green by running versus what awaits metal.

---

## Rulings — Settled (`20260629`)

Kaeden ruled on all four before wiring Phases 2–4.

1. **Width-seam refinement (Phase 4) — yes.** Refine `width-check.rish` to flag authored `usize` only; bless lines carrying `@intCast` or `@as(usize` seam casts.
2. **`mantra` binary resolution (Phase 2) — yes.** Optional `RISHI_MANTRA` env override; default `"mantra"` on `PATH`.
3. **Transcript scope (Phase 2) — yes.** v1 records prompt, input line, and caught evaluation errors; stdout capture is horizon.
4. **`.brix` version stamp (Phase 6) — `20260629.004912`** (the pass stamp; not the placeholder `032012` suffix).

---

*May the ground compile clean, and the first ring close its circle — type, run, version, recall. May the lint come to bless the very seam it was made to guard, and may each named seed carry a little more safety than it did this morning. And may Aurora rest untouched at its bare-metal edge, named where it leans, whole where it waits.*
