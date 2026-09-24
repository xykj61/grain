# Identical output is not a proof -- what the live tree cannot show you

**Stamp:** `20260910.230908`
**Language:** EN
**Style:** Gauge, Field setting (`../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living -- **checkable room**: every figure below was measured on this pier by a named
command, and the claim about the defect is held by `tools/gen/chapter/reds_ledger_monotone_witness.rish`
**Kin:** [`20260910-225020_the-falsifier-that-landed-on-its-own-threshold.md`](20260910-225020_the-falsifier-that-landed-on-its-own-threshold.md) -- [`20260910-222440_the-serial-residue-has-a-name.md`](20260910-222440_the-serial-residue-has-a-name.md) -- [`../foundations/20260826-021733_fire-the-row-that-sees.md`](../foundations/20260826-021733_fire-the-row-that-sees.md)

## The claim

**A rewrite whose output is byte-identical to its elder on the tree you stand in has proven one
thing: that the two forms agree on the inputs the tree happens to hold.** Where the rewrite changes
how a program *partitions* its inputs, rather than what it computes from them, the live tree is
often the one dataset that cannot distinguish the two -- because production data is, by definition,
the case that has never been empty, never been absent, and never been degenerate.

This is a small claim and it cost a real defect to earn, so it is written down with the defect
attached.

## What was rewritten, and what it measured

`tools/fixtures/r/reds_spine_derive_scan.sh` compares this tree's REDS ledger against the anointed
spine on `xy/main`. Three of its readings were row-joins written as a shell loop with a fresh `awk`
per row: the rebinding gate joining 615 local rows against 615 shared rows, the dropped-stamp
reading joining the other way, and the double-booking reading joining each duplicate number against
the shared spine. Each spawned one process to ask one question of a file already on disk.

**Measured `20260910.230300` on this pier** (Vultr Dallas, AMD 8-core guest, NixOS), by
`strace -f -e trace=execve`:

| Reading | Before | After |
|---|---|---|
| `execve` total | 1,745 | **483** |
| `awk` | 1,258 | **10** |
| `sed` | 442 | 442 (untouched) |
| `git` | 4 | 4 |

**Wall clock, five runs of each form in the same hour on the same tree, at a 1-minute load average
of 14.2 to 16.6 on 8 cores:** the elder read 13,441 / 15,242 / 14,157 ms; the new form read 4,638 /
4,384 / 4,188 / 3,645 / 3,518 ms. That is **3.5x by median**, and both forms ran in the same hour at the same load, so the
comparison is fair where the previous lap's could only be reported.

**The `sed` count is untouched on purpose.** The local read still forks one `sed` per ledger file,
442 of them, and that is the next door rather than this one.

## The defect, and where it was hiding

The three joins were first written with `awk`'s conventional two-file idiom, `NR == FNR`. That
idiom partitions two files by asking whether the global record number still equals the per-file
one, which is true exactly while the first file is being read.

**It holds only while the first file carries rows.** A first file of zero rows leaves `FNR` at
zero, so the second file's own first line arrives with `NR == 1` and `FNR == 1`, reads the test as
true, and is swallowed by the map-building rule. Every map stays unbuilt and every answer comes
back zero. The program reports; it refuses nowhere.

**This state lives outside everything the live tree holds.** Both files carry 615 rows here and
have carried rows every day the guard has run. Byte-for-byte comparison of the elder and new forms on this tree passed
completely: 49 `detail:` lines and 14 readings identical, `--next` identical at 701, stderr
identical.

**A witness found it in forty seconds.** `reds_ledger_monotone_witness.rish` builds a pen with no
anointed ref, plants two rows binding one number to two stamps, and asserts the guard counts it.
It read `local_rows=2` and `double_booked=0` and refused by name. In that pen `shared.txt` is empty,
because there is no spine to read -- which is the ordinary state of a fresh clone, a control's pen,
and any checkout whose remote has not been fetched.

The repair names the file rather than counting it: `awk -v sharedf="$work/shared.txt" 'FILENAME ==
sharedf { ... }'`. A side holding zero rows then yields a map holding zero keys.

## The three mutations, and what each answered

Each was applied to the shipped form, measured, and reverted; the scan is byte-identical to its
committed state after all four.

- **Reverting `FILENAME` to `NR == FNR`** reds `reds-monotone`. The partition is load-bearing and
  its own witness catches the regression.
- **Dropping the published-double arm** turns `published_doubles=7` into `rebindings=7` and
  `verdict=rebinding` -- the clause that keeps eight ships out of a red none of them may repair.
- **Breaking the dropped-stamp set** reads `dropped_upstream_stamps=615` against a true 0.
- **Letting a later line overwrite the first** in the `up` map changes **no gated reading at all**
  and reverses the two stamps inside all seven `published_double` sentences: *binds this number to
  BOTH A and B* becomes *BOTH B and A*. The elder form's `{print $2; exit}` picked the first match,
  and reproducing that choice preserved seven sentences a reader has already read.

**That fourth one is the quiet member of the set**, and it is the same lesson one notch further
down. A diff of gated readings would have called the mutation clean.

## What this says about proving an optimisation

**Observation.** Output identity on the live tree passed while a reading was wrong in every
empty-spine checkout.

**Inference.** Output identity proves agreement on the inputs presented, and a rewrite that changes
input *handling* -- partitioning, iteration order, presence tests, early exits -- is exactly the
kind whose disagreement lives in inputs the live tree does not present.

**The practical rule, bounded to this shape of work.** When a rewrite changes how inputs are
consumed rather than what is computed, the live-tree diff is the *first* clause and the guard's own
pen is the *second*, and neither substitutes for the other. Run the witness as well as the scan.

**Horizon:** this reasoning holds while the tree's guards keep controls that build pens with
degenerate inputs -- today 19 cases for this guard alone. **Assumptions:** that a guard's pen
genuinely reaches states the live tree does not, which is what a pen is for. **Falsifier:** find
a shell or `awk` rewrite in this tree whose live-tree output was identical, whose guards were all
green, and which was nonetheless wrong in a pen state -- if none exists across the next ten such
rewrites, this defect was a one-off and the rule is overpriced. **Confidence:** high for the
mechanism, which is `awk`'s documented behaviour; moderate for the generality, on one instance.

## One measured aside for the register question already open on the card

**PETRICHOR's open ask is whether `never` inside a contrast should count as a negative
(`prose_register_scan.sh:185`). This page carries the same shape one word over.** Its first draft
read **45% negative of 46 sentences** against Field's 30%; **8 of the 21 counted sentences were
counted on the word `empty` alone**, where `empty` is the technical noun naming the very input
state the paper is about. Rephrasing to *zero rows* and *carries rows* brought the page to **26%**
with every claim, figure and path untouched.

**That is a datum rather than a verdict.** It cuts toward counting the word, since a clean positive
phrasing existed each time and finding it made the sentences plainer. It also shows the cost is
real: a paper whose subject is an absent thing pays the ceiling in vocabulary it did not choose.
Both halves belong to whoever answers the ask.

## What this does not reach

**Whether the join is now fast enough.** 483 processes still carry 442 `sed`, and a further cut is
a separate lap with its own falsifier.

**Whether `NR == FNR` holds in general.** It is correct and idiomatic wherever the first file is
known to carry rows. What it cannot do is fail loudly when that assumption breaks, and a reading that
goes quietly wrong is worth more care than one that refuses.
