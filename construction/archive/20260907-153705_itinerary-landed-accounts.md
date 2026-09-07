# ITINERARY landed accounts -- folded `20260907.153705`

**Language:** EN
**Status:** Landed accounts, folded from [`../ITINERARY.md`](../ITINERARY.md) -- **checkable room**:
every number below was measured on metal and names the instrument that read it
**Voice:** Kyri
**Room:** checkable

*The live front holds what is OPEN and what waits on Keaton's word; a landed account folds here, the
way a REDS row folds to its shelf. Nothing is edited on the way down.*

---

## GRASS -- a page that calls itself living is not testimony (`20260907.145113`)

Row `20260907.145113` BOOKED and folded, by stamp. A mark-law test for **path references** was
borrowed to ask whether a page's **prose** obeys the word bans: **555** pages fall to it, **147**
declaring `Living` -- including the threshold page every ship opens on row 3, which said the retired
word where its source reads *first resident*. Roster **379 -> 520**, duty 1 **0 -> 3**, control
**10**. Three reds closed first. Full account:
[`20260907-145113_itinerary-landed-accounts.md`](20260907-145113_itinerary-landed-accounts.md).

---

## GRASS -- a reading of nothing is not a clean tree (`20260907.153705`)

Row `20260907.153705` BOOKED, cited by stamp until the anointed spine binds it.

`tools/fixtures/l/retired_word_scan.sh` reads a roster of living pages on stdin and names every
retired word in them. Fed nothing -- an empty pipe, a producer that died, a roster whose paths have
all moved -- it walked its `while read` loop zero times and printed `retired_word_files=0`,
`retired_word_hits=0`, exit 0. **That is byte for byte what a swept tree gives.** Its one live
caller, duty 1 of `tools/fixtures/l/living_docs_lint_scan.sh`, spelled the call
`> "$TMP/d1raw" 2>/dev/null || true` and then supplied the zero itself with `${d1_files:-0}`, so a
dead roster published `OK   duty1 retired LEXICON words -- none across 0 living prose pages`. The
word OK over a reading of nothing, with the number that disproves it inside the same line.

**Demonstrated before the repair, on metal:** `false | sh <scan>` run through the caller's own three
lines prints exactly that sentence. A quieter half rode with it -- the loop's `[ -f "$rel" ] ||
continue` silently skipped a roster path that had moved, so a partial move shrank the corpus with no
word said.

**What caught it** was the fire rota row -- lap 4192, row 2, *cut and stop* -- run against my own
last lap's scan. Fire's page asks a lap to look hard at the thing it would rather route around, and
the likeliest wrong thing in this tree is what the same hand built the lap before.

**Repaired.** The scan counts absent roster lines, prints `retired_word_absent=` beside the two
existing readings, and when **no** file was read exits **2** naming which shape it met:
`roster_empty` when the roster held no line, `roster_all_absent` when every line it held has moved.
Two words rather than one, because an empty roster sends a reader to the producer and a vanished
corpus sends them to the tree. Exit 2 is this tree's word for a reading that could not run (`%567`),
kept apart from 1 so a caller tells a refusal from a finding. A **partial** absence is reported and
never gated -- a path moving mid-pass is ordinary work. The caller reads the exit code and the
scan's own stderr, printing `ADVISE duty1 unread`, plus a second advisory when `absent` stands above
zero; duty 1 stays advisory, since a lint that refuses the tree is a lint someone turns off.

**Proven both ways.** `tools/fixtures/l/retired_word_control.sh` grows **10 behaviors to 14** -- the
empty roster and the vanished corpus each refused by name at exit 2, a mixed roster still read at
exit 0 reporting `files=1 absent=1`, and the load-bearing leg: the refusal block stripped out of a
copy of the scan, so the same empty roster walks free at exit 0 and the guard is told apart from a
bypass. That leg also refuses to pass when the block it deletes is absent, which is `%519`'s own
lesson applied to this control's own plant. Against a deliberately disarmed scan the control answers
`MISSED` five times and `control_verdict=MISSED`; restored, `ok`.

**The live reading is unchanged: 520 pages, 4 advisories, 0 absent.** Grades: scan **A (90)**,
control **B (84)**, caller **A+ (100)**.

**Third firing in one lane.** `%540` found this scan's roster reading a fourteenth of the tree,
`20260907.145113` found its mark-law test charging a page's prose to a path rule, and this is the
reading itself. Each was the same shape one layer in: an instrument describing a subject it had not
actually read.

**A cost this lap paid, and names rather than hides.** The three edits above landed while the cold
roster pass was still walking, so its close will read `tree_moved` -- the baton says hold still while
it runs, and I did not. Fifty-two guards had already answered green when the first edit landed, and
the honest green for the tree this commit ships is the `--hot` pass after `git add`.
