# HUNK92 — the sort names which way it turns: a directional header over the matching page

**Stamp:** `20260814.014131` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (Season A · waymark HUNK · parts-marketplace journey · rung HUNK92)
**Kin:** [`part_facets_sorted_screen.rye`](../brushstroke/part_facets_sorted_screen.rye) (HUNK90) · [`part_facets_sort_desc.rye`](../brushstroke/part_facets_sort_desc.rye) (HUNK91)

---

## What stands, and the blind spot

HUNK90 stacks a header reading `sorted by price` over the cheapest-first shelf, and HUNK91 builds the descending sort — the same result read dearest-first. Yet the two never met: the header says only *sorted by price*, never *which way*, and the descending shelf carries no header at all. A keeper reading a sorted page still cannot tell low-to-high from high-to-low by the words above it — the direction is drawn but never named. A sort control that turns both ways owes the keeper a label that says which way it turned.

## The crux

**The header names the direction, and the page beneath is the page that direction draws — no drift between the word and the order.** Once the screen carries a direction, `sorted by price low to high` sits over the ascending page and `sorted by price high to low` over the descending page, chosen by the same parameter that chooses the shelf. The word and the order can never disagree, because one direction drives both.

## The shape

A new module `brushstroke/part_facets_sort_dir.rye`, mirroring HUNK90 with a direction parameter, inventing no storage:

- `SortDir` — an enum, `ascending` or `descending`, the one parameter that turns the whole screen.
- `format_sorted_header_dir(cat, text, rows, offset, dir, out)` — HUNK88's paged header plus the direction's tail (`  sorted by price low to high` or `  sorted by price high to low`), added only when a result exists.
- `sorted_header_dir_row(cat, text, cols, rows, offset, dir)` — that line as a one-row anchor-palette grid.
- `facets_sorted_screen_dir(cat, text, cols, rows, offset, dir)` — the directional header stacked over the direction's shelf: HUNK89's `facets_sorted_shelf` for ascending, HUNK91's `facets_sorted_desc_shelf` for descending.

## The invariants the witness proves

1. **The header names the direction.** Ascending reads `… sorted by price low to high`; descending reads `… sorted by price high to low`.
2. **No drift, word to order.** When the header says *high to low*, the shelf's first row is the dearest part; when *low to high*, the cheapest.
3. **The two directions are exact reverses on distinct prices.** The ascending screen's shelf rows read backward equal the descending screen's, part for part.
4. **A zero-result line names neither page nor direction** — there is nothing to order.
5. **Refusals hold.** A malformed clause refuses through the header before any sort (`UnknownKey`); a zero or over-ceiling width refuses `EmptyHeader` / `HeaderTooLarge`; an offset past the result refuses `BadOffset`.

## Custody

A price is echoed, compared, and reordered by; nothing is moved. No network, no key, no funds — custody gate #3 untouched.

*A sort that says which way it turned answers the keeper's real question — not only "what does this cost," but "am I looking at the cheapest or the best."*
