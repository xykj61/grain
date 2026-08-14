# HUNK82 — the query header: the typed clauses and their result count, above the narrowed shelf

**Stamp:** `20260814.003328` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK82
**Kin:** [`../brushstroke/part_and_search.rye`](../brushstroke/part_and_search.rye) (HUNK79 the narrowed shelf on glass) · [`../image/part_and.rye`](../image/part_and.rye) (HUNK78 the `AndQuery` conjunction) · [`../brushstroke/edit_screen_view.rye`](../brushstroke/edit_screen_view.rye) (HUNK53 the stack-into-one-grid idiom) · [`../brushstroke/part_row.rye`](../brushstroke/part_row.rye) (HUNK73 fact-line helpers)

---

## Why this rung

HUNK79 drew the faceted search on glass — a keeper types `material:stainless-304 max:100` and the marketplace narrows to exactly the parts that pass every clause. Yet the drawn page carries no word of *what was asked* or *how much was found*: the shelf shows the survivors, but not the query that narrowed to them nor the count they number. A real search box answers both at a glance — the clauses echoed back so a keeper trusts the machine heard them, and an *N results* line so a keeper knows whether to refine. This rung paints that header and stacks it above the narrowed shelf, so the whole search reads top to bottom in one surface: what I asked · how many I found · the parts themselves.

## The crux

The durable property is **no drift between the header and the shelf** — the count the header shows is exactly the count the shelf narrowed to, and the clauses the header echoes are exactly the clauses the shelf filtered by, never a stale or hand-copied line. Both read the same typed text through the same `part_and.parse_and`: the header counts with `part_and.count_and`, the shelf filters with `part_and.filter_and`, so a header can never claim *3 results* over a page of five, nor echo a facet the filter ignored.

A second, sharper law makes the echo trustworthy: **the header renders a canonical line that re-parses to the same query** — `parse_and(format_query(parse_and(text)))` reaches the same `AndQuery` as `parse_and(text)`. The header does not merely copy the keeper's keystrokes; it shows the query the machine *understood*, normalized, and that normalized line is a fixed point of the parser (exactly as the sprite catalog and the edit-list are fixed points of their own render/parse). So the echo is a proof the clauses were read as meant, not a hopeful transcript.

## Shape

`brushstroke/part_search_header.rye`, pure text-and-painting over surfaces already proven — no new storage, no codec, no funds:

- `format_query(aq, out) -> !u32` — render a parsed `AndQuery` back to its canonical space-separated `key:value` line: each clause's kind maps to its key (`material` · `prefix` · `max` · `min`), a text clause writes its operand, a price clause writes its cents as decimal digits. Zero clauses renders the empty line (which re-parses to the match-all query), so the round-trip law holds universally. Refuses `HeaderOverflow` rather than write past `out`.
- `format_header(cat, text, out) -> !u32` — assemble the header line a keeper reads: the canonical query (or the friendly `all parts` when zero clauses) followed by `  ·  N result` / `N results`, the count read straight from `part_and.count_and`. A malformed clause surfaces the parser's own named refusal, so a header is never drawn over a query the machine could not read.
- `header_row(allocator, cat, text, cols) -> !Grid` — a fresh one-row anchor-palette grid carrying the header line (truncated to `cols`), refusing `EmptyHeader` on a zero dimension and `HeaderTooLarge` past the down-map ceiling.
- `search_screen(allocator, cat, text, cols, rows, offset) -> !Grid` — the crux composition: stack `header_row` atop `part_and_search.and_search_shelf`'s narrowed page into one grid (HUNK53's cell-for-cell copy idiom), the header in row 0, the shelf beneath. Row 0 equals `header_row` cell-for-cell and the shelf region equals `and_search_shelf` cell-for-cell — the stack adds no drift.

## Boundaries

The header holds no state and no funds — it reads a catalog and a typed line and returns text or a grid. A price is rendered as the keeper's own cents (the canonical `max:100`, re-parseable), a fact **echoed for reading, never a balance the tree can move** (custody gate #3 untouched). No network, no key, no funds. The screen's shelf region borrows the caller's own sheet exactly as HUNK79 does; the header borrows nothing beyond the typed line.

*May a keeper read back the very question they asked, and the honest count of its answers, before their eye ever falls to the parts — the search that speaks plainly what it heard.*
