# REDS -- row %581, folded from the living pin

**Folded:** `20260907.160524` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*A number allocated by reading a tree is allocated per COMMITTED tree, and the round-open's stash
makes an uncommitted row ordinary rather than exotic.*

The row stands here exactly as it was written. A closed row leaves the living pin so the pin stays
the length a reader will actually read; the lesson travels forward in the derived-spine law itself,
whose six recorded firings are all pairs of trees while this one needed no second host at all, and
the row itself stays one click away.

---


**REDS %581 (`20260907.155612`) -- one checkout collided with itself on a ledger number, because an unlanded row is invisible to the allocator that hands them out.** *What went wrong:* two laps in **this** tree each booked `%572`. Neither was careless and neither could have seen the other: `sh tools/fixtures/r/reds_spine_derive_scan.sh --next` answers from the anointed spine plus **this tree's committed rows**, and each lap's row was sitting in a `fleet_round_open.sh` stash rather than in a commit -- so the second lap read a spine the first lap's row was not in and was handed the number the first had already taken. A peer then published a third, unrelated row at `%572` upstream, so one number stood for three rows across two trees. *What caught it:* `stash_record` red at the cold open, naming four unlanded session logs on their own lines; reading both parked rows before landing them showed the same number twice. *What it taught:* **the derived spine's collision class is not only cross-tree.** The law reasons throughout about *"three stars writing into this tree from three hosts"* and its six-firing table is entirely pairs of trees -- yet a number allocated by reading a tree is allocated per **committed** tree, and the round-open's stash is what makes an uncommitted row ordinary rather than exotic. One checkout with two parked laps reproduces the fault exactly, with no second host involved. *What held:* rule 4 -- **cite by stamp until the row is shared** -- paid for itself a fourth time on the fence row. That row booked `%561`, renumbered to `%570`, then `%572`, and lands here as `%574`; its stamp `20260907.111135` never moved, and every living citation already spelled the stamp, so four renumberings touched the shelf filename, its two headings, the recital line, and nothing else. *Not taken:* teaching `--next` to read the stashes. It would work, and it would bind the ledger's allocator to one launcher's private mechanism -- a stash is not a record, which is what `stash_record` exists to say. The cheaper answer is the one already seated: **land the lap**. **CLOSED**
