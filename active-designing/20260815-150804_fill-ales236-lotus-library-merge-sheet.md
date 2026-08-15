# Fill ALES236 — Lotus library_merge_sheet: the merge verdict as a readable page

**Stamp:** `20260815.150804` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES236**
**Kin:** [`../lotus/library_merge.rye`](../lotus/library_merge.rye) (ALES234 — the Merge this draws) · [`../lotus/library_diff_sheet.rye`](../lotus/library_diff_sheet.rye) (ALES230 — the readable-projection idiom this mirrors) · [`20260815-145638_fill-ales234-lotus-library-merge.md`](20260815-145638_fill-ales234-lotus-library-merge.md)

## The crux

ALES234 reconciled two independent sets of catalog changes into a `Merge` — resolved albums, dropped albums, and named conflicts — yet that verdict lives in a struct a *program* reads, not a page a *keeper* reads. Before a keeper accepts a merge, or reaches for the ear a conflict wants, they want to *see* it at a glance: which records the merge takes and from whose hand, which it drops, and exactly where the two sides disagree.

This rung draws that page, the same quiet move the diff sheet took over the diff (ALES230): **a projection, not a round-trip.** The `Merge` is the computed verdict; the sheet is the eye's version of it, parsing back to nothing. It needs no new frame and no new hash — only a bounded render over fields `merge` already proved whole. It completes the merge's usefulness the way every catalog primitive earns its readable page.

The one new grammar decision the merge sheet makes past the diff sheet: a conflict can carry an **absent** digest (a side that lacks the album, as in a change-vs-remove conflict). An absent digest renders as a single `-` — a token a real 64-hex digest can never be — so every conflict line keeps four positional fields (`name`, base, ours, theirs) a reader or a grep can trust.

## What ALES236 adds

`lotus/library_merge_sheet.rye`, a pure render over ALES234's `Merge`:

- `render_sheet(merge, out) → u32` — a `format lotus-library-merge-sheet-v1` header, a `summary <resolved> <dropped> <conflicts>` line, then one line per verdict in order: `resolved <name> <source> <digest>` (source a plain word — `unchanged` / `ours` / `theirs` / `agreed`), `dropped <name> <source>`, and `conflict <name> <base> <ours> <theirs>` (an absent side's digest a `-`).
- `SheetError = error{ Overflow }` — a projection is otherwise infallible; every field it reads was already proven by `merge`.

Every field is bounded (a name within its bound, a fixed source word, fixed-width digests), so `max_sheet_bytes` proves the whole page fits a fixed buffer; a too-small buffer refuses `Overflow` rather than truncating.

## The laws the witness proves on metal

- **THE SUMMARY LAW** — the page opens with the format line and a `summary <resolved> <dropped> <conflicts>` line carrying the three tallies.
- **THE RESOLVED LAW** — every resolved album appears in order with its source word and its digest.
- **THE DROPPED LAW** — every dropped album appears with the source that removed it.
- **THE CONFLICT LAW** — every conflict appears with its name and three digest fields; a change-vs-remove conflict prints the removing side as `-`.
- **THE ATOMIC LAW** — a too-small buffer refuses `Overflow`, nothing truncated.

## Honest scope

Software only, purely local — a bounded text render over in-process fields already proven whole by `merge`, siloed to `lotus/`. Content-addressing on the page, never a signature. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate — the signed carry that names *who made* a record remains the later crypto seam on Keaton's word. With this rung the merge tier carries its readable page at the library level; the album mirror is the next natural rung.
