# REDS -- row %305, folded from the living pin

**Folded:** `20260827.221020` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The first Choir round's own catch: a rename swept every direct caller and missed every symlink
consumer, twenty-two sites across two rooms, invisible until something built them.*

A symlink is a reference the grep never sees. A path-walking sweep repoints `caravan/...` literals
and reads straight past a consumer that spells the same file `linengrow/capabilities.rye`, so a
rename sweep must resolve symlinks or grep for the symbol rather than the path.

It folded on the lap it was booked, because the pin held four OPEN rows and the fold tool rightly
keeps what is open -- the born-on-a-shelf shape the recital already carries for `%286`-`%288`,
`%296` and `%297`.

---

**REDS %305 (`20260827.221020`) -- a rename swept every direct caller and missed every symlink consumer.** *What went wrong:* `caravan/capabilities.rye` molted `add_child` -> `add_dependent`, and the sweep repointed callers naming `caravan/` in their paths -- and none of the consumers importing through a **symlink**. `linengrow/capabilities.rye` links to that file: **20 call sites across 10 linengrow files** plus 2 in `mand/mand_ring1_witness.rye` still spoke the elder name, so every capability-table consumer there failed to compile. *What caught it:* **the first Choir round** -- six lane laps under one supervisor, every loop stopped. Mystery hit the compile failure, repaired its own room, and reported the Mand pair as an orbit-rule line; the supervisor closed those two. *What it taught:* **a symlink is a reference the grep never sees** -- a path-walking sweep reads past a consumer spelling the same file by another name, so a rename sweep resolves symlinks or greps the **symbol**. And the Choir's argument proved on its first run: six lanes in one round surfaced what six loops had each missed from their own side. *Repaired:* all 22 sites read `add_dependent`; seven witnesses GREEN on metal, a clean android build of the pack target, tree-wide grep at zero outside the reading rooms. CLOSED.
