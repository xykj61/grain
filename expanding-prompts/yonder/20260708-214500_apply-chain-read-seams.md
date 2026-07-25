# Cursor Apply-Prompt — Chain-Read Seams for Realidream

**Stamp:** `20260708.214500 UDT` · **Parent:** `5298fef` · **Voice:** Rio 3
**Bundle:** `20260708-214500_chain-read-seams.zip`

Built rather than left proposed — the one concrete step both sides of the settlement discussion already agreed on. Read this apply-prompt's "Steps" section carefully: one real verification step is still needed that this bench's sandbox genuinely could not perform.

## What Lands

- **`comlink/chain_read_monad.sh`** — `eth_getTransactionByHash` against Monad's public testnet RPC, `curl`-only. Argument validation and all four JSON-parsing branches (found, not-found, node-error, malformed) verified on this bench against fixtures.
- **`comlink/chain_read_sui.sh`** — `sui.rpc.v2.LedgerService/GetTransaction` via `grpcurl`. **A real correction from the prior round**: Sui's GraphQL service is mainnet-only, so this seam uses gRPC, the only path that reaches testnet once JSON-RPC finishes sunsetting this week. Method and request shape confirmed across Sui's own current docs and three independent RPC providers. Tries server reflection first, falls back to fetching Sui's own published `.proto` fresh (never vendored, since this schema is mid-migration and most likely to drift). New tool dependency named plainly: needs `grpcurl` installed.
- **`counsel/20260708-214500_...`** — precise account of what this bench could and couldn't verify.
- **`TASKS.md` / `ROADMAP.md`** — updated to reflect built-but-partially-verified status honestly.

## Steps — Please Do This First

**This bench's sandboxed network cannot reach blockchain RPC endpoints at all** — neither script's actual network round trip was tested against a live chain. Everything short of that (argument handling, tool-detection, JSON parsing) was verified for real; the live call was not, and is not claimed to have been.

1. Tree at `5298fef`; unzip at root, confirm both scripts are executable.
2. Install `grpcurl` if not already present (`https://github.com/fullstorydev/grpcurl` — single static binary).
3. Run `comlink/chain_read_monad.sh <a real testnet tx hash>` — confirm it reaches `testnet-rpc.monad.xyz` and parses a real response.
4. Run `comlink/chain_read_sui.sh <a real testnet tx digest>` — confirm it reaches `fullnode.testnet.sui.io:443`, confirm whether reflection works or the proto-fallback path is needed, confirm the response shape matches what the parsing logic expects.
5. Once both are confirmed live, wire each into its own `tools/chain_read_*.rish` witness, matching the existing external-interpreter seam pattern.

## Held

Everything else — Pond, Dexter, the GUI rendering itself, the L1/L2 horizon question. This is the data layer underneath a future viewer, nothing more.

---

*May the one thing this bench couldn't test be the very next thing confirmed true.*
