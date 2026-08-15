# Fill ALES238 — Lotus catalog_verify: a whole catalog proven whole, end to end

**Stamp:** `20260815.151716` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES238**
**Kin:** [`../lotus/library_manifest.rye`](../lotus/library_manifest.rye) (ALES226 — `verify_library`, the catalog level) · [`../lotus/album_manifest.rye`](../lotus/album_manifest.rye) (ALES224 — `open_album_manifest` + `verify_album`, the record level) · [`20260815-151215_fill-ales237-lotus-album-merge-sheet.md`](20260815-151215_fill-ales237-lotus-album-merge-sheet.md)

## The crux

The Lotus catalog family now stands whole — manifest · sheet · find · diff · diff_sheet · merge · merge_sheet, at both the record and the catalog level. Yet every verify to date proved *one* level: `verify_library` confirms each album's manifest digest matches the catalog; `verify_album` confirms each track's bundle digest matches a record. A keeper who holds a whole body of work — the library manifest, every album manifest, every bundle — wants *one* answer: is all of it whole, top to bottom?

The crux is that content-addressing already composes into a proof of the whole tree. The library digest binds each album manifest; each album manifest binds each bundle. So verifying a catalog end to end is walking *two levels of digests*, never re-hashing a mountain of audio into one number — a Merkle check the exact shape of the catalog itself. A flipped byte anywhere surfaces by name at the level it broke: a swapped album manifest at the catalog level, a single edited bundle two levels down at the record level. This rung composes the two existing verifies into that one deep check — pure composition over their public APIs, no new hash and no new frame.

## What ALES238 adds

`lotus/catalog_verify.rye`:

- `AlbumTree` — one album's whole tree in hand: its `name`, the sealed `album_manifest` bytes the catalog names, and the `tracks` (bundles) that album manifest in turn names.
- `verify_deep(lm, tree) → DeepError!void` — first the catalog level (`verify_library` over the tree's names and album-manifest bytes), then the record level (each album manifest opened verify-before-trust, then `verify_album` over its bundles). A match returns cleanly; any break refuses by the same name the single-level verify already uses.
- `DeepError = library_manifest.LibraryManifestError || album_manifest.AlbumManifestError` — the honest union of both levels, bounded by `max_albums` so the fixed working array cannot overflow.

## The laws the witness proves on metal

- **THE WHOLE-TREE LAW** — a catalog whose library manifest, album manifests, and bundles all agree verifies cleanly.
- **THE CATALOG-TAMPER LAW** — a whole album manifest swapped for a different (internally consistent) one refuses `AlbumDigestMismatch` at the catalog level, before the record level is walked.
- **THE RECORD-TAMPER LAW** — a single flipped bundle byte two levels down refuses `TrackDigestMismatch`; the album manifest still matches the catalog, so the fault can only surface at the record level.
- **THE NAME LAW** — a track renamed in hand (its bytes and digest unchanged) refuses `TrackNameMismatch`.
- **THE COUNT LAW** — a catalog missing an album refuses `CountMismatch`.

## Honest scope

Software only, purely local — a bounded walk over in-process bytes, siloed to `lotus/`. Content-addressing, never a signature: it proves a catalog arrived *whole*, not *who made it* — the signed carry remains the later crypto seam on Keaton's word. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate. With this rung the whole catalog family closes a loop: a body of work can be built, named, read, diffed, reconciled — and now proven whole, end to end.
