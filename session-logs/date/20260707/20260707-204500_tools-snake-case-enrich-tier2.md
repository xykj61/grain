# Tools snake_case — enrich Tier 2

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.204500

**Prompt:** `kg` — enrich Tier 2 per counsel `201912`.

## Thinking trace

Renamed **22** camelCase `fn` across `surfaces.rye`, `witness.rye`, `sections.rye`; repointed all inbound callers within `enrich/` only (no external callers per counsel).

`enrich_strengthening_docs.rish` GREEN.

Census: **46 → 24** remaining (tiers 3–5).

## Files

| File | Why |
|------|-----|
| `tools/enrich/surfaces.rye` | 9 fn |
| `tools/enrich/witness.rye` | 4 fn |
| `tools/enrich/sections.rye` | 9 fn |
| `tools/enrich/*.rye` (callers) | Inbound repoint |
| `work-in-progress/TASKS.md` | 24 remaining |

**Recommend:** **`keep going`** to Tier 3 (`blocks_surface`, `blocks_audit`, `extract`) on next `kg`.
