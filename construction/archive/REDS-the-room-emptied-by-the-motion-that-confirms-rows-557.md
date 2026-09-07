# REDS shelf -- the room emptied by the motion that confirms, row %557

**Language:** EN
**Stamp:** `20260907.093147`
**Status:** Shelf -- immutable once written
**Rows:** `%557` -- folded from [`../REDS.md`](../REDS.md) on `20260907.093147`
**Voice:** Kyri

REDS `%266` opened `construction/standing-equipment-reds/` for one purpose: to root a guard that
reads red under the roster and GREEN alone. Its own closing sentence named the flake it could not
yet explain and promised that *the next occurrence will carry its words*.

Six occurrences later, none of them carried their words -- and the reason was in the room's own
housekeeping rather than in the guards. The clear ran on every pass, so the ordinary way a hand
confirms a flake, running the one guard by name, deleted every guard's evidence on its way past and
left nothing, since the alone-run is green.

**The general shape is worth more than the fix.** A record survives only the motions its keeper
anticipated. This keeper anticipated the full pass, where a whole-room clear is exactly right, and
never the partial pass -- which is the motion the record exists for.


**REDS %557 (`20260907.093147`) -- the room built to root a flake is emptied by the one motion used to confirm one.** *What went wrong:* `tools/fixtures/s/standing_equipment_run.sh` cleared its evidence room with `rm -rf "$red_room"` on **every** pass, including a by-name single-guard pass. REDS %266 opened that room for one purpose -- to root a guard that reads red under the roster and GREEN alone -- and the motion that confirms exactly that is `sh tools/fixtures/s/standing_equipment_run.sh <guard>`. So the diagnostic step deleted the words it was opened to read, and left nothing behind, because the alone-run is green. *What caught it:* this pier's cold pass at `20260907.084904` read `standing_equipment red 70s` and named `evidence construction/standing-equipment-reds/standing_equipment.txt`; I ran the guard alone, watched it answer `green 70s`, and found the file absent. Six firings of this flake family stand unrooted -- `caravan_suite` at %266, `fleet_watch` and this runner's own guard since -- and `%549` recovered one such file only because a `/tmp` clobber sent a hand to the room before anyone re-ran the guard. *What it taught:* **a record survives only the motions its keeper anticipated, and the motion nobody anticipated here is the one the record exists for.** The clear was written for a full pass, where it is right: a full pass answers for every rostered guard, so it owns the room and sweeps it whole -- which also retires the file of a guard that has left the roster. A partial pass answers for a named few and owns only those. *Repaired (`20260907.093147`):* the clear reads `run_scope`, computed above the evidence write rather than below it; a full pass still `rm -rf`s the room, and a `--scoped` or by-name pass removes only `$red_room/<name>.txt` for each guard in `$pen/running`, then `rmdir`s an emptied room so a partial green reads the same as a full one. Four control behaviors on real repositories in a throwaway pen, proven from both sides: with the elder `rm -rf` restored, `named_pass_keeps_peer_evidence` reads **no**; with the repair it reads **yes**, and `full_pass_seeds_both`, `named_pass_clears_its_own` and `named_pass_emptied_room_leaves` hold. `standing_equipment` GREEN. **CLOSED.**
