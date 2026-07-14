# Spawn lap 2 — catch-up wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.033100

**Prompt:** `kg` — migrate catch-up device wire lab.

## Thinking trace

Eighth spawn lap 2 migration: `comlink/run_recall_catch_up_wire_lab.sh` — rev 2 and rev 3 catch-up hops (**15565/15566**), four spawn/wait-for cycles. Success banners on response RX: `"catch-up rev 2 GREEN"` and `"catch-up rev 3 GREEN"`.

`mantra_recall_catch_up_wire.rish` GREEN. Two-way sync lap from prior `kg` still uncommitted — batch both with **`go`**.

## Files

| File | Why |
|------|-----|
| `tools/comlink_recall_catch_up_wire_lab.rish` | Four-hop rev2+rev3 catch-up lab |
| `comlink/run_recall_catch_up_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Eight comlink labs migrated |

**Recommend:** keep going to **`go`** to ship two-way sync + catch-up; next **`kg`** can take `run_recall_subscribe_poll_wire_lab.sh`.
