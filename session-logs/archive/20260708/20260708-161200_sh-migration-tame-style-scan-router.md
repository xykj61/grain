# Sh-migration kg — tame_style_scan mode router

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.161200

## Prompt

`kg` — next mechanical `.sh` → `.rish` cluster.

## Thinking trace

Migrated `tools/fixtures/tame_style_scan.sh` to thin delegate → `tools/tame_style_scan.rish` mode router (`bans` default, `advise`, `*-legacy` parity scripts). Legacy bodies extracted to `tame_style_scan_bans_legacy.sh` and `tame_style_scan_advise_legacy.sh`; advise-legacy `>70` section calls `tame_style_long_fn.rish`. `assert … else` inside `if-then` fails (`UnknownStatement`) — use bare `assert legacy.ok`.

## Verified

- `sh tools/fixtures/tame_style_scan.sh bans` — GREEN
- `tame_style_scan_advise_selftest` — GREEN
- `tame_style_check.rish` — GREEN

## Files

- `tools/tame_style_scan.rish` — created
- `tools/fixtures/tame_style_scan.sh` — thin delegate
- `tools/fixtures/tame_style_scan_bans_legacy.sh` — extracted
- `tools/fixtures/tame_style_scan_advise_legacy.sh` — extracted
- `tools/tame_style_scan_bans.rish` — comment update
- `context/TAME_GUIDANCE.md` — census `161200`
- `work-in-progress/TASKS.md` — census extended

**Recommend:** say **`go`** to ship `161000`–`161200`; witness-support census effectively complete; `slc1_*` and orchestration `.sh` stay.
