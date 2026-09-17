# Landed account -- COPAL, the cache and the copy

**Stamp:** `20260917.041331` (EDT)
**Language:** EN
**Style:** Gauge at Meter
**Voice:** Kyri
**Status:** Landed account, shelved at birth -- historical continuity outside Mitra and shred-prep
**Room:** checkable -- every reading below is held by a named guard or a named command
**Card:** [`../ITINERARY.md`](../ITINERARY.md)

## AIR FEELS -- walk the fence line and press each post

Row 1, N=5246. The air row's test is tactile: press a boundary and see whether the hand goes
through. The boundary pressed here was a falsifier -- the clause `%642`'s own design wrote to say
when the work it books stops being worth doing.

## THE READING THE ROW STOOD ON HAD MOVED UNDER IT

`%642` stands BOOKED and is queue item 1 on the eight-ship card: build a content-keyed scrub cache
for the seed publish. The `20260916` timing paper justified it on the classification -- two greps
every candidate pays, 215.58 seconds of a 364.68-second projection. The batching lap of
`20260917.004532` replaced those greps with four batched reads, so the number the ruling rested on
was spent the same night and nothing re-read it.

## THE MECHANISM

`tools/fixtures/s/sow_project.sh` reports its own step seconds when `SOW_TIME` is set. A `mark`
function stamps the boundary between the eleven numbered steps into `$W/time.txt`, bounded at
`SOW_MAX_MARKS=16`, and one `awk` pass at the close prints `step_<name>_s=` per step plus a total.
Off -- the default, and every run the publisher makes -- it costs one shell test per step and spawns
nothing.

## MEASURED, TWO RUNS BACK TO BACK, 9,116 CANDIDATES

| Step | Run 1 | Run 2 | Share |
|---|---|---|---|
| candidates | 1.48 | 1.54 | 2.1% |
| path-only refusals | 8.85 | 9.42 | 12.5% |
| armor grep, batched | 0.22 | 0.22 | 0.3% |
| identity grep, batched | 0.51 | 0.55 | 0.7% |
| verdict | 0.04 | 0.06 | 0.1% |
| make directories | 0.10 | 0.10 | 0.1% |
| **the plain copies** | **38.10** | **40.32** | **53.7%** |
| **the `sed` scrub** | **20.32** | **18.44** | **28.7%** |
| post-scrub identity re-read | 0.74 | 0.73 | 1.0% |
| public-key read and stub | 0.50 | 0.46 | 0.7% |
| the three logs | 0.02 | 0.02 | 0.0% |
| **total** | **70.89** | **71.84** | |

| Phase | `20260916` | `20260917` |
|---|---|---|
| projection | 364.68 | **75.91** |
| witness, whose duty 2 projects again | 354.09 | **99.90** |
| a publish | 718.77 | **175.81** |

Every second is FREE. Run `SOW_TIME=1 sh tools/fixtures/s/sow_project.sh`.

## THE RULING

A publish fell **4.1 times with no cache built at all**. What a cache still reaches is the scrub at
20.32 and the four batched reads at 1.47 -- **21.8 seconds of 70.89, 31 percent**, or a quarter of a
publish. What it never reaches is the copy at 53.7 percent, because the projection clears `seed/`
first and every kept file lands again whatever a cache remembers. Reaching that means syncing rather
than rebuilding, which moves the guarantee `stale_projection_file_cleared` currently holds.

## THE STEP NOBODY HAD COUNTED

The two path-only refusals cost **8.85 seconds and spawn no process at all** -- one `while read`
over 9,116 lines running two `case` tests, **six times all four batched greps together**. The
batching lap walked past it because the elder table had no row for it.

## PROVEN

`tools/fixtures/s/sow_project_control.sh` **35 legs from 28, 0 failing**, five mutations bitten. The
sharpest new leg is `timing_moves_no_projected_byte`: the pen projects one field twice, once silent
and once timed, and compares the two trees with `diff -r`. The mark ceiling is proven from both
sides by lowering `SOW_MAX_MARKS` to 2 and watching the timed run refuse out loud.
`tools/s/sow_project_witness.rish` GREEN; its leg count raised 28 to 35 so a leg written today is
heard today.

## MINE

I worked while the cold endurance run was still going, so it closed `tree_moved=yes` -- the same
fault the captain booked against itself yesterday, on the same card I had just read.

## YOURS

The path refusals are one `awk` pass away from under a second, with no guarantee to move and a pen
that already covers every branch -- one lap in this lane, and I left it rather than widening this
one. The larger question is the copy: an incremental `seed/` sync buys 38 seconds a projection and
owes a proof that a withdrawn file leaves. Design and word, rather than a lap?

Paper: [`../../active-designing/20260917-041331_the-cache-and-the-copy.md`](../../active-designing/20260917-041331_the-cache-and-the-copy.md).
Custody gate `%1` untouched; nothing published.
