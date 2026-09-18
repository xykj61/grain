# The Binary Two Guards Are Writing

**Stamp:** `20260912.020039` -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Room:** checkable -- every count below is read by `tools/fixtures/b/build_target_scan.sh` and every
timing is read by `tools/fixtures/b/build_target_race_probe.sh`, both on this pier.
**Status:** Landed -- gated by [`tools/b/build_target_witness.rish`](../tools/b/build_target_witness.rish)
**Kin:** [`reds-first`](../.claude/rules/reds-first.md) -- REDS `%700` -- [`the-baton`](../.claude/rules/the-baton.md)

A guard that builds a binary has to put it somewhere. Until this lap, nothing in this tree ever
asked where.

## The counts

Read `20260912` off `construction/standing-equipment.kyri` and the witness sources it names:

| Reading | Count |
|---|---|
| rostered guards | 353 |
| guards passing `-femit-bin=` to `rye build` | 60 |
| emit sites across those guards | 125 |
| sites naming a fixed path inside the tree | 110 |
| sites naming a directory the run made for itself | 15 |
| sites this scan cannot follow | 0 |
| distinct fixed paths | 51 |
| fixed paths written by two or more distinct guards | 6 |
| writers on the most-written path | 18 |

Three of the six shared paths -- `amphora/bin/vessel-seal`, `amphora/bin/vessel-core` and
`amphora/bin/amphora` -- are each written by eighteen different rostered guards. The other three are
`amphora/bin/manifest-entry` at four, and two pairs.

**These figures are walled rather than free.** `emit_fixed` and `shared_paths` sit under ceilings
that only fall, so a new guard building into a fixed tree path reds on the lap it lands. Run the
scan rather than trusting the table.

## Why a shared path costs something, measured rather than argued

The argument writes itself and it is easy to get wrong. A compiler that emitted its output by
writing a temporary and renaming it over the target would make this whole exposure imaginary: a
rename is atomic, so a reader sees either the old file or the new one and never a half of either.

So the first reading is the concrete fact at the door. **A rebuild leaves the output file's inode
unchanged.** `rye build` writes *through* the existing file rather than replacing it, and everything
below follows from that one fact.

Measured on metal over 400 executions of a tiny program while builds ran beside it:

| The reader's own path is... | Failed executions |
|---|---|
| written by nobody, while three builds write three others | **0** |
| written by one other build | **335** |
| written by three other builds | **275** |

The failures are shell codes 126 and 127 -- *cannot execute* -- which is what a partially written
binary looks like from the outside. When three builds shared one target, the file that survived was
one of the three arbitrarily.

## The lock that exists covers the other axis

`rye build` already holds a lock. `rye/src/main.rye` takes `.rye-build.lock` from the first shadow
write to the last delete, which REDS `%281` booked and
[`tools/r/rye_build_lock_reach_witness.rish`](../tools/r/rye_build_lock_reach_witness.rish) holds.
So the three-writer row above did not race at all -- all three builds ran from the repository root,
took that one lock, and went one at a time.

**The reader still failed 275 times out of 400.** And the single-writer row, where there is no build
race whatever, failed **335** -- the worst of the three, because one uninterrupted build holds the
output file open longer than three taking turns.

That is the whole finding in one sentence: **the lock serializes builds against builds, and nothing
anywhere serializes a build against a run.** A boundary drawn on one axis over a hazard that lives
on another, which is the sentence that guard's own header already writes about its own scope.

## Who the second reader is

Within one roster pass, guards run one at a time, and `standing_equipment_run.sh` holds a directory
lock so no second pass opens over the first. That lock covers roster pass against roster pass and
reaches nothing else. The second reader is one of these:

- **A hand running a guard by name** while a pass is in flight -- which this tree's own baton tells
  every ship to do, and which the read-scope law makes the normal way to reach a witness.
- **A detached pass from a dead lap** still working through the roster. This lap met exactly that at
  its open: a `--hot` runner from the previous lap was still alive in this tree, and the lock was
  what said so.

**This is where the shared paths earn their place in the table.** A guard that writes a path only it
writes is exposed when that same guard runs twice at once. `amphora/bin/vessel-seal` is written by
eighteen, so a hand running any one of them can be executing the file a pass is building for any of
the other seventeen reasons -- eighteen chances rather than one, over one filename.

## What this does not prove

REDS `%700` records `mantra_recall_tablecloth_query_wire` reading red on a cold pass and green on a
re-run minutes later over one unchanged tree, and names two builds into fixed tree paths as the
suspicion. That guard's two paths are written by no other guard, so the shared-path reading above is
not its cause. What this lap adds to `%700` is that the *mechanism* it guessed at is real and large,
and that it is not the mechanism the row pictured: a build into a fixed path breaks a concurrent
reader 335 times in 400 with no second build anywhere near it. Whether `%700` is
this fault or another one stays open, and no run has caught that guard in the act.

## Two walls that already hold

`emit_tracked` is a build output the repository carries -- a lap could commit a binary.
`emit_unignored` is one git would show, which moves the tree digest the runner takes at open and
close, so a pass would refuse itself under `tree_moved`. Both read **zero** today, which is what
makes them walls rather than ratchets: a zero held from the day it is measured costs nothing and
refuses the first arrival.

## The convention this seats

**A new guard builds into a directory it made for itself.** The named escape is one line, and
fifteen sites already spell it:

```sh
d=$(mktemp -d); ... rye build src.rye -femit-bin=$d/thing ...; rm -rf $d
```

The 110 standing sites are not swept here. Lowering `emit_fixed` is a per-lane lap, and the cheapest
first move is the amphora family, where eighteen guards share three paths.

## Why the probe is not on the roster

The probe's reading is timing-dependent, and a timing-dependent guard on the roster is a guard that
answers differently on one unchanged tree -- which is `%700`, the very fault this family was opened
for. Adding a flapping guard to measure flapping would be the joke writing itself. A hand runs the
probe when the question comes up; the ratchets are what stand.

## What the scan cannot see

`emit_unresolved` counts a site whose target is a variable the scan cannot follow to either a
literal or a `mktemp`. It reads zero today, and while it stands above zero `emit_fixed` is a floor
rather than a total. The scan says so in its own printout, because a reading that names its blind
spot is worth more than one that quietly rounds down.

The scan's own first draft got this wrong in the loud direction: a literal that itself holds a
variable -- `let elder_dir = "${home}/elder"`, where `home` reaches a real pen through two further
bindings -- read as a fixed tree path, and **ten amphora sites already doing the right thing were
counted as tree writes**. The resolution iterates now, bounded at four hops, and the control plants
that exact shape.
