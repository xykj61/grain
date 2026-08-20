# HUNK76 — a typed search box: parse a keeper's query text into a filter

**Stamp:** `20260813.234932` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK76
**Kin:** [`../image/part_filter.rye`](../image/part_filter.rye) (HUNK75 filter) · [`../image/part_catalog.rye`](../image/part_catalog.rye) (HUNK71 facts) · [`../tally/parse_int.rye`](../tally/parse_int.rye) (strict integer) · [`hunk-part-filter`](20260813-234337_hunk-part-filter-narrow-the-catalog-exploration.md)

---

## Why this rung

HUNK75 built the narrowing — `filter_catalog` turns a catalog and a `Query` into the sub-catalog of matches. Yet a `Query` is a struct a program builds; a keeper types *text*. McMaster-Carr's sidebar is reached by a search box, and no rung had let a typed string become a query. This rung is that search box: `parse_query` reads one line a keeper typed and returns the `Query` it means, refusing a malformed line by name so a bad search can never quietly match everything or nothing.

## The crux

The durable property is **a typed line means exactly the query it reads as** — `parse_query(text)` yields precisely the `Query` a keeper intended, so `filter_catalog(cat, parse_query(text))` narrows identically to `filter_catalog(cat, <the hand-built Query>)`. The search box adds no meaning of its own; it is a faithful mouth for the filter that already exists. A malformed line refuses rather than guessing — an empty value, an unknown key, a missing colon, a non-numeric price, or an over-long token each surface a named error before a single part is walked.

## Shape

`image/part_query.rye`, a small strict parser over `part_filter`'s public `Query` and `tally/parse_int`'s strict integer — no new filter logic, no new failure the filter did not already imply:

- The grammar is one `key:value` pair, the keys a keeper reads at a glance:
  - `material:<token>` → an exact-material query.
  - `prefix:<token>` → a part-number-prefix query.
  - `max:<cents>` → a price ceiling (at most).
  - `min:<cents>` → a price floor (at least).
- `parse_query(text) -> Query` — split on the first colon, match the key, and either keep the value slice (a text query, bounded to `max_query_text`) or parse the cents (`parse_int`, ceiling-checked against `max_price_cents`). The value slice points into the caller's own text, copied only when the filter re-adds a match — the parser allocates nothing.
- `QueryParseError` — `NoColon`, `EmptyKey`, `EmptyValue`, `UnknownKey`, `BadPrice`, beside `part_filter`'s own `QueryTextTooLong` and `part_catalog`'s `PriceTooLarge`, each reached by the fault it names.

## Boundaries

Pure parsing over public APIs — the parser never touches storage, a codec, a palette, or a key. A price token is read as a **fact to compare**, parsed to a `u64` count of cents and ceiling-checked exactly as `add_part` checks a stored price; it is never a balance the tree can move (custody gate #3 untouched). No network, no funds. The value slice is borrowed from the caller's line, so a query lives exactly as long as the text it was typed into.

*May a keeper type `material:stainless-304` and mean it — and may a line that says nothing clear refuse, rather than quietly narrow the world to the wrong seven parts.*
