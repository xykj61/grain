# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: pull · apply · ping · UDP · NCM frame · live framed socket · device-wire payload · Desk hold status — before Pixel/QEMU gadget bind.*

**Status:** Checkable — operator compressor (SETU0–SETU6.5 · HOLD* · live-sent GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-20 (live-sent on Pixel `enx*` CDC-NCM)  
**Compresses:** [`LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · season [`../active-designing/20260718-185147_desk-hearth-hold-season.md`](../active-designing/20260718-185147_desk-hearth-hold-season.md) · SETU6.5 [`../active-designing/20260718-201601_setu65-lab-tx-gate.md`](../active-designing/20260718-201601_setu65-lab-tx-gate.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

The fold crosses USB as files, then as a sealed ping, then as an NCM-shaped frame on a live socket, then as a virtio-sized device payload (`lane_frame.bin`). Desk names that hold in one status line (**HOLD0**). **SETU6** seats the device-wire lab harness (payload ready · iface classified). **SETU6.5** gates framed TX: stand-in refuses; armed unicasts iface-bound UDP :38503 to the tether gateway. Live **sent** GREEN on Pixel CDC-NCM (`enx*` or `usb0`/`ncm*`).

**Waymark:** **SETU**. Sibling **LULU** owns the preference mold.

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
| **HOLD0** | Desk status · local ignores stale ping/frame | `setu_desk_hold0_witness` | **GREEN** `20260718.190720` |
| **HOLD1** | Desk Skate: hold chrome rows 0–1 | `setu_desk_hold1_witness` | **GREEN** `20260718.193122` |
| **HOLD-W** | Desk Wayland eyes: raster + look; eyes seen | `setu_desk_hold_wayland_witness` | **GREEN** `20260718.194211` |
| **SETU6** | Lab harness: payload ready · iface stand-in/armed | `setu6_device_lab_witness` | **GREEN** `20260718.201232` |
| **SETU6.5** | Lab TX gate: stand-in refuses · armed prepares/attempts | `setu65_lab_tx_witness` | **GREEN** `20260718.201601` |
| **Live-sent** | Framed TX on real CDC-NCM (`enx*`/`usb0`/`ncm*`) | host probe + `setu65_lab_tx_onpath_host` | **GREEN** `20260720.233805` |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu6_device_lab_witness.rish
rishi/bin/rishi run tools/setu65_lab_tx_witness.rish
rishi/bin/rishi run tools/setu6_lab_probe_onpath_host.rish
rishi/bin/rishi run tools/setu65_lab_tx_onpath_host.rish
# eyes: linengrow/bin/setu_desk_hold_wayland_look
```

---

*May every wire carry the fold home before it tries to live.*
