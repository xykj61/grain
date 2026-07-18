# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: carry the Hearth fold over USB, apply on Desk, arm a Comlink lane ping on `usb_desk`, then prove that ping crosses a hosted UDP stand-in before real CDC-NCM.*

**Status:** Checkable — operator compressor (SETU0–SETU2 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (SETU2 hosted UDP GREEN)  
**Compresses:** [`LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

USB pulls the fold; Desk inherits a station; `usb_desk` seals a ping; that ping crosses localhost UDP as the Setu lane stand-in. Real CDC-NCM gadget networking waits as **SETU3**.

**Waymark:** **SETU**. Sibling **LULU** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **SETU0** | adb pull pointer + Bron; Desk parse | `setu0_hearth_pull_witness` | **GREEN** `20260718.132731` |
| **SETU0.5** | Desk apply → `station.bron` | `setu05_desk_apply_witness` | **GREEN** `20260718.133328` |
| **SETU1** | `usb_desk` lane ping → `lane_ping.bin` | `setu1_lane_ping_witness` | **GREEN** `20260718.133853` |
| **SETU2** | Ping crosses hosted UDP (port 38501) | `setu2_lane_wire_witness` | **GREEN** `20260718.134348` |
| **SETU3** | CDC-NCM gadget lane | — | open — check-in |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
rishi/bin/rishi run tools/setu1_lane_ping_witness.rish
rishi/bin/rishi run tools/setu2_lane_wire_witness.rish
```

---

*May every wire carry the fold home before it tries to live.*
