# Fill ALES229 — Lotus library_diff: what changed between two catalog versions

**Stamp:** `20260815.143152` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES229**
**Kin:** [`../lotus/library_find.rye`](../lotus/library_find.rye) (ALES228 — the `find` resolve this composes on) · [`../lotus/library_manifest.rye`](../lotus/library_manifest.rye) (ALES226 — the two opened catalogs this compares) · [`20260815-142750_fill-ales228-lotus-library-find.md`](20260815-142750_fill-ales228-lotus-library-find.md)

## The crux

ALES228 let a keeper reach into one catalog by name. Yet a body of work is not one snapshot — it grows. A keeper reseals their library the day they finish a record, retire a demo, or remaster an old one, and the honest question the next morning is *what changed since yesterday's catalog?* Answering it by eye means reading two whole sheets side by side; a keeper wants the difference named.

This rung names it: a bounded classification of two opened library manifests, a **before** and an **after**, into three honest verdicts — **added** (an album the after holds that the before did not), **removed** (one the before held that the after does not), and **changed** (a name in both whose content-address digest differs — the same record, resealed). Every other album is unchanged and needs no line.

The crux is that this **composes on the resolve, it does not re-walk from scratch.** Each classification is a `library_find.find` into the other catalog — name present or absent, digest same or different. The digest is the whole comparison: content-addressing already proved that two matching digests mean identical bytes and two differing digests mean the record moved. So a diff needs no new hash and no byte compare — only the handles the manifests already carry. It is the first Lotus rung to *stand on* another catalog primitive rather than beside it, which is the shape the level should grow in.

## What ALES229 adds

`lotus/library_diff.rye`, a pure classification over two opened `LibraryManifest` values:

- `Change = struct { name, old_digest, new_digest }` — one album present in both catalogs whose digest moved.
- `Diff = struct { added: [max]Entry, removed: [max]Entry, changed: [max]Change, plus counts, same_count }` — the whole verdict, every array bounded by `library_manifest.max_albums`.
- `classify(before, after) → Diff` — for each album in `after`, `find` it in `before`: absent ⇒ added, present-and-digest-differs ⇒ changed, present-and-equal ⇒ counted same; for each album in `before`, absent from `after` ⇒ removed. One ordered pass over each catalog; both are already bounded.

No new hash, no error union — the manifests were proven whole on open, and the arrays are bounded, so the classification is total and infallible.

## The laws the witness proves on metal

- **THE ADDED LAW** — an album in the after and not the before appears exactly once as added, with its digest.
- **THE REMOVED LAW** — an album in the before and not the after appears exactly once as removed, with its digest.
- **THE CHANGED LAW** — a name in both whose digest differs appears exactly once as changed, carrying both the old and new digest; a name in both with the *same* digest appears in none of the three lists and is counted same.
- **THE IDENTITY LAW** — a catalog diffed against itself yields zero added, zero removed, zero changed, and `same_count` equal to the album count.

## Honest scope

Software only, purely local — a bounded classification over in-process fields already proven whole, siloed to `lotus/`. Content-addressing on every handle it reports, never a signature. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate — the signed carry that names *who made* a catalog remains the later crypto seam on Keaton's word.
