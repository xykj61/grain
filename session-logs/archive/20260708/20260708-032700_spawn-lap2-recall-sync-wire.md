# Spawn lap 2 — recall sync wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.032700

**Prompt:** `kg` — migrate NS-L3 recall sync device wire lab.

## Thinking trace

Fifth spawn lap 2 migration: `comlink/run_recall_sync_wire_lab.sh` — request hop (**15561**) and response hop (**15562**). Built `tools/comlink_recall_sync_wire_lab.rish`; banners `"sealed sync request GREEN"` and `"sealed sync response GREEN"`.

`mantra_recall_lap3_wire.rish` GREEN. Prior laps still uncommitted — batch with **`go`**.

## Files

| File | Why |
|------|-----|
| `tools/comlink_recall_sync_wire_lab.rish` | Native NS-L3 two-hop sync lab |
| `comlink/run_recall_sync_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Five comlink labs migrated |

**Recommend:** keep going to **`go`** to ship the accumulated batch; next **`kg`** can take `run_recall_batch_wire_lab.sh`.
