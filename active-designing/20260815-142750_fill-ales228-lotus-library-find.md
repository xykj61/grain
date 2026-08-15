# Fill ALES228 — Lotus library_find: resolve an album by name in a catalog

**Stamp:** `20260815.142750` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES228**
**Kin:** [`../lotus/library_manifest.rye`](../lotus/library_manifest.rye) (ALES226 — the opened catalog this searches) · [`../lotus/library_sheet.rye`](../lotus/library_sheet.rye) (ALES227 — the readable page this makes usable) · [`../lotus/rack.rye`](../lotus/rack.rye) (ALES30 — the `find` / `name_of` lookup idiom mirrored one level up) · [`20260815-142207_fill-ales227-lotus-library-sheet.md`](20260815-142207_fill-ales227-lotus-library-sheet.md)

## The crux

ALES226 sealed a whole catalog by content address; ALES227 drew it as a page. Both walk the catalog in order — a keeper reads it top to bottom. Yet a working creator does not scroll a discography to cite one record; they name it. Every later Lotus workflow — open *this* album, compare *this* album's digest, publish *this* one — begins by resolving a name to the record it points at. Without that step, a large catalog is a scroll, not an index.

This rung seats the resolve: a bounded, ordered lookup that turns an opened `LibraryManifest` from a listing into an index. It is the smallest move that opens the rest — the primitive the album/compare/publish rungs stand on. The `find` / `name_of` idiom is already proven one level down in `rack.rye` (ALES30); this is that idiom lifted from a rack of clips to a catalog of records, unchanged in shape.

A miss is an **answer, not a fault.** A catalog that does not hold a name returns `null` — the honest optional the rack's own `find` returns — so a caller distinguishes *absent* from *malformed* without an error path. The manifest was already proven whole by `open_library_manifest`; the search reads only fields the seal verified.

## What ALES228 adds

`lotus/library_find.rye`, three pure reads over ALES226's opened `LibraryManifest`:

- `find(lm, name) → ?u32` — the index of the album named `name`, or `null` when the catalog holds no such name. One ordered pass; an album name is unique within a manifest, so the first match is the only match.
- `name_of(lm, i) → []const u8` — the album name at index `i`, a slice into the opened body (mirrors `rack.name_of`).
- `digest_of(lm, i) → []const u8` — the album's 64-hex content-address digest at index `i` — the citable handle a resolve exists to hand back.

No new frame, no new hash, no error union — a lookup over fields the manifest already proved whole.

## The laws the witness proves on metal

- **THE RESOLVE LAW** — a name present in the catalog resolves to its index in order, and `digest_of` at that index returns the exact digest the manifest holds for it.
- **THE ABSENCE LAW** — a name the catalog does not hold returns `null`, never a wrong index and never a fault.
- **THE FIRST-MATCH LAW** — the search compares every live album until it matches, and a `null` answer means every album was compared (an ordered, total pass).
- **THE EMPTY LAW** — a search over a zero-album catalog returns `null` for any name.

## Honest scope

Software only, purely local — a bounded lookup over in-process fields already proven whole, siloed to `lotus/`. Content-addressing on the handle it returns, never a signature. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate — the signed carry that names *who made* a catalog remains the later crypto seam on Keaton's word.
