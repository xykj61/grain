# Apply sh-migration bundle 39 — two wins, one wall

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.044200

## Prompt

`@files (39).zip` — apply `20260708-042112_sh-migration-two-wins-one-wall.zip` from parent `9300d35`.

## Thinking trace

Unzipped bundle to `/tmp/bundle39/inner/`. Applied the two native fixture repoints, counsel, expanding-prompt, TAME_GUIDANCE POSIX paragraph (list indexing, stream discipline, `where` wall), and TASKS census line beside spawn lap 2.

Updated `tools/rs1_args.rish` to call `rs1_args_max.rish` and assert on `.out` (wrapper forwards `result.err` via `say`). Updated `tools/rw1_history_contract.rish` to call `rw1_exact_probe.rish` instead of the `.sh` elder.

## Verification

- `rishi/bin/rishi run tools/rs1_args.rish` — **GREEN** (all four assertions).
- `rishi/bin/rishi run tools/rw1_history_contract.rish` — fails at mantra self-provision: pre-existing `mantra/src/main.rye` wrapper-staging error (`import of file outside module path` for `../parse_int.zig`). Out of scope for this bundle; counsel and apply-prompt already held this.

## Observations

- List indexing (`expr[n]`, `.len`) and stream discipline (`say` → stdout, runtime errors → stderr) are now recorded in TAME_GUIDANCE.
- Real grammar wall: `where` input must be a bound name — blocks `opening_lines_scan.sh` and `tame_check_mantra.sh` until `let…in` or block-body for loops is ruled.
- Regex-dependent fixtures and `slc1_accept.sh` stdin question remain `.sh` per census.

## Files

- `tools/fixtures/rs1_args_max.rish` — created; RS-1 max-args native repoint
- `tools/fixtures/rw1_exact_probe.rish` — created; RW-1 exact-byte probe native repoint
- `tools/rs1_args.rish` — updated wrapper + stream assertion fix
- `tools/rw1_history_contract.rish` — repointed to native probe
- `context/TAME_GUIDANCE.md` — POSIX seams paragraph expanded
- `work-in-progress/TASKS.md` — census `[x]` + last-updated stamp
- `counsel/20260708-042112_claude-counsel-sh-migration-wall-found.md` — filed
- `expanding-prompts/20260708-042112_apply-sh-migration.md` — filed

**Recommend:** say **`go`** to ship this batch; then **`kg`** on mantra `parse_int` wrapper-staging if RW-1 full chain should go GREEN on metal.
