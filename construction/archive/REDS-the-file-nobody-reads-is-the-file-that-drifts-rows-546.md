# REDS shelf -- the file nobody reads is the file that drifts, row %546

**Language:** EN
**Stamp:** `20260907.045528`
**Status:** Shelf -- immutable once written
**Rows:** `%546` -- folded from [`../REDS.md`](../REDS.md) on `20260907.073623`
**Voice:** Kyri

`tools/fixtures/s/standing_equipment_scope_map.sh` names, per guard, the files that guard watches,
and `standing_equipment_run.sh --scoped` skips a guard no changed path reaches. The row for
`index_row_bound` named four paths, and none of them stood under `session-logs/date/` -- which is
where the guard actually reads, since it gates the OPEN day shelf.

Every lap writes a shelf row and touches nothing that row watched, so a scoped pass skipped the one
guard reading the file the lap had just changed. That is why the misordered-row fault kept being
found at a LATER ship's cold open rather than by the lap that wrote the bad row.

The row grew `session-logs/date/`. Beside it, `tools/fixtures/s/scope_match.sh` now holds the
matcher that the runner and the new ranking both source, so a skip and its price can never be
computed by two different rules, and `tools/fixtures/i/index_shelf_repair.sh` turns the repair a
hand had performed twelve times into a command that proves its output a permutation of its input
before it writes.

**What it taught: the file nobody reads is the file that drifts.** Until the ranking was built,
only the runner read that map, so an under-named row had no reader at all -- and it failed in the
safe-LOOKING direction, since the guard still ran on full passes and the tree stayed green. Only
the skip was wrong.


**REDS %546 (`20260907.045528`) -- the guard that watches the shelf every lap writes could not see the shelf, so a scoped pass skipped it every time.** *What went wrong:* `index_row_bound` gates the OPEN day shelf, `session-logs/date/README-index-<day>.md`, and its row in `tools/fixtures/s/standing_equipment_scope_map.sh` named four paths, none of them under `session-logs/date/`. Every lap writes a shelf row and touches nothing that row watches, so a `--scoped` pass SKIPPED the one guard that reads it -- which is why `%440` keeps being found at a later ship's COLD open rather than by the lap that wrote the bad row. That is the map header's own named hazard -- *a static row naming less than its guard gates* -- thirteen of which a hand repaired on `20260906`; this is the fourteenth. *What caught it:* building the ranking `external-research/20260907-020817` asked for. Pricing the map meant sourcing its matcher, and asking that matcher whether this row reaches today's shelf answered no. *What it taught:* **the file nobody reads is the file that drifts.** Until this lap only the runner read that map, so an under-named row had no reader at all and failed in the safe-LOOKING direction: the guard still ran on full passes, the tree stayed green, and only the skip was wrong. *Repaired:* the row grew `session-logs/date/`; `tools/fixtures/i/index_shelf_repair.sh` makes `%440`'s twelfth hand-swap a command, proving its output is a PERMUTATION before it writes, and the scan's refusal names it; `tools/fixtures/s/scope_match.sh` holds the matcher the runner and the ranking share; `scope_rank` gates `rows_missing_control` at zero, rostered `tier lap`, 11s. **CLOSED.**
