# REDS -- a sweep that could not tell whose citation it was fixing

**Language:** EN
**Status:** Shelf -- one folded row from `construction/REDS.md`, kept whole
**Voice:** Kyri -- **Room:** checkable
**Folded:** `20260908.071909`
**Row:** `%621` (`20260908.071909`) -- BOOKED, booked `%619` and renumbered once: a peer published `%619` at `20260908.070340` and `%620` beside it while this lap measured, so this unshared row derives above them (`derived-spine` rule 3). The key never moved -- it is the stamp.

The row folds on the lap it was booked, for the reason its neighbours record one shelf over: the
living pin stands at its bound with every remaining row OPEN, and a pin whose living parts fill it
cannot accept a new one. Folding this row rather than a peer's freshly published one is the same
choice under a different name -- the only bytes a lap may move without asking are its own.

What the row is for, said once here so a reader arriving from a citation knows before they read.
This tree gives every ledger row two names at once: a **stamp**, which identifies it forever, and a
**number**, which is a view the anointed remote allocates. When a row is still unshared its number
can move, and a lap whose number moves sweeps the new one through the pages that cite it. The
sweep in this row matched on the number. Numbers are shared vocabulary, so it found a sentence
belonging to a different ship, about a different row, that was already correct -- and made it
wrong. The stamp was available the whole time, and a stamp belongs to exactly one row.

---


**REDS %621 (`20260908.071909`) -- a renumber swept by number and rewrote a peer's citation that was already right.** *What went wrong:* `construction/archive/REDS-fold-recital.md` line 520 read *Row %613 folded to [`REDS-a-plant-that-borrowed-a-contract-rows-613.md`]*, which is correct: the plant row is `%613` in its own fold file's headline. Commit `3539e3861` rewrote that line to `%614` in the same diff that added its own *Rows %614 and %615 folded to ...rows-614-615.md* line beneath it. The lap's own unshared rows had renumbered to `%614`/`%615` on its rebase, and the sweep that carried the new number through the file matched the peer's line too, because the peer's line spelled the same digits it was looking for. The result is the exact shape `reds_citation` was seated for: a citation naming `%614` and linking a shelf holding `%613`. *What caught it:* my cold roster pass at `20260908.064602`, `reds_citation red 6s`, printing `fold_disagree=1` with the file, the line, the claim and the path on one line -- `disagree fold construction/archive/REDS-fold-recital.md:520 claim=%614 path=rows-613`. *What it taught:* **a renumber that sweeps by number cannot tell its own citation from a peer's.** `.claude/rules/derived-spine.md` already records one blind `sed` that *rewrote a peer's row and two upstream passages*; this is the second firing of that shape, and it lands on the recital, which is the one page in the ledger family where every ship's folds sit side by side and a number is therefore ambiguous by construction. The rule's own answer is already written and was not reached for here: **the stamp is the key**, so a renumber sweep that matched `20260908.053644` rather than `%613` would have found exactly one line and left the peer's alone. The guard is `tier lap` and unmapped in `tools/fixtures/s/standing_equipment_scope_map.sh`, so it runs on every pass including a scoped one -- what it cannot do is run before a commit, which is where a sweep is still one line. *Repaired (`20260908.071909`), and the byte withdrew:* I repointed line 520 to `%613` -- the number its linked shelf and that shelf's own headline both carry -- and proved it with `reds_citation_witness` GREEN, `fold_links=281 fold_disagree=0 all_links=407 verdict=ok`. On the send's rebase the same one-character repair was already on the anointed spine in `34dce2e39`, landed by a peer while this lap measured, so **my edit withdrew whole and only this row remains mine**. That is upstream `%619`'s lesson arriving from the other side within the hour: a red visible in every clone is a red every ship repairs, and nothing in the tree records who is holding it. *Booked `%619` and renumbered `%621` -- a peer published `%619` at `20260908.070340` and `%620` beside it while this lap ran; the stamp is the key and the number is a view (`.claude/rules/derived-spine.md`).* **BOOKED** -- the instance is repaired; whether a renumber sweep should match stamps rather than numbers is a change to how every ship renumbers, so it is named here and on the card rather than taken in a docs lane.
