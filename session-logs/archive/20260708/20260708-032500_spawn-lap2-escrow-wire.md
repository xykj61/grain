# Spawn lap 2 — open asks escrow wire lab in Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.032500

**Prompt:** `kg` — migrate OA-L3 escrow device wire lab.

## Thinking trace

Fourth spawn lap 2 migration: `comlink/run_open_asks_escrow_wire_lab.sh` — hold hop (**15559**) and release hop (**15560**). Built `tools/comlink_open_asks_escrow_wire_lab.rish` mirroring the OA-L2 two-hop pattern; banners `"sealed hold GREEN"` and `"sealed release GREEN"`.

Shell delegate + `open_asks_lap3.rish` GREEN.

Prior laps (receipt, open asks) still uncommitted — batch with **`go`**.

## Files

| File | Why |
|------|-----|
| `tools/comlink_open_asks_escrow_wire_lab.rish` | Native hold + release hops |
| `comlink/run_open_asks_escrow_wire_lab.sh` | Thin delegate |
| `work-in-progress/TASKS.md` | Four comlink labs migrated |

**Recommend:** keep going to **`go`** to ship receipt through escrow batch; next **`kg`** can take `run_recall_sync_wire_lab.sh`.
