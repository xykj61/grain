# Fill ALES233 — Lotus album_diff_sheet: what changed in a record, as a readable page

**Stamp:** `20260815.144829` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES233**
**Kin:** [`../lotus/album_diff.rye`](../lotus/album_diff.rye) (ALES232 — the classified `Diff` this draws) · [`../lotus/library_diff_sheet.rye`](../lotus/library_diff_sheet.rye) (ALES230 — the readable-projection idiom this mirrors) · [`20260815-144541_fill-ales232-lotus-album-diff.md`](20260815-144541_fill-ales232-lotus-album-diff.md)

## The crux

ALES232 classified two record versions into added, removed, and changed — the honest answer to *what changed in this record since the last master.* Yet that answer lives in a `Diff` struct a program reads, not a page a keeper reads. A keeper wants to *see* the change at a glance: which tracks arrived, which were cut, which were remastered, and how many stood still.

This rung draws that page — the same quiet move library_diff_sheet took over the catalog diff one level up (ALES230): **a projection, not a round-trip.** The `Diff` is the computed verdict; the sheet is the eye's version of it. It parses back to nothing — it needs no new frame, no new hash, only a bounded render over fields ALES232 already proved total. It completes album parity: the record now carries content address · readable page · resolve · diff · **diff page**, exactly the working set the library level carries.

## What ALES233 adds

`lotus/album_diff_sheet.rye`, a pure render over ALES232's `Diff`:

- `render_sheet(diff, out) → u32` — a `format lotus-album-diff-sheet-v1` header, a `summary <added> <removed> <changed> <same>` line, then one line per moved track in order: `added <name> <digest>`, `removed <name> <digest>`, and `changed <name> <old_digest> <new_digest>`. Every field is bounded (a name within its bound, fixed-width 64-hex digests), so the whole page fits a fixed buffer; a too-small buffer refuses `Overflow` rather than truncating.

`SheetError = error{ Overflow }` — a projection is otherwise infallible; every field it reads was already proven by `classify`.

## The laws the witness proves on metal

- **THE SUMMARY LAW** — the page opens with the format line and a `summary <added> <removed> <changed> <same>` line carrying the four tallies.
- **THE MOVED LAW** — every added, removed, and changed track appears in order with its name and full digest(s); a changed line carries both the old and the new digest.
- **THE QUIET LAW** — an unchanged track (counted `same`) appears in no track line; only the summary counts it.
- **THE ATOMIC LAW** — a too-small buffer refuses `Overflow`, nothing truncated.

## Honest scope

Software only, purely local — a bounded text render over in-process fields already proven whole, siloed to `lotus/`. Content-addressing on the page, never a signature. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate — the signed carry that names *who made* a record remains the later crypto seam on Keaton's word. With this rung the album and library levels stand at full parity, each catalog primitive having earned its readable page.
