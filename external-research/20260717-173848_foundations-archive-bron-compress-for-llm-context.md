# Foundations Archive, Bron Compress, and LLM Context Budget

**Language:** EN
**Version:** `20260717.173848` (Eastern)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** research for understanding — archive vs compress · Bron vs Markdown · LLM context (Two Rooms). Addressed to a generic Acme Corporation employee.
**Companion silo:** [`../active-designing/20260717-173848_compass-card-and-foundations-compress.md`](../active-designing/20260717-173848_compass-card-and-foundations-compress.md)

---

## What This Study Asks

An Acme Corporation employee reading this is weighing whether to:

1. Archive foundations or context essays into smaller homes.
2. Compress those essays into succinct Bron (`.bron`) so LLM sessions spend fewer tokens.
3. Keep the why-shelf intact and save tokens another way.

Shelf sizes at this stamp (order of magnitude): **foundations ~264 KB / 26 Markdown files**; **context ~612 KB / 71 Markdown files**. The largest single essays (`the-aspiring-radiance-universal.md`, `TAME_GUIDANCE.md`, `LEXICON.md`) dominate cold-load cost when an agent reads them whole.

## Verdict First

| Move | Verdict |
|---|---|
| Bulk-archive `foundations/` or `context/` into `archive/` | **Decline** without a separate, explicit ruling that reopens the closed inventory |
| Rewrite dated foundations into Bron essays | **Decline** — dated_guard · accrete-never-break · teacher prose loses Radiant voice |
| Replace foundations with Bron | **Decline** — Bron is seam notation, not essay form |
| Extend the seated **docs compression** layer | **Approve** — already law; missing a compass / day-one page |
| Add a tiny **compass card** (Bron pointers only) | **Approve** — agent cold-start order without loading essays |

## Laws Already Seated (this question is not blank)

| Law | What it already says |
|---|---|
| Docs compression (`20260712.221600`) | Raw dated notes beneath; living `docs/` compressors above; pages never replace the record |
| Markdown inventory (`20260713.215800`) | `foundations/` and `context/` keep their roles — no blanket archive |
| Compass check-in (`20260717.165200`) | Do not archive or rewrite foundations to fit incomplete Glow without an explicit ruling |
| Bron notation | ~half the tokens of JSON for **config and seam values** — not a substitute for why-prose |
| `dated_guard` | Dated-on-main files stay immutable unless living-ledger or freeze-pointer |
| Two Rooms | Foundations are mostly visionary/why; a compressor that claims GREEN must stay checkable and witness-bound |

The tree already solved “too many notes for operators” with **Markdown compressors** (`docs/HAWM.md`, `docs/TUBE.md`, …). It has not yet solved “too much why for an agent’s first turn” with a single day-one compressor and a pointer card.

## Why Bron Essays Would Fail Here

Bron’s strength is **immutable key-value at a seam**: session logs, host cards, policy descriptors. Turning `the-happy-zone-and-the-thin-edge.md` into Bron fields would:

- Strip Radiant Style (the form employees and humans read for meaning).
- Fight `dated_guard` if the Markdown original were rewritten or deleted.
- Teach agents a second essay grammar they do not need.
- Save fewer tokens than a **short compressor + pointers**, because the why still has to be said somewhere when the lap needs it.

**Bron for LLM savings already works where it belongs:** load `GLOW_HOST.bron`, a session log, or a **compass card** of paths — not 500-line vision essays.

## What Actually Saves LLM Context

Ordered from cheapest to dearest:

1. **Do not load the shelf.** Agents follow Cursor rules + itinerary; they open foundations only when the lap needs the why.
2. **Read a compressor first** (`docs/COMPASS.md`) — ≤120 lines that name the rose and point out.
3. **Load a Bron compass card** — a few dozen tokens of `read <path>` lines for cold-start order.
4. **Open one foundation** when the question is why, not how.
5. **Never** paste aspiring-radiance or full TAME into every turn.

Token cost is mostly **habit**, not file size on disk. Archiving does not shrink what an eager agent greps; a reading order does.

## Recommended Shape (scaffold this send)

| Artifact | Role |
|---|---|
| `docs/COMPASS.md` | Living Markdown compressor — day-one rose for Acme + Cursor |
| `docs/compass_card.bron` | Succinct Bron pointer list — agent cold-start; no essay body |
| Tutorial link | `manual/tutorials/cursor-and-the-compass.md` points at both |
| Foundations / context files | **Stay** — affirm in place; never rewritten for token budget |

Horizon (needs a later word): a `docs/TAME.md` thin compressor if `TAME_GUIDANCE.md` cold-loads too often; a `docs/LEXICON_CORE.bron` of the twenty most-used terms — only if measured pain appears.

## What This Does Not Claim

- It does not move any foundation into `archive/`.
- It does not convert essays to Bron.
- It does not change `dated_guard` or living_docs_lint duties.
- It does not declare the large vision docs “done” — they remain living why.

## Related

- `../active-designing/20260712-221600_docs-compression-layer-design.md`
- `../external-research/20260712-223300_living-docs-lint-and-karpathy-wiki-pattern.md`
- `../work-in-progress/20260713-215800_markdown-archive-inventory-and-migration-plan.md`
- `../active-designing/yonder/20260621-063912_bron-notation.md`
- `../foundations/20260706-185112_follow-our-compass.md`
- `../docs/README.md`
- `../manual/tutorials/cursor-and-the-compass.md`
- Prior habitat study `20260717-173427_*`

---

*May the raw shelf stay beneath, the compressor stay few, and every cold start begin with a card rather than a cathedral.*
