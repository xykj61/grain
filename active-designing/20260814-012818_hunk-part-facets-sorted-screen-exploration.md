# HUNK90 — the sorted screen: a header names the sort above the cheapest-first parts

**Stamp:** `20260814.012818` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (Season A · waymark HUNK · parts-marketplace journey · rung HUNK90)
**Kin:** [`part_facets_paged.rye`](../brushstroke/part_facets_paged.rye) (HUNK88) · [`part_facets_sort.rye`](../brushstroke/part_facets_sort.rye) (HUNK89)

---

## What stands, and the blind spot

HUNK89 sorts the faceted result cheapest-first, and HUNK88 crowns the faceted shelf with a header naming the query, the count, and the page. Yet the two never meet: the paged header still sits over the **held-order** shelf, and the sorted shelf carries **no header at all**. A keeper reading a sorted page has no word that it *is* sorted — the order is silent. A real search box says so: *sorted by price*, above the parts it ordered.

## The crux

**A keeper reads, in one surface, what they asked · how many were found · which page they are on · and that the page is sorted by price — above the very cheapest-first parts.** The header names the sort and the shelf beneath is actually price-sorted, so the word and the order can never drift. This closes the faceted-search arc: read (HUNK86) → echo + count + page (HUNK87–88) → sort (HUNK89) → *say it is sorted, over the sorted parts* (HUNK90).

## The shape

A new module `brushstroke/part_facets_sorted_screen.rye`, pure text-and-painting over the two seated rungs:

- `format_sorted_header(cat, text, rows, offset, out)` — HUNK88's whole paged header (`format_facets_header_paged`) followed by `  sorted by price`, appended only when a result exists (a zero-result line names no sort, exactly as it names no page).
- `sorted_header_row(...)` — draw that header as a one-row anchor-palette grid, through HUNK88's own dimension guards.
- `facets_sorted_screen(...)` — stack the sorted header over HUNK89's `facets_sorted_shelf` into one grid `cols` wide and `1 + rows` tall (HUNK53's cell-for-cell idiom). Row 0 equals `sorted_header_row` cell-for-cell and the shelf region equals `facets_sorted_shelf` cell-for-cell.

## The invariants the witness proves

1. **The header names the sort.** A result line's header ends `  sorted by price`; a zero-result line carries neither page nor sort tail.
2. **No drift, word to order.** The screen's shelf region equals `facets_sorted_shelf` cell-for-cell — the parts under the *sorted by price* header are the actually-sorted parts (cheapest-first, the tie stable).
3. **No drift, header to grid.** Row 0 equals `sorted_header_row` cell-for-cell.
4. **The page named is the page drawn.** The header names `page N of M` and the shelf draws exactly that page of the sorted result.
5. **Refusals hold.** A malformed clause refuses through the header before any sort; a zero/over-ceiling header and a bad offset each refuse by name.

## Custody

A price is echoed, compared, and reordered by; nothing is moved. No network, no key, no funds — custody gate #3 untouched.

*The last honest word the sorted shelf owed its reader: that it is sorted, said plainly above the parts it ordered.*
