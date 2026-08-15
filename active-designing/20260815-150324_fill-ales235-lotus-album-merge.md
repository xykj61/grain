# Fill ALES235 — Lotus album_merge: two independent sets of record changes, reconciled

**Stamp:** `20260815.150324` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES235**
**Kin:** [`../lotus/library_merge.rye`](../lotus/library_merge.rye) (ALES234 — the three-way merge this mirrors one level down) · [`../lotus/album_diff.rye`](../lotus/album_diff.rye) (ALES232 — the sibling second-order primitive this stands beside) · [`../lotus/album_find.rye`](../lotus/album_find.rye) (ALES231 — the find / digest_of resolve this composes on) · [`20260815-145638_fill-ales234-lotus-library-merge.md`](20260815-145638_fill-ales234-lotus-library-merge.md)

## The crux

ALES234 seated the canonical three-way merge at the library level — two keepers' independent catalog changes reconciled against one base. Yet a record changes under more than one hand exactly as a catalog does: one engineer remasters the verse while another drops a rough take and adds a bridge, both from the same master, and the next morning the two edits must become one record. ALES232 answered *what changed* in a record; a diff compares only two, and a merge is the whole reason a diff exists.

This rung mirrors `library_merge` one level down (catalog → record, album → track), unchanged in shape. The three-way rule is identical: where **only one side changed** a track, take that change; where **both sides made the same change** (same new digest, or both removed it), take it and mark it agreed; where **both sides changed the same track to different content** (or one changed it while the other removed it), name a conflict carrying all three digests — never silently resolved. The content-address digest is again the whole comparison, so the merge needs no byte compare and no new hash — only the handles the three manifests already carry. It stands beside `album_diff`, both second-order primitives over the same `album_find` resolve.

## What ALES235 adds

`lotus/album_merge.rye`, a pure, infallible classification over three opened `AlbumManifest` values, exactly parallel to ALES234:

- `merge(base, ours, theirs) → Merge` — visit every distinct track name across the three records exactly once (base in order, then ours-only, then theirs-only) and classify each by the three-way rule.
- `Merge` — `resolved` (tracks the merged record holds, each with its chosen `digest` and a `Source`), `dropped` (tracks the merge removes, with the `Source` that removed them), and `conflicts` (tracks the two sides disagree on, each carrying `base_digest` · `our_digest` · `their_digest`, `""` where a side lacks the track).
- `Source = enum { unchanged, ours, theirs, agreed }` and `is_clean(merge) → bool`, as in ALES234.

Every list is bounded from `max_tracks` (`resolved` and `conflicts` by two records' worth, `dropped` by one), so the classification cannot overflow and always terminates. No new hash, no new frame.

## The laws the witness proves on metal

- **THE CLEAN LAW** — a track changed by at most one side is taken and names its hand (`ours` / `theirs`); a one-sided removal drops cleanly; zero conflicts.
- **THE AGREEMENT LAW** — both sides making the same change to a track reads `agreed`; both removing it drops `agreed`.
- **THE CONFLICT LAW** — both sides changing a track to different digests, or change-vs-remove, is named a conflict carrying base, our, and their digests (`""` for a side that lacks it).
- **THE UNTOUCHED LAW** — a track neither side changed resolves `unchanged` with its base digest.
- **THE IDENTITY LAW** — `merge(base, base, base)` resolves every track `unchanged`, with zero drops and zero conflicts.

## Honest scope

Software only, purely local — a bounded classification over in-process fields already proven whole by `open_album_manifest`, siloed to `lotus/`. Content-addressing on every handle, never a signature: it reconciles *what* two hands changed, not *who* made a change — the signed carry that names authorship remains the later crypto seam on Keaton's word. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. No custody gate. With this rung the merge tier stands at both levels — a record and a catalog each reconcilable under many hands, the shape collaboration grows in.
