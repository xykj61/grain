# Kg — chain-read native hosts + witnesses

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.220612

## Prompt

`kg` — next mechanical bench item after ensure_grpcurl.

## Thinking trace

Split chain-read per aurora / wire-lab pattern: `tools/chain_read_monad.rish` and `tools/chain_read_sui.rish` are arg-forwarding hosts delegating to POSIX seams in `comlink/`. Witness logic moved to `tools/chain_read_monad_witness.rish` and `tools/chain_read_sui_witness.rish`. Sui host uses sequential `if forwarded == ""` arms — block-body `assert` inside `if then` is an `UnknownStatement` wall.

Both witnesses GREEN on metal (host → seam → live testnet).

## Observations

- Canonical entry is now `rishi/bin/rishi run tools/chain_read_*.rish`; comlink scripts remain external-interpreter seams.
- Still not wired to `parity.rish` — network seam policy unchanged.

## Files

- `tools/chain_read_monad.rish` — host (was witness).
- `tools/chain_read_sui.rish` — host with ensure on non-empty args.
- `tools/chain_read_monad_witness.rish` — witness via host.
- `tools/chain_read_sui_witness.rish` — witness via host.
- `comlink/chain_read_*.sh` — header canonical entry updated.
- `work-in-progress/TASKS.md` — wire row names hosts + witnesses.
- `session-logs/20260708-220612_kg-chain-read-hosts.md` — this log.

**Recommend:** say **go** to commit and push; then check in with Claude before parity wiring or Realidream viewer UI — crosses visual-track seam.
