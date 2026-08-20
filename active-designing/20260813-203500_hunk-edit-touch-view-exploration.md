# HUNK — the touchable Photos editor: a gesture edits, the view repaints, from one cursor

**Stamp:** `20260813.203500` · **Status:** Mixed -- Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-202710_hunk-edit-input-seam-exploration.md`](20260813-202710_hunk-edit-input-seam-exploration.md) — HUNK48's gesture seam
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`../image/edit_input.rye`](../image/edit_input.rye) · [`../image/edit_cursor.rye`](../image/edit_cursor.rye) · [`../brushstroke/edit_preview.rye`](../brushstroke/edit_preview.rye) · [`../pond/apps/preset_touch_view.rye`](../pond/apps/preset_touch_view.rye)

---

## Why this round, now

The Photos app now holds both halves of the editing loop, still uncoupled. HUNK48 gave the **input** half — a raw gesture (`commit` a verb, `undo`, `redo`) becomes exactly one `EditCursor` move. HUNK13 gave the **render** half — an edit-list replayed over a source and down-mapped to a Skate grid a keeper *sees*. A device wants one surface it touches and watches change: a tap edits, a swipe walks the history, and the picture on glass is always the image the gesture just produced.

This is the exact parallel of HUNK47, which closed the *scroll* loop by binding the touch session and the painted view to one shared cursor. Reading **Lindy-first, crux-first**, the touchable editor is the capstone crux of the Photos interaction story — read every time a keeper edits, composing only proven parts, and closing the arc symmetrically with the browse arc. It lives in `brushstroke/` beside `edit_preview.rye` and `cursor_preview.rye`, which already bind the cursor and the down-map cleanly across the assembly.

## The crux

> **A gesture and the picture share one cursor: `gesture` mutates the `EditCursor`, `paint` renders exactly that cursor's applied prefix through the down-map — so the image a keeper sees can never drift from the edit history, structurally. A commit shows the new edit, an undo shows the earlier image, a redo the later one; the same one-graph discipline the Realidream editor and view share, carried to the touch surface.**

## The shape

`brushstroke/edit_touch_view.rye`:

- `EditTouchView { cursor: EditCursor, cols: u32, rows: u32 }` — one owned history and the grid it paints onto.
- `open(cols, rows)` — validate the grid against the down-map's own ceiling (`image_skate.max_map_cols`/`rows`), refusing `BadView` on a zero or over-ceiling dimension so `paint` can never be handed a grid the down-map would reject.
- `gesture(g)` — delegate to `edit_input.apply(&cursor, g)`, the whole clamp discipline inherited (both edges no-op, a fresh commit forgets the redo tail, the list ceiling refuses `TooManyEdits`).
- `paint(allocator, source)` — `edit_preview.preview(source, cursor.applied(), cols, rows)`: always the down-map of exactly the prefix the cursor stands on. Pure — the source is never mutated, and `paint` reads the cursor without moving it.
- `depth()` — the undo depth, for a caller's affordance.

## What the witness proves on metal

An 8×8 two-tone image on a real grid: a fresh view paints the plain source (the left cell red); a `commit(flip_h)` gesture makes the next paint show the flipped image (the left cell blue) — the picture tracks the gesture; an `undo` gesture returns the paint to the source; a `redo` returns it to the flip; `paint` equals a direct `edit_preview.preview` of `cursor.applied()` cell-for-cell (no drift); two paints are byte-identical and the cursor is unmoved by painting (pure); a bad grid refuses `BadView` at open; and a committed out-of-bounds crop surfaces `OutOfBounds` through paint's fold — no new failure mode invented. HUNK48 and HUNK13 GREEN beneath.

## Where this journey goes next (named intent, not yet built)

- **The finger surface proper.** Bind a raw touch (a tap on a gesture strip, a swipe left/right) to `gesture`, as HUNK46 turned finger events into scroll moves — the last mile to a real device.
- **A gesture stream that travels.** Record the raw gesture session content-addressed, so a keeper's whole edit reproduces from a name (composes HUNK12's edit store).

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The move is HUNK48's `apply`; the picture is HUNK13's `preview`; the history is HUNK16's cursor. No new arithmetic, storage, or render primitive.
- **Bounds, widths, asserts.** `u32` grid dimensions bounded at open by the down-map's ceiling; ≥2 positive invariants per function (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a pure surface over proven seams.
