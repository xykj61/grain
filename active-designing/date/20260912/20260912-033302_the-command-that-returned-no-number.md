# The command that returned no number

**Stamp:** `20260912.033302`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **mixed room**: the census and the two readings are checkable, the verdict that
this class earns no instrument is a judgment about population size
**Room:** mixed
**Kin:** [`../.claude/rules/quality-assurance.md`](../.claude/rules/quality-assurance.md) --
[`../tools/fixtures/d/docs_command_path_scan.sh`](../tools/fixtures/d/docs_command_path_scan.sh) --
[`20260912-011500_the-column-the-paragraph-could-not-keep.md`](20260912-011500_the-column-the-paragraph-could-not-keep.md)

## The finding

`docs-geode/README.md` holds a paragraph written to free a reader from two typed numbers. It names
both figures as **free**, says plainly that each rises whenever anyone writes a stamped page
anywhere in the tree, and then hands the reader the reading itself:

```
sh tools/fixtures/t/two_rooms_doorway_scan.sh | tail -2
```

Run it and the two lines that come back are `verdict=ok` and `OK doorway scan complete (seating
20260705-203144)`. Both are status words. The scan prints one line per page it reads, then three
summary lines each opening with the word `doorway`, then its verdict and its closing line -- so the
figures the paragraph had just promised sit three and four lines above where `tail -2` reaches.

**A position is a promise about how many lines follow. A prefix is a promise about what a line
says.** Only the second survives a `FAIL` line appearing above it, and this scan emits one per
failing page, so the count below the figures was never fixed even in principle.

## Where the repair came from, which is the part worth reading

The `| tail -2` entered on `20260910` in `a9963f08c`, whose subject is *the card says which half of
Truth answered*. That commit taught `qa_report_card.sh` to print `truth_mode=counted|judged`,
because a page had scored `truth=100` while its figure stood a quarter high. In the same commit it
freed this paragraph from its typed numbers, and handed the reader a command whose last two lines
are status words.

So the repair for a false figure was a command nobody ran. The card then graded the repaired page
**composite 94** two days later, because the counted half of Truth asks only whether every cited
path resolves, and `tools/fixtures/t/two_rooms_doorway_scan.sh` resolves perfectly. The path was
right, and the pipeline chose by position. A guard reading paths sees exactly the half that held.

**That seam is named rather than guessed at.**
[`../tools/fixtures/d/docs_command_path_scan.sh`](../tools/fixtures/d/docs_command_path_scan.sh)
gates, hard at zero, a path a page tells a reader to RUN that resolves nowhere -- the closest guard
this tree carries, rostered at `tier lap`, and green on this page throughout. Its own header
already names three guards it was built to sit between. This is a fourth seam one layer past it:
the path resolves, the command runs, and what it prints is not what the page said it would print.

## The census, and why it earns no instrument

Living tracked Markdown, outside `date/`, `archive/`, `yonder/`, `gratitude/`, `vendor/`, `seed/`
and `session-logs/`, printing a positional `tail -N` or `head -N` on a pipeline -- **three pages**,
read `20260912.033302`:

| Page | Shape |
|---|---|
| `docs-geode/README.md` | `sh <scan> \| tail -2` -- the fault |
| `active-designing/20260905-232224_the-fence-with-no-post-on-the-time-side.md` | prose *about* `tee file \| head -40` closing the pipe early |
| `counsel/replies/20260726-033904_re-pin-and-shelf-ad-stop.md` | `git log ... \| head -3` on a closed stack, where position names no figure |

**The class is one living page, and one page is a repair rather than a guard.** A gate costs a
roster seat, a control, a witness and a lap of every ship's time forever; the population it would
watch is a single line, in a room a lane already tends. The honest move is the repair, the census
that shows the population, and this page saying so, so the next reader meeting a second instance
knows the first one was counted.

**What would change that verdict:** a second living page printing a positional selector over a tree
scan. The census above is one command, and it is the thing to re-run rather than this table:

```
git ls-files '*.md' | grep -vE '/(date|archive|yonder)/|^(gratitude|vendor|seed|session-logs)/' \
  | xargs grep -lE '\| *(tail|head) -[0-9]'
```

## The repair

The page now prints `| grep '^doorway '`, which returns the three summary lines whatever stands
above them, and gives the shelf claim its own exact check -- `grep -E '^(FAIL|LIVING-SILENT)'` piped
through `grep docs-geode`, where empty output is the claim holding. Both refusal words are matched,
because the scan writes `FAIL` for a stamped page whose door names no room and `LIVING-SILENT` for
a stampless one, and a check reading only the first would call a silent door clean.

## Proven on metal, both directions

Run `20260912.033302` on this tree, against the live scan rather than a pen:

| Command | What came back |
|---|---|
| `... \| tail -2` | `verdict=ok` and `OK doorway scan complete (seating 20260705-203144)` -- no figure |
| `... \| grep '^doorway '` | three lines: `pages=1293 ... geode=18`, `fails=3 ceiling=3`, `stampless=138 living_silent=0` |
| `... \| grep -E '^(FAIL\|LIVING-SILENT)' \| grep docs-geode` | empty -- and the scan refused **3** pages in all, so the shelf claim holds against a non-empty population |

The third row is why the check is worth printing: an empty result proves nothing when the scan
refuses nobody, and here it refuses three.

## What this does not reach

**Whether the figures the paragraph names are right.** They are free by the paragraph's own word;
this repair only makes the command that reads them return them.

**Every other kind of promise a printed command makes.** A command whose flags have moved, whose
output format has changed, or whose exit status the prose describes wrongly is the same class and
is reached by nothing here. Named, so the next firing is a second instance rather than a surprise.
