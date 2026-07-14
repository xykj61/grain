# Mantra parse_int symlink + RW-1 contract GREEN

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.044800

## Prompt

`go then kg` — after bundle 39 ship (`e62b7c8`), close mantra wrapper-staging and verify RW-1 full chain.

## Thinking trace

**Go:** committed and pushed `e62b7c8` to origin, github, gp36-codeberg, gp36-github (excluded `tools/bin/`).

**Kg — mantra build:** `mantra/src/main.rye` imported `../parse_int.rye`, which resolved through `mantra/parse_int.rye` → `tally/` outside the wrapper module path. Mirrored the rishi pattern: symlink `mantra/src/parse_int.rye` → `../../tally/parse_int.rye`, import `@import("parse_int.rye")`.

**Kg — rw1_exact_probe:** first native version indexed `[2]` without guarding short tab fields; HEAD commit blobs (`parent none`) crashed. `.len` on a parenthesized split inside `if` hit `NotARecord` in this position; Rishi has no `>` — used `length (split …) == 3` as the guard before field-3 compare, matching `cut -f3` semantics on weave lines.

## Verification

- `rye build mantra/src/main.rye` — succeeds
- `rishi/bin/rishi run tools/rw1_history_contract.rish` — **GREEN**
- `rishi/bin/rishi run tools/rs1_args.rish` — still GREEN

## Files

- `mantra/src/parse_int.rye` — symlink to tally (wrapper-staging seam)
- `mantra/src/main.rye` — import repoint
- `tools/fixtures/rw1_exact_probe.rish` — tab-field guard via `length … == 3`

**Recommend:** say **`go`** to ship mantra symlink + RW-1 GREEN; **`kg`** on the next `.sh` census item stays parked until `let…in`/block-body ruling for `opening_lines_scan` / `tame_check_mantra`.
