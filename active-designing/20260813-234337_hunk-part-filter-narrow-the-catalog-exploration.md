# HUNK75 — narrow the catalog: filter a marketplace to the parts that match

**Stamp:** `20260813.234337` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK75
**Kin:** [`../image/part_catalog.rye`](../image/part_catalog.rye) (HUNK71 facts) · [`../pond/apps/part_store.rye`](../pond/apps/part_store.rye) (HUNK72 content-addressed) · [`../brushstroke/part_row.rye`](../brushstroke/part_row.rye) (HUNK73 shelf · HUNK74 paging) · [`double-seat-expansion`](20260813-020035_double-seat-expansion-six-seasons.md)

---

## Why this rung

HUNK71 gave each part its honest facts — a part number, a material, a price in cents. HUNK73 painted a whole catalog as a shelf, HUNK74 let a catalog larger than the screen page. Yet a real parts marketplace is not read front to back — it is *narrowed*. McMaster-Carr's whole art is the sidebar that turns a wall of a hundred thousand parts into the seven a keeper actually wants: *stainless only*, *under two dollars*, *part numbers that start with `HX`*. No rung had let a keeper narrow the catalog at all.

This rung is that narrowing. `filter_catalog` reads a whole `PartCatalog` and a `Query`, and builds a fresh sub-catalog holding exactly the parts that match — in held order, over the very same shared sheet — so the result is itself an ordinary `PartCatalog` that paints (`part_shelf`), pages (`part_window`), and round-trips (`render`/`parse`) by every law already proven. A filter is not a new kind of thing; it is a smaller catalog.

## The crux

The durable property is **the filter loses no match and admits no stranger**: every part whose facts satisfy the query reaches the sub-catalog exactly once, in the source's held order, and no part that fails the query appears. Two corollaries fall out for free and are worth asserting:

- **A match-all query reproduces the catalog** — same parts, same order, byte-for-byte the same rendered record. Narrowing by nothing loses nothing.
- **A match-none query yields a real empty catalog** — zero parts, zero pages, a shelf that paints an empty page rather than refusing. The empty result is a first-class catalog, not an error.

And because the result is a `PartCatalog`, a filter *composes*: filtering a filtered catalog narrows further, by the same function, with no special case.

## Shape

`image/part_filter.rye`, pure composition over `part_catalog`'s public API and `sprite`'s window read — no new storage, no new codec, no new palette:

- `QueryKind` — `material` (exact material), `number_prefix` (part number begins with the text), `price_at_most` (cents `<=` a ceiling), `price_at_least` (cents `>=` a floor). Four honest ways a keeper narrows a marketplace.
- `Query` — the kind plus its one operand: a bounded `text` (material or prefix) or a `u64` `price`. The text ceiling is `max_material_len` (the wider of the two token fields), so a query token can never outrun what a stored field could hold.
- `matches(cat, i, query) -> bool` — does the i-th part satisfy the query? Reads `facts_at(i)` directly, so a match is measured against exactly the stored facts.
- `count_matches(cat, query) -> u32` — how many parts a query would keep, a bounded walk (`0..len`), so a caller can size a page before it filters.
- `filter_catalog(cat, query, out) -> void` — build `out` fresh over `cat.index.sheet`, then re-`add_part` each match with its own window (`cat.index.entry(i).win`) and facts. Every re-added window and token already passed the source catalog's checks, so the rebuild never half-adds; the parallel windows-and-facts invariant `add_part` guards holds on the sub-catalog too.

## Boundaries

Price is read as a **fact** — compared, never moved; `price_at_most` / `price_at_least` weigh a recorded cent count and nothing more (custody gate #3 untouched). No network, no key, no funds. The filter allocates nothing beyond the fresh `PartCatalog` the caller owns; the shared sheet is borrowed, never copied — a filtered catalog windows into the same decoded bytes the source did.

*May a keeper find the one part they need in a wall of ten thousand — the stainless bolt under two dollars — and may the narrowing never quietly drop the part that would have served.*
