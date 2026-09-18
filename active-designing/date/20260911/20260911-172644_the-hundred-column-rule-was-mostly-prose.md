# The hundred-column rule was mostly prose

**Stamp:** `20260911.172644`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living -- **checkable room**: a census with an instrument beside it, and one decision recorded
**Kin:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) -- [`20260911-112513_the-table-that-said-enforced-now.md`](20260911-112513_the-table-that-said-enforced-now.md) -- `tools/l/line_length_census_witness.rish`

REDS `%714` read the lint table of `context/TAME_GUIDANCE.md` one row at a time, under a heading
that says **Enforced now**, and found four different sentences wearing one claim. Nineteen rows
came out of that reading with an instrument beside them. One row came out holding nothing at all:

> **Line length <= 100 columns** -- flag lines past 100, allowing a URL or a multiline-string
> result that itself fits -- **held by nothing yet**

The remainder it booked was a single lap, and this is that lap: measure the population, then say
whether the row earns a guard or a retirement.

## The measurement

Read `20260911` over 4,915 tracked sources of the six extensions TAME governs -- `.rye`, `.rish`,
`.brix`, `.bron`, `.glow`, `.kyri` -- with the vendored rooms, the public projection, the session-log
testimony and every `fixtures/` plant left out:

| Reading | Count |
|---|---|
| lines | 895,602 |
| lines past 100 columns | 102,153 |
| of those, own-line comments | 54,940 |
| of those, a Rishi `say` or `assert` | 18,495 |
| of those, code | 28,718 |
| files carrying at least one | 4,036 of 4,915 |

Better than one line in nine runs past the bound, and **72 percent of them carry a sentence rather
than a statement**. The comment half is prose by its own mark. The claim half is prose wearing
code's syntax: a Rishi witness says what it proves and names what it refuses, and those two forms
alone account for 18,495 lines.

The reading is free -- it rises with every lap -- so run it rather than trusting the table above:

```
rishi/bin/rishi run tools/l/line_length_census_witness.rish
sh tools/fixtures/l/line_length_census_scan.sh --list
```

## Where the remaining code lines live

The 28,718 that are genuinely code concentrate in three rooms, and each concentration has a cause that wrapping leaves
exactly where it stands.

**`tools/` holds 37,262 long lines of all classes**, the largest single room by a wide margin, and
Rishi is what fills it. Read across the whole family, the 34,342 long Rishi lines come out 11,095
comments, 13,911 `assert`, 4,584 `say`, **4,129 a `run [...]` invocation array** -- an interpreter, a
script path and its arguments, which the Rishi convention keeps on one line -- and 623 everything
else. So Rishi contributes 4,752 lines of genuine code width to a population of 102,153.

**`caravan/` holds 4,866**, and 956 of those are a single shape: `report_out.inner.inner.inner...`,
a chained field access whose width is the ladder's own nesting depth. A rung added tomorrow adds
more of them, and the width comes from the ladder rather than from a writer.

**`crypto/` holds 7,341**, largely published test vectors that stand exactly as their source prints
them. Rewrapping a vector is how a parity proof stops proving parity.

Against that, the hand-written module rooms read small: `tally` 7, `kumara` 32, `rye` 50,
`mantra` 260, `ember` one. The habit the rule describes is alive where a person writes each line,
and absent where a line's width comes from generation, invocation, or a published constant.

## The decision

**The row keeps its place, and its instrument reports where a ceiling would sit.** A ratchet over a hundred thousand lines that
rises whenever a rung is generated would red on ordinary work, which four laws in this tree already
name as the way a guard gets turned off. What the row earns instead is an instrument that publishes
its own number, so a reader meeting *Enforced now* finds a command rather than a figure to trust.

A retirement would have cost something real. The rule still describes a live habit in the rooms
where a person writes each line, and a reader arriving tomorrow deserves to see both the aspiration
and its distance from the tree. A census keeps both visible, which is what a first-day reader deserves.

## What the guard does hold

One gate, and it is the failure a ratchet can never catch. A walk that quietly stops early reports
a smaller population and reads as a cleaner tree. This tree has booked that fault three times: a
shell glob that stopped at `/` after a room folded, `index_row_bound` reading the pin alone over 87
unheld rows, and `log_has_a_row` answering `flat_logs=0` for nine days. So `files_read` is held
against a floor, and a census that lost its corpus refuses rather than celebrating.

Two smaller refusals ride beside it, each in the safe direction. The file list is bounded at 20,000
-- four times what stands today -- so a corpus past it says `corpus_over_bound` rather than being
truncated by the kernel's argument vector. And a path carrying whitespace refuses by name, since
the list is expanded unquoted into one `awk` and a space would split one path into two unreadable
ones: the same fault the ASCII-first widening found in a `for f in docs/*.md` loop, where a spaced
page fell out of a wall in silence.

Two readings are printed side by side, since a column is a display cell and a meter wants every
host to agree. `over` counts bytes under `LC_ALL=C`; `over_display` counts characters in the host's
own locale. They differ by 181 lines, every one of them carrying the non-ASCII residue the
ASCII-first law already meters.

Forty-five legs stand in a throwaway pen, every refusal planted and then lifted, the bound proven
from both sides at exactly 100 and 101 columns, and two mutations of the scan's own text each
carrying an `applied` leg beside the leg it bites -- because a plant that plants nothing passes
every leg it was written for.

Three of the forty-five come ahead of the first plant, and they guard the happy case. Under
`set -eu` a `grep` that matches nothing ends the walk, so a corpus holding no long line at all --
the tree this rule hopes for -- is precisely what an unguarded reader dies on. A sibling scan was
bitten by that lantern earlier the same day, which is why the clean corpus is read first here rather
than last.

## The instrument demonstrates its own finding

Both shell halves of this census hold the rule at zero lines past a hundred, which took two edits:
a `find` predicate wrapped onto a second line, and a locale assignment given a name. Both read the same
to anyone following the code.

The witness beside them carries fifteen lines past the bound -- **eleven an `assert ... else
"sentence"` and four a `say`** -- which is the whole of the `over_claim` class the census counts
apart, with nothing else in it. Shortening them means shortening the refusal a reader meets when
the guard reds, and a refusal that fits a
terminal by losing its reason is a worse line than a long one. So they stand, and they are the
argument in miniature: where the width is code, the bound is free; where the width is a sentence,
the bound asks for the sentence.

## What this does not reach

**Whether any particular long line should be shorter.** The census counts and classifies; a reader
decides. Every file keeps its lines, and a sweep of 28,718 code lines would be churn wearing a
number's clothes.

**The other five extensions' claim lines.** Only Rishi's `say` and `assert` are counted apart,
because only Rishi puts a whole sentence in one statement often enough to move the reading. A Rye
`print` chain runs across several lines and is counted as the code it is.

*May every rule this tree writes down be a rule it can also read back.*
