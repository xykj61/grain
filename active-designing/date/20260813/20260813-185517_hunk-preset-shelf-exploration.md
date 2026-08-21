# HUNK36 — a keeper reads their installed library as a shelf on glass

**Stamp:** `20260813.185517` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- self-approved design round · **Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · Photos-app journey · rung **HUNK36**
**Kin:** [`../pond/apps/preset_detail.rye`](../pond/apps/preset_detail.rye) (HUNK35) · [`../brushstroke/skate_grid.rye`](../brushstroke/skate_grid.rye) · [`../brushstroke/preset_preview.rye`](../brushstroke/preset_preview.rye) (HUNK33)

## Where the road stands

HUNK35 gave a keeper an honest detailing of their installed filter books — every book's name and the names of the presets it holds, read from a verified reopen, refusing the whole detailing when a book cannot be honestly reopened. That detailing travels as text; a keeper cannot yet *see* it on glass. HUNK35 named this as its first horizon — the Skate view of the detail, a book shown as a shelf of named chips.

By Lindy-first, crux-first that view is the next crux: the library is read every time a keeper opens the Photos app, the effort compounds, and it composes two already-proven seams — HUNK35's honest detailing and HUNK2/HUNK33's Skate grid — rather than inventing a new pipeline. The honesty is already earned upstream: the shelf is a *pure view* of an already-honest detailing, so it can add no new way to lie.

## The keystone (HUNK36)

`pond/apps/preset_shelf.rye`, rendering a `preset_detail.DetailListing` onto a Skate `Grid`:

- `shelf_grid(allocator, listing, cols, rows)` — one row per installed book, each row reading `<name>  <preset…>` so a keeper sees the whole library at a glance. The book name wears a real palette slot (`put_color_run`) so it stands out as a chip against its presets. Returns the built grid.
- The shelf is **pure over the detailing**: it reads the listing many times and touches it never, so building twice yields identical cells and colors (deterministic), and the underlying detailing is unchanged.

## The property this rung earns

A view must never quietly hide a book. `shelf_grid` refuses `ShelfTooSmall` when the grid has fewer rows than the detailing has books — rather than silently dropping the books past the last row, it refuses, so a rendered shelf always shows *every* installed book or none. This is the display-side echo of HUNK35's whole-detailing honesty: upstream never advertises a phantom, and downstream never omits a real one.

## The properties the witness proves

1. **One row per installed book** — a detailing of two books renders to a grid whose first two rows carry those books, in held order.
2. **Names and presets shown** — row `i`'s cells contain the book's name and each of its preset names (the stock row carries `vivid … sketch`).
3. **The name is a chip** — the book-name cells wear a non-sentinel foreground slot, distinct from the presets beside them.
4. **Pure and deterministic** — building the shelf twice yields identical cells and foreground indices; the detailing is untouched.
5. **Genuinely seen** — the shelf rasterizes to a lit canvas.
6. **Never hides a book** — a grid with fewer rows than books refuses `ShelfTooSmall`; a zero dimension refuses `EmptyShelf`; an over-ceiling dimension refuses `ShelfTooLarge`.

No network, no key, no funds — a shelf reads the detailing and paints a grid, storing nothing.

## Horizons (named, not half-built)

- The scrollable shelf — a viewport over a library larger than the grid's rows (a bounded window, not a silent truncation).
- Each row carrying its book's preset *count* as a right-aligned column, the detailing's number shown beside its names.
- The served shelf — a Comlink-served library view (stops at the Comlink-served custody gate).
