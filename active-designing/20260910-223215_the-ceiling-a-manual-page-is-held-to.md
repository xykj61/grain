# The ceiling a manual page is held to

**Stamp:** `20260910.223215`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **mixed room**: the twenty declarations, the five measurements and the three
sweeps are checkable; the routing-page reading at the end is proposed and waits on Keaton's word
**Kin:** [`../.claude/rules/gauge-style.md`](../.claude/rules/gauge-style.md) -
[`../.claude/rules/quality-assurance.md`](../.claude/rules/quality-assurance.md) -
[`20260910-204226_the-door-that-names-its-own-ceiling.md`](20260910-204226_the-door-that-names-its-own-ceiling.md)

**Mechanism.** Twenty living pages under `manual/` and `docs-geode/` carried a `**Style:** Gauge`
header line that stopped at the style word. Each now names one -- `**Style:** Gauge, Door setting` or
`**Style:** Gauge, Field setting` -- in the same header line the report card already parses with
`declared_style_line_of()` at `tools/fixtures/q/qa_report_card.sh:181`. Three pages were then swept
to sit inside the ceiling they had just declared: one `not` became `rather than` in
`manual/grain-os/overview.md`, one `empty` became `at zero length` in
`manual/tutorials/run-record-and-failures.md`, and five phrasing negatives left
`manual/guides/macos-ai-jail-setup.md` with every claim carried over word for word.

## Why the twenty had no setting

The elder lap seated a wall over the nineteen doors of the register roster: a page there declares
its setting or `door_setting_verdict()` refuses. That roster is nineteen pages. Measured this lap
across the whole tracked tree, **1,064 pages declare a style and name no setting**, and **157 of
them are living** -- the rest carry a one-clock basename and are testimony, which keeps every word
it wrote. Twenty of the 157 stand in the rooms this lane owns.

Both figures are **free**: each rises with the next page written.
Run the reading rather than trusting these numbers:

```
git ls-files '*.md' '*.mdc' | while read f; do
  s=$(grep -m1 -E '^\*\*Style:\*\*' "$f" 2>/dev/null) || continue
  [ -n "$s" ] || continue
  echo "$s" | grep -qiE 'door|field|meter' || echo "$f"
done | grep -vE '(^|/)[0-9]{8}-[0-9]{6}([_.])' | wc -l
```

## The rule the twenty were sorted by, written down

A setting is chosen by **who is reading**, ahead of what the page measures. Choosing it the other
way round -- reading the number first and picking the label it clears -- makes a declaration a wish
with a decimal point in it.

| Setting | The reader | The pages |
|---|---|---|
| **Door** | arrives with no context | the three `README.md` front doors, `get-started.md`, `overview.md`, `_variant-template.md`, and all four tutorials |
| **Field** | is already here, doing a task | the seven `guides/` pages and the three `reference/` pages |

A setup guide lands in Field on that reading rather than on its number. Someone following
`macos-ai-jail-setup.md` is at their own keyboard installing a sandbox, which is the reader Gauge's
Field setting describes, and the page owes them the failures by name.

## What the reading found once every page had a ceiling

Five of the twenty stood above the ceiling their reader put them under. Three came down this lap and
two stand named.

| Page | Setting | Before | After |
|---|---|---|---|
| `manual/grain-os/overview.md` | Door 20% | 21% | **14%** |
| `manual/tutorials/run-record-and-failures.md` | Door 20% | 22% | **11%** |
| `manual/guides/macos-ai-jail-setup.md` | Field 30% | 37% | **30%** |
| `manual/guides/self-hosted-vpn-setup.md` | Field 30% | 33% | 33% -- named |
| `manual/guides/walking-the-rounds.md` | Field 30% | 31% | 31% -- named |

**The three that came down were phrasing; the two that stand are subject.** Every sentence swept in
the ai-jail guide kept its claim exactly -- `one source of truth, no drifting copy` became `one
source of truth, rather than a copy free to drift`, and `re-stamps identity without minting new
keys` became `re-stamps identity while the existing keys stand`. What was left alone is what the
guide exists to say: that Seatbelt resolves an overlapping allow/deny pair to deny, that a nested
call fails outright, that a symlink whose target lies outside the fence is uncovered.

**`walking-the-rounds.md` is counted for writing in the house style.** Seven of its twenty-one
counted sentences carry **`never` and nothing else negative** -- `Report what ran, never what will
run`, `Bench output is quoted, never paraphrased`, `Length ceilings are ceilings, never targets`.
That `X, never Y` contrast is this tree's own most-used affirmative form, and it appears throughout
the law pages the meter holds at zero. Drop those seven and the page reads **14 of 66, 21%**, inside
Field with room to spare. The guide that teaches how to write a round is penalized for teaching it
by example.

This is named rather than swept, and it is named rather than fixed in the instrument.
`tools/fixtures/p/prose_register_scan.sh:185` publishes the word list, and its own header already
says the honest half of this at line 143 -- *a target is a ceiling rather than a goal, and a page
about refusal spends more*. Whether `never` in a contrast clause should count is a reading of the
wall, and the wall is Keaton's.

## The three that read below B, and the one shape two of them share

The report card grades four readings meaned. Three of the twenty came back under the door at B, and
**every one of them lost it on Reach rather than on Register**:

| Page | Letter | What pulled it |
|---|---|---|
| `manual/grain-os/get-started.md` | C+ 78 | 6 cross-refs per 100 words against Door's 1 -- 22 links in 373 words |
| `manual/grain-os/variants/_variant-template.md` | C+ 76 | 8 per 100 words -- 6 links in 73 words |
| `manual/guides/macos-ai-jail-setup.md` | C+ 76 | reading grade 15 against Field's 11, across 2,011 words |

The third is the page's own fault and its own lap: a security guide written in very long sentences
should be written in shorter ones, and that is a rewrite of two thousand words rather than a frame.
It is booked.

**The first two share a shape.** A get-started page and a template are **link-dense by function** --
routing is what they do -- and the Door budget of one cross-reference per hundred words is drawn for
prose that argues. The card already knows this class and holds one door open for it: a page
declaring `**Kind:** index` or `**Depth:** routing` **and measuring under 100 words** has its
cross-reference term freed (`qa_report_card.sh:645`). `_variant-template.md` measures inside that
floor at 73 words; `get-started.md` stands outside it at 373.

So the proposal, stated and left: **the index door tests a page's kind and its size, and a routing
page can be honest about its kind while standing above the size floor.** The floor's own reasoning
is that a rate below one unit of its denominator is extrapolation, which is true and settles nothing
about a 373-word page that is genuinely three-quarters links. Whether routing earns a budget of its
own is a reading of the card, and the card is Keaton's.

## What this lap did not reach

**The other 137 living pages** whose style line stops at the style word. They stand in rooms other
lanes own, and a setting written into a page by a hand that has never read it is the wish this lap
was drawn to remove.

**Whether any of the twenty is held.** The census that prices the unnamed setting reads a roster of
**330 pages**, and exactly **one** of these twenty sits inside it: `setting_unnamed` fell 110 to
109. The other nineteen declarations are held by nothing at all, and they are true because a hand
measured them rather than because a guard would red if they drifted.
