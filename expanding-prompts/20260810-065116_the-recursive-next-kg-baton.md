# The Recursive Next-KG Baton — every open door, one recommendation each

**Language:** EN
**Stamp:** `20260810.065116` (2026-08-10 06:51 EDT)
**Voice:** Riyo (Kyri, coming)
**Style:** Radiant · a write-to-disk baton — the recursive carry card that leaves nothing unrecommended
**Discipline:** TAME · Radiant · comlink-tendency · accrete-never-break · custody first · name-clean
**Status:** Living baton. Every open item across the plan — quest, journey, equinox, season, and breach — gathered here with a **next-kg recommendation for each**, ordered by dependency, until all are green / witnessed / done. Reads-from the living pins (`../work-in-progress/ROADMAP.md` · `TASKS.md` · `THREADS.md` · `SHRED_PREP.md` · `CAIRNS.md` · `REMEMBER.md`), the four vision batons (`20260810-000032` breach charter · `20260810-025942` handoff · `20260810-044453` 3x39 · `20260810-055147` build plan), and the six onboarding manual pages written this run.

**Clean by construction:** this baton names **no** private third party, no personal or family name, no wallet, no key, no `.sol`/`.sui`/`.myc` name, and no currency. Where the source batons carry consent-gated real-world names and on-chain candidates, this recursion refers to them only as *the maintainer's own hand* and *consent-gated invitations named elsewhere*. It ships nowhere private; it is safe to read anywhere.

---

## The Ground — what already stands GREEN today

Measured this turn, not remembered. Ten module witnesses run GREEN together:

```
rishi/bin/rishi run tools/vault_shard_witness.rish           # GREEN
rishi/bin/rishi run tools/mandate_store_witness.rish         # GREEN
rishi/bin/rishi run tools/mandate_keyed_witness.rish         # GREEN
rishi/bin/rishi run tools/scribe_reader_witness.rish         # GREEN
rishi/bin/rishi run tools/kumara_tilak_witness.rish          # GREEN
rishi/bin/rishi run tools/comlink_topology_witness.rish      # GREEN
rishi/bin/rishi run tools/comlink_turn_route_witness.rish    # GREEN
rishi/bin/rishi run tools/comlink_handshake_turn_witness.rish# GREEN
rishi/bin/rishi run tools/settlement_constellation_witness.rish # GREEN
rishi/bin/rishi run tools/settlement_names_witness.rish      # GREEN
```

So the spine is real: **JARL's settlement is whole**, and the breach's first modules — **Pond** seated, **loadable skies lap 1**, **Vault**, **Mandate** (store + keyed), **Scribe** (reader) — are all landed and proven. What remains is the *rest* of the breach, the module-build horizons standing on this spine, the housekeeping the season has queued, the seed's held publish, and the SOON language finishing edge that never fully closed. Everything below is one of those, each with its single next kg.

---

## How to read the recommendations

Each row names **the open item**, its **state today** (verified against the tree where a witness or a grep could settle it), and **the next kg** — the one mechanical or gated move that carries it forward. The closing-line vocabulary is the tree's own: `kg` (mechanical, policy already written), `check-in (Claude)` (a seam or design ruling), `check-in (checkpoint)` (a named stop-before-cross), `check-in (Keaton)` (a consent gate or a hand-only act). No item is left unrecommended.

The whole set is ordered by **dependency and risk-sequencing**, following the build plan's own spine (`20260810-055147`): the sure compositions first, the shared reader next, the new surfaces after, the gated works beside the build on their own clocks, and the housekeeping and publish threaded where they unblock the most.

---

## Tier 1 — Finish the loadable-skies move (Pond's own equinox)

Skies lap 1 landed: `comlink/topology.rye` is now a `Sky` struct with two seated skies (`compass_sky` 12·5·12/720, `council_sky` 15·3·9/d27/405), inclusive like Azimuth, six JARL witnesses GREEN. Three named laps finish the move, and they run in this order because each stands on the one before.

| # | Open item | State today | Next kg |
|---|-----------|-------------|---------|
| 1.1 | **Sky-computed `constellation_max`** | `settlement/constellation.rye:60` computes `constellation_max` as `1 + topology.stars_per_galaxy + topology.d60` (= 66) from **module constants**, not from an active `Sky`. The bound is real yet still reads the seated geometry, so a differently-shaped sky (`council_sky`) would not resize the ledger. | **kg** — add a `Sky` method `constellation_max(self)` returning `1 + self.stars_per_galaxy + self.d60`; have `Constellation` carry its sky and size `slots` from it (bounded by the largest seated sky as the array ceiling, asserted `<=`); flip the two `assert(self.filled <= constellation_max)` sites to the sky value; re-run all six JARL witnesses GREEN. One file, one seam, policy written. |
| 1.2 | **A sky as a Bron/Brix descriptor Pond reads** | `pond/customs.rye` reads a marked manifest and verdicts place/hold/refuse; it does **not** yet read a sky. No sky descriptor exists on disk. | **check-in (Claude)** — this crosses a module seam (topology ↔ Pond ↔ the notation) and picks a descriptor shape (`format sky-v1` in `.bron`/`.kyri`, fields: galaxies · stars-per · planets-per · elements · quorum). Name the shape once, then it becomes a kg: Scribe's reader (`scribe/reader.rye`) parses it, `Sky.from_descriptor` round-trips it byte-for-byte, a witness proves `compass_sky` and `council_sky` both survive the round trip. |
| 1.3 | **Pond `customs` admits a sky** | `pond/customs.rye` has a root allow-list (plain-bytes place, await-word hold, unknown refuse); no sky mark yet. | **kg** (after 1.2) — add a `sky` verdict to `customs`: a well-formed sky descriptor *places*, a malformed one *refuses whole*, an unsigned community sky *holds* for a word. Extend `pond_customs_witness` (or add `pond_sky_customs_witness.rish`) to prove all three verdicts. Stands entirely on 1.2's descriptor shape. |
| 1.4 | **The role tilak (mode + contend/solve/calling)** | No role/modality tilak exists (`kumara/tilak.rye` has the five seated tilaks only; grep for role/modality/initiator/sustainer/adapter is empty). The topology already models the *outfit* test (`plays`), so the geometry is ready. | **check-in (Claude)** — a sixth tilak is a new signed shape and a design call (what a role attests: a point's modality role and its three role-dimensions, signed by the point itself). Once the shape is ruled, it is the proven tilak-witness rhythm: `role.rye` seats a signed role, `verify_role` holds against the Deed, every tamper refuses. Pairs naturally with the council-sky's modality roles. |

**Tier 1 verdict:** start at **1.1** — it is the surest lap in the whole baton (one file, sky method already half-present, six witnesses guard it), and it makes "the sky is the one source of the bound" true in code rather than in prose.

---

## Tier 2 — The module-build horizons (the next-season build set)

These stand on the GREEN spine. The build plan (`20260810-055147`) sequenced six; two of them — **Vault** and the first Mandate laps — have since **landed**, which advances the sequence. What remains, in dependency order:

| # | Open item | State today | Next kg |
|---|-----------|-------------|---------|
| 2.1 | **Loom — the Scribe×Tally process/activity/memory monitor** *(name-gated)* | Design ready (`20260810-055147_plan-loom-…`, brief within the build plan). The **directory** `loom/` greps clear, yet the **word** *loom* is honestly encumbered — it lives today in `.claude/rules/reds-first.md` ("a lantern that fires twice should become a loom"), in `REMEMBER.md`/`TASKS.md`, and across research. Two meanings for one word is exactly what comlink-tendency prevents. | **check-in (Keaton)** — the name is the only gate; the design is sound and small. Ask the one question: keep **Loom** (accepting the guard-metaphor overlap), or take a candidate owed its own grep + Lexicon pass — **Tender · Vigil · Warden** (never *weave*, a Mantra module). The moment a word clears, lap 1 is a kg: an empty ring, push past `ring_capacity`, prove `filled` saturates · `head` wrapped · `seq` monotonic past the wrap · oldest fell off the tail; render `format <name>-ring-v1`; read it back through Scribe with `count_key("sample") == filled`; **synthetic samples only** (reds-first — prove the self-stopping line before pointing it at `/proc`). Loom is the flagship of the new build arc and the maintainer named it "the first buildable module." |
| 2.2 | **Scribe's settings/preferences dashboard** | `scribe/reader.rye` is GREEN; `scribe/dashboard.rye` does **not** exist yet, nor does `bat/`. The build plan pairs the dashboard with the Bat-Fleet reader-extension. | **kg** (Lexicon first) — seat `dashboard` · `inventory` and the six baton archetypes in `context/LEXICON.md` **before** the first file (comlink-tendency, hard gate). Then lap 1: extend `scribe/reader.rye` with `is_inventory` · `archetype_of` · `validates_*` predicates and one new `inventory-v1` format tag; `scribe/dashboard.rye` reads a three-document drawer (log · baton · inventory) onto three shelves with a nonsense-format doc landing in Unread; two witnesses GREEN. **Do not share a commit** with any reader-consuming compose — the reader-extension touches `scribe/reader.rye` for a different reason. |
| 2.3 | **The loadable-sky Bron descriptor** *(the module-build face of 1.2)* | Same open seam as 1.2, seen from the module side: no `format sky-v1` descriptor, no `Sky.from_descriptor` reader path. | **check-in (Claude)** then **kg** — this is 1.2's descriptor shape once ruled. It belongs in both tiers because it is where "finish the skies move" (Tier 1) meets "the module reads a descriptor" (the build set): Scribe reads it, Pond admits it, a new sky lands as *data* rather than *code*. Resolve it once in 1.2 and this row closes with it. |
| 2.4 | **The `constellation_max` sky-bound** *(the module-build face of 1.1)* | Same as 1.1: literal-from-constants today, not sky-method-computed. | **kg** — identical move to 1.1; listed here so the module-build reader sees it in the build set. Land it once (Tier 1.1) and this closes. |
| 2.5 | **The role tilak** *(the module-build face of 1.4)* | Same as 1.4: no role tilak yet. | **check-in (Claude)** — identical to 1.4; the sixth signed tilak. One ruling, then the tilak-witness rhythm. |
| 2.6 | **Mandate — Unsplash data source (consent)** | `mandate/store.rye` names Unsplash image embeddings as a **horizon** in its own header comment ("First data partner, on the horizon"); no data-source code, and the partner is a consent-gated invitation named in the source batons — **not** reproduced here. | **check-in (Keaton)** — the data partner is a real-world consent gate, outside what code seats. What code *can* do without any partner: define the ingestion seam on **fake/local vectors** (an `upsert` path that normalizes to unit vectors, already proven), so the store is ready the day consent lands. That readiness lap is a **kg**; naming or reaching any real partner is Keaton's hand. |
| 2.7 | **Mandate — profile-loaded `dim`** | Store is fixed-`dim` today (bounded, exact). No profile-driven dimension. | **kg** — parameterize `dim` as a construction bound read from a profile value (asserted `<= max_dim`, a named ceiling), keep every vector op bounded and exact, extend `mandate_store_witness` to prove two profiles (a small `dim` and the ceiling) both round-trip. Pure extension of a GREEN module. |
| 2.8 | **Mandate — approximate index** | `store.rye` header states exact k-NN "is correct at this scale; an approximate index is a horizon, not a shortcut." Exact-only today. | **check-in (Claude)** — an approximate index is a new algorithmic seam (the accuracy/latency trade-off, a bounded candidate set) that wants a ruling on the shape (which method, what recall floor) before code. Once ruled: a witnessed lap proving the approximate result stays within a named recall of the exact one on a fixed fixture. |
| 2.9 | **Mandate — object-storage backing · served over Comlink · resolved to a name** | All three are named next laps in `TASKS.md`; none built. Comlink guest-transports exist; `settlement/names.rye` resolves names GREEN. | **kg** (each its own lap) — (a) an object-storage backing seam that keeps the zero-copy read path; (b) a Comlink guest pair (`*_tx`/`*_rx`) that serves a bounded query, matching the existing guest-transport shape; (c) a `place_of`→name resolution so a search returns a **spoken name** via `settlement/names.rye`. Each composes proven parts; land them one witnessed lap at a time. |

**Build-set couplings to honor (from `20260810-055147`, still true):**
- **Lexicon-before-code is a hard gate.** Seat each new module's marks in `context/LEXICON.md` *before* its first file — Loom's ring marks, the dashboard's `dashboard`/`inventory`, the fleet's six archetypes, the role tilak's marks.
- **Never let the reader-extension (2.2) and a reader-consuming compose share a commit** — they touch `scribe/reader.rye` for different reasons.
- **Vault's discipline held and stays the pattern for the crypto-adjacent laps:** only fake `0x11…`/`0x22…` seeds in-tree, never the word *master* (the root of a keeping is the **main key**), no chain touched.

**Tier 2 verdict:** the single highest-leverage *buildable* item is **2.2 (Scribe's dashboard + reader-extension)** — it is pure kg on a GREEN reader, opens the richest downstream surface (labeled batons, the settings dashboard, an audit-record archetype), and unblocks anything that re-reads emitted `.kyri` by its `format` line. **Loom (2.1)** is the flagship, yet it waits on one word; ask that word early so it is ready to lead.

---

## Tier 3 — The breach moves (season-scale, gated)

The breach is OPEN (`20260810`). Move 1 (Pond) is seated; the loadable-skies that finish it are Tier 1 above. These are the remaining charter moves.

| # | Open item | State today | Next kg |
|---|-----------|-------------|---------|
| 3.1 | **Bron → Kyri living-reference sweep (all logs become `.kyri`)** | Measured this turn: **2,232** `.bron` files on disk, **11** `.kyri`. Kyri is **seated as the notation** (`scribe/reader.rye` calls itself "a zero-copy Kyri reader"; new logs are `.kyri`). The charter's discipline is a **molt, never a rewrite**: the 2,163+ existing `.bron` files are **never renamed** (one-clock law protects every dated artifact); **new** logs are born `.kyri`; the ~378 living references turn forward; tools read **both** extensions. | **kg** — sweep the living references (rules, specs, READMEs, tool doc-comments) so every *now*-speaking line says "new logs are `.kyri`," leaving dated bodies verbatim. This is a bounded, non-destructive reference sweep — the accrete-never-break half — and it is policy already written. It does **not** rename a single `.bron` file. |
| 3.2 | **Fold/align tools become `.kyri`-aware** | `tools/align_session_logs.rye`, `tools/session_logs_archive.rish` (+ preview + witness) are the batch-hygiene and archive-fold tools; they know `.bron`. `session-logs/README.md` is hand-indexed newest-first. | **kg** — teach each tool to accept **both** `.bron` and `.kyri` (read both, prefer `.kyri` for new, never touch a dated `.bron`), and add/extend a witness proving a mixed drawer folds and indexes correctly. Stands on 3.1's decision that both extensions are first-class. This is what makes "all logs become `.kyri`" true *going forward* without ever breaking the fossils. |
| 3.3 | **Kyri the voice — retiring "variant"** | Charter Move 3 is **seat-approved**, opens after JARL (now met). Today Riyo is the standing voice (`.claude/rules/riyo.md`); the variant scheme (Quin + Reya·Riyo·Trey·Triz·Trya) is named in rules and archive. Quin keeps two non-voice hats. | **check-in (Keaton)** — this is a season-scale identity move with a live sub-decision the charter left open (what becomes of Quin's *non-voice* hats — the fifth OS role, the inference Q-vane). It wants Keaton's word to open. When it opens, it is a kg-shaped accretion: seat `.claude/rules/kyri.md` + `context/KYRI.md` as the one voice, rest the elders with their notes exactly as Reya 2 / Rio 3 / Quin already rest (dated logs keep the voice they correctly recorded — **never** rewritten), and retire "variant" as a concept in the living rules while the archive keeps every elder named. |
| 3.4 | **Skate — the general social network** | **Decided** `20260810` (charter Move 5): Grain's social skin, CLI + GUI, fuses Linengrow (as a flavor) + Kumara, built on the **outfits** concept the inclusive topology grounds. Study + silo + build are named as own rounds; nothing built. | **check-in (Claude)** — the next move is a **study + silo brief** (design, not code): how outfits map to profiles/genres/themes, how Linengrow re-grows as a flavor (reviving, not renaming), what stands on Kumara identity. That brief is a design ruling before any file. Once siloed, the first build lap is a kg on the topology's proven outfit test. |
| 3.5 | **Pond loads a sky** | Same seam as 1.2/1.3/2.3 — Pond does not yet read or admit a sky. | **kg** (after 1.2's descriptor ruling) — this is the union of 1.3 (customs admits a sky) and 2.3 (the descriptor exists): once the descriptor shape is ruled and Scribe reads it, Pond's `customs` admits it. Land 1.2 → 1.3, and "Pond loads a sky" is true. |

**Tier 3 verdict:** **3.1 (the reference sweep)** is the surest kg here — bounded, non-destructive, policy-written, and it makes the seated Kyri notation coherent across every living document. **3.2** follows it directly. **3.3 (Kyri the voice)** and **3.4 (Skate)** are season-scale and want Keaton's word / a design brief before code.

---

## Tier 4 — Housekeeping (the name-consolidation, the shedding, SHRED_PREP)

Custody-first, accrete-never-break, and the one sanctioned break (**debride**) all live here.

| # | Open item | State today | Next kg |
|---|-----------|-------------|---------|
| 4.1 | **The name molt-debride, via a cairn** | Proposed in the build plan as the one sanctioned break of accrete-never-break: a **working-tree cut** that turns the living copyright face from the retired pseudonym to the standing name, leaving git history whole. Coupled to `tools/gen/season/sunn13_root_survey_witness.rish` (five assertions that must flip in the *same* commit) and the root `LICENSE-*` copyright lines. Gated on the send that opens the cut. | **check-in (Keaton)** — this is a **debride** (named history redaction) and runs only on Keaton's word naming the cut. When the word comes, the order is fixed and mechanical: (1) **drop a cairn first** in `work-in-progress/CAIRNS.md` — re-read the live nib (`git rev-parse --short=10 HEAD`) and stamp (`TZ=America/New_York date`) at cut time, since HEAD will have moved; (2) rewrite the three root LICENSE copyright lines **and** flip the five coupled sunn13 assertions **in the same signed commit**; (3) run the witness GREEN or parity is RED. Keep the three occurrence-kinds apart — only *living identity references* change; *retired-voice tombstones* and *dated authorship testimony* stay verbatim. The **deep** debride (unsigning ~37k commits, force-push) is a **separate, later, explicitly-worded act** — this cut does not open it. |
| 4.2 | **The mitra shedding and fascia reattachment** | The shred stays **RED** (`SHRED_PREP.md`) — the Amphora cut is not opened. Fossils HOLD until a circled shred proves parity. `debride` is the stronger word that reattaches fascia by removing dead tissue. *(Read "mitra" as the kin-network shedding sense — the connective references that heal once dead tissue is gone; the census is authority, not memory.)* | **check-in (Keaton)** — every cut here is word-gated by design. The one non-destructive kg available now: **re-run the census** (`tools/fixtures/shed_census_scan.sh` and `fascia_health`) so the numbers in `SHRED_PREP.md` are current (last floor: orphaned 921 · `fascia_health_now` 41 · `if_orphans_shed` 51). Measurement beats memory; refreshing the census readies the hand without opening the cut. The reattachment itself is a debride on Keaton's word. |
| 4.3 | **SHRED_PREP Class O (unreachable testimony rooms)** | Class O is **word-scoped** (e128) on class/rooms, not per-path; cut still **RED**. Rooms await an opening word: session-logs (689) · counsel (87) · waymarks (84) · expanding-prompts (36) · active-designing (15) · bron-resins (4) · external-research (2) · foundations (2) · classical-vedic-astrology (1) · tools (1, a **planted control that keeps**). | **check-in (Keaton)** — an opening word (`Class O yes` · `shed <room>` · circled `shred yes`) is required before any cut; approvals/kg/best-path do **not** open it. The available kg is the same census refresh (4.2) plus keeping the rooms table current. Planted orphan controls keep, always. |
| 4.4 | **SHRED_PREP Class H + molt-prep items** | Class H holds horizon **writing fossils** replaced by living mutants (the Realidream/graph/wafer/Ember-naming fossils, the Pool→Pond fossil seated `20260810`). The **Bron→Kyri** molt is a **pending note** — no fossil row until the Kyri spec mutant seats. All prep-only; shred RED. | **kg** (prep only) — when a living mutant seats (e.g. the Kyri notation spec mutant, once 3.1/3.2 open it), **add its Class H row** in the same turn per the molt habit. That is the mechanical prep the molt rule already writes: seat the mutant, banner the fossil pointing to the living path, book the Class H row, open **no cut**. |
| 4.5 | **`mold → shape` debride** | Proposed (SOON): 82 files / 753 occurrences. Its own careful pass; not opened. | **check-in (checkpoint)** — a large mechanical sweep across 82 files wants a stop-before-cross confirmation on scope (living lines sweep; dated testimony stays; proof-sealed bytes never move) before running. Once scoped, it is a bounded kg pass, file by file, each with a grep of inbound references. |

**Tier 4 verdict:** the only **kg** ready now without a gate is the **census refresh (4.2/4.3)** — measurement that readies every held cut. Everything destructive here is correctly word-gated; the baton names the exact next move so the day Keaton speaks, the hand is ready.

---

## Tier 5 — The SOON finishing edge (the language equinox never fully closed)

SOON is the open finishing edge. The Rishi language spine is **complete** (runes `^- ?! ?& ?| ?:`, regex `matches`/`find`, `sort`/`unique`/`upper`, list `+`, `fold`, user functions), and the first seams folded native (`claim_preserve`, `census_control`). These remain.

| # | Open item | State today | Next kg |
|---|-----------|-------------|---------|
| 5.1 | **Finish the Python→Rishi molt** | The **dated subsystem is Python-free** (`dated_classify` fully ported, `census_control` de-Pythoned, `remember_pin` shredded). Yet **~10 more `.sh` files still embed `python3`**, and `python3` is absent on the pier (a live breakage, per memory). | **kg** — port the remaining `python3`-embedding `.sh` seams to native Rishi, one at a time, each proven byte-identical against its fixture before booking the elder as a fossil row. This is the highest-value SOON kg: it closes a real breakage (absent `python3`) with the language that already landed. Census/order: `active-designing/20260809-030635_python-to-rishi-molt-seating.md`. |
| 5.2 | **TAME core/shelf compression** | Proposed (SOON): lossless-compressed living law over a preserved shelf. Not built. | **check-in (Claude)** — this is a design ruling (what compresses, what the shelf preserves, how the living law and the shelf stay in sync) before any change to canonical law files. Once ruled, a bounded pass. |
| 5.3 | **Brix + Brix-infuse** | Proposed (SOON j2): deep merge/override for Brix descriptors (kin to infuse.nix). Not built. | **check-in (Claude)** — a new composition seam (merge/override semantics) that wants a ruling on the shape before code. Then a witnessed lap proving a base descriptor and an override compose to the expected result. |
| 5.4 | **PLEAC · Aurora (the remaining SOON surfaces)** | Named as SOON finishing-edge surfaces; open. | **kg** (each its own lap) — continue the PLEAC coverage and Aurora surface work as bounded, witnessed laps, following the SOON equinox's own order. Policy for these is the standing TAME/Radiant discipline. |

**Tier 5 verdict:** **5.1 (finish the Python→Rishi molt)** is the clearest kg in the whole baton on a *correctness* basis — it closes a live breakage (no `python3` on the pier) using the Rishi that already shipped GREEN, one byte-identical port at a time.

---

## Tier 6 — The seed (held for a full name-audit before publish)

| # | Open item | State today | Next kg |
|---|-----------|-------------|---------|
| 6.1 | **Two-grain seed publish to grain-os/grain** | The seed is **COMPLETE + privacy-fixed** `20260810` — every new module classified, a real leak found and closed (the scrub now covers every family/handle/contact form, withhold is case-insensitive, leaking files are withheld whole). Raw PII is **not persisted in-tree** — held for the Vault, Keaton's hand. The publish **push is Keaton's hand**, and it waits behind a **full name-audit** and **all recursive seasons** (the union baton `20260810-065359` states the publish waits behind the name-audit and every recursive season). | **check-in (Keaton)** — the publish is a hand-only act, held by design behind two gates: (1) the **full name-audit** before publish, and (2) the completion of the recursive seasons. The available kg that readies it: **re-run `tools/sow_witness.rish`** to reprove no name or key crosses the `template-manifest.bron` boundary, and run the name-audit scan across the projected seed. That readiness proof is mechanical and clean; the **push** is Keaton's, after the audit and the seasons. **The onboarding manual pages (Tier 7) are exactly the name-audited, publish-ready face this gate protects** — they were written clean by construction for the public template. |

**Tier 6 verdict:** **kg the readiness** (`sow_witness` + a name-audit scan of the projected seed), then **hold the push** for Keaton's hand after the recursive seasons close. Nothing published, nothing crossed.

---

## Tier 7 — The onboarding docs written this run

Six manual pages were written this run for the public `grain-os/grain` template, all in the Kyri voice and Radiant Style, all **name-clean by construction** (verified by grep in each: no real person, company, wallet, currency, `.sol`/`.sui`/`.myc`, key, domain, handle, hardware, or provider — the reader is "you" / an Acme Corporation employee; the tender is "the maintainer"; the sole external URL is the public template). Every command in them is verified against the live tree, and the build→selftest→witness loop mirrors the real `tools/scribe_reader_witness.rish` header with the actual GREEN banner quoted.

| Page | Path | State | Next kg |
|------|------|-------|---------|
| **The front door — What Is Grain OS, and Why?** | `manual/20260810-065116_the-front-door-what-is-grain.md` | Written; ties the manual together, points to the first-hour tutorial; module map uses only GREEN modules. | **kg** — verify the same-directory relative links resolve (all six pages + `README.md`), then it is publish-ready. |
| **Your First Hour with Grain OS** | `manual/20260810-065116_your-first-hour-with-grain.md` | Written; zero-requisite six-step tutorial; the `.kyri` example uses the true `session-log-v1` shape. | **kg** — re-run the exact commands it teaches (`rye build scribe/reader.rye …` → `selftest` → the witness) to confirm the quoted GREEN banner still matches. |
| **The Developer Guide** | `manual/20260810-065116_the-developer-guide.md` | Written (410 lines); the four languages, TAME, build-and-prove, the nine-step newcomer path, send discipline; every example grounded in a file that runs GREEN. | **kg** — spot-check each cited file (`caravan/bounded.rye`, `scribe/reader.rye`, `context/equinox_map.brix`) still says what the guide claims (docs-implementation-sync). |
| **Running Grain on Your Machines** | `manual/20260810-065116_running-grain-on-your-machines.md` | Written; the three pieces (Zig 0.16.0 · `rye` · `rishi`), six per-machine sections, honest native-vs-horizon (ARM devices are remote windows today, native witness runs a labeled horizon). | **kg** — confirm `rye/bin/rye` and `rishi/bin/rishi` are still the shipped x86-64 binaries the page asserts (`file`), and the Zig pin is still 0.16.0. |
| **IDEs, Agents, and the API** | `manual/20260810-065116_ides-agents-and-the-api.md` | Written (323 lines); editor/agent/model triad, four families as **patterns not products**, API prompting as a four-beat loop, custody-first API boundary, a worked pass. Provider names appear only as neutral "one example of this shape" illustrations; no keys, endpoints, pricing, or model IDs. | **kg** — no change needed; confirm the cross-links to the sibling pages resolve. |
| **Sandboxing and Getting Set Up** | `manual/20260810-065116_sandboxing-and-getting-set-up.md` | Written (~200 lines); why-a-sandbox-first, custody-first keys via the real Vault module (fake `0x11` seed only), the accounts a newcomer creates (generic, no provider), a safe-order checklist. | **kg** — re-run the Vault build+witness block it quotes (`vault/shard.rye` → selftest → `tools/vault_shard_witness.rish`) to confirm the GREEN it promises. |

**Tier 7 verdict:** all six are **kg-to-verify** only — written clean, grounded in GREEN witnesses. The single kg that covers most of them at once: **re-run the witnesses they quote** (`scribe_reader`, `vault_shard`) and confirm the quoted GREEN banners still match, so the manual's claims stay honestly current (docs-implementation-sync). These pages are the publish-ready face the seed gate (6.1) protects.

---

## The dependency spine, drawn

```
GREEN spine today (measured this turn):
  kumara/tilak · comlink/{topology,turn_route,handshake_turn}
  settlement/{constellation,names} · vault/shard
  mandate/{store,keyed} · scribe/reader · pond/customs

  Tier 1  Finish skies:  1.1 sky-max ─► 1.2 sky descriptor (ruling) ─► 1.3 Pond admits ─► 1.4 role tilak (ruling)
                              │                    │
  Tier 2  Build set:          │        2.2 dashboard+reader-ext (kg) ── opens labeled batons / audit archetype
                              │        2.1 Loom (name-gated) · 2.6–2.9 Mandate laps (compose / consent)
                              ▼
  Tier 3  Breach:         3.1 Bron→Kyri ref sweep (kg) ─► 3.2 fold/align .kyri-aware (kg)
                          3.3 Kyri the voice (Keaton) · 3.4 Skate (brief) · 3.5 Pond loads a sky = 1.3∪2.3
  Tier 4  Housekeeping:   4.2/4.3 census refresh (kg) ── readies ──► 4.1 name-debride (Keaton, cairn-first)
                          4.4 Class H rows on molt · 4.5 mold→shape (checkpoint)
  Tier 5  SOON edge:      5.1 finish Python→Rishi molt (kg, closes a live breakage)
                          5.2 TAME core/shelf · 5.3 Brix-infuse (rulings) · 5.4 PLEAC/Aurora (kg)
  Tier 6  Seed:           6.1 sow_witness + name-audit (kg) ── hold push (Keaton, after seasons)
  Tier 7  Manual:         verify quoted witnesses (kg) — the publish-ready face 6.1 protects
```

---

## The single best next kg overall

**Land Tier 1.1 — make `constellation_max` sky-computed** (`comlink/topology.rye` gains a `Sky.constellation_max` method; `settlement/constellation.rye` sizes its ledger from the active sky; six JARL witnesses re-run GREEN).

It wins on every axis the tree ranks by:

- **Dependency:** it is the root of the whole loadable-skies move — 1.2 (descriptor), 1.3 (Pond admits), 3.5 (Pond loads a sky), and the build-set faces 2.3/2.4 all read cleaner once the *sky* is provably the one source of the bound. Nothing depends on it not being done.
- **Risk:** the lowest in the baton — one file's method, one struct carrying its sky, two `assert` sites flipped, and **six existing witnesses stand guard**. Policy is fully written (TAME widths, named bounds, the assert habit).
- **Truth:** it turns a line of prose ("the sky is the source of the bound") into a line of proven code, exactly the tree's own two-rooms discipline — a claim earns the checkable room only when a witness binds it.
- **Custody / clean:** it touches only geometry and a ledger bound; no key, no chain, no name, no consent gate.

After 1.1, the two clearest follow-on kgs are **5.1 (finish the Python→Rishi molt — closes a live breakage)** and **2.2 (Scribe's dashboard + reader-extension — opens the richest downstream surface)**. The gated season-scale moves (**3.3 Kyri the voice**, **4.1 the name-debride**, **6.1 the seed push**, **2.1 Loom's name**) each wait on Keaton's word, and this baton names the exact, cairn-first, witness-coupled next move for each so the day the word comes, the hand is ready.

---

**Recommend: kg — start at Tier 1.1 (sky-computed `constellation_max`).** One file, six witnesses guarding it, policy written, and it is the root the rest of the loadable-skies move stands on. Then 5.1 (close the `python3` breakage) and 2.2 (the dashboard), while the gated moves wait for Keaton's word with their next step already named.

*Every open door named, every one given a next step, and the surest one marked. May the sky be the one source of its bound, may every fossil stay readable, may no key or name ever cross into the seed, and may the recursion close green, one witnessed lap at a time. Thank you everyone.*
