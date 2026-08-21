# recall_batch + snapshot delivery snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.172758

## Prompt

kg.

## Thinking trace

Touched the two remaining mantra delivery binaries — private helpers, in-file only:

- `recall_batch_delivery.rye` — **27** fns (`recv_wire_timeout`, `recv_batch_payload`, `run_chunk_demo`, …)
- `snapshot_export_delivery.rye` — **13** fns (`fetch_snapshot_over_wire`, `send_batch_payload`, …)

Applied **`recv_buf`** preemptively in `recv_batch_payload` loops before `recvWire` → `recv_wire` (lesson from prior delivery pass).

Ratchet **324 → 284** (−40). Witnesses GREEN: `mantra_recall_batch_wire`, `mantra_snapshot_wire`, `tame_style_check`.

Full uncommitted bundle from committed tip: **462 → 284** (−178).

## Files

| File | Why |
|------|-----|
| `mantra/recall_batch_delivery.rye` | batch wire delivery helpers |
| `mantra/snapshot_export_delivery.rye` | snapshot wire delivery helpers |

**Recommend:** say **go** to commit and push the full uncommitted snake_case bundle; **keep going** to mantra library modules (`recall_two_way_sync.rye`, `snapshot_export.rye`, `beading.rye`, …) on the next kg.
