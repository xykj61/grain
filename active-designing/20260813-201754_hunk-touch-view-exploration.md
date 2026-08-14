# HUNK47 — the touchable painted surface: the page scrolls under the finger, on glass

**Stamp:** `20260813.201754` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** A (Hardware & Right-to-Repair) · **Waymark:** HUNK · rung **HUNK47**
**Kin:** [`preset_scroll_view.rye`](../pond/apps/preset_scroll_view.rye) (HUNK42 painted view) · [`preset_touch_scroll.rye`](../pond/apps/preset_touch_scroll.rye) (HUNK46 touch session) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Two journeys that never met

The touch-scroll work grew along two arcs. One is **render**: HUNK40 the cursor, HUNK41 the scrollbar geometry, HUNK42 the page painted beside a live bar on one Skate grid. The other is **input**: HUNK43 the event seam, HUNK44 the pixel drag, HUNK45 the fling, HUNK46 the whole touch session. Each arc is proven, and each is complete — yet nothing has put them in the same hand. A device does not want a session *and* a view; it wants **one surface it touches and watches scroll**. This rung is that surface: the finger drives the cursor, and the same cursor is painted, so what a keeper sees on glass is exactly where their finger left the page.

## The crux — one cursor, driven and drawn

The property that makes a touchable surface honest is that **the picture cannot drift from the position**. HUNK46's session mutates a cursor; HUNK42's view paints a cursor. Bind them to the *same* cursor and the guarantee is structural: `paint()` is always `scroll_view` of the cursor the session just moved, so the painted top book, the visible rows, and the thumb's place on the bar all track the finger with no separate state to fall out of sync. It is the same one-graph discipline the Realidream editor and view share (BUHR), carried to the touch surface: input and picture are two readings of one cursor.

## Shape

`pond/apps/preset_touch_view.rye`:

- `TouchView { session, cursor, cols, bar_w }` — HUNK46's touch session, the one cursor both sides share, and the grid geometry. `open(count, rows, cell_px, friction_num, friction_den, cols, bar_w)` opens the cursor (HUNK40) and the session (HUNK46), validating cell height, friction, and the bar geometry once.
- `finger_down(y)` · `finger_move(y)` · `finger_up()` · `tick()` · `settle()` — the device events, each delegating to the session over the shared cursor.
- `paint(allocator, listing) !Grid` — render the current cursor through HUNK42's `scroll_view`, so the glass shows exactly where the finger left the page.
- `is_flinging()` · `is_idle()` — the phase a surface reads while deciding whether to keep ticking.

## What it proves on metal

Over the same real five-book library, a two-row viewport, a ten-pixel cell, a 24-wide grid with a 2-column bar:

- **The page tracks the finger:** at the top the painted row 0 is the first book and the thumb sits on the top bar cell; after a drag down the painted row 0 is a later book and the thumb has moved down the bar — the picture followed the finger.
- **A flick coasts on glass:** a flick settles the painted page bottom-pinned (the last book on the bottom row, the thumb on the bottom bar cell) — a keeper watches the list come to rest.
- **Picture never drifts:** `paint()` equals `scroll_view` of the session's own cursor at every step; two paints of the same state are byte-identical.
- Every clamp and refusal is inherited — a hard flick lands bottom-pinned on glass, and a bad bar or grid refuses at paint by name.

## Not this rung

- A **real display device loop** (a Wayland frame callback ticking the session) is the enclosure's job — named, not built; this surface is device-agnostic and takes its ticks from the caller.
- **Rubber-band overscroll** and **velocity smoothing** stay the named horizons from HUNK45/46.
- The **served-marketplace module-assembly ruling** (HUNK39 checkpoint) stays held for Keaton's word.

*Input and picture are two readings of one cursor; bind them to the same three counts and the glass can only ever show the truth of where the finger left the page.*
