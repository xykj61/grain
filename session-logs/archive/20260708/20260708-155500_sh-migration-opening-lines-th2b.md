# Sh-migration kg — opening_lines + tame_check_mantra native

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.155500

## Prompt

`kg` — next mechanical cluster after `9d6b581`.

## Thinking trace

Counsel `042112` parked `opening_lines_scan` and `tame_check_mantra` behind a `where`-input wall. Re-read `tame_style_scan_advise.rish`: `map` + `where (lines (read-file f))` already works for multi-line scans. The wall is narrower — inline computed bindings as `where` input fail; record staging in `map` does not.

Built native fixtures using `map` → record fields (`bind_a`, `qual_a`, …) → chained `if`/`else` `for-each` for OK/FAIL lines. No `or` in predicates (undefined); TH-2b uses two `where` filters + separate asserts.

Confirmed `run` `.stdin = .ignore` — documents `slc1_*` as permanent `.sh` in TAME_GUIDANCE.

## Verification

- `rishi/bin/rishi run tools/fixtures/opening_lines_scan.rish` — 18 OK lines
- `rishi/bin/rishi run tools/opening_lines_witness.rish` — GREEN
- `rishi/bin/rishi run tools/fixtures/tame_check_mantra.rish` — GREEN
- `rishi/bin/rishi run tools/tame_check_th2b.rish` — GREEN

## Files

- `tools/fixtures/opening_lines_scan.rish` — created
- `tools/fixtures/tame_check_mantra.rish` — created
- `tools/opening_lines_witness.rish` — repointed to native
- `tools/tame_check_th2b.rish` — repointed to native
- `context/TAME_GUIDANCE.md` — POSIX paragraph narrowed
- `work-in-progress/TASKS.md` — census extended

**Recommend:** say **`go`** to ship; further `.sh` census (`chrono_version_scan`, `identity_shape`, `two_rooms_doorway_scan`, `tame_check_scan`, `slc1_*`) stays regex- or stdin-gated.
