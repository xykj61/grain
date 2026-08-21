# HUNK87 — the faceted query header: the typed groups and their result count, above the narrowed-and-widened shelf

**Stamp:** `20260814.010517` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK87
**Kin:** [`../brushstroke/part_search_header.rye`](../brushstroke/part_search_header.rye) (HUNK82 the AND header this rung generalizes) · [`../brushstroke/part_facets_search.rye`](../brushstroke/part_facets_search.rye) (HUNK86 the faceted shelf it crowns) · [`../image/part_facets.rye`](../image/part_facets.rye) (HUNK85 the faceted query it echoes)

---

## Why this rung

HUNK82 gave the pure-AND shelf a query header — the clauses echoed and an *N results* line — so a keeper reads what they asked, how many were found, and the parts themselves top to bottom. HUNK86 then drew the *whole* sidebar grammar on glass: OR within a facet, AND across facets. Yet the faceted shelf carries no header — a keeper widening within a facet and narrowing across facets sees the parts, with no word of what the machine heard or how many it found. The named horizon on HUNK86's own tail was exactly this: *a query header over the faceted shelf, echoing the groups and their result count, generalizing HUNK82.* This rung is that header.

## The crux

The durable property is HUNK82's, now over the faceted grammar: **no drift between the header and the shelf**. Both read the same typed line through the same `part_facets.parse_facets` — the header counts with `count_facets`, the shelf filters with `filter_facets` — so a header can never claim a count the shelf does not number, nor echo a group the filter ignored.

A sharper law makes the echo trustworthy: `format_facets_query` renders a **canonical** line that **re-parses to the same query** — `parse_facets(format_facets_query(fq))` reaches the same `FacetQuery` as `fq`, a **fixed point of the parser**. So the header shows the query the machine understood, not a hopeful transcript of keystrokes. Because a `|`-free line *is* HUNK82's canonical AND line, this header is a **strict superset** of HUNK82's — every AND header it drew, this rung draws identically, plus the within-facet unions (`|`) HUNK82 could not echo.

## Shape

`brushstroke/part_facets_header.rye`, pure text-and-painting over the public surfaces, mirroring `part_search_header.rye` clause for clause:

- `format_facets_query(fq, out) -> u32` — render a `FacetQuery` back to its canonical line: groups by single space, clauses within a group by `|`, each clause its own `key:value`. Held order kept, so the render is a fixed point of `parse_facets`. Zero groups renders the empty line (the match-all).
- `format_facets_header(cat, text, out) -> u32` — the header line: the canonical query (or `all parts` when zero groups), a two-space gap, and `N result` / `N results`, the count read straight from `count_facets`. A malformed clause surfaces the parser's named refusal.
- `facets_header_row(allocator, cat, text, cols) -> Grid` — the header as a fresh one-row anchor-palette grid, truncated to `cols`. Refuses `EmptyHeader` / `HeaderTooLarge`.
- `facets_search_screen(allocator, cat, text, cols, rows, offset) -> Grid` — the whole faceted search screen: the header row atop HUNK86's `facets_search_shelf` page, stacked into one grid `cols` wide and `1 + rows` tall (HUNK53's cell-for-cell copy idiom). Row 0 equals `facets_header_row` cell-for-cell and the shelf region equals `facets_search_shelf` cell-for-cell — no drift.

## Boundaries

The header holds no state and no funds — it reads a catalog and a line and returns a grid. A price clause is **echoed** as the keeper's own cents (the canonical `max:100`, re-parseable) and **compared**; nothing is moved (custody gate #3 untouched). No network, no key. The header row and the shelf both window into the caller's shared sheet, borrowed and never copied.

## What was proven (witness GREEN)

`tools/hunk_part_facets_header_witness.rish` — four parts across four bands: `(stainless|brass) max:100` reads `2 results`, `stainless max:100` reads `1 result` (singular), an empty line `all parts  4 results`; the echo re-parses to the same query (a fixed point, the canonical single-space/single-`|` line); a `|`-free line renders exactly HUNK82's AND header; the header count equals the shelf's count for every line; `facets_search_screen` stacks header over shelf cell-for-cell; the screen rasterizes to a lit canvas; a malformed clause (`UnknownKey`, `NoColon`), a zero/over-ceiling header (`EmptyHeader`, `HeaderTooLarge`), and a bad offset (`BadOffset`) each refuse by name. HUNK86 faceted shelf and HUNK85 faceted query beneath stay GREEN.

## Next agent-doable

The query header a keeper can *see* now stands whole (AND HUNK82, faceted HUNK87). Next: a **scrollable/paged faceted screen** that carries the page number into the header (*page 2 of 3*), a **per-facet count** beside each echoed group (*stainless-or-brass: 3*), or another Season-A / double-seat journey. No network, no key, no funds.

*May a keeper read back the facets they widened and narrowed, and the honest count of what answered — above the very parts that answer them, in one calm surface.*
