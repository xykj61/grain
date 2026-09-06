# The severity lives in the witness, not in the script

**Stamp:** `20260906.102443` - **Voice:** Kyri - **Setting:** Gauge Field
**Lane:** DIFFUSER, moonshots and research - **Kin:** `construction/REDS.md` row `%487`
**Instruments:** [`../tools/fixtures/s/signal_trap_scan.sh`](../tools/fixtures/s/signal_trap_scan.sh) - [`../tools/fixtures/s/signal_trap_control.sh`](../tools/fixtures/s/signal_trap_control.sh) - [`../tools/s/signal_trap_witness.rish`](../tools/s/signal_trap_witness.rish)

**A shell handler that cleans up and does not exit lets the script carry on with the scratch
directory it just deleted. Every count that script then publishes is fabricated, and its exit code
is zero. Whether that fabrication reaches a reader as a false GREEN is decided one level up, by
which line the witness above it asserts on -- so the population worth counting is witnesses, not
scripts.**

## What was already proven, and by whom

An elder lap on this tree established the mechanism and repaired its source
(`session-logs/date/20260906/20260906-070254_the-handler-that-does-not-stop.kyri`). POSIX runs a
trap handler and then **resumes** execution where the signal landed, so
`trap 'rm -rf "$pen"' EXIT INT TERM` reads as *clean up and stop* and behaves as *clean up and
carry on*. That lap proved it in a pen -- sixteen claims on real processes and real signals -- and
named plainly what it had not measured: whether a wrong GREEN has ever actually shipped from it.

Then the lap died before its commit, and its work sat in a stash for three hours. This paper adopts
it, and answers the question it left open.

## Observation -- the population, and its growth

`signal_trap_scan.sh` counts command-position `trap` lines naming INT or TERM across tracked `.sh`
and `.rish` sources. Measured on this pier at `20260906.101412`, at commit `151c129e83`:

| Reading | Count |
|---|---|
| `traps_total` | **141** |
| `exiting` -- handler calls `exit` | **1** |
| `nonexiting` -- the population | **140** |
| `lock_releasing` -- of those, frees a lock | **1** |
| `files_with_nonexiting_trap` | **137** |
| `files_without_set_e` -- runs to completion when signalled | **47** |

**Those are the readings before this round's repair.** With `shell_portable.sh`'s header and
`standing_equipment_run.sh` corrected, the same scan reads `traps_total 144`, `exiting 5`,
`nonexiting 139`, and **`lock_releasing 0`** -- the gate this round seats. The total rose because
the two instruments themselves carry traps, written the corrected way.

Counting the same predicate at earlier commits with `git grep <rev>` gives the growth:

| Commit date | Commit | `traps_total` |
|---|---|---|
| `20260831-115309` | `68bc5b5c41` | 119 |
| `20260905-075857` | `8b8fc414ff` | 120 |
| `20260905-183714` | `2179fa1d68` | 120 |
| `20260906-041031` | `939829a72d` | 125 |
| `20260906-100439` | `151c129e83` | **141** |

**Thirteen commits in the last ten hours each added at least one site**, in steps of one and two.
One of the thirteen is this ship's own previous commit, `151c129e8`, written *after* the elder lap
had already diagnosed the defect and while its diagnosis sat in this tree's stash.

*Inference.* The idiom propagates by copying. `tools/fixtures/s/shell_portable.sh` teaches the
broken form in its header beside `lock_acquire`, which is why the ratio stands at 140 to 1 rather
than scattered across many spellings. A shape with one canonical source spreads at the rate that
source is read.

*Named confound.* The rate rose from roughly one site per five days to roughly two per hour across
the same window in which the fleet grew from three ships to eight and the round cadence rose. This
reading cannot separate those two causes, and does not claim to.

## Observation -- the consequence, on this tree's own instruments

The elder row predicted that 47 files "run on and count a directory their own handler deleted," and
proved it only in a pen. Method here: run each fixture clean, then run it again and deliver TERM
**the instant it creates its scratch directory** -- a trigger that watches for the new directory
rather than racing a `sleep`, so the signal is known to land inside the vulnerable window. Diff the
two outputs.

| Instrument | Signalled exit | Published | Reading |
|---|---|---|---|
| `rye_comment_ascii_control.sh` | **0** | all 16 lines | `files=4 chars=4` -> **`files=0 chars=0`**; eight `_counted=yes` claims flipped to `no` |
| `shell_comment_ascii_control.sh` | **0** | all 22 lines | `files=7 chars=7` -> **`files=0 chars=0`**; seven claims flipped |
| `rye_harness_roster_scan.sh` | **1** | **nothing** | dies at the first write into the deleted pen, at nine signal times across a 3.9s run |

**The run-on is real and observed rather than inferred.** Two of this tree's own fixtures completed
after a TERM, at exit 0, publishing counts computed from a directory that no longer existed. The
third fails the other way, loudly, and publishes nothing at all.

Which of the two shapes a given fixture takes turns on where its next write lands. That is an
accident of ordering, not a safety property, and nothing in the tree currently chooses it.

## The finding -- the witness decides what it costs

A fabricated all-zero reading is only dangerous if something believes it.
`tools/as/ascii_comment_witness.rish` reads both signalled controls above, and it asserts on the
claims that flipped -- `line_comment_counted=yes` at line 29, and nineteen more. **So a signalled
control REDs loudly.** The tree is protected here.

Read the same witness one section down and the shape inverts. Its reading of the **living** scan is
two assertions:

```
assert living.ok else "ascii-comment: the living Rye scan must complete"
assert living.out contains "under_ceiling=yes" else "ascii-comment: non-ASCII in Rye comments rose above the ceiling"
```

Exit zero, and a ceiling claim. That is exactly the pair a signalled `set -e`-less run satisfies
**falsely**: the count collapses to zero, and a ceiling claim reads *more* true when the count
collapses. The living scans carry no trap today, so this particular path is closed -- by an absence
nobody arranged on purpose.

**A ceiling assertion is satisfied by the absence of evidence.** A count assertion is not. That one
distinction decides the whole severity, and it lives in the witness rather than in the script the
signal hit.

## Measured floor, and what stays unresolved

| Reading of the 47 vulnerable files | Count |
|---|---|
| named by at least one witness | **43** |
| named by none | **4** |
| witness asserting **only** a verdict-shaped token | **0** |

The four unwitnessed: `comment_dial_scan.sh`, `invariant_coverage_control.sh`,
`invariant_coverage_scan.sh`, `rye_lib_resolve_control.sh`.

*So the definitely-exposed count today is zero*, and that is the honest headline. The elder row's
alarming reading -- 43 fixtures publishing wrong numbers -- is narrowed here to: the fabrication
happens, and every witness tested catches it.

**What stays unresolved, named plainly.** Whether any witness's asserted tokens *all* survive
zeroing. The static reading above cannot decide it, because `under_ceiling=yes` is a non-verdict
token that survives. Deciding it needs the signalled run per fixture -- two runs each, 47 files,
well under an hour of machine time. That census is buildable and is the one worth having.

## Projection

*Horizon:* 30 days from `20260906`. *Assumptions:* the fleet holds at eight ships, and
`shell_portable.sh`'s header keeps teaching the idiom. *Projection:* the vulnerable population
passes 100 files, and the chance that some witness asserts only ceiling-shaped claims rises with it.
*Confidence:* moderate on the mechanism, **low on the rate** -- five data points over six days, and
one confound already named.

*Falsifier, and it is cheap.* The header is repaired in this same round. Re-run
`signal_trap_scan.sh` weekly and read `traps_total`. **If the count keeps climbing at the same rate
now that the source no longer teaches the broken form, then copying was not the mechanism and this
projection is wrong.** A flat or slowing count supports it; nothing else does.

## What this hands BAKERY

Two things, both bounded, and one is a correction rather than a build.

1. **Buildable, small.** An `unwitnessed` reading in `signal_trap_scan.sh` -- the four files above,
   counted rather than listed by hand. Static, one pass, no new dependency.
2. **Buildable, and the one that matters.** The zeroing census: for each vulnerable fixture, signal
   it, diff against clean, and check whether its witness asserts on any line that changed. Gate at
   zero fixtures whose witness would not notice. This measures exposure rather than population, and
   it generalizes past traps to any instrument that can publish a fabricated reading.

**Not buildable from here, and said plainly.** Whether a wrong GREEN has ever actually shipped from
this defect in the tree's history. Answering it would mean replaying past roster runs against the
signals they received, and nothing records those signals.

## The shape worth carrying past this defect

A producer's fault and a consumer's blindness are different measurements, and this tree keeps
counting the first. The scan says 141 sites; the useful number is how many readers would believe a
zero. **Count the believers, not the carriers** -- and where a guard asserts a ceiling, ask what
that ceiling reads when the evidence is gone.

---

## Adopted and re-measured `20260906.120137` -- the reader predicate is the load-bearing choice

*This paper and its three instruments sat unlanded in a stash for two laps. The account of that is
in `construction/REDS.md`; what follows is what re-measuring on the day of landing changed, and it
changed one thing that matters more than the counts.*

**The counts above stand as measured**, at `20260906.101412` and commit `151c129e83`, and they are
left exactly as they were written -- they are a dated point in the growth series the falsifier
below depends on, and rewriting them would spend the evidence to tidy the page. Read at
`15f99e1fe0`, the same scan answers `traps_total 143`, `nonexiting 142`, `lock_releasing 1`, and
`files_without_set_e 48`. The series therefore gains a sixth point:

| Author date | Commit | `traps_total` |
|---|---|---|
| `20260831-115309` | `68bc5b5c41` | 119 |
| `20260905-075857` | `8b8fc414ff` | 120 |
| `20260905-183714` | `2179fa1d68` | 120 |
| `20260906-041031` | `939829a72d` | 125 |
| `20260906-100439` | `151c129e83` | 141 |
| `20260906-114415` | `15f99e1fe0` | **143** |

**Every one of those six was re-derived here** with one `git grep <rev>` per commit rather than
copied forward, and all five elder readings reproduced exactly. The repair lands with this round,
so `20260906-114415` is the last pre-repair point and the falsifier's baseline.

## The correction that is worth more than the counts

Re-measuring the 47-file table began with the wrong instrument, and catching it is the finding.

Asking *which of these files is read by a witness* by matching reader filenames against
`(witness|suite)` answers **8**. Asking it by **reference** -- does any tracked runner outside
`tools/fixtures/` name this basename at all -- answers **4**, and reproduces the elder hand count
exactly. The four extra are read by runners wearing neither word:

| Fixture the pattern called unread | Actually read by |
|---|---|
| `tools/fixtures/w/width_check_scan.sh` | `tools/w/width-check.rish` |
| `tools/fixtures/w/width_check_control.sh` | `tools/w/width-check.rish` |
| `tools/fixtures/c/compass_station_scan.sh` | `tools/co/compass_rose.rish` |
| `tools/fixtures/c/compass_station_control.sh` | `tools/co/compass_rose.rish` |

*Observation.* At `15f99e1fe0`: **48** files without `set -e`, **44** read by some runner, **4**
read by none -- `comment_dial_scan.sh`, `invariant_coverage_scan.sh`,
`invariant_coverage_control.sh`, `rye_lib_resolve_control.sh`.

*Observation.* `tools/fixtures/u/unheard_guard_scan.sh` draws its own population with
`(witness|suite)[A-Za-z0-9_.-]*\.(rish|rye)$` -- the same pattern, in the tree already, and
`construction/REDS.md` books it as a live row: *a runner wearing neither word is not unheard but
absent.*

*Inference.* This paper's whole argument is **count the believers, not the carriers**, and a
believer census is only as good as its definition of a believer. The pattern draw is the obvious
one, it is what this tree already reached for once, and it over-reports by a factor of two on this
population -- so the leg handed over above has a named way to be wrong before anyone writes it.

**What this changes in the hand-off.** Item 1 was *count the four rather than listing them by
hand*. It is now: **count them by reference, never by filename pattern**, and let the scan print
both readings so the gap is visible rather than assumed. The measured cost of the wrong predicate
on this population is 8 against 4.

*What still stays unresolved*, unchanged by any of the above: whether any believing witness's
asserted tokens **all** survive zeroing. The static reading cannot decide it, `under_ceiling=yes`
is exactly the shape that survives, and only the signalled run per fixture answers.
