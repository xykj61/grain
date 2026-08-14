# HUNK — the finger surface proper: a tap on a strip, a swipe left or right, becomes one edit gesture

**Stamp:** `20260813.204548` · **Status:** Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-203500_hunk-edit-touch-view-exploration.md`](20260813-203500_hunk-edit-touch-view-exploration.md) — HUNK49's touchable editor, which named this rung as its next crux
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`../image/edit_input.rye`](../image/edit_input.rye) · [`../pond/apps/preset_touch_scroll.rye`](../pond/apps/preset_touch_scroll.rye) · [`../brushstroke/edit_touch_view.rye`](../brushstroke/edit_touch_view.rye)

---

## Why this round, now

HUNK48 gave the edit arc a clean input seam — a raw gesture (`commit` a verb, `undo`, `redo`) becomes exactly one `EditCursor` move. HUNK49 bound that seam and HUNK13's preview to one cursor, so the picture on glass can never drift from the history. Both halves speak `edit_input.Gesture` — yet nothing yet turns a *finger* into one. A real touchscreen reports pixel coordinates, not verb tags; the device wants a driver that reads a landing point and a lift point and decides: was that a tap on a verb, a swipe back, or a swipe forward?

The scroll arc already closed exactly this last mile. HUNK46's `TouchScroll` turned finger down · move · up into live scroll-cursor motion. Reading **Lindy-first, crux-first**, the edit arc's own finger surface is the symmetric capstone — read every time a keeper edits by touch, composing only proven parts, and closing the editing story the same way HUNK46 closed the browsing one. HUNK49's design doc named it in plain words: *"Bind a raw touch (a tap on a gesture strip, a swipe left/right) to `gesture`, as HUNK46 turned finger events into scroll moves — the last mile to a real device."*

## The crux

> **A finger becomes an editing gesture: a keeper taps a **gesture strip** (a bounded palette of verbs, one cell each) to `commit` that verb, swipes left to `undo`, swipes right to `redo` — the raw down/up coordinates classified into exactly one `edit_input.Gesture` (or none), pure, so the same seam HUNK48 proved carries whatever the finger sends. No new arithmetic beyond a clamped delta and a cell index; no new refusal beyond the strip's own bounds.**

## The shape

`image/edit_touch_input.rye`:

- `max_strip: u32 = 16` — the most verbs one gesture strip holds; a keeper's palette is a handful, never thousands (TAME bound at construction).
- `EditTouch { strip: [max_strip]Edit, strip_len, cell_px, swipe_px, down_x, down_y, armed }` — the palette, the cell width and swipe threshold in pixels, and the transient landing point.
- `open(cell_px, swipe_px)` — validate both as positive, refusing `BadCell` / `BadSwipe`, so no later classification divides by a zero cell or reads a zero swipe.
- `bind(edit)` — append a verb to the strip, refusing `StripFull` at the ceiling; the strip is built once, left of the cursor.
- `finger_down(x, y)` — record the landing point and arm.
- `finger_up(x, y)` returns `?edit_input.Gesture` — classify the completed touch:
  - a horizontal travel of at least `swipe_px` to the left → `undo`; to the right → `redo` (a swipe wins over the landing cell — a drag is a walk, wherever it started);
  - otherwise a **tap**: the landing `x` picks cell `x / cell_px`; if that cell holds a verb, `commit` it; a tap off the strip (a negative `x` or past the last cell) fires nothing, returning `null`.
  The delta is taken in `i64` and clamped to `i32` so a wild jump never wraps.

The classifier is **pure**: it produces a gesture and touches no cursor. The caller pipes the gesture into HUNK48's `apply` — one layer reads the finger, one layer moves the history — exactly the boundary HUNK43 kept for scroll.

## What the witness proves on metal

A real 6×4 tagged image driven through an `EditCursor` by finger events over a three-verb strip (`flip_h` · `flip_v` · `rotate 1`) on a ten-pixel cell: a tap on the first cell commits `flip_h` and the viewed image is exactly that verb byte-for-byte (via `edit_cursor.view`); a tap on the third cell stacks `rotate 1`; a left swipe undoes to the earlier image recovered byte-for-byte; a right swipe redoes it forward; a tap off the right end of the strip fires nothing and the image is unchanged; a hard rightward drag from a verb cell reads as a `redo`, not that cell's commit (the swipe wins); a zero cell width and a zero swipe threshold each refuse at open by name. HUNK48 seam and HUNK16 cursor GREEN beneath.

## Where this journey goes next (named intent, not yet built)

- **The strip painted on glass.** Render the gesture strip as a Skate row a keeper reads before tapping (reusing HUNK2's down-map for each verb's chip), the finger surface and the painted view sharing HUNK49's cursor.
- **A gesture session that travels.** Record the raw finger session content-addressed, so a keeper's whole touch edit reproduces from a name (composes HUNK12's edit store).

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The gesture is HUNK48's `Gesture`; the move is HUNK48's `apply`; the image proof is HUNK16's `view`. No new arithmetic beyond a clamped delta and a cell index, no new storage, no new render primitive.
- **Bounds, widths, asserts.** `u32` strip bounded at `max_strip`; the delta clamped in `i64` to `i32`; `cell_px` / `swipe_px` positive at open; ≥2 positive invariants per function (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a pure classifier over proven seams.
