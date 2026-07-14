# Spawn lap 2 — subscribe-poll wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.033200

**Prompt:** `kg` — migrate outer subscribe-poll device wire lab.

## Thinking trace

Ninth spawn lap 2 migration: `comlink/run_recall_subscribe_poll_wire_lab.sh` — one poll-cycle body equals catch-up rev 2 (two hops on **15565/15566**). Built `tools/comlink_recall_subscribe_poll_wire_lab.rish`; reuses catch-up r2 guests.

`mantra_recall_subscribe_poll_wire.rish` GREEN. Prior laps (two-way sync, catch-up) still uncommitted — batch with **`go`**.

## Files

| File | Why |
|------|-----|
| `tools/comlink_recall_subscribe_poll_wire_lab.rish` | Two-hop poll-cycle catch-up lab |
| `comlink/run_recall_subscribe_poll_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Nine comlink labs migrated |

**Recommend:** keep going to **`go`** to ship three-lap batch; next **`kg`** can take `run_open_asks_lap5_wire_lab.sh`.
