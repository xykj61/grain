# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: pull the Hearth fold, apply on Desk, arm a lane ping, cross UDP, wear an NCM-shaped frame, then carry that framed ping on a live socket before gadget bring-up.*

**Status:** Checkable — operator compressor (SETU0–SETU4 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (SETU4 framed live lane GREEN)  
**Compresses:** [`LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

USB pulls the fold; Desk inherits a station; `usb_desk` seals a ping; the ping wears Comlink’s NCM-shaped frame and crosses a live localhost UDP socket. Host may probe for `usb0`/`ncm` (SKIP when absent). Pixel/QEMU CDC-NCM iface bring-up is **SETU5**.

**Waymark:** **SETU**. Sibling **LULU** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **SETU0** | adb pull pointer + Bron | `setu0_hearth_pull_witness` | **GREEN** |
| **SETU0.5** | Desk apply → `station.bron` | `setu05_desk_apply_witness` | **GREEN** |
| **SETU1** | `usb_desk` lane ping | `setu1_lane_ping_witness` | **GREEN** |
| **SETU2** | Bare ping over UDP :38501 | `setu2_lane_wire_witness` | **GREEN** |
| **SETU3** | NCM-shaped virtio+eth wrap | `setu3_ncm_frame_witness` | **GREEN** |
| **SETU4** | Framed ping over live UDP :38502 · gadget probe SKIP | `setu4_framed_lane_witness` · host probe | **GREEN** `20260718.184323` |
| **SETU5** | CDC-NCM gadget iface bring-up | — | open — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu4_framed_lane_witness.rish
rishi/bin/rishi run tools/setu4_gadget_probe_onpath_host.rish
```

---

*May every wire carry the fold home before it tries to live.*
