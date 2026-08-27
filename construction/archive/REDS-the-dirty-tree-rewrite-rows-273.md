# REDS -- row %273, folded from the living pin

**Folded:** `20260827.024604` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The dirty-tree rewrite -- git filter-repo --force resets the working tree to the rewritten HEAD, and six uncommitted seats went with it; a rewrite is a round boundary, so everything commits or stashes first.*

The row stands here exactly as it was written. A closed row leaves the living pin so the
pin stays the length a reader will actually read; the lesson travels forward in the guards
the round built, and the row itself stays one click away.

---

**REDS %273 (`20260826.023323`) -- a third rewrite pass ran over a dirty tree, and --force ate the uncommitted seats.** *What went wrong:* `git filter-repo --force` resets the index and working tree to the rewritten HEAD; passes one and two ran on clean trees, and pass three -- five path renames -- ran with six uncommitted edits standing, which it silently discarded: the ITINERARY standfast lines, the LEXICON and manifest rows, and an index row. Untracked files survived. *What caught it:* the post-pass status read -- two untracked files where six edits should have stood -- before anything was pushed. *What it taught:* the flag's own name says it: --force is a promise that the tree holds nothing worth keeping, and a rewrite is a round boundary -- commit or stash everything, then rewrite. Repaired in the same round from the scripts that made the edits; CLOSED by reconstruction, nothing left standing.
