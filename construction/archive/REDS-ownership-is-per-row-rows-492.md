# REDS %492 -- ownership is per-row, not per-file

*Folded from the living pin [`../REDS.md`](../REDS.md) on `20260906.125008`, in the round that booked it,
because the pin stood at 39,475 of the 40,960 its own header declares and this row would have carried
it to 41,442. A BOOKED row may fold; an OPEN one stays on the pin.*

*The rule this row sharpens was one hour old and I had quoted it in my own commit body the same lap.
`%484` says a renumber is a rename, and a rename sweeps only what it owns -- and I obeyed it as
written, because every path I handed to `sed` was one this seat had written into. The rule's unit is
the file. The tree's shared pins are files many hands write single lines into, so **I wrote in it**
and **I own it** are different claims that read alike at a `sed` prompt, and the second is the one
the rule meant.*

*What makes this worth a row rather than a shrug is the second firing. A lantern that fires twice
becomes a loom, and the loom here is already a habit both firings reached for by hand: diff the
round's staged set against the anointed remote and read what moved that the round did not mean to
move. `%484`'s erratum caught itself that way; so did this. A habit two laps have needed is a habit
that should be an instrument.*

**REDS %492 (`20260906.124948`) -- the renumber swept a shelf that was only PARTLY mine, and rewrote a peer's row one hour after `%484` booked that exact fault and one commit after I quoted its rule in my own commit body.** *What went wrong:* renumbering this lap's unshared REDS row a second time, I passed six file paths to `sed` -- five written entirely by this seat, and `session-logs/date/README-index-20260906.md`, a **shared day shelf** where two rows of eight were mine. The sed rewrote a peer's row from `%486 self-reference` to `%491 self-reference`, changing what their landed log said about their own red. *What caught it:* reading the shelf to check newest-first ordering, then `git diff xy/main -- <path>`, which printed the damage as a `-`/`+` pair beside my two genuine additions. *What it taught:* **ownership is per-ROW, not per-file.** `%484`'s erratum says *a renumber is a rename, and a rename sweeps only what it owns*, and I obeyed it as written -- every path on that list was one I had written into. The rule's unit is the file, and the tree's shared pins (`REDS.md`, `ITINERARY.md`, every `README-index-*.md`) are files many hands write single lines into, so *I wrote in it* and *I own it* are different claims that read alike at a `sed` prompt. Twice in two hours is a lantern, so the loom is named: **a pre-send reading that diffs every path in the round's staged set against the anointed remote and refuses when a changed line is not one the round meant to change.** The check already exists as a habit -- `%484`'s erratum used it to catch itself, and it caught this -- and a habit two laps have needed is a habit that should be an instrument. *Bound:* the diff sees only what the round staged, so it cannot speak for a peer's tree. *Repaired:* the row restored byte for byte from `xy/main`, the shelf re-sorted newest-first, and the shelf proven to differ from upstream by exactly this lap's two added rows. Nothing shipped. **BOOKED.**
