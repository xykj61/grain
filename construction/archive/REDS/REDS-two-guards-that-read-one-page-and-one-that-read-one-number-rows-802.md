# REDS shelf -- row %802

**Stamp:** `20260917.024418` - **Rows:** `%802` - **Room:** checkable
**Pin:** [`../REDS.md`](../../REDS.md) - **Recital:** [`REDS-fold-recital.md`](REDS-fold-recital.md)

One row about a guard reading a page another reader already held.

`%802` booked a guard seated over a page a sibling guard had already read for a week -- four of its
five command-and-output pairs checked twice under two conventions, and one piece of genuinely new
coverage. The lesson: **before seating a reader, ask what already reads this.** A named roster and
a derived collection cannot see each other, and the derived one reaches further.

This shelf was written to carry `%800` beside it, and a peer folded that row to its own shelf in the
same hour. The published fold stands and this unshared one yielded the row -- the derived-spine law
one instrument over, where the key is the row and the shelf is a view.

The row follows, its relative links re-anchored one directory deeper by
`tools/fixtures/r/reds_fold_reanchor.sh`.


**REDS %802 (`20260916.220211`) -- a guard was seated over a page a sibling guard had already read for a week, and the roster was one lap from growing further into it.** *What went wrong:* `tools/d/demo_output_witness.rish` was seated `20260916.211732` over `docs-geode/demos/README.md`, running the five commands that page prints and reading each answer back. `tools/fixtures/t/tutorial_output_scan.sh`, seated `20260909`, already read command-and-output pairs across a collection of git pathspecs -- `docs-geode/*.md manual/*.md SOURCE.md` -- which holds that page. Measured by running its own `list` verb: it reads the same five fences, at lines 32, 50, 70, 102 and 121, and CHECKS four of them, holding the fifth as outside its derived run roster. **Four of the new guard's five pairs are checked twice under two conventions; the fifth is its one piece of new coverage.** *What caught it:* the next lap, weighing `docs-geode/tutorials/the-first-hour.md` for the roster. A `shown` marker, a `--pairs` reading and the annotated page were built and GREEN at 28 control legs before a read of the candidate page's own history found the sibling naming that page's two mis-attributed blocks **by line, 67 and 99**, a week earlier. The whole build was reverted. *What it taught:* **a named roster and a derived collection cannot see each other, and the derived one is stronger.** The sibling picks what to run by a rule on the command line -- one plain invocation of `rishi` or `sh` naming a tracked script, no redirect, pipe, semicolon or glob -- so a page written tomorrow is covered the day it lands and no page can forget to declare itself. *What was landed instead:* `double_read` in `tools/fixtures/d/demo_output_scan.sh` -- for each rostered page, whether another guard's collection already holds it, read out of the sibling's own `CORPUS` constant with no command run, reported every pass and reachable alone through `--overlap`. It reads **1**. Reported, never gated: two guards on one page is a cost rather than a fault, and which yields is Keaton's word. *What holds it still:* `demo_output` GREEN with `double_read=1` asserted; control **26 legs from 20, 0 failing**, four mutations bitten including the membership test whose removal returns that zero. **BOOKED** -- the reading stands; which guard yields is a hand's word.
