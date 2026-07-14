# Spawn lap 2 — snapshot export wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.033400

**Prompt:** `kg` — migrate last comlink wire lab (snapshot export).

## Thinking trace

Eleventh and final comlink spawn lap 2 migration: `comlink/run_snapshot_export_wire_lab.sh` — request + response hops on **15567/15568**. Built `tools/comlink_snapshot_export_wire_lab.rish`.

`mantra_snapshot_wire.rish` GREEN. **All eleven `comlink/run_*_wire_lab.sh` scripts now delegate to native Rishi.** Only `aurora/run.sh` remains on the spawn lap 2 list — single-process blocking QEMU (may need only `run`, not spawn).

Five prior laps still uncommitted — batch with **`go`**.

## Files

| File | Why |
|------|-----|
| `tools/comlink_snapshot_export_wire_lab.rish` | I2 snapshot two-hop lab |
| `comlink/run_snapshot_export_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Comlink wire-lab arc complete |

**Recommend:** keep going to **`go`** to ship five-lap batch; next **`kg`** can scope `aurora/run.sh` — check in with Claude if aurora needs spawn or only `run`.
