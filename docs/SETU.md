# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: carry the Hearth preference fold over USB, then apply it on Desk, before live CDC-NCM. Compresses the silo; never replaces it.*

**Status:** Checkable — operator compressor (SETU0 · SETU0.5 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (SETU0.5 Desk apply GREEN)  
**Compresses:** [`LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md) · compose ruling [`../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md`](../active-designing/20260718-133455_glass-desk-compose-amber-amphora-revive.md)

---

## Thesis — the cable that installs can carry home

The same USB path that installs the APK can pull `hearth_home` + `{id}/hearth.bron` from Glass onto Desk. Desk then applies the preset under a seated window and writes a warm `station.bron`. Prove file carry and inherit first; live NCM later. Amber/Amphora compose is a later graduation — not this ladder fused.

**Waymark:** **SETU**. Sibling **LULU** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **SETU0** | adb `run-as` pull pointer + Bron; Desk parse; home_ids agree | `setu0_hearth_pull_witness` · host `setu0_hearth_pull_onpath_host` | **GREEN** `20260718.132731` |
| **SETU0.5** | Desk applies pulled Hearth → station line + `station.bron` | `setu05_desk_apply_witness` · host path after SETU0 | **GREEN** device-free + host `20260718.133328` |
| **SETU1** | CDC-NCM / Comlink live sync | — | open — check-in |

## Hands-on (host shell — not ai-jail)

```bash
cd ~/urbit
# Glass must have saved hearth once (any Settings toggle)
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
# device-free:
rishi/bin/rishi run tools/setu0_hearth_pull_witness.rish
rishi/bin/rishi run tools/setu05_desk_apply_witness.rish
```

---

*May every wire carry the fold home before it tries to live.*
