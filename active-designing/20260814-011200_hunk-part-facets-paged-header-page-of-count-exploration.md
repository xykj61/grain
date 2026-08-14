# HUNK88 — the paged faceted header: the page a keeper reads, named above its own parts

**Stamp:** `20260814.011200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK88
**Kin:** [`../brushstroke/part_facets_header.rye`](../brushstroke/part_facets_header.rye) (HUNK87 the faceted header this rung pages) · [`../brushstroke/part_facets_search.rye`](../brushstroke/part_facets_search.rye) (HUNK86 the shelf and its page count) · [`../brushstroke/part_row.rye`](../brushstroke/part_row.rye) (the paging law it reads)

---

## Why this rung

HUNK87 gave the faceted shelf a header — the query echoed and an *N results* count — so a keeper reads what they asked and how many were found. Yet a keeper on the second page of a tall result reads no word of *which* page they are on, nor *how many* there are: the shelf shows a page of parts with no sense of the whole. HUNK87's own tail named this horizon — *carry the page number into the header (page N of M)*. A real search box answers it, so a keeper knows a page remains to reach. This rung is that page line.

## The crux

The durable property is **no drift between the named page and the drawn page**. `format_facets_header_paged` names the page `page_index(offset, rows)` sits on and counts the pages with HUNK86's `facets_search_page_count`; `facets_search_shelf` draws exactly `[offset, offset + rows)` of the same faceted result. Both read the same typed line through the same `parse_facets`, so the *page N of M* a keeper reads is exactly the page of parts drawn beneath it — a keeper reading `page 2 of 2` sees the second page's own parts. A **zero-result line carries no page tail** (there is no page), so the header never claims the nonsense `page 1 of 0`.

## Shape

`brushstroke/part_facets_paged.rye`, pure text-and-painting composed over HUNK87 and HUNK86:

- `page_index(offset, rows) -> u32` — the 1-based page a `rows`-tall window at `offset` sits on (`offset / rows + 1`), exact on a page boundary as every caller draws them.
- `format_facets_header_paged(allocator, cat, text, rows, offset, out) -> u32` — HUNK87's whole header, then `  page N of M` when the result has at least one page; omitted entirely when zero.
- `facets_paged_header_row(allocator, cat, text, cols, rows, offset) -> Grid` — the paged header as a fresh one-row anchor-palette grid, truncated to `cols`; refuses `EmptyHeader` / `HeaderTooLarge`.
- `facets_paged_screen(allocator, cat, text, cols, rows, offset) -> Grid` — the paged header row atop HUNK86's shelf page, stacked into one grid `cols` wide and `1 + rows` tall (HUNK53's cell-for-cell idiom). Row 0 equals `facets_paged_header_row`, the shelf region equals `facets_search_shelf` — no drift.

## Boundaries

The header holds no state and no funds — it reads a catalog, a line, a page, and returns a grid. A price clause is echoed and compared; nothing is moved (custody gate #3 untouched). No network, no key. The page tail is ASCII (`  page N of M`), so it paints on the anchor-palette glyph atlas without a multi-byte cell.

## What was proven (witness GREEN)

`tools/hunk_part_facets_paged_witness.rish` — four parts across four bands: `(stainless|brass) max:100` at one row per page reads `page 1 of 2` then `page 2 of 2`; an empty line two rows per page reads `all parts  4 results  page 1 of 2`; a zero-result line carries no page tail (never `page 1 of 0`); the named page equals the drawn page (`page 2 of 2` draws hexnut's own row); `facets_paged_screen` stacks header over shelf cell-for-cell; the screen rasterizes lit; a malformed clause (`UnknownKey`), a zero/over-ceiling header (`EmptyHeader`, `HeaderTooLarge`), and a bad offset (`BadOffset`) each refuse by name. HUNK87 faceted header and HUNK86 faceted shelf beneath stay GREEN.

## Next agent-doable

The readable faceted search now reads the whole result — query, count, page, and the parts of that page — top to bottom. Next: a **sort** over the result (by price, ascending or descending — a real McMaster-Carr capability distinct from filtering), a **per-facet count** beside each echoed group, or another Season-A / double-seat journey. No network, no key, no funds.

*May a keeper always know which page they stand on and how many remain — the whole result honest in one glance, above the very parts that answer them.*
