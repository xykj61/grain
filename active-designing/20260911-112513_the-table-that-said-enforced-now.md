# The Table That Said Enforced Now

**Stamp:** `20260911.112513`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **Room:** checkable; every count below comes from a named command over named
files, and the repair it argues for ships in the same commit
**Kin:** [`../.claude/rules/docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md)
-- [`../.claude/rules/gauge-style.md`](../.claude/rules/gauge-style.md) (*what holds a figure still*)
-- [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
-- [`../tools/fixtures/l/law_guard_heard_scan.sh`](../tools/fixtures/l/law_guard_heard_scan.sh)

`context/TAME_GUIDANCE.md` closes on a section called **What We Check, and When**, and its first
table stands under the words **Enforced now**. Twenty rule rows sit there. A reader meets them as
twenty walls.

Listened to one at a time -- the aether rota, row zero, the row that hears -- they are three
different sentences wearing one heading.

## The reading

Measured `20260911.112513` by pulling every backticked `tools/` path out of the table's own rows,
then asking `construction/standing-equipment.kyri` and the roster's own reach census which of them
a lap ever runs.

| Kind | Rows | What the reader gets |
|---|---|---|
| Names an instrument a lap runs | 8 | a wall, and a way to check it |
| Names an instrument **no lap runs** | 6 | a promise standing on nobody |
| Names **no instrument**, and one holds it anyway | 4 | a wall the reader cannot find |
| Names no instrument, and **nothing holds it** | 2 | a wish |

Eight rows lean on five rostered tools -- `width-check`, `tame-check` for three separate rules,
`opening_lines_witness`, `living_docs_lint` and `tame_style_check` for two more.

The four naming nothing while being held are the ban rows -- `FIXME` and `dbg(`, qualified
`debug.assert(`, compound `assert(a and b)`, and a call result compared to an error. All four are
enforced by `tools/t/tame_style_scan_bans.rish`, which `tools/t/tame_style_check.rish` drives and
the roster runs every lap. The check is real; the table simply never says so, and a reader who
wanted to run it had nowhere to start.

The six naming an instrument nothing runs name six different tools, and each is unheard for its
own reason -- only one of them is *nobody got round to it*. See **What this lap leaves standing**.

## The two rows nothing held

**Line length at or under 100 columns.** Searched for by predicate rather than by name -- any
tracked tool comparing a line length against a hundred -- and the only hit is
`tools/fixtures/t/tigerbeetle_style_by_the_numbers_census.sh`, which is a study of somebody else's
code and stands on no roster. Nothing in this tree flags a long line.

**One `# Title` per markdown.** This one had a shape worth naming, because it looked answered from
either end. `tools/fixtures/r/radiant_lint_scan.sh` carries the duty as its third and prints
`duty3 multiple-H1 -- deferred (TAME one-# Title / tame-check owns it)`. Turn to `tame-check` and
neither `tools/t/tame-check.rish` nor `tools/fixtures/t/tame_check_scan.sh` spells a heading at
all. Two pages each pointing at the other, and a reader checking either one finds a citation
rather than a hole.

## What the rule was worth, measured before it was built

A rule nobody holds may be a rule nobody needs, so the pages were counted before the guard was
written. Over 6,271 tracked `*.md` pages, fence-aware and counting an HTML `<h1>` as a title:
**6,221 carry exactly one**, 39 carry none, and 11 carry two or more.

Narrowed to the living population -- dated testimony, the `date/`, `archive/` and `yonder/`
shelves, the rooms whose text is not ours to edit, and every `fixtures/` path all read past --
**390 pages, 389 carrying exactly one title, one carrying two.**

So the rule is kept at 99.7 percent by habit alone, and by nothing at all. That is the best moment
to seat a guard: the wall costs one page of slack rather than a migration.

## The form a naive reading gets wrong

`README.md` centers its title as HTML:

```
<h1 align="center">Grain</h1>
```

A bare `^# ` count reads **zero titles** on the most-read page in the tree and calls the front door
a violation. A meter that did that would be turned off on its first day, and rightly. The fence
half of the same discrimination was already proven here once --
`tools/fixtures/c/census_control_h1_fenced.md` plants one true title with three decoys inside a
fence and reads `duty1_h1_true=1 duty1_h1_naive=4` -- so the method existed and had never been
pointed at the tree's own pages.

## What landed

`tools/fixtures/o/one_title_scan.sh` counts titles per living page, fence-aware, HTML-aware, and
holds `untitled + multi_titled` under a ceiling that only falls -- published at **1**, exactly what
was measured. `tools/o/one_title_witness.rish` runs it beside its pen, and the roster carries the
guard at `tier lap`: the scan reads 390 pages in 0.23s and the pen runs in 2.7s.

`tools/fixtures/o/one_title_control.sh` proves **48 behaviors** on real pages in a throwaway pen.
Six mutations of the scan were each bitten by their own legs: masking the fence (4 legs), dropping
the HTML title (2), dropping the inline-code mask (2), dropping the dated-basename filter (2),
widening the room anchors to match a nested directory (2), and silencing the short-walk check (2).

That fourth mutation is worth keeping in view. Anchoring the vendored-room filter as
`(^|/)seed/` rather than at the root reads as a tidy generalization and silently drops the three
living pages of `recursion-prompts/seed/` out of the population. The pen refuses it by planting a
nested page of that name and asserting it stays counted.

The table itself now names, for each row, the instrument that holds it -- and says plainly that the
line-length row is held by nothing yet.

## What this lap leaves standing

**Line length stays unheld.** The population was not measured and the repair is its own lap.

**Five of the six unheard instruments are unheard for a reason the tree already holds.**
`tools/cl/claim_preserve_witness.rish` refuses a bare invocation by design -- it wants
`CLAIM_PRESERVE_FILES` named, so it is a parameterized instrument a style pass drives rather than
standing equipment. `tools/d/designed_not_built_witness.rish` opens on its own first line with
*not in parity until Kaeden rules for the bound*, so rostering it would cross a parked ruling
rather than repair a gap. `tools/r/radiant_lint.rish` prints and never fails, by its own header and
by its row's own words -- and a guard that cannot red guards nothing, so *advisory* is the honest
roof for that row rather than *enforced*. `tools/d/dated_guard.rish` is a doorway over the staged
index, vacuously green when nothing freeze-class is staged, and it is reached by the parity chapter
rather than by a roster. `tools/p/proven_seat_signed_kumara_parity.rish` wants a staged bench.

The sixth, `tools/ce/cellar_first_ring.rish`, looks plainly rosterable and is left for a lap that
can run it and measure its cost, since rostering a guard and finding out what it costs are two acts
and doing both at once means nobody can tell which of them moved the number.

**The wider population this came out of.** `tools/fixtures/l/law_guard_heard_scan.sh` reads 25
law-cited guards no roster pass reaches, and its own header says it cannot tell a wall claim from a
mention. Grouped by the page doing the citing -- which is free, since the scan already knows it --
the 25 fall into three kinds: **13** are `context/LEXICON.md` rows recording what landed on a day,
**10** are `context/TAME_GUIDANCE.md`, and **2** are an answered question in
`context/OPEN_QUESTIONS.md` citing its evidence. **Not one is a `.claude/rules/` page making a wall
claim.** A landing record and an answered question are testimony; only the middle group is a
standing promise, and it is the group this lap read. Printing that grouping beside the total is a
small lap somebody should take.

---

*May every wall this tree describes be a wall somebody can run, and may the rules we keep by habit
be the ones we seat before the habit slips.*
