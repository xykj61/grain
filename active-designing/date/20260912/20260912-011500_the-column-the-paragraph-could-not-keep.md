# The Column the Paragraph Could Not Keep

**Stamp:** `20260912.011500`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **Room:** checkable; every figure below comes from a named command over named
files, and the repair it argues for ships in the same commit
**Kin:** [`20260911-112513_the-table-that-said-enforced-now.md`](20260911-112513_the-table-that-said-enforced-now.md)
-- [`../.claude/rules/gauge-style.md`](../.claude/rules/gauge-style.md) (*what holds a figure still*)
-- [`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md) (*count, never number*)
-- [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
-- [`../tools/l/lint_table_runs_witness.rish`](../tools/l/lint_table_runs_witness.rish)

Yesterday a lap read `context/TAME_GUIDANCE.md`'s lint table one row at a time and found twenty
rows under one heading keeping four different promises. That round landed two instruments and
wrote the split down in a paragraph beneath the table.

**The paragraph was stale the next morning, by the exact size of its own repair.**

## The reading

The sentence, written `20260911.112513`, opens:

> Twenty rule rows stand here; eight lean on five tools a roster pass runs every lap, and six name
> a tool **no lap runs**.

Measured `20260912.011500` against the same two files, by pulling every `tools/` path out of each
row and asking `construction/standing-equipment.kyri` which of them holds a `path` row and at what
tier:

| Reading | `20260911.112513` | `20260912.011500` |
|---|---|---|
| rows a roster pass runs every lap | 8 | **10** |
| rows a roster pass runs on cadence | counted with the above | **1** |
| rows no roster carries | 6 | **9** |

Nothing went wrong in the tree between those two stamps. **The round that wrote the sentence
rostered two of the rows it was counting** -- the title witness and the line-length census, both
seated in that same commit -- so the number was already two short of the tree by the time the file
was saved. The other move is the same fault standing still: three rows name only
`tools/t/tame_style_scan_bans.rish`, which `tools/t/tame_style_check.rish` drives every lap, and a
reading that goes by what a row *names* had to call them hand-run.

## Why a paragraph could never have kept it

Gauge asks a figure for five things, and the fifth is **what holds it still**: pinned, walled, or
free. A count typed into prose is free by construction. This tree has a law for exactly that case --
*count, never number* -- and the reason is visible here at one day's resolution: the split moves
whenever a guard's tier changes, whenever a row is added, and whenever somebody rosters a tool.
Each of those is ordinary work, and each silently falsifies a sentence nobody thought to reread.

The elder paragraph was honest, careful, and measured. It still could not stay true, because the
thing it measured was a property of two living files and the sentence lived in a third.

## The repair

**The split moved into the table, one word per row.** A new **Runs** column carries `every lap`,
`on cadence`, or `by hand`, and
[`tools/fixtures/l/lint_table_runs_scan.sh`](../tools/fixtures/l/lint_table_runs_scan.sh) derives
the true word from the roster -- `tier lap`, `tier cadence`, or no `path` row at all -- and refuses
when a declared word disagrees. Three walls stand at zero: a word that disagrees, a row carrying no
word, and a row naming no instrument for a word to be derived from.

**The heading changed with it.** *Enforced now* claimed a wall over six rows a lap never runs and
one census that measures rather than gates. It reads **Checkable today** now, which is true of all
twenty, and the contrast the section wanted -- against the *Horizon* table below, waiting on a
parser -- survives intact.

**Three rows gained the driver they had always leaned on.** Naming `tame_style_check` inside the
row is the repair, rather than teaching the scan a private map of which scan drives which: a map
inside the instrument would put the relationship in a second place, where the two can disagree and
only one is read.

## What the pen proves

[`tools/fixtures/l/lint_table_runs_control.sh`](../tools/fixtures/l/lint_table_runs_control.sh)
builds its own page and roster in a throwaway pen and stands **32 legs**. Every refusal is planted
and then lifted -- a row understating what runs it, a row overstating it, a cadence guard claiming
every lap, a row with no word, a row naming no tool, a missing page, a missing roster, a section
with no table. Two mutations run a broken copy of the scan and are shown to bite: breaking the
roster's `tier` default, and dropping the section anchor so a decoy table above the heading is read
as the lint surface.

One leg is worth naming on its own. The table is entered at its **delimiter row** rather than at
the first bold rule, so a row somebody adds without bold is counted rather than vanishing. A
population that can silently drop a member is the fault this whole family exists to catch, and the
first draft of this scan had it.

## The guard that caught my own filing

The first draft of this round filed all three files under `t`, for *TAME* -- the subject the page
belongs to. `tools/t/tool_letter_room_scan.sh` read the hot pass and refused: a letter room is
decided by the file's own **first sprig letter**, so `lint_table_runs_*` belongs under `l`, and a
room a reader resolves by name cannot be filed by what the file is about. Three files moved, seven
citing files repointed in the same pass, and the ceiling returned to zero.

The rule is already written in [`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md)
-- *a room whose files are found by WHAT folds by first sprig letter* -- and the fault was mine
rather than the law's. It is recorded here because a guard catching the round that was building
another guard is the plainest evidence there is that both are earning their seconds.

## What this does not reach

**Whether a guard that runs is a guard worth running**, and whether a rule the table states is a
rule worth stating. This holds the table's claim about itself and stops there.

**The six rows that read `by hand`** each stay off the roster for their own stated reason, and five
of those reasons are good ones. The sixth -- `tools/ce/cellar_first_ring.rish` -- still looks
plainly rosterable and still waits on a lap that can measure its cost.

*May the tables in this tree claim only what their rows can keep.*
