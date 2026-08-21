# receipt_core snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.170612

## Prompt

Go then kg.

## Thinking trace

After open_asks push (`7ef7d0a`), migrated **14** camelCase `fn` in `linengrow/receipt_core.rye` and repointed **16** `rc.*` callers (delivery, receipt, open_asks, guests). Scoped pattern — no global replace.

Ratchet **476 → 462** (−14). Witnesses GREEN: `slcl2_receipt`, OA-L1, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `linengrow/receipt_core.rye` | receipt fact/payload API snake_case |
| 16 callers | `rc.*` repoint |

**Recommend:** say **go** to commit receipt_core bundle + open_asks commit-push log.
