# Spawn lap 2 — go batch (all comlink wire labs complete)

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.033500

**Prompt:** `go full summary and commits and pushes`

## Thinking trace

Kaeden asked for **`go`** with full summary. This commit ships the five remaining comlink wire-lab migrations (two-way sync through snapshot export) that accumulated since `bcb79e3`. All eleven `comlink/run_*_wire_lab.sh` scripts now thin-delegate to `tools/comlink_*_wire_lab.rish`; witnesses GREEN on metal before commit.

Pushed `e8a24ad` to origin, github, gp36-codeberg, gp36-github. Excluded `tools/bin/`.

## Spawn arc — four commits on main

| Commit | Content |
|--------|---------|
| `60fe5c5` | Lap 1: `spawn` / `wait-for` in Rishi + witnesses |
| `7641104` | Lap 2 start: device wire lab |
| `bcb79e3` | Receipt, open asks, escrow, recall sync, recall batch |
| `e8a24ad` | Two-way sync, catch-up, subscribe-poll, OA-L5, snapshot |

**Remaining on spawn lap 2:** `aurora/run.sh` only — single blocking QEMU wake; may need only `run`, not spawn.

## Files (this commit)

| File | Why |
|------|-----|
| 5× `tools/comlink_*_wire_lab.rish` | Native orchestration |
| 5× `comlink/run_*_wire_lab.sh` | Thin delegates |
| `work-in-progress/TASKS.md` | All comlink labs checked |
| 5 session logs + README index | Trace |

**Recommend:** keep going to **`kg`** on `aurora/run.sh` — mechanical if blocking `run` suffices; check in with Claude if SMP or stage-args need design.
