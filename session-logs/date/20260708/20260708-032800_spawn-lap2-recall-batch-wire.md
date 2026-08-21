# Spawn lap 2 — recall batch wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.032800

**Prompt:** `kg` — migrate NS-L3 recall batch device wire lab.

## Thinking trace

Sixth spawn lap 2 migration: `comlink/run_recall_batch_wire_lab.sh` — request (**15563**) and batch response (**15564**). Built `tools/comlink_recall_batch_wire_lab.rish`; banners `"sealed batch request GREEN"` and `"sealed beaded batch response GREEN"`.

`mantra_recall_batch_wire.rish` GREEN.

## Files

| File | Why |
|------|-----|
| `tools/comlink_recall_batch_wire_lab.rish` | Native batch two-hop lab |
| `comlink/run_recall_batch_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Six comlink labs migrated |

**Recommend:** keep going to **`go`** to ship receipt-through-batch batch; next **`kg`** can take `run_recall_two_way_sync_wire_lab.sh`.
