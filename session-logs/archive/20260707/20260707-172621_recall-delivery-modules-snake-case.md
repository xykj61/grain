# recall delivery modules snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.172621

## Prompt

kg.

## Thinking trace

Touched four mantra delivery binaries — private helpers only, in-file renames (no import-prefix callers):

- `recall_sync_delivery.rye` — **14** fns
- `recall_catch_up_delivery.rye` — **19** fns
- `recall_two_way_sync_delivery.rye` — **20** fns
- `recall_subscribe_poll_delivery.rye` — **25** fns

**Shadow fix:** `recvWire` → `recv_wire` collided with existing local `var recv_wire` buffers; renamed locals to `recv_buf` in all four files.

Ratchet **402 → 324** (−78). Witnesses GREEN: lap3 wire, catch-up wire, two-way wire, subscribe poll wire + stop, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| 4 `recall_*_delivery.rye` | wire/socket helper snake_case |
| recv_buf rename | resolve fn/local shadow |

**Recommend:** say **go** to commit the full uncommitted bundle; **keep going** to `recall_batch_delivery.rye` + `snapshot_export_delivery.rye` on the next kg.
