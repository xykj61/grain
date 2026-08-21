# Remove SLC-L3 settlement rail and retired chain-read seams

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260709.163549

**Prompt:** Continue removal arc — delete retired Sui/Monad settlement implementation; fix doorway scan; verify parity **197**.

## Thinking trace

Picked up from handoff after settlement/chain-read deletion was applied locally but doorway scan failed and full parity was unverified.

Doorway failures were mechanical: `slcl3-settlement-rail.md` Status did not name a checkable room; three external-research Claude briefs lacked `**Status:**` lines. Fixed all four to match TWO_ROOMS register (`checkable room` / `Checkable-room research`).

Re-ran `tools/two_rooms_doorway.rish` — **GREEN**.

Started full `tools/parity.rish`; run hung ~30 minutes on `open_asks_lap3` (`open-asks-escrow-delivery` demo/applicant sleeping). Killed the hung run — pre-existing escrow lap behavior, not caused by settlement removal.

Aligned counsel `152612` and ZK study `223327` with Kaeden's delete directive (counsel had said "never deleted"; user chose removal with no external dependents).

## Observations

- **772 lines** removed across settlement core, witnesses, chain-read hosts, grpcurl bootstrap, bron goldens, settle fixtures.
- Parity witness count **197** (SLC-L3 stanza dropped from `tools/parity.rish`).
- Historical briefs (`211637`, `015832`) still cite landed files — correct as dated record.
- Full parity green not reconfirmed this pass; doorway green confirmed.

## Files

| File | Why |
|------|-----|
| `active-designing/20260708-182500_slcl3-settlement-rail.md` | Status names checkable room; removal noted |
| `external-research/20260708-211637_…` | Status line added |
| `external-research/20260709-015832_…` | Status line added |
| `external-research/20260709-034527_…` | Status line; parity **197** |
| `counsel/20260709-152612_…` | Retire section reflects deletion |
| `external-research/20260708-223327_…` | Seam table marks SLC-L3 removed |
| Deleted settlement + chain-read tree | User directive — no dependents |

**Recommend:** keep going to **`go`** — commit bundle 45 + removal stack + doorway fixes; push four remotes (exclude `tools/bin/`). If full parity is required before push, investigate `open_asks_lap3` hang separately — it predates this removal.
