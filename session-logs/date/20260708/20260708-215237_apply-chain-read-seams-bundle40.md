# Apply chain-read seams bundle 40

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.215237

## Prompt

`@files (40).zip` — counsel bundle `20260708.214500` chain-read seams for Realidream.

## Thinking trace

Extracted parent zip at `5298fef`. Landed `comlink/chain_read_monad.sh`, `comlink/chain_read_sui.sh`, counsel `214500`, apply prompt, ROADMAP/TASKS updates. Repaired bundle TASKS header corruption — checklist items belong under Realidream lane, not above Style block.

Live verification on metal: Monad `eth_getTransactionByHash` GREEN against `testnet-rpc.monad.xyz`. Sui gRPC reflection works on `fullnode.testnet.sui.io:443`; fixed nested `transaction.digest` parse in `chain_read_sui.sh` after live response shape differed from fixture assumption. Installed `grpcurl` v1.9.3 to `/tmp` for Sui path (not vendored — named dependency).

Wired `tools/chain_read_monad.rish` and `tools/chain_read_sui.rish` (on-demand witnesses; not parity yet — network seam). Sui witness skips live path when `grpcurl` absent.

## Observations

- GraphQL mainnet-only correction from counsel `214500` stands — testnet uses gRPC.
- Pinned live digests in witnesses may age off testnet history eventually; revisit if RED.
- `grpcurl` should be installed on benches that run Sui witness live.

## Files

- `comlink/chain_read_monad.sh` — Monad testnet read seam.
- `comlink/chain_read_sui.sh` — Sui gRPC read seam; nested digest parse fix.
- `counsel/20260708-214500_claude-counsel-chain-read-seams-built.md` — counsel filed.
- `expanding-prompts/20260708-214500_apply-chain-read-seams.md` — apply prompt filed.
- `tools/chain_read_monad.rish` / `tools/chain_read_sui.rish` — witnesses.
- `work-in-progress/TASKS.md` / `ROADMAP.md` — live verified; wire checked.
- `session-logs/20260708-215237_apply-chain-read-seams-bundle40.md` — this log.

**Recommend:** keep going to install `grpcurl` on cloud bench PATH if Sui witness should run there — mechanical; or check in with Claude before parity wiring for network seams.
