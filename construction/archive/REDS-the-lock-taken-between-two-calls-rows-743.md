# REDS -- row %743, folded from the living pin

**Folded:** `20260915.220549` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*A build lock was created in one call and claimed in a second, so a live holder's lock could be
taken from it in the gap -- and both halves of the protocol read as reasonable alone.*

The row stands here exactly as it was written. A closed row leaves the living pin so the pin stays
the length a reader will actually read; the lesson travels forward in the guard the round built, and
the row itself stays one click away.

---


**REDS %743 (`20260915.211500`) -- a live holder's build lock could be taken from it, and both halves of the protocol were reasonable alone.** *What went wrong:* `rye/src/main.rye` created `.rye-build.lock` with an atomic `createDir` and wrote the holder's pid in a SECOND call, so between them the lock stood with nothing inside -- which the waiter's rule reads as a corpse after two looks and clears, out from under a live holder, which then bridges beside the thief. *What caught it:* an aether rota lap listening for the claim a page repeats. The lock's comment priced that window at *"a maker hanging inside a two-line window"*; the code says one 50ms poll, on a pier at **load average 16.8**. *What it taught:* **a lock published in two steps is unlocked in between, and a grace measured in LOOKS is measured in wall clock under load.** Sharper: `rye_build_lock_reach` read `cross_scope_collisions=0` over a lock stealable INSIDE one scope -- **reach and tenure are two questions.** *Repair:* `build_lock_claim` assembles the lock complete and `rename`s it into place, refusing `DirNotEmpty` when one stands -- the move is both claim and test; the waiter is untouched. *The first repair was wrong, which writing the control found:* a robbed holder writes its own pid over the thief's and reads back what it just wrote. **CLOSED** on `tools/r/rye_build_lock_holder_witness.rish` GREEN, 28 legs, two compilers from tracked sources, one mutation bitten. Full account: the lap's log and the card. *Not reached:* **`rye/bin/rye` is gitignored** -- nothing reads whether an installed compiler matches its source, so this repair reaches a ship only when that ship rebuilds. **The same class fired on this lap in a second binary:** rebasing onto the peer row that landed `out_brief` in `rishi/src/main.rye` left this ship's equally gitignored `rishi/bin/rishi` without the field, so `reds_fold_witness.rish` reads `NoSuchField` and is RED for a reason unrelated to the tree -- GREEN in this lap's own cold pass, before the rebase. The rebuild then refused `FileBusy`, the roster holding the binary open, so the repair wants an install order too. Proposed on the card.
