# Spawn lap 2 — receipt wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.032200

**Prompt:** `go then kg` — push device wire lap 2, migrate receipt wire lab.

## Thinking trace

**`go`:** Committed `7641104` (device wire `.rish` + thin shell delegate + TASKS + session log) and pushed to origin, github, gp36-codeberg, gp36-github.

**`kg`:** Second spawn lap 2 migration — `comlink/run_receipt_wire_lab.sh`. Same pattern as device wire: builds via `run`, RX via `spawn`, `sleep 1`, TX via blocking `run`, `wait-for` RX, assert `"sealed receipt GREEN"` in captured stdout. Port from `env "COMLINK_RECEIPT_LAB_PORT"` default **15556**.

Shell entry thinned to `exec rishi/bin/rishi run tools/comlink_receipt_wire_lab.rish`. `slcl2_receipt.rish` GREEN end-to-end (hosted + device wire).

## Files

| File | Why |
|------|-----|
| `tools/comlink_receipt_wire_lab.rish` | Native spawn/wait-for SLC-L2 receipt lab |
| `comlink/run_receipt_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Lap 2 progress — two of seven+ migrated |

**Recommend:** keep going to **`go`** to ship receipt wire; next **`kg`** can take `run_open_asks_wire_lab.sh` (OA-L2 pattern).
