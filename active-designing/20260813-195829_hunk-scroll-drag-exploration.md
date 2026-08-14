# HUNK44 — the drag seam: a touch drag in pixels becomes line deltas over the cell height

**Stamp:** `20260813.195829` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** A (Hardware & Right-to-Repair) · **Waymark:** HUNK · rung **HUNK44**
**Kin:** [`preset_scroll.rye`](../pond/apps/preset_scroll.rye) (HUNK40 cursor) · [`preset_scroll_input.rye`](../pond/apps/preset_scroll_input.rye) (HUNK43 input seam) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the scroll surface stands

HUNK40 gave a pure `ScrollCursor` whose every gesture clamps at both ends. HUNK43 raised the input seam above it: `apply(cursor, Input)` turns a raw event — a signed *line* delta, a page key, an edge key — into exactly one cursor move. The one thing HUNK43 assumes is that the delta already arrives **counted in lines**: a wheel notch is one line, a Page-Down is one page.

A real touch surface does not speak in lines. A finger drag arrives **counted in pixels**, and a row of the library is some number of pixels tall — a Skate cell height, a glyph height. The seam that turns a pixel drag into a line delta is missing, and it is the layer directly above HUNK43 that every touch scroll surface has.

## The crux — the carried remainder

The naïve conversion loses a slow drag. A touch device reports the drag as a stream of small pixel deltas; if each event divides by the cell height and drops the remainder, a drag of three pixels at a time over a ten-pixel cell never scrolls at all — every event floors to zero. The crux is a **carried remainder**: the seam holds a signed residual pixel accumulator, and each fed pixel delta adds into it; whole cells that the running total crosses become the line delta, and the sub-cell remainder **stays** to accumulate with the next event. So four three-pixel drags over a ten-pixel cell scroll exactly one line on the fourth, and the leftover two pixels wait for the fifth.

That is the whole durable idea, and it is Lindy — every pixel-quantizing scroll surface, on any device, needs exactly this accumulator. Below it is HUNK43's already-proven routing; the seam invents no clamp and no new refusal, only the pixel→line quantization with a bounded carry.

## Shape

`pond/apps/preset_scroll_drag.rye`:

- `DragScroll { residual: i32, cell_px: u32 }` — a small quantizer holding the carry and the cell height. `open(cell_px)` refuses `BadCellHeight` on a zero or absurd (`> max_cell_px`) cell.
- `feed(self, pixels: i32) i32` — add `pixels` to the residual (in `i64`, so an `i32`-min delta added to a negative residual never wraps), take the whole-cell quotient as the returned line delta (`@divTrunc`), keep the remainder as the new residual (`@rem`, magnitude strictly below `cell_px`). The governing invariant: **`total == lines·cell_px + residual` and `|residual| < cell_px`** after every feed — a bounded carry that never grows.
- `drag(cursor, self, pixels)` — the composition: `feed` the pixels to a line delta, then `preset_scroll_input.apply(cursor, Input.scroll_by(lines))`, so a pixel drag drives the HUNK40 cursor through the HUNK43 seam with every clamp inherited. Returns the line delta it applied.

Direction convention stays HUNK43's: a positive pixel delta scrolls the content down. A natural-scrolling surface negates the device delta at its own edge; this module is a pure, direction-agnostic pixel→line quantizer.

## What it proves on metal

Over the same real five-book library the HUNK40/43 selftests build, driven through a two-row viewport:

- A single drag of two full cells scrolls exactly two lines; the reverse drag walks back — reversible.
- **The carry accumulates:** four sub-cell drags (three pixels each over a ten-pixel cell) scroll zero, zero, zero, then **one** line — the remainder was never lost.
- The residual stays bounded (`|residual| < cell_px`) after every feed in a long mixed stream.
- An `i32`-min pixel delta added to a negative residual quantizes cleanly — no wrap before the divide.
- The composed `drag` clamps at both ends exactly as HUNK43 does (a huge fling lands on the bottom-pinned page, never past it), and a library that fits the screen never moves whatever the drag.

## Not this rung

- A **velocity fling** (momentum decay after the finger lifts) is a real later gesture — named, not built; it wants a timer the pure seam does not hold.
- A **pinch-zoom** of the cell height is a different axis entirely.
- The **served-marketplace module-assembly ruling** (the HUNK39 checkpoint) stays held for Keaton's word.

*A drag is only pixels until a cell height gives it meaning; the carried remainder is what lets a slow, honest hand move the page at all.*
