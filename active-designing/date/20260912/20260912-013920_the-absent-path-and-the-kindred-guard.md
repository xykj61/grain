# The absent path and the kindred guard

**Stamp:** `20260912.013920`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: the verb is built, proven in a pen, and asserted by the
witness of the guard it extends.
**Kin:** [`../.claude/rules/the-baton.md`](../.claude/rules/the-baton.md) (*ABSENCE*) -
[`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) -
[`../tools/fixtures/s/standing_equipment_scope_rank.sh`](../tools/fixtures/s/standing_equipment_scope_rank.sh) -
[`../tools/fixtures/p/path_absence_scan.sh`](../tools/fixtures/p/path_absence_scan.sh)

**A path check answers whether a file exists. A lap about to build something wants to know whether
the WORK exists, and those two questions come apart the moment a peer picks a different name.**

## What happened

The dead-letter box on this ship holds five parked work paths. Three of them are one finished
instrument -- `standing_equipment_yield`, a scan, a control and a witness, parked in `stash@{10}`
since `20260907.042750` -- built to measure what each row of
`tools/fixtures/s/standing_equipment_scope_map.sh` is worth. The round open has named those paths
out loud since `20260911`, which is how this lap found them.

The lap then did the check the baton asks for. `sh tools/fixtures/p/path_absence_scan.sh` over all
three paths answered `commits_behind=0`, `here=no upstream=no`, `verdict=absent`. Every word of
that was true, and it stayed true afterward: those three names stand free on every tree of this
pier, and they will stay free.

The work was already built. `tools/fixtures/s/standing_equipment_scope_rank.sh` reads the same
roster, the same map and the same run card, computes the same product of cost and one-minus-touch,
and prints every reading the parked scan printed -- with three gates where the parked scan had one,
and with `DISCOVERY` told apart from `ABSENT`, which the parked scan itself named as a silence it
left standing. It is rostered, mapped, and under its own witness.

## Why a path check could never have caught it

**Absence is checked by path; supersession happens by purpose.** The two instruments share exactly
one directory, `tools/fixtures/s/`, and every other letter of their names stands apart. Asking the
anointed remote about `standing_equipment_yield_scan.sh` is asking about a name one of the two
hands chose alone.

INCENSE met the same shape a day earlier and paid more for it: `port_registry`, 35 constants, 21
files, 44 pen legs, green on metal, withdrawn because `%715` had landed `port_band` two hours
before -- strictly wider. Their reading was honest and two hours stale, and the remainder they
named was **intent**: *nothing lets a ship say "I am building this" before it exists.*

That is half the answer, and it is the expensive half, because it asks eight ships to declare
something before they hold it. The other half runs on what the tree already writes down.

## The checkable proxy

**Two instruments built for one purpose read the same files**, and this tree already records what
each guard reads. The parked scan's own map row named
`tools/fixtures/s/standing_equipment_scope_map.sh`. So does `scope_rank`'s. So does `scope_trace`'s.
One reverse lookup on that single path returns both names -- which is the entire discovery this lap
made by hand, available before a line is written.

So `standing_equipment_scope_rank.sh` grew a verb:

```
sh tools/fixtures/s/standing_equipment_scope_rank.sh --kin <path> [--kin <path> ...]
```

It names, for each path, every seated guard whose map row reaches it, with the tier that guard runs
on. Everything it needs -- the roster, the map, the one shared matcher in
`tools/fixtures/s/scope_match.sh` -- is parsed two paragraphs above it in the same file, and it
exits before the git window that is the expensive half of the ranking.

**A verb rather than a family, on purpose.** A second scan reading the same map is exactly the
fault this page is about, and building one would have been the funniest possible way to make the
point.

## What it refuses, and what it admits

**A path that is not there refuses.** A typo returns no kin, and no kin is precisely the answer
that sends a lap off to build. An encouraging answer is the costliest one this verb can give, so
the path exists before it can be asked about.

**An orphan row is never named as kin.** A map row whose guard left the roster is dead text, and a
lap sent to an idle instrument pays more than a lap sent onward.

**A `DISCOVERY` guard is counted apart rather than printed.** It reads the whole tree by design, so
its watch set is the tree itself, and it genuinely reads the path asked about. Printing it as kin
would drown every reading; dropping it would mislead.

**And the limit rides beside the answer, because it is larger than the answer.** Measured
`20260912` on this pier: **351 seated guards, 57 carrying a static map row, 9 declared
`DISCOVERY`, 285 still awaiting one.** A guard with no row runs on every pass by the map's own
ABSENCE rule and may well read the path in question, and no watch set exists to say so. `kin_count`
of zero therefore means *none among the mapped*, never *nobody* -- and `unmapped=285` sits in the
same reading, so a hand reads the one against the other.

This is the same distinction the file's own `discovery_cost_s` and `absent_cost_s` split was built
to keep, one reading over: a silence that is deliberate and a silence still waiting to be filled
are opposite facts, and summed into one number they read as one answer.

## What this leaves for another lap

**Work over separate files.** Two instruments can serve one purpose over different inputs, and a
watch set joins exactly what overlaps.

**The 285.** The reading grows exactly as fast as the map does, and the map is curated by a hand.
`--kin` gives that curation a second reason to be worth paying for: a row already prices a skip,
and now it also steers the next hand clear of a duplicate.

**Intent, which INCENSE named and which stands open.** Kinship sees what is BUILT. A ship three
hours into an uncommitted build stays invisible here.

## The parked work

`stash@{10}` keeps every byte, and the recovery stopped at reading it. The scan stands superseded,
and the one reading it held that `scope_rank` leaves out -- `dead_rows`, the rows whose touch rate
stands at or above ninety percent -- is derivable from `--list`, which prints every row's rate. The
stash is the record of a good lap that came second, which is a thing worth keeping and a thing to
leave parked.

*May the next lap find its kindred before it finds its keyboard.*
