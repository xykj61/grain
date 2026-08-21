# SLC-L3 settlement witness — gate crossed

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3
**Stamp:** 20260708.183000

## Thinking trace

Kaeden opened the SLC-L3 gate (`182500`). The branch already held `settlement_core.rye`, `settlement.rye`, lane POSIX seams, and bron goldens from the prior pass. First metal run failed on `FileNotFound` for the lane capture file — shell redirect under `std.process.spawn` did not land output on disk while stdout inherited to the parent. Switched `invoke_lane_seam` to `std.process.run` with captured stdout; duplicated seam strings into arena memory to avoid use-after-free.

Second failure: `AmountMismatch` from dangling slices — `built.amount` and `built.fact_stamp` pointed at stack buffers inside `build_slcl1_log`. Fixed by re-parsing canonical fact fields in `run_lane` and unwelcome paths.

After fixes: `linengrow/bin/settlement selftest` GREEN — both lanes, three axes, welcome and unwelcome paths. Added hammock scope `active-designing/20260708-182500_slcl3-settlement-rail.md`, `tools/slcl3_settlement_witness.rish`, wired parity **198**, updated TASKS and ROADMAP. Witness and tail stanzas (identity, Comlink device wire, SLC-L3) GREEN on cloud bench. Full `parity.rish` re-run hung on OA-L5 demo (>15m); killed; prior **197** baseline still holds.

## Observations

- Thin rail stays POSIX external-interpreter family per TAME — no SDK link.
- Mainnet treasury and SLC-L4 remain out of scope; witness scores, prose does not crown.
- Golden bron fixtures pin six fields; `log_digest` computed at runtime.

## Files

- `linengrow/settlement_core.rye` — receipt shape, digest, amount, lane verify.
- `linengrow/settlement.rye` — two-lane selftest; `process.run` seam capture.
- `tools/fixtures/slcl3_lane_*_settle.sh` — pinned testnet seams.
- `tools/fixtures/settlement_receipt_lane_*.bron` — lane goldens.
- `tools/slcl3_settlement_witness.rish` — build + run witness.
- `active-designing/20260708-182500_slcl3-settlement-rail.md` — hammock scope.
- `tools/parity.rish` — parity **198** stanza.
- `work-in-progress/TASKS.md` — SLC-L3 landed.
- `work-in-progress/ROADMAP.md` — trio **198**; SLC-L3 row landed.

**Recommend:** check in with Claude before mainnet treasury or settlement-seat prose crown — custody and recommendation stay Kaeden's after witness scores.
