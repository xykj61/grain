# Sh-migration kg — tame_check_scan native

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.160100

## Prompt

`kg` — next mechanical cluster (includes uncommitted `155500` batch from prior turn).

## Thinking trace

Prior turn landed `opening_lines_scan.rish` and `tame_check_mantra.rish` (still uncommitted at `9d6b581`). This turn: `tame_check_scan.rish` — same map + record + `where (lines (read-file f))` idiom for TH-2 rules (qualified assert, `Self = @This()`, tabs, trailing space/tab via `ends-with`). Repointed `tools/tame-check.rish`.

Native output byte-matches the `.sh` elder on all 16 roster files.

## Verification

- `diff` native vs `tame_check_scan.sh` — identical
- `rishi/bin/rishi run tools/tame-check.rish` — **GREEN**

## Files

- `tools/fixtures/tame_check_scan.rish` — created
- `tools/tame-check.rish` — repointed
- Plus uncommitted from `155500`: opening_lines, tame_check_mantra fixtures + witnesses, TAME_GUIDANCE, TASKS

**Recommend:** say **`go`** to ship the full sh-migration batch (`155500` + `160100`); regex-gated fixtures (`chrono_version_scan`, `identity_shape`, `two_rooms_doorway_scan`, `designed_not_built_scan`, `tame_style_long_fn`) stay `.sh`.
