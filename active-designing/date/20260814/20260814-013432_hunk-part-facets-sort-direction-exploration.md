# HUNK91 — the sort a keeper can reverse: dearest-first as well as cheapest-first

**Stamp:** `20260814.013432` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (Season A · waymark HUNK · parts-marketplace journey · rung HUNK91)
**Kin:** [`part_facets_sort.rye`](../brushstroke/part_facets_sort.rye) (HUNK89) · [`part_facets_sorted_screen.rye`](../brushstroke/part_facets_sorted_screen.rye) (HUNK90)

---

## What stands, and the blind spot

HUNK89 sorts the faceted result cheapest-first and HUNK90 names that sort above the parts. Yet the direction is fixed: a keeper can find the least dear part, never the dearest. A real sort control turns both ways — *price: low to high* and *price: high to low* — so a keeper shopping for the best part rather than the cheapest is served too. A sort you cannot reverse is half a sort.

## The crux

**The price sort takes a direction, and a descending sort reads the same result dearest-first — still stable, still a permutation.** Direction is the parameter that turns a one-way ordering into a control; once the sort carries a direction, the door opens to a keeper choosing it and to sorting any fact either way. It stays additive: HUNK89's ascending functions keep their names and their GREEN witness, and the descending pair sits beside them.

## The shape

A new module `brushstroke/part_facets_sort_desc.rye`, mirroring HUNK89 clause for clause, inventing no storage:

- `sort_by_price_desc(src, out)` — builds a fresh sub-catalog over the same sheet holding every part in **descending** price order, ties keeping their held order (a **stable** sort, so equal prices read in the order a keeper added them — the same tie rule as ascending, never reversed).
- `facets_sorted_desc_shelf(cat, text, cols, rows, offset)` — `parse_facets` → `filter_facets` → `sort_by_price_desc` → `part_window`, so the drawn page reads dearest-first.

## The invariants the witness proves

1. **Dearest-first.** Over the price spread, the descending sort draws the dearest part first and the least dear last; each row's price is `≤` the row above it.
2. **The exact reverse of ascending on distinct prices** — for a result with no ties, the descending order is HUNK89's ascending order read backward.
3. **Stable on ties, held order (not reversed).** Two parts at the same price keep their held order after the descending sort — a tie is broken by held order in *both* directions, so descending is not a naive reversal of the ascending array.
4. **A permutation, never a change.** Same parts as a set, only reordered.
5. **Refusals hold.** A malformed clause refuses before any sort; an offset past the result refuses `BadOffset`.

## Custody

A price is compared and reordered by; nothing is moved. No network, no key, no funds — custody gate #3 untouched.

*A sort that turns both ways answers two honest questions at once — what can I afford, and what is the best they have.*
