# HUNK43 — the input seam: a keeper's raw gesture drives the cursor

**Stamp:** `20260813.195500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read (self-approved round) · **Season A** · waymark **HUNK** · rung **HUNK43**
**Kin:** [`pond/apps/preset_scroll.rye`](../pond/apps/preset_scroll.rye) (HUNK40 cursor) · [`pond/apps/preset_scroll_view.rye`](../pond/apps/preset_scroll_view.rye) (HUNK42 surface)

---

## Where the ladder stands

HUNK40 gave a pure `ScrollCursor` whose gestures — `line_down`, `line_up`, `page_down`, `page_up`, `to_top`, `to_bottom` — each clamp at both ends. HUNK42 painted the cursor's page beside a live scroll bar. What is missing is the **boundary above the cursor**: the translation from a raw input event — a wheel notch, a drag delta, a Page-Down key, a Home/End key — into exactly one cursor move. Every real gesture source speaks in signed deltas and named keys, not in the cursor's own verbs.

## The crux this rung takes

A pure `apply(cursor, input)` that maps one input event to one cursor move, preserving every clamp guarantee the cursor already holds — a fling of ten thousand lines past the end still lands on the bottom-pinned page, and a signed delta at the `i32` extremes never under/overflows before the clamp. It composes HUNK40 exactly, inventing no new storage and no new render.

## The shape

- `InputKind` — `scroll` (a signed line delta, `+` down / `−` up), `page_down`, `page_up`, `to_top`, `to_bottom`.
- `Input { kind, lines }` — `lines` read only for `scroll`.
- `apply(cursor, input)` — routes each kind to the matching cursor gesture; for `scroll`, the sign picks the direction and the magnitude the line count, the magnitude taken in `i64` and capped into `u32` range so even `i32` min can never wrap before the cursor's own clamp.

The reward: a keeper's raw gesture drives the viewport with the cursor's full safety — a page always lands somewhere real, and no adversarial delta can move the offset off the ends.

## What the witness proves

Over a real five-book, two-row viewport: a positive scroll delta walks down and a negative one up, both reversible; a huge positive delta clamps to the bottom-pinned offset and a huge negative one to the top, without wrap; `i32` min and max as deltas both clamp cleanly; the page/edge kinds match the cursor's own gestures; a library that fits never moves whatever the input. No network, no key, no funds.

*May every hand that reaches the glass find the page it meant, and never fall off the end.*
