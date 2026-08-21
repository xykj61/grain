# Delivery wire cluster — copy_disjoint ratchet turn

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.140812

## Prompt

Keep going — next mechanical bench after parity **190**.

## Thinking trace

Policy from `053212`: migrate `@memcpy` to `copy_disjoint` on touch, not in one sweep. Five Mantra delivery files already edited in the alignment pass still carried eleven bare `@memcpy` calls on the hot wire path — batch, sync, catch-up, subscribe poll, snapshot export.

Each file gained `tally_copy` import and every site became `copy_disjoint(u8, …)`. Targeted witnesses GREEN: batch wire, catch-up wire, subscribe poll wire, snapshot wire, sync lap3 wire. `@memcpy` ratchet **121 → 111** (eleven sites across five files; lint counts one implementation `@memcpy` inside `tally/copy.rye` itself).

## Files

| File | Why |
|------|-----|
| `mantra/recall_batch_delivery.rye` | 6 sites |
| `mantra/recall_catch_up_delivery.rye` | 1 site |
| `mantra/recall_subscribe_poll_delivery.rye` | 1 site |
| `mantra/snapshot_export_delivery.rye` | 1 site |
| `mantra/recall_sync_delivery.rye` | 2 sites |

**Recommend:** keep going to the next ratchet cluster on touch — `snapshot_export.rye` in-process export (many sites) or comlink virtio guests when their labs are next run; commit this turn when Kaeden gives the word.
