# REDS -- a symlink counted as two declaring files

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- the repair is proven by five new control legs
**Folded:** `20261001.152938` from [`../REDS.md`](../../REDS.md)

One row, folded the moment its repair landed. It teaches that a corpus walk reading files by path
reads a symlink and its target as two files, and a shared refusal helper in another file is a real
repair a per-file scan has no shape for until it is taught one.


**REDS %830 (`20261001.150304`) -- a symlink and its target were counted as two declaring files, doubling every finding.** *What went wrong:* `tools/fixtures/c/ceiling_teeth_scan.sh` reads `mantra` and `tally` by `git ls-files`, and `mantra/src/tally_receipt_offer_bounds.rye` is a symlink to `tally/receipt_offer_bounds.rye` -- the same file read under two names, so its three asserted-only constants (`max_value_unit_bytes`, `max_return_kind_bytes`, `max_signature_bytes`) were each counted twice, and none of the three was recognized at all: each is genuinely refused, not by an inline condition in its own declaring file, but by `mantra/src/receipt_offer.rye` passing it to the shared `tally_refusal.text_refusal` helper. *What caught it:* `tools/c/ceiling_teeth_witness.rish` refused at `verdict=asserted_spread`, `asserted_only=7` against a ceiling of 1, while repairing the shim_reason finding named the same lap. *What it taught:* the same symlinked-import class this tree already named once ("a symlinked @import is two compilation units, not one") reaches a scan's own corpus walk too, and a shared refusal helper is a real repair the scan had no shape for. *Repaired:* the scan now resolves each declaring file with `readlink -f` and skips a real path already seen under an earlier alias, and a new `delegated` category reads a constant structural when a file that genuinely imports the declaring file by name passes it to `tally_refusal.text_refusal` or `.exact_length_refusal` and returns the result. `asserted_only` fell from 7 to 1, the one remaining being `mantra/recall_sync_wire.rye`'s `max_wire_payload`, enforced only through a caller's buffer length rather than the named constant -- left open, named rather than forced. Five new control legs prove the delegated shape, its refusal when no real importer exists, and the symlink dedup, each from both sides. **CLOSED** -- `ceiling-teeth` reads GREEN on metal, both ledger witnesses and `tame_style_check` clean.
