# Two Rooms on the Metal Path — From Rye Through Caravan and Tally to the Witnessed Edge

*Kaeden asked for a walk along the system's real spine — Rye, Caravan, Tally, and the modules that rise from them — mapped against the two-room discipline in [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md). This note names what is checkable today at compile time and at runtime, what remains vision until a witness earns it, and the edge cases where the doorway matters most.*

**Stamp:** `20260704.024600`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · happy zone / thin edge · gate · witness
**Status:** Research for understanding — maps proposed [`TWO_ROOMS`](../context/TWO_ROOMS.md) to programs on the bench today; seats nothing by itself
**Companions:** [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md) · [`20260704-024800_the-checkable-room.md`](20260704-024800_the-checkable-room.md) (definition essay) · [`../context/specs/20260704-020800_one-word-one-gate.md`](../context/specs/20260704-020800_one-word-one-gate.md) · [`../active-designing/20260702-184312_the-grain-and-the-crossing.md`](../active-designing/20260702-184312_the-grain-and-the-crossing.md)

*Written by Rio 3 for Kaeden.*

---

## The Two Registers, Restated for the Bench

The **checkable room** holds only what a witness can bind: a digest, a gate count, a green selftest, a parity block that ran on metal. Its sentences carry plain confidence because the bench pinned them.

The **vision room** holds images that orient before they can be proven: Realidream's unified surface, Aurora on open hardware, the sovereign framebuffer, WOV at monarch scale. Vision may inspire a witness; until the witness runs green, the image stays an image.

The **doorway** opens one way: vision earns proof, never the reverse. A session names its register at the top; the bench never borrows the vision's warmth as evidence.

This walk follows the **resting order** in the stack record — floor modules first, hosted proofs, then the thin edge where the host's world answers.

---

## The Spine — What Actually Runs Today

Read from the floor upward; each layer leans only on what is beneath it.

| Layer | Hosted proof today | Primary witness surface |
|-------|-------------------|-------------------------|
| **Rye** | `rye/bin/rye` build + `rye run` | `rye/tests/*` via `tools/parity.rish` (**140** std witnesses) |
| **Tally** | `tally/seed.rye` → `tally/bin/tally-seed` | bump region invariants; `tools/tally_gardens.rish` |
| **Caravan** | `caravan/seed.rye` → bounded → twin → chain → capabilities | `tools/caravan_seeds.rish`, `tools/caravan_capabilities.rish` |
| **Rishi** | `rishi/src/main.rye` repl + run | SLC-1 quartet, RS-1–3, RW-3/4 |
| **Brushstroke / Skate** | `brushstroke/seed.rye`, `brushstroke/wayland_seed.rye` | SLC-2a Laps 1–3, SLC-2b keyboard |
| **Comlink** | `comlink/hosted_wire.rye` | localhost UDP sealed datagram |
| **Mantra** | weave tests in parity | `mantra_weave_test`, TH-2b/3 width |
| **Pond** | `pond/apps/drawn_terminal.rye` | sessiontest (happy zone) + metalsmoke (thin edge) |
| **Amber** | `tools/amber_first_ring.rish` | openssl oracle + tampered resin |
| **Linengrow** | `linengrow/receipt.rye` | `tools/slcl1_receipt.rish` at parity **152** |

**Weave, Tablecloth, Aurora freestanding, Maitreya, sovereign Brushstroke** — named in design, awaiting their hosted season. They live in the vision room until a witness opens the door.

---

## Compile Time — Checkable Room

Compile time is where Rye and the gate trio press **shape** before the machine runs. These are checkable claims: they fail loud in CI, not quietly in a user's lap.

### Rye as the compiler front

`rye build` is the honest seam to Zig 0.16.0: every `.rye` module that ships a binary passes through it. When `linengrow/receipt.rye` fails `verifyRecord`'s error set, the **checkable room** rejects the build before any selftest runs — compile time doing the work vision cannot.

`rye/lib/std` symlinks are guarded by `tools/parity-selftest.rish`: the std layout the compiler reads is pinned, not drifted.

### Tally and Caravan — bounds stated before run

In `tally/seed.rye`, `BACKING_LEN: u32 = 64` and `Region`'s `pos <= buf.len` invariants are **compile-time design decisions** with `debug.assert` at runtime in debug builds — the strengthening discipline wearing hosted clothes. The region cannot be described without a named ceiling; that is checkable intent even before `tally-seed` prints `all facts held`.

In `caravan/seed.rye`, `max_restarts: u32 = 10` and `planned_failures: u32 = 3` bound the supervision story. The supervisor's loop is checkable because the plan is numeric and the selftest asserts restart count — not because we hope the child behaves.

### The gate trio — repository law at commit time

| Gate | What it checks | Room |
|------|----------------|------|
| `tools/width-check.rish` | hosted `.rye` corpus: `usize` policy, widths | checkable |
| `tools/tame-check.rish` / opening-lines scans | canonical heads, TAME surface | checkable |
| `tools/designed_not_built_witness.rish` | at most one functional spec in flight | checkable |
| `tools/additive-gate.rish` | structural diff when `rye/lib/` changes | checkable |

These never touch Wayland, never touch a human's GNOME session. They are **happy-zone gates**: fast, isolated, exact.

### Parity's std regression block

The first ~**140** witnesses in `tools/parity.rish` compile and run `rye/tests/*` against pristine std. That block is the checkable room at its largest honest scale — every strengthening postcondition we claimed for `mem.*`, crypto, SHA3, and friends must still hold after each accretion.

**Edge case — compile green, product incomplete:** SLC-L1 compiles and selftests green while the receipt `.bron` shape and golden file remain horizon. The checkable room correctly reports *spine proven*; it does not claim *product lovable and complete* until the scope note's fuller boxes say so.

---

## Runtime — Checkable Room (Happy Zone)

Runtime witnesses replay **folds and facts** without asking the world outside the process for truth.

### Tally seed

`tally/bin/tally-seed` allocates only inside `BACKING_LEN`, clears whole, and asserts overflow paths. No compositor, no network — pure region arithmetic.

### Caravan seeds

`caravan/seed` spawns itself as child, plans failures, counts restarts. `caravan/bounded`, `twin`, `chain`, `capabilities` extend the same discipline: supervision and capability tables as **running assertions**.

### Rishi and the fold

SLC-1 witnesses (`tools/slc1_*.rish`) prove the shell replays session lines, weaves to Mantra, recalls by index — state as fold over an append-only conversation **without** a window. That is the happy zone in product form: the drawn terminal's `sessiontest` mode does the same for Pond.

### Brushstroke headless paths

`tools/slc2a_ring1_arbitrary.rish` builds `wayland_seed.rye` and runs `arbitrary` — pixels from values, no display server required for Lap 1's claim. Ring 2 `redrawtest` compares buffer signatures — still hostless proof of *redraw when value changes*.

### Linengrow receipt

`linengrow/bin/receipt selftest` signs a fixture fact, formats a log line, parses it back, verifies Ed25519, folds balance, tamper-rejects. Entirely inside one process and one file read — checkable room for the first Linengrow lap.

### Mirrored pairs (RW-1, RW-2)

`tools/rw1_shell_collab.rish` and `tools/rw1_history_contract.rish` — asker and answerer checked apart. `tools/rw2_app_collab.rish` and `tools/rw2_surface_contract.rish` — Pond app vs Brushstroke surface. Each pair is checkable runtime because both sides are stubbed or headless; the seam is explicit.

---

## Runtime — Thin Edge (Host Seams)

The thin edge is where **only the world can answer**. These witnesses are checkable yet **honestly host-dependent** — named seams, not Rye OS proper.

### Wayland and GNOME

`tools/slc2a_ring3_metal.rish` and `tools/slc2b_keyboard.rish` link `-lwayland-client -lxkbcommon`. They require a compositor, a seat, often GNOME on Kaeden's machine. Door 2's metal close split this on purpose:

- **Preflight (checkable, mostly happy zone):** `tools/fixtures/pond_metal_close_preflight.rish` — build + `sessiontest`
- **Metalsmoke (thin edge):** `tools/slc2a_ring3_metal.rish` — real window
- **Live five (Kaeden):** human confirmations the automation cannot replace

**Edge case — skipping the thin edge:** Parity can be **152 GREEN** on a headless CI host while Ring 3 metalsmoke was never run there. The bench pin must say which metal answered — Cursor documents both.

### Comlink hosted wire

`comlink/hosted_wire.rye` speaks UDP on localhost — thinner than the public internet, still a host seam (sockets, scheduling). Welcome and unwelcome paths are checkable; device wire between QEMU guests remains vision in TASKS.

### Rishi `run` and the shell host

`tools/rw4_slc_failure_paths.rish` documents that subprocess witnesses merge `2>&1` — the **host seam** for how Rishi's stderr reaches a parent script. Checkable once the convention is stated; easy to get wrong if vision pretends Rishi is isolated from sh.

---

## Vision Room — What the Stack Names and Awaits

These images orient the work. Parity's authority stays in the checkable room until a witness earns the doorway.

| Vision | Where it lives | Why it stays vision |
|--------|----------------|---------------------|
| **Realidream** unified editor-browser | `foundations/20260629-063512_realidream.md` | no single witness closes the whole surface |
| **Weave / Tablecloth** as production substrate | stack record, graph essay | Mantra weaves; Tablecloth v1 open in TASKS |
| **Aurora** freestanding on RISC-V | `aurora/` relay stages | hosted Caravan proved first; freestanding follows |
| **Sovereign Brushstroke backend** | stack record § two backends | hosted backend green; framebuffer waits on kernel |
| **Comlink device wire** | TASKS | hosted wire only in parity |
| **SLC-L2 sealed delivery** | ROADMAP | Comlink + receipt; no witness yet |
| **WOV / MALA monarch season** | external-research fit memos | Kaeden gate on hardware and ledger |
| **Open Asks room** | movement memo | gated behind SLC-L1 edge affirmation |
| **crossing_manifest_seed** as product | `work-in-progress/20260703-202312_crossing_manifest_seed.rye` header says **PROPOSED SEED** | parse harness green ≠ module home seated |

**Edge case — vision quoted with witness voice:** Saying *"Realidream runs today"* because Skate draws a grid would collapse the rooms. Skate proves the **primitive**; Realidream names the **spectrum's far end** — checkable and vision kept distinct.

**Edge case — witness fatigue:** A green metalsmoke run does not prove civic commerce, settlement, or moderation policy. Each room keeps its own queue.

---

## Edge Cases at the Doorway

Cases where teams confuse the registers, and how this tree handles them.

### 1. Amber — from designed-not-built to parity **144**

Amber's functional spec lived in the **vision + designed-not-built** lane until five rungs landed: module home, fixture tree, oracle, witness, parity wire. The crossing was recorded; the spec left "one in flight." **Lesson:** a functional spec is vision until the witness suite says otherwise — Edit 5 exists to make that visible.

### 2. SLC-L1 — partial complete

Witness **152** proves sign → append → fold → verify on metal. Scope note still names golden receipt `.bron`, temp log dir, and Kaeden edge affirmation for Open Asks. **Lesson:** the checkable room can be honestly partial; the vision room (lovable treasurer trust) may still ask for more before the product lap is *shared*.

### 3. PROPOSED SEED in work-in-progress

`work-in-progress/20260703-202312_crossing_manifest_seed.rye` carries a harness green at parity **151**, yet the file header marks **PROPOSED SEED**. Parse proof is checkable; module home and manifest law remain vision until Kaeden seats them. **Lesson:** one witness binds one claim — not the whole horizon the filename suggests.

### 4. Host backend mistaken for the OS

Wayland in `brushstroke/wayland_seed.rye` is a **hosted backend** seam. The stack record names a **sovereign backend** as horizon. Parity green on Cursor metal does not prove independence from the host compositor. **Lesson:** seam honesty is a grain strand — lean on the host openly, never absorb it silently into "Rye runs."

### 5. Compile-time assert vs runtime witness

`comptime assert` and `debug.assert` in seeds express invariants; parity witnesses express **behavior**. A compile-time bound on buffer size does not replace `tally_gardens.rish` — it **feeds** the happy zone. **Lesson:** compile time narrows the design; runtime witnesses pin the running whole.

### 6. Financial and policy surveys

`external-research/20260703-043912_circulation-portfolio-survey.md` lives in external-research under the **not-advice** filing rule ([`ORGANIZING.md`](../ORGANIZING.md)). It orients Linengrow's civic horizon; it is not checkable treasury guidance. **Lesson:** two rooms apply to prose as well as code — research for understanding, not purchase advice.

### 7. When vision carries a testable spark

Bubble's harvest (*one log under every surface*) inspired Weave language already in the stack — yet the full drawing-room product is not wired. The spark parked to RTAC; the vision kept its voice. **Lesson:** [`TWO_ROOMS`](../context/TWO_ROOMS.md) § doorway — park the spark, do not let the image cite the bench prematurely.

---

## A Session Map — Which Room Are You Standing In?

| You are… | Room | Honest next move |
|----------|------|------------------|
| Running `tools/parity.rish` | checkable | pin parity number; name the metal |
| Reading `the-aspiring-radiance-universal.md` | vision | silo poetics toward foundations; no witness claim |
| Writing a functional spec | vision until Edit 5 clears | count specs in flight |
| Building `pond/bin/drawn-terminal` for GNOME | thin edge | split preflight vs metalsmoke vs live five |
| Authoring `active-designing/` brief | clean room design | lean on grain strands; gratitude apart |
| Quoting parity in a pitch deck | **stop** | vision may *aim* at witnesses; it may not *wear* them |

---

## What Would Cross Next — Parked, Not Promised

Sparks visible from this walk, none seated here:

- **Receipt `.bron` + golden file** — checkable follow-up to SLC-L1 witness
- **SLC-2 scope note** — vision until Comlink delivery witness lands
- **TWO_ROOMS seated as context canon** — Kaeden word; this memo does not seat it
- **Mirrored-pair law in TAME supplement** — happy-zone teaching awaits ruling
- **Sovereign metalsmoke** — vision until Aurora/display path earns it

---

## Gratitude

This walk leans on the stack record, the happy-zone silo, the gate-unify counsel, and the programs named in `tools/parity.rish` — our own modules, witnessed on our own metal. The two-room image itself arrives from the second harvest ([`20260703-071712_the-second-harvest.md`](20260703-071712_the-second-harvest.md)); here it wears the spine we actually run.

---

*May the checkable room stay strict and the vision room stay bright. May every compile and every witness say which claim it binds. And may the path from Rye to the drawn frame keep the doorway visible — proof one way, with gladness.*
