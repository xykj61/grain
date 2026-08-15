# Fill ALES237 — Lotus album_merge_sheet: the record merge verdict as a page, the merge tier whole

**Stamp:** `20260815.151215` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES237**
**Kin:** [`../lotus/album_merge.rye`](../lotus/album_merge.rye) (ALES235 — the Merge this draws) · [`../lotus/library_merge_sheet.rye`](../lotus/library_merge_sheet.rye) (ALES236 — the catalog page this mirrors one level down) · [`20260815-150804_fill-ales236-lotus-library-merge-sheet.md`](20260815-150804_fill-ales236-lotus-library-merge-sheet.md)

## The crux

ALES235 reconciled two independent sets of record changes into a `Merge`, and ALES236 drew the catalog merge as a page. This rung completes the pair: the record merge deserves the same readable page, mirroring `library_merge_sheet` one level down (catalog → record, album → track). Before a keeper accepts a record merge, or reaches for the ear a conflict wants, they want to *see* it — which tracks the merge takes and from whose hand, which it drops, and exactly where the two engineers disagree.

The same quiet move the diff sheet and the catalog merge sheet took: **a projection, not a round-trip.** No new frame, no new hash — a bounded render over fields `merge` already proved whole, including the absent-digest grammar (a change-vs-remove side rendered as a single `-`, a token a real 64-hex digest can never be). With this rung the merge tier's readable-page parity is complete: `merge` and `merge_sheet` each stand at both the record and the catalog level.

## What ALES237 adds

`lotus/album_merge_sheet.rye`, a pure render over ALES235's `Merge`, exactly parallel to ALES236:

- `render_sheet(merge, out) → u32` — a `format lotus-album-merge-sheet-v1` header, a `summary <resolved> <dropped> <conflicts>` line, then one line per verdict in order: `resolved <name> <source> <digest>`, `dropped <name> <source>`, `conflict <name> <base> <ours> <theirs>` (an absent side's digest a `-`).
- `SheetError = error{ Overflow }` — a projection is otherwise infallible.

Every field is bounded from `max_track_name` and `digest_hex_len`, so `max_sheet_bytes` proves the whole page fits a fixed buffer; a too-small buffer refuses `Overflow`.

## The laws the witness proves on metal

- **THE SUMMARY LAW** — the page opens with the format line and a `summary <resolved> <dropped> <conflicts>` line.
- **THE RESOLVED LAW** — every resolved track appears in order with its source word and its digest.
- **THE DROPPED LAW** — every dropped track appears with the source that removed it.
- **THE CONFLICT LAW** — every conflict appears with its name and three digest fields; a change-vs-remove conflict prints the removing side as `-`.
- **THE ATOMIC LAW** — a too-small buffer refuses `Overflow`.

## Honest scope

Software only, purely local — a bounded text render over in-process fields already proven whole by `merge`, siloed to `lotus/`. Content-addressing on the page, never a signature. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate — the signed carry that names *who made* a record remains the later crypto seam on Keaton's word. With this rung the whole merge family stands whole: `merge` and `merge_sheet`, at the record and the catalog level alike — the shape a body of work grows under many hands.
