# Apply Kumara extraction — Expanding Prompt

**Stamp:** `20260707.223300`
**Voice:** Rio 3
**Ground:** [`counsel/20260707-222812_claude-counsel-open-questions-final-pass.md`](../counsel/20260707-222812_claude-counsel-open-questions-final-pass.md)

---

## Objective

Extract scattered `std.crypto.sign.Ed25519` identity helpers into one small home — `tally/kumara.rye` or `kumara/seed.rye` — same shape as `tally/copy.rye` first lap.

## Empirical ground (verified `222812`)

- **Zero** authored `.rye` files name Kumara today
- **~40** files import `Ed25519` directly
- `linengrow/receipt_core.rye` already centralizes sign/verify for receipt path — study for API shape, do not duplicate

## First lap scope (happy zone)

1. `tally/kumara.rye` (or module home per grain) with:
   - `generate_deterministic(seed: [32]u8) -> KeyPair`
   - `sign(message, kp) -> Signature`
   - `verify(message, sig, pubkey) -> bool` or `!VerifyFailed`
   - `selftest` entry point
2. Symlinks: `linengrow/kumara.rye`, `comlink/kumara.rye`, `mantra/kumara.rye` (match `tally_copy` pattern)
3. Repoint **one cluster** first (e.g. `linengrow/receipt.rye` + `receipt_core` callers) — Gall's Law; expand on touch
4. `tools/kumara_seed.rish` witness; wire parity when cluster GREEN

## Out of scope

- Kumara-signed Amber manifests (later lap)
- Replacing all ~40 files in one sweep
- New crypto — behavior unchanged

## Verify

```
rye build tally/kumara.rye -femit-bin=tally/bin/kumara
tally/bin/kumara selftest
rishi/bin/rishi run tools/kumara_seed.rish
# existing slcl1 / receipt witnesses unchanged
```
