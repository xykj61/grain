# Spawn lap 2 — two-way sync wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.033000

**Prompt:** `go then kg` — push five-lab batch, migrate two-way sync device wire.

## Thinking trace

**`go`:** Committed `bcb79e3` — receipt through recall batch (five `.rish` labs + delegates) — pushed to all four remotes.

**`kg`:** Seventh spawn lap 2 migration: `comlink/run_recall_two_way_sync_wire_lab.sh` — phase 1 peerB (NS-L3 sync guests, two hops) then phase 2 peerA (reversed `guest_2way_*`, two hops). Built `tools/comlink_recall_two_way_sync_wire_lab.rish`; `mantra_recall_two_way_sync_wire.rish` GREEN (~21s device phase).

## Files

| File | Why |
|------|-----|
| `tools/comlink_recall_two_way_sync_wire_lab.rish` | Four-hop two-way sync lab |
| `comlink/run_recall_two_way_sync_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Seven comlink labs migrated |

**Recommend:** keep going to **`go`** to ship two-way sync; next **`kg`** can take `run_recall_catch_up_wire_lab.sh`.
