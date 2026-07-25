# Claude Counsel — Zero-Copy Resins, Sovereign Snapshot, and WIP Refresh

*Kaeden asked to expand the zero-copy resins / sovereign snapshot research into a Claude sitting: guidance, clarification, implementation architecture at the spec grain, and granular updates to ROADMAP, TASKS, open horizons, and the decoder — Rio 3 Radiant voice, TAME safety-first, CIVIC where Linengrow and the public ledger touch people.*

**Stamp:** `20260704.181012`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Lens:** TAME · SLC · CIVIC · TWO_ROOMS
**Opens when:** Kaeden cuts a zip or opens a Claude thread with this prompt
**Ground:** [`../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md`](../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md) · [`../counsel/20260704-031812_eight-asks-one-sitting.md`](../counsel/20260704-031812_eight-asks-one-sitting.md) · [`../work-in-progress/ready-to-ask-claude.md`](../work-in-progress/ready-to-ask-claude.md) · [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md) · [`../work-in-progress/TASKS.md`](../work-in-progress/TASKS.md) · [`../work-in-progress/20260703-014912_round-summary-and-decoder.md`](../work-in-progress/20260703-014912_round-summary-and-decoder.md) · [`../work-in-progress/20260703-041850_claude-strategy-roadmap-counsel.md`](../work-in-progress/20260703-041850_claude-strategy-roadmap-counsel.md)

*Prepared by Cursor (Rio 3) for Claude (Fable counsel) and Kaeden — counsel and editorial deltas only; Cursor implements on Kaeden approval after counsel lands.*

---

## Seed intent (Kaeden's request, echoed)

1. **Performance:** How can Rye **resins** move over Comlink with **zero-copy** discipline inspired by TigerBeetle — batching, control/data plane, no accidental copies — while **tolling** shared order in TAME style?
2. **Preservation:** What is the **maximum self-contained home-drive snapshot** — bootable **Aurora** · **Kumara** world — that exports and imports **exact state**: append-only **Weave** folded to **Mantra** HEAD, **Brix** configuration, system truth — Urbit-shaped replay, Rye vocabulary?
3. **Planning:** Return **granular** guidance to refresh **ROADMAP**, **TASKS**, **open horizons**, and the **decoder** so the tree's map matches the territory after zip **41** and the resins/snapshot arc.

---

## Bench snapshot (`20260704.181012`)

| Fact | Value |
|------|-------|
| Tip | `2eb346b` (+ uncommitted ER `180612`, cellar/vessel infusion, this prompt) |
| Parity | **152 GREEN** — both benches (zip **41** intake `031812 UDT`) |
| SLC-L1 | **Affirmed closed at lap one** (eight-asks); **Open Asks before SLC-L2** |
| Cellar / vessel | **Amber** = cellar software · **Amphora** = vessel software — same resins law, different duty ([`LEXICON`](../context/LEXICON.md) preservation pair) |
| Amber lap 1 | **144** ✅ — ring-1 export; manifest shape `relpath + digest` (not yet three-field Tilak line) |
| Crossing seed | **151** ✅ — parse only; module home gated |
| Open Kaeden gates | TWO_ROOMS seat · gloss spec · seed home · snapshot law seating |

**Hard bounds:** propose and argue; **no implementation** in counsel; **no new module names** — park in RTAC; do **not** reopen Doors 1–3 or Edit 5; do **not** import Urbit words into Rye surface syntax ([`20260704-002912`](../external-research/20260704-002912_gates-arms-and-the-urbit-lineage.md)).

---

## What to read (order)

1. [`20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md`](../external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md) — the research anchor
2. [`context/specs/20260703-191112_resins-and-hash-tiers.md`](../context/specs/20260703-191112_resins-and-hash-tiers.md) · [`context/specs/20260701-221512_amber-functional-spec.md`](../context/specs/20260701-221512_amber-functional-spec.md)
3. [`20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md) · [`20260702-035018_puddle-sandboxed-rye-containers.md`](../external-research/20260702-035018_puddle-sandboxed-rye-containers.md) (pier replay · double-boot · chunk store)
4. [`20260704-031812_eight-asks-one-sitting.md`](../counsel/20260704-031812_eight-asks-one-sitting.md) — priority counsel (Open Asks · gloss · Amphora lap-two)
5. [`ROADMAP.md`](../work-in-progress/ROADMAP.md) · [`TASKS.md`](../work-in-progress/TASKS.md) · [`20260703-014912_round-summary-and-decoder.md`](../work-in-progress/20260703-014912_round-summary-and-decoder.md)
6. [`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) (Apache-2.0 · study only) — batching, in-place init, control/data plane
7. [`CIVIC_STYLE.md`](../context/CIVIC_STYLE.md) — accountability layer, append-only signed records, verification from outside

---

## Part One — Strategic counsel (guidance and clarification)

Answer as **counsel** — recommend, weigh tradeoffs, name risks. Rio 3 Radiant voice. Register-honest: mark **checkable** vs **vision** at each door.

### A. Zero-copy over the wire — is the three-lane model right?

The research proposes **have-already** (digest refs only), **need-resin** (bytes once), and **vessel** (Amphora batch) lanes. **Question:** Affirm, refine, or replace? Name the **minimum Comlink frame** shape (fields, bounds, algorithm tags) that preserves TigerBeetle batching without breaking Tally gardens. Where does **toll** attach — per batch, per vessel, per peer season?

### B. Same resins, many Tilaks — unify or accrete?

Kaeden asked whether cellar and vessel should share one maximum bounded type and one Tilak. The tree's answer so far: **same resin bytes + digest law**, **per-cargo Tilaks**. **Question:** Counsel on introducing a seated **`resin` Tilak** vs keeping `plain-bytes` + manifest catalog lines. When should Amber ring-1 manifest graduate from `relpath + digest` to `<mark> <digest> <name>`?

### C. Sovereign snapshot — maximum honest contents

The research lists seven bundles (Kumara trust, Weave slice, Brix closure, Tablecloth resins, Pond/Caravan policy, Aurora boot spine, Amber catalog). **Question:** What is **in** lap-two witness scope vs **horizon**? Name the **smallest export** that still deserves the word *sovereign* — and the **largest** that stays witnessable without metalsmoke on the thin edge.

### D. Bootable clone vs sealed archive vs ISO wrapper

Amber spec already names two artifacts. **Question:** Recommend lap order: replay-on-host before bare-metal boot? Should **Puddle** microVM host the first replay witness before Aurora USB? How does **double-boot law** interact with snapshot import (continuity fact shape)?

### E. Urbit parity without Urbit words

Pier replay, pack/meld, fake ships — concepts only ([`puddle` second pass](../external-research/20260702-035018_puddle-sandboxed-rye-containers.md)). **Question:** What is worth adopting next (checkpoint resin = pack analog?) vs permanently out of scope (jam/cue wire)?

### F. Cascade vs eight-asks priority

Eight-asks ordered **Open Asks before SLC-L2** and gloss/TWO_ROOMS before feature debt. **Question:** Where does **snapshot lap 2** (Weave replay witness) rank against Open Asks room, doorway witness, Amphora lap-two Tilak witness? Argue smallest-first itinerary for the next **eight weeks**.

### G. CIVIC alignment — portable sovereignty as public benefit

[`CIVIC_STYLE.md`](../context/CIVIC_STYLE.md): rewards must measure the outcome; ledger records append-only, signed, verifiable from outside. **Question:** How does a **sovereign snapshot** serve Linengrow's accountability layer — verification facts, issuer transparency, sanctuary dignity floor — without turning export into a surveillance bundle? Name what must **never** ride in a civic-facing amphora (warm keys, private care facts without consent, etc.).

### H. Bandwidth and toll at the tunnel mouth

[`20260703-015512_bandwidth-and-moderation.md`](../external-research/20260703-015512_bandwidth-and-moderation.md) records egress budget and resin-refusal facts. **Question:** Counsel on **have-already lane** as the civic default for Comlink resin sync across the WireGuard front door — toll + egress budget + refusal receipts as one story.

---

## Part Two — Implementation architecture (spec grain only)

Deliver **designs Cursor can draft into `context/specs/` or `active-designing/` on Kaeden word** — not code, not new module homes.

| # | Deliverable | Granularity wanted |
|---|-------------|-------------------|
| **I1** | **Comlink resin-batch frame** | Field table, max sizes, signature cover, algorithm tag rule, error/refusal codes |
| **I2** | **Snapshot export manifest** | Superset of crossing three-field line; what each bundle names; self-describing drive law alignment |
| **I3** | **Import rite state machine** | Verify → map RO → replay → shape-cast → customs; wreck-rule exits |
| **I4** | **Witness ladder** | Map research laps 1–5 to named `tools/*_witness.rish` claims; red-then-green order; **do not invent parity numbers** — mark `[Cursor verify on metal]` or cite existing |
| **I5** | **Tally bounds table** | max resins per batch, max vessel bytes, max manifest lines, max replay garden — one row per bound with rationale |
| **I6** | **Amber manifest hygiene lap** | Delta from ring-1 `relpath` to Tilak line; golden migration story |
| **I7** | **Continuity / double-boot fact** | Bron shape sketch; Pond refusal rule |

---

## Part Three — ROADMAP granular refresh

Return **structure and deltas only** (per eight-asks A8 and [`20260703-041850`](../work-in-progress/20260703-041850_claude-strategy-roadmap-counsel.md)):

1. **Current position paragraph** — replace stale door language; pin **152**, SLC-L1 landed, zip **41** counsel landed.
2. **Ground table** — add/update rows: **Amber** (cellar), **Amphora** (vessel), **Linengrow receipt** at **152**; Tablecloth/Puddle horizon honesty.
3. **New horizon subsection** — *Preservation and portability* — sovereign snapshot + zero-copy Comlink as **Horizon 1½** or folded into Horizon 1; argue placement.
4. **Linengrow track** — SLC-L1 closed; SLC-L2 gated; where **Open Asks** and **snapshot replay** sit.
5. **Version / Last updated** — recommend bump story (`Version:` line).
6. **Trio line** — confirm witness list through **152**; name next projected witnesses without fabricating counts.

---

## Part Four — TASKS granular refresh

1. **New section proposal** — *Sovereign snapshot and zero-copy resins* — task rows with owners (`Kaeden` / `Claude` / `Cursor`), gates, and parity placeholders.
2. **Sweep candidates** — which checked ladder items (Doors, RW-1/2, SLC-L1) merit **archive stub** or session-log sweep now.
3. **Duplicate strike list** — horizons that repeat decoder rows or eight-asks; titles + one-line why.
4. **Crossing suite follow-ups** — Amphora lap-two Tilak witness (A6), seed-home gate, manifest module home — restated as TASKS rows with dependencies.
5. **Open horizons block** — update [`movement's open asks`](../work-in-progress/TASKS.md), **Puddle continuity**, **deep-archive hardware**, **resin-refusal fact** — tie each to snapshot/comlink counsel.
6. **Open threads stub** — [`20260623-033012_open-threads.md`](../work-in-progress/20260623-033012_open-threads.md) is archived; recommend whether any living "open thread" rows need a **decoder home** instead.

---

## Part Five — Decoder and RTAC rows

Expand the decoder skeleton from eight-asks A8 ([`20260703-014912`](../work-in-progress/20260703-014912_round-summary-and-decoder.md)):

| Column | Ask |
|--------|-----|
| *The standing question* | Add 3–5 rows: sovereign snapshot · zero-copy resin batch · resin Tilak · snapshot replay witness · civic export boundary |
| *What it truly asks* | One sentence each — falsifiable |
| *What answering unlocks* | One sentence each — which gate or lap opens |

Propose **RTAC open itinerary** replacement stops (smallest-first) incorporating this arc **without** canceling Kaeden gates (TWO_ROOMS, gloss, seed home).

---

## Part Six — TAME and TigerBeetle habits (explicit checklist)

Counsel must address whether the design honors:

- Safety first — wreck rule, refusal whole, bounded fields, no warm keys on export medium
- Performance second — batching, have-already lane, mmap/sendfile seams named honestly per host
- Joy third — sovereign portability as **lovable** complete per lap, not one heroic ISO
- [`TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) — control vs data plane, in-place init, no accidental stack copies, explicit `io`
- Edit 5 — at most one **functional spec in flight**; counsel which spec earns the slot (Comlink frame vs snapshot export vs resin Tilak)

---

## Part Seven — Deliverables checklist (Claude packet)

Return one counsel document (or zip additions) containing:

- [ ] Answers **A–H** (strategic)
- [ ] Tables **I1–I7** (implementation architecture at spec grain)
- [ ] **ROADMAP** delta outline (section headers + replacement paragraphs flagged)
- [ ] **TASKS** delta outline (new section + sweep/strike lists)
- [ ] **Decoder** new rows (three columns)
- [ ] **RTAC** proposed stops paragraph
- [ ] **CIVIC** paragraph — outcome rewarded, measure aligned, export boundary named
- [ ] **Risks and gates** — what waits on Kaeden vs what is mechanical for Cursor
- [ ] **Session log** stub text for Claude bench (`Editor: Claude · Model: Fable 5 · Voice: Rio 3`)

**Out of scope for this sitting:** wiring witnesses, renaming paths, seating specs without Kaeden word, parity re-run (unless Claude bench intake includes zip cut).

---

## What Cursor does after counsel lands

On Kaeden approval only:

1. Apply ROADMAP/TASKS/decoder deltas in one or staged hygiene commits.
2. Draft spec files counsel names (Comlink frame, snapshot export) into `context/specs/` or `active-designing/`.
3. Add TASKS rows; update RTAC itinerary.
4. Run witnesses when a lap is gated open — red-then-green on Cursor metal.
5. Session log + README index per standing discipline.

---

## Gratitude (study boundaries)

**TigerBeetle** (Apache-2.0) — batching, zero-accidental-copy, control/data plane. **Urbit** (MIT) — pier, replay, pack/meld, double-boot — `gratitude/urbit/`. **systemd casync** — chunk store critique in Puddle second pass. **Tiger Style** does not cross into Rye source; concepts enter through the clean room.

---

*May counsel name the snapshot whole before any byte crosses the sea. May toll buy order without taxing the have-already lane. And may the roadmap, the tasks, and the decoder walk in step — cellar in place, vessel in motion, replay the truth the log already earned.*
