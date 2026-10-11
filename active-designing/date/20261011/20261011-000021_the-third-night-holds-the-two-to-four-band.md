# The third night holds the two-to-four band, and the direction replicates a third time

**Lane:** Diffuser (moonshots and research)
**Status:** Landed -- **Room:** research for understanding
**Kin:** [the same-night pair holds the ratio](../20261010/20261010-232345_the-reset-is-already-in-the-source-and-the-same-night-pair-holds.md) - [the sequential sweep replicates below the band on a second night](../20261010/20261010-231930_the-sequential-sweep-replicates-below-the-band-on-a-second-night.md)

## What this note is for

The same-night paper named one next door: a third night, on a later calendar day than
`20261010`, with the 2 to 4 huge-to-control ratio falsifier stated before the run. The clock
reads `20261011` now, so the door is open. This note runs it and reports what it found. It does
not reopen the reset question, which the same-night paper already settled by reading the source.

## Falsifier, stated before the run

Stamped `20261011.000012` (New York), before any run in this note:

If a third-night pair, control and huge, returns a control-to-huge miss ratio outside roughly 2 to
4 on either pair, the ratio is not a stable quantity on this guest, and the absolute figures cannot
be compared across nights.

## Method

- **Binaries:** `session-output/hugepage-chase/sweep_control` and `sweep_huge`, the same binaries
  the two earlier nights ran. Untracked scratch, gitignored, as before.
- **Runs:** three pairs, control then huge, alternating, on `20261011` from about 00:01 New York
  time. Eight-core guest, transparent huge pages set to `madvise`.
- **Expectation:** 1,048,576 accesses per run (64 MiB at 64-byte lines), so a permille reading is
  `misses * 1000 / 1,048,576`.
- **Label note:** the control arm was run through `sweep_control`, which printed the label
  `sweep_huge:` on its line. The arm is named `huge=control` in the same line and the readings are
  taken from that field, so the label is a misprint, not a mixed-up binary. It is the same kind of
  label fault the seven-base paper recorded in its own script.

## Observation

Read from the program's own output, `sweep_huge` lines and the `AnonHugePages` figure in
`/proc/meminfo`:

| Pair | Control misses | Control permille | Huge misses | Huge permille | Control / huge |
|---|---|---|---|---|---|
| 1 | 246,945 | 235 | 74,954 | 71 | 3.30 |
| 2 | 342,890 | 327 | 96,871 | 92 | 3.54 |
| 3 | 282,554 | 269 | 87,186 | 83 | 3.24 |

The huge arm reports `anon_huge_kb=63488` on every run, against 65,536 kB on the earlier nights.
The figure is smaller and still non-zero, so the requested pages were granted and the arm is not a
silent fallback. The control arm reports `anon_huge_kb=0`, as it should.

## Inference

All three pairs sit inside the 2 to 4 band the falsifier stated. The huge arm reads lower than the
control in every pair, the same direction as all three earlier nights. Across the nights the
control-to-huge ratio now rests on eleven pairs: six from the first two nights, two from the
same-night rerun, and three tonight. The band held on every night that ran it.

## Projection, with its horizon, falsifier, and confidence

- **Horizon:** the ratio's direction on this guest over the next few calendar days. The absolute
  permille figures are not a horizon claim: they drift between nights, and the earlier papers
  already recorded that.
- **Projection:** the huge-to-control ratio stays in roughly 2 to 4 on this guest.
- **Falsifier:** a later pair, with the band stated before its run, lands outside 2 to 4 on either
  arm. The falsifier that could kill this projection is that one.
- **Confidence:** moderate-to-high on the direction, which has now held on three nights. Low on the
  exact band edges, since the observed ratios run from 3.24 to 3.54 and a band of 2 to 4 is wide
  enough to hold them with room to spare, not tight enough to fix a number.

## What this does not say

Why the counter reads so far below one miss per fill is still open. The prefetch explanation
remains a candidate, and its falsifier, a prefetch-disabled run that lands in the band, was not run.
The guest still blocks that control, so this note adds no evidence there.

## Next door

Hold the band as a tendency and stop adding nights of the same pair. The next move that moves
the open question is the prefetch-disabled control, which needs a host capability this guest does
not grant. Whether to request that capability is Keaton's word, and this note does not seek it.

*The scratch binaries and their raw output stay in `session-output/hugepage-chase/`, untracked.
This paper carries the readings and the falsifier so the record survives the scratch directory.*

## Re-reading

These figures are testimony from the run at `20261011.000021`. The raw counts are kept only in the
scratch directory, which is gitignored. To read the ratio again on a later night, run
`./sweep_control` and `./sweep_huge` in that directory and divide the two `misses=` fields. The
result is free: nothing holds it still between runs.
