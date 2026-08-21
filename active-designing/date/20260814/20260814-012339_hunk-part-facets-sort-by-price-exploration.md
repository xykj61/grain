# HUNK89 — the faceted result, sorted cheapest-first

**Stamp:** `20260814.012339` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (Season A · waymark HUNK · parts-marketplace journey · rung HUNK89)
**Kin:** [`part_facets_search.rye`](../brushstroke/part_facets_search.rye) (HUNK86) · [`part_facets_paged.rye`](../brushstroke/part_facets_paged.rye) (HUNK88) · [`part_catalog.rye`](../brushstroke/part_catalog.rye) (HUNK71) · [`part_row.rye`](../brushstroke/part_row.rye)

---

## What stands, and the blind spot

The faceted search reads a keeper's whole typed query and draws exactly the parts that satisfy it (HUNK86), crowned by a header that echoes the query, counts the results, and names the page (HUNK87–HUNK88). Yet the result draws in **held order** — the order parts were added to the catalog — which is no order a shopper wants. On a real parts wall the first thing a keeper reaches for is *cheapest first*: show me the parts that satisfy my query, least dear at the top. Every faceted rung so far leaves that undone.

## The crux

**A keeper reads the faceted result sorted by price, cheapest-first, and the sorted page is exactly the parts the query kept — reordered, never changed.** Sorting is the fundamental marketplace verb; once the result can be ordered by a fact, the door opens to ordering by any fact and to *sort by* as a keeper choice. It is Lindy-durable (a search that cannot sort is half a search) and crux-first (the one decisive move price-ordering, per-facet counts, and a sort selector all build on).

## The shape

A new module `brushstroke/part_facets_sort.rye`, pure text-and-catalog over the seated pieces, inventing no storage:

- `sort_by_price(cat, out)` — builds a fresh sub-catalog over the **same sheet**, holding every part of `cat` in **ascending price order**, ties keeping their held order (a **stable** sort, so equal prices read in the order a keeper added them). Reuses `add_part`, so every window is re-validated and every fact re-checked; a selection sort bounded by `sprite.max_products`.
- `facets_sorted_shelf(cat, text, cols, rows, offset)` — the composition a keeper sees: `parse_facets` → `filter_facets` (the query's kept parts) → `sort_by_price` (cheapest-first) → `part_window` (the page). So *what a keeper types is what a keeper sees*, now in the order they want it.

## The invariants the witness proves

1. **Cheapest-first.** Over four parts spanning a price spread, an empty (match-all) line sorted draws the least-dear part first and the dearest last; each row's price is `≥` the row above it.
2. **A permutation, never a change.** The sorted sub-catalog holds exactly the same parts as the filtered result — same count, same names as a set — only the order differs; no part invented, none dropped.
3. **Stable on ties.** Two parts at the same price keep their held order after the sort.
4. **The sorted page equals a hand-sorted window** — the composition invents nothing; it is `filter` then `sort` then `window`, drawn faithfully.
5. **Refusals hold.** A malformed clause surfaces the parser's named refusal before any sort; an offset past the sorted result refuses `BadOffset` through the window.

## Custody

A price clause **compares** a recorded cent count and the sort **reorders** by it; nothing is moved. No network, no key, no funds — custody gate #3 untouched.

*A shelf a keeper can sort is a shelf a keeper can trust to answer "what can I afford?" — the next honest thing the marketplace owes its visitor.*
