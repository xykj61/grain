# HUNK — the edit history as a filmstrip: every step a thumbnail, the cursor marked

**Stamp:** `20260813.211417` · **Status:** Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`edit_cursor.rye`](../image/edit_cursor.rye) — HUNK16's history · [`edit_preview.rye`](../brushstroke/edit_preview.rye) — HUNK13's preview · [`image_skate.rye`](../brushstroke/image_skate.rye) — HUNK2's down-map
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## Why this round, now

The finger arc (HUNK48–53) let a keeper walk the undo/redo history by swipe, and paints the one picture the cursor currently stands on. Yet a keeper reading a long edit sees only that one picture — never the whole road their photo took, nor which step they are on now. A photo app's filmstrip answers exactly that: the history laid out as thumbnails, the current step marked.

This composes only proven seams — HUNK16's cursor holds the history, HUNK13's `preview` paints the picture at any prefix, HUNK2's down-map turns it into a thumbnail, and HUNK53's own tiling places them side by side. It stays wholly within the brushstroke assembly (no cross-assembly store), so it is a clean, self-contained lap. Reading **Lindy-first, crux-first**, a visual edit history is a durable Photos primitive that every later navigation surface reads.

## The crux

> **The filmstrip shows every step of the history in order, each thumbnail the picture at exactly that many edits, and the marker names exactly where the cursor stands.** `filmstrip` replays the cursor for each step `k` in `0..=history` — step 0 the untouched source, step `k` the first `k` edits applied — down-maps each to a `tcols × trows` thumbnail, and tiles them into one grid with a marker row above wearing a solid block over the current step's band. No drift: thumbnail `k` equals a direct `edit_preview.preview` of the first `k` edits, cell-for-cell.

## The shape

`brushstroke/edit_filmstrip.rye`:

- `filmstrip(allocator, source, cursor, tcols, trows)` — the whole history as one grid, `steps·tcols` wide and `trows + 1` tall; refuses `FilmstripTooWide` when the tiled width would pass the map ceiling.
- `marker_slot` — the "you are here" color (white, anchor slot 2), a solid block over the current step's band.
- `max_film_cols` — the width ceiling (the down-map ceiling), so the tiled grid stays bounded at construction.

The prefix of the first `k` edits is built directly from the cursor's own list — no new storage, no history mutated.

## What the witness proves on metal

A two-tone source and a cursor holding two edits (`flip_h`, `flip_v`) rewound one step (live position 1): the filmstrip is a `6×3` grid of three steps (source, `flip_h`, `flip_h`+`flip_v`); each tile equals a direct `preview` cell-for-cell (no drift); the marker names step 1 as a solid block, the other bands blank; the strip rasterizes to a lit canvas; a fresh cursor paints a one-step strip marked at step 0; a too-wide filmstrip refuses `FilmstripTooWide`. HUNK16 cursor, HUNK13 preview, HUNK2 down-map GREEN beneath. No network, no key, no funds.

## Where this journey goes next (named intent, not yet built)

- **A tap on a filmstrip thumbnail jumps the cursor there.** Bind the finger geometry (HUNK50's cell index) to the filmstrip bands, so a tap on step `k` sets the cursor's position to `k` — the visual counterpart of the swipe walk.
- **The session that travels** — persist the whole editing session content-addressed (composes HUNK18) — reaches the pond/apps ↔ brushstroke assembly-identity seam REMEMBER holds for a design decision; named here, held for that decision.

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The history is HUNK16; the picture is HUNK13; the thumbnail is HUNK2; the tiling is HUNK53's. No new render primitive, no new storage.
- **Bounds, widths, asserts.** The strip bounded by `max_film_cols`, the history by `max_edits`, ≥2 positive invariants per function (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a pure read over proven seams; the cross-assembly store is named and held.
