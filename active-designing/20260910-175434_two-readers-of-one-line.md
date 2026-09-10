# Two readers of one line, and the ceiling nobody declares

**Stamp:** `20260910.175434`
**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living - **Room:** checkable -- every figure here comes out of a scan named beside it,
and the one proposal at the end is marked vision
**Kin:** [`../.claude/rules/gauge-style.md`](../.claude/rules/gauge-style.md) -
[`../.claude/rules/quality-assurance.md`](../.claude/rules/quality-assurance.md) -
[`../.claude/rules/ascii-first.md`](../.claude/rules/ascii-first.md) *(the wall that became derived)* -
[`../tools/fixtures/q/qa_report_card.sh`](../tools/fixtures/q/qa_report_card.sh) -
[`../tools/fixtures/q/qa_setting_declared_scan.sh`](../tools/fixtures/q/qa_setting_declared_scan.sh)

Gauge sets one dial by who is reading. **Door** holds a page at or under 20% negative sentences,
**Field** at or under 30%, and **Meter** carries no ceiling at all, since refusal is what a ledger
row is about. A page answers to exactly one of the three, and this tree writes a `**Style:**` line
at the head of most pages to say which.

Two instruments read that line. On `20260910` they were asked the same question about the same
pages and gave different answers, and one of them carried a comment announcing that they agreed.

## What each one missed

The report card matched `^[ \t]*\*\*Style:\*\*` -- the key at the start of a line. The census read
the block above a page's first `---` rule and looked for the key anywhere in it. Measured over the
census's own 330-page population:

| Reader | Rule | Missed |
|---|---|---|
| `qa_report_card.sh` | the key at line start, anywhere in the file | **65** pages writing it inline after another key |
| `qa_setting_declared_scan.sh` | any key above the first `---` rule | **5** pages declaring below that rule |

`docs/README.md` writes `**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Door setting`, so
the card answered `absent` for a page that names its setting in plain words. `README.md` -- the
page a stranger meets first -- opens with a centred logo, a title, a tagline and four licence
badges above its rule and carries its front matter below, so the census read the tree's own front
door as declaring nothing.

**Both faults point the same way, which is why neither ever surfaced.** A missed declaration reads
exactly like a page that never wrote one, so the two instruments agreed on `absent` for different
reasons and no disagreement was there to be caught. The census's four counts were all understated:
`style_declared` 158 to **164**, `setting_named` 48 to **50**, `setting_unnamed` 110 to **114**,
`no_style_line` 172 to **166**.

## The repair, and the shape it takes

The rule is published **once**, as `declared_style_line_of()` in the card, and the census lifts it
out of that file at run time -- the road the card already walks for `measure()` and the sentence
floor, and the road the ASCII wall walked when its enforced set became derived
from the rule rooms' own citations in place of a typed list.

A declaration is a `**Style:**` key standing **anywhere in the page's head**, and the head is
bounded at 40 lines. The bound is what keeps body prose out now that the first rule no longer does:
`context/RADIANT_STYLE.md` discusses the words `Style: Radiant` at line 57 and `context/TRYA.md` at
line 31, and neither writes the bold key at all.

**Three legs prove the citation is live rather than decorative.** An absent card refuses; a card
that stops publishing the function refuses; and a card publishing a **blind** reader is believed,
which is the only one of the three a quiet second copy could not fake. Thirty-eight behaviors stand
in the census's pen and 162 in the card's, every one on planted pages in a throwaway repository,
and the three shape legs were shown to bite by carrying the elder anchor back in.

## The reading this turned up, and the question it leaves

With the rule repaired, the same question can be asked of the **DOOR roster** -- the sixteen pages
`tools/fixtures/p/prose_register_scan.sh` holds at the strictest ceiling this tree has. Measured
`20260910.163831`:

| Reading | Count |
|---|---|
| DOOR pages declaring `Door setting` | 7 |
| DOOR pages naming no setting | **9** |
| DOOR pages declaring another setting | 0 |

`README.md`, `bat`, `encoding`, `foundations`, `the-return-that-feeds-everyone`,
`docs-geode/tutorials/the-first-hour.md`, `mycelium`, `amphora` and `mikrophone` are each held at
20% by a list typed inside a scan, and each says nothing about it at its own door. **A reader
learns the language, the voice and the register, and never learns the number.**

The roster is deliberate, and a page joins it by a hand rather than by accident, which is the
property that scan's own header defends. What stands open is whether the promise belongs on the
page as well as in the list.

**The proposal is vision, and it stays vision.** If a page declared its setting and the meter read
that declaration, the roster would follow the pages rather than the other way round -- and a page
brought under Door tomorrow would say so the day it arrives. Two things stand between here and
there. The **14 spellings** the 50 declaring pages use today, where a tool can read one -- and the
same drift already costs two false readings, since a Style line ending *"it stays in the field"*
means the maintainer's working tree and reads as Gauge's Field. And the question of who owns a
page's register, the page or the roster, which is Keaton's word rather than a lap's.

**What holds these figures still.** The two card and census readings are walled by
[`../tools/q/qa_setting_declared_witness.rish`](../tools/q/qa_setting_declared_witness.rish) and
[`../tools/q/qa_report_card_witness.rish`](../tools/q/qa_report_card_witness.rish), which run every
lap. The population counts and the door table are **free** -- they move whenever a page is written
-- so run `sh tools/fixtures/q/qa_setting_declared_scan.sh` rather than trusting the tables above.
