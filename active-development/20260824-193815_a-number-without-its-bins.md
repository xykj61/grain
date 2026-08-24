# A number without its bins

**Language:** EN
**Stamp:** `20260824.193815`
**Style:** Gauge, **Field** setting
**Voice:** Kyri
**Room:** Round note -- the answer to a scoped measurement
**Scan:** [`../tools/fixtures/invariant_coverage_scan.sh`](../tools/fixtures/invariant_coverage_scan.sh)

## The verdict, first

**The seated invariant law runs at 79%, not 59.6%, and its gap is 4,757 asserts, not 13,235.** The
figure this tree has been carrying is **2.8 times** the real one. And the gap that remains is not
1,210 modules being uniformly careless: it is **a room property**, with three rooms where the law
was never applied at all and seven where it was applied thoroughly.

## What the reported number was counting

TAME asks that an assert carry a `// invariant:` line naming the reason. The comment-dial round of
`20260824.170904` counted that carefully -- walking up from each assert through the comment block
above it, rather than dividing two line counts -- and reported **13,235 asserts with no stated
reason**. The method was right and the population was never questioned. Two things were folded into
one number:

**Three promises, one denominator.** Not every assert is a contract, and the law reaches them
differently:

| Bin | Asserts | With a reason | What the law asks |
|---|---:|---:|---|
| **contract** -- inside an ordinary function | **22,816** | **18,059** | a reason above the call |
| **selftest** -- inside `main` or a `selftest` function | 4,301 | 357 | the test's own name is the reason |
| **witness** -- inside a `*_witness.rye` file | 2,568 | 0 | the witness header is the reason |

Only the first row is what the seated law is about. The three sum exactly to the old figure:
`4,757 + 3,944 + 2,568 = 13,235`, so nothing was miscounted -- three different promises were
added together.

**And 211 symlinks were counted as modules.** Zig refuses an import that escapes the root file's
directory, so a module several rooms need is symlinked into each. `image/photos.rye` is the file;
`pond/apps/photos.rye` and `brushstroke/photos.rye` are links to it. Counting the links tripled that
file's 185-assert gap to 555. **11% of the 1,891 "modules" were links**, and three identical rows in
the worst-ten table are what showed it -- a symlink looks like a coincidence to a counter.

## The shape, which is the useful part

**4,757 asserts across 570 modules, and half of it sits in 50 files.**

| Reading | Value |
|---|---|
| Modules carrying a contract assert | 1,210 |
| Fully covered | **640** |
| Carrying a gap | 570 |
| **Median gap per module** | **3** |
| Gap in the worst 10 modules | 1,155 (**24%**) |
| Gap in the worst 50 modules | 2,329 (**48%**) |
| Worst single module | 312 (`pond/apps/drawn_terminal.rye`) |

A median of three with a tail reaching 312 is not a tree of careless files. It is a tree where most
files got the law right and a few never met it.

## Coverage is a room property

This is the reading that decides what a remedy looks like.

| Coverage | Room | Covered of contract |
|---:|---|---|
| **98.2%** | constel | 334 of 340 |
| **96.3%** | lotus | 1,239 of 1,286 |
| **93.3%** | mikrophone | 97 of 104 |
| **92.8%** | caravan | 8,685 of 9,360 |
| **92.3%** | image | 4,001 of 4,333 |
| **91.3%** | mycelium | 742 of 813 |
| **87.6%** | brushstroke | 624 of 712 |
| 58.8% | crypto | 400 of 680 |
| 44.8% | pond | 1,475 of 3,295 |
| 34.7% | linengrow | 172 of 495 |
| **11.0%** | mantra | 12 of 109 |
| **3.4%** | glow | 7 of 205 |
| **0.0%** | lattice | 0 of 199 |

**Seven rooms sit above 87%. Three sit below 12%.** The six rooms under 60% hold **2,917 of the
4,757**, which is **61% of the whole gap** in a quarter of the rooms.

That is not a discipline decaying evenly. It is a discipline that was carried into some rooms and
never into others, and it means a per-room sweep closes most of the gap while a tree-wide ratchet
would grind 570 modules with a median of three.

## What a remedy would look like, and what it would cost

**Horizon:** one round per room for the three near-zero rooms; `lattice` is 199 asserts in one file.

**Assumptions:** that an invariant line is worth writing where the law asks for one, and that the
seven rooms above 87% are evidence it is.

**The falsifier, and it is real:** read twenty covered asserts in `caravan`, the room with 8,685 of
them. If their invariant lines mostly restate the assertion -- `// invariant: n is at most 64` above
`assert(n <= 64)` -- then 92.8% coverage is a number about vocabulary rather than about reasons, and
the whole reading needs a second look before anyone sweeps a room to match it.

**Confidence:** *likely* that the room shape is real and stable; *a live possibility* that coverage
quality varies as much as coverage does, which the falsifier above is the cheapest way to find out.

## What this round does not do

It seats no ratchet and sets no ceiling. **Where a wall starts is a decision rather than a
measurement**, and it is more answerable now that the number is 4,757 in 50 files rather than 13,235
everywhere. The scan joins no standing roster; it answered its question and is kept so the next
round can re-run it in two seconds.
