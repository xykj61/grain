# Apply Zig-native ZK path — bundle 44

**Editor:** Cursor · **Model:** Composer 2.5 · **Voice:** Rio 3

**Stamp:** 20260709.031010

## Prompt

Claude counsel `023112` via `@files (44).zip` — Zig-native SLC-L4 path supersedes Groth16/Circom; Kaeden testnet-then-audit sequencing affirmed.

## Thinking trace

Extracted bundle 44 at parent `bc97a93`. Counsel checked vendored Zig 0.16: no pairing curves in `std.crypto.pcurves` — Groth16 impossible Zig-native. Recommends Curve25519 Pedersen (`Edwards25519.mulDoubleBasePublic`) + Sigma-protocol (Fiat-Shamir via SHA3); first lap fixed tiers ($10/$50/$100). Supersedes bundle 43 / counsel `021112` (Circom/snarkjs) — local bundle 43 logs already removed; `tools/fixtures/slcl4/` circom artifacts left untracked.

Applied counsel + TASKS + ROADMAP from bundle. Hygiene wiring: six-point #3, hammock `194500`, study `223327` supersession note. MALA/WOV Horizon 3 line updated with testnet-low-value-then-audit sequencing. Thin Realidream demo exception re-named in TASKS header (`021112`).

## Observations

- Docs-only — no code, no parity change.
- Counsel `021112` remains dated artifact; implementation direction is `023112`.
- Lap still Kaeden-gated.

## Files

| File | Why |
|------|-----|
| `counsel/20260709-023112_claude-counsel-zig-native-zk-path.md` | Counsel filed |
| `work-in-progress/TASKS.md` | Corrected path, MALA sequencing, thin-demo row |
| `work-in-progress/ROADMAP.md` | Version `023112`, SLC-L4 table |
| `active-designing/20260708-194500_slcl4-selective-disclosure.md` | Pedersen/Sigma receipt fields |
| `external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md` | Superseded for Zig-native |
| `session-logs/20260709-031010_apply-zig-native-zk-bundle44.md` | This log |
| `session-logs/README.md` | Index row |

**Recommend:** keep going to **`go`** — commit bundle 44 wiring; exclude `tools/bin/` and `tools/fixtures/slcl4/` (orphaned Circom artifacts from superseded `021112`).
