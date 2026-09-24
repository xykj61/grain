# What a guard is a function of, and why a path map cannot see it

**Stamp:** `20260908.191119`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Room:** research for understanding -- every measurement below names the command that
reproduces it, and the keying proposal in the last section is vision until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Status:** Proposed
**Kin:** [`20260908-125418_the-roster-is-half-the-pier.md`](20260908-125418_the-roster-is-half-the-pier.md)
(the cost half, landed on this same lap out of a stash -- it prices the roster and names the
lever this paper measures) --
[`20260908-065034_the-receipt-that-was-earned-and-the-map-that-cannot-spend-it.md`](20260908-065034_the-receipt-that-was-earned-and-the-map-that-cannot-spend-it.md) --
[`../active-designing/20260825-173153_reprove-only-what-moved.md`](../active-designing/20260825-173153_reprove-only-what-moved.md)
(the design being measured) --
[`../foundations/20260823-222019_what-brix-infuse-is.md`](../foundations/20260823-222019_what-brix-infuse-is.md)
and [`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)
(the Water row's cardinal and fixed seats, read on this lap's rota)

---

## Bounds, before any number

Every figure below was read on the Dallas pier -- an AMD EPYC-Rome guest, 8 vCPU, `host=linux`,
`TZ America/New_York` -- on `20260908` between `18:47` and `19:11`, on the `grain-diffuser`
checkout at git nib `b3dc4b95a6`. The load average across the window ran **10.6 to 15.0 on 8
cores**, with seven peer ships sailing and one of my own roster passes running throughout, so
every wall figure carries contention and my own measuring added to it. Sources: the tracked
roster `construction/standing-equipment.kyri`; the untracked per-ship ledgers
`construction/standing-equipment-hitrate.kyri` on all eight checkouts, read read-only;
`sh tools/fixtures/s/standing_equipment_scope_rank.sh`; one cold pass transcript of my own; and
direct timed runs of nine scan and control fixtures. Units are wall seconds unless the word
`cpu` appears.

## What the scoped pass cannot reach, in the tree's own numbers

**Observation.** `sh tools/fixtures/s/standing_equipment_scope_rank.sh`, read `20260908.185500`:

| Reading | Value |
|---|---|
| Rostered guards | 262 |
| Mapped to watched paths (`static`) | 58 |
| Discovery-mapped | 8 |
| **Unmapped** | **196** |
| Lap cost of guards with a known cost | 1,698 s over 197 guards |
| **Share of that cost held by unmapped guards** | **85.0%** |
| Seconds the existing map already saves | 185 s (10.9%) |

**Observation.** The unmapped guards are the expensive ones. The scan's own
`rank_unmapped` list opens `readme_metrics` 59 s, `lantern_face` 52 s, `shared_pen` 51 s,
`declared_ceiling` 51 s, `tame_style_app_sites` 45 s -- and 140 more it reports as a count.

**Inference.** A path map is the wrong key for these guards rather than a map somebody forgot to
fill in. A guard whose scan reads `git ls-files` with no pathspec takes the whole tracked tree as its
input, so an honest map row for it would list everything and skip everything else. The map is
full; the key is simply the wrong shape.

## The purity census: a guard asked twice

**Observation.** The Water row's cardinal seat states the tree's claim about change --
`infusion(world') -> world'` -- and `tools/c/convergence_census.sh` measures it for tools that
**write**. Nothing measures it for tools that **read**, and a verdict may only be cached if the
reading is stable. So I ran ten of the heaviest unmapped scans twice each, back to back, on an
unchanged tree, and compared output bytes:

| Scan (heaviest unmapped guards) | second run | output bytes |
|---|---|---|
| `readme_metrics_scan.sh` | identical | 62 |
| `shared_pen_scan.sh` | identical | 121 |
| `declared_ceiling_scan.sh` | identical | 533 |
| `borrowed_number_scan.sh` | identical | 223 |
| `topology_relaxed_scan.sh` | identical | 6,807 |
| `crushed_index_scan.sh` | identical | 222 |
| `unshared_citation_scan.sh` | identical | 53 |
| `topology_stretch_scan.sh` | identical | 2,194 |
| `glow_desk_reach_scan.sh` | identical | 426 |
| `living_card_ascii_scan.sh` | identical | 721 |

**Ten of ten.** No scan's answer moved between two runs on an unchanged tree.

**Against myself, and it is the same shape as the fault my elder lap booked.** My first reading of
the tenth pair said `DIFFERS`, and it was wrong: I compared the second output file while the
background job was still writing it, so I read a truncated tail as an unstable answer. Re-run three
times by hand it is 721 bytes with one `verdict=` line every time, and the job's own comparison
agreed. **A measurement taken against state that is still moving reports on the reading rather than
on the subject** -- which is what a peer's glob over a shared pen did earlier today, one room over.


**Inference.** Stability is the precondition for caching a verdict, and on this sample it holds. That is
evidence rather than proof: ten of roughly 196 unmapped guards, two runs each, one machine, one
tree state. What it settles is the cheapest objection -- the worry that these scans read a clock, a process
table or a remote, which would put a cached verdict out of reach. All ten read tracked content or
the repository's own history, both of which a digest can name: `shared_pen_scan`, for instance,
greps tracked sources for `/tmp` path literals, and `borrowed_number_scan` reads a window of git
log. Each has a definable key.

## A guard is two computations wearing one name

**Observation.** A standing witness in this tree does two things. It runs a **scan** over this
tree's content, and it runs a **control** that builds a real repository in a throwaway pen,
plants a wrong shape, and proves the guard bites it -- the mirrored pair the happy-zone
foundation calls house law. **The control's input is the guard's own source and the pen it
builds, never this tree's content.** Checked for the three timed below: none contains a
`git ls-files`, and `crushed_index_control.sh` says so in its own head -- it runs the scan
*inside pens it makes* and reads its lines back.

**Observation.** Timed separately, one run each, `TIMEFORMAT='%R %U %S'`:

| Guard | scan wall | control wall | control share |
|---|---|---|---|
| `declared_ceiling` | 39.3 s | 27.8 s | **41%** |
| `unshared_citation` | 45.6 s | 0.8 s | 1.7% |
| `crushed_index` | 7.0 s | 50.5 s | **88%** |

Three guards, one run each, under contention: read these as three points rather than as a mean.
Two of the three sums exceed what the roster recorded for the whole guard on my own cold pass
(`declared_ceiling` 45 s, `crushed_index` 28 s), which says the witness shares work between the
two fixtures, or that the pier was quieter then. **The spread is the finding**: the
control half runs from 2% to 88% of a guard's cost, so it is neither negligible nor uniform, and
nothing in the roster records which.

## The control half is the same bytes on eight ships

**Observation.** The pier carries eight checkouts. Of the **205** `tools/fixtures/*/*_control.sh`
files in mine, **199 are byte-identical across all eight**, read `20260908.190500` by
`sha256sum` in each tree. Six differ:

```
fleet_drain_control.sh  glow_literal_law_control.sh  mantra_weave_merge_control.sh
qa_report_card_control.sh  rune_assert_control.sh  two_rooms_doorway_control.sh
```

**Observation.** Five of those six were last committed today between `17:13` and `18:44`, and
the sixth yesterday at `21:59` (`git log -1 --date=format:%Y%m%d.%H%M%S -- <path>`).

**Inference.** The differing set is exactly the fleet's live edge, and the identical set is
everything else. So **97% of this fleet's self-test surface is one computation, performed
independently on eight checkouts**, dozens of times a day.

**Observation, for contrast, and it is the point rather than a second version of the first.** The
scan fixtures are just as identical -- **276 of 281** across the eight. That is unremarkable, since
all eight are checkouts of one repository. What differs is the **input**: a control's whole input is
its own source, which is fleet-identical; a scan's input is the tracked tree. Of my checkout's
**16,666** tracked files, the widest pair of ship HEADs I hold locally differs in **72**, and the
next widest in **69** -- **0.43% and 0.41%**. The eight ships stood on five distinct HEADs when I
looked (`20260908.185500`), and my clone holds three of the five.

**Against myself again.** Those two absent commits were honestly excluded only after a second look:
`git diff` against a revision the clone does not hold exits non-zero, my first pass piped that
refusal to `/dev/null`, and `wc -l` read the empty result as **zero files differ** -- the most
flattering answer available. `git cat-file -e` on each commit is what named them absent. **A refusal
sent to `/dev/null` returns as a fact**, and it returns wearing the shape the reader hoped for.

## Why the whole-tree key can never pay

**Observation.** Every ship writes an `open` row to
`construction/standing-equipment-hitrate.kyri` naming whether the tree digest at the open matched
the last fully green receipt. Read across all eight checkouts `20260908.185000`:

| Ship | opens recorded | opens today | **hits, ever** |
|---|---|---|---|
| bakery | 151 | 61 | 0 |
| copal | 119 | 31 | 0 |
| diffuser | 108 | 30 | 0 |
| grass | 121 | 29 | 0 |
| incense | 184 | 25 | 0 |
| patchouli | 91 | 29 | 0 |
| petrichor | 117 | 26 | 0 |
| pheromone | 105 | 26 | 0 |
| **fleet** | **996** | **257** | **0** |

**Inference.** A key over the whole tree digest asks whether a working checkout stood still, and
a working checkout never does. The mechanism works exactly as built; the granularity is answering the question it was given.

## What follows: two keys, neither of them the tree

**Projection.** Key each half of a guard on what it actually reads. The control half keys on the
guard's own source bytes plus the fixtures it invokes -- a digest of a handful of files. The scan
half keys on the digest of the content it read, which for a `git ls-files` scan is available free
from the index. Both keys are content, so both are shareable between laps **and between ships** -- the one
property a path map and a whole-tree digest each lack.

**Horizon:** one chapter, if the control half is taken first, since it is the smaller and safer
of the two. **Assumptions:** that a scan's verdict is a pure function of the bytes it reads
(measured above, ten of ten); that the control half is a pure function of the guard's own source
(argued from the pen, unmeasured); and that a shared store between checkouts on one pier is
acceptable custody, which is Keaton's word rather than mine. **Falsifier:** cache the control
half of the three guards timed above, keyed on source digest, and re-time a cold pass; if the
pass does not fall by roughly the control share those three showed, the split is not where the
cost lives. **Confidence:** moderate-high on the mechanism, unmeasured on the fleet-wide size,
since only three guards were split.

**One cheaper thing first, and it is not mine.** The parked study beside this one names it: have
the runner report its own `user` and `sys` in the receipt. Until a pass reports its own CPU, every
figure here and there is a wall second under contention, which is a measurement of the pier as
much as of the guard.

## For the modules

**Tablecloth** already holds the shape this wants -- a name that is a proof, computed once. A
guard verdict keyed by content is the same object as a blob keyed by its digest, one level up.

**Tally** bounds allocation; a verdict cache is an allocation with a lifetime, and its bound is
the one thing this proposal must name before it is built rather than after.

**Caravan** is the module that would run such a cache's eviction as a supervised dependent, and
the price list in the parked study says what that dependent costs before it does any work.

**Mantra and Aurora** are named honestly as unmeasured. Nothing here touched either.

---

**What holds these figures still: nothing.** The roster grows, the fleet commits, and the ledgers
advance every few minutes. Run the commands rather than reading the tables; the stamp says when
somebody looked, never that the reading still stands.
