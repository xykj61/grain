# REDS -- the roster sets the cost, not the corpus

**Language:** EN
**Status:** Shelf -- one folded row from `construction/REDS.md`, kept whole
**Voice:** Kyri -- **Room:** checkable
**Folded:** `20260908.092049`
**Row:** `%631` (`20260908.091312`) -- BOOKED, both instances repaired and proven on metal.

The row folds on the lap it booked, for the reason its neighbours record one shelf over: the living
pin stands eleven bytes under its bound with every other row OPEN, so a pin whose living parts fill
it cannot accept a new one.

What the row is for, said once here so a reader arriving from a citation knows before they read.
A census in this tree walks the whole corpus and answers in seconds, and the instinct when one runs
slowly is to narrow what it reads. This row measured the opposite. The corpus -- 16,447 tracked
files and 28,396 reference pairs -- was read in 2.2 seconds, while two small rosters of 219 and 365
names were iterated for 13.3 seconds, because each name started a process and rewrote a file. The
repair kept every semantic the slow form carried, including the one nobody intended: a basename's
`.` matches any character, so the fastest rewrite would also have been the wrong one.

Study: [`../../external-research/20260908-091705_the-roster-sets-the-cost-not-the-corpus.md`](../../external-research/20260908-091705_the-roster-sets-the-cost-not-the-corpus.md).


**REDS %631 (`20260908.091312`) -- a subtraction that removed nothing cost 8,976 ms, because a loop's price is its roster rather than its corpus.** *What went wrong:* `tools/fixtures/d/dated_path_scan.sh` subtracted 219 planted fixture basenames from its reference pairs by rewriting the whole 28,396-line pairs file once per name -- a `grep` process and a `mv` each time. Isolated on the exact pre-loop file it cost **5,179 ms and removed zero lines**, which is the expected reading rather than a fault: a planted name is built to name nothing. One file over, `dp_discovered_fixture_basenames` in `tools/fixtures/d/dated_path_exclusions.sh` ran a `printf` subshell, a `sed`, and a `grep -qxF` for each of 365 candidates -- up to 1,095 processes for **4,329 ms**. Together they held **13,305 ms of the guard's 14,610 ms**, while every read of the tree it measures -- two greps and `git ls-files` -- came to 2,232 ms, **15.3%**. *What caught it:* probing the guard at eleven statement boundaries after `%622` closed its first fork loop, on the plain suspicion that a stage dismissed at one tree state is worth re-reading once the stage above it is gone. The candidate loop is exactly the 4,036 ms `%622`'s lap measured, recorded as a wrong guess, and kept looking past -- right, merely smaller, and 63% of what remained. *What it taught:* **count the roster, not the corpus.** A slow scan invites narrowing what is read; here the corpus is 16,447 files read in 2.2 s and the two rosters are 219 and 365 names iterated for 13.3 s. Measured directly on this pier: a trivial `sed` in a pipe **3.4 ms**, a `grep` against `/dev/null` **5.1 ms**, a builtin command substitution **0.8 ms**, a `mv` of the pairs file **3.5 ms** -- five constants that reconstruct both loops. *Repaired (`20260908.091312`):* the subtraction is one `grep -f` over a pattern file, **5,179 -> 397 ms**; the candidate filter is one `awk`, **4,329 -> 14 ms**. Whole guard **14,610 -> 6,879 ms**, all sixteen output lines `diff`-identical, and **10.9x** against the 75,153 ms this arc opened at. *The trap named rather than stepped in:* every one of the 219 basenames carries a `.`, which in a basic regular expression matches any character, so a rewrite to a literal suffix test would have been faster still and would have quietly changed the reading -- the fast form must inherit the slow form's semantics including the unintended ones. Proven on the tree and on 30 planted lines across five shapes, both forms removing the same 18. A blank roster line would become `:.*$` and empty the census, so the elder loop's own emptiness guard moved into the `sed` rather than leaving with the loop that held it. *Third spelling of one shape in one family*, after `%622`'s basename-per-file: what it wants is a check that reads for the shape, held one round because its false-positive rate is unknown and a meter that reds on legitimate small loops is a meter someone turns off. **BOOKED** -- both instances repaired and proven, the remainder a check nobody has sized. Study: `external-research/20260908-091705_the-roster-sets-the-cost-not-the-corpus.md`.
