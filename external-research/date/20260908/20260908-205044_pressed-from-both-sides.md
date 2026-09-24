# Pressed From Both Sides -- the control half measured, and the horizon that pays for it

**Stamp:** `20260908.205044`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Room:** mixed -- every table below is reproduced by the commands printed beside it; the cache it argues for is vision, and no witness binds it
**Kin:** [`20260908-191119_the-half-that-reads-nothing.md`](20260908-191119_the-half-that-reads-nothing.md) -- [`20260908-125418_the-roster-is-half-the-pier.md`](20260908-125418_the-roster-is-half-the-pier.md) -- [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)

The study before this one left one sentence carrying the whole proposal, and marked it unmeasured:
**that a guard's control half is a pure function of the guard's own source.** If that holds, a
control's verdict is cacheable by content and shareable between ships. If it fails, the cache is a
wish. This page presses on that sentence until it either stands or gives, and then asks the second
question a cache always owes -- over what horizon does the key stay warm?

The air row's own test is the one used here: **you check whether a part stands free by trying to
pull it out.** So the control halves were pulled out of this tree and run somewhere else.

## The instrument

**Observation.** `git worktree add --detach .lap/elder HEAD~400` builds a second checkout of this
same repository at commit `d6acba58d`, stamped `20260905.191905` -- three days and 400 commits
behind HEAD. The two trees share a control's source wherever that file is byte-identical between
the commits, and differ in nearly everything else.

Each control was then run twice, once with the working directory in each tree, and the two outputs
compared by digest:

```sh
a=$( sh "$f" 2>&1 | md5sum )
b=$( cd .lap/elder && sh "$f" 2>&1 | md5sum )
```

**The candidate set was chosen to make a leak visible rather than to flatter the result.** A
control qualified when its own source AND its guard's scan source were byte-identical across the
two commits, and when that scan reads the tree through `git ls-files` -- so any dependence on tree
content had a live channel to travel down. Twenty-three of 207 controls met all three conditions.

## What the controls did

**Observation.** Twenty-three of twenty-three produced byte-identical output in both trees.

| Reading | Count |
|---|---|
| Controls run in both trees | 23 |
| Byte-identical output | **23** |
| Output differing | **0** |

**And the instrument proves it can see a difference**, which is the leg that makes the row above
worth reading. Three scan halves were run through the same harness, on the same two trees, on the
same afternoon:

| Reading | head | elder | verdict |
|---|---|---|---|
| `exec_bit_scan.sh` | `fbd0fda25ddc` | `1e00e8a72af0` | **differs** |
| `room_bound_scan.sh` | `c1c488c82217` | `96cacfc413e2` | **differs** |
| `banner_room_scan.sh` | `58b3ac31bd51` | `0161f6cdeccf` | **differs** |

Three of three differ. Same comparison, same trees, same shell -- so `23 of 23 same` is a reading
about the controls rather than about a harness that compares nothing. A refusal proven only in the
passing direction cannot be told from a bypass, and that holds for a measurement as much as for a
guard.

## Why they behave that way, read from the source

**Observation.** The idiom is nearly universal and it is visible without running anything. Of 206
control scripts read at `20260908.204406`, **194 build a throwaway pen** -- `mktemp -d`, or a
named directory under `TMPDIR` where POSIX purity forbids `mktemp` -- plant their cases inside it,
`cd` into it, and invoke the guard's scan by an absolute path resolved before the move:

```sh
root="$(pwd)"; work="$(mktemp -d)"; cd "$work"
out=$(sh "$root/tools/fixtures/b/banner_room_scan.sh")
```

**Inference.** The scan's working directory during that call is the pen. So the control's whole
input is its own source, the scan's source, and the shell and git binaries -- the tree beyond them
is not on any path the scan can walk.

**The twelve exceptions were read one at a time**, since a rule with an unread remainder is a rule
about the part somebody looked at:

| Shape | Count | What it reads |
|---|---|---|
| Pen built by the caller | 8 | a `build_dir` handed in by the witness, plus a handful of named module sources copied into it |
| Heredoc input, no directory at all | 1 | its own text |
| Reads a real peer tree and a real enclosure | 1 | genuinely tree-dependent, and environment-dependent besides |
| Copies a module and builds it | 2 | the named module sources, nothing wider |

**Inference.** Eleven of the twelve still take a small, nameable input set -- module sources rather
than the tree. **One is a true exception:** `tools/fixtures/c/captain_view_control.sh` enters a
sandbox and reaches into a peer checkout on purpose, because what it proves is a denial across
trees. A cache keyed on source content must exclude it by name rather than by rule, and the honest
way to exclude it is a declared field on the roster rather than a guess in a scanner.

## The second question: how long a key stays warm

A content key is worth its machinery only if the content holds still long enough to be hit twice.
This fleet writes guards quickly, so the horizon matters more than the mechanism.

**Observation**, read `20260908.205044` by `git diff --name-only HEAD~N HEAD -- 'tools/fixtures/*/*_control.sh' | wc -l`:

| Horizon | Wall time it spans | Controls changed or added, of 207 | Unchanged share |
|---|---|---|---|
| 25 commits | ~2.3 hours | 8 | **96%** |
| 50 commits | ~5.2 hours | 12 | 94% |
| 100 commits | ~13 hours | 27 | 87% |
| 200 commits | ~1.3 days | 65 | 69% |
| 400 commits | ~3 days | 119 | 43% |
| 800 commits | ~12 days | 207 | **0%** |

**Inference, and it reverses the obvious design.** A cache that remembers a control's verdict for a
week buys almost nothing, because in twelve days every control in the tree has moved. A cache
that remembers for one lap buys nearly everything: **at a lap's own horizon, 96% of controls are
the same bytes they were.**

**And the width pays better than the depth.** The prior study read the control halves across all
eight checkouts at one instant and found **199 of 205 byte-identical**, with the six that differed
last committed inside the previous ninety minutes. So the fleet at one moment agrees on 97% of its
control sources, while the fleet across three days agrees on 43% of them. **The prize is eight ships
proving the same thing at the same time, rather than one ship remembering what it proved last
week.**

## What follows

**Projection.** A pier-local store keyed on `sha256(control source, scan source, the module sources
it copies)` returns a control's verdict without running it, and returns it to whichever ship asks
first. Eight ships open a cold pass within the same hour; the first pays, and seven read.

**Horizon:** one chapter. **Assumptions:** that the roster can carry a per-guard input list, which
is a field rather than a mechanism; that a verdict cached under a digest is acceptable custody on
one pier, which is Keaton's word rather than mine; and that `captain_view` and any future
tree-reading control declare themselves rather than being detected. **Falsifier:** cache the 23
guards measured above, keyed on source digest, and run a cold pass on two ships within one hour; if
the second ship's pass does not fall by roughly the control share of those guards, the split is not
where the cost lives. **Confidence:** high that the control half is pure, since it was measured
both ways on real trees; moderate on the saving, which rests on the three timings in the prior study
rather than on a fleet-wide split.

**What this does not reach.** Whether the SCAN half can be cached, which is the larger half and the
harder key -- the scans differ across trees by design, and that is the whole of their job. Whether
a cached verdict is a verdict at all, which is a custody question rather than an engineering one: a
guard that reports without running has told you about a digest, and somebody has to decide that is
enough. And the six controls whose sources differed across the fleet, which are the live edge and
the population a cache would miss exactly when the tree is changing fastest.

## For the modules

**Tablecloth** already holds this object. A verdict keyed by the digest of its inputs is a blob
keyed by its content, one level up, and the store's existing shape answers the lookup unchanged.

**Tally** owns the bound. A cache is an allocation with a lifetime, and the horizon table above
gives it a real number rather than a guess: past roughly a day the entries are dead weight, so the
eviction rule can be stated before the store is built rather than after.

**Caravan** would supervise the eviction as a dependent, and the price list in the roster study says
what that dependent costs before it does any work.

**Aurora and Mantra** are named honestly as untouched. Nothing here measured either.

---

**What holds these figures still: nothing.** The fleet commits every few minutes and the control
population grew by one during the pull that opened this lap. Run the commands printed beside each
table; the stamp says when somebody looked, and never that the reading still stands.
