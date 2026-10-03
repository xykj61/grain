# REDS -- a plant matched nothing

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its repair proven by a witness on real metal
**Folded:** `20261003.041407` from [`../REDS.md`](../../REDS.md)

One row, folded in the same lap that closed it, to hold the pin under the bound eight ships share.

It teaches that a control's own plant is code with its own drift risk: a `sed` keyed to a struct's
literal layout stops proving anything the moment a sibling lap reformats that struct for
readability, and the silence reads as a passing phase unless something runs the control and checks
its own verdict word.

**REDS %833 (`20261003.041407`) -- a control's own unstated-type plant stopped matching the struct
it meant to mutate, and the plant's failure read as a refusal with nothing wrong.** *What went
wrong:* `tools/fixtures/m/mantra_replay_whole_fact_control.sh`'s `unstated_type` phase `sed`s
`signer_id: []const u8, signature: []const u8,` as one line to append a planted field after it;
`mantra/src/receipt_offer.rye`'s `ReceiptOfferFact` struct had moved to one field per line before
this lap, so the pattern matched nothing and the phase reported
`control_verdict=plant_matched_nothing` -- the exact fault `%519` already named one file over, a
sed aimed at a stale literal matching nothing while the module stays correct. *What caught it:*
running `tools/t/tally_receipt_offer_bounds_witness.rish` after an unrelated edit to this same
module (the `%765` schema molt) found the control's own assert failing rather than the schema
change. *What it taught:* a control's plant is itself code with its own drift risk, and a plant
keyed to a multi-field one-liner breaks the moment a module-head grading pass reformats the struct
for readability -- exactly what landed this same lap-day in `mycelium`'s and `grass`'s module-head
lifts nearby. *Repaired:* the `sed` now matches only the `signature: []const u8,` line and appends
the planted field on its own line after it, following the field however it is laid out; `sh
tools/fixtures/m/mantra_replay_whole_fact_control.sh` reads `control_verdict=ok control_failed=0`
and `tally_receipt_offer_bounds_witness.rish` reads GREEN on metal. **CLOSED.**
