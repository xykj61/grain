# HUNK86 — the faceted grammar to glass: OR-within, AND-across draws one paged shelf

**Stamp:** `20260814.005836` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK86
**Kin:** [`../image/part_facets.rye`](../image/part_facets.rye) (HUNK85 the faceted query this rung draws) · [`../brushstroke/part_and_search.rye`](../brushstroke/part_and_search.rye) (HUNK79) · [`../brushstroke/part_or_search.rye`](../brushstroke/part_or_search.rye) (HUNK84)

---

## Why this rung

HUNK85 joined the AND and the OR into the canonical faceted query — OR within a facet, AND across facets — yet it lives in the image layer, unseen. HUNK79 drew the pure AND on glass and HUNK84 the pure OR; this rung draws the *whole* sidebar grammar: `facets_search_shelf` reads a catalog, a faceted line, and a page offset, and paints exactly the parts that satisfy every group. With it, the query algebra a keeper can *see* is complete — a keeper types `material:stainless-304|material:brass max:100` and watches the wall become the stainless-or-brass parts under a dollar.

## The crux

The durable property is HUNK79's and HUNK84's, now over the faceted grammar: **what a keeper types is what a keeper sees**. `facets_search_shelf(cat, "material:stainless-304|material:brass max:100", …, offset)` draws precisely the page `part_window` would draw over the catalog `filter_facets` narrows-and-widens — no part shown that fails a group, no satisfying part hidden. The view invents nothing; it is the faithful composition `parse_facets` → `filter_facets` → `part_window`, inheriting every law HUNK85 proved (backward-compatibility with HUNK78, the match-all empty line, distribution). Because a `|`-free line *is* HUNK78's conjunction, this view is a strict superset of HUNK79 — every AND page it already drew, this rung draws identically, plus the within-facet unions HUNK79 could not express.

## Shape

`brushstroke/part_facets_search.rye`, pure composition over the public surfaces, mirroring `part_or_search.rye` clause for clause:

- `facets_search_result_count(cat, text) -> u32` — parse the line, count the parts passing every group (`parse_facets` then `count_facets`), so a caller shows *N results* and sizes the paging before it draws.
- `facets_search_page_count(allocator, cat, text, rows) -> u32` — how many pages the result needs at `rows` per page, over the faceted catalog.
- `facets_search_shelf(allocator, cat, text, cols, rows, offset) -> Grid` — parse the faceted line, filter the catalog into a fresh sub-catalog over the same sheet with `filter_facets`, and draw the page `[offset, offset + rows)` with `part_window`. Refuses `BadOffset` past the result exactly as `part_window` does; refuses the parser's named errors for a malformed clause, `TooManyGroups` for an over-long line, and the shelf's own dimension errors.

## Boundaries

The search view holds no state and no funds — it reads a catalog and a line and returns a grid. A price clause **compares** a recorded cent count; nothing is moved (custody gate #3 untouched). No network, no key. The sub-catalog windows into the caller's shared sheet, borrowed and never copied. A `brushstroke/part_facets.rye` symlink lets the brushstroke build resolve the image-layer faceted query, matching the pattern HUNK79 and HUNK84 set. A query header over the faceted shelf (echoing the groups and their result count, generalizing HUNK82) is a named horizon on a later rung.

*May a keeper name the facets that matter — some widened, some narrowed — and watch the wall become exactly the handful that serve, drawn on glass in one honest paged shelf.*
