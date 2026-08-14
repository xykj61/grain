# HUNK73 — a part row: the picture beside its honest facts, on glass

**Stamp:** `20260813.232756` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK73
**Kin:** [`../image/part_catalog.rye`](../image/part_catalog.rye) (HUNK71 facts) · [`../pond/apps/part_store.rye`](../pond/apps/part_store.rye) (HUNK72 content-addressed) · [`../brushstroke/sprite_shelf.rye`](../brushstroke/sprite_shelf.rye) (HUNK38/39 swatch shelf) · [`double-seat-expansion`](20260813-020035_double-seat-expansion-six-seasons.md)

---

## Why this rung

HUNK71 bound honest facts beside each window — a part is a picture **plus** a part number, a material, and a price. HUNK72 gave the whole catalog a content address, so a marketplace reproduces from cold. Yet no rung had let a keeper **see** a part the way McMaster-Carr shows one: the picture beside the facts, in one reading. HUNK38/39 painted a `SpriteIndex` shelf — name beside a thumbnail swatch — but a `SpriteIndex` carries no facts; the price and the part number never reached the glass.

This rung is that reading. `part_shelf` paints a whole `PartCatalog`, one row per part: the product's **thumbnail swatch** at the right (HUNK38/39's idiom, the product's real colors down-mapped from the one shared sheet) and a **fact line** at the left — `<name>  <part#>  <material>  $D.CC` — so a keeper reads picture and facts together, every part drawn from the ONE decoded sheet.

## The crux

The durable property is **no drift between the stored facts and the painted row**: the cells a keeper reads spell exactly the facts the catalog holds, and the price renders as **exact dollars-and-cents** (845 cents → `$8.45`, never a rounded float — money is a `u64` count of the smallest honest unit, formatted, never moved). A tampered or absent fact cannot hide behind a pretty row, because the row is drawn from `facts_at` and `entry(i).name` directly.

## Shape

- `format_price(cents, buf) -> len` — a `u64` cents count to `$D.CC`, the cents always two digits, the dollars exact and unbounded-width within the buffer. No float, no division loss.
- `format_fact_line(name, facts, buf) -> len` — `<name>  <part#>  <material>  $D.CC` into a bounded buffer (`max_fact_line`).
- `part_shelf(allocator, cat, cols, rows) -> Grid` — one row per part: the fact line at the left (truncated to the label region so it never overwrites the swatch), the thumbnail swatch at the right. Refuses `ShelfTooSmall` when a grid has fewer rows than parts (every part or none), `RowTooNarrow` when a row cannot hold a fact cell plus a swatch, `EmptyShelf`/`ShelfTooLarge` on the dimension edges — the `sprite_shelf` refusal family, reused honestly.

## Boundaries

Pure composition over public APIs — no new storage, no new codec, no new palette, no new failure class the shelf family did not already name. **Price is a recorded fact, formatted for reading; it is never a balance the tree can move** (custody gate #3 untouched). No network, no key, no funds.

*May a keeper read the whole part in one glance — the picture true to the sheet, the price true to the cent.*
