# The Row That Expanded Before It Matched

**Stamp:** `20260910.030711` -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Status:** Living -- **mixed room**: the census and the matcher repair are checkable, each bound by
a control named below; the taxonomy of row kinds is vision, proposed and unbuilt.
**Kin:** [`20260907-061951_the-map-a-guard-writes-for-itself.md`](20260907-061951_the-map-a-guard-writes-for-itself.md)
(the sample this completes) -- [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)
**Instrument:** `tools/fixtures/s/scope_trace.sh` -- **Matcher:** `tools/fixtures/s/scope_match.sh`
**Control:** `tools/fixtures/s/scope_trace_control.sh`, leg 8

A `--scoped` roster pass skips a guard when no changed path reaches its **watch row** in
`tools/fixtures/s/standing_equipment_scope_map.sh`. A row is therefore a behavioral claim about
what a guard reads, and `scope_trace.sh` was built on `20260907` to check that claim by running the
guard under `strace` and comparing the observed read set against the row. Its roster entry left one
step to a hand: *tracing a REAL guard stays a hand's command*. Eight guards were traced the day it
was seated, and two rows were repaired.

This paper reports what happened when the remaining rows were traced, and one defect the census
found in the matcher underneath it.

## What was measured, and what was left out

**Observation.** On `20260910`, 44 of the 58 mapped rows were traced on this pier
(`grain-diffuser`, Linux, `strace` present), each with `sh tools/fixtures/s/scope_trace.sh <guard>`.
The census ran twice, because the first pass found a defect in the matcher it was measuring with,
and the second pass is the honest reading.

| Reading | Elder matcher | After the repairs |
|---|---|---|
| Rows traced | 37 | **44** |
| `verdict=ok` -- the row reaches every file its guard read | 11 | **13** |
| `verdict=under_named` -- the row names less than the guard reads | 26 | **31** |
| Share under-named | 70% | **70%** |
| Files read and covered | 6,350 | **9,845** |
| Files read and **unreached by the row** | 1,808 | **188** |

**Roughly seven rows in ten name less than their guard reads, before and after.** Each unreached
file is a path whose change leaves that guard unrun under `--scoped`.

**The repairs closed volume rather than incidence**, and that distinction is the census's most
useful finding. Unreached files fell 1,808 to 188 -- 1,589 of that from one row, `reds_fold`, set to
`DISCOVERY`, and most of the rest from the matcher repair below. The **share** of rows naming less
than their guard reads did not move at all. So the tree does not hold a few catastrophic rows beside
many good ones; it holds a majority of rows that each under-name by a handful of files, plus a small
number that under-name by a thousand.

**Named rather than left silent: 14 mapped rows were not traced.** Thirteen are `tier cadence`
suites that build through the Zig toolchain and cost minutes apiece
(`ales_suite`, `caravan_suite`, `crypto_suite`, `lattice_suite`, the six `glow_*` gates,
`comlink_rehearsal_wire`, `fora_socket`, `glow_choir`). The fourteenth is `reds_fold`, which now
reads `DISCOVERY` and so has no row left to compare a read set against. A census that stops says
where.

**Two controls on the instrument itself.** `radiant_negation`, repaired on `20260907` after reading
142 files against a row reaching 89, traced **147 files with zero gaps** here. `tally_roster`,
repaired the same day from **816** gaps, reads **2**. Repairs made through this instrument hold, and
that is what makes the census worth taking rather than merely worth reading.

## Two shapes, and the second is the one that grows

**Observation.** `loop_prompt_parse` read eleven files its row missed, nine of them
`tools/l/launch-*-chapter.rish`. Its scan discovers every launcher by glob; its row named one
launcher.

**Inference, dated from git.** The row was written in `39d97db31` (`2026-08-29`). At that commit the
scan already carried the glob, and **eight** launchers already existed. The row named one of eight
on the day it was born. It was never stale -- it was **born under-named**, which is what a row
written by reading a guard's name rather than by running it looks like.

**Observation.** `prose_register` read 92 room front doors, `<room>/README.md`; its row named nine
of them by hand. Three days earlier the same guard traced at four gaps. The guard was widened in
the interval and the row stayed where it was.

So there are two shapes: a row **born** naming less than its guard reads, and a row that **stops
following** a guard that grew. Tracing a row once catches the first. The second returns, which makes
a census a reading rather than a repair.

## The defect underneath: a row was expanded before it was matched

The census turned up something the sample could not: **the matcher never read a row's globs as
patterns at all.**

`scope_match_row` split its row with an unquoted expansion. In POSIX sh an unquoted expansion
performs **pathname expansion** as well as word splitting, so every glob word in a row was replaced
by the files matching it in the working directory **before** `case` ever saw a pattern. The file's
own header states the intended reading plainly -- *a shell glob read by `case`, which is where the
semantics come from* -- and measured on `20260910` the semantics came from the pathname expander
instead. `case` only ever met paths that already existed.

Two consequences follow, and both were silent.

**A deleted watched file is skipped.** A path removed from the tree no longer expands, so a row word
`tools/*/ales_*_witness.rish` did not reach a deleted `ales_x_witness.rish`. Deleting a witness left
its guard unrun -- the change most likely to break a guard is the change its row could not see.

**A glob reached only the depth it literally spelled.** `*/README.md` matched `caravan/README.md`
and missed `context/keys/README.md`, where `case` matches both, since `*` in a `case` pattern
crosses `/`.

**And the failure arrives exactly when the row starts working.** An unmatched glob stays literal in
POSIX sh, so the elder matcher answered a deleted path correctly whenever its row word matched
nothing at all. It failed only once the word had a real file to expand into. That is why this stood
for three days under a control: the control's pen held no sibling for the glob to catch, so the
elder behavior passed every leg it was shown.

**The repair is to disable globbing for the split alone** -- `set -f` around the `for`, with the
caller's own setting saved and restored. Matching moves in the safe direction only: a pattern
reaches at least every path its expansion used to name, so a guard runs at least as often as before
and never less.

**Proven from both sides.** `scope_trace_control.sh` leg 8 asserts the deleted path, the nested
glob, the room word, an unrelated path refused, and the caller's glob state restored -- then plants
a copy with the `set -f` removed and shows the elder matcher missing the first two while still
reaching the shallow one. Control **40 behaviors, 0 faults**; `scope_trace` and `scope_rank` both
GREEN.

## What the census suggests about rows, proposed and unbuilt

**Vision, from here on.** The traced rows fall into three kinds, and only one of them is a row.

- **Bounded readers** -- a guard reading a handful of named files. A watch row fits, and eleven of
  these read `ok`.
- **Whole-tree readers** -- `reds_fold` read 1,589 files its row missed, spread across `counsel/`,
  `active-designing/`, `session-logs/` and eighteen other rooms, because it sweeps `%N` citations
  across the tree. No honest row is shorter than the tree. Its row was set to `DISCOVERY`, the map's
  own word for *always runs*, which costs one 2.7-second guard per scoped pass.
- **Build-edge readers** -- a guard that compiles through the vendored toolchain reads it. This is
  the class that gave `tally_roster` 816 gaps on `20260907`, and `comlink_handshake_turn` six here.

**The projection.** If a row's kind were declared beside it, the map could refuse a bounded row for
a guard observed reading a thousand files, and the second shape above -- the row that stops
following -- would red on the lap the guard grew rather than at the next census.
**Horizon:** one lap to build, once the census is complete.
**Assumption:** a guard's kind is stable between traces.
**Falsifier:** trace the mapped roster twice a week apart; if guards migrate between kinds, the
declaration is another claim needing its own census, and the idea is worth less than it costs.
**Confidence:** moderate. The evidence for the kinds is thirty-seven traces on one tree.

## What was repaired on this lap

Five rows widened by **union**, which can only make a guard run more often, and each re-traced:

| Row | Gaps before | after | What it was missing |
|---|---|---|---|
| `loop_prompt_parse` | 11 | **0** | nine launchers and the fleet roster |
| `crypto_count_guard` | 4 | **0** | the standing roster and three tool-declaration fixtures |
| `reds_fold` | 1,589 | -- | set `DISCOVERY`; a whole-tree reader has no shorter honest row |
| `prose_register` | 96 | **4** | every room front door, via `*/README.md` |
| `skate_macos_choice` | 9 | **4** | the decision paper and the gratitude pages it cites |

**`prose_register` needed both halves, and it is the clearest case for the matcher repair.**
Widening its row with `*/README.md` took it 96 gaps to 38; the elder matcher expanded that word
against the working directory and reached only the front doors one level deep. Reading the same
word as a pattern took the remaining 34.

The residue on the two partial repairs stops where a row cannot go: `.git/config`, `.git/HEAD`, and
`.git/index`. That is the same dependency the `20260907` paper named as one the map has no way to
spell, and it now stands in a third row -- which makes it a class rather than a curiosity.

**The largest rows still standing**, for whoever takes the next lap: `scope_rank` at 62 unreached
files, `pond_display_gate` at 37, and `equinox_e123_living_pin_guard` at 21. Each wants a reading of what its
guard gates rather than a word appended to a row, so each is its own lap.

## What this does not reach

**Whether a gap is gated.** A row follows a guard's gated readings, and observation cannot tell a
gated read from an advisory one. Every widening here is a union, so a wrong guess costs run time
rather than a missed refusal.

**One tree is one tree.** A guard whose read set branches on file content may reach a room it never
reached here.

**The instrument's own ceiling moved, and it is a count of a growing surface.** `max_paths` was
raised 65,536 -> 262,144 after the census met the refusal on three live guards -- `index_row_bound`
at 79,888 trace lines, `pond_policy_launcher` at 83,728, and `scope_rank`. The elder number was set
three days earlier against a largest-reader reading of 15,011 files. The bound's reason is unchanged;
a lap that meets the refusal again should re-measure rather than trust this line.
