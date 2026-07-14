# Sh-migration kg — chrono_version_scan native

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.160300

## Prompt

`kg` — next mechanical cluster (includes uncommitted `155500`–`160200`).

## Thinking trace

`chrono_version_scan.sh` used grep semver regex. Native port: `chrono_version_roster.sh` keeps glob expansion; scan logic uses summed `where`/`contains` backtick needles (`\`v0.`…`\`99.`) on `**Version:**` lines — no regex engine, same witness class as camelCase ratchet.

OK/FAIL lines byte-match the grep elder on the live corpus; witness `chrono_version_sweep.rish` GREEN.

## Verification

- `diff` OK/FAIL lines native vs grep elder — identical
- `rishi/bin/rishi run tools/chrono_version_sweep.rish` — **GREEN**

## Files

- `tools/fixtures/chrono_version_scan.rish` — created
- `tools/fixtures/chrono_version_roster.sh` — glob helper
- `tools/fixtures/chrono_version_scan.sh` — thin delegate
- `tools/chrono_version_sweep.rish` — repointed

**Recommend:** say **`go`** to ship the full sh-migration batch (`155500`–`160300`); `identity_shape`, `two_rooms_doorway_scan`, `designed_not_built_scan`, `tame_style_long_fn`, `slc1_*` stay `.sh`.
