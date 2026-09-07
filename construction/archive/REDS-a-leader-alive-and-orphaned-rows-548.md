# REDS %548 -- a leader alive and orphaned at once

*Folded from the living pin [`../REDS.md`](../REDS.md) on the lap that booked it, because the pin
could not seat it. `tools/fixtures/r/reds_pin_capacity_scan.sh` read `pin_deadlocked=1`,
`rows_that_fit=0`, `pin_foldable_rows=0`: ten OPEN rows, 627 bytes of headroom, and a median row of
2,934. A BOOKED row may fold to a shelf, and this one was booked and repaired in the same lap, so it
folds rather than pushing the pin past the bound its own header declares.*

*The clause worth carrying forward is its title, and it is the third time this family has taught it.
A liveness reading is fixed at whatever generation its author could see. `%387` read the holder's
parent; `%528` added the process group leader when a detached pass kept a live parent; this row adds
the leader's own parent, because the harness a lap now reaches for gives the pass its own session and
makes the LEADER the thing init adopts. Each repair asked whether its immediate answer was alive, and
the fleet kept moving which process that was.*

*What the pin's deadlock leaves for a hand: nothing here folds it. Ten OPEN rows are live work, and a
raise of `living_pin_max_bytes[construction/REDS.md]` is a decision rather than a lap.*

---


**REDS %548 (`20260907.065808`) -- a group leader can be alive and orphaned at once, so a dead lap's pass held the lock while both of the runner's liveness readings said `alive`.** *What went wrong:* my cold open was refused by `tools/fixtures/s/standing_equipment_run.sh` against pid `3457737`, whose lap had ended minutes earlier. The runner reads the holder's parent and its process group leader, and either answering `gone` makes `lap=gone`. Here parent and leader were the same pid `3457725`, alive -- and `3457725`'s own ppid was **1**. A lap launching a pass through the harness's detached form, `sh -c '... runner --hot --scoped > /tmp/hot.txt ...'` started in the background, gets a new SESSION for that command, so the `sh -c` leads its own group rather than joining the lap's, and it is what init adopts when the lap ends while going right on running. *What caught it:* walking `ps -o ppid=` by hand after the refusal printed no repair advice -- the silence `%528` already describes. *What it taught:* **a liveness reading fixed at one generation moves up one generation when the launcher does.** `%387` declared the under-report with a subreaper as its example; `%528` found the real shape one generation up and added the group leader; this is the third firing, and its cause is that the leader is now the thing being orphaned. A loom rather than a lantern: each repair asked *is my immediate answer alive*, and the fleet keeps changing which process that is. *Repaired:* a third reading, `leader_parent`, asks the leader the first question -- has the process that started the family exited -- joining the same `lap=gone` disjunction. One extra `ps`, never a walk: the ancestry above the leader belongs to the lap, not the pass. It cannot call a live pass gone, since a foreground pass has the lap's own shell as leader and that shell's parent is the agent process; only a detached pass makes the `sh -c` the leader, and only a dead lap makes its parent init. The refusal now names which reading fired. *Proven:* the control plants it in three processes under `set -m` -- an outer shell backgrounds the leader and exits, init adopts it, the leader spawns the holder and stays alive -- reading **nine** behaviors, two load-bearing in the other direction: both elder readings must still answer `alive` there, or a widened check could not be told from one stuck on. The live-holder plant carries the negative side. On metal the standing orphan read `parent=alive group_leader=alive leader_parent=gone lap=gone`. *Folded on the lap that booked it:* the pin read `pin_deadlocked=1 rows_that_fit=0 pin_foldable_rows=0` -- ten OPEN rows, 627 bytes of headroom, a median row of 2,934 -- so a BOOKED row could not be seated without going over. **BOOKED.**
