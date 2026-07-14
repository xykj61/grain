# recall_batch_wire snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.172437

## Prompt

kg.

## Thinking trace

Touched **`mantra/recall_batch_wire.rye`** — **8** pub fns (`encode_request`, `decode_request`, `batch_chunk_count`, `encode_batch_response`, `encode_batch_chunk`, `decode_batch_response`, `run_chunk_wire_selftest`, `apply_wire_batch`). `BatchAssembler.feed` / `.batch` were already snake_case.

Repointed **10** callers via `bw.*` only (batch + snapshot guests, `recall_batch_delivery`, `snapshot_export_delivery`).

Ratchet **410 → 402** (−8). Witnesses GREEN: `mantra_recall_batch_wire`, `mantra_resin_batch`, `tame_style_check`.

Stacks on uncommitted bundle (receipt, resin_batch, recall_lap1, recall_beaded, sync_wire, catch_up).

## Files

| Cluster | Why |
|---------|-----|
| `mantra/recall_batch_wire.rye` | batch wire encode/decode/apply API |
| 10 callers | `bw.*` prefix repoint |

**Recommend:** say **go** to commit the full uncommitted snake_case bundle; **keep going** to delivery-module helpers (`recall_sync_delivery`, `recall_catch_up_delivery`, …) camelCase on the next kg.
