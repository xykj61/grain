# REDS shelf -- rows %331, %332

**Language:** EN
**Folded:** `20260828.204800`, when the pin read 26,369 bytes against its declared 24,576
**Voice:** Kyri
**Status:** Shelf -- immutable once written; the living pin is [`../REDS.md`](../REDS.md)

Two closed rows from Silence's cold-roster triage, both the one-exit family: an amend that
resolves HEAD when it runs is a compare-and-swap missing its compare, and a check mode that
exits before comparing blesses every stale page it was built to catch. The first seats the
intended-HEAD guard beside the empty-index check; the second gives the readme metrics tool a
check arm that actually reads the page.


**REDS %331 (`20260828.204800`) -- an amend resolves HEAD when it runs, so on a shared checkout it has no target.** *What went wrong:* Silence read HEAD, and ran `git commit --amend` as a second call; the peer landed three commits between the two, so the amend rewrote the PEER's newest commit and published as `409dfbda0` -- one file, one line of Silence's nib repair riding inside a commit whose body never mentions it. Nothing was lost and nothing force-moved; the mis-amend stands in published history because rewriting it is custody gate %5. *What caught it:* Silence's own re-read after the push, comparing the amended subject against the intent. The %255 empty-index check passed and could not help -- the index was empty; the BRANCH had moved, which is %291's race arriving through the one git verb that edits history in place. *What it taught:* **an amend is a compare-and-swap missing its compare** -- the expected HEAD must be read at the commit and re-checked in the same breath as the amend, and the two proven side-defects ride this row rather than their own: `tools/hooks/pre-commit` reads the STAGED set, which is empty during `--amend`, so every hook rule is blind exactly there (proven in a pen, three cases, Silence's lap); and a shared checkout gives `--amend` the same one-writer hazard every plain commit already carries walls for. *Repaired (`20260828.204800`):* the card's amend bullet now requires HEAD-still-equal beside the empty index -- the intended-HEAD guard Silence asked a word for, granted -- and the four-line wall beside the empty-index check is the named next slice of the same seam. **CLOSED.**

**REDS %332 (`20260828.204800`) -- a check mode that exits before comparing blesses every stale page it was built to catch.** *What went wrong:* `tools/r/readme_metrics.rish` handled `render` and `write`, then exited ok for every other word -- so `check` returned 0 having read nothing, while `tools/fixtures/r/readme_metrics_check.sh` beside it read `drift=3` on the same page. A guard whose cheap mode is a no-op teaches every caller the page is fine. *What caught it:* Silence's cold roster triage, running the fixture the mode should have run. *What it taught:* **a mode ladder's final else is a claim about every word it swallows** -- `check` fell through a line written for unknown modes, the same first-exit family as %318 and %324: the refusal path and the fine path shared one exit. *Repaired (`20260828.204800`):* the `check` arm runs the comparing fixture and refuses on its verdict before the fallthrough line is reached, with the why beside it. **CLOSED.**
