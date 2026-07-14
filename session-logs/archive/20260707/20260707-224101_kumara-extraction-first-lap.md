# Kumara extraction — first lap

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.224101

**Prompt:** `go then kg` — counsel already pushed; complete Kumara extraction first lap per counsel `222812` and expanding prompt `223300`.

## Thinking trace

1. Resumed interrupted Kumara lap from prior turn — `tally/kumara.rye` and symlinks were on disk; `receipt_core.rye` had a broken `Ed25519` alias (`const Ed25519 = kumara.PublicKey`).
2. Fixed `receipt_core.rye` to use `kumara.Signature`, `kumara.PublicKey`, `kumara.signature_length`, and `kumara.verify_bytes` throughout.
3. Repointed `linengrow/receipt.rye` — `keypair_from_seed`, `sign`, signature buffer sizes via kumara.
4. Fixed `tally/kumara.rye` `sign` noise parameter type (`?[Ed25519.noise_length]u8`) to match upstream Ed25519.
5. Added `tools/kumara_seed.rish` (mirror `tally_copy.rish` pattern) and wired parity after tally copy_disjoint.
6. Verified GREEN: `tally/bin/kumara selftest`, `linengrow/bin/receipt selftest`, `tools/kumara_seed.rish`, `tools/slcl1_receipt.rish`.
7. Marked Kumara first lap done in `work-in-progress/TASKS.md`.

## Observations

- First lap scope stays Gall's Law: receipt cluster only (`receipt_core`, `receipt`). Open Asks and delivery modules still import Ed25519 directly — repoint on touch.
- `slcl1_seed` remains witness-pinned in `receipt_core`; only crypto primitives moved to kumara.
- Behavior unchanged — extraction, not new capability.

## Files

| File | Why |
|------|-----|
| `tally/kumara.rye` | Kumara identity seam — keypair, sign, verify, selftest |
| `linengrow/kumara.rye` | Symlink → tally |
| `comlink/kumara.rye` | Symlink → tally |
| `mantra/kumara.rye` | Symlink → tally |
| `linengrow/receipt_core.rye` | Repoint verify/sign types to kumara |
| `linengrow/receipt.rye` | Repoint keygen/sign to kumara |
| `tools/kumara_seed.rish` | Witness for kumara build + selftest |
| `tools/parity.rish` | Wire kumara witness after tally_copy |
| `work-in-progress/TASKS.md` | Mark first lap complete; update direction |

**Recommend:** check in with Kaeden before SLC-L3 implementation or repointing Ed25519 sites beyond the receipt cluster — custody gate and module-seam breadth.
