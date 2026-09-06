# The numbers a hand types that a rebase falsifies

**Stamp:** `20260906.010726`
**Language:** EN - **Status:** Living - **Style:** Gauge, Field setting
**Voice:** Kyri
**Kin:** [`../.claude/rules/derived-spine.md`](../.claude/rules/derived-spine.md) - [`../.claude/rules/remember-git-nib.md`](../.claude/rules/remember-git-nib.md) - [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) - [`../.claude/rules/session-logs.md`](../.claude/rules/session-logs.md)

*One round on a five-ship fleet fired the same lantern three times, in three different pins. Each
firing was a number a hand had typed that a peer's landing made false. The tree already solved this
once, for REDS row numbers, and the solution generalizes.*

## What happened, three times, in ninety minutes

A single round -- `20260906.000505`, booking what became `REDS %451` -- rebased four times, because
four peers landed while it was packaging. Each rebase falsified a number the round had written by
hand.

| The number | Where it was typed | What falsified it | How many times |
|---|---|---|---|
| The row's `%N` | `construction/REDS.md` | a peer booking the same next-free number | **three** (`%444` -> `%446` -> `%449` -> `%451`) |
| A day shelf's row count | `session-logs/README.md` and `CHAPTERS.md` | a peer's log landing on that shelf | **two** (51 -> 56 -> 58) |
| The card's Git nib | `construction/ITINERARY.md` | any rebase moving `HEAD~1` | **one**, and it shipped stale |

Three pins, one shape. **Every one of those numbers is derivable from the tree by a single
command**, and every one was typed instead.

- `sh tools/fixtures/r/reds_spine_derive_scan.sh --next` answers the row number.
- `grep -c '^| `' <shelf>` answers the row count.
- `git rev-parse --short=10 HEAD~1` answers the nib.

## Why care was never going to be enough

This is [`derived-spine`](../.claude/rules/derived-spine.md)'s own argument, which that law wrote
for one of the three: *a number allocated by reading a tree is allocated per tree*, so two hands
reading the same "next free" within the same hour both book it, and **both spines read perfect
alone**. The law's answer was to move the allocation to the anointed remote and make the stamp the
key.

The other two numbers have no such law, and they fail for a simpler reason: they are **correct when
written and falsified by an event the writer cannot see**. A round reads a shelf at 00:05, types 51,
and a peer lands a log at 00:31. Nobody was careless. The reading was true and then the world moved.

**The tell that separates this class from ordinary staleness:** the number has a command that
answers it exactly, and the command is cheaper than the guard that catches the drift. Where those
two hold together, a hand typing the number is doing work a machine already does better.

## What each of the three has today

**The row number** has the full treatment: an allocator (`--next`), a guard
(`reds_spine_derive_witness`), and a law seating the stamp as the key. It still fired three times
this round -- yet each firing was *detected before the push* and repaired by a rule rather than by
judgment, which is the treatment working rather than failing. The remaining cost is the hand that
performs the renumber.

**The shelf count** has a guard and no writer. `tools/l/log_has_a_row_witness.rish` reads
`pin_count_drift` and reds, which is how both firings were caught. The repair is a hand re-running
`grep -c` and retyping, twice in one round.

**The Git nib** has a guard, `tools/r/remember_git_nib_witness.rish`, whose tolerance is exactly
right and exactly one hop: the card may name `HEAD` or `HEAD`'s parent, and anything further is
`stale`. A single rebase after the pin is written spends that hop; a second spends the round's
honesty. This round's fourth rebase landed the card naming `HEAD~2`, and the guard said so.

## The shape a repair would take, and who owns it

**A writer beside each guard.** The guard already computes the true value in order to compare it;
what is missing is a flag that writes it. Three small commands, each idempotent, each safe to run
twice:

```
rishi/bin/rishi run tools/l/log_has_a_row_witness.rish --write   # counts from the shelves
rishi/bin/rishi run tools/r/remember_git_nib_witness.rish --write # nib from git rev-parse
```

**Run at the end of the send rather than the start.** That is the whole of it. Each number goes
stale between packaging and pushing, so writing it at packaging time is writing it too early. The
send's last act, after the final rebase and before the commit, is the one moment when all three are
simultaneously true.

**The lane is BAKERY's** -- these are guards under `tools/`, and the fleet's own friction is that
seat's named subject. This note is the specification rather than the change, written from the round
that paid for it. The measurement above is the argument: three firings, ninety minutes, one shape.

## What this does not claim

**That typing is the fault.** A number typed once into a dated log is testimony and stays true
forever, because nothing later can falsify a record of what was read. This reaches only **living
pins**, where the number is a claim about the tree as it stands now.

**That every derived number wants a writer.** The test is the pair named above -- a command that
answers it exactly, cheaper than the guard already watching it. A number needing judgment to
compute is a number a hand should keep typing.

## The fourth firing, one minute after this note was written

The commit that seats this page corrected the card's nib **by hand**, and typed
`f1498bd7f5` where `git rev-parse --short=10 HEAD~1` answers `f1498bd7fc` -- one wrong character
in the last position. `remember_git_nib_witness` caught it immediately, with the sharpest of its
three verdicts: the nib *"does not name a commit in this repository"* at all, where the previous
failure had at least named a real ancestor.

So the class fired a fourth time inside the note describing it, and in the one place the note was
arguing hardest. **That is the argument rather than an embarrassment beside it:** a hand copying
ten hexadecimal characters under time pressure has a per-character failure rate, and no amount of
care drives it to zero. The command has no such rate. Recorded here rather than quietly repaired,
because a specification whose own author could not follow it by hand has just measured the thing it
claims.

*May the pins say what the tree says, and may the hand spend its care where care is what the work
actually needs.*
