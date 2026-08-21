# TH-4 and TH-5 — .brix mend and Rishi width

**Editor:** Cursor · **Model:** Composer  
**Stamp:** 20260629.175959

## Thinking trace

Continued the TAME hardening bench after Claude's TH-3 ruling and silo filing.

**TH-4:** Replaced retired `.brix` paths (`995_open_threads`, `996_roadmap`) with `work-in-progress/ROADMAP.md` and `TASKS.md`; stamped `version 20260629.004912`. Added `tools/width_check_th4.rish` (fixture-style `grep -q` via shell — direct `grep` in `run` failed `ok`).

**TH-5:** Migrated all authored `usize` in `rishi/src/main.rye` to `u32` under the written seam policy — `Env`, `StrBuf`, `History`-adjacent buffers, parser indices, `TokenIter`, `TopLevelSplit`, and find helpers now return `?u32`. Seam casts at slice indices; `@as(u32, @intCast(...))` where Zig needed explicit result types. Built with `rye/bin/rye build rishi/src/main.rye`; SLC-1 repl witness green. Added `tools/width_check_th5.rish`; parity **127** green.

Global `width-check`: **RED 2/12** — `comlink/hosted_wire.rye` and `aurora/src/deciding.rye` remain; still outside parity per ruling.

## Observations

Comlink wire offsets are a **`u64`-leaning** judgment — inherit seam policy yet may need Claude if wire layout questions surface. Aurora freestanding stays deferred.

Changes uncommitted until Kaeden asks.

**Recommend: check in with Claude before RS-1** — Rishi `args[3..]` semantics and value-model exposure cross the shell boundary; mechanical width work is done through TH-5.

## Files

| File | Why |
|------|-----|
| `.brix` | living ROADMAP/TASKS bricks; stamp |
| `rishi/src/main.rye` | TH-5 width migration |
| `tools/width_check_th4.rish`, `tools/width_check_th5.rish`, `tools/parity.rish` | witnesses; parity 127 |
| `work-in-progress/TASKS.md`, `ROADMAP.md`, `992` baseline | bench state |
