# SETU — USB hearth carry Glass ↔ Desk

*Waymark for wire-first sync: carry the Hearth preference fold over USB before live CDC-NCM. Compresses the silo; never replaces it.*

**Status:** Checkable — operator compressor (SETU0 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (SETU0 Pixel host GREEN)  
**Compresses:** [`../docs/LULU.md`](LULU.md) · [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md)

---

## Thesis — the cable that installs can carry home

The same USB path that installs the APK can pull `hearth_home` + `{id}/hearth.bron` from Glass onto Desk. Prove file carry first; live NCM later.

**Waymark:** **SETU** (Setu — the crossing / bridge sense of Wired Glass). Sibling ladder **LULU** owns the preference mold.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **SETU0** | adb `run-as` pull pointer + Bron; Desk parse; home_ids agree | `setu0_hearth_pull_witness` · host `setu0_hearth_pull_onpath_host` | **GREEN** device-free + Pixel host `20260718.132731` |
| **SETU1** | CDC-NCM / Comlink live sync | — | open — check-in |

## Hands-on (host shell — not ai-jail)

```bash
cd ~/urbit
# Glass must have saved hearth once (any Settings toggle)
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
# device-free parse only:
rishi/bin/rishi run tools/setu0_hearth_pull_witness.rish
```

---

*May every wire carry the fold home before it tries to live.*
