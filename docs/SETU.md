# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: pull · apply · ping · UDP · NCM frame · live framed socket · device-wire payload · Desk hold status — before Pixel/QEMU gadget bind.*

**Status:** Checkable — operator compressor (SETU0–SETU5 · HOLD0 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (HOLD0 Desk hold GREEN)  
**Compresses:** [`LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · season [`../active-designing/20260718-185147_desk-hearth-hold-season.md`](../active-designing/20260718-185147_desk-hearth-hold-season.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

The fold crosses USB as files, then as a sealed ping, then as an NCM-shaped frame on a live socket, then as a virtio-sized device payload (`lane_frame.bin`). Desk names that hold in one status line (**HOLD0**). Live CDC-NCM iface / QEMU device-wire lab bind is **SETU6** (parked).

**Waymark:** **SETU**. Sibling **LULU** owns the preference mold. Season: Desk Hearth Hold.

## Rung table

| Rung | Claim | Witness | State |
|------|-------|---------|-------|
| **SETU0** | adb pull Bron | `setu0_hearth_pull_witness` | **GREEN** |
| **SETU0.5** | Desk station apply | `setu05_desk_apply_witness` | **GREEN** |
| **SETU1** | `usb_desk` lane ping | `setu1_lane_ping_witness` | **GREEN** |
| **SETU2** | Bare ping UDP :38501 | `setu2_lane_wire_witness` | **GREEN** |
| **SETU3** | NCM-shaped wrap | `setu3_ncm_frame_witness` | **GREEN** |
| **SETU4** | Framed ping live UDP :38502 | `setu4_framed_lane_witness` | **GREEN** |
| **SETU5** | Fits device max_frame · `lane_frame.bin` | `setu5_device_payload_witness` | **GREEN** `20260718.184537` |
| **HOLD0** | Desk status: home · preset · wire · ping · frame | `setu_desk_hold0_witness` | **GREEN** `20260718.185306` |
| **HOLD1** | Desk Skate chrome from station | — | open — check-in |
| **SETU6** | QEMU/Pixel CDC-NCM / device-wire lab | — | parked — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu5_device_payload_witness.rish
rishi/bin/rishi run tools/setu_desk_hold0_witness.rish
# host (Pixel attached): pull → station → ping → hold line
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
```

---

*May every wire carry the fold home before it tries to live.*
