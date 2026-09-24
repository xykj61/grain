# Shelved account -- Grass, the camelCase ratchet's own repair missed a sibling, found on reverse-read

**Shelved:** `20260918.105634` -- the-writer-sheds (one live account per seat)

---

**GRASS -- THE CAMELCASE RATCHET'S OWN REPAIR MISSED A SIBLING, FOUND ON REVERSE-READ.** The
`20260918.102405` camelCase repair renamed `encodedFact`/`factCount` in
`tally/receipt_offer_bounds.rye` and closed the ratchet 2 to 0 -- yet `tame_style_check` read **1**
again on this lap's own re-run, since the same file's `productDigest` was never named that round.
`pub fn productDigest(value: []const u8) BoundError!void` is now `pub fn product_digest(...)`; a
whole-tree grep found zero call sites for either spelling, so no caller needed a matching edit.
`tools/t/tally_receipt_offer_bounds_witness.rish` GREEN unchanged (`clean_green=yes`, `control_legs=7`,
`control_failed=0`); `width-check` clean (`corpus_files_ceiling=282` unmoved);
`tame_style_check`'s camelCase ratchet reads **0** again. No claim opened: an ordinary repair to one
existing tracked file (with its `mantra/src/` symlink), named by no ledger row. **YOURS:** the
ratchet roster stands at `@memcpy` migration (135), `parseInt(` migration (54), `Ed25519` migration
(1), and `functions_over_70=694` headed by `glow/lower_shop_gate_witness.rye` at 1035 lines; the
next agent-doable pick is any one, claim-board checked first.
