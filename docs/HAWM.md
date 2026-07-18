# HAWM — GrapheneOS / Pixel mobile ladder

*Waymark for the Pixel/GrapheneOS SLC line. Emulation first, then real Titan-class hardware. Compresses the living ledger; never replaces it.*

**Status:** Checkable — operator compressor
**Depth:** guide
**Ceiling:** ≤120 lines
**Last updated:** 2026-07-18 (JABS living name beside Sala fold modules)
**Compresses:** [`two-dev-environments-and-mobile-emulation.md`](../context/specs/two-dev-environments-and-mobile-emulation.md) · [`20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md`](../context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md) · [`pixel-10a-grapheneos-setup.md`](../manual/guides/pixel-10a-grapheneos-setup.md) · [`JABS.md`](JABS.md)

---

## Thesis — prove the compute, then the platform

**HAWM** is the waymark for the GrapheneOS/Pixel ladder (SHA3-512 over `old/doc/spec/flw.txt`, seated `20260716.115927`). It is a different ladder from the Genode proven-seat **G0/G1** in [`PROVEN_SEAT.md`](PROVEN_SEAT.md) — that collision is why waymarks exist.

HAWM0/HAWM1 exercise real AOSP/Android userland (useful for Glow code). Only HAWM2 (real GrapheneOS build) or HAWM3 (physical device) touch GrapheneOS's own hardening. Name that boundary honestly; never claim the emulator is GrapheneOS.

---

## Rung table

| Rung | Claim | Primary witness / guide | State |
|------|-------|-------------------------|-------|
| **HAWM0** | Stock AOSP AVD boots, KVM-accelerated | `tools/hawm0_boot_onpath_host.rish` | GREEN |
| **HAWM1** | **JABS0** Sala fold runs inside that AVD (module `sala_b0_fold`); session root matches native | `tools/hawm1_sala_witness.rish` | GREEN |
| **HAWM2** | Real GrapheneOS build / image | — | horizon (Linux/KVM + full AOSP) |
| **HAWM3** | Physical Pixel, GrapheneOS flashed, boot-key hash matched | [`pixel-10a-grapheneos-setup.md`](../manual/guides/pixel-10a-grapheneos-setup.md) · hash `d8f879d1…` | **closed** `20260717.013700` |

On-device Sala via `tools/hawm3_sala_device_witness.rish` (aarch64) needs USB debugging on the phone — host-terminal, same boundary as HAWM0.

---

## Hands-on doors

| Task | Door |
|------|------|
| Flash GrapheneOS on a Pixel 10a | [`manual/guides/pixel-10a-grapheneos-setup.md`](../manual/guides/pixel-10a-grapheneos-setup.md) |
| Upstream install / features wording | [`gratitude/grapheneos/`](../gratitude/grapheneos/) (MIT mirror — study, not our guide) |
| Living ledger (full register) | [`context/specs/two-dev-environments-and-mobile-emulation.md`](../context/specs/two-dev-environments-and-mobile-emulation.md) |
| Packaging + glass rail on Pixel | [`TUBE.md`](TUBE.md) — TUBE0.5–TUBE5 + **TUBE7 GREEN** `20260717.145547` (TUBE6 waits on HAWM2) |
| GrapheneOS Storage · Contact Scopes → Glow | [`../linengrow/glow_storage_scope.rye`](../linengrow/glow_storage_scope.rye) — **GREEN** `20260717.155846` · glass cover `20260717.161220` (scopes cover declared photos + contacts) |
| GrapheneOS Network permission toggle → Glow | [`../linengrow/glow_network_grant.rye`](../linengrow/glow_network_grant.rye) — **GREEN** `20260717.160607` · TUBE1 wire `20260717.160828` (binary grant; appears down; glass door live) |
| GrapheneOS Sensors permission toggle → Glow | [`../linengrow/glow_sensors_grant.rye`](../linengrow/glow_sensors_grant.rye) — **GREEN** `20260717.161013` · emit `20260717.161448` (appears zeroed; `OTHER_SENSORS` table row) |
| Install APK + prove Sala root | Host terminal: `tools/tube05_install_proof_onpath_host.rish` — **HAWM0** · **Pixel** · glass through TUBE4 + **JABS1** carriage + Dexter D1 line (`20260717.173133`; D2 Pixel look open) |

---

## Related ladders (do not collide)

| Ladder | Metal | Compressor |
|--------|-------|------------|
| **HAWM** | GrapheneOS / Pixel | this page |
| **Genode G0/G1** | proven-seat / Sculpt | [`PROVEN_SEAT.md`](PROVEN_SEAT.md) |
| **M0–M3** | Fairphone / postmarketOS | living ledger only (no compressor yet) |

---

*May the emulator prove the fold, and the Titan prove the seat.*
