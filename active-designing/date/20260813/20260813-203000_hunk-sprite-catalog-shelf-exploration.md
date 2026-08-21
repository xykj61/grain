# HUNK — the marketplace catalog painted as a paged shelf

**Stamp:** `20260813.203000` · **Status:** Mixed -- Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Open Image journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-201500_hunk-sprite-marketplace-index-exploration.md`](20260813-201500_hunk-sprite-marketplace-index-exploration.md) — the HUNK4–HUNK7 sprite-index quest, complete
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`../image/sprite.rye`](../image/sprite.rye) · [`../brushstroke/sprite_page.rye`](../brushstroke/sprite_page.rye) · [`../brushstroke/image_skate.rye`](../brushstroke/image_skate.rye) · [`../pond/apps/preset_shelf.rye`](../pond/apps/preset_shelf.rye)

---

## Why this round, now

The sprite quest built the one-sheet trick end to end: an index binds each product to a window (HUNK4), a single product renders and is *seen* on glass (HUNK5), the sheet is content-addressed (HUNK6), and the catalog travels as text (HUNK7). Yet a keeper still meets the marketplace one product at a time. The surface McMaster-Carr is actually known for — the fast *index page*, a scannable list of many products drawn from one sheet — is the missing durable crux.

Reading **Lindy-first, crux-first**: the catalog browse surface is the marketplace's front door, read far more often than any single product page, and it composes only proven parts — the sprite index (walk the catalog in held order), the down-map (each product's own colors), and the paging pattern the preset library already proved (`preset_shelf.rye`). No custody gate, no deferred web search; greenfield composition over green code.

## The crux

> **A catalog larger than the screen is fully browsable, one page at a time, each row a product's name beside a real color swatch drawn from that product's own window into the one sheet — every product reachable, none shown twice, none silently dropped.**

## The opening rung — HUNK38

`brushstroke/sprite_shelf.rye` — `catalog_shelf` renders a whole `SpriteIndex` onto a Skate grid, one row per product reading `<name>` at the left and a fixed-width color **swatch** at the right; the swatch wears the palette slot the product's window down-maps to (HUNK2's `image_skate.down_map` at 1×1 → the window's dominant anchor), so a keeper *sees* each product's color in the list, not only its name. `catalog_window(offset)` renders one page — the products `[offset, offset + rows)` — so a catalog past the screen is reachable a page at a time; `page_count` and `window_len` do the honest ceiling arithmetic. A shelf refuses `ShelfTooSmall` rather than drop a product past the last row (every product or none); a window refuses `BadOffset` past the catalog; both refuse `EmptyShelf` on a zero dimension, `ShelfTooLarge` past the map ceiling, and `RowTooNarrow` when the grid is too thin to hold a name and a swatch. Bounds named at construction; ≥2 positive invariants per function.

Two small additive seams land in `image_skate.rye` beneath it, each reused by any surface that tiles down-mapped thumbnails onto one grid: `set_anchor_palette(grid)` (point Skate at the block atlas and set a grid's palette to the fixed anchors — `down_map` refactored to call it, behavior identical) and `block_cell` made public (the full-block cell value a swatch paints). The 1×1 dominant swatch is robust for a window of any size — a block that spans the whole window can never empty — so the shelf never asserts on a small product; a later rung may enrich the swatch to a multi-cell strip.

The witness (`tools/hunk_sprite_shelf_witness.rish`) indexes four solid-color products into one tagged sheet and proves: each row's swatch wears exactly its product's color slot (red→3, green→4, blue→5, yellow→6), each row carries its product's name, paging covers every product once in held order, the shelf is pure and deterministic, and the five named refusals fire — with HUNK5's product page and HUNK2's down-map re-run GREEN beneath.

## Where this quest goes next (named intent, not yet built)

- **HUNK39 — the swatch enriched.** A multi-cell thumbnail strip per row (the window down-mapped to 1×N horizontal), so a product's shape reads, not only its dominant color.
- **HUNK40 — the catalog served.** The paged shelf over a sheet fetched content-addressed (HUNK6), so the browsed catalog is the exact bytes whose digest the index pins.

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The rows are the sprite index; the color is `down_map`; the paging is the shape `preset_shelf` already proved. No new storage, codec, or palette.
- **Bounds, widths, asserts.** `u32` in-memory coordinates and counts; every buffer names a maximum; positive invariants (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — sourcing real parts and hosting a real sheet are Season A's later, gated rounds.
