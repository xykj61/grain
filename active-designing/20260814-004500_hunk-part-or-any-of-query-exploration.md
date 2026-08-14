# HUNK83 — the OR of clauses: widen the marketplace to the parts matching any facet

**Stamp:** `20260814.004500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK83
**Kin:** [`../image/part_and.rye`](../image/part_and.rye) (HUNK78 the conjunction this rung duals) · [`../image/part_filter.rye`](../image/part_filter.rye) (HUNK75 `matches` / `filter_catalog`) · [`../image/part_query.rye`](../image/part_query.rye) (HUNK76 `parse_query`)

---

## Why this rung

HUNK78 gave the marketplace a conjunction — a line of clauses narrowing to the parts that satisfy *every* one. That is half of a real facet sidebar. The other half *widens*: a keeper who checks both `material:stainless-304` and `material:brass` does not want the parts that are somehow both, but the parts that are *either* — the union. This rung is that disjunction, the dual of HUNK78, so the boolean query algebra a marketplace runs on stands whole: narrow with AND, widen with OR.

## The crux

The durable property is that **a line of clauses under OR means the union of their matches, and the clauses commute** — `filter_or` keeps exactly the parts that pass at least one clause, in the catalog's held order, each part once. No new matching rule is invented: because HUNK75's `matches` already reads the stored facts, a disjunction is just `matches` asked of every clause with a logical OR (`matches_any`), exactly as the conjunction was `matches` with an AND.

Two laws make the dual honest and checkable:

- **The De Morgan identity.** An empty AND is a match-*all* (all-of-nothing is true); an empty OR is a match-*none* (any-of-nothing is false). A keeper who has typed nothing under OR has named no way to match, so the honest result is the empty catalog — the exact dual of the conjunction's whole-catalog. Following the algebra rather than a friendlier guess keeps AND and OR true duals.
- **The superset relation.** Over the same clauses, OR is always a superset of AND: every part the conjunction keeps, the disjunction keeps too. This is a free cross-check against HUNK78 — a single catalog, filtered both ways, must nest.

## Shape

`image/part_or.rye`, mirroring `part_and.rye` clause for clause so the two read as the pair they are:

- `parse_or(text) -> !OrQuery` — read a whitespace-separated line into a bounded `OrQuery` (`max_clauses = part_and.max_clauses`, so AND and OR share one ceiling and the superset check is measured at equal width), each clause parsed by HUNK76's own `parse_query`. Zero clauses is a match-none query.
- `matches_any(cat, i, oq) -> bool` — does part `i` satisfy at least one clause? Empty is false (the dual of `matches_all`'s empty-is-true).
- `count_or` / `filter_or` — the bounded count and the fresh sub-catalog over the same shared sheet, each part once in held order — an ordinary `PartCatalog` that paints, pages, and round-trips like any other.
- Refuses by name: a malformed clause surfaces `parse_query`'s own error (`UnknownKey`, `NoColon`, …); an over-long line refuses `TooManyClauses` before any walk; a hand-built over-long text operand refuses `QueryTextTooLong` in `check_clauses`.

## Boundaries

The disjunction reads and compares; it moves nothing. A price clause compares a recorded cent count (custody gate #3 untouched). No network, no key, no funds. The result borrows the caller's own sheet exactly as the conjunction's does, so it never dangles. Bringing the OR to glass (an `or_search_shelf` mirroring HUNK79, and a mixed AND-of-ORs grammar) is a named horizon on the next rungs.

*May a keeper widen as freely as they narrow — the union as honest as the intersection, and the empty query under each read exactly as the algebra says it should.*
