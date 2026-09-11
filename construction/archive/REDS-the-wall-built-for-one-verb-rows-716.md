# REDS -- the wall built for one verb

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its repair proven on metal and held by a rostered witness
**Folded:** `20260911.150000` from [`../REDS.md`](../REDS.md)

One row, born on its shelf because the pin had no room for it -- `reds_pin_capacity_scan.sh` read
`rows_that_fit=0`, the same door `%699`, `%703`, `%706`-`%708` and `%711`-`%713` came through. It
teaches that **a wall built for one verb is a wall for one verb**: the vessel room seated
*prove before you write* for `restore` on `20260910`, stated the rule generally, implemented it
locally, and left `pour` -- the sibling verb, forty lines away in the same file -- with the shape
its sibling had just left behind. Read it beside
[`REDS-the-gate-that-inherited-its-bound-rows-710.md`](REDS-the-gate-that-inherited-its-bound-rows-710.md),
where a guard's argument reached wider than the class it walled, and
[`REDS-fold-recital.md`](REDS-fold-recital.md).


**REDS %716 (`20260911.130000`) -- a refused pour destroys the vessel already standing at that path, and the room's front door promised the opposite in so many words.** *What went wrong:* `pour_ship` in `amphora/src/main.rye` called `write_unsealed_vessel` on the TARGET first and ran the seal and the stamp over it afterward, so every refusal between those steps replaced a good vessel with a half-made one. Measured on metal: a 1,565-byte sealed, stamped vessel, then a re-pour with `AMPHORA_VESSEL_SEAL` absent, and **956 bytes stand at that path carrying the manifest and cargo listing in the CLEAR with neither seal nor stamp** -- both walls refusing over the wreck of a vessel that had passed them minutes earlier. With `AMPHORA_VESSEL_CORE` absent instead the leavings are **sealed and unstamped**, which reads legitimate to anyone checking the seal alone. *What caught it:* the water rota, cardinal seat -- run the actual thing up close, and run it a SECOND time. `amphora/README.md` already promised *"it answers by name the moment one of them disagrees -- while the vessel already on disk keeps every byte it had"*; `tools/am/amphora_pour_witness.rish` asserted a same-season re-pour `.ok` and never read the vessel afterward, so an exit code stood in for a file nobody looked at. *What it taught:* **a wall built for one verb is not a wall until the sibling verb is asked the same question.** `amphora_prove_before_write` seated this rule for RESTORE on `20260910`, and POUR, one verb over in the same file, kept the elder shape. *Repaired:* fill, seal and stamp land on a `.pouring` scratch beside the target, and `rename(2)` -- one filesystem, so POSIX makes it atomic -- replaces the target only once the rite has passed; `refuse_and_clear` sweeps that scratch on every refusal. **8 legs** under `tools/am/amphora_pour_atomic_witness.rish`, `tier lap`, the elder shape rebuilt in a pen and watched losing the vessel over the plant the repaired binary keeps. **CLOSED**
