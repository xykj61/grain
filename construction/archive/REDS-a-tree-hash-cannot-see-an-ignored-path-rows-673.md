# REDS -- a tree hash cannot see an ignored path

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- one ledger row, closed by a control on metal
**Folded:** `20260909.220903` from [`../REDS.md`](../REDS.md)

One row, and it is about the instrument every convergence claim in this tree leans on. A prover
that compares `git write-tree` before and after a run reads exactly what git is willing to stage,
so a tool writing to a path `.gitignore` denies moves nothing the prover can see. This tree denies
its whole root and allows paths back one at a time, which makes the blind spot wide rather than
narrow. The repair asks the cheap second question -- did any file's bytes change where the hash
said nothing moved -- and prints the paths by name.

**REDS %673 (`20260909.210541`) -- the prover that settles every convergence claim compares a tree hash, and a tree hash cannot see a path git ignores.** *What went wrong:* `tools/c/convergence_tree_prove.sh` compares `git add -A` plus `git write-tree` before and after each run, and `git add -A` stages nothing `.gitignore` denies. This tree denies its **whole repository root** -- `/*`, then allow-backs one directory at a time, because the checkout sits inside a sandboxed home holding the editor, credentials and personal files -- so a file written there moves the disk and moves no hash. Both halves were proven RED on metal in a pen before the repair: an operator appending to an ignored `notes.txt` on **every** run, which diverges every time it is called, read `inert`; and a perturbation writing an ignored root file read `perturb_inert`, whose own words are *the sample never landed* while the file sat right there. *What caught it:* a hand paying the fault rather than reading about it. Proving `tools/fixtures/r/readme_metrics_splice.sh` took two tries, the first writing its block file to the pen root and reading `perturb_inert`. The water rota row asks a lap to run the instrument up close rather than read the sentence about it, and this is what running it returned. *What it taught:* **a comparison names the world it can see, and every verdict it prints is a claim about the whole world.** `inert` says *the tree exercised no path* -- a statement about the subject, made by an instrument that never looked where the subject wrote. *Repaired the same lap:* `unseen` and `perturb_unseen` read `git status --porcelain --ignored=matching`, refuse by name and print the paths, asked only where the hash has just said nothing moved, so the ordinary path pays none of the 0.15s. Proven both ways in `tools/fixtures/c/convergence_tree_prove_control.sh` (34 -> 42 checks) by one operator across two pen repositories differing only in their `.gitignore`, every new leg shown failing with the repair removed -- which is how one leg was caught passing on the recital of its own `perturb=` line rather than on the verdict. **CLOSED** -- `tools/c/convergence_tree_prove_witness.rish` GREEN.
