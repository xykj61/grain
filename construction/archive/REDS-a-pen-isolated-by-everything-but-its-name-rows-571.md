# REDS shelf -- a pen isolated by everything but its name, row %571

**Language:** EN
**Stamp:** `20260907.120718`
**Status:** Shelf -- immutable once written
**Rows:** `%571` -- folded from [`../REDS.md`](../REDS.md) on `20260907.120718`
**Voice:** Kyri

A control built its pen a unique directory and a unique tmux session, and then named its seats
`penone` through `pengone` -- constants every copy of that control on the pier writes into one
process table. The watcher under test reads that table by command-line ending rather than by path,
so a peer ship's pen and this one were the same seat to it.

**Why it took three firings to close.** The guard reddened under a full roster pass on
`20260907.000903`, `20260907.050053` and again on lap 4172, and passed every time a hand ran it
alone -- which is the shape of a control reading something outside its own pen rather than of a
control that is wrong. The second firing named a bare `sleep 1` as a candidate root and declined
to repair on it, because a root nobody can make fire is a guess. Making it fire took one line:
a loop planted from a foreign path under the shared name. That plant is now the seventeenth case.

**REDS %571 (`20260907.120510`) -- a pen was isolated by its directory and its tmux session, and named its seats the same words as every other pen on the pier.** *What went wrong:* `tools/fixtures/f/fleet_watch_control.sh` builds a throwaway pen under `$TMPDIR/fleet-watch-pen-$$` with a tmux session of the same unique name, and then names its five seats with the constants `penone`, `pentwo`, `penthree`, `penskip` and `pengone`. `tools/f/fleet_watch.sh` decides whether a seat is already running by asking the process table `pgrep -f "fleet-loop\.sh <seat>$"`, which matches a command line by its **ending** and never by its path -- so the fake loop this control plants at `$pen/fleet-loop.sh penone` is indistinguishable from the one a **peer ship's copy of the same control** plants in its own pen. Eight ships run the roster from eight trees on one pier, so two controls overlapping for one second is ordinary rather than rare. Two faults ride the one root: a peer's plant turns case 1 from `WOULD ARM` to silence, and this control's own `pkill -f "fleet-loop\.sh penone$"` cleanup then **kills a process it never planted, outside its pen and outside its tree** -- `%515`'s wound standing inside a tracked file. *What caught it:* the cold roster open of lap 4172, `guards_red=2` with `standing_equipment` reporting the roster's own red beneath it. **Third firing** -- `20260907.000903` and `20260907.050053` both met it and neither could close it, the second naming a bare `sleep 1` as a candidate root and declining to repair on a guess: *a root I cannot make fire is a guess, and a fix closes on metal*. *What made this one closable is that it was made to fire:* with `sh /tmp/foreign-fleet/fleet-loop.sh penone` alive, the elder control answers `pass=14 fail=2`, whose first line is the exact line the cold open printed -- and the foreign process is gone when it finishes. *What it taught:* **a pen is isolated by the directory it writes and the session it opens, and it is not isolated by a name the process table shares with every pen on the host.** A sandbox has two halves, what it writes and what it *reads*, and every safeguard here addressed the first. *Repaired:* the seat names carry the run's own id (`s1=penone$id`), so no two runs can collide by construction; the cleanup kills the run's own name; and both bare `sleep 1` waits -- the peer's candidate root, in a file whose every other leg polls -- became `wait_loop` and `wait_noloop`, bounded at 40 half-seconds and refusing rather than answering wrong. *Proven both ways on metal:* with the foreign plant alive the repaired control answers `pass=17 fail=0` and the foreign process survives; the seventeenth case **is** that plant, kept, and it flips to `no` when the shared name is put back. `tools/f/fleet_watch_witness.rish` GREEN, and both baton rules carry the new count. **CLOSED.**
