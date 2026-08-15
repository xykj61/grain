# Fill ALES234 — Lotus library_merge: two independent sets of changes, reconciled

**Stamp:** `20260815.145638` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES234**
**Kin:** [`../lotus/library_diff.rye`](../lotus/library_diff.rye) (ALES229 — what changed between two catalogs) · [`../lotus/library_find.rye`](../lotus/library_find.rye) (ALES228 — the find / digest_of resolve this composes on) · [`../lotus/library_manifest.rye`](../lotus/library_manifest.rye) (ALES226 — the three opened catalogs this reconciles) · [`20260815-143152_fill-ales229-lotus-library-diff.md`](20260815-143152_fill-ales229-lotus-library-diff.md)

## The crux

ALES229 answered *what changed* between two versions of a catalog. Yet a diff only ever compares two. The honest next question a body of work asks the moment more than one hand touches it is *what happens when two keepers change the same catalog independently* — one remasters a record while the other retires a demo and adds a new single. A diff cannot answer that; a **merge** can, and a merge is the whole reason a diff exists.

This rung seats the canonical **three-way merge**: given a common ancestor `base` and two descendants `ours` and `theirs`, reconcile every album into one verdict. The crux is that a merge is not a guess — it is a decision procedure that composes on the same ALES228 resolve the diff already uses, per album name:

- where **only one side changed** an album, the merge takes that change — clean;
- where **both sides made the same change** (the same new digest, or both removed it), the merge takes it and marks it agreed — clean;
- where **both sides changed the same album to different content** (or one changed it while the other removed it), the merge **names a conflict** carrying all three digests — never silently resolved.

The content-address digest is again the whole comparison — two matching digests mean identical bytes, two differing digests mean the record moved — so the merge needs no byte compare and no new hash, only the handles the three manifests already carry. It stands beside `library_diff`, both second-order primitives over the same `find` resolve; a merge is two diffs reconciled against one base.

## What ALES234 adds

`lotus/library_merge.rye`, a pure, infallible classification over three opened `LibraryManifest` values:

- `merge(base, ours, theirs) → Merge` — visit every distinct album name across the three catalogs exactly once (base in order, then ours-only, then theirs-only), classify each by the three-way rule, and sort it into one of three lists.
- `Merge` — `resolved` (albums the merged catalog holds, each with its chosen `digest` and a `Source`), `dropped` (albums the merge removes, with the `Source` that removed them), and `conflicts` (albums the two sides disagree on, each carrying `base_digest` · `our_digest` · `their_digest`, `""` where a side lacks the album).
- `Source = enum { unchanged, ours, theirs, agreed }` — which hand a clean verdict came from: `unchanged` (neither side touched it), `ours` / `theirs` (one side's change taken), `agreed` (both sides made the same change).
- `is_clean(merge) → bool` — true when no album conflicts, so a caller tells a clean merge from one that needs a keeper's eye without walking the lists.

Every list is bounded by a named ceiling drawn from `max_albums` (`resolved` and `conflicts` by the union of two catalogs' albums, `dropped` by one catalog's), so the classification can never overflow and always terminates. No new hash, no new frame — a read over fields `open_library_manifest` already proved whole.

## The laws the witness proves on metal

- **THE CLEAN LAW** — when each album is changed by at most one side, the merge takes every change with zero conflicts, and each resolution names the hand it came from (`ours` / `theirs`); a one-sided removal drops the album cleanly.
- **THE AGREEMENT LAW** — when both sides make the same change to an album (identical new digest, or both remove it), the merge is clean and marks the verdict `agreed`.
- **THE CONFLICT LAW** — when both sides change the same album to different digests, or one changes it while the other removes it, the album is named a conflict carrying base, our, and their digests (`""` for a side that lacks it), never silently resolved.
- **THE UNTOUCHED LAW** — an album neither side changed resolves with source `unchanged` and its base digest.
- **THE IDENTITY LAW** — `merge(base, base, base)` resolves every album `unchanged`, with zero drops and zero conflicts.

## Honest scope

Software only, purely local — a bounded classification over in-process fields already proven whole by `open_library_manifest`, siloed to `lotus/`. Content-addressing on every handle it reports, never a signature: it reconciles *what* two hands changed, not *who* made a change — the signed carry that names authorship remains the later crypto seam on Keaton's word. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate. With this rung the library level grows from *reading* a catalog's history to *reconciling* it — the first Lotus primitive that composes three catalogs at once, the shape collaboration grows in.
