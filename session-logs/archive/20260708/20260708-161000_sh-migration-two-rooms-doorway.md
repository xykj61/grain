# Sh-migration kg — two_rooms_doorway_scan native orchestration

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.161000

## Prompt

`kg` — next mechanical `.sh` → `.rish` cluster.

## Thinking trace

Full inline native blocked: no `<` for stamp compare, no `if` in `map`, no `and`/`or` for room register, `run ["sh" "-c" "[ a \< b ]"]` fails under Rishi argv escaping.

Landed **native orchestration** pattern (chrono roster class): `two_rooms_doorway_scan.rish` maps `run scan_one` per file, aggregates fails, exits 1; `two_rooms_doorway_roster.sh` preserves glob order and README skip; `two_rooms_doorway_scan_one.sh` holds per-file POSIX logic; elder `.sh` thin-delegates; `two_rooms_doorway.rish` repointed.

Byte-identical output vs pre-migration scan; witness GREEN.

## Files

- `tools/fixtures/two_rooms_doorway_scan.rish` — created
- `tools/fixtures/two_rooms_doorway_scan_one.sh` — per-file seam
- `tools/fixtures/two_rooms_doorway_roster.sh` — glob helper
- `tools/fixtures/two_rooms_doorway_scan.sh` — thin delegate
- `tools/two_rooms_doorway.rish` — repointed
- `context/TAME_GUIDANCE.md` — census `161000`
- `work-in-progress/TASKS.md` — census extended

**Recommend:** say **`go`** to ship; `tame_style_long_fn`, `slc1_*` stay `.sh`; full inline doorway waits on `<` or `let…in`.
