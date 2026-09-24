# REDS -- a name the tool hands you, row `%620`

**Language:** EN
**Status:** Shelf -- immutable once written; the pin holds what is still open
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- the row moved whole, its links re-anchored by the fold

One row, folded `20260909.170804` to make room on a pin standing 232 bytes under its bound.

What it taught outgrew its own text and now sits on `tools/f/fleet_baton.txt`, where every
ship reads it at its cold open: a unique filename is not a found filename. A lap that names its
scratch `$$` and then recovers it by globbing has identified nothing, and on a shared directory
the glob returns whichever run of that pid wrote last -- which was, in this firing, the same
tree a day earlier. The cure was not a better name. It was
`sh tools/fixtures/s/standing_equipment_run.sh --detach`, which derives the transcript path
from the flags it was handed and prints it, so no hand chooses a name at all.

---


**REDS %620 (`20260908.065244`) -- a unique filename found again by globbing a shared directory, so a lap read its own tree as it stood yesterday.** *What went wrong:* the cold roster pass was launched as `nohup sh tools/fixtures/s/standing_equipment_run.sh > /tmp/incense-cold-$$.txt`, and the same command line closed with `ls /tmp/incense-cold-*.txt` to name the file back. The redirect and the glob ran in different shells: the pass wrote `429947`, the listing printed `4172` -- a file that PID had written on `20260907` at 11:56 and nobody had swept, since `/tmp` is the pier's and outlives a day. Twenty minutes of reading followed from it. *What caught it:* an evidence file the pass ANNOUNCED and the filesystem did not hold. Chasing `construction/standing-equipment-reds/fleet_watch.txt` put a timestamp beside the room -- `06:27:42`, before this lap opened -- and the file's own body then settled it: `stashed_entries=3` naming `20260906-072048` first, against six here naming `20260907-183139`. `ps -o lstart` on the launch PID and `date -u` closed it. *What it taught:* **uniqueness without identification buys nothing** -- `%549` seated *your own root or a mktemp pen*, this lap took the unique name and then threw the identification away at the glob. And the elder file was THIS SAME TREE, which is the worse half: a peer's pass disagrees loudly, while your own from yesterday agrees on every structural line and differs only in what has happened since. It read two reds and an absent evidence file, none of them today's; `fleet_watch` was run on that strength and answered GREEN in 27s, and *the runner announces evidence that does not exist* was one step from being booked as a red against a healthy instrument. **A stale reading of your own tree does not merely mislead -- it manufactures reds**, which is `%616`'s *a stale law page commissions duplicate work* one artifact over. *Repaired (`20260908.065244`):* the clause is seated in `tools/f/fleet_baton.txt`'s FLEET stanza, where `%541`'s and `%549`'s habits already live and for their reason -- a lap's own command is in no file, so no guard reaches it: output lands under this root in `session-output/`, and a pass nobody watched finish is checked by matching its `stashed_entries` and stash detail lines against `git stash list` here before it is believed. *Third firing of the family* (`%541` a signal, `%549` a redirect, this a glob), and the third artifact where a lap's own shell reaches past the tree the laws are written for. *Not taken:* whether the runner should write its transcript to `session-output/` itself, which would end the family by construction rather than by habit -- that is the runner's own lane. **OPEN** **CLOSED**
