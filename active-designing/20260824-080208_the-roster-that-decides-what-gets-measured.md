# The Roster That Decides What Gets Measured

**Language:** EN
**Stamp:** `20260824.080208`
**Voice:** Kyri
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- the three measurements below were taken on metal and are named with their dates
**Kin:** [`stamp-and-name`](../.claude/rules/stamp-and-name.md) - [`reds-first`](../.claude/rules/reds-first.md) - REDS %184, %185, %187

---

## The question

Every meter in this tree reads a list of things to measure. So what measures the list?

The question arrived on `20260824` because one answer went wrong three times in five hours, in
three different rooms, and each repair stayed inside the room it was made in.

## What was measured, and when

Three readings, all taken on `20260824` on this pier, each by counting a set on disk against the
list that claimed to name it:

| Reading | The list said | The disk held | Stamp |
|---|---|---|---|
| Caravan's ladder table | 73 rungs | 110 modules | `062207` |
| Mycelium's naming rule | 95 of its modules | 98 modules | `071500` |
| The living-docs meter's roster | 6 module front doors | 34 module front doors | `075409` |

The third is the one that names the class, because that list decides what a **meter** reads. The
first two govern what a person finds; the third governs what every downstream reading can see at
all. Its blind spot was measurable: asked of the roster, the tree held three documents over the
24,576-byte pin bound, and asked of the tree it held seven. Four over-bound documents were
invisible to the meter that exists to find them, and the two largest pages anywhere in the tree
were among them.

## The observation the three share

Each list was written by hand, and each was true on the day it was written.

That is the whole mechanism, and it is worth stating plainly because it sounds too simple to
matter. A hand-written list is a photograph of a directory. The directory keeps growing; the
photograph keeps its moment. The divergence stays quiet, because a list holds exactly what
somebody typed, and it holds that correctly forever.

## Why a reader's roster drifts further than a program's

A program's roster gets corrected by the program. `tools/ca/caravan_suite_witness.rish` holds a
bijection between the witnesses on disk and its own list, so a missing entry breaks a run on the
next lap and somebody fixes it within the hour. All 33 of Caravan's unlisted rungs were heard by the
machine.

A reader's roster waits on a person for that same correction. A missing entry breaks understanding, and understanding
fails quietly: the reader simply does not learn a thing exists, forms no question about it, and
reports nothing. The same module carried both kinds of roster, and only the free one went short.

**The inference:** a list's accuracy tracks how loudly its errors arrive, rather than how carefully
it was written.

## The three tiers, in order of what a gap costs

Reading the three findings together, the lists in this tree sort into three tiers, and the cost of
a gap rises steeply down the column:

1. **A roster a program runs.** A gap breaks a run. Self-correcting within a lap.
2. **A roster a reader uses.** A gap costs one reader one understanding. Silent, and it accretes.
3. **A roster a meter reads.** A gap costs every reading downstream of it, including the readings
   that exist to catch tiers 1 and 2. Silent, and it compounds.

Tier 3 is where the effort belongs, and it is the tier nobody had been checking, because a meter
feels like the thing that does the checking rather than a thing that needs it.

## The repair that generalizes

Discovery rather than a list. Ask the system for the set instead of remembering it.

The tree had already written this down. `tools/fixtures/index_fold_scan.sh`, seated `20260824.052329`,
carries the sentence in its own body: *discovery rather than a roster, so a room that folds tomorrow
is measured the same way.* Four hours later, forty guards away, the living-docs roster was still a
hand list. A habit learned in one room travels to another by being written where the next hand
reads it, rather than by being true.

Three properties make a discovered roster hold where a written one slips:

- **It asks the system.** `git ls-files` over a glob, `git check-ignore` over a guess about which
  rooms are generated. The system already knows; a written answer is a copy that can drift from it.
- **It stays a pure function of what is on disk.** Add a module and it is measured on the next run,
  with the rule doing the remembering.
- **It keeps the hand-written entries it cannot derive.** Three module front doors keep their
  sources one level down, where the rule cannot see them, and they stay listed by hand. A page
  dropping off a meter is a page whose pass nobody witnessed, so a rule arriving takes nothing
  away.

## What still stands open

Two lists of tier 3 remain unmeasured as of `20260824.080208`, and both are named here so a later
lap starts from the measurement:

- **The DOOR roster** in `tools/fixtures/prose_register_scan.sh` names **7** documents. The tree
  holds **34** module front doors. Mycelium's page read 46% negative against a 20% ceiling on
  `20260824.071500` precisely because it stood off this list, so the gap has already cost once.
- **The standing-equipment roster** names **42** guards; the tree holds **1,670** `*_witness.rish`
  files. Most are reached by suite witnesses that hold their own bijections, so the two numbers are
  meant to differ. The open question is whether **every** witness on disk is reached by something,
  since a witness nobody runs guards nothing. Answering it means tracing reachability rather than
  comparing counts, which is a round of its own.

**A falsifier for the whole thesis:** find a hand-written roster in this tree that has stayed
complete for a month while its directory grew. One would show that care alone can hold a list, and
that the three findings above were three accidents rather than one mechanism. None has been found
so far, and the search has been narrow.

## The trade-off this accepts

A discovered roster costs a rule, and a rule can be wrong in a way a list cannot. The first
discovery expression written for the living-docs roster used `git ls-files 'dir/*.rye'`, whose glob
crosses slash boundaries, so it read a room's index as a module front door on the strength of a
fixture three directories down. A list stays exactly right about its own entries, which is how
it would have stayed clear of that mistake.

The answer is to prove the rule from both sides on planted corpora, which is what the tree's guards
already do. Sixteen behaviors on real git repositories settle what the rule means, and the
load-bearing case is the one where an untracked README sits beside a tracked source and passes
free -- a glob would have manufactured a door out of a scratch file.

So the bill is honest: a rule needs a pen, where a list needed only a careful hour. The pen is paid
once and holds forever, and the careful hour is paid again every time the directory grows.

---

*May every list know what it is missing, and may the ones that cannot be taught to know it be
retired in favor of a rule that asks.*
