# Tools snake_case — enrich Tier 4

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.205500

**Prompt:** `kg` — enrich Tier 4 per counsel `201912`.

## Thinking trace

Renamed **5** camelCase `fn` across `enrich_file.rye`, `sync.rye`; repointed orchestrator `enrich_strengthening_docs.rye` and internal callers in `crosswalk.rye`, `lexicon.rye`. Updated witness prose in `enrich_strengthening_docs.rish`.

Witness GREEN: `enrich_strengthening_docs` (required after orchestrator touch).

Census: **9 → 4** remaining (Tier 5 only).

## Files

| File | Why |
|------|-----|
| `tools/enrich/enrich_file.rye` | `enrich_file` |
| `tools/enrich/sync.rye` | 4 fn |
| `tools/enrich_strengthening_docs.rye` | Orchestrator repoint |
| `tools/enrich_strengthening_docs.rish` | Comment alignment |
| `tools/enrich/{crosswalk,lexicon}.rye` | `list_pass_docs` callers |

**Recommend:** **`keep going`** to Tier 5 on next `kg` — final 4 fn + orchestrator repoint closes the enrich subsystem.
