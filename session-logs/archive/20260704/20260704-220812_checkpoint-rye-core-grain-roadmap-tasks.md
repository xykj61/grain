# Checkpoint — Rye core grain, full progress, roadmap, and tasks

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260704.220812 · **Expanded:** 20260704.220912

**Prompt:** Kaeden asked for one self-contained session log that saves entire progress, granular roadmap and tasks, and work in progress — all related to Rye OS grain. Expanded with fuller detail throughout.

**How to use this log:** A future sitter can read this file alone and recover where the tree stood on the evening of 2026-07-04 — metal pins, counsel standing, open gates, the rye-core lap law, and every uncommitted path awaiting commit.

---

## Part One — Rye OS grain: what we are building

### Vision

**Rye OS** is a system that belongs wholly to the one who runs it: one language (Rye), one value model, one kernel (Caravan), one compositor (Brushstroke), one shell (Rishi), one version history (Mantra), one network (Comlink), one database (Tablecloth), one composition language (Brix), one data notation (Bron), one memory model (Tally), one boot (Aurora), one enclosure (Pond). **Linengrow** is the flagship application on the same spine — transparent civic commerce grown from signed facts and pure folds.

Rye today is a **thin, honest frontend** on pinned Zig 0.16.0 — `rye/lib/std` through pristine symlinks; safety lives in authored `.rye` (assertions, width law, the gate trio). The strengthening chronicle **completed** as analysis; it is record, not product.

Full design: [`active-designing/yonder/20260619-225712_the-whole-system.md`](../active-designing/yonder/20260619-225712_the-whole-system.md). Order and why: [`work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md). Granular what-now: [`work-in-progress/TASKS.md`](../work-in-progress/TASKS.md). Strategy checkpoint: [`work-in-progress/ready-to-ask-claude.md`](../work-in-progress/ready-to-ask-claude.md).

### Two tracks, one spine

| Track | Grows | Current lap |
|-------|-------|-------------|
| **Rye OS** | Infrastructure modules — Rishi, Pond, Comlink, Brix, Caravan, Amber, … | SLC-2 landed on metal; Compose horizon next |
| **Linengrow** | Application laps on the same modules | SLC-L1 **done** (parity **152**); SLC-L2 gated behind Open Asks |
| **Ground** | TAME, width, gate trio, parity society | **Complete** in parity; as-you-touch on `mantra/*` |

Correctness by construction in the kernel becomes trust by construction in the platform: the same Mantra log that versions a file records a verifiable receipt; the same Comlink that seals a datagram will deliver a signed transaction identity to identity.

### Five foundations (every lap rests here)

1. **Keypair** — Kumara identity at seams  
2. **Signed event** — facts append-only  
3. **Log** — Mantra holds history  
4. **Projection** — pure fold over the log  
5. **Capability** — Caravan names what may run  

`linengrow/receipt.rye` is the flagship lap that wears all five on the rye-core grain.

---

## Part Two — The lap grain (tonight's architectural seat)

Tonight's arc names the **lap grain** every host-touching stop now wears. This is **Seed Law** one file thicker than `tally/seed.rye` and `caravan/seed.rye`.

### Ladder

```
Lap zero — seed        one file, one claim, stdout or exit code
Lap one  — core        *.rye — explicit subject, test, selftest
         + shell       *.rish — build, run, say GREEN
Lap two  — parity      tools/parity.rish — pin what metal reports
Lap three — module home graduate when second consumer or Kaeden's word
```

**One sentence:** *the core proves; the shell witnesses.*

### Anatomy

| Layer | Artifact | Must do | Must not |
|-------|----------|---------|----------|
| **Core** | `*.rye` | `assert`, `test`, `selftest`, explicit entry struct | Hide crypto/filesystem policy in shell strings |
| **Shell** | `*_witness.rish` or driver `.rish` | Build bin, run `selftest`, wire parity when graduated | Reimplement parsers, folds, link algebra |
| **Index** | session-logs, README rows | Pin counts from metal; accrete never break | Invent parity; inherit counsel counts |

### The explicit subject

Every core carries the **full context** its logic may assume — usually a **struct** with paths, clocks, gardens, Tilak-bearing inputs. The witness constructs that struct on metal; `selftest` constructs the smallest true struct on fixture sandboxes. If a value is not in the struct or in `init`, it is not in scope — same discipline as declared Brix inputs.

**Fixture discipline:** sandboxes are **payload the core expects**, not floating mocks.

### Horizon (one-way visibility)

| Layer | May call inward | May never call outward |
|-------|-----------------|------------------------|
| Core | — | Shell, parity, Pond policy |
| Shell | Core (`selftest`, subcommands) | Parity neighbors, other witnesses |
| Parity | Graduated witnesses | Core algorithms directly |
| Pond | Receipt policy at boundary | Core internals |

### The vows

- **Separation** — business logic in the core exactly once  
- **Selftest first** — lap is not real until cold `selftest` passes  
- **Idempotency** — second pass changes nothing when the world is already true  
- **Control before data** — signed header once; payloads prove by digest  
- **Read vs mutate** — `preview`, verify-only, and `fold` are distinct entry points  

### Growth law for new laps

1. Draft core with explicit struct, tests, `selftest` on fixtures  
2. Draft shell that builds, runs `selftest`, prints GREEN  
3. Split read and mutate entry points before ship  
4. Add `rishi/tests/` integration when the pattern teaches  
5. Wire parity only after red-then-green on wiring bench  
6. Session log + README row; document horizon in one line  

**Law home:** [`active-designing/20260704-211012_the-rye-core-and-the-shell.md`](../active-designing/20260704-211012_the-rye-core-and-the-shell.md) · **Last updated:** `20260704.215012`

### Gratitude comparisons (external-research only)

| Source | Concept we keep | Names we refuse in Rye source |
|--------|-----------------|-------------------------------|
| Urbit/Hoon | core/gate/arm/mark ideas → struct, fn, Tilak | `++grab`, *arm*, Hoon *gate* for functions |
| TigerBeetle | control/data plane, safety order | — |
| Zig | struct grain, comptime, explicit IO | — |
| s6 | one job, bounded restart | bash megaproject |
| Nix | content-keyed builds (ideas only) | libnix link |

**ER pair:** [`211012_rye-cores-and-the-gratitude-lineage.md`](../external-research/20260704-211012_rye-cores-and-the-gratitude-lineage.md) · [`214100_subject-oriented-programming-and-the-rye-core.md`](../external-research/20260704-214100_subject-oriented-programming-and-the-rye-core.md)

Urbit's **subject-oriented programming** sharpened the silo as **explicit subject** and **horizon** — compile-time context explicit, shell calls inward only, sandbox `selftest` then metal witness.

---

## Part Three — Metal snapshot (2026-07-04 evening)

### Git and benches

| Fact | Value |
|------|-------|
| **Last committed tip** | `229d2cd` — *Fold session logs into date archive folders — first run* (500 logs → 12 day folders under `session-logs/archive/`) |
| **Prior tip** | `1000798` — zip 42 unified intake |
| **Zip 42 base** | `43584d8` — zero-copy counsel + ends-first orientation; both benches **152 GREEN** at intake |
| **Zip 43** | **Queued** — full-tree at HEAD after rye-core commit batch |
| **Uncommitted** | Entire rye-core arc (see Part Ten) — awaiting Kaeden commit word |

### Parity pin

**152 GREEN** on Cursor metal — tallied as **116 std** witnesses in `rye/tests/` plus **36 block** witnesses, plus hosted suite blocks in `tools/parity.rish` (SLC-1, SLC-2a, SLC-2b, RW-1, RW-2, Caravan, Comlink, Tally/Brushstroke seeds, width-check, Edit 5, Amber, chrono, crossing seed, SLC-L1 receipt, **session archive hygiene**).

**Gate trio:** `parity.rish` · `parity-selftest.rish` (std symlink guard) · `additive-gate.rish` (when `rye/lib/` changes).

**Designed-not-built:** count=0 — Edit-5 functional spec slot **open**.

**Headless honesty:** parity 152 here is compile + hosted witnesses. Thin-edge metalsmoke is claimed only where a lap's witness says so (Pond Lap 3 closed on GNOME `20260703.032412 UDT`; archive uses fixture sandboxes).

### Parity arithmetic — ladder landed

| Step | Witness / lap | Parity | Stamp |
|------|---------------|--------|-------|
| Hosted width-check + regression | `rye/tests/*` + suite | **140** baseline | 2026-06-28+ |
| RW-3 run record | `run_record_witness.rish` | **141** | 20260702 |
| RW-4 SLC failure paths | `rw4_slc_failure_paths.rish` | **142** | 20260702 |
| Edit 5 designed-not-built | `designed_not_built_witness.rish` | **143** | 20260703.032812 |
| Amber first lap | `amber_first_ring.rish` | **144** | 20260703.051812 |
| SLC-2b keyboard | `slc2b_keyboard.rish` | **145** | 20260703.132112 |
| RW-1 mirrored pair | `rw1_shell_collab` + `rw1_history_contract` | **147** | 20260703.182612 |
| Chrono version sweep | `chrono_version_sweep.rish` | **148** | 20260703.203212 |
| RW-2 mirrored pair | `rw2_app_collab` + `rw2_surface_contract` | **150** | 20260703.235512 |
| Crossing manifest seed | `crossing_manifest_seed.rish` | **151** | 20260704.020800 |
| SLC-L1 verifiable receipt | `slcl1_receipt.rish` | **152** | 20260704.021800 |
| Session archive hygiene | `session_logs_archive_witness.rish` | parity suite (additive) | 20260704.214600 |

---

## Part Four — Module ground (what already runs)

From [`ROADMAP.md`](../work-in-progress/ROADMAP.md) — The Ground table, refreshed mentally for Jul 4:

| Module | Seed / home | Witnesses / status |
|--------|-------------|-------------------|
| **Rye** | Thin frontend; `rye/lib/std` → vendor symlink | 116 std in parity |
| **Rishi** | Shell: repl, file I/O, builtins | Gate trio + SLC-1 four witnesses |
| **Mantra** | Weave + commit chain + log | 9/9 bricks wove |
| **Caravan** | seed → chain → capabilities | Seeds + capabilities in parity |
| **Tally** | seed + gardens | 15 invariants; parity |
| **Brushstroke** | Hosted + Wayland seed | Frame from values; grid in parity |
| **Skate** | Text grid → ARGB8888 | Headless selftest GREEN |
| **Comlink** | Sealed datagram | Full crypto; hosted wire in parity |
| **Pond** | `pond/apps/drawn_terminal.rye` | SLC-2a Laps 1–3 + SLC-2b **145**; Lap 3 metal-closed GNOME |
| **Brix** | `.brix` descriptor, 10 bricks | Read by Mantra |
| **Bron** | Data notation | Used by Brix |
| **Amber** | `amber/` module home | First lap **144** — resin seal witness |
| **Aurora** | Six-stage relay RISC-V | Freestanding |
| **Linengrow** | `linengrow/receipt.rye` | SLC-L1 at **152** |

**SLC status:**

| Lap | What | Status |
|-----|------|--------|
| **SLC-1** | Rishi + Mantra shell — type, run, version, recall | **Done** 2026-06-29 |
| **SLC-2a** | Drawn terminal — Skate viewer, session mirror | Laps 1–3 **done**; metal-closed |
| **SLC-2b** | Keyboard from window — Dexter aspect in Pond | **Done** `145` |
| **SLC-L1** | Verifiable receipt — sign, append, fold, verify | **Done** `152` |
| **SLC-L2** | Sealed delivery over Comlink | Gated — Open Asks after SLC-L1 edge affirmation |

---

## Part Five — Jul 4 chronology (full day)

### Morning — parity 152 and vocabulary

| Stamp | Event |
|-------|-------|
| `020800` | Crossing manifest seed witness — parity **151** |
| `021800` | SLC-L1 receipt — `linengrow/receipt.rye` + witness — parity **152** |
| `023400` | Sameness is the macro — Kaeden affirmed tenth grain strand |
| `030600`–`030800` | Itinerary retires diet; vocabulary quartet; canonical audit |
| `031812` | Zip **41** intake — orientation + eight asks; both benches **152** |

### Afternoon — zip 42 and archive

| Stamp | Event |
|-------|-------|
| `181512`–`194300` | Zip 42 unified packet; zero-copy counsel; ends-first lens; intake @ `43584d8` |
| `202900` | First session-log archive fold — 500 files → 12 day folders (shell v1) |
| `203100` | Archive refactor — `session_logs_archive.rye` + Rishi witnesses + selftest |

### Evening — rye-core arc

| Stamp | Event |
|-------|-------|
| `211012` | ER gratitude survey + silo **The Rye core and the shell** |
| `214100` | ER Urbit subject-oriented programming applied to lap law |
| `214400` | Silo accreted — explicit subject, horizon, read-vs-mutate |
| `214600` | `preview` / `fold` split; archive witness wired in parity — all GREEN |
| `215012` | Radiant pass across arc |
| `220812` | This checkpoint (expanded `220912`) |

---

## Part Six — Archive lap (deep implementation)

### Convention

[`ORGANIZING.md`](../ORGANIZING.md) — **Tidy Days:** working day flat in `session-logs/`; every earlier day under `session-logs/archive/YYYYMMDD/`. README index links rewrite in place on `fold`.

### Tooling stack (wears rye-core grain end-to-end)

| Layer | Path | Duty |
|-------|------|------|
| **Core** | `tools/session_logs_archive.rye` | `dayFromLogFname`, `shouldFoldFlat`, `rewriteReadmeLink`, `foldSessionLogs` |
| **Preview** | `session_logs_archive_preview.rish` | Read-only — `preview` subcommand |
| **Fold** | `session_logs_archive.rish` | Mutate — `fold` subcommand |
| **Witness** | `session_logs_archive_witness.rish` | Builds bin, runs `selftest`, asserts GREEN |
| **Integration** | `rishi/tests/session_logs_archive.rish` | Delegates to witness |
| **Fixtures** | `tools/fixtures/session_logs_archive/` | `alpha` (20260703), `beta` (20260704), README |
| **Sandbox** | `fixtures/.../_sandbox/` | gitignored; selftest workspace |

### Core API

```
rye run tools/session_logs_archive.rye preview [--today YYYYMMDD]
rye run tools/session_logs_archive.rye fold   [--today YYYYMMDD]
rye run tools/session_logs_archive.rye selftest
```

### Selftest proves (on fixtures, not production tree)

1. **Preview** counts `moved=1` yet leaves `20260703-100000_alpha.md` flat  
2. **Fold** moves alpha to `archive/20260703/`; beta stays flat for `today=20260704`  
3. README link rewrites to `](archive/20260703/...)`  
4. Second **fold** returns `moved=0`; README stable (idempotency)  

Production fold already ran at `202900` (500 logs); evening `preview` reports `moved=0` — archive current.

### History note

v1 used bash fixture with rishi `${}` interpolation bug — promoted to `.rye` per silo anti-pattern (logic in untyped shell). Archive fold is now the **reference lap** for rye-core grain in hygiene tooling.

---

## Part Seven — Green catalog (laps wearing the pattern)

| Lap | Core | Shell | Parity | Claim |
|-----|------|-------|--------|-------|
| Crossing manifest | `work-in-progress/…_crossing_manifest_seed.rye` | `crossing_manifest_seed.rish` | **151** | `<mark> <sha3-256-hex> <name>` parses; damaged line refused whole |
| SLC-L1 receipt | `linengrow/receipt.rye` | `slcl1_receipt.rish` | **152** | Ed25519 sign; hex log append; SHA3-256 fold; verify; tamper rejected |
| Session archive | `session_logs_archive.rye` | preview + fold + witness | parity hygiene | Prior days fold; links rewrite; preview/fold split |
| Amber ring-1 | `amber/` export | `amber_first_ring.rish` | **144** | SHA3-256 oracle; welcome + tampered stone fails |
| SLC-2b keyboard | `pond/apps/window_input.rye` | `slc2b_keyboard.rish` | **145** | Wayland seat + xkbcommon; `keyboardtest` witness |
| RW-1 | Rishi ↔ Mantra | `rw1_shell_collab` + `rw1_history_contract` | **147** | Mirrored pair per contract `200109` |
| RW-2 | App ↔ Brushstroke | `rw2_app_collab` + `rw2_surface_contract` | **150** | `setFrame` seam per contract `205630` |
| Caravan caps | seeds | `caravan_capabilities.rish` | suite | Capability table |
| Comlink batch | counsel I1 | designed | — | Signed header ‖ manifest; stones by digest |

**Seed laps (lap zero):** `tally/seed.rye` · `caravan/seed.rye` · `brushstroke/wayland_seed.rye`

---

## Part Eight — Counsel standing (zip 41 + zip 42)

### Zip 41 — eight asks (landed `20260704.031812`)

| Ask | Verdict | Gate |
|-----|---------|------|
| **A1** Bench raise | **Done** — 152 on second metal | — |
| **A2** Gloss spec | Architecture drafted — `context/specs/*_canonical-glosses.md` on Kaeden word | Kaeden |
| **A3** TWO_ROOMS | Seat as written + LEXICON row | Kaeden |
| **A4** SLC-L1 edge | **Closed at lap one**; Open Asks before SLC-L2 | Affirmed |
| **A5** Claim register | Quartet written; witness hooks optional | Kaeden |
| **A6** Amphora lap-two | Four assertions, two fixtures — designed | seed-home gate |
| **A7** Fold canon map | Lap 3 of canonical refinement | counsel |
| **A8** ROADMAP/TASKS/decoder | Refresh on approval | Kaeden |

ER: [`20260704-031812_the-view-from-the-floor.md`](../external-research/20260704-031812_the-view-from-the-floor.md) · [`20260704-031812_eight-asks-one-sitting.md`](../counsel/20260704-031812_eight-asks-one-sitting.md)

### Zip 42 — zero-copy counsel (landed `20260704.185412`)

ER: [`20260704-181612_zero-copy-resins-counsel-answers.md`](../counsel/20260704-181612_zero-copy-resins-counsel-answers.md) · ends-first: [`20260704-185412_ends-first-map-orientation.md`](../external-research/20260704-185412_ends-first-map-orientation.md)

#### Strategic answers A–H (summary)

| ID | Counsel headline |
|----|------------------|
| **A** | Two wire lanes + one cargo grammar; **one frame shape** serves all three |
| **B** | **Decline** seated `resin` Tilak; per-cargo Tilaks stand; hygiene lap (I6) first |
| **C** | Smallest sovereign export: trust bundle + Weave HEAD + Mantra + resin closure + signed manifest |
| **D** | Replay-on-host before boot; Puddle before USB; continuity fact at customs |
| **E** | Adopt checkpoint resin concept; refuse jam/cue wire |
| **F** | Edit-5 slot → **snapshot export spec (I2) first**, Comlink frame (I1) second |
| **G** | CIVIC amphora carries only published commons facts + proofs |
| **H** | Tunnel mouth: have-already civic default; refusal reason classes enum |

#### Implementation architecture I1–I7 (horizon)

| ID | Stop | Notes |
|----|------|-------|
| **I1** | Comlink resin-batch frame | Signed header ‖ manifest; payloads prove by digest |
| **I2** | Snapshot export spec | Edit-5 slot candidate; `snapshot_replay` witness |
| **I3** | (in counsel ER) | Import/refusal paths |
| **I4** | Puddle boot-shaped replay | Happy zone before thin edge |
| **I5** | Checkpoint resin | Concept adopted; metal waits |
| **I6** | **Amber manifest hygiene** | `<mark> <digest> <name>` line law — **mechanical next** |
| **I7** | Continuity fact | Double-boot law; Kaeden gate on exact shape |

#### Eight-week smallest-first order (counsel F)

1. Kaeden words in one sitting (TWO_ROOMS, gloss, seed home, Edit-5, resin-Tilak)  
2. Amber manifest hygiene I6 — mechanical  
3. Snapshot export spec + witness  
4. Amphora lap-two when seed-home opens  
5. Comlink frame + hosted wire witnesses  
6. Open Asks design; SLC-L2 gated  

---

## Part Nine — Context canon seated (Jul 4)

| Item | Path | Status |
|------|------|--------|
| Gate · witness · toll | `context/specs/20260704-020800_one-word-one-gate.md` | **Seated** |
| Itinerary retires diet | `context/specs/20260704-030300_itinerary-retires-diet.md` | **Seated** |
| Sameness (10th grain) | `foundations/20260703-182612_sameness-is-the-macro.md` | **Affirmed** Kaeden `20260704.023400` |
| Claim definition | `external-research/20260704-024900_claim.md` | LEXICON row |
| Vocabulary quartet | `024600` → `024800` → `024900` → `025600` | Programs → registers map |
| Itinerary primer | `external-research/20260704-030600_itinerary-and-the-crossing-manifest.md` | Replaces diet ER |
| Recursion prompt v4 | `expanding-prompts/20260704-030300_cursor-recursion-prompt-v4.md` | STOPS · journey's pause |

### Proposed (await Kaeden)

| Item | Path |
|------|------|
| **TWO_ROOMS** | `context/TWO_ROOMS.md` — register law vs bench law |
| **Canonical gloss** | `context/specs/*_canonical-glosses.md` — not yet drafted |
| **Rye core silo** | `active-designing/20260704-211012_the-rye-core-and-the-shell.md` — graduation to spec |

### Crossing names ratified (`20260703.203712 UDT`)

| Name | Seat |
|------|------|
| **Tilak** | Type-mark word |
| **absorb / express / tend** | Three duties of every Tilak |
| **Pottery** | Value-object tier (`.pott`) |
| **Amphora** | Crossing-vessel vocabulary |

Law: [`active-designing/20260703-202312_the-marked-value.md`](../active-designing/20260703-202312_the-marked-value.md)

---

## Part Ten — TASKS granular (open work)

Source: [`work-in-progress/TASKS.md`](../work-in-progress/TASKS.md)

### Three doors — all closed

- [x] Door 1 — Pond clause (`3320bed`)  
- [x] Door 2 — Lap 3 metal close (`20260703.032412 UDT`)  
- [x] Door 3 — Edit 5 ruling → parity **143**  

### Ladder through 152 — all checked

Edit 5 → Amber **144** → SLC-2b **145** → RW-1 **147** → chrono **148** → RW-2 **150** → crossing **151** → SLC-L1 **152**

### Mechanical next (smallest-first)

| # | Stop | Owner | Gate |
|---|------|-------|------|
| 0 | **Commit rye-core arc** | Kaeden word | — |
| 1 | **Amber manifest hygiene (I6)** | Cursor | mechanical when itinerary opens |
| 2 | Snapshot export spec (I2) + `snapshot_replay` witness | Cursor | Edit-5 slot word |
| 3 | Amphora lap-two Tilak witness | Cursor | seed-home gate |
| 4 | Comlink resin-batch frame (I1) | Cursor | after I2 lap one green |
| 5 | ROADMAP / TASKS / decoder (A8) | Cursor | Kaeden approval |
| 6 | Queue zip 43 at new tip | Cursor | after commit |

### Kaeden gates (standing)

| Gate | Source | What it unlocks |
|------|--------|-----------------|
| TWO_ROOMS seat | A3 | Register law in context canon |
| Gloss spec go-ahead | A2 | `*_canonical-glosses.md` |
| Resin Tilak ruling | zip 42 B | Confirms decline seated `resin` mark |
| Edit-5 slot word | zip 42 F | I2 snapshot spec first |
| Ends-first lens | zip 42 addendum | Age-banded doc orientation |
| Civic export boundary | zip 42 G | CIVIC amphora never-list |
| Continuity-fact custody | zip 42 D/I7 | Puddle import customs |
| Seed home | crossing + Amphora | Module graduation from `work-in-progress/` |
| Journey's pause | recursion v4 | Honorable stop — question for Kaeden, not off-route license |

### Ground — open horizons (selected)

- Kernel-direction memo (`expanding-prompts/20260628-120912_*`)  
- Egress budget design (`20260703.015512`)  
- Deep-archive hardware (procurement waits)  
- Living build counsel — builder as projection (`193012`)  
- Bench-as-block — three siloed active-designing cuts  
- WOV gate — exit-honesty spec before lap  
- Open Asks room — after SLC-L1 edge  
- Puddle continuity invariant  
- Happy-zone pairing — mirrored witnesses per seam  
- Width migration Phase 1b — `mantra/*` as-you-touch  

### Soon — medium term

**Rye OS:** Comlink device wire (virtio-net QEMU) · Comlink v1 · Brix v1 · unified keys · revitalization pass on oldest active-designing briefs  

**Linengrow:** SLC-L2 sealed delivery (Comlink) — gated  

### Later — horizons

Caravan v1 · Pond v1 · Forge · TAME Editor · Aurora verified boot · kernel on RISC-V · SLC-L3 settlement on Sui

---

## Part Eleven — RTAC hard bounds (Cursor loop)

From [`ready-to-ask-claude.md`](../work-in-progress/ready-to-ask-claude.md):

- **Never** touch boxes tagged **(Kaeden …)**  
- **No new module/aspect names** — park in RTAC  
- **Stop-and-park** on: Kaeden-tagged path · parity red twice · module-home decision · keys/custody/amber/MALA · new names  
- **Journey's pause** — when open itinerary has no further stops, summarize rather than invent work  

**Open itinerary definition:** a **gate** is any precondition owned by someone else; **open itinerary** means every precondition is satisfied and owner is Cursor; **smallest-first** sets order; **witness-first red-then-green** sets method.

**Current Cursor stops:** commit batch · I6 when open · gates above on Kaeden word

---

## Part Twelve — Uncommitted batch (exhaustive)

Awaiting single commit when Kaeden asks:

### Active-designing
- `20260704-211012_the-rye-core-and-the-shell.md`
- `README.md` (index row)

### External-research
- `20260704-211012_rye-cores-and-the-gratitude-lineage.md`
- `20260704-214100_subject-oriented-programming-and-the-rye-core.md`
- `README.md` (index rows)

### Tools — archive lap
- `tools/session_logs_archive.rye`
- `tools/session_logs_archive.rish`
- `tools/session_logs_archive_preview.rish`
- `tools/session_logs_archive_witness.rish`
- `tools/fixtures/session_logs_archive/` (README, alpha, beta logs)
- `tools/fixtures/session_logs_archive.sh` (deprecated delegate)
- `tools/parity.rish` (archive witness block)
- `rishi/tests/session_logs_archive.rish`

### Org
- `ORGANIZING.md` (preview/fold commands)
- `session-logs/README.md` (archive note + index rows)
- `.gitignore` (`tools/.build/`, `_sandbox/`)

### Session logs (this arc)
- `20260704-203100_session-logs-archive-rishi-witnesses.md`
- `20260704-211200_rye-cores-er-and-silo.md`
- `20260704-214100_subject-oriented-programming-er.md`
- `20260704-214400_silo-accrete-subject-horizon.md`
- `20260704-214600_archive-preview-fold-parity.md`
- `20260704-215012_radiant-pass-rye-core-arc.md`
- `20260704-220812_checkpoint-rye-core-grain-roadmap-tasks.md` (this file)

**Exclude from commit:** `linengrow/bin/` (build artifact)

### Suggested commit message (when asked)

```
Seat rye-core lap law — gratitude survey, silo, archive tooling, parity hygiene.

Names the core+shell pattern affirmed on metal; session archive wears preview/fold;
witness joins parity. Docs Radiant-passed at 215012.
```

---

## Part Thirteen — Session-log index (Jul 4)

| Stamp | Title | One line |
|-------|-------|----------|
| `020800` | Crossing seed witness 151 | Manifest line parse green |
| `021800` | SLC-L1 receipt 152 | linengrow/receipt on metal |
| `023800` | Parity 152 + not-advice | ORGANIZING filing rule |
| `031812` | Zip 41 + eight asks | Orientation counsel |
| `181512`–`194300` | Zip 42 intake | Zero-copy + ends-first |
| `202900` | Archive fold first run | 500 logs → 12 days |
| `203100` | Archive Rye+Rishi | Core + selftest |
| `211200` | Rye cores ER + silo | Gratitude survey |
| `214100` | Subject-oriented ER | Urbit → lap law |
| `214400` | Silo accrete | Subject + horizon |
| `214600` | Preview/fold + parity | Read/mutate split |
| `215012` | Radiant pass | Arc polish |
| `220812` | **This checkpoint** | Full progress save |

Full index: [`session-logs/README.md`](../session-logs/README.md) — prior days under `session-logs/archive/20260704/` etc.

---

## Part Fourteen — Grain map (module ↔ lap law)

| Module | Role in rye-core grain |
|--------|------------------------|
| **Rye** | Compiles cores; TAME asserts at seams; thin Zig frontend |
| **Rishi** | Shell society — `run`, `assert`, `say`; parity batches witnesses |
| **Mantra** | History; cores never silently rewrite seated prose |
| **Weave** | Typed values; digest-named outputs at seams |
| **Tilak** | Type-mark; absorb / express / tend at every crossing |
| **Brix** | Declared inputs — subject discipline at build seam |
| **Pond** | Policy at receipt; core returns bytes, Pond enforces enclosure |
| **Caravan** | Supervision — one job, bounded restart (s6 lesson) |
| **Comlink** | Control/data at wire — batch header once, stones by digest |
| **Amber** | Cellar — resin seal lap; manifest line law (I6 next) |
| **Amphora** | Crossing vessel — frames under batch mark |
| **Linengrow** | Application — `receipt.rye` flagship core lap |
| **Parity** | Outermost subject that may claim GREEN for whole bench |
| **Puddle** | Happy zone — replay-on-host before boot-shaped replay |

**Sameness is the macro:** one lap shape — core + witness + parity row — so learning one lap teaches the next ([`foundations/20260703-182612_sameness-is-the-macro.md`](../foundations/20260703-182612_sameness-is-the-macro.md)).

---

## Recommend

**Commit the rye-core arc as one batch** when Kaeden asks — this checkpoint is the cover letter. Message drafted in Part Twelve. **Then queue zip 43** at the new tip with comment = `git rev-parse HEAD`.

**Keep going** to Amber manifest hygiene (I6) when the itinerary opens — mechanical, follows zip-42 counsel, smallest metal stop in the preservation arc, needs no new gate beyond open itinerary.

**Check in with Claude before** seating TWO_ROOMS, gloss spec, resin-Tilak ratification, continuity-fact shape, or bulk ROADMAP/TASKS refresh — each crosses module seams or awaits Kaeden word.

**Graduate rye-core silo** to `context/specs/` on Kaeden's word — pattern is affirmed on six green laps plus archive hygiene.

---

*May the lap grain travel home with every module on the Rye OS spine. May this checkpoint hold the whole evening — metal, counsel, tasks, and paths — for any sitter who arrives alone. And may the next commit land seed, core, witness, and parity together, as one honest breath.*
