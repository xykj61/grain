# HUNK78 — an AND of clauses: narrow on several facets at once

**Stamp:** `20260814.000136` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK78
**Kin:** [`../image/part_filter.rye`](../image/part_filter.rye) (HUNK75 filter) · [`../image/part_query.rye`](../image/part_query.rye) (HUNK76 parse one clause) · [`../brushstroke/part_search.rye`](../brushstroke/part_search.rye) (HUNK77 search on glass)

---

## Why this rung

HUNK75–77 built a real search box, yet it narrows on **one** facet at a time: a keeper types `material:stainless-304` **or** `max:100`, never both at once. A real parts marketplace is faceted — a keeper wants *the stainless bolts under a dollar*, several clauses narrowing together. This rung is that conjunction: one typed line of `key:value` clauses, whitespace-separated, means the parts that satisfy **every** clause.

The ground is already laid. HUNK75's `filter_catalog` **composes** — filtering a filtered catalog narrows further — so a two-clause search is, by construction, the successive narrowing of each clause. This rung names that composition as a first-class thing a keeper can type, and proves the fast single-pass conjunction equals the slow successive fold exactly.

## The crux

The durable property is **a line of clauses means the intersection of their matches, and the order of the clauses does not change it**: `filter_and(cat, parse_and("material:stainless-304 max:100"))` keeps precisely the parts that pass *both* clauses, in held order, and equals the successive fold `filter_catalog(filter_catalog(cat, c0), c1)` name-for-name. A conjunction is not a new kind of matching — it is `part_filter.matches` asked of every clause, so the AND view inherits every law the single filter proved (a match reads the stored fact, never a copy; a match-none line yields a real empty catalog, not an error).

The identity is the honest edge: **an empty line is a match-all** — a fold over zero clauses reproduces the catalog. A keeper who has typed nothing sees the whole marketplace, exactly as they should.

## Shape

`image/part_and.rye`, pure composition over the two public surfaces (`part_query.parse_query`, `part_filter.matches`) — no new storage, no new codec, no new matching rule:

- `AndQuery` — a bounded list of `part_filter.Query` clauses (`max_clauses = 8`, a keeper narrows on a handful of facets) plus a count. Each clause's text slice borrows into the caller's typed line, exactly as one `Query` does.
- `parse_and(text) -> AndQuery` — tokenize the line on spaces (blank runs skipped, so extra spacing is tolerated) and parse each token through `part_query.parse_query`, so every single-clause law is reused verbatim. Zero tokens is a valid match-all `AndQuery`; a malformed clause surfaces the parser's own named error; past the ceiling refuses `TooManyClauses`.
- `matches_all(cat, i, aq) -> bool` — the i-th part satisfies **every** clause (an empty clause set is trivially true — match-all).
- `count_and(cat, aq) -> u32` — how many parts pass all clauses, so a caller sizes the paging before it draws.
- `filter_and(cat, aq, out)` — one bounded walk building the sub-catalog of parts that pass all clauses, over the same shared sheet. The result is an ordinary `PartCatalog` that paints, pages, and round-trips like any other.

## Boundaries

The AND view holds no state and no funds — it reads a catalog and a line and returns a count or a sub-catalog. A price clause **compares** a recorded cent count; nothing is moved (custody gate #3 untouched). No network, no key. The sub-catalog windows into the caller's shared sheet, borrowed and never copied. The clause list is bounded at parse time; the sub-catalog can never outrun the source catalog's own product ceiling.

*May a keeper name the few facets that matter and watch the wall become the handful that serve — and may the clauses commute, so it never matters which fact they named first.*
