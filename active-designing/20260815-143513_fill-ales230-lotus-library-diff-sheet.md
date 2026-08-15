# Fill ALES230 — Lotus library_diff_sheet: what changed, as a readable page

**Stamp:** `20260815.143513` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES230**
**Kin:** [`../lotus/library_diff.rye`](../lotus/library_diff.rye) (ALES229 — the classified `Diff` this draws) · [`../lotus/library_sheet.rye`](../lotus/library_sheet.rye) (ALES227 — the readable-projection idiom this mirrors) · [`20260815-143152_fill-ales229-lotus-library-diff.md`](20260815-143152_fill-ales229-lotus-library-diff.md)

## The crux

ALES229 classified two catalog versions into added, removed, and changed — the honest answer to *what changed since yesterday's catalog.* Yet that answer lives in a `Diff` struct a program reads, not a page a keeper reads. A keeper wants to *see* the change at a glance: which records arrived, which retired, which were remastered, and how many stood still.

This rung draws that page — the same quiet move the library sheet took over a manifest (ALES227): **a projection, not a round-trip.** The `Diff` is the computed verdict; the sheet is the eye's version of it. It parses back to nothing — it needs no new frame, no new hash, only a bounded render over fields the classification already proved total. It completes the diff's usefulness the way `album_sheet` completed the album manifest's and `library_sheet` completed the library manifest's: every catalog primitive earns its readable page.

## What ALES230 adds

`lotus/library_diff_sheet.rye`, a pure render over ALES229's `Diff`:

- `render_sheet(diff, out) → u32` — a `format lotus-library-diff-sheet-v1` header, a `summary <added> <removed> <changed> <same>` line, then one line per moved album in order: `added <name> <digest>`, `removed <name> <digest>`, and `changed <name> <old_digest> <new_digest>`. Every field is bounded (a name within its bound, fixed-width 64-hex digests), so the whole page fits a fixed buffer; a too-small buffer refuses `Overflow` rather than truncating.

`SheetError = error{ Overflow }` — a projection is otherwise infallible; every field it reads was already proven by `classify`.

## The laws the witness proves on metal

- **THE SUMMARY LAW** — the page opens with the format line and a `summary <added> <removed> <changed> <same>` line carrying the four tallies.
- **THE MOVED LAW** — every added, removed, and changed album appears in order with its name and full digest(s); a changed line carries both the old and the new digest.
- **THE QUIET LAW** — an unchanged album (counted `same`) appears in no album line; only the summary counts it.
- **THE ATOMIC LAW** — a too-small buffer refuses `Overflow`, nothing truncated.

## Honest scope

Software only, purely local — a bounded text render over in-process fields already proven whole, siloed to `lotus/`. Content-addressing on the page, never a signature. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate — the signed carry that names *who made* a catalog remains the later crypto seam on Keaton's word.
