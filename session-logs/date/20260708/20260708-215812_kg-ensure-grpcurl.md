# Kg — ensure_grpcurl bootstrap

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.215812

## Prompt

`go` then `kg` — four remotes, then next mechanical bench item.

## Thinking trace

**Go:** tree already at `59631ac` on all four remotes; only untracked `tools/bin/` (excluded).

**Kg:** landed `tools/ensure_grpcurl.sh` — fetches grpcurl v1.9.3 into gitignored `tools/.build/grpcurl` (qrencode family). Updated `comlink/chain_read_sui.sh` to resolve PATH → `.build` → ensure. Updated `tools/chain_read_sui.rish` to call ensure before live round trip. Both chain-read witnesses GREEN on metal without manual `/tmp` grpcurl.

## Observations

- Sui seam no longer skips live path when grpcurl absent from system PATH.
- `tools/.build/grpcurl` stays gitignored; first witness run fetches from GitHub releases.

## Files

- `tools/ensure_grpcurl.sh` — bootstrap script.
- `comlink/chain_read_sui.sh` — grpcurl resolution + ensure fallback.
- `tools/chain_read_sui.rish` — witness calls ensure.
- `work-in-progress/TASKS.md` — ensure noted on wire row.
- `session-logs/20260708-215812_kg-ensure-grpcurl.md` — this log.

**Recommend:** keep going to thin-delegate `comlink/chain_read_*.sh` from native `.rish` hosts when Realidream viewer lap opens — mechanical, follows POSIX seam pattern; or check in with Claude before parity wiring for network seams.
