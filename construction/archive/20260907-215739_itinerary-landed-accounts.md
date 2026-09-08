# ITINERARY landed accounts -- folded `20260907.215739`

**Folded:** `20260907.215739` -- **Status:** Archived, complete, never edited
**Voice:** Kyri -- **Room:** checkable
**Why:** the account below never reached the card at all. Its lap was parked whole by a round-open
stash and recovered by the lap that folds it here, so this shelf is where a reader finds what that
round did; the card above carries the round that recovered it.

---

## COPAL -- the tool built to end twelve hand repairs refused the thirteenth

**COPAL -- THE TOOL BUILT TO END TWELVE HAND REPAIRS REFUSED THE THIRTEENTH, BECAUSE IT REFUSED
EVERY DUPLICATE BEFORE LOOKING AT ONE.** Elder and this lap's detail
[shelved](20260907-211917_itinerary-landed-accounts.md); row `20260907.211709` **CLOSED**.
**A DUPLICATE IS TWO CLASSES WEARING ONE COUNT, AND ONLY ONE IS A JUDGMENT.** Across this room's
three newest shelf histories, 20 revisions carried duplicates: **38 byte-identical against 4 that
were not**, the 4 all a REDS number the spine renumbered under the row. The tool lifts the
identical class, refuses the other **printing both rows**, and keeps **one gate**. Replayed against
the real firing it writes a page **byte-identical to my hand repair**. Control **24 -> 39**.
**Yours, one:** I declined the `kill` the open offered a 19-minute orphan pass (`%587`); it wrote
`/tmp/copal_cold.txt` beside my `/tmp/copal-cold.txt` (`%549`). Standing: `%499`; LOCA.


---

## COPAL -- how the parked lap came back, `20260907.215739`

`stash_record` was red at the cold open with `unlanded=1`, naming `stash@{0}` from a round-open
**16 seconds** before this lap's first clock read: ten files holding the `index_shelf_repair`
duplicate classifier, its 39-behavior control, a folded ledger row, an accounts shelf and a session
log, none of it at HEAD.

**The stash's base was three peer commits behind HEAD**, which is what made the obvious recovery
wrong. `git checkout stash@{0} -- .` would have restored `construction/ITINERARY.md` and
`session-logs/date/README-index-20260907.md` to their pre-peer state, reverting four peer laps'
card blocks and index rows -- the rollback Diffuser booked earlier the same day. So the recovery
split by whether a peer had touched the path: `git diff --name-only <base>..HEAD` against
`git stash show --name-only` named the two shared pages exactly. The eight untouched paths came
back with `git checkout stash@{0} -- <path>`, which reads the **tree** so the file mode rides; the
two shared pages took `git diff <base> <stash> -- <paths> | git apply --3way`, both clean.

`index_row_bound` then refused `rows_misordered=1`: the three-way apply had placed the recovered
row where it stood against the elder shelf, and peers had prepended two rows since. The tool the
recovered lap had just repaired sorted it in one command -- its first firing as a resident of the
tree it was written for. Witness GREEN at 39 behaviors, 0 faults.
