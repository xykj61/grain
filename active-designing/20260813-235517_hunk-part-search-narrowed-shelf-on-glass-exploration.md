# HUNK77 — the search box on glass: a typed line draws a narrowed, paged shelf

**Stamp:** `20260813.235517` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK77
**Kin:** [`../image/part_query.rye`](../image/part_query.rye) (HUNK76 parse) · [`../image/part_filter.rye`](../image/part_filter.rye) (HUNK75 filter) · [`../brushstroke/part_row.rye`](../brushstroke/part_row.rye) (HUNK73 shelf · HUNK74 paging) · [`hunk-part-query`](20260813-234932_hunk-part-query-typed-search-box-exploration.md)

---

## Why this rung

Three rungs built the narrowing whole: HUNK73/74 paint and page a catalog, HUNK75 filters it to the parts that match a `Query`, HUNK76 parses that query from a keeper's typed line. Yet nothing had joined them on glass. A keeper who types `material:stainless-304` should *see* the marketplace shrink to the stainless parts, one paged shelf, drawn from the one shared sheet. This rung is that joining: `search_shelf` reads a catalog, a typed line, and a page offset, and draws exactly the narrowed page — the search box end to end, from keystroke to lit swatch.

## The crux

The durable property is **what a keeper types is what a keeper sees**: `search_shelf(cat, text, …, offset)` draws precisely the page `part_window` would draw over the *filtered* catalog — no part shown that fails the query, no matching part hidden. The search view invents nothing; it is the faithful composition `parse_query` → `filter_catalog` → `part_window`, and it inherits every law those proved (paging loses nothing, the swatch is true to the sheet, a match-none query draws a real empty page). A malformed line does not draw a wrong shelf — it surfaces the parser's own named refusal to the caller, so a bad search shows nothing rather than the wrong seven parts.

## Shape

`brushstroke/part_search.rye`, pure composition over the three public surfaces — no new storage, no new codec, no new failure class:

- `search_result_count(cat, text) -> u32` — parse the line, count the matches (`parse_query` then `count_matches`), so a caller can show *N results* and size the paging before it draws. A malformed line surfaces the parser's error.
- `search_page_count(allocator, cat, text, rows) -> u32` — how many pages the narrowed result needs at `rows` per page, over the filtered catalog.
- `search_shelf(allocator, cat, text, cols, rows, offset) -> Grid` — parse the line, filter the catalog into a fresh sub-catalog over the same sheet, and draw the page `[offset, offset+rows)` with `part_window`. Refuses `BadOffset` past the narrowed result exactly as `part_window` does; refuses the parser's named errors for a malformed line; refuses the shelf's own dimension errors. The narrowed catalog is a local, so the drawn grid outlives it (the grid owns its cells) while the sub-catalog's borrowed sheet is the caller's original.

## Boundaries

The search view holds no state and no funds — it reads a catalog and a line and returns a grid. A price is drawn as a **fact formatted for reading** (the shelf's own `$D.CC`), matched by a query that *compares* a recorded cent count; nothing is moved (custody gate #3 untouched). No network, no key. The sub-catalog windows into the caller's shared sheet, borrowed and never copied, so a search draws the same decoded bytes the catalog did.

*May a keeper type what they need and watch the wall of parts become the few that serve — and may a search that reads as nonsense draw nothing, rather than quietly the wrong thing.*
