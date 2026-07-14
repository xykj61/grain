# Spawn lap 2 complete — aurora run native

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.033600

**Prompt:** Claude counsel bundle — close `aurora/run.sh` migration; structural POSIX seam complete.

## Thinking trace

Kaeden forwarded Claude's verified counsel on the spawn arc closure. The eleven comlink wire labs were already shipped (`e8a24ad`); `aurora/run.sh` remained.

Implemented per counsel:

- `tools/aurora_run.rish` — `join args ""` for optional stage (default `seed`); `RYE_SMP` / `RYE_ZIG` from env; build + blocking QEMU `run`; `exit wake.code`
- `aurora/run.sh` — thin `exec` delegate with `"$@"` passthrough
- `tools/aurora_run_witness.rish` — missing stage exits **2** (no parity wiring — developer utility)
- Counsel [`counsel/20260708-035600_claude-counsel-aurora-run-migration.md`](../counsel/20260708-035600_claude-counsel-aurora-run-migration.md)
- `TAME_GUIDANCE.md`, `TASKS.md`, `ROADMAP.md`, `aurora/README.md` updated

Verified: witness GREEN; `seed` wake GREEN (exit 0); `tame_style_check.rish` GREEN.

## Files

| File | Why |
|------|-----|
| `tools/aurora_run.rish` | Native aurora build + wake |
| `aurora/run.sh` | Thin delegate |
| `tools/aurora_run_witness.rish` | Missing-stage exit proof |
| `counsel/20260708-035600_*.md` | Closure ruling |
| `context/TAME_GUIDANCE.md` | POSIX seam taxonomy updated |

**Recommend:** keep going to **`go`** to ship spawn lap 2 closure; SLC-L3 settlement remains Kaeden's gate.
