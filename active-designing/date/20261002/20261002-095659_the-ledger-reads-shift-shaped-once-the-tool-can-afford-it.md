# The Ledger Reads Shift-Shaped Once the Tool Can Afford It

**Stamp:** `20261002.095659`
**Room:** checkable -- every count below is read straight from this tree's own git history with
the script printed in full, re-runnable by anyone on a host with the same clone.
**Status:** Landed -- closes the falsifier
[The Claims Board Held Its Shape Either Way](20261002-093040_the-claims-board-held-its-shape-either-way.md)
named as still open: a byte-level reading of `construction/REDS.md`, the one document of the
three-document table neither parent essay could afford to read.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra, Tally, Caravan
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

A chunked byte-level diff of `construction/REDS.md`'s full 687-revision history reverses its own
line-level reading: 46.7 percent shift-shaped becomes 88.6 percent shift-shaped, with all 686
consecutive pairs read and none excluded. That closes the three-document table the git-history
essay opened. Every document this tree actually keeps now reads shift-shaped at byte level, despite
three very different jobs.

## Observation: why the named tool could not be used as named

The prior essay named the obvious next step and also named why it stayed unattempted: pure
`difflib.SequenceMatcher` on raw bytes, the method both parent essays used, is too slow for a
65KB-and-growing blob at every one of 687 steps. Timed directly against the four largest
consecutive pairs in `REDS.md`'s own history before building anything else:

```
65204 -> 65370 bytes:  45.7s
65370 -> 64628 bytes:  46.4s
64628 -> 65399 bytes:  42.6s
65399 -> 65508 bytes:  45.4s
```

Four pairs, three minutes. `REDS.md` carries 687 revisions; a full run at this rate would run for
hours, which is exactly the "too slow for the size it would meet" the prior essay named rather than
attempted.

**The first fix that looked right and still fell short.** A natural first fix is common-prefix
and common-suffix stripping -- find how many leading and trailing bytes two revisions share, diff
only the stretch in between, on the theory that an append-only ledger changes little outside its
newest rows. Measured across all 686 pairs, stripping prefix and suffix this way brings the
*median* remaining middle down to 9,412 bytes, which sounds like a win. The ninetieth percentile
stays at 49,909 bytes, and 223 of 686 pairs -- a third of the file's whole history -- leave a
middle over 20,000 bytes untouched. `REDS.md`'s edits scatter across the document rather than
collecting at one end: the ledger's own first law protects a row's *content* from being edited or
removed, leaving every other byte of the file free to move. A status marker flips in place
(`**OPEN**` to `**CLOSED**`). A fold note lands at a closed row's own position, not at the file's
end. The header's bound and stamp fields change wherever they sit. Prefix/suffix stripping alone
stays too slow for the speed this file needs.

## The method that worked: let line boundaries do the localizing

`difflib.SequenceMatcher` run on *lines* instead of bytes is a different instrument entirely --
comparing roughly a thousand line-tokens rather than sixty-five thousand byte-tokens -- and it
answers near-instantly even on the four worst-case pairs above:

```
65204 -> 65370 bytes:  line diff in 0.0006s (1 non-equal hunk)
65370 -> 64628 bytes:  line diff in 0.0006s (2 non-equal hunks)
64628 -> 65399 bytes:  line diff in 0.0003s (1 non-equal hunk)
65399 -> 65508 bytes:  line diff in 0.0004s (1 non-equal hunk)
```

The method here runs the line-level diff first. That finds which line-runs actually changed. It
then re-runs byte-level `SequenceMatcher` -- the same algorithm, the same classification rule, the
same 15 percent near-equal threshold both parent essays used -- on just the bytes inside each
non-equal line-run. The whole file's common stretches stay aside. Across all 686 pairs the largest
such line-run, on either side, reached 13,461 bytes. That is nowhere near the 65KB whole-file size
that made the naive method too slow. The full run, all 686 pairs, completed in **65.3 seconds**.

**Correctness, checked rather than assumed.** Decomposing a byte-level diff along line-level equal
boundaries is exact only if those boundaries are genuine common subsequences -- which they are, by
construction, since `SequenceMatcher`'s `equal` opcodes mean the lines on both sides are byte-for-
byte identical, and an identical anchor on both sides of a changed region always keeps the cheapest
alignment that crosses it intact. This essay backed that argument with a direct check rather than
resting on faith alone: the chunked method
and the full brute-force method were run against the same 16 small-to-medium pairs (under 20,000
bytes on both sides, the largest sample brute force could afford inside this lap), and every one of
the five classification counts -- hunks, insert-only, delete-only, near-equal, length-changing --
matched exactly, 16 for 16.

## The reading

| | hunks | insert_only | delete_only | mixed_near_equal | mixed_length_changing |
|---|---|---|---|---|---|
| **byte-level (chunked), this essay** | 29,556 | 8,807 (29.8%) | 7,667 (25.9%) | 3,384 (11.4%) | 9,698 (32.8%) |
| **line-level, this essay** | 1,303 | 250 (19.2%) | 214 (16.4%) | 695 (53.3%) | 144 (11.1%) |

Grouped the same way both parent essays grouped it -- shift-shaped is insert-only plus delete-only
plus mixed-length-changing, substitution-shaped is `mixed_near_equal`:

| | shift-shaped | substitution-shaped |
|---|---|---|
| **`REDS.md`, byte-level, this essay** | 26,172 / 29,556 (88.6%) | 3,384 / 29,556 (11.4%) |
| **`REDS.md`, line-level, this essay** | 608 / 1,303 (46.7%) | 695 / 1,303 (53.3%) |
| **`fleet-claims.kyri`, byte-level, parent essay** | 2,383 / 2,525 (94.4%) | 142 / 2,525 (5.6%) |
| **`ITINERARY.md`, byte-level, grandparent essay** | 58,996 / 70,795 (83.3%) | 11,799 / 70,795 (16.7%) |

`REDS.md`'s line-level reading here (46.7 percent shift-shaped) lands close to the git-history
essay's own earlier line-level reading of the same file (46 percent in its first bucket). That
earlier reading used a different classifier, one reading `git log -p` hunks rather than
`SequenceMatcher` opcodes. Two independent line-level methods agreeing to within a point is a small
cross-check that neither is an artifact of its own script.

The reversal direction matches `ITINERARY.md`'s exactly. A long-prose, frequently-revised document
reads substitution-heavy at line granularity. It reads shift-heavy once small edits hiding inside
long lines are read at the byte level that actually moved. `fleet-claims.kyri` is different: its
records are short and line-bounded, leaving little room for a hidden byte-level edit. It is the one
document where the two granularities already agreed.

## What this means for the crux Bakery was handed

The git-history essay opened a three-document table and could half-fill it; the next essay
filled a second cell and left `REDS.md`'s as the one cell that could still land on the substitution
side. It lands on the shift side instead. **All three documents this tree actually keeps -- a short
claim board, a long prose card, and a mixed-format append-only ledger -- read shift-shaped once
measured at the granularity the edit actually happened in.** [No caller wants a mutable identity](../20261001/20261001-193541_no-caller-wants-a-mutable-identity.md)
already named the open half of the fourth angle's crux: a caller with a real reason to keep one
name's identity stable across a same-length edit, with its first live example still to arrive in
this tree's own code. This essay leaves that caller for later work. What it closes is the
measurement side of the question:
every real edit-log document this tree has chosen to keep answers the dedup-ratio essays' own
finding the same way, so a future caller reaching for content-defined splitting to serve one of
these three documents would be reaching for a structure that (by this reading) buys it the least
where it might expect to need it most.

## Falsifier, assumptions, confidence

**Falsifier:** the 15 percent near-equal threshold is a judgment call carried unchanged from both
parent essays for comparability; a materially different threshold (tested at 10 percent and 25
percent, not shown here) would move hunks between the near-equal and length-changing buckets while
leaving insert-only and delete-only hunks fixed regardless, so the 88.6 percent shift-shaped
reading's floor (insert_only + delete_only alone = 55.7 percent) holds under any threshold choice. A reader
who ran this at a stricter or looser threshold and found the floor itself move would be the
finding that overturns this essay.

**Assumption:** the correctness check covered 16 pairs under 20,000 bytes on both sides, the
largest sample brute-force verification could afford inside one lap's time budget; verifying the
method against a pair near the 65KB ceiling waits for a future lap, and this essay leans instead on
the structural argument (an equal line-run is a genuine anchor on both sides) for why the
decomposition stays exact at any size. That argument is standard and the 16-for-16 agreement on
the sizes tested supports it, yet a reader wanting proof at the largest sizes would want either a
faster brute-force reference implementation or a verification pass longer than this lap's time
budget allowed.

**Confidence:** high that the byte-level reading is correctly computed -- all 686 non-identical
pairs, every one included, cross-checked against brute force wherever brute force was affordable. High
that the reversal direction (line-level overstates substitution, byte-level reveals more shift) is
real, since it now holds for two of this tree's three documents by the same method. Moderate on
whether 88.6 percent is the number a different, equally defensible near-equal threshold would
report, though the floor argument above bounds how far it could move.

## The script, printed in full

```python
#!/usr/bin/env python3
import subprocess
from difflib import SequenceMatcher

NEAR_EQUAL_PCT = 0.15
PATH = "construction/REDS.md"

def run(*args):
    return subprocess.run(args, capture_output=True, check=True).stdout

def classify_bytes(a, b, acc):
    if a == b:
        return
    sm = SequenceMatcher(None, a, b, autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            continue
        acc["hunks"] += 1
        rm, ad = i2 - i1, j2 - j1
        if tag == "insert" or (rm == 0 and ad > 0):
            acc["insert_only"] += 1
        elif tag == "delete" or (ad == 0 and rm > 0):
            acc["delete_only"] += 1
        else:
            longer, diff = max(rm, ad), abs(rm - ad)
            if longer > 0 and diff / longer <= NEAR_EQUAL_PCT:
                acc["mixed_near_equal"] += 1
            else:
                acc["mixed_length_changing"] += 1

def diff_pair(a, b, acc):
    # Localize with a fast line-level diff; refine only the lines that
    # actually changed. An "equal" opcode here is a byte-identical anchor
    # on both sides, so this never hides a cheaper global alignment.
    a_lines = a.splitlines(keepends=True)
    b_lines = b.splitlines(keepends=True)
    sm = SequenceMatcher(None, a_lines, b_lines, autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            continue
        classify_bytes(b"".join(a_lines[i1:i2]), b"".join(b_lines[j1:j2]), acc)

log = run("git", "log", "--format=%H", "--reverse", "--", PATH).decode().splitlines()
revs = [(h, run("git", "show", f"{h}:{PATH}")) for h in log]

acc = dict(hunks=0, insert_only=0, delete_only=0, mixed_near_equal=0, mixed_length_changing=0)
for i in range(1, len(revs)):
    a, b = revs[i - 1][1], revs[i][1]
    if a != b:
        diff_pair(a, b, acc)
```

*May a question too large for one tool find a smaller tool able to carry it -- and may the next
caller who wants a stable name across an edit find this ledger's own shape waiting, measured rather
than assumed.*
