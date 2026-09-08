# What the grader's correction costs, measured

**Stamp:** `20260907.171748`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed measurement -- **Room:** checkable; every number below comes from a named corpus
under a named command, and the commands are quoted so the run repeats
**Row:** `construction/REDS.md` `20260907.144904`, OPEN -- *the card's two readings disagree about
what prose is*
**Kin:** [`../.claude/rules/quality-assurance.md`](../.claude/rules/quality-assurance.md) -
[`../tools/fixtures/q/qa_report_card.sh`](../tools/fixtures/q/qa_report_card.sh) -
[`../tools/fixtures/p/prose_register_scan.sh`](../tools/fixtures/p/prose_register_scan.sh)

---

## The question this answers

The open row says the report card holds two readings that disagree about which lines are prose.
**Register** skips a bullet the CommonMark way -- the marker `-`, `*`, or `+` *followed by
whitespace* -- after REDS `%451` proved the elder character class read `**Bold:**` paragraph
openings as bullets. **Reach**, one reading down in the same file, still spells the elder
`/^[ \t]*[-*>#]/`. So a paragraph that opens in bold, which is how Gauge writes, leaves Reach's
grade and link density while Register counts it.

The lap that found this declined to correct it, and named the reason: correcting the rule re-grades
every graded page in one step nobody had measured. That is the right refusal and it leaves one
question, which is the only thing standing between the row and its repair -- **what does the
correction actually do to the tree's grades?**

This page answers that, and leaves the tree exactly as it stands.

## Method

A copy of `qa_report_card.sh` in a throwaway pen, with one line group replaced: Reach's read-past
rule, rewritten to the four rules Register already runs -- a rule line, a true bullet, quotes and
headings, and the front-matter block Register recognises by position and shape together. The rest
of the file stands exactly as it is.

Both graders then ran over the same corpus, at the same setting, with the same service number, so
every difference is attributable to that one rule.

```sh
git ls-files '*.md' \
  | grep -vE '^(gratitude|vendor|seed)/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | grep -vE '/(date|archive|yonder)/'
# 429 files -- living prose: our own, still edited, still on an open shelf
```

**The corpus is living prose, and that bound is deliberate.** Dated testimony keeps every word it
wrote, so its grade steers a decision nobody will take. Every file ran at `--setting field
--service 75`; a page's true setting varies, and holding it constant across both runs is what makes
the delta clean.

## What moves

| Reading | Value |
|---|---|
| Pages read | 429 |
| Grade unchanged | 324 |
| Grade rose | 56 |
| Grade fell | 49 |
| Mean composite delta | **+0.59** |
| Mean gain where it rose | +7.70 |
| Mean loss where it fell | -3.61 |
| Pages under the B door, before | 81 |
| Pages under the B door, after | **72** |
| Crossed up over B | 16 |
| Crossed down under B | 7 |

**Register is identical on all 429 pages.** That is the proof the patch reaches one reading and
leaves the other alone, and it is worth more than the deltas: Register already read correctly, so it
should come back byte for byte, and it does.

**Reach sees 337,421 words where it saw 211,089** -- 126,332 words of body prose it had been
walking past, on 350 of the 429 pages.

## The correction runs both ways, and the second half was unexpected

The elder rule **dropped** body prose, and it also **counted** front matter as prose. That second
half produces the largest movements.

`waymarks/stoa-300s/README.md` is an index whose body is a table. Under the elder rule Reach saw
13 words and 2 links -- the shared `**Where this sits:**` navigation line, three lines of metadata
carrying two citations -- and read 15 cross-references per hundred words against a budget of 3,
which floors Reach at 0 and the page at **D+ 69**. Under the corrected rule it sees the 7 words
that are actually its own, carries no links in the reading, and reads **A 94**. Three STOA index
pages and `granary/README.md` move exactly that way.

So the rise is not the meter being generous. It is the meter stopping grading a page on its own
navigation header, which is the same fault `%451` repaired for Register and which has stood in
Reach ever since.

## The seven that would fall, named

| Page | Before | After |
|---|---|---|
| `.claude/rules/the-baton.md` | B 83 | C+ 78 |
| `active-designing/seam-season-hammock.md` | B 80 | C 72 |
| `.claude/rules/ascii-first.md` | B 81 | C+ 78 |
| `active-designing/20260814-fill-ales11-lotus-equal-power.md` | B 80 | C+ 75 |
| `active-designing/20260814-fill-ales21-lotus-marker-time.md` | B 83 | C+ 78 |
| `context/specs/two-dev-environments-and-mobile-emulation.md` | B 80 | C+ 75 |
| `crypto/CONSTANT_TIME.md` | B 80 | C+ 77 |

**Each fall is honest, and two were opened to check.** `ascii-first.md` goes from 330 counted words
to 548 and its reading grade from 12 to 13; `CONSTANT_TIME.md` from 670 to 735 and from 11 to 12.
In both the newly visible prose is real body text, and it is genuinely denser than the part the
elder rule was reading. The meter has grown no harsher; it has started finishing the page.

## The sixteen that would rise, named

`cellar/README.md` C 73 -> A 90 - `classical-vedic-astrology/_method/README.md` D+ 69 -> B+ 86 -
`docs/ZETA.md` D+ 69 -> A 91 - `granary/README.md` D+ 69 -> A 94 - `keys/README.md` C+ 77 -> B 80 -
`lantern/README.md` C+ 76 -> A 91 - `mandate/README.md` C+ 78 -> B 80 -
`manual/grain-os/variants/_variant-template.md` C 74 -> B 81 -
`rye-learning-process/GLOW_ALMANAC.md` C+ 76 -> B 81 - `src/shape/PLACARD.md` C+ 76 -> B+ 89 -
`tally/README.md` C+ 79 -> B 84 - two `tools/fixtures/*/livemod/README.md` C+ 76 -> A 94 -
three `waymarks/stoa-*00s/README.md` D+ 69 -> A 94.

## What this measurement does not reach

**Whether the corrected rule is right.** It matches Register, and Register's own form was argued
and measured under `%451`. This page shows what agreement costs; it does not re-derive the argument
for the form.

**Dated testimony, 4,120 files of it.** The elder lap counted 22,041 body lines dropped across the
whole tracked tree. Those pages keep every word they wrote, so this run
spent its hours on the grades a hand can act on.

**A page's true setting.** Every file ran at Field. A Door page carries tighter ceilings, so its
individual delta will differ; the direction and the population hold, since the rule decides
which lines are read before any ceiling applies.

**The seven falls are a price, plainly stated.** A page below B pushes one molt frame under the
quality-assurance rule, so the correction opens seven. It also lifts sixteen pages over the door
and closes their frames, which is why the tree carries nine fewer afterward than it carries today.

## What it hands back

The row asked whether a lap may correct its own grader when the correction re-grades every page
unmeasured. **It is measured now:** 324 of 429 pages do not move, the mean moves by half a point,
the door population improves by nine, and the seven pages that fall do so because the meter has
started reading prose it had been skipping.

The word stays Keaton's, and it now has a number under it.
