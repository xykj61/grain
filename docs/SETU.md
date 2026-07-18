# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: pull the Hearth fold, apply on Desk, arm a lane ping, cross hosted UDP, then wear the NCM-shaped ethernet frame before real gadget bring-up.*

**Status:** Checkable — operator compressor (SETU0–SETU3 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (SETU3 NCM frame GREEN)  
**Compresses:** [`LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

USB pulls the fold; Desk inherits a station; `usb_desk` seals a ping; that ping crosses localhost UDP; the same bytes wear Comlink’s virtio-net + Ethernet header (CDC-NCM packet shape). Live gadget bring-up on Pixel/QEMU is **SETU4**.

**Waymark:** **SETU**. Sibling **LULU** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **SETU0** | adb pull pointer + Bron | `setu0_hearth_pull_witness` | **GREEN** |
| **SETU0.5** | Desk apply → `station.bron` | `setu05_desk_apply_witness` | **GREEN** |
| **SETU1** | `usb_desk` lane ping → `lane_ping.bin` | `setu1_lane_ping_witness` | **GREEN** |
| **SETU2** | Ping crosses hosted UDP :38501 | `setu2_lane_wire_witness` | **GREEN** `20260718.134348` |
| **SETU3** | NCM-shaped virtio+eth wrap/unwrap | `setu3_ncm_frame_witness` | **GREEN** `20260718.134613` |
| **SETU4** | Live CDC-NCM / gadget bring-up | — | open — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu2_lane_wire_witness.rish
rishi/bin/rishi run tools/setu3_ncm_frame_witness.rish
```

---

*May every wire carry the fold home before it tries to live.*
