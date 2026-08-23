# REDS -- row %168, the meter that counted the wrong thing

**Folded here** `20260823.152322` from [`../REDS.md`](../REDS.md), every byte kept, on the lap it
was booked, as row %171 carried the living pin past its 24,576-byte bound. CLOSED. Its repair is
written into `tools/fixtures/room_bound_scan.sh`, which now carries two counting rules and prints
`counts=all` beside the second, and into the mark law's *a room folds by what its files are found
by*.

---

**REDS %168 (`20260823.144100`) -- the bound meter counted dated basenames, so the room with no dated basenames read zero for its whole life.** *What went wrong:* `tools/` stood at **1,917 flat entries against a bound of 256** -- 7.4x over, past GitHub's 1,000-entry listing cap -- while `tools/r/room_bound_witness.rish` ran green on every roster pass. The believed reason was that the room sat off the enforced roster. The measured reason is worse: `count_flat` counts files whose basename carries a one-clock stamp, because the rooms it was written for fold by day. Not one of the 1,917 carried a stamp, so **adding `tools` to the roster would have changed nothing** -- the meter would have reported zero and passed. *What caught it:* adding the room to the enforced roster and reading the output, which printed `room=tools flat=0` beside a room holding nineteen hundred files. *What it taught:* **a meter is blind to whatever its counting rule was not written for, and adding a room to a roster does not teach the roster to see it.** The scan now carries two counting rules -- dated basenames for a day-folded room, every flat entry for a letter-folded one -- and prints `counts=all` beside the second, so a reader knows which rule answered. The general form: when a roster gains a member of a new kind, check that the meter can measure that kind before believing the green.
