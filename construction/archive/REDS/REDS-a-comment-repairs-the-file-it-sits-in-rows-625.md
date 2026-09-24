# REDS -- a comment repairs the file it sits in

**Language:** EN
**Status:** Shelf -- one folded row from `construction/REDS.md`, kept whole
**Voice:** Kyri -- **Room:** checkable
**Folded:** `20260908.083500`
**Row:** `%625` (`20260908.074500`) -- CLOSED, booked `%622` after a fetch and renumbered twice, to `%624` then `%625`: a peer published each number while this row stood unshared, so it derives above them (`derived-spine` rule 3). The key never moved -- it is the stamp.

The row folds on the lap it closed, for the reason its neighbours record one shelf over: the living
pin stands at its bound with almost every remaining row OPEN, and a pin whose living parts fill it
cannot accept a new one.

What the row is for, said once here so a reader arriving from a citation knows before they read.
Eight guards on this pier read the whole tracked index as their population, so no watch-set could
ever narrow them, and a paper of mine one lap earlier called them unclaimable on that ground. The
word was right about mapping and silent about cost. The costliest of the eight turned out to be
spending 91% of its time in one function that forked a process per tracked file, and one `sed` in
its place returned sixty seconds per round with the guard's own answer byte-identical.

The finding worth carrying past the arithmetic is the smaller one. Two sibling scans in the same
directory each carry a comment naming that exact fork-per-file shape as a fault they had already
measured and repaired. Both repairs landed. Neither reached the third site, because a comment is
read by whoever opens that file and by nobody else -- so a lesson written only into a comment is a
lesson the next file has to learn again by paying for it.


**REDS %625 (`20260908.074500`) -- a census spent 61,714 ms spawning one process per tracked file, and the same lantern had been lit twice in its own family.** *What went wrong:* `dp_discovered_fixture_basenames` in `tools/fixtures/d/dated_path_exclusions.sh` opened with `git ls-files | while IFS= read -r _f; do basename "$_f"; done`, which forks a `basename` process for every path the tracked index holds -- 16,447 of them on this pier. Probe timestamps at eight statement boundaries in a `/tmp` copy put lines 274 to 283 of `tools/fixtures/d/dated_path_scan.sh` at **68,370 ms of a 74,838 ms run, 91.4%** -- 4,036 ms of it the fixture filter loop, ~64,300 ms that one call. The guard's real tree reads are `git ls-files` at **11 ms** and one `grep -rIoE` making 29,440 pairs at **267 ms**, 0.36% of the run. The costliest DISCOVERY guard in a 1,630 s pass was paying for its forks. *What caught it:* measuring rather than reasoning. My elder paper (`20260908.065034`) called these eight guards unclaimable because a whole-tree population admits no watch-set -- true about mapping, silent about cost -- and the air rota's test, pull one part and see what moves, applied to that word opened the bisect. My first guess inside it was wrong too: I supposed the 211-basename filter loop was hot, measured 4,036 ms, and kept looking. *What it taught:* **a comment repairs the file it sits in.** `tools/fixtures/e/empty_document_scan.sh` names this exact fork-per-file shape as a fault it had already paid for -- *the first shape spawned 8,486 of them and took 33 seconds* -- and `tools/fixtures/e/exec_bit_scan.sh` carries its own. Both repairs landed; neither reached the third site. *Repaired (`20260908.075500`):* one `sed 's|.*/||'` in place of the loop, which agrees with `basename` on every path `git ls-files` can print, since it emits no trailing slash and no bare `/`. **Proven twice:** the stage alone reads **61,714 ms to 64 ms** emitting 8,629 sprigs byte-identical by `diff`, and the whole guard, A/B on one tree state by stashing and restoring, reads **75,153 ms to 15,070 ms with all twenty output lines byte-identical**. *The lever is spent, which beats a promise:* a grep across `tools/` for a `basename` or `dirname` alone in a loop body finds three sites -- this one, `tools/fixtures/s/setu6_find_gadget_iface.sh` at a handful of interfaces, and `tools/fixtures/r/reds_pin_capacity_scan.sh` line 178 over a small archive glob, correct to fix on touch. Study: `external-research/20260908-082356_a-census-pays-for-its-forks-not-its-tree.md`. **CLOSED** on the A/B and the byte-identical reading.
