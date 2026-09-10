# REDS -- a gate that never runs when it matters

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its repair proven on the spine it reads
**Folded:** `20260910.050256` from [`../REDS.md`](../REDS.md)

One row, folded by a peer within the hour it was booked so the pin could hold the next one: the
ledger stood twelve bytes clear and this row read **BOOKED**, which is the one status the fold law
lets move. It teaches that a gate's clock decides what it can ever catch -- a check that runs at
the open and the close is a check absent at the moment a number is published. Read it beside
[`REDS-fold-recital.md`](REDS-fold-recital.md).


**REDS %687 (`20260910.020754`) -- the gate that would refuse a published double runs twice a lap, and never at the moment that publishes one.** *What went wrong:* `.claude/rules/derived-spine.md` names the **published double** -- one `%N` bound on the anointed spine to two stamps -- calls the collision *exactly once*, and points at `%530`. Measured `20260910.015328` by `tools/fixtures/r/reds_spine_derive_scan.sh`: **seven** stand -- `%530`, `%592`, `%642`, `%664`, `%669`, `%675`, `%681` -- **six arriving in the three days after the law was written**. *What caught it:* a fold. The pin held `%681` twice, once in a row and once on a shelf a peer folded 25 minutes earlier. *What it taught:* **the instrument was right and its placement was wrong.** The scan already exits 1 on `rebindings` and `double_booked`, the two states that BECOME a published double the instant a push lands. It runs at the cold open and the hot close, and **both precede the send's final rebase** -- the one step that brings a peer's row into this tree -- and no send script holds the gap, since the send is typed from `tools/f/fleet_baton.txt`. On the history rather than argued: commit `7b1f6b3ee` binds `%681` to `20260910.001157` in the pin and to `20260909.234718` on its shelf, which is `double_booked=1` at the moment of a push that shipped. *Repaired:* `tools/hooks/pre-push` asks that scan after the tree settles and before an object leaves -- a **placement rather than a new instrument**, reaching every ship with no arming, `core.hooksPath` reading `tools/hooks` on **8 of 8** (`20260910.015328`). It welcomes a published double already upstream, a delete, and a push whose own range carries no ledger change. Twelve behaviors with real pushes in a pen, every refusal planted then lifted: `tools/fixtures/p/pre_push_spine_control.sh` under `tools/p/pre_push_spine_witness.rish`. **This row was booked `%683` from a local read and renumbered on the rebase that found a peer's `%683` already folded** -- the law's own rule 4, paid once and cheaply, since every citation spelled the stamp. **BOOKED** -- the seven published stay Keaton's word; what closes here is the arrival of the eighth.

