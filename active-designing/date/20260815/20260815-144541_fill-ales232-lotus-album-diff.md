# Fill ALES232 — Lotus album_diff: what changed between two record versions

**Stamp:** `20260815.144541` · **Voice:** Kyri · **Style:** Radiant · **Status:** Vision -- Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES232**
**Kin:** [`../lotus/album_manifest.rye`](../lotus/album_manifest.rye) (ALES224 — the two opened `AlbumManifest` values this compares) · [`../lotus/album_find.rye`](../lotus/album_find.rye) (ALES231 — the resolve this composes on) · [`../lotus/library_diff.rye`](../lotus/library_diff.rye) (ALES229 — the classification this mirrors one level down) · [`20260815-144122_fill-ales231-lotus-album-find.md`](20260815-144122_fill-ales231-lotus-album-find.md)

## The crux

ALES231 let a keeper reach into one record by track name. Yet a record grows and changes — a keeper remasters a track, drops a rough take, adds a bonus cut, and reseals the album the same evening. The honest question the next morning is *what changed in this record since the last master?* ALES229 answered exactly that question one level up, for a catalog of records; this rung answers it one level down, for a record of tracks — a bounded classification of two opened album manifests, a BEFORE and an AFTER, into three verdicts: **added**, **removed**, **changed**, every other track unchanged (a `same` tally).

It composes on the ALES231 resolve exactly as library_diff composed on ALES228: each verdict is a `find` into the other record, and the track's content-address digest *is* the whole comparison — content-addressing already proved two matching digests mean identical bundle bytes and two differing digests mean the track moved, so a diff needs no byte compare and no new hash. This is the album level's own second-order primitive, standing *on* album_find rather than beside it — the shape the level grows in, now proven at both scales.

## What ALES232 adds

`lotus/album_diff.rye`, a bounded classification over ALES224's opened `AlbumManifest`:

- `Change` — a track present in both records whose content-address digest moved (`name` · `old_digest` · `new_digest`), slices into the two opened bodies.
- `Diff` — `added[]` / `removed[]` (`album_manifest.Entry`) and `changed[]` (`Change`), each bounded by `album_manifest.max_tracks`, plus a `same_count`.
- `classify(before, after) → Diff` — for each track in `after`, `album_find.find` it in `before`: absent means added, present-with-a-different-digest means changed, present-and-equal counts same; for each track in `before` absent from `after`, removed. One ordered pass over each record — both bounded on open, so the walk is total and the verdict infallible. Closing asserts prove the three after-tallies account for the whole after and no list overflows its bound.

No new hash, no new frame, no error union — a read over fields the seal already proved total.

## The laws the witness proves on metal

- **THE ADDED LAW** — an after-only track appears once as added, with its digest.
- **THE REMOVED LAW** — a before-only track appears once as removed, with its digest.
- **THE CHANGED LAW** — a name in both with a moved digest appears once as changed, carrying both the old and the new digest; an unchanged name appears in no list and is counted `same`.
- **THE IDENTITY LAW** — a record diffed against itself yields all zeros and a `same_count` equal to the track count.

## Honest scope

Software only, purely local — a bounded classification over in-process fields already proven whole, siloed to `lotus/`. Content-addressing on every handle it reports, never a signature: it names what moved, not who made it — the signed carry remains a later crypto seam on Keaton's word. No real file, no DAC, no acoustic or electrical fact, no network, no funds, no real device. No custody gate.
