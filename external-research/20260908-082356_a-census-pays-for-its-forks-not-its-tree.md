# A census pays for its forks, not for its tree

**Stamp:** `20260908.082356`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed in part, proposed in part -- **mixed room**: the measurements below are checkable and reproducible by the commands they name, and the incremental-census design in the last section is vision until a witness binds it ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Room:** mixed
**Kin:** [`20260908-065034_the-receipt-that-was-earned-and-the-map-that-cannot-spend-it.md`](20260908-065034_the-receipt-that-was-earned-and-the-map-that-cannot-spend-it.md) -- [`../foundations/20260826-021732_air-the-row-that-feels.md`](../foundations/20260826-021732_air-the-row-that-feels.md)

## What this asks

The roster's cheaper pass, `--scoped`, works by knowing which files each guard watches. Eight guards
on this pier can never be watched that way: their scan reads `git ls-files` with no pathspec, so the
whole tracked index is the population and no watch-set could be right. My own lap on `20260908.065034`
named them DISCOVERY and put a number beside them -- `discovery_cost_s=59` unclaimable against
`absent_cost_s=1136` still winnable by mapping.

That reading carried an assumption I did not test, and it is the assumption in the word *unclaimable*:
that a guard reading the whole tree costs what reading the whole tree costs. This paper tests it on
the costliest of the eight and finds it false by more than two orders of magnitude.

## Observation: the tree read is not the cost

Measured `20260908.074500` on this pier, `grain-diffuser`, 16,447 tracked files, with two peer roster
passes running concurrently. Absolute figures therefore carry contention; every ratio below is taken
between two commands run minutes apart under the same load, which is what makes the ratios the
robust reading and the absolute times the soft one.

The eight DISCOVERY scans, each run directly as `sh <scan>`, wall milliseconds:

| Guard | ms | Guard | ms |
|---|---|---|---|
| `dated_path` | 63,107 | `phantom_path` | 5,187 |
| `borrowed_number` | 10,555 | `tracked_link` | 4,257 |
| `witness_own_build` | 1,466 | `exec_bit` | 1,287 |
| `log_file_claim` | 411 | `empty_document` | 198 |

One guard holds 73% of the family's 86,468 ms. So `dated_path` is where the question lives, and I
bisected it by inserting timestamp probes at eight statement boundaries in a copy under `/tmp`:

- Reading the tracked index -- `git ls-files`, 16,447 paths: **11 ms** (median of three).
- The dominant content read -- one `grep -rIoE` over the working tree across eight file extensions,
  producing 29,440 reference pairs: **267 ms**.
- Lines 274 to 283 of `tools/fixtures/d/dated_path_scan.sh`: **68,370 ms of a 74,838 ms run, 91.4%**.

The tree read is 0.36% of that run. Inside the 91.4%, the filter loop over 211 fixture basenames
takes 4,036 ms, which leaves roughly 64,300 ms in one function call:
`dp_discovered_fixture_basenames`. Its first statement was

```sh
git ls-files | while IFS= read -r _f; do basename "$_f"; done | sed -n 's/.../p' | sort -u
```

-- one `basename` process per tracked file, 16,447 processes.

## Inference: the cost was process spawning, and it is provably removable

`sed 's|.*/||'` answers the same question in one process. The two forms agree on every path
`git ls-files` can emit, since it prints no trailing slash and no bare `/`, which are the only inputs
where `basename` and that substitution part. Measured on this tree, both emit **8,629 sprigs,
byte-identical by `diff`**:

| Form | ms |
|---|---|
| `basename` per file | 61,714 |
| one `sed` | 64 |

Landed `20260908.075500`. The honest test of a repair like this is the whole guard on one tree state,
so I stashed the change, ran the scan, restored it, and ran again: **75,153 ms to 15,070 ms, and the
scan's twenty output lines byte-identical.** A five-fold speedup on the costliest census in a 1,630 s
roster pass, and 60.1 s returned to every round that runs it.

**This lantern had already been lit twice in the same family.** `tools/fixtures/e/empty_document_scan.sh`
carries a comment naming this exact shape as a fault it had paid for -- *"the first shape spawned 8,486
of them and took 33 seconds, and a guard nobody waits for is a guard nobody runs"* -- and
`tools/fixtures/e/exec_bit_scan.sh` carries its own. Both repairs were made; neither reached the third
site, because a comment repairs the file it sits in.

**So I swept for the shape rather than trusting that it was gone.** A grep across `tools/` for a
`basename` or `dirname` call standing alone inside a loop body finds exactly three sites: the one
repaired here, `tools/fixtures/s/setu6_find_gadget_iface.sh` at a handful of interfaces, and
`tools/fixtures/r/reds_pin_capacity_scan.sh` line 178, which loops over an archive glob of a few
hundred entries. **This lever is now spent**, and saying so is worth more than implying that more
wins wait. Confidence: high, since the sweep is one reproducible grep over the whole room.

## The general claim, and what would kill it

**Claim:** a whole-tree census's wall time is dominated by what it does per item rather than by
reading the tree, so the DISCOVERY family's 1,195 lap-seconds are reachable by work that has nothing
to do with mapping.

**Bound:** this is measured on one guard, on one pier, on one day. I bisected `dated_path` alone. The
other seven splits are unmeasured, and three of them already run under 1.5 s, so their absolute
headroom is small whatever their split turns out to be.

**Falsifier:** run the same probe bisect on `borrowed_number` (10,555 ms) and `phantom_path`
(5,187 ms), the two remaining guards with real headroom. If the whole-tree content read is over half
the wall time in both, the claim is false as a family statement and survives only as a fact about
`dated_path`.

**Horizon:** one lap. **Confidence:** moderate. The claim is proven for the guard that holds 73% of
the family's time, and untested for the rest.

## Projection: what an incremental census would need

The second lever is the one the card asked me for -- a census that costs the diff rather than the
tree. It is worth stating precisely, because the intuition that a census must be a sum to be
incremental is wrong, and the real condition is sharper.

A census is a function over the tracked tree. It admits a diff-sized update when there is a stored
summary from which the new answer is computable given only the changed paths. The eight guards fall
into four shapes, and the shapes differ in how large that summary has to be:

- **Per-file predicate.** `exec_bit` asks whether each file's mode agrees with its index entry. A
  changed file changes only its own contribution, so the summary is the count alone.
- **Fold with an inverse.** A sum of per-file character counts updates in both directions, because
  subtraction exists. The summary is again one number.
- **Fold without an inverse.** A maximum updates cheaply when a file arrives and needs the whole
  population back when the holder leaves. The summary must carry per-file contributions.
- **Cross-reference closure.** `dated_path`, `tracked_link`, and `phantom_path` ask whether every path
  a file names exists. Editing a file changes only its own claims, which is diff-sized. **Deleting**
  one invalidates claims in files nobody touched, so the summary must carry an inverted index from
  path to citing files. On this tree that index holds 29,440 references.

So the condition is not that the census sums. **It is whether the census stores enough to answer what
a deletion breaks**, and for the reference sweeps that store is an inverted index roughly the size of
the reference set -- bounded, nameable, and paid once.

**The hazard that makes this research rather than a plan:** an incremental census can be wrong in a
way a full census cannot, because its answer rests on state nobody re-derived. Any design must
therefore carry its own falsifier -- a periodic full re-derivation compared against the incremental
state, with a mismatch booked as a red rather than smoothed over. That is the receipt-and-basis
pattern the roster already runs at the level of a whole pass, applied one level down at the level of
a single reading.

**Falsifier for the moonshot itself:** build the inverted index for `dated_path` and measure the
update cost against a real day's diff. If a median lap's diff touches enough files that the update
costs more than the 15,070 ms the repaired full scan now takes, incrementality is not worth its state
for this guard. **Horizon:** one round. **Confidence:** low. The repair above moved the full scan far
enough down that it may already sit under the incremental version's own floor, which would be a good
outcome honestly reported and a poor moonshot.

## For BAKERY, plainly

**Buildable now, no word needed:** `tools/fixtures/r/reds_pin_capacity_scan.sh` line 178 carries the
same fork-per-item shape over a few hundred archive entries. Small, and correct to fix on touch.

**Buildable, and it wants a word first:** `dated_path` stands at `tier cadence` in
`construction/standing-equipment.kyri`, which is why its ceiling breach today went unheard by every
lap-tier pass. At 15 s it is now affordable every lap. Moving it wants the gate question below
settled first, since a guard that reds every lap over a number no lap may lower is a guard someone
turns off.

**Not buildable -- it is Keaton's:** the scan's own comment proposes moving its gate from `refs_lost`
to `lost_promised_living`, and waits on his word. Today that matters concretely, which the next
section records.

## What I found while measuring, and did not fix

`dated_path` reds at HEAD, and it is not mine: I proved it by injecting only the reading-identical
fast function into an otherwise clean tree and reading the same answer. It reports `refs_lost=100`
against `LOST_CEILING=85`, a ceiling lowered to exactly the count standing on `20260907.104201` with
no slack.

The counted 100 split as **95 testimony and 5 living**, and the class a lap may lawfully repair --
a broken promise inside a file a lap may edit -- reads **`lost_promised_living=0`**. Nearly every
citer is a dated session log or a folded shelf, which accrete-never-break forbids anyone to repair.

So the gate sits on a number that rises whenever a ship writes a log naming a path, and falls for
nobody. It will red again tomorrow whatever any lap does. That is the shape of the red, and the
repair is the gate move the scan already proposes and already defers to his word -- because a gate a
lap moves for itself is a ceiling raised by a side door.

## What this does not reach

Whether the other seven DISCOVERY guards split the way `dated_path` does. Whether any census in this
tree is worth its stored index. And whether the mapping lever my elder paper measured is still the
larger prize -- it may well be, and this paper narrows rather than replaces it.
