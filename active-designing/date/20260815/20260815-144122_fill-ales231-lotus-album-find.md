# Fill ALES231 — Lotus album_find: resolve a track by name in a record

**Stamp:** `20260815.144122` · **Voice:** Kyri · **Style:** Radiant · **Status:** Vision -- Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES231**
**Kin:** [`../lotus/album_manifest.rye`](../lotus/album_manifest.rye) (ALES224 — the opened `AlbumManifest` this reads) · [`../lotus/library_find.rye`](../lotus/library_find.rye) (ALES228 — the resolve idiom this mirrors one level down) · [`20260815-142750_fill-ales228-lotus-library-find.md`](20260815-142750_fill-ales228-lotus-library-find.md)

## The crux

ALES228 gave the *catalog* an index: a keeper reaches straight to the record they name rather than scrolling a discography. Yet one level down, the *record* is still only a scroll — the album manifest (ALES224) and the album sheet (ALES225) walk the tracks in order, top to bottom. A working creator reaching inside a record wants the same move the catalog already has: name the track, get its place and its citable handle. Every later per-track workflow — open THIS track's bundle, compare THIS track's digest across two masters, cite THIS one in a chain of custody — begins by resolving a name to the entry it points at.

This rung seats that resolve, so an album is an index a keeper reaches into, not only a scroll they read down. It is the exact shape of `library_find` (ALES228), lifted from a catalog of records to a record of tracks — the same `find` / `name_of` / `digest_of` lookup, unchanged, over `album_manifest.AlbumManifest` instead of `library_manifest.LibraryManifest`. It brings the album level to parity with the library level, so both carry their full working set (content address · readable page · resolve).

## What ALES231 adds

`lotus/album_find.rye`, a pure lookup over ALES224's opened `AlbumManifest`:

- `name_of(am, i) → []const u8` — the track name at index `i`, a slice into the opened manifest body.
- `digest_of(am, i) → []const u8` — the 64-hex Sha256 of the track's bundle at index `i` — the citable handle a resolve exists to hand back.
- `find(am, name) → ?u32` — the index of the track named `name`, or null when the record holds no such name. One ordered pass; a track name is unique within an album manifest, so the first match is the only match. A miss is a clean null, never a fault — absence and malformation are different answers, and the manifest was already proven whole by `open_album_manifest`.

No new frame, no new hash, no error union — a read over fields the seal already proved total.

## The laws the witness proves on metal

- **THE RESOLVE LAW** — a present name resolves to its index in order, and `digest_of` returns the exact digest the manifest holds for it (the citable handle).
- **THE ABSENCE LAW** — a name the record lacks returns null, never a wrong index and never a fault; a prefix of a present name still misses (the match is whole, not partial).
- **THE FIRST-MATCH LAW** — a null answer means every live track was compared, an ordered total pass, not an early stop.
- **THE EMPTY LAW** — a search over a zero-track record returns null for any name.

## Honest scope

Software only, purely local — a bounded lookup over in-process fields already proven whole, siloed to `lotus/`. Content-addressing on the handle it returns, never a signature: it points to a track, it does not prove who made one — the signed carry remains a later crypto seam on Keaton's word. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate.
