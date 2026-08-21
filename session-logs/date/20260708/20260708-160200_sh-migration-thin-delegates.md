# Sh-migration kg — thin delegates for native fixtures

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.160200

## Prompt

`kg` — next mechanical cluster (includes uncommitted `155500`–`160100` from prior turns).

## Thinking trace

Attempted native `designed_not_built_scan.rish` — nested `where` inside `where` predicates with `as ln2` hits `PipelineNeedsAs`; map+record with inner `as ln` hits the same. Parked; grep elder stays.

Landed thin delegates (`session_logs_archive.sh` pattern) for five migrated elders: `opening_lines_scan`, `tame_check_mantra`, `tame_check_scan`, `rs1_args_max`, `rw1_exact_probe`.

## Verification

- `rishi/bin/rishi run tools/opening_lines_witness.rish` — GREEN
- `rishi/bin/rishi run tools/tame-check.rish` — GREEN
- `rishi/bin/rishi run tools/tame_check_th2b.rish` — GREEN
- `rishi/bin/rishi run tools/rs1_args.rish` — GREEN
- `sh tools/fixtures/opening_lines_scan.sh` delegates to native (output matches)

## Files

- Five `tools/fixtures/*.sh` — thin `exec rishi … run …rish`
- Plus uncommitted: `155500` + `160100` batches (opening_lines, tame_check_mantra, tame_check_scan)

**Recommend:** say **`go`** to ship the full sh-migration batch; `designed_not_built_scan` and regex roster stay `.sh` until `let…in` or a nested-where grammar fix.
