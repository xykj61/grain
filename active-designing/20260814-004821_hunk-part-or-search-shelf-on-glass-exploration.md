# HUNK84 — the OR to glass: a widening line draws the union as one paged shelf

**Stamp:** `20260814.004821` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK84
**Kin:** [`../image/part_or.rye`](../image/part_or.rye) (HUNK83 the disjunction this rung draws) · [`../brushstroke/part_and_search.rye`](../brushstroke/part_and_search.rye) (HUNK79 the AND on glass this rung duals) · [`../brushstroke/part_search.rye`](../brushstroke/part_search.rye) (HUNK77 single-clause search)

---

## Why this rung

HUNK83 gave the marketplace its disjunction — a line of clauses widening to the parts that satisfy *any* one — yet it lives in the image layer, unseen. HUNK79 already drew the AND on glass: type `material:stainless-304 max:100`, watch the wall become the parts that pass every clause. This rung draws the *other* half of the facet sidebar: `or_search_shelf` reads a catalog, a widening line, and a page offset, and paints exactly the union as one paged shelf. With it, the boolean query algebra a keeper can *see* stands whole — narrow with AND on glass (HUNK79), widen with OR on glass (HUNK84).

## The crux

The durable property is HUNK79's, now over the disjunction: **what a keeper types is what a keeper sees**. `or_search_shelf(cat, "material:stainless-304 max:60", …, offset)` draws precisely the page `part_window` would draw over the catalog `filter_or` widens — no part shown that fails every clause, no part matching some clause hidden. The view invents nothing; it is the faithful composition `parse_or` → `filter_or` → `part_window`, inheriting every law HUNK83 proved (the clauses commute, an empty line is a match-*none* — the De Morgan dual of AND's match-all, each part once, paging loses nothing). A malformed clause surfaces the parser's own named refusal rather than a wrong shelf.

The one honest difference from HUNK79 is the empty line. Under AND an empty line is a match-all and draws the whole catalog; under OR an empty line is a match-none and draws a real empty page — a keeper who has named no way to match sees nothing, exactly as the algebra says. The glass view carries that dual faithfully rather than softening it to a friendlier guess.

## Shape

`brushstroke/part_or_search.rye`, pure composition over the two public surfaces, mirroring `part_and_search.rye` clause for clause so the two read as the pair they are:

- `or_search_result_count(cat, text) -> u32` — parse the line, count the parts passing at least one clause (`parse_or` then `count_or`), so a caller shows *N results* and sizes the paging before it draws. A malformed clause surfaces the parser's error.
- `or_search_page_count(allocator, cat, text, rows) -> u32` — how many pages the widened result needs at `rows` per page, over the union catalog.
- `or_search_shelf(allocator, cat, text, cols, rows, offset) -> Grid` — parse the line, filter the catalog into a fresh sub-catalog over the same sheet with `filter_or`, and draw the page `[offset, offset + rows)` with `part_window`. Refuses `BadOffset` past the widened result exactly as `part_window` does; refuses the parser's named errors for a malformed clause and `TooManyClauses` for an over-long line; refuses the shelf's own dimension errors.

## Boundaries

The search view holds no state and no funds — it reads a catalog and a line and returns a grid. A price clause **compares** a recorded cent count; nothing is moved (custody gate #3 untouched). No network, no key. The sub-catalog windows into the caller's shared sheet, borrowed and never copied, so the widened search draws the same decoded bytes the catalog did. A `brushstroke/part_or.rye` symlink lets the brushstroke build resolve the image-layer disjunction, matching the `part_and`/`part_filter`/`part_query` pattern HUNK79 set. A mixed AND-of-ORs grammar on glass (a keeper narrowing on some facets while widening on others) is a named horizon on a later rung.

*May a keeper widen on glass as freely as they narrow — the union drawn as faithfully as the intersection, and the empty query under each read exactly as the algebra says it should.*
