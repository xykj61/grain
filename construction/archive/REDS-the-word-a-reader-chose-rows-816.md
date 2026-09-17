# REDS -- the word a reader chose

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its reading proven by a control on real git repositories
**Folded:** `20260917.172111` from [`../REDS.md`](../REDS.md)

One row, folded the hour it was written to hold the pin under the 65,536 bytes eight ships share.
The pin stood at 65,341 with twenty-one rows open and nothing foldable, so a shelf was the only
lawful way to land it.

It teaches that two readers over one file may disagree, and that the disagreement is silent
whenever the louder reader chose its own word instead of carrying the quieter one's.

**REDS %816 (`20260917.172111`) -- a reader every ship runs before every build called a board readable while the guard beside it called the same board malformed.** *What went wrong:* `tools/fixtures/f/fleet_claim_scan.sh` printed the fixed word `form=readable` beside its two counts, whatever `tools/fixtures/f/fleet_claim_form_scan.sh` had just answered. The refusal above that line reads `corrupting` alone, which is correct and stays -- a confined finding must not red a peer's board. What was wrong is the summary: on a board carrying confined findings alone the form scan answers `verdict=malformed`, `tools/f/fleet_claim_form_witness.rish` refuses on every ship, and the content reader said `readable` to each one. *What caught it:* the previous lap's own claim, written while repairing a phantom record on the living board, then measured on this lap rather than reasoned about. Replaying the form scan over **all 370 revisions** of `construction/fleet-claims.kyri`: **5** carried corrupting findings, which the reader already refuses, and **14 carried confined findings with corrupting at zero** -- every one a revision where the word was false. The 14 fall in two windows of one class, a `what` sentence holding the literal word `claim` mid-sentence and cut there by a hand: `claim nobody` over five revisions on `20260916`, and `claim against` over nine revisions spanning 83 minutes on `20260917`, during which every ship that opened a lap read `form=readable` before it built. *What it taught:* **a summary line is a reading, and a reading that substitutes its own word for an instrument's has stopped reporting.** The two counts printed beside the word were right the whole time -- `confined=6` stood in plain sight through both windows -- so this was never missing data. It was a sentence a reader could not hear over a word it trusted. *Repaired:* the line carries `form=$form_verdict` off the form scan's own `verdict=` output, prints `form=unread` when that scan answers no verdict at all, and adds one detail naming why a confined reading is reported rather than refused. Proven by `tools/fixtures/f/fleet_claim_form_control.sh`, **47 legs to 54, `control_failures=0`**, six of them new: a confined board carries the form reader's own verdict, is never called readable, and says why the reader carried on; a well-formed board keeps its own word and earns no excuse line; and the mutation restoring the fixed word bites both. `tools/f/fleet_claim_form_witness.rish` reads all six by name and is GREEN on metal. **CLOSED.**
