# REDS -- row %709, folded from the living pin

**Folded:** `20260911.094500` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The capacity round -- a meter over a page eight ships write must name which tree it read, and a loom already built for that class is carried to its second site rather than built again.*

The row stands here exactly as it was written. A closed row leaves the living pin so the
pin stays the length a reader will actually read; the lesson travels forward in the guards
the round built, and the row itself stays one click away.

---

**REDS %709 (`20260911.064500`) -- the ledger's own capacity meter answered about a page eight ships write, from one clone's bytes.** *What went wrong:* every reading in `tools/fixtures/r/reds_pin_capacity_scan.sh` -- `pin_headroom`, `rows_that_fit`, `pin_foldable_rows`, `pin_deadlocked` -- was taken from THIS checkout's `construction/REDS.md`, and the scan's own header called that *purely local*. Measured `20260911`: **all 200** of the last 200 commits touched the pin, 50 of them inside 16 hours, and headroom moved **0 -> 1,993 -> 15 bytes** across five of them -- a swing wider than the median row of **1,977**. A clone one commit behind does not read a slightly stale ledger; it reads one whose deadlock verdict can have flipped. *What caught it:* the new reading, on the lap that wrote it, on live state -- mid-lap `commits_behind` went 0 -> 2 and it named **`%705`**, the very row this checkout's `pin_foldable_rows=1` was counting, already folded by a peer. Replayed eight commits back on real history it names **`%701`**, the row that misled the lap of `20260911.034352`. *What it taught:* **a meter over a shared page must name which tree it read.** `%457`'s loom, `tools/fixtures/p/path_absence_scan.sh`, was built for this exact class and wired to one site; a lantern that fires twice becomes a loom, and the loom is CARRIED to the second site rather than rebuilt there. *Repaired:* the scan reads `${REDS_ANOINTED:-xy/main}`'s pin beside its own through the one row reader, and prints `pin_upstream_state`, `pin_rows_ahead_of_upstream`, `pin_rows_only_upstream` and `commits_behind` -- **reported, never gated**, since being behind is ordinary work on an eight-ship fleet. It reads the ref rather than fetching, which is the sibling `reds_spine_derive_scan.sh`'s idiom and right for a lap-tier guard. **83 control legs, fail=0, five mutations bitten**; the pen's leg COUNT is pinned, so a leg deleted refuses where `cases_failed=0` read the same. **BOOKED.**
