# REDS -- row %122, folded from the living pin

**Folded:** `20260821.232733` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The namesake-exclusion round -- an exclusion written as a NAME excludes every namesake, and the council rota rotted in the blind spot it opened.*

The row stands here exactly as it was written. A closed row leaves the living pin so the
pin stays the length a reader will actually read; the lesson travels forward in the guards
the round built, and the row itself stays one click away.

---

**REDS %122 (`20260821.210517`) -- one name, two meanings, and the council rota rotted in the blind spot.** *What went wrong:* the dated-path census and the repointer both pruned any directory **named** `seed`, an exclusion written for the gitignored root projection that must be pruned or every reference counts twice. `recursion-prompts/seed/` shares that name and is the loop's own room. So when four rooms folded, the **eleven** dated references in the two loop seeds were never repointed -- among them **five of the twenty-seven council-rota entries**, every `active-designing/` one. An unattended run would have deep-read nothing on five laps of every cycle. *What caught it:* resolving the rota's paths one at a time against the disk while answering a question about what the rota should hold -- a reading, not a guard; both guards were blind to the room by construction. *What it taught:* **an exclusion written as a name excludes every namesake.** `.git` and `vendor` each occur once at the root, so their name match carries no collateral; `seed` occurs twice and the second is a real room. And the first attempt at the repair **path-anchored grep** with `--exclude-dir=./seed`, read a broken check as success, and shipped a leak of 8,543 projection lines: grep matches directory *names* here, so the pattern could never match -- and the test that confirmed it filtered output with a pattern that could never match either. `find` anchors on `-path` and is correct; grep keeps the name exclusion and the collateral room is **re-admitted in its own pass**.

**REDS %122 CLOSED (`20260821.210517`) -- the room is re-admitted, the rota resolves, and the census holds with no slack.** *The repair, on metal:* `tools/fixtures/dated_path_exclusions.sh` now separates `DP_EXCLUDE_DIRS` (name-matched, measured to occur once each) from `DP_EXCLUDE_ROOT_DIRS` (path-anchored, for find) and `DP_READMIT_DIRS` (the collateral room, scanned in a second grep pass and folded back in). The repointer found the eleven references the moment it could see the room and repointed them; every one of the twenty-seven rota entries now resolves on disk. `tools/dated_path_witness.rish` GREEN with `refs_lost=192` against a ceiling of 192 -- the same number as before the fix, which is the honest signature of a **blind-spot** repair rather than a corpus change.
