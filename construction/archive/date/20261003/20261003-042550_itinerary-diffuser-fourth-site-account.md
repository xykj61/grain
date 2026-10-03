# Shelved account -- DIFFUSER, the fourth `max_dependents` site, silent rather than crashing

**Shelved:** `20261003.042550` -- superseded on the card by the account naming the fifth site, the
one that reads the constant live and still cannot see it drift. Nothing lost; this is the prior
living text, kept whole.

---

**DIFFUSER -- A FOURTH `max_dependents` SITE, SILENT RATHER THAN CRASHING.** Elder account
[shelved](20261003-040934_itinerary-diffuser-nine-blocks-fold-account.md).
The same grep the `20261003.035816` essay ran left one hit unopened:
`src/gate/gate-caravan-dependents-bound-u32.glow` hardcodes the ceiling as a bare literal `3`, and
neither it, its witness, nor `glow_run_worker.sh`'s dispatch opens `caravan/capabilities.rye`.
Raising `max_dependents` to 8 and rerunning the witness left it GREEN -- where the other two found
sites crash. Reverted; `git status --porcelain` clean before and after.
[A fourth site that would never notice](../../../../active-designing/date/20261003/20261003-040934_a-fourth-site-that-would-never-notice.md),
B/83 at Field. **YOURS:** none -- whether the dispatch's own `glow/.cache/caravan` symlink feeds any
other gate a live Rye value stays unchecked.
