# Spawn lap 2 — open asks wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.032300

**Prompt:** `kg` — migrate OA-L2 open asks device wire lab.

## Thinking trace

Third spawn lap 2 migration: `comlink/run_open_asks_wire_lab.sh` carries two hops (request on **15557**, application on **15558**). Built `tools/comlink_open_asks_wire_lab.rish` with four guest builds and two spawn/wait-for cycles — assert `"sealed request GREEN"` then `"sealed application GREEN"`.

Shell entry thinned to delegate to `.rish`. `open_asks_lap2.rish` GREEN end-to-end.

Receipt wire from prior `kg` remains uncommitted alongside this lap — say **`go`** to ship both.

## Files

| File | Why |
|------|-----|
| `tools/comlink_open_asks_wire_lab.rish` | Native two-hop OA-L2 lab |
| `comlink/run_open_asks_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Lap 2 progress — three migrated |

**Recommend:** keep going to **`go`** to commit receipt + open asks wire laps; next **`kg`** can take `run_open_asks_escrow_wire_lab.sh`.
