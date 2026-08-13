# HUNK40 — the scroll cursor: a live viewport offset from a keeper's gesture

**Stamp:** `20260813.192957` · **Status:** Living (design capture, self-approved) · **Voice:** Kyri · **Style:** Radiant
**Season:** A (Hardware & Right-to-Repair) · **Waymark:** HUNK · **Journey:** the marketplace / Photos-app surface
**Kin:** [`../pond/apps/preset_shelf.rye`](../pond/apps/preset_shelf.rye) (HUNK36–37 pager) · [`../image/edit_cursor.rye`](../image/edit_cursor.rye) (HUNK16 cursor idiom) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md)

---

## The crux this rung fixes

HUNK37 gave the installed-book shelf a **pager** — `shelf_window(offset)` renders the books `[offset, offset+rows)`, and walking page-aligned offsets covers the whole library, each book once. Yet nothing held **where a keeper's viewport currently sits**. A page number is a fact about the library; a *scroll offset* is a fact about the **reader** — the one live piece a scrolling surface needs and the pager alone cannot carry. HUNK39 named exactly this as the next agent-doable crux: *a live scroll offset from a keeper's gesture.*

The scroll cursor is to the shelf pager what HUNK16's `EditCursor` is to the edit-list: a **pure bounded state machine** that holds a position and moves it by gestures, clamping at both edges so it can never fall off the ends. It invents no storage and no new failure mode; it composes HUNK37's `shelf_window` and HUNK37's `window_len`.

## The one governing invariant (the tractable-hard core)

A viewport is **bottom-pinned**: a keeper can scroll until the last book sits at the bottom row, and no further — the surface never shows blank rows past the end of a library taller than the screen. So the cursor's whole law is

```
0 <= offset <= max_offset
max_offset = (count > rows) ? count - rows : 0
```

Every gesture preserves it by clamping. This is the crux: the clamp arithmetic must never underflow (scroll up past the top) nor overflow (scroll down past the bottom), and `max_offset` must pin the bottom exactly — a library that *fits* the screen (`count <= rows`) has `max_offset == 0`, so it never scrolls at all.

The reward the pager could not claim: **a scroll cursor's window never refuses.** Because `offset <= max_offset <= count - 1` whenever `count > 0` (and `offset == 0` on an empty library is the allowed empty first page), `shelf_window` at the cursor's offset can never hit `BadOffset`. The cursor is the guarantee that a keeper's gesture always lands on a real page.

## The gestures

- `line_down(k)` / `line_up(k)` — move by `k` rows, clamped. Line-granular (not page-aligned), so the bottom pins smoothly.
- `page_down` / `page_up` — move by a whole viewport (`rows`), the common key gesture.
- `to_top` — offset 0. `to_bottom` — offset `max_offset` (the last book pinned to the bottom row).
- `at_top()` / `at_bottom()` — booleans for a scrollbar hint.
- `window(allocator, listing, cols)` — the page a keeper currently sees, through HUNK37's `shelf_window`.

Line-granular over page-aligned is the richer, more Lindy behavior — every real scroll surface pins its bottom rather than snapping to page boundaries — and it composes cleanly with `shelf_window`, which accepts any in-range offset.

## What it reuses, invents, and refuses

- **Reuses:** HUNK37 `shelf_window` + `window_len` (the render and the visible count), HUNK35 `DetailListing` (the library it scrolls over).
- **Invents:** nothing stored. A cursor is `{ count, rows, offset }` — three `u32`, a place in a library.
- **Refuses:** `rows == 0` is a degenerate viewport (`EmptyViewport`); every other state is reachable and valid. No new render error — the whole point is that a cursor's window never refuses.

## Proof shape (the algebra it must obey)

1. A fresh cursor sits at the top (`offset 0`, `at_top`).
2. `line_down` walks the offset down one book at a time; `line_up` walks it back — a walk is reversible.
3. **Bottom-pinned:** `to_bottom` lands on `max_offset` and `at_bottom` is true; the window there shows the **last** `rows` books, the final book on the bottom row, no blank row.
4. **Clamp, never over/underflow:** scrolling up past the top stays at 0; scrolling down past the bottom stays at `max_offset`; a page jump past either edge clamps.
5. **A library that fits never scrolls:** `count <= rows` ⇒ `max_offset == 0`, every gesture a no-op, `at_top && at_bottom`.
6. **The window never refuses:** at every reachable offset, `shelf_window` returns a real page (never `BadOffset`) whose visible count matches `window_len`.
7. **Coverage:** paging the cursor from top to bottom by `page_down` shows every book (each at least once) — scrolling loses nothing, exactly as HUNK37's page walk proved for the pager.

## Home and assembly

`pond/apps/preset_scroll.rye` — beside `preset_shelf.rye` in the same assembly, so `DetailListing`, `shelf_window`, and the Skate grid are reached through one symlink root (no cross-assembly type-identity wall, the seam HUNK39 held for Keaton). Witness `tools/hunk_scroll_cursor_witness.rish`.

## HUNK41 addendum — the scrollbar thumb (additive, `20260813.193940`)

The cursor holds a keeper's position; a scrollbar *shows* it. `scroll_bar(cursor, track_len)` is a pure function over the cursor, additive on the same module (as HUNK37's pager was additive on `preset_shelf`), yielding a `ScrollBar { track, thumb_start, thumb_len }`:

- **Proportional length** — `thumb_len ≈ rows/count` of the track, floored at one row so it is always visible, capped at the track. A library that fits the viewport fills the whole track (nothing to scroll — the thumb *is* the track).
- **Edges pinned true** — at the top the thumb pins to `0`; at the bottom `thumb_start + thumb_len == track` exactly, so a keeper reads the ends without rounding drift. Interior positions are `offset/max_offset` of the leftover travel.
- **Monotone and always inside** — scrolling down never moves the thumb up, and `thumb_start + thumb_len <= track` at every reachable offset. Products run in u64 so no term wraps; a zero or over-ceiling track refuses `BadTrack`.

Witness `tools/hunk_scroll_cursor_witness.rish` extended (four scrollbar greps), GREEN; `tame_style_check` clean, width exit 0.

*A page number tells you about the book; a scroll offset tells you about the reader. May the viewport always land on a real page, the bottom always pin true, and the thumb always read a keeper home.*
