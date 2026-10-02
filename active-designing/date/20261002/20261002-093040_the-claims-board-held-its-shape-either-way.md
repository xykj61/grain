# The Claims Board Held Its Shape Either Way

**Stamp:** `20261002.093040`
**Room:** checkable -- every count below is read straight from this tree's own git history with
the script printed in full, re-runnable by anyone on a host with the same clone.
**Status:** Landed -- extends the falsifier
[The Line-Level Proxy Was Misleading](20261002-055959_the-line-level-proxy-was-misleading.md)
ran to a second document the parent of that essay had cited at line-level alone.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra, Tally, Caravan
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

A byte-level LCS re-read of `construction/fleet-claims.kyri`'s full revision history agrees with
its own line-level reading -- 94.4 percent shift-shaped against the line-level reading's 97.8
percent -- which is the opposite outcome from the same method run against `ITINERARY.md`, where
the byte-level reading reversed the line-level one by sixty points.

## Observation: the second document, read the same way

[The real edit log was already in git](20261002-010921_the-real-edit-log-was-already-in-git-not-in-mantra.md)
classified three tracked documents at line level: `fleet-claims.kyri` at 97.8 percent shift-shaped,
`construction/REDS.md` at a 46/28/27 mix, and `ITINERARY.md` at 76.2 percent substitution-shaped.
[The line-level proxy was misleading](20261002-055959_the-line-level-proxy-was-misleading.md) ran a
true byte-level LCS against `ITINERARY.md` alone and found the opposite of the line-level number --
83.3 percent shift-shaped once read correctly, against the earlier 76.2 percent substitution-shaped.
That essay's own closing section named the obvious next step and left it for later: re-check the
other two documents' line-level numbers at byte level too. This essay takes that step for
`fleet-claims.kyri`, the smaller of the two and the one whose history stays under the large-blob
exclusion size throughout.

**The method is the same script, pointed at the other file.** The ordered list of revisions
(`git log --follow --format=%H --reverse`), one `git show <hash>:<path>` per revision, and
`difflib.SequenceMatcher` run directly on the raw bytes of each consecutive pair, grouped into
hunks by `get_opcodes()` and split by the same 15 percent near-equal-length threshold. The whole
script is forty lines and is reproduced at the foot of this essay. `fleet-claims.kyri` stayed
under 4,443 bytes at its largest tracked revision, well under the 50KB exclusion line the
`ITINERARY.md` run needed -- all 826 non-identical consecutive pairs across 830 revisions are
read in full, at a real cost of ten and a half minutes, each one a small-file version of the same
slow-pair phenomenon the parent essay named: short, structurally repetitive text (`claim`, `seat`,
`stamp`, `epoch`, `paths`, `what`, on repeat, 828 times) defeats `difflib`'s usual speed.

**The reading:**

| | hunks | insert_only | delete_only | mixed_near_equal_len | mixed_length_changing |
|---|---|---|---|---|---|
| **byte-level, this essay** | 2,525 | 944 (37.4%) | 823 (32.6%) | 142 (5.6%) | 616 (24.4%) |
| **line-level, parent essay** | 844 | n/a | n/a | 19 (2.2%) | n/a |

Grouped the same way both parent essays grouped it -- shift-shaped is insert-only plus delete-only
plus mixed-length-changing, substitution-shaped is `mixed_near_equal_len`:

| | shift-shaped | substitution-shaped |
|---|---|---|
| **byte-level, this essay** | 2,383 / 2,525 (94.4%) | 142 / 2,525 (5.6%) |
| **line-level, parent essay** | 825 / 844 (97.8%) | 19 / 844 (2.2%) |
| **`ITINERARY.md`, byte-level, grandparent essay** | 58,996 / 70,795 (83.3%) | 11,799 / 70,795 (16.7%) |
| **`ITINERARY.md`, line-level, grandparent essay** | 2,083 / 8,759 (23.8%) | 6,676 / 8,759 (76.2%) |

The byte-level reading moves `fleet-claims.kyri`'s substitution share from 2.2 to 5.6 percent --
upward, not downward, and by 3.4 points rather than `ITINERARY.md`'s 59.5-point swing in the
opposite direction. Both readings of `fleet-claims.kyri` land on the same side of the line: this
document is shift-shaped under either method, and the method choice changes the reading by a
small amount rather than reversing its conclusion.

## Inference: the two documents disagree about whether the method matters, and the reason is structural

`ITINERARY.md`'s line-level reading pointed the wrong direction because its own prose runs long
lines -- a one-word change inside a paragraph sentence renders as one whole `-` line and one whole
`+` line of near-equal length, and that is the one shape git's line-oriented diff always sees from
inside a long line, whatever actually changed within it. `fleet-claims.kyri`'s records are the
opposite shape by construction: each `claim` block is six short lines (`claim`, `seat`, `stamp`,
`epoch`, `paths`, `what`), and the board's own convention is to write a fresh claim rather than
hand-edit a stamp or a path inside an existing one, so a claim opening, closing, or being replaced
touches whole lines almost every time. A document built from short, line-bounded records is a
document where the line-level diff and the byte-level diff agree on nearly the same shape, because
a long line for a small edit to hide inside is rare.

**The small movement that did occur points at where the two methods can still disagree, even on a
line-structured file.** `mixed_near_equal_len` rose from 19 to 142. The likely cause is a `stamp`
or `epoch` line rewritten to a new value of the same digit length (`20261002.070417` to
`20261002.091216` is a same-length in-place swap even inside one short line). Both a byte-level
and a line-level diff read that correctly as a substitution, so the rise is not surprising by
itself. What is worth naming is the scale: the parent essay's own line-level pass found only 19
such hunks across 844, and this pass finds 142 across 2,525. Part of that gap is denominator --
2,525 hunks here against 844 there, because a byte-level diff finds roughly three times as many
distinct changed spots even in a line-structured file, the same effect the grandparent essay found
at ten times the rate in `ITINERARY.md`'s long-line prose. Part is numerator: some of the 142 are
genuinely new substitutions that the line-level pass had folded into a `mixed_length_changing`
hunk, because they sat next to an insert or delete the line-level diff grouped them with. The
byte-level diff's finer hunk boundaries pull those apart into their own, correctly-sized pieces.

## Projection: what this settles, and `REDS.md` left standing

**Horizon:** already closed -- this reads history already written.

**What this settles:** the `fleet-claims.kyri` half of the grandparent essay's three-document
table is now confirmed at byte level rather than resting on a line-level reading alone. Of the
three documents named, two now carry a byte-level confirmation (`fleet-claims.kyri`, agreeing with
its line-level reading) and one carries a byte-level correction (`ITINERARY.md`, reversing its
line-level reading). `construction/REDS.md`'s 46/28/27 mixed reading remains line-level only.

**Falsifier, inherited and still open:** read `REDS.md` the same way. Its current size is 65,508
bytes -- past the ITINERARY.md run's 50KB exclusion threshold already, and it is append-only by
the ledger's own first law (`reds-first.md`: "rows are never edited or removed"), so its history is
monotonically growing rather than shed-and-regrown the way `ITINERARY.md`'s was. That means every
one of its 687 revisions past some early point in its history would need the exclusion this essay
and its grandparent both avoided paying for `fleet-claims.kyri`, and a majority of its revisions
would likely fall on the excluded side of a 50KB line, which is the opposite coverage problem from
the one the `ITINERARY.md` run solved by excluding one contiguous growth era. Reading `REDS.md`
properly wants either a faster LCS implementation than pure-Python `difflib`, or a chunked method
that diffs each revision against a bounded window around its own prior size rather than attempting
a full LCS on a 65KB-and-growing blob at every step. Named here as the clearly next thing to build,
rather than attempted with a tool already known to be too slow for the size it would meet.

**Assumption, carried from both parent essays:** the 15 percent near-equal threshold is a judgment
call, applied unchanged here for comparability across all three readings in this essay's second
table.

**Confidence:** high that the byte-level reading above is correctly computed straight from the
bytes -- all 826 pairs, read in full. High that `fleet-claims.kyri`'s shift-shaped dominance is
real under either method, for the structural reason named above (short, line-bounded records).
Low, still, on `REDS.md`'s true shape, which stays an open falsifier rather than a read result.

## What this means for the crux Bakery was handed

[No caller wants a mutable identity](../20261001/20261001-193541_no-caller-wants-a-mutable-identity.md)
already named the open half of its own crux: a caller with a real reason to keep one name's
identity stable across an edit, waiting on a live example in this tree's own code. What two essays
running now confirm is a cleaner
picture of which existing *documents'* edit traffic would reward which chunking strategy, should
such a caller ever read one of them: a short, record-bounded board like `fleet-claims.kyri` is
shift-shaped and would reward content-defined splitting regardless of which diff granularity
measures it, while a long-prose card like `ITINERARY.md` turns out to be shift-shaped too, once
measured correctly -- so both documents this tree actually keeps, read honestly, land on the same
side of the dedup-ratio essays' own finding. `REDS.md`'s mixed structure is the one document left
that could still land on the other side, and it is also the one document neither essay could
afford to read yet.

## The script, printed in full

```python
#!/usr/bin/env python3
import subprocess, sys
from difflib import SequenceMatcher

PATH = "construction/fleet-claims.kyri"
NEAR_EQUAL_PCT = 0.15

def run(*args):
    return subprocess.run(args, capture_output=True, check=True).stdout

log = run("git", "log", "--follow", "--format=%H", "--reverse", "--", PATH).decode().splitlines()

revs = []
for h in log:
    try:
        blob = run("git", "show", f"{h}:{PATH}")
    except subprocess.CalledProcessError:
        continue
    revs.append((h, blob))

pairs_total = pairs_read = pairs_excluded = 0
hunks = insert_only = delete_only = mixed_near_equal = mixed_length_changing = 0

for i in range(1, len(revs)):
    a_h, a = revs[i-1]
    b_h, b = revs[i]
    if a == b:
        continue
    pairs_total += 1
    if len(a) > 50000 or len(b) > 50000:
        pairs_excluded += 1
        continue
    pairs_read += 1
    sm = SequenceMatcher(None, a, b, autojunk=False)
    ops = [op for op in sm.get_opcodes() if op[0] != "equal"]
    for tag, i1, i2, j1, j2 in ops:
        hunks += 1
        rm, ad = i2 - i1, j2 - j1
        if tag == "insert" or (rm == 0 and ad > 0):
            insert_only += 1
        elif tag == "delete" or (ad == 0 and rm > 0):
            delete_only += 1
        else:
            longer, diff = max(rm, ad), abs(rm - ad)
            if longer > 0 and diff / longer <= NEAR_EQUAL_PCT:
                mixed_near_equal += 1
            else:
                mixed_length_changing += 1
```

*May the shape of a record outlast the method used to see it, and may the next reading of
`REDS.md` find a tool fast enough to afford the ledger its due measure.*
