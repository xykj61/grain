# Linengrow cluster — copy_disjoint ratchet turn

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.154512

## Prompt

Keep going — after beading cluster.

## Thinking trace

Migrated the remaining application `@memcpy` sites in the linengrow open-asks and receipt stack, plus `recall_tablecloth_query` and the two transcript append sites in `rishi/src/main.rye`. Added `linengrow/tally_copy.rye` → `../tally/copy.rye` so imports match the rest of the tree.

`pond/apps/rishi/main.rye` already carried `copy_disjoint` on those lines — no edit needed.

Witnesses GREEN: SLC-L1/L2 receipt, OA-L1 through OA-L5, tablecloth query, `tame_style_check`. Ratchet **25 → 1** — the sole remaining site is the intentional `@memcpy` inside `tally/copy.rye` itself.

Cumulative uncommitted arc: **121 → 1** (application surface complete).

## Files

| File | Sites |
|------|-------|
| `linengrow/tally_copy.rye` | symlink (new) |
| `linengrow/receipt_core.rye` | 4 |
| `linengrow/receipt.rye` | 2 |
| `linengrow/open_asks.rye` | 10 |
| `linengrow/open_asks_lap5_delivery.rye` | 4 |
| `linengrow/open_asks_delivery.rye` | 1 |
| `mantra/recall_tablecloth_query.rye` | 1 |
| `rishi/src/main.rye` | 2 |

**Recommend:** say **go** to commit the full ratchet arc (beading + linengrow turns and all prior uncommitted migrations) in one bundle; application `@memcpy` is done.
