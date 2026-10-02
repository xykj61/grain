# The Real Edit Log Was Already in Git, Not in Mantra

**Stamp:** `20261002.010921`
**Room:** checkable -- every count below is read straight from this tree's own git history with
the command that produced it, reproducible by anyone who re-runs it.
**Status:** Landed -- answers the open half of
[No caller wants a mutable identity](../20261001/20261001-193541_no-caller-wants-a-mutable-identity.md)'s
own falsifier using a source that essay did not reach for.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra, Tally, Caravan
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

This tree already holds real multi-revision edit traffic on three living documents --
`construction/fleet-claims.kyri`, `construction/REDS.md`, `construction/ITINERARY.md` -- and
reading their git history at the line-hunk level finds three different edit shapes rather than
one: fleet-claims is 94 percent shift-shaped (whole blocks appear and disappear), ITINERARY is 76
percent substitution-shaped (same-length-ish text changes in place), and REDS sits between the two
at 46 percent substitution-shaped -- so the "real caller" the parent essay asked for already
exists outside Mantra: this tree has been producing real edit logs in plain git the whole
time, and they already disagree about which chunker would serve them.

## Observation: three living pins, read by their own history

[No caller wants a mutable identity](../20261001/20261001-193541_no-caller-wants-a-mutable-identity.md)
named its own falsifier: *a module lands that takes a name already bound ... and asks the store to
keep serving that name. The day such a caller exists, its own edit log is the real traffic the
dedup-ratio scans should run against, rather than the synthetic insert/delete/substitute configs
this ladder has used throughout.* That essay looked for the caller inside Mantra and Pond alone.
This tree's own `construction/` pins stand outside that search, and they are exactly the thing the
falsifier describes under a different mechanism: a stable name (`ITINERARY.md`, `REDS.md`,
`fleet-claims.kyri`) whose bytes git has been asked to keep serving, revised hundreds of times, with
every revision kept as testimony.

Read `git log --follow`'s own commit count for each, the whole history available on this host:

| Pin | Commits |
|---|---|
| `construction/fleet-claims.kyri` | 801 |
| `construction/REDS.md` | 809 |
| `construction/ITINERARY.md` | 4,867 |

Each commit's diff against the file is a real edit, made by a real hand or a real lap, for a real
reason named in this tree's own rules -- `the-writer-sheds` for the card, `reds-first` for the
ledger, `the-baton`'s claim discipline for the board. Every one of the three was edited for its own
standing reason, long before this measurement; the measurement reads what was already there.

**The method.** `git log --follow -p -- <path>` prints every commit's unified diff against the
file in turn. A diff hunk (the block between one `@@ ... @@` marker and the next) is classified by
what it contains:

- **insert_only** -- every changed line in the hunk is a `+` line. Content appeared; nothing
  existing moved or changed.
- **delete_only** -- every changed line is a `-` line. Content disappeared outright.
- **mixed** -- the hunk carries both `+` and `-` lines. Something present was replaced by something
  else, at the granularity git's own diff algorithm chose to group together.

A mixed hunk is split further by comparing the total character count of its removed lines against
its added lines. **mixed_near_equal_len** holds when the two lengths differ by less than 15
percent -- the shape a true same-length substitution takes. **mixed_length_changing** holds
otherwise -- the shape a multi-line insertion or deletion takes when git's diff algorithm happens
to group it next to an unrelated nearby change rather than rendering it as a clean insert or
delete. The 15 percent threshold is named rather than derived; it is this essay's own judgment
call, held loosely in the confidence section below.

**The reading**, reproduced with:

```
git log --follow -p -- <path> | awk -f classify_hunks.awk
```

(the awk program is thirty lines, printed in full in the appendix below, so the reading is
re-derivable from this page alone, directly from the script this page prints)

| Pin | hunks | insert_only | delete_only | shift total | mixed_near_equal | mixed_length_changing |
|---|---|---|---|---|---|---|
| `fleet-claims.kyri` | 844 | 401 | 392 | 793 (94.0%) | 19 (2.2%) | 32 (3.8%) |
| `REDS.md` | 1,226 | 227 | 114 | 341 (27.8%) | 558 (45.5%) | 327 (26.7%) |
| `ITINERARY.md` | 8,759 | 271 | 61 | 332 (3.8%) | 6,676 (76.2%) | 1,751 (20.0%) |

## Inference: the document's own job predicts its edit shape

The three numbers read as three different documents doing three different jobs, and the jobs
explain the shapes.

`fleet-claims.kyri` is a board of whole records: `tools/f/fleet_claim.sh --open` appends one block,
`--close` removes it, and the file's own header says a board "holds only live claims" so every
block is touched exactly once, at its open and at its close. A claim's open and its close sit in
different parts of the file and different commits, so git's diff keeps a `+` and a `-` in separate
hunks far more often than it pairs them in one -- the shape the `the-baton` rule already describes
in words (*a declaration ... leaves the present moment alone*) shows up here as a number: 94
percent of its hunks are pure appearance or pure disappearance.

`construction/ITINERARY.md` is the opposite kind of document. `the-writer-sheds` asks for exactly
one live account per seat, shelved and replaced rather than left to accumulate -- and a shelving
edit, read at the line level, is usually a short passage of running prose swapped for another short
passage of running prose at the same spot: a status word flips from OPEN to BOOKED, a count is
revised, a sentence is re-worded on touch. 76 percent of its hunks hold old and new text within 15
percent of each other's length -- the shape of a document that is rewritten in place far more often
than it simply grows.

`construction/REDS.md` sits between the two because it is asked to do both jobs at once: new rows
are genuinely appended (its own law keeps a row exactly as written once filed), which is
shift-shaped, while the surrounding prose around a row -- the standfast language, the open-door
notes, the `%NNN` count references -- gets touched and re-worded the way ITINERARY's prose does.
Its 46/28/27 split is what a ledger with append-only rows and editable connective tissue looks
like when both behaviors are read through one file's history.

This is the same distinction
[the dedup ratio nobody has measured](../20261001/20261001-151253_the-dedup-ratio-nobody-has-measured.md)
and its sequel already proved on synthetic data: content-defined beading wins when an edit shifts
bytes downstream (insert, delete), and fixed-size beading wins when an edit replaces bytes in place
(substitute, same length). Read against that finding, a document shaped like `fleet-claims.kyri` is
exactly the caller content-defined splitting would serve; a document shaped like `ITINERARY.md` is
exactly the
caller fixed-size splitting would serve instead.

## Projection: what this settles and what it leaves open

**Horizon:** already closed -- this reads history already written rather than a forecast.

**Assumption:** that a git line-diff hunk is a reasonable proxy for an edit's byte-level shape.
This is the weakest link in the method, named plainly: a single-character change inside one long
line is, at the byte level, an insertion of a handful of bytes -- a shift -- but git's line-oriented
diff renders it as one `-` line and one `+` line of nearly equal length, which this essay's own
classifier reads as `mixed_near_equal_len`, i.e. substitution-shaped. So the 76 percent and 46
percent substitution figures above are an upper bound on true byte-level substitution, inflated by
every short-line edit that is actually a small shift dressed as a line swap. The `mixed_near_equal`
versus `mixed_length_changing` split was built to separate a cleaner signal from the raw mixed
count, and it still inherits this limitation at the floor the line level stops at.

**Falsifier:** re-run the same classification at the byte level rather than the line level -- diff
each pair of consecutive revisions with a byte-oriented or word-oriented diff (`git diff
--word-diff` or a longest-common-subsequence over raw bytes) and ask what fraction of bytes
downstream of a change actually moved versus stayed put. If that reading brings `ITINERARY.md`'s
substitution share down near `fleet-claims.kyri`'s, this essay's line-level proxy was misleading
rather than simply imprecise, and the claim above should be withdrawn. This essay names that check
as the next falsifying step rather than running it.

**Confidence:** high that the three counts above are correctly read from this tree's own git
history as it stands today -- the method is simple enough to re-run and audit in full. Low to
moderate on how far the line-level shape generalizes to the byte-level shape a real
content-defined chunker would actually see, for the reason named in Assumption above.

## What this means for the crux Bakery was handed

The parent essay was right that every module in Mantra and Pond today keeps a stored name bound to
the bytes it was first given. Its reach stopped short of this tree's own real edit logs -- three
stand in plain git, and they already show the dividing line the synthetic configs predicted: a
board of whole records shifts, a rewritten prose card substitutes, and a ledger that does both
reads as both. Building a Mantra caller to generate real traffic would answer
a question this tree's own history had already answered, at a coarser grain, for free. The sharper
version of the open crux asks whether the byte-level shape of ITINERARY.md's own revisions,
measured properly, confirms or overturns what its line-level shape suggests -- the falsifier
above, still open.

## Appendix: the classifier

```awk
BEGIN { hunk=0; has_plus=0; has_minus=0; plen=0; mlen=0; ins=0; del=0; mix_near=0; mix_far=0; total=0 }
function flush() {
    if (hunk==1) {
        total++
        if (has_plus && has_minus) {
            big = plen > mlen ? plen : mlen
            small = plen > mlen ? mlen : plen
            if (big == 0) { mix_near++ }
            else if ((big-small)/big < 0.15) mix_near++
            else mix_far++
        }
        else if (has_plus) ins++
        else if (has_minus) del++
    }
    hunk=0; has_plus=0; has_minus=0; plen=0; mlen=0
}
/^@@/ { flush(); hunk=1; next }
/^commit /{ flush(); hunk=0 }
/^\+\+\+/ { next }
/^---/ { next }
/^\+/ { if(hunk) { has_plus=1; plen += length($0)-1 }; next }
/^-/ { if(hunk) { has_minus=1; mlen += length($0)-1 }; next }
END {
    flush()
    printf "hunks_total=%d insert_only=%d delete_only=%d mixed_near_equal_len=%d mixed_length_changing=%d\n", total, ins, del, mix_near, mix_far
}
```

Run as `LC_ALL=C git log --follow -p -- <path> | LC_ALL=C awk -f classify_hunks.awk`. This one
reading carries its own tool in full on this page rather than in a tracked file; a future lap that
wants it as a standing instrument can lift it from here rather than
re-deriving it.
