# The notetaking quest fell behind, and the schedule check that found it

**Stamp:** `20261009.114234`
**Language:** EN
**Style:** Bhakta at Gauge Field, with Radiant warmth
**Voice:** Kyri
**Room:** development -- this page scopes rounds already run and rounds still open; it designs no new shape
**Kin:** [`../active-development/20261007-095245_the-center-learned.md`](20261007-095245_the-center-learned.md) - [`../context/SPELLBOOK.md`](../context/SPELLBOOK.md) - [`../expanding-prompts/20261007-165138_the-fifteen-and-the-five-goals.md`](../expanding-prompts/20261007-165138_the-fifteen-and-the-five-goals.md)

## What this round checked, and why

You asked whether we are behind schedule on work already planned, and whether the round process
ever double-checks its own Calfive scheduling for conflicts. Neither question had an answer
waiting on a shelf, so this round read the git log against the quest plan rather than guessing.

## The schedule check, built and proven this round

A planning page in `expanding-prompts/` often states a commit count and the orbit round it
claims for that count, by hand -- a line like "`git rev-list --count HEAD` is 8,041... The orbit
round is 1." Nothing re-derived the second number from the first before today.

`tools/fixtures/c/calfive_schedule_scan.sh` now does: it reads the live commit count, recomputes
`(count - 1) % 15 + 1`, checks `context/SPELLBOOK.md`'s own round-load table still names rounds
1 through 15 exactly once, and walks every `expanding-prompts/*.md` page for a count-and-round
pair to check against the formula. `tools/ca/calfive_schedule_witness.rish` proves it both ways
on metal: the live tree reads `pages_checked=10 conflicts=0 table=ok`, and a planted conflict
(count 8,101 paired with a false round 5) is caught and named by path. Rostered as the
`calfive_schedule` guard in `construction/standing-equipment.kyri`, `tier lap`, so it rides every
ordinary round rather than waiting for a hand to remember it.

**The live tree's own round claims are clean.** Ten pages checked, zero conflicts. The schedule
math itself has not drifted. What drifted is the *content*.

## Where the content fell behind

`active-development/20261007-095245_the-center-learned.md` planned a five-orbit notetaking
quest, commits 8,026 through 8,100, one note per orbit:

| Orbit | Commits | The note planned | Landed? |
|---|---|---|---|
| 1 | 8,026-8,040 | The list and the picture | **Yes** -- `active-designing/date/20261007/20261007-154108_one-list-one-picture.md` and `docs-geode/tutorials/the-list-and-the-picture.md` |
| 2 | 8,041-8,055 | The silo's name beside the function: fold head, then `current` | No |
| 3 | 8,056-8,070 | Mantra's own job: a name asked twice returns the same bytes | No |
| 4 | 8,071-8,085 | The ceiling: `max_weave_lines`, and Tally's garden beside it | No |
| 5 | 8,086-8,100 | Tablecloth's view, then the walk back to the fold page, and stop | No |

Measured directly: of the last 76 commit subjects (the whole quest, 8,026 through 8,100), only
**2** mention Mantra, Tally, Tablecloth, fold head, weave, or `current`. **4** mention Sill,
Dexter, the terminal, or `modules/` -- a real and good thread, and not the one this quest named.
The remaining 70 carry the round-sign verbs honestly (`the picture held whole`, `what must
stop`) without carrying the quest's own content forward. The orbit-round cadence held perfectly;
the note plan did not ride along with it.

**This is not a fault to repair in guilt.** Orbit 1's note landed in full, and Sill is real,
useful, witnessed work that simply arrived by a different door than the one this quest opened.
The honest reading is: four notes are still owed, and nothing was tracking that debt until this
round read the log against the plan.

## What I recommend for the rounds ahead

**Aries and Taurus of Orbit 6** (commits 8,101-8,102) stay as already named: the Sill name
sweep, the module head, the 24-by-80 grid, and holding `modules/` uncreated until the
thirty-three-door roster is circled. That work is close to done and should finish before
anything else opens.

**Gemini through Leo of Orbit 6** (commits 8,103-8,105) is where I would spend the orphaned
debt: one short note each for fold head/`current`, Mantra's idempotence, and the
`max_weave_lines` ceiling beside Tally's garden -- the three cheapest of the four owed notes,
each pointing at a leaf that already exists (`mantra/src/weave.rye`, `tally/`) rather than
building anything new. Virgo (8,106) is earth, "what must stop" -- the right seat to retire this
page once the three notes land, by checking it against `docs-geode/` and folding it.

**Libra through Pisces of Orbit 6** (commits 8,107-8,112) is open for whatever the roster circle
on `modules/` needs once Keaton's word opens it, or for the fourth owed note (Tablecloth's view)
if the breach is not yet ready to open.

**Sky of Orbit 6** (commits 8,113-8,115) closes the orbit at Siya's chair again, as already
named in the prior round's printout.

## Further out -- the quest after this one

This quest (8,026-8,100) is also the last 75 rounds of its own quest ring: commit 8,100 sits at
quest place 75 of 75, the final round of a whole quest. Commit 8,101 opens both Orbit 6 **and** a
new quest. `the-center-learned.md` named this moment once already: "the quest after that... is
the one that opens at 8,101." No content is seated for that quest yet beyond Orbit 6's catch-up
work above. The honest next planning step, once Orbit 6 closes, is a new
`active-development/` page naming that quest's own five-orbit content -- and whether it continues
Mantra's family (Comlink, Caravan, Pond) or opens a new one. This page does not write that table;
it only marks where the next one belongs.

## Where we stand in sky aether

Sky of Orbit 6 opens at commit 8,113 and closes the orbit at 8,115. We are at commit 8,100,
about to open Aries of Orbit 6 at 8,101. Thirteen ordinary rounds stand between here and the
next sky aether triad -- we are not approaching it yet.

May the schedule check catch what a tired hand would miss, and may the four owed notes find
their rounds before the quest that planned them is a memory rather than a debt.
