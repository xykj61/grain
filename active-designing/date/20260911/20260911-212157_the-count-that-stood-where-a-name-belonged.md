# The Count That Stood Where a Name Belonged

**Stamp:** `20260911.212157` -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Room:** checkable -- every figure below comes from a scan anyone may run, and the repair is held
by a pen that bites.
**Status:** Landed -- `tools/t/tutorial_output_witness.rish` GREEN, pen at 58 legs.
**Kin:** [`the fence label the guard could not read`](20260911-171657_the-fence-label-the-guard-could-not-read.md)

A guard in this tree may do one of three things with what it finds. It may **gate** -- refuse the
tree until the fault is repaired. It may **ratchet** -- hold a population under a ceiling that only
falls. Or it may **report** -- count something and pass it on to a reader, gating nothing.

The third is the honest answer when the finding wants a judgment the scan cannot make. It is also
the one that quietly depends on a reader being able to act, and that dependency is easy to leave
unpaid.

## The promise, and what was printed

`tools/fixtures/t/tutorial_output_scan.sh` reads the command-and-output pairs the teaching rooms
write, runs each command, and gates the tree the moment a quoted block drifts from what prints.
Two of its readings report rather than gate.

**`undeclared_after_prose`** counts a pair with a sentence standing between the command and the
block. That sentence decides which of three different things the block is -- a subset of this
output, the output of another invocation, or an unrelated listing -- and each of the three wants its
own test. So the scan names the pair and leaves the judgment to a reader.

**`held`** counts a fence outside the run roster: one that makes a directory, writes a file, or
names a script the reader is about to write themselves. Running it lies beyond this pier, so the
scan names it and holds it under a ceiling.

Both readings earn their exemption on the same promise, and the scan's own header states it twice:
the population stays **visible**. A block nothing reads and a block nothing *may* read read alike
from outside, and only one of them is a gap.

What a roster lap actually printed was this:

```
undeclared_after_prose=4
held=3
```

Seven pages, seven line numbers, and a report carrying the two totals alone.

## Where the names were

They existed. The scan writes every pair to its own line file with a verdict and a reason, and a
second verb prints that file:

```
sh tools/fixtures/t/tutorial_output_scan.sh list
```

Nothing in this tree runs it. A grep over the tracked `.rish`, `.sh`, `.kyri` and `.md` sources
finds exactly two callers -- the witness, which runs the default report, and the pen, which runs the
pen. Every other appearance of the scan's name is prose citing it. So the names were written, kept, and reachable by a hand that already knew to ask -- the one
reader already holding the answer.

**A population reported as a bare count is visible the way a locked door is visible.** You can see
that something is there. The repair is two lines, printing each name beside its count:

```
undeclared: docs-geode/tutorials/the-first-hour.md:65 -- 8 line(s) of prose sit between the
            command and the block; declare selected, volatile or lead-in to have it read
held: docs-geode/demos/README.md:41 -- the fence is outside the run roster
```

## Not booked as a red, and why

The argument for a row is that the header said *named* and a roster lap read a number. The argument
against it is stronger: the scan genuinely named them, through a verb its own usage block documents,
and every claim it makes holds. What the repair adds is a door the two callers already walk through.
That is something which could be better, which is the lighter of the two weights quality assurance
names. Recorded here instead, where the next reader of this guard will meet it.

## What the four turned out to be

Reading them one at a time is the first thing the names made possible, so this lap did it rather
than sampling.

| Pair | What the block belongs to |
|---|---|
| `SOURCE.md:241` | a fingerprint card under the words *reads like* -- an illustration of shape |
| `the-first-hour.md:65` | the *run it twice* block, a second invocation of a different command |
| `the-first-hour.md:96` | `already=yes`, which belongs to the fetch script three fences above |
| `cloud-agent-toolchain-setup.md:23` | what `rye` and `rishi --help` answer, two other commands |

All four are honest reattributions or illustrations. The caution the scan carries is right about
every one of them, and all four stand correctly as they are. **That population is honestly
unreadable rather than unread**, which is a better answer than a ceiling and was unavailable while
the names sat behind a verb.

## The shape the reading found

The first hour's pair at line 96 is worth one more sentence, because the fence above it carries a
second claim of its own:

````
```sh
vendor/zig-toolchain/zig version
# 0.16.0
```
````

`# 0.16.0` is what the reader will see, written as a comment rather than as an output block, and
nothing reads it -- the parser strips a trailing comment before deciding whether a line is runnable,
so the claim is discarded on the way past. It is exact today, checked on metal.

Measured across the scan's own corpus: **39 comment lines stand inside command fences over the 80
tracked pages, 22 of them in the 49 living ones, and six of those 22 are output claims** --
`SOURCE.md` at 223, 582, 589 and 591, the first hour's 98, and `manual/grain-os/get-started.md` at
48. The other sixteen are asides: a section label, an alternate command, a note about where a
download landed.

Position alone reads sixteen of the twenty-two, six of them the claims -- so the shape wants a
declaration exactly as the prose above it does.

**A fourth declaration token was declined, and the population is why.** Of the six claims, five sit
off the run roster: a macOS `fdesetup`, two `socketfilterfw` reads, a `gpg` fingerprint, and a
toolchain binary rather than a tracked script. The sixth abbreviates its output with an arrow rather
than quoting it. A checker built for this shape would check nothing today. The class is counted and
named in the scan's header so the decline is visible rather than silent, and so the lap that writes
a seventh claim has a standard to build against.

## What holds the repair

The pen plants a page with an undeclared pair and reads the report for its name; plants a fence
outside the roster and reads the report for that one; and mutates the scan by deleting the two
naming lines, watching the names go and the count stand. The mutation is what proves the first leg
reads its own line rather than one printed elsewhere.

**And the hot pass read the mutation before the commit did.** `plant_liveness` resolves every
single-quoted writing `sed` in the tree's controls and runs it against the file it names, so a
plant whose pattern has gone stale is caught rather than left testing an unchanged file. The first
draft of this mutation spelled its two deletions as `sed -e '...' -e '...'`, and that guard's
parser reads one quoted program per `sed`, so it handed the shell a program ending inside a quote
and reported `sed refused the program` with my file and line beside it. The mutation itself worked
and its leg passed -- which is exactly the case a liveness guard exists for, since a plant that
runs today and parses wrongly tomorrow looks identical from its own leg. One `;` in place of the
second `-e` closed it: `plants_live` reads 51 where it read 50, and `plants_failed` reads zero.

## What this does not reach

Whether a reader acts on a name once it is printed. And the three pairs the scan holds: they are
named now, and a macOS disk-encryption check stays beyond a Linux pier.
