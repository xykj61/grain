# RS-1 through RS-3 — script args, flag helper, launch-cursor graduation

**Editor:** Cursor · **Model:** Composer  
**Stamp:** 20260629.195133

## Thinking trace

Continued the Rishi script-arguments arc after Claude's RS-1 ruling (uncommitted from prior turn).

**RS-1:** `bindScriptArgs` pre-binds `args[3..]` as `.list` of `.string`; `.len` and `[n]`; `max_args`; friendly OOB; witnesses green. Fixed `findListOpenBracket` (findTopLevel cannot match `[`) and comparison trim.

**RS-2:** Pure `.rish` cannot scan args with mutable state (no while, for-each child scope). Added `flag <list> <name>` builtin — same family as `length`/`join` — scans for exact `--name` token, returns the following string; friendly `FlagNotFound` / `FlagNeedsValue`. Witness `tools/rs2_flag.rish`.

**RS-3:** `launch-cursor.rish` reads `--appimage` and `--gpu` via `flag` and `contains` (single-line `if` — multi-line blocks are line-at-a-time). `cursor-jail.sh` accepts positional APPRUN; `--appimage` kept as legacy. `--extract` stays on the shell driver for now. Witness `tools/rs3_launch_cursor.rish`.

Parity **130** green; SLC-1 repl unchanged.

## Observations

RS-2 landed one small interpreter surface rather than a `.rish` library — honest given no indexed loop with assignment. Value model still five shapes.

**Recommend: keep going to Comlink width** under the written seam policy (`u64` wire offsets) — mechanical unless a layout question the policy does not place.

**Recommend: check in with Claude** only if Comlink wire layout surfaces a width the policy does not answer, or before Aurora freestanding width rules.

## Files

| File | Why |
|------|-----|
| `rishi/src/main.rye` | RS-1 args bind; list `.len`/`[n]`; RS-2 `flag` |
| `tools/rs1_args.rish`, `tools/rs2_flag.rish`, `tools/rs3_launch_cursor.rish` | witnesses; parity 130 |
| `tools/launch-cursor.rish`, `tools/cursor-jail.sh` | RS-3 launcher graduation |
| `work-in-progress/TASKS.md`, `ROADMAP.md` | RS-1–RS-3 done |
