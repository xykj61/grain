# Rye Cores and the Gratitude Lineage — Battery, Shell, and Witness

*Kaeden asked for a writing that names what we mean by **Rye cores** — the typed `.rye` body and the **Rishi** shell that witnesses it — and compares that pattern honestly to the designs we study in `gratitude/`. This survey maps the homonyms, states what we adopt as concept, and leaves foreign words in the library rather than on our surface.*

**Stamp:** `20260704.211012` · **Last updated:** `20260704.215012`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME · SLC · TWO_ROOMS
**Category:** External research — architectural survey; proposes no module names; seats nothing
**Status:** Proposed — comparisons cite gratitude sources by name; siloed companion at [`../active-designing/20260704-211012_the-rye-core-and-the-shell.md`](../active-designing/20260704-211012_the-rye-core-and-the-shell.md)
**Ground:** [`20260704-002912_gates-arms-and-the-urbit-lineage.md`](20260704-002912_gates-arms-and-the-urbit-lineage.md) · [`20260704-214100_subject-oriented-programming-and-the-rye-core.md`](20260704-214100_subject-oriented-programming-and-the-rye-core.md) · [`20260703-193012_the-bench-as-a-block-and-the-living-build.md`](20260703-193012_the-bench-as-a-block-and-the-living-build.md)

*Written in Rio 3's Radiant voice, for Kaeden and every future sitter.*

---

## Part One — What We Mean by a Rye Core

A **Rye core** is the smallest **typed, testable body** of a lap — usually one `*.rye` file (sometimes a small cluster) that:

1. **States invariants** at public surfaces (`assert`, explicit widths, named bounds).
2. **Proves claims** in `test` blocks and a `selftest` subcommand runnable without the network.
3. **Emits a binary** when the claim needs host I/O, crypto, or filesystem work the shell should not reimplement.
4. **Speaks our vocabulary** — Tilak at seams, gardens not arenas, shape-cast at trust boundaries — never gratitude identifiers in source.

The **Rishi shell** (a `*.rish` witness) sits **outside** the core:

- **Orchestrates** — build the binary, run `selftest`, run `fold`, call `parity` neighbors.
- **Asserts GREEN** — `assert`, `run`, `say`; stops on red with a readable reason.
- **Stays thin** — no business logic that belongs in the core; file moves, link rewrites, and crypto walks live in Rye.

The **pattern in one breath:** *the core proves; the shell witnesses; parity wires the witness when the lap graduates.*

Recent metal wears it plainly:

| Lap | Rye core | Rishi shell | Claim |
|-----|----------|-------------|-------|
| Crossing manifest | `work-in-progress/…_crossing_manifest_seed.rye` | `tools/crossing_manifest_seed.rish` | Three-field line parses; damaged line refused whole |
| SLC-L1 receipt | `linengrow/receipt.rye` | `tools/slcl1_receipt.rish` | Sign, append, fold, verify |
| Session archive | `tools/session_logs_archive.rye` | `session_logs_archive_preview.rish` · `session_logs_archive.rish` · `session_logs_archive_witness.rish` | `preview` counts; `fold` mutates; README links rewrite; idempotent; parity hygiene |

This is our **Seed Law** grown one file deeper — the seed proves one claim; the witness is the gate that reports green on metal. Urbit's `%core` noun lives in gratitude; our shape is struct, test, and shell.

---

## Part Two — Urbit and Hoon: Core, Gate, Arm, Vane

**Studied in:** `gratitude/urbit/` (MIT) · Hoon School · Arvo vanes · Clay marks.

| Urbit shape | What it is there | What we keep | What we refuse |
|-------------|------------------|--------------|----------------|
| **core** `[battery payload]` | Code map + data context in one noun | **Concept** — struct + methods in Zig; duties split across files | The word *core* as a Rye keyword |
| **arm** `++foo` | Named method in a core's battery | **Concept** — `pub fn` on a struct; **Tilak triad** absorb/express/tend | The word *arm* in API docs |
| **gate** | One-arm core with sample — callable closure | **Concept** — `fn` + explicit args | The word *gate* for functions (we keep *gate* for checkpoints and witnesses) |
| **door** | Parameterized core / mark module | **Concept** — comptime parameters; **Tilak** definitions as data | Urbit *door* as syntax |
| **vane** | Kernel module with `+poke` / `+peek` | **Concept** — module with bounded surface; Caravan capabilities | Nine-vane kernel shape |
| **mark** + grab/grow/grad | Type door with conversions and revision algebra | **Concept → Tilak** seated; triad renamed | `++grab` in Rye source |

**Poke vs peek** is the lesson we import as **discipline**, not as arms: **mutation** (`+poke`) and **read-only scry** (`+peek`) must stay separable — our fold claims and boot claims stay in different witnesses (zip-42 counsel: replay-on-host before boot-shaped replay).

**Ford dissolved into Clay** — the build system became a **projection over the versioned store**. Our mirror: **Brix declared inputs + Weave/Mantra content keys**; the builder is a fold, not a second filesystem (see bench essay `193012`).

Full homonym map: [`20260704-002912_gates-arms-and-the-urbit-lineage.md`](20260704-002912_gates-arms-and-the-urbit-lineage.md).

---

## Part Three — TigerBeetle and Tiger Style: Control Plane, Data Plane, In-Place

**Studied in:** `gratitude/TIGER_STYLE.md` (Apache-2.0) · TigerBeetle batching habits (clean room).

| Tiger habit | Meaning there | Our Rye-core reading |
|-------------|---------------|----------------------|
| **Control plane / data plane** | Batch header signed once; payloads prove by hash | Comlink resin-batch counsel (I1): signature over header ‖ manifest; resins prove by digest |
| **In-place initialization** | Structs initialized through out-pointers; viral discipline | Rye structs at seams sized explicitly; gardens bounded before read |
| **Safety → performance → DX** | Irrevocable order | Witness gates before ergonomics; `selftest` before shell sugar |
| **Deterministic simulator** | Four years to production via simulated metal | Puddle microVM as happy-zone boot replay; parity suite as hosted simulator |
| **Zero technical debt** | Do it right once | Red-then-green per lap; no invented parity counts |

The **batch** metaphor is kin to our **bench as block** — scarce resource amortized (attention, fsync, signature verification) — not kin to a Hoon core.

---

## Part Four — Zig and the Thin Frontend

**Studied in:** `vendor/zig-toolchain` · Andrew Kelley's grain (MIT).

Rye is a **thin frontend** on pinned Zig 0.16: the **core** is Zig semantics strengthened — assertions, width law, `std.process.Init` with `io` + `garden`. The **shell** is Rishi when the lap is orchestration-heavy; otherwise `main` in the `.rye` file suffices.

| Zig offers | Rye core uses | Rishi adds |
|------------|---------------|------------|
| `struct` + `pub fn` | Battery without Urbit's noun | — |
| `test` blocks | Unit proofs beside logic | Witness runs `selftest` on metal |
| `comptime` | Doors as types, not runtime nouns | — |
| Explicit allocators | `init.garden` / bounded regions | — |
| `std.process.run` | Host tools (`git mv`, `date`) at seams | `run` builtin wraps the same boundary |

We **do not** embed a second language inside Rye for orchestration — that is Rishi's room — and we **do not** ask Zig's comptime to be Ford; Brix + content addresses carry the build graph.

---

## Part Five — Supervision and Init: s6, Nix, systemd

**Studied in:** skarnet s6 + skalibs (ISC, via SixOS gratitude) · Nix (LGPL, ideas only) · systemd unit model (GPL, concepts only).

| System | Pattern | Concept we take | Where it lives here |
|--------|---------|-----------------|---------------------|
| **s6** | Small scripts, supervision tree, no shell megaproject | **One process, one job, bounded restart** | Caravan seeds → chain → capabilities |
| **s6-rc** | Declared service graph | **Declared graph, not discovered** | Brix splitLines law |
| **Nix** | Pure derivation, content-addressed store | **Content-keyed outputs, early cutoff** | Weave resins; counsel lap 2 cache |
| **systemd** | Unit files + dependency tree | **Avoid** — too much implicit state | Rishi witnesses replace ad-hoc shell units for gates |

**Rishi is not bash:** it is a **typed shell** with `assert`, bounded `list-dir`, and explicit `run` — closer to s6's discipline than to systemd's surface area, yet **hosted** like the gate trio rather than PID 1.

---

## Part Six — Build Systems and Live Reload

**Studied in:** Ford/Clay (Urbit) · Make · Ninja · Bazel/Buck2 · Nix · Salsa · Zig `--watch` (see `193012` table).

The convergence we keep: **minimality** (no work twice) and **early cutoff** (byte-identical output stops the wave). Rye cores participate as **actions** in that story:

- **Inputs** declared in Brix, not inferred by timestamp.
- **Outputs** content-keyed at the working tier (SHA3-256 law).
- **Witness** proves no-op rebuilds when inputs are unchanged (lap two counsel).

The **inner loop** stays Zig's `--watch` on the toolchain side; Rishi watch is lap one, not a new Ford.

---

## Part Seven — Shells, Tests, and Anti-Patterns

| Pattern elsewhere | Risk | Our rule |
|-------------------|------|----------|
| **Python script + pytest** | Logic drifts into untyped shell | Logic in `.rye`; witness in `.rish` |
| **Bash fixture scripts** | Interpolation bugs (archive fold v1) | Extract to `.rye`; shell only at `run` seams |
| **Monolithic `main`** | Untestable orchestration | `selftest` subcommand + witness |
| **Urbit vase everywhere** | Dynamic typing at every seam | Shape-cast at boundaries; typed core |

**Sameness is the macro** applies: one lap shape — **core + witness + parity row** — so learning one lap teaches the next ([`20260703-182612_sameness-is-the-macro.md`](20260703-182612_sameness-is-the-macro.md)).

---

## Part Eight — Comparison at a Glance

```
Gratitude              Their "core"              Our Rye core + shell
──────────────────────────────────────────────────────────────────────────
Urbit/Hoon             [battery payload] noun    .rye struct + fns; .rish witness
TigerBeetle            batch engine              .rye crypto/fold; signed header separate
Zig                    language runtime          .rye (thin Zig) + vendor std
s6                     supervision scripts       Caravan + Rishi gates
Nix                    pure derivations          Brix + Weave keys (not libnix)
systemd                unit orchestration        tools/*_witness.rish (avoid)
pytest                 test runner               test blocks + selftest + witness
Make/Ninja             rebuild graph             Brix declares; Zig builds; witness pins
```

---

## Part Nine — What Crosses into the Silo

For [`../active-designing/20260704-211012_the-rye-core-and-the-shell.md`](../active-designing/20260704-211012_the-rye-core-and-the-shell.md) — concepts only, gratitude names stripped:

1. **Two-layer lap** — core proves, shell witnesses, parity wires.
2. **Selftest is sacred** — runnable without the witness; witness re-runs it on metal.
3. **Idempotency** — second run moves zero (archive fold law; batch sync law).
4. **Control/data split** — signed manifest vs payload bytes at Comlink seam.
5. **Read vs mutate discipline** — mutation witnesses and read-only witnesses stay in separate rooms (`preview` / `fold` on archive lap).
6. **Seed Law** — core is the running seed; shell is the gate trio for that seed.

---

## Gratitude

| Source | License | What we studied |
|--------|---------|-----------------|
| **Urbit** | MIT | Cores, gates, arms, marks, vanes, Ford→Clay |
| **TigerBeetle / Tiger Style** | Apache-2.0 | Control/data plane, in-place init, safety order |
| **Zig** | MIT | Struct grain, comptime, explicit IO |
| **s6 / skalibs** (Laurent Bercot) | ISC | Supervision discipline |
| **Nix** (Eelco Dolstra) | LGPL — ideas only | Content-addressed builds |
| **Build Systems à la Carte** | Research | Minimality, early cutoff |

Concepts entered through the clean room; implementations live in `rye/`, `rishi/`, `tools/`.

---

*May every lap carry a core that proves and a shell that witnesses. May gratitude teach through comparison and leave its words in the library. And may parity pin only what the bench reports.*
