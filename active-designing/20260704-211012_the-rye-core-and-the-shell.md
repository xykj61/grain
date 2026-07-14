# The Rye Core and the Shell

**Language:** EN
**Stamp:** `20260704.211012 UDT` · **Last updated:** `20260704.215012` (Radiant pass — explicit subject, horizon, preview/fold)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME · SLC · Seed Law
**Register:** active-designing — siloed; names only our own modules
**Lineage:** outside comparisons live in [`../external-research/20260704-211012_rye-cores-and-the-gratitude-lineage.md`](../external-research/20260704-211012_rye-cores-and-the-gratitude-lineage.md) · context discipline surveyed in [`../external-research/20260704-214100_subject-oriented-programming-and-the-rye-core.md`](../external-research/20260704-214100_subject-oriented-programming-and-the-rye-core.md)
**Status:** Proposed — pattern affirmed on recent metal; graduation to spec on Kaeden's word

*Written in Rio 3's Radiant voice.*

---

## The Duty

Every lap that touches the host grows through **two cooperating layers** — a typed core and a witnessing shell — rather than one script that mixes proof with orchestration.

The **Rye core** is the typed body: invariants, algorithms, unit tests, and a `selftest` entry point that proves the claim without the gate suite. The **shell** is **Rishi** when the lap must build, orchestrate, or speak GREEN to parity — it runs the core, asserts the result, and keeps algorithmic meaning in the core alone.

One sentence: **the core proves; the shell witnesses.**

This is the Seed Law wearing clothes one file thicker than `seed.rye` alone: the seed established the claim; the core is the seed grown testable; the witness is how the gate trio meets that claim on metal.

## Anatomy

| Layer | Artifact | Must do | Must not |
|-------|----------|---------|----------|
| **Core** | `*.rye` (or small cluster) | `assert` at surfaces; `test` blocks; `selftest`; named bounds; explicit entry context | Hide filesystem/crypto policy in shell strings |
| **Shell** | `*_witness.rish` or lap driver `.rish` | Build bin if needed; run `selftest`; `say` GREEN; wire into `parity.rish` when graduated | Reimplement parsers, folds, or link algebra |
| **Index** | `session-logs/`, `parity.rish`, README rows | Pin counts from metal; accrete never break | Invent parity; inherit counts from counsel tables |

## The explicit subject

Every core carries an **explicit subject** — the full context its logic may assume — rather than scattered globals or argv parsing buried in `main`.

The subject is usually a **struct**: paths, clocks, gardens, and any Tilak-bearing inputs the battery needs. The witness constructs that struct on metal; `selftest` constructs the smallest true struct on fixture sandboxes. If a value is not in the struct or in `init`, it is not in scope — the same discipline as declared Brix inputs at the build seam.

**Fixture discipline.** Sandboxes are not floating mock helpers. They are **payload the core expects** — minimal trees, vectors, and README stubs that `selftest` wires into the entry struct. The witness runs the same formulas against production paths; only the subject values change.

## Horizon

**Horizon** is one-way visibility between layers. The inner layer never imports the outer.

| Layer | May call inward | May never call outward |
|-------|-----------------|------------------------|
| Core | — | Shell, parity, Pond policy |
| Shell | Core (`selftest`, subcommands) | Parity neighbors, other witnesses |
| Parity | Graduated witnesses | Core algorithms directly |
| Pond | Receipt policy at boundary | Core internals |

A core that reaches for parity counts or README rows has **broken horizon** — the review failure is the same as calling a name that is not in scope. Each catalog row below carries a one-line horizon note.

## The Vows

**Separation.** Business logic lives in the core exactly once. The shell may call `run` at OS seams — move bytes, read clock, invoke `git` — yet the **meaning** of a moved file or a verified signature is decided in Rye.

**Selftest first.** A lap is not real until `selftest` passes on a cold binary. The witness is a second run on the bench, not the only run.

**Idempotency.** A second fold, sync, or verify pass changes nothing when the world is already true — the wreck rule at the lap grain.

**Control before data.** Signed headers and manifests are verified once; payloads prove by digest — the Comlink batch law is the same vow at the wire.

**Read vs mutate.** Witnesses that observe stay separate from witnesses that change the tree — `preview`, verify-only, and `fold` are distinct entry points, each with one duty. Replay-on-host stays read-shaped before boot-shaped replay runs.

## The Laps

**Lap zero — seed.** One file, one claim, stdout or exit code (`tally/seed.rye`, `caravan/seed.rye`).

**Lap one — core + witness.** Core gains `test` + `selftest` on an explicit subject; shell builds and asserts GREEN (`crossing_manifest_seed`, `slcl1_receipt`, `session_logs_archive`).

**Lap two — parity wire.** Witness joins `tools/parity.rish`; count verified on Cursor metal before any zip comment claims it — parity is the outermost layer that may claim GREEN for the whole bench.

**Lap three — module home.** Core moves from `work-in-progress/` or `tools/` into its module directory when the second consumer or Kaeden's word opens the gate.

Each lap **widens the subject** the next layer may assume, yet inner layers stay buildable alone — seed without witness, core without parity.

## The Seams

**Rye** compiles the core. **Rishi** runs the shell. **Parity** is the society of shells — each lap keeps its own witness; the suite is batching for attention, not a monolith.

**Mantra** holds history; the core never silently rewrites seated prose. **Weave** holds typed values; the core's outputs are values or bytes named by digest law. **Pond** applies policy at receipt; the core does not know enclosure rules — Pond does.

**Tilak** sits at every seam the core crosses: manifest lines, frame lanes, Bron records. Unknown marks refuse whole — the core returns `error.InvalidFormat`, not partial trust. Tilak is how **type carries scope** at the boundary: bytes are not trusted until shape-cast succeeds.

## Catalog (green or proposed)

| Lap | Core | Shell | Parity | Horizon (one line) |
|-----|------|-------|--------|-------------------|
| Manifest line | `crossing_manifest_seed.rye` | `crossing_manifest_seed.rish` | **151** | Core parses three fields; shell runs seed; parity pins count |
| Verifiable receipt | `linengrow/receipt.rye` | `slcl1_receipt.rish` | **152** | Core signs/verifies; shell orchestrates host OpenPGP seam |
| Session archive fold | `session_logs_archive.rye` | `session_logs_archive_witness.rish` · `session_logs_archive_preview.rish` | parity (hygiene) | Core folds + rewrites links; `preview` reads only, `fold` mutates |
| Amber ring-1 | `amber/` export path | `amber_first_ring.rish` | **144** | Core exports record; Pond enforces enclosure at receipt |
| Comlink batch | counsel I1 (horizon) | `amphora_comlink_resin_batch` (designed) | — | Header verified once; stones prove by digest |

## Growth law for new laps

When a new host-touching stop arrives:

1. Draft the **core** with an explicit entry struct, `test` blocks, and `selftest` on fixture sandboxes — smallest true subject, not production paths.
2. Draft the **shell** that builds, runs `selftest`, and prints GREEN.
3. Split **read** and **mutate** entry points before the lap ships — `preview` or verify-only never shares a subcommand with `fold` or append.
4. Add **integration** under `rishi/tests/` when the lap teaches a reusable pattern.
5. Wire **parity** only after red-then-green on the wiring bench.
6. **Session log** + README row; document horizon in one line; pin what metal reports.

Shell scripts may remain at `run` seams — they do not hold algorithms. When a shell grows logic, **promote to Rye**.

---

*May every core know its subject — explicit, bounded, testable alone. May horizon hold: inward calls only, never outward. And may the next lap recognize its elders — seed, core, witness, parity — and grow in that order.*
