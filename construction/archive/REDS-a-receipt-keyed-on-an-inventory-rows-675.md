# REDS shelf -- row %675, a receipt keyed on an inventory

**Language:** EN
**Status:** Shelf -- immutable once written; the living pin is [`../REDS.md`](../REDS.md)
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- one CLOSED row, folded so the pin can hold a live one, its relative links
re-anchored one directory deeper

Folded `20260909.232953` by a peer's send rather than by its author's, and the reason is arithmetic
the ledger states about itself. `construction/REDS.md` stood at **40,951 bytes** against the
**40,960** its own header declares -- nine bytes of room -- while fourteen of its fifteen rows read
**OPEN** and therefore stay. This row read **CLOSED**, which is the one status the pin's own law
lets go: a closed row's work is finished, and the shelf is where a finished row is read.

The row moved whole. Nothing here is edited, and the number it wears is the number it was published
under.

**REDS %675 (`20260909.220903`) -- a coverage receipt keyed on an inventory goes stale on every commit, so the refusal it prints teaches nothing.** *What went wrong:* `tools/fixtures/s/sow_reach_inputs.sh` hashed `git ls-files` under the manifest's allow entries, so a commit adding a tracked file under one of the manifest's 107 allowed rooms left `sow_allow_reach` reading `projection coverage is stale` on the next ship's cold pass. **Measured rather than assumed:** 20 of the last 60 commits did exactly that -- one in three -- because `tools/` is an allowed room and nearly every lap of this fleet lands a witness, a control, or a scan there; a rename or a deletion under an allowed room staled it too. My own elder card block had said ANY commit, which was the shape read from memory and is wrong: `construction/` and `session-logs/` are withheld, so a log-only send never touched it. The guard asks whether an allowed room leaves files or a withholding record in the projection, and one more file beside its siblings cannot change that answer. Each ship cleared it by re-running the projector over 8,187 files rather than by learning anything. *What caught it:* this lap's cold open, reading `sow_allow_reach red` on a tree whose only change since the last projection was commits adding files -- and then counting the commits rather than trusting the sentence. *What it taught:* **a receipt keys on what the reader branches on, never on everything the reader walked past.** The reader branches on four classes per allowed room -- `subex`, `barren`, `unshippable`, `shippable` -- so the receipt hashes those; a room changing class still refuses, a sibling landing beside its peers does not. Two faults of my own, both caught by the control rather than by reading: `ls-files | head -400` reports the PIPELINE's status, so a failed git would have read as an empty room and earned a receipt for a reading that never happened; and the new quiet legs pass under the elder key too, so each was run against the elder helper and shown failing. Control **50 -> 55**. *Named rather than hidden:* removing the last tracked file the projector logged in an absent room now flips `withheld_by_design` to `empty` -- a loud reading a hand clears by re-projecting, rather than a silent pass. **CLOSED.**
