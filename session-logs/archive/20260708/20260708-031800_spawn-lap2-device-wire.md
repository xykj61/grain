# Spawn lap 2 — device wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.031800

**Prompt:** `go then kg` — push spawn lap 1, then first wire-lab migration.

## Thinking trace

**`go`:** Committed `60fe5c5` (spawn/wait-for lap 1 + witnesses + TASKS + session log) and pushed to origin, github, gp36-codeberg, gp36-github. Excluded `tools/bin/`.

**`kg`:** First spawn lap 2 proof — migrate `comlink/run_device_wire_lab.sh` background-orchestration to native Rishi. Counsel `195912` named this script as the structural POSIX seam; spawn/wait-for now closes that gap for one lab.

Built `tools/comlink_device_wire_lab.rish`: four guest builds via `run`, two laps each with `spawn` RX (qemu listen), `run sleep 1`, blocking TX `run`, `wait-for` RX, banner assert on captured stdout. Port from `env "COMLINK_LAB_PORT"` with `if`/`then`/`else` binding (Rishi has no ternary — `let port = if …` fails with `UndefinedName`).

Thin shell delegate preserves stable path: `comlink/run_device_wire_lab.sh` execs `rishi/bin/rishi run tools/comlink_device_wire_lab.rish`. `comlink_device_wire.rish` unchanged entry — still calls the shell path; witness GREEN.

## Observations

- Capturing qemu output via spawn pipes replaces log-file grep; same banners, less shell.
- Pattern is repeatable for the remaining six comlink wire labs + `aurora/run.sh` (aurora is single-process blocking — may only need `run`, not spawn).
- Eleven `run_*_wire_lab.sh` exist; counsel counted seven at `195912` — TASKS tracks six remaining comlink labs + aurora.

## Files

| File | Why |
|------|-----|
| `tools/comlink_device_wire_lab.rish` | Native spawn/wait-for QEMU lab |
| `comlink/run_device_wire_lab.sh` | Thin delegate to `.rish` |
| `work-in-progress/TASKS.md` | Lap 2 progress — device wire done |

**Recommend:** keep going to **`go`** to ship lap 2 device wire; next **`kg`** can migrate `run_receipt_wire_lab.sh` using the same spawn pattern.
