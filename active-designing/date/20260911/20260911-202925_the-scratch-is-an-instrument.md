# The scratch is an instrument

**Stamp:** `20260911.202925` -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Room:** checkable -- one guard's repair, proven on real git repositories in a throwaway pen
**Status:** Landed -- `tools/fixtures/a/announced_length_scan.sh`, control 19 -> 25 legs, witness GREEN
**Kin:** [`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md) --
[`../foundations/20260905-154954_the-clock-and-the-mark.md`](../foundations/20260905-154954_the-clock-and-the-mark.md) --
[`../foundations/20260826-021735_earth-the-row-that-breathes-in.md`](../foundations/20260826-021735_earth-the-row-that-breathes-in.md)
**Ledger:** REDS `%721`

**Recovered and re-measured `20260911.211000`.** The round below was written, proven and never
sent: the lap that made it was cut mid-send, and `fleet_round_open.sh` parked its whole working tree
in a stash (%321). The next lap found it there because the roster's own `stash_record` guard reds on
exactly that state -- a session log in the dead-letter box that no branch carries. The repair and
its 25 pen legs are the elder lap's; the census in *How wide it goes* is re-measured here and reads
differently, which is said in that section rather than quietly.

A guard reads the tree and prints a verdict. Between those two acts many guards put their findings
somewhere -- a file on disk, written by one half of the script and read back by the other. That
file is part of the instrument, and this is the story of the one place this tree forgot it.

## What the guard is for

`announced_length` reads every living page for a ladder announced from zero -- `SOON0-SOON63` --
and prints how far that ladder actually got. The law behind it is the mark law: a number written
into a name for **planned** work is a forecast, and a forecast reads like a fact. Nine such
announcements were found by hand and typed into the rule, four equinoxes among them announcing 256
rungs between them and having reached six. The guard exists so the tenth is caught on the lap it
arrives.

## What it did when its scratch went missing

The walk wrote one line per announcement into `/tmp/al_found.$$`, under `2>/dev/null || true`, and
the second half read the file back. When that write cannot land, the read returns nothing, and
nothing is a lawful answer here: a tree announcing no ladder at all counts zero and passes. So the
guard printed

```
announcements_checked=0
forecasts_short=0
verdict=no_living_forecast
```

at exit 0 -- and `verdict=no_living_forecast` is the one string the witness asserts.

**Proven on metal rather than argued.** A pen holding one sixty-four-rung `WIDE` forecast, run twice
against the same unmodified scan: with a writable scratch it reads `living_forecast` and names both
numbers; with the scratch path pointed somewhere unwritable it reads `no_living_forecast` at exit 0.
The forecast stands in the pen either way. A guard unable to red guards nothing.

## The part worth keeping

**The script already knew this discipline.** Twenty-five lines above the fault it proves `git` is
present before calling it, and proves the living listing non-empty before walking it -- both citing
REDS `%413`, *the instrument is proven present before it is trusted*. The scratch sits between those
two checks and carries every finding from one half of the script to the other, and it was the one
instrument taken on faith.

That is the shape to carry forward. A guard's preconditions are easy to see because they are named
in the prose that justifies the guard. Its **plumbing** is invisible for the same reason a forecast
in a name is invisible: it reads like a fact.

## How wide it goes -- a singleton, and one shell option is what makes it one

**Eleven tracked scans redirect a block into a scratch file and read it back**, re-measured
`20260911.211000` over every tracked `.sh` and `.rish` carrying a block redirect -- `done >`, `} >`
or `fi >` -- whose target is read again further down. What separates the ten sound ones from this
one is smaller than it looks.

**`mktemp` is not a refusal.** The elder reading of this class counted files that CALL `mktemp`,
and calling it says nothing about what happens when it fails. `work=$(mktemp -d)` on a full disk
leaves `work` empty, and every path built from it becomes an absolute path at the root. What
actually refuses is one of two things:

| What holds the scratch | Scans |
|---|---|
| an explicit `\|\| exit` on the line that makes it | 5 -- `elf_machine_census`, `foundations_link`, `plant_liveness`, `ratchet_slack`, `tame_style_long_fn` |
| `set -e` alone, under which a failed assignment ends the run | 5 -- `caravan_allowance_symbol`, `caravan_object_symbol`, `geode_libraries`, `room_braid_census`, `tool_path_repoint` |
| neither | 1 -- `announced_length`, repaired here |

**Proven on metal rather than read off the source.** The same failing `mktemp` under the two
options, run in this shell:

```
$ sh -c 'set -eu; d=$(mktemp -d -p /nonexistent 2>/dev/null); echo "REACHED [$d]"'; echo "exit=$?"
exit=1
$ sh -c 'set -u;  d=$(mktemp -d -p /nonexistent 2>/dev/null); echo "REACHED [$d]"'; echo "exit=$?"
REACHED []
exit=0
```

`announced_length_scan.sh` carries `set -u` on line 21 and nothing else, which is the whole of why
this one scan walked past an unmakeable scratch into a green verdict while ten siblings did not.

**And the class was counted three times, growing twice, each time because a counter read one
spelling.** The first reading said seven, counting `mktemp` calls. The second said ten, following
the literal redirect target -- and missed `plant_liveness_scan.sh`, which writes `done > "$pen/tally"`
and reads it back through an alias assigned on the next line, `tally="$pen/tally"`. Eleven is the
reading that followed both. A population is a claim about a class, and each of these three was a
claim about a spelling.

**Five refuse SILENTLY**, which is a lesser tell rather than a clean bill: `set -e` exits 1 and
prints nothing, so a reader sees an empty run rather than a reason. The repair below gives this one
scan a named refusal and a required write-back, which no sibling has.

## The repair, and why it is two checks

`mktemp` with a refusal at exit 2 closes the case proven above. It cannot close the next one: a
write that fails **partway** leaves the file created and the listing short, and a short listing
understates the reading exactly as an empty one does.

So a `#listing-complete` sentinel is written last and required back. Its absence is what a
truncated write leaves behind, and it is present in every honest case including the honest zero --
a tree with no announcements writes that line and nothing else, counts zero, and passes.

**The two are layered rather than redundant, and a mutation proved it.** With the `mktemp` refusal
removed, the unwritable-scratch case was still caught -- by the sentinel. The control carries both
refusals planted and then lifted, and both mutations bite: 25 legs, `fail=0`.

## What this does not reach

**The other ten carry the partial-write residue.** Every one of them refuses when the scratch
cannot be MADE, by hand or by `set -e`, and not one requires the write back -- so a filesystem
filling mid-walk understates all ten in silence. Naming it is cheaper than sweeping it, and cheaper
than pretending it is closed.

**A footnote the round earned by tripping over it.** This write-up first spelled that pen's
announcement literally -- the range, both ends -- in the paper, the card and the ledger row, and the
repaired guard read all three as three fresh forecasts by three living pages. The scan's own header
already names this shape twice, once for a table that tabulates announced against reached and once
for the demos page that quotes the scan's own output; prose describing a pen is the third face of
it. The fix belongs in the prose rather than in the meter: a page that means to DESCRIBE a forecast
can say *a sixty-four-rung forecast* and make none. An instrument must know where it stands
(`%458`), and so must the page that writes about one.

**And whether a guard's finding is worth having.** This proves the finding survives the trip from
one half of a script to the other, and stops there.
