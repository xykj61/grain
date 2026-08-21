# Fill ALES227 — Lotus library_sheet: a keeper's whole catalog as a readable page

**Stamp:** `20260815.142207` · **Voice:** Kyri · **Style:** Radiant · **Status:** Vision -- Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES227**
**Kin:** [`../lotus/library_manifest.rye`](../lotus/library_manifest.rye) (ALES226 — the opened content-address this reads) · [`../lotus/album_sheet.rye`](../lotus/album_sheet.rye) (ALES225 — the readable-projection idiom this mirrors one level up) · [`20260815-141539_fill-ales226-lotus-library-manifest.md`](20260815-141539_fill-ales226-lotus-library-manifest.md)

## The crux

ALES226 sealed a keeper's whole catalog by content address, yet that record is a byte frame a *program* reads, not a page a *keeper* reads. Before opening any album, a keeper wants to see their body of work at a glance — how many records, and for each its name and its content-address digest, the short handle they cite, publish, or compare by. This rung draws that page.

The crux is the same quiet one the album sheet took at ALES225: a **projection, not a round-trip.** The library manifest (ALES226) is the sealed, verify-before-trust artifact; the sheet is the eye's version of it. It does not parse back — it needs no new frame, no new hash, only a bounded render over fields already proven whole by `open_library_manifest`. This completes the library level's two projections — the sealed content address and its readable page — the exact pair the album level carries (`album_manifest` · `album_sheet`).

## What ALES227 adds

`lotus/library_sheet.rye`, a pure render over ALES226's opened `LibraryManifest`:

- `render_sheet(lm, out) → u32` — write a `format lotus-library-sheet-v1` header line, a `library <count>` line, then one `album <i> <name> <digest>` line per album in order. Every field is bounded (a u32 index, a name within its bound, a fixed-width 64-hex digest), so the whole page is proven to fit a fixed buffer; a too-small buffer refuses `Overflow` rather than truncating.

`SheetError = error{ Overflow }` — a projection is otherwise infallible; every field it reads was already proven by `open_library_manifest`.

## The laws the witness proves on metal

- **THE LISTING LAW** — every album appears in order with its name and its full 64-hex content-address digest.
- **THE HEADER LAW** — the page opens with the format line and a `library <count>` line.
- **THE EMPTY LAW** — a zero-album library renders exactly the two header lines and no album line.
- **THE ATOMIC LAW** — a too-small buffer refuses `Overflow`, nothing truncated.

## Honest scope

Software only, purely local — a bounded text render over in-process fields, siloed to `lotus/`. No real file, no DAC, no acoustic fact, no network, no funds, no real device. Content-addressing on the page, never a signature. No custody gate.
