# Comlink virtio guests — copy_disjoint ratchet turn

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.153812

## Prompt

Keep going — comlink virtio guests next.

## Thinking trace

Twenty-three `comlink/guest_*.rye` TX/RX virtio legs each carried one bare `@memcpy` on the sealed-payload append path (or log-line append for poster/consent RX). Added `tally_copy` import beside `virtio_net`; every site became `copy_disjoint(u8, …)`.

Device-wire witnesses GREEN: `comlink_device_wire`, sync lap3 wire, OA-L3 escrow, snapshot wire, batch wire, catch-up wire, two-way wire, OA-L5, SLC-L2 receipt. `@memcpy` ratchet **101 → 78**. Cumulative from `053212` landing: **121 → 78** across delivery, snapshot export, and guests (uncommitted with prior turns).

## Files

| File | Why |
|------|-----|
| `comlink/guest_*.rye` (23) | One `@memcpy` each → `copy_disjoint` |

**Recommend:** keep going to `recall_sync_wire.rye` / `wire_format.rye` shared wire modules next, or say **go** to commit the full ratchet cluster.
