# The verb already in your hand

**Language:** EN - **Stamp:** `20260917.211946` - **Voice:** Kyri - **Style:** Gauge, Field setting
**Status:** Landed reading - **Room:** checkable -- every figure names the command that produced it
**Kin:** [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) - the fusion build design `20260825-173153`

## The question that started it

Keaton asked what the computational engine of this tree currently is, given that it holds three
languages of its own -- Rye, Rishi and Glow.

The measured answer is **POSIX shell**, by a wide margin.

| Reading, `20260917` | Value |
|---|---|
| Rostered guards that build Rye / their wall | 33 / **382 s** |
| Rostered guards that do not / their wall | 330 / **4,370 s** |
| Authored Rye module source | 1,848 files, **742,391 lines** |
| Witnesses invoking a Rye build | **147 of 2,058** |
| Rishi's share of a cold run | **0.11%** (13.16 ms x 355 guards) |
| Glow | 451 files, 3,280 lines -- **7.3 lines a file** |

**Ninety-two percent of the proving hour is shell**, while the largest body of authored code in the
tree runs in 33 of 449 guards. Every figure here is free; run
`sh tools/fixtures/p/process_fanout_scan.sh` and the two `git ls-files` counts rather than trusting
the table.

## The recommendation that followed, and why it was wrong

From that reading I recommended giving Rishi native text primitives, so a guard could count and
match without reaching outward. It sounded right: Rishi conducts and never computes, so give it
something to compute with.

**Rishi already had them, and had for a long time.** Its own module header declares `read-file`,
`lines`, `where`, `length`, `contains`, `starts-with`, `ends-with`, `trim`, `slice`, `join` and
`map`. Three lines answer the question a `grep -c` answers:

```
let body = read-file "construction/standing-equipment.kyri"
let hits = where (lines body) as l: l starts-with "guard "
say "count=${length hits}"
```

Both forms answer **453**. Traced, the Rishi form starts **one** process -- itself -- and the shell
form starts **two**, `sh` and `grep`.

So the gap lies elsewhere. **The harness reaches for an outside tool while holding the operation in
its hand**, and it does so because that is how shell has always been written, rather than because
of anything the languages lack.

## The sharper half: the shell was holding it too

A finding only about Rishi would recommend a migration -- 413 scans, one at a time. This one reaches
wider, and the same day proved it twice in one file.

`tools/fixtures/s/standing_equipment_scan.sh` is the roster runner's own reader, and the fan-out
meter named it the heaviest guard it could see. Two repairs, both inside POSIX shell, both leaving
the output byte-identical:

**One.** Seven roster sites and one card site pulled a single whitespace field out of a line already
held in a variable, by spawning `printf` into `awk`. The shell splits words itself: `set -- $line`
and a positional parameter. **3,259 awk processes to 3.**

**Two.** Three sites asked *is this name in that list?* with `grep -qx`, once per row inside a loop.
The shell answers membership itself, with `case` against a newline-delimited string built beside the
file the loop was already writing. **916 grep processes to zero.**

| | Processes | Wall |
|---|---|---|
| Before | 4,330 | 20,641 ms |
| After the field split | 974 | 3,583 ms |
| After the membership test | **45** | **531 ms** |

**Thirty-nine times faster, with every byte of its answer held exactly.**

## What the pattern actually is

Both repairs kept the language, the dependencies and the primitives exactly as they stood. Both noticed that **a language was
being asked to fetch a tool for an operation it already performs**, and the cost of fetching is a
process -- which on this host runs 1.3 to 6.8 ms before it reads a byte, measured fresh each run by
`tools/fixtures/p/process_fanout_scan.sh --calibrate-only`.

Shell is a superb process orchestrator and this tree uses it well. The fault is a habit of reaching, and it hides because every individual reach is correct, cheap to
write, and reads exactly like the manual page.

**What makes it invisible is that it only costs anything in a loop.** One `grep -qx` is 5 ms, small enough to pass unread. The same line inside a 449-row walk is four and a half seconds, and nothing in the diff
looks different.

## The method this cost us, worth more than the repair

The byte-identity check nearly gave a false alarm. The baseline output was captured, the repair
made, the output compared -- and it **differed**, at `runs_seconds_total` and `newest_run`.

Both readings are OF the run card, and a guard had been run in between, which rewrote the card. The
input had moved, not the logic.

**A before-and-after comparison measures the change plus everything else that moved.** The honest
form runs both versions against the same input in the same moment -- stash, run, unstash, run, compare
-- and that read **identical**. A repair that changes a reading of a file the repair does not touch
is indistinguishable from a repair that breaks something, until you hold the input still.

## What this does not claim

**That shell should be replaced.** 92 percent of the harness is shell and will be for a long time;
these two repairs made it faster without moving a line out of it.

**That Rishi should now be the engine.** It could be -- the verbs are there and the probe proves
it -- yet 413 scans are shell today and each port is a lap with its own byte-identity wall. What
the probe settles is that the door is **open** rather than that anyone should walk through it
tomorrow.

**That the other guards carry this.** The fan-out census sampled 11 of a 177-guard population and
found a 58-fold spread, 13 to 750 per mille. One guard at 750 was repaired here; the rest are
unmeasured, and the meter that would name them is rostered at tier cadence.

## The reading to keep

**Before adding a primitive to a language, run the language.** I proposed building what existed,
from a correct measurement and a wrong inference, and one three-line script settled it in under a
minute. The measurement said *the harness spawns too much*; the inference said *because Rishi is
missing verbs*; and the missing verb was in the header of the file I was about to edit.

*May we reach for what we are already holding.*
