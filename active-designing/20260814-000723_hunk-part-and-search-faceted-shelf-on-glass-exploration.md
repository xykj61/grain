# HUNK79 — the faceted search box on glass: a multi-clause line draws a narrowed, paged shelf

**Stamp:** `20260814.000723` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK79
**Kin:** [`../image/part_and.rye`](../image/part_and.rye) (HUNK78 conjunction) · [`../brushstroke/part_search.rye`](../brushstroke/part_search.rye) (HUNK77 single-clause search on glass) · [`../brushstroke/part_row.rye`](../brushstroke/part_row.rye) (HUNK73 shelf · HUNK74 paging)

---

## Why this rung

HUNK78 gave the marketplace a faceted query — a line of `key:value` clauses narrowing to the parts that satisfy **every** one. Yet HUNK78 lives in the image layer; a keeper never *sees* it. HUNK77 drew the single-clause search on glass but reaches only `parse_query`, one facet. This rung joins HUNK78's conjunction to the shelf: `and_search_shelf` reads a catalog, a *multi-clause* typed line, and a page offset, and draws exactly the narrowed page. The faceted search box, end to end — from a keeper typing `material:stainless-304 max:100` to the lit swatches of the two stainless parts under a dollar.

## The crux

The durable property is the same one HUNK77 proved, now over the conjunction: **what a keeper types is what a keeper sees**. `and_search_shelf(cat, "material:stainless-304 max:100", …, offset)` draws precisely the page `part_window` would draw over the catalog `filter_and` narrows — no part shown that fails any clause, no satisfying part hidden. The view invents nothing; it is the faithful composition `parse_and` → `filter_and` → `part_window`, inheriting every law those proved (the clauses commute, an empty line is a match-all, a match-none compound draws a real empty page, paging loses nothing). A malformed clause surfaces the parser's own named refusal rather than drawing a wrong shelf.

## Shape

`brushstroke/part_and_search.rye`, pure composition over the two public surfaces — no new storage, no new codec, no new failure class, mirroring `part_search.rye` exactly one rung up in expressiveness:

- `and_search_result_count(cat, text) -> u32` — parse the line, count the parts passing all clauses (`parse_and` then `count_and`), so a caller shows *N results* and sizes the paging before it draws. A malformed clause surfaces the parser's error.
- `and_search_page_count(allocator, cat, text, rows) -> u32` — how many pages the narrowed result needs at `rows` per page, over the filtered catalog.
- `and_search_shelf(allocator, cat, text, cols, rows, offset) -> Grid` — parse the line, filter the catalog into a fresh sub-catalog over the same sheet with `filter_and`, and draw the page `[offset, offset+rows)` with `part_window`. Refuses `BadOffset` past the narrowed result exactly as `part_window` does; refuses the parser's named errors for a malformed clause and `TooManyClauses` for an over-long line; refuses the shelf's own dimension errors.

## Boundaries

The search view holds no state and no funds — it reads a catalog and a line and returns a grid. A price clause **compares** a recorded cent count; nothing is moved (custody gate #3 untouched). No network, no key. The sub-catalog windows into the caller's shared sheet, borrowed and never copied, so the faceted search draws the same decoded bytes the catalog did. A `brushstroke/part_and.rye` symlink lets the brushstroke build resolve the image-layer conjunction, matching the `part_filter`/`part_query` pattern HUNK77 set.

*May a keeper name the few facets that matter and watch the wall become the handful that serve — drawn on glass, one paged shelf, exactly what they asked for.*
