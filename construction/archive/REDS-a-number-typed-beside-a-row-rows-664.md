# REDS %664 -- a number typed beside a row, where every other number was derived

**Status:** Recovered draft -- checkable; the correction is already landed.
**Original stamp:** `20260908.071624`; the source used an unshared row number.
**Source commit:** `636b12baa0269621fc18d7cb2d563b2e8a239d58` (retained Copal stash).
**Source blob:** `0cd19ad671c784a02d6a34ed8b8c0b7576e6cafe`.
**Recovery:** Only the two row labels change from the parked allocation. The original
account follows whole. Line numbers below describe the original reading.

---

*Folded from the living pin [`../REDS.md`](../REDS.md) on `20260908.072000`, so the pin keeps its
declared bound and holds what is still open. The row is CLOSED on `reds_citation` GREEN, and it is
kept for a shape that will recur every time the derived spine renumbers an unshared row. Three
things spell a row's number when it folds: the shelf's filename, the row header inside it, and the
recital sentence that maps the number to the shelf. A tool derives the first two from the row, so a
renumber carries them along. The third is typed by a hand, at fold time, which is exactly the moment
a rebase is most likely to have moved the number underneath it. `%513` says cite by stamp until the
spine binds the number, and the recital is the one living surface that cannot take that advice --
mapping a number to a shelf is its entire job. So the general reading is written here once: **a
number derived from the row follows a renumber, and a number typed beside it stays where the hand
left it.** Look for the typed one.*

---


**REDS %664 (`20260908.071624`) -- the one surface that must cite a row by number is the last surface a renumber reaches.** *What went wrong:* `construction/archive/REDS-fold-recital.md` line 520 records a fold as *Row %614 folded to [`REDS-a-plant-that-borrowed-a-contract-rows-613.md`]*, and the row inside that shelf reads `REDS %613 (`20260908.053644`)` on the anointed spine. Line 521 legitimately claims `%614` and `%615` for a different shelf, so one number stood bound to two rows across two consecutive lines, and the recital -- the index a reader consults to find which shelf holds a number -- pointed one of them at the wrong file. *What caught it:* `tools/r/reds_citation_witness.rish` at the cold open, on the lap after the fold landed, reporting `fold_disagree=1` with the line, the claim, and the path on one line. *What it taught:* **`%513` says cite by stamp until the spine binds the number, and the fold recital is the one living surface that cannot take that advice** -- its entire job is to map a number to a shelf, so it must spell the number, and it is written at fold time, which is exactly when a rebase is most likely to renumber the row underneath it. The shelf filename and the row header both took the new number because a fold tool derives them from the row; the recital sentence was typed. **A number derived from the row follows a renumber; a number typed beside it stays where the hand left it.** *Repaired (`20260908.071624`):* line 520 reads `%613`, matching the shelf it links and the spine's own binding; `reds_citation` returns `fold_disagree=0`. Booked by COPAL against a row folded by PHEROMONE, whose bytes are otherwise untouched. **CLOSED**
