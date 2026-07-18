# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: carry the Hearth preference fold over USB, apply it on Desk, then arm a Comlink-shaped lane ping when `wire · usb_desk`. Compresses the silo; never replaces it.*

**Status:** Checkable — operator compressor (SETU0 · SETU0.5 · SETU1 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (SETU1 lane ping GREEN)  
**Compresses:** [`LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

USB pulls the fold; Desk inherits a station; `usb_desk` arms one sealed Comlink ping. CDC-NCM gadget networking waits as **SETU2**. Amber/Amphora compose stays a later graduation.

**Waymark:** **SETU**. Sibling **LULU** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **SETU0** | adb pull pointer + Bron; Desk parse | `setu0_hearth_pull_witness` · host path | **GREEN** `20260718.132731` |
| **SETU0.5** | Desk apply → `station.bron` | `setu05_desk_apply_witness` | **GREEN** `20260718.133328` |
| **SETU1** | `usb_desk` arms Comlink lane ping; writes `lane_ping.bin`; `local` refuses | `setu1_lane_ping_witness` · host SKIP/seal | **GREEN** `20260718.133853` |
| **SETU2** | CDC-NCM / live gadget lane | — | open — check-in |

## Hands-on (host shell — not ai-jail)

```bash
cd ~/urbit
# Toggle wire · usb_desk on Glass to arm SETU1 seal (else host SKIP)
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
rishi/bin/rishi run tools/setu1_lane_ping_witness.rish
```

---

*May every wire carry the fold home before it tries to live.*
