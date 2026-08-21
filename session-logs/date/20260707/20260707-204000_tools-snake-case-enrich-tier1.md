# Tools snake_case — enrich Tier 1

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.204000

**Prompt:** `kg` — enrich Tier 1 per counsel `201912`.

## Thinking trace

Renamed **19** camelCase `fn` across five leaf files (`buf`, `scan_text`, `zig_lookup`, `root`, `constants`). Repointed all inbound callers across `enrich/` plus external `resolve_root` (3 files) and `load_zig_sources` (orchestrator).

Witnesses GREEN: `enrich_strengthening_docs`, `align_session_logs`, `session_logs_archive`.

Census: **65 → 46** remaining (tiers 2–5).

## Files

| File | Why |
|------|-----|
| `tools/enrich/{buf,scan_text,zig_lookup,root,constants}.rye` | Tier 1 renames |
| `tools/enrich/*.rye` (callers) | Inbound repoint |
| `tools/align_session_logs.rye`, `session_logs_archive.rye`, `enrich_strengthening_docs.rye` | External repoint |
| `work-in-progress/TASKS.md` | 46 remaining; Tier 2 next |

**Recommend:** say **`go`** to ship counsel `201912` + Tier 1 + prior clusters. **`keep going`** to Tier 2 on next `kg`.
