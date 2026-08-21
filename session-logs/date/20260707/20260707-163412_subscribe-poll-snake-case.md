# CamelCase on-touch — subscribe poll cluster

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.163412

## Prompt

Keep going.

## Thinking trace

With the >70-line ledger clear, the next mechanical ratchet is camelCase on-touch. Migrated every camelCase `fn` in `caravan/subscribe_poll_service.rye` (11 names) and `mantra/recall_subscribe_poll.rye` (8 names, including public `sleep_interval_ns`, `poll_one_cycle`, `poll_cycles`). Updated `mantra/recall_subscribe_poll_delivery.rye` call sites and renamed local wire helpers to `poll_one_cycle_wire_in_process` / `poll_one_cycle_wire_sockets` after a partial replace.

Ratchet **692 → 671** (−21). Witnesses GREEN: five caravan subscribe-poll witnesses, mantra subscribe poll + interval, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `caravan/subscribe_poll_service.rye` | snake_case for all internal helpers |
| `mantra/recall_subscribe_poll.rye` | snake_case for public poll API + selftests |
| `mantra/recall_subscribe_poll_delivery.rye` | repointed `sp.*` imports; wire helper names |

**Recommend:** say **go** to commit this three-file snake_case bundle; keep going on-touch in `pond/apps/drawn_terminal.rye` (many camelCase fns) or the next file the bench touches.
