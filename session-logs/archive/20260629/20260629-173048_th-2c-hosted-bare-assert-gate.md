# TH-2c — hosted bare assert; tame-check gates the corpus

**Editor:** Cursor · **Model:** Composer  
**Stamp:** 20260629.173048

## Thinking trace

Continued from the handoff summary mid-TH-2c. Finished the mechanical rename on the remaining hosted modules: `caravan/bounded.rye`, `caravan/twin.rye`, `caravan/chain.rye`, and `rishi/src/main.rye` (import already present — calls only). Prior partial edits on Tally, Caravan seed, Comlink, and Brushstroke were already in the working tree.

Flipped `tools/tame-check.rish` from informational to a hard gate (`assert length fails == 0`). Updated `tools/tame_check_th2.rish` to expect `TAME CHECK GREEN`. Added `tools/tame_check_th2c.rish` and registered it in `tools/parity.rish` (124 suite witnesses). Updated bench docs: `TASKS.md`, `ROADMAP.md`, `context/TAME_GUIDANCE.md`, `992` width baseline.

Metal: `tame_check_scan.sh` → 15/15 OK; `tame-check.rish`, `tame_check_th2c.rish`, and full `parity.rish` green with `HOME=/home/xy/veganreyklah2/.build-home`.

## Observations

- Aurora stays on freestanding `fn assert` — excluded from the rename; scan still passes (no `std.debug.assert(`).
- **Next pause:** TH-3 (`mantra/*` Phase 1b width) needs Claude strategy before Cursor touches slice indices or extends the width-check file list.
- Changes are uncommitted until Kaeden asks for a commit and four-remote push.

## Files

| File | Why |
|------|-----|
| `tally/seed.rye`, `tally/gardens.rye` | import-once + bare `assert(` |
| `caravan/*.rye` (4 files) | same |
| `brushstroke/seed.rye`, `comlink/hosted_wire.rye` | same |
| `rishi/src/main.rye` | bare `assert(` on existing binding |
| `tools/tame-check.rish` | hard gate |
| `tools/tame_check_th2.rish`, `tools/tame_check_th2b.rish` | witness strings aligned |
| `tools/tame_check_th2c.rish` | new TH-2c witness |
| `tools/parity.rish` | register TH-2c |
| `work-in-progress/TASKS.md`, `ROADMAP.md` | TH-2c done; TH-3 Claude pause |
| `context/TAME_GUIDANCE.md`, `992` baseline | tame-check is a gate |
