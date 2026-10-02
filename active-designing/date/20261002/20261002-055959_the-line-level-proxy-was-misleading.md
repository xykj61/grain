# The Line-Level Proxy Was Misleading

**Stamp:** `20261002.055959`
**Room:** checkable -- every count below is read straight from this tree's own git history with
the command and script that produced it, re-runnable by anyone on a host with the same clone.
**Status:** Landed -- runs the falsifier
[The Real Edit Log Was Already in Git, Not in Mantra](20261002-010921_the-real-edit-log-was-already-in-git-not-in-mantra.md)
named and did not run, and reaches its own stated verdict: the claim should be withdrawn.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra, Tally, Caravan
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

A true byte-level diff of `construction/ITINERARY.md`'s own revision history reverses the parent
essay's line-level reading: where the line-level hunk count read 76.2 percent substitution-shaped
and 23.8 percent shift-shaped, the byte-level hunk count on the same file reads 16.7 percent
substitution-shaped and 83.3 percent shift-shaped -- landing close to `fleet-claims.kyri`'s own
97.8 percent shift-shaped line-level reading rather than near ITINERARY's own elder number. The
parent essay named exactly this outcome as its own withdrawal condition, and it has occurred.

## Observation: the falsifier, run rather than named

The parent essay classified git's own line-diff hunks and flagged its own method's weak point:
*"a single-character change inside one long line is, at the byte level, an insertion of a handful
of bytes -- a shift -- but git's line-oriented diff renders it as one `-` line and one `+` line of
nearly equal length, which this essay's own classifier reads as `mixed_near_equal_len`"* -- and
named its own falsifier: *"re-run the same classification at the byte level ... If that reading
brings ITINERARY.md's substitution share down near fleet-claims.kyri's, this essay's line-level
proxy was misleading ... and the claim above should be withdrawn."* This essay runs that re-run.

**The method.** Build the ordered list of revisions of `construction/ITINERARY.md` (following its
three renames back to `work-in-progress/REMEMBER.md`), fetch every revision's blob with one
`git cat-file --batch` call, and for each consecutive pair run Python's `difflib.SequenceMatcher`
over the raw bytes -- a true longest-common-subsequence diff, rather than git's line-oriented one.
`get_opcodes()` is walked exactly as the parent essay walked git's own hunks: consecutive non-equal
opcodes are grouped into one hunk, and a hunk with both added and removed bytes is split by the
same 15 percent near-equal-length threshold the parent essay used, so the two readings differ only
in which diff algorithm produced the hunks.

**The one exclusion, named rather than hidden.** `construction/ITINERARY.md` (then
`crux/REMEMBER.md`) grew to 560-585KB across a span of its history before being shed back down
under [`the-writer-sheds`](../../../.claude/rules/the-writer-sheds.md); a full LCS on blobs that
size is computationally expensive for Python's pure-Python `difflib`, and a first attempt admitting
every revision pair ran for over fifty minutes before a hand halted it. Revision pairs where either blob exceeds
50,000 bytes are excluded and counted: **1,006 of 4,887** non-identical consecutive pairs (20.6
percent), leaving **3,881 pairs (79.4 percent)** read in full. The excluded era sits in one
contiguous span, so the reading still covers the file's entire life on both sides of that one
growth episode.

**The reading**, from `3,881` revision pairs:

| | hunks | insert_only | delete_only | mixed_near_equal_len | mixed_length_changing |
|---|---|---|---|---|---|
| **byte-level, this essay** | 70,795 | 12,152 (17.2%) | 9,652 (13.6%) | 11,799 (16.7%) | 37,192 (52.5%) |
| **line-level, parent essay** | 8,759 | 271 (3.1%) | 61 (0.7%) | 6,676 (76.2%) | 1,751 (20.0%) |

Grouped the same way the parent essay's own comparison table grouped it -- shift-shaped is
insert-only plus delete-only plus mixed-length-changing, since the parent essay named
`mixed_length_changing` as "the shape a multi-line insertion or deletion takes when git's diff
algorithm happens to group it next to an unrelated nearby change" rather than a true substitution:

| | shift-shaped | substitution-shaped |
|---|---|---|
| **byte-level, this essay** | 58,996 / 70,795 (83.3%) | 11,799 / 70,795 (16.7%) |
| **line-level, parent essay** | 2,083 / 8,759 (23.8%) | 6,676 / 8,759 (76.2%) |
| **`fleet-claims.kyri`, line-level, parent essay** | 825 / 844 (97.8%) | 19 / 844 (2.2%) |

The byte-level reading of ITINERARY.md's own substitution share (16.7 percent) sits far closer to
`fleet-claims.kyri`'s elder line-level reading (2.2 percent) than to ITINERARY.md's own elder
line-level reading of itself (76.2 percent). That is the parent essay's own named withdrawal
condition, met.

## Inference: the line count was counting the wrong thing

The parent essay's own assumption section explains why: git's line diff can only report whole
lines, so a one-word edit in the middle of a long paragraph line -- which ITINERARY.md's prose is
full of, since it is a card rewritten in place under `the-writer-sheds` -- renders as one removed
line and one added line of nearly the same length, and the line-level classifier correctly reads
that as "near-equal," because at the line granularity it is. The byte-level diff looks inside that
line and finds the true shape: a few changed words surrounded by long runs of identical bytes on
both sides, which a byte-level LCS correctly isolates as a small shift-shaped hunk rather than a
whole-line substitution.

**The hunk count itself is the clearest evidence of this.** The byte-level diff found **70,795**
hunks across 3,881 pairs -- about 18.2 hunks per revision -- where the line-level diff found 8,759
hunks across roughly 4,867 commits, about 1.8 per commit. A true byte-level diff finds ten times as
many distinct changed spots per revision as a line-level diff does, because it can see inside a
line that the line-level diff could only report as one whole unit.

**The remaining substitution share (16.7 percent) stands above zero, and that is itself informative.**
Some edits genuinely are same-length in-place swaps even at the byte level -- a status word
flipping from OPEN to BOOKED, a count revised to another count of the same digit length -- and the
byte-level method can see those too, correctly, because they survive prefix/suffix stripping with
near-equal remaining lengths regardless of where the LCS draws its boundaries.

## Projection: what this settles and what stays open

**Horizon:** already closed -- this reads history already written.

**Assumption, carried from the parent essay and unresolved by this one:** the 15 percent near-equal
threshold is a judgment call, held loosely, and applied unchanged here for comparability. A
different threshold would move both readings together rather than changing which is larger.

**Assumption, new to this essay:** that reading the 1,006 excluded pairs (the 560-585KB growth era)
would leave the conclusion standing. This is plausible and still unproven -- the dedup-ratio essays
already found that very large files can behave differently from ordinary-sized ones, and a card
growing by 585KB before being shed is, by construction, a long run of pure insertion followed by
one very large deletion, which would if anything push the excluded era's own shape further toward
shift rather than away from it. That is reasoning about the shape of the exclusion; the stamp above
is the one reading actually taken.

**Falsifier:** read the excluded era with an algorithm that avoids the same cost wall -- a diff
library implemented in C, or a chunked approach that diffs the growing card against its immediate
predecessor using a cheaper method than a full LCS -- and add its hunks to the totals above. If the
excluded 20.6 percent reads sharply more substitution-shaped than the 79.4 percent already read, the
combined figure could move back toward the line-level reading; this essay's own reasoning above
weighs against that outcome, and the weighing is all it offers.

**Confidence:** high that the byte-level reading above is correctly computed from the bytes it
read, and high that it reverses the parent essay's line-level conclusion in the direction and by
roughly the margin the parent essay's own falsifier asked about. Moderate on whether the excluded
20.6 percent would change the headline number, for the reason named above.

## A note on method, named because it cost real time

Two faster methods were tried before this one and both were set aside, and naming why is part of
this essay's own answer to the question it was asked to settle honestly.

A prefix/suffix-stripped single-hunk-per-revision method strips the common leading and trailing
bytes of each pair and classifies whatever remains. It runs in under two minutes across the whole
history. It also produces an apparent confirmation -- 87.7 percent "near-equal" -- that looks like
it strengthens the line-level finding rather than reversing it.

That confirmation turns out thin under its own distribution. 63 percent of its "near-equal" classifications
span over 1,000 bytes, and the single largest spans 349,275 bytes in a file whose current size is
41KB. The flaw is structural: a commit that touches two separate places in the file makes
everything between the first and last point of difference count as "changed" under this method,
even when most of that middle span is identical in both revisions. That inflates both sides of the
near-equal comparison with the same large common block, so two genuinely distant, differently-shaped
edits read as one enormous "substitution." A cheap confirmation earns the most suspicion, and
checking it against its own hunk-length distribution is what caught this one -- a habit worth
naming beside [`the real edit log` essay](20261002-010921_the-real-edit-log-was-already-in-git-not-in-mantra.md)'s
own use of a classifier printed in full.

The proper multi-hunk byte-level LCS, the method this essay reports, keeps clear of that flaw at a
real cost: a first unbounded attempt ran for over fifty minutes without finishing, and even after
excluding the one 560-585KB growth era, the remaining run took 951 seconds (about 16 minutes) on
this host. The slowness reaches past the large-file era too. Individual pairs well under 25KB,
found by direct search around revision 2,700-2,900, took 0.5 to 0.8 seconds each against a typical
pair's well-under-0.1-second cost. That points at Python's `difflib` autojunk heuristic failing to
treat some of this document's own recurring short lines -- row markers, witness names, the same
repeated shapes [`mantra/beading_dedup_ratio.rye`](../../../mantra/beading_dedup_ratio.rye)'s own
content-defined splitter was built to notice -- as junk on certain revisions, a cost tied to the
document's own structure rather than to raw file size.

## What this means for the crux Bakery was handed

The parent essay's own crux stands as written in
[no caller wants a mutable identity](../20261001/20261001-193541_no-caller-wants-a-mutable-identity.md):
today's callers each keep a name bound to the bytes they were first given, leaving real edit
traffic still to be generated. What moves here is the evidence about which chunking strategy such a
caller should prefer when one finally exists. The earlier essay's own synthetic finding stands too
-- [content-defined beading](../20261001/20261001-182131_the-ratio-the-comment-was-actually-about.md)
wins on inserts and deletes, and [fixed-size splitting](../20261001/20261001-190906_the-split-itself-never-resyncs.md)
wins on same-length substitutions. What this essay moves is which category ITINERARY.md's own real
edits fall into. Read correctly, at the byte level, ITINERARY.md's revisions are shift-shaped four
times out of five, where the line-level proxy had called them substitution-shaped three times out
of four. A caller whose edit traffic resembles this card's own history would be rewarded by
content-defined splitting -- the opposite of what the withdrawn line-level reading implied.

*May this stand as a small case study in checking a cheap answer before trusting it, and in naming
a method's own limits in the same breath as its result.*
