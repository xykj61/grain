# The orphan that had already landed under another name

**Stamp:** `20260911.230630`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room** ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)):
every count below is read by [`../tools/fixtures/s/stash_record_scan.sh`](../tools/fixtures/s/stash_record_scan.sh)
and gated by [`../tools/s/stash_record_witness.rish`](../tools/s/stash_record_witness.rish)
**Room:** checkable
**Kin:** [`../tools/fixtures/s/stash_record_control.sh`](../tools/fixtures/s/stash_record_control.sh) -
[`../tools/f/fleet_round_open.sh`](../tools/f/fleet_round_open.sh) -
[`../external-research/20260906-175851_the-hop-you-can-compute.md`](../external-research/20260906-175851_the-hop-you-can-compute.md) -
`construction/REDS.md` rows `%464`, `%510`, `%592`, `%505`

---

## The reading, in one paragraph

The round open parks what a stopped lap left in a stash, and `stash_record_scan.sh` sorts what it finds
into three drawers: `moved` for a path a uniquely-named living file answers for, `shelf` for a
fold's output, and `work` for everything else. Its header calls `work` **the only one worth a
lap**. Measured on this tree `20260911.225140`: `orphans_work=3`, and all three were
`tools/fixtures/t/topology_routed_{scan,control}.sh` and `tools/t/topology_routed_witness.rish` --
the draft name of an instrument that landed on `20260907` as `topology_stretch_*`. **Three of
three were landed work wearing a draft name.** A fourth reading now names that class, and the
drawer a hand acts on reads **zero**.

## Why neither standing probe could see it

The scan's own header names both probes and, in the same breath, names the shape between them:

> **THE BLOB PROBE WAS TRIED FIRST AND FOUND NOTHING** [...] it matched zero of the nineteen,
> because a file that moves rooms in this tree is also edited on the way.

> An orphan can be honest. **A file landed under a different NAME reads as an orphan**, and so does
> an experiment a hand deliberately abandoned.

Both sentences are true and neither is actionable. A rename defeats the basename probe **by
definition** -- the names differ, that is what a rename is -- and it defeats the blob probe for the
reason the header already gives, since a file renamed on the way to landing is also edited. The
class was described in prose for three days and counted as noise in the one column a reader was
told to act on.

## The reading that answers it, and the one step that makes it work

**Ask the orphan's own lines of a candidate, never the other way.** For each sibling in the
orphan's own room: what share of this orphan's non-blank lines does that file carry? The question
is asymmetric, and the asymmetry is the whole instrument. *What does A hold that B does not*
answers supersession; a diff size, a shared subject, or a shared elder reads the same from either
end and cannot tell a rewrite from a fork.

This tree already holds that sentence. It is quoted from the paper whose instrument these three
orphans **are** -- written on `20260907` after two careful laps had refused this same set on
symmetric evidence:

> *To ask whether B supersedes A, measure what A holds that B does not.* That reading is asymmetric
> by construction, so it answers the asymmetric question.

**And the name is mapped before the reading is taken.** A guard says its own name in every `say`
line and every assert message, so the loudest textual difference between a draft and its landing is
the name itself. Measured on the three, `20260911.230000`:

| Orphan | Raw share | Mapped share | Unheld |
|---|---|---|---|
| `topology_routed_scan.sh` | 99% | **100%** | 0 |
| `topology_routed_control.sh` | 97% | **100%** | 0 |
| `topology_routed_witness.rish` | **42%** | **100%** | 0 |

Every one of the witness's forty-five unheld lines differed only in the word `routed` where the
landing writes `stretch`. **A floor set anywhere above 42 misses the file that most needed the
answer** -- so an unmapped reading would have shipped a class that skips its own hardest case.

The mapping is narrow by construction: the full basename stem in both separator spellings, plus the
single differing token carried by its own left neighbour. The neighbour is load-bearing. Mapping a
bare `routed` would rewrite `routed_mean` into `stretch_mean` and **lower** the share, since the
landed file keeps that reading's own name.

## What bounds the claim

Four gates, because a triage column that guesses is worse than the count it replaced -- the
sentence the `moved` class already stands on.

- **Same room.** Candidates are the tracked files of the orphan's own directory. A rename that also
  changed rooms is a `moved` question, or nobody's.
- **One rename apart.** The two stems carry the same `_` token count and differ in exactly one
  position. This is the sibling filter and it runs before one file is opened.
- **A floor** of 90 percent on the mapped share.
- **Dominance**: at least four times the runner-up. On the three standing here the separation is 100
  against 21, 13 and 6.

A share between 50 and the floor is counted as `orphans_renamed_near` and **stays in the work
drawer**, since the safe direction for an unproven claim is the drawer a hand already reads. The
near count prints at zero too: a reach nobody prints is claimed by implication (`%505`).

**One looseness, named with its size.** A stem carrying no `_` at all -- `fleet-fly-bare` -- is one
token, so every other one-token stem in its room counts as one rename apart and the filter
degenerates to the room. Measured `20260911.231405` over this tree's tracked files, the largest
such rooms are `construction/archive` at 462, `glow/gen/g` at 140 and `caravan` at 106. The first
can never arrive here, since `shelf` is decided before this reading runs and that room is what the
shelf class names; the rest are held by the candidate bound, and `rename_reads` prints what was
opened. The floor and the dominance test are what keep a wide candidate set from becoming a wide
claim: 64 unrelated siblings answer with a best share in the teens, which reaches neither.

The row names the path and the remainder -- `orphan:renamed:<path>:unheld=N`. The class is not a
verdict that the bytes are disposable. It says a named living file carries all but N of these
lines, and a reader checks it in one `diff`.

## Two faults this instrument's own pen caught before it shipped

**A looser sibling filter decided an answer by sort order.** Admitting any file sharing a leading
**or** a trailing token pulls in every `*_witness.rish` in `tools/t/` -- 106 files -- so the
per-orphan read bound of 64 cut the walk off alphabetically **before it reached
`topology_stretch_witness`**, and the one orphan whose answer was 100 percent read `work`. The
bound was doing the deciding, silently, and the answer it gave was the old wrong one.

**And a `grep -E` pattern spelling a tab read zero work rows while one stood in its own output.**
POSIX ERE has no `\t`, so `grep -cE '\twork'` looks for a literal `t`. The partition check --
`orphan_kinds=partition`, an invariant this scan has asserted since it was written -- is what
caught it, one lap after that check was called insurance. The kinds are counted by field in one
`awk` now.

## The cost, measured

| Reading | Before | After |
|---|---|---|
| Round open, mean of three runs | 2,416ms | **2,884ms** |
| Processes added per orphan | -- | 3 (list, filter, reading) |
| Sibling files opened, this tree | -- | 27 |
| `orphans_work` | 3 | **0** |

**+468ms, +19 percent**, and the drawer a hand is told to act on goes from three rows of noise to
one clear column. Two shapes were tried and rejected on this number, which is why it is quoted three ways: a
process per candidate held the open at 4,720ms, and an `awk` per candidate for the sibling question
alone held it at 4,700ms. The scan's own header already sustains exactly this objection against a
per-orphan classifier -- *three small processes per orphan beat one larger one only in intuition* --
and that sentence is now proven twice in one file.

## Coverage gaps and the falsifier

**Horizon.** This describes the box of one checkout on `20260911`: 18 stashes, 90
paths, 8 orphans. Nothing here projects to another ship's box, and the header says so -- an orphan
count is a per-checkout, per-hour fact, which is why it reports and never gates.

**Assumptions.** That a rename keeps the file in its room; that it moves one `_` token; that line
membership is a fair proxy for sameness; and that the orphan's own lines are the right numerator.

**Falsifiers, in the order I would try them.**

1. **A renamed landing this class misses.** Park a file whose rename changed its token count, or
   crossed rooms, and the reading answers `work` -- correct by its own bounds, and the bound is the
   claim. If the misses outnumber the catches on any ship's box, the sibling filter is too narrow
   and the answer is a second, wider pass rather than a looser first one.
2. **A false claim.** A sibling reaching 90 percent and four times the runner-up while genuinely
   holding different work would name a living path that does not carry the orphan. `unheld` is the
   check: it names how many lines the claim leaves behind, and `unheld=0` is not a promise that the
   two files mean the same thing.
3. **The cost on a fuller box.** 27 sibling reads is this box. A box whose work drawer holds fifty
   orphans in crowded rooms would pay the per-run bound of 512 reads, and the honest answer then is
   to run the class in `list` mode alone rather than at every open.

**Confidence, in plain words.** *High* that the three orphans standing here are the landed
`topology_stretch` instrument -- `unheld=0` on all three, mapped, with the runner-up four to seven
times behind. *High* that the timing figures are what this bench does. *Moderate* that the four
bounds are the right four; they are the `moved` class's own bounds carried over one reading, and
only a second ship's box will say whether they fit a box nobody tuned them on.

## The fleet's whole drawer, measured

The count is per checkout, so the fleet needs each tree asked in turn -- and each answer costs one
command. Measured `20260911.231405`, read-only, from each checkout's own scan:

| Ship | Stashes | Orphans | `work` |
|---|---|---|---|
| `grain-diffuser` (this tree) | 18 | 8 | **3 -> 0** |
| `grain-incense` | 9 | 5 | **2** |
| `grain-petrichor` | 23 | 11 | 0 |
| `grain-copal` | 21 | 12 | 0 |

**The fleet's entire actionable drawer was five files, and three of the five were landed work.**
The two standing on `grain-incense` are `tools/fixtures/t/two_rooms_doorway_reach.sh` and
`tools/l/fleet-fly-bare.sh`. The first is one token from six tracked siblings in its own room, so
this reading has something to say about it; the second carries a one-token stem, which is the
looseness named above. Neither is judged here -- that tree answers to its own writer (`%291`).

## What this hands the fleet

**A drawer a hand can trust.** `orphans_work` is the number the round open prints and the only one
the scan calls worth a lap. It read three for three days, and every one of the three was already
in the tree.

**And one sentence worth carrying past this file.** A guard that names a class in its prose and
counts it in no column has not named it. Both sentences quoted at the top of this paper were
written by hands who understood the fault exactly; what was missing was a reading, and the reading
cost 468 milliseconds.

---

*May the next lap's leavings be read for what they hold rather than for what they are called.*
