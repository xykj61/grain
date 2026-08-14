# HUNK81 — the part detail page: a tapped ref paints the picture above its full facts

**Stamp:** `20260814.002316` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK81
**Kin:** [`../brushstroke/part_tap.rye`](../brushstroke/part_tap.rye) (HUNK80 the tap that returns a `PartRef`) · [`../brushstroke/part_row.rye`](../brushstroke/part_row.rye) (HUNK73 fact-line + swatch helpers) · [`../brushstroke/image_skate.rye`](../brushstroke/image_skate.rye) (down-map)

---

## Why this rung

HUNK80 closed the marketplace loop up to the tap: a keeper narrows the shelf, touches a result, and the surface returns a `PartRef` — the part's index, name, and honest facts. Yet the tap opens onto nothing to *see*. A shelf row is a one-line glance (a fact line and a thumbnail swatch, all on one row); a real catalog's detail page is larger — the picture bigger, each fact on its own line, room to read. This rung paints that page from the handle HUNK80 hands over, so the whole gesture arrives somewhere: search → tap → the part's own page.

## The crux

The durable property is **no drift between the page and the part** — the picture a keeper sees is the tapped part's own window into the one shared sheet, and each fact line reads exactly the fact the catalog holds, never a stale copy. `detail_page(cat, ref, cols, rows, pic_rows)` renders the part's window (`cat.render_part`, a fresh cut of the sheet), down-maps it into the top `pic_rows` of the page as solid colour blocks, and stacks the facts below — name, part number, material, and the exact `$D.CC` price, each on its own row. Because both the picture and every fact line read the same `PartRef` and the same catalog, the page can never show one product's picture beside another's price. The page composes with HUNK80 directly: a `PartRef` from `open_tapped_and` paints the detail of the very part the search narrowed to.

## Shape

`brushstroke/part_detail.rye`, pure painting over the surfaces already proven — no new storage, no codec, no funds:

- `detail_page(allocator, cat, ref, cols, rows, pic_rows) -> !Grid` — a fresh anchor-palette grid: the part's down-mapped picture filling the top `pic_rows` at full width, then the four fact rows (`name`, `part_number`, `material`, formatted `price`) beneath, each read straight from `ref`. Reuses `image_skate.down_map` for the picture (the same seam the thumbnail swatch uses, so the detail picture and the shelf swatch paint one product's colours by one law) and `part_row.format_price` for the price (so the detail price and the row price format identically).
- Refuses by name: `EmptyPage` on a zero dimension, `PageTooLarge` past the down-map ceiling, `EmptyPicture` on zero picture rows, and `PageTooShort` when the page cannot hold the picture and its four fact rows — so a page a keeper reaches always holds a whole part.

## Boundaries

The detail page holds no state and no funds — it reads a catalog and a `PartRef` and returns a grid. It moves nothing (custody gate #3 untouched), opens no network, holds no key. The price is a `u64` count of the smallest honest unit, **formatted for reading, never a balance the tree can move**. The picture is a fresh cut of the caller's own sheet; the fact lines borrow the `PartRef`, which borrows the caller's catalog — so the page reads live storage and never dangles.

*May a keeper's finger land on a part and the part rise to meet it — its picture whole, its facts plain and true, the page the whole search was reaching toward.*
