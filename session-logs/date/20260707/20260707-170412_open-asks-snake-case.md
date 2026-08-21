# open_asks snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.170412

## Prompt

Kg (keep going).

## Thinking trace

Migrated all **59** camelCase `fn` declarations in `linengrow/open_asks.rye` (canonical; `comlink/open_asks.rye` symlinks here). Repointed **17** caller files via `oa.*` prefix only — avoided a first overly broad global replace that had touched unrelated `runSelftest` / `bufLenU32` sites in tally and mantra.

Ratchet **535 → 476** (−59). Witnesses GREEN: OA-L1 through OA-L5, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `linengrow/open_asks.rye` | full module snake_case |
| 17 callers | `oa.*` import repoint |

**Recommend:** say **go** to commit; keep going on-touch in `linengrow/receipt_core.rye` (overlapping helper names, separate module).
