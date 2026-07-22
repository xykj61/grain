# STOA286 — HAWM0 Stopped · Season Fold Check-In

*An Acme Corporation employee reading this gets the close after Keaton stopped hawm0 cleanly: the host boot→harvest→HAWM1→session_root chain stays GREEN on disk, the AVD is down, and the Pixel remains the live USB device.*

**Language:** EN  
**Version:** `20260722.154348` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — lean **A** send with round-close · lean **B** rest  
**Register:** Checkable (Two Rooms) — stop GREEN from host printout; harvest Bron unchanged on disk  

**Grounds in:** STOA285 lean **B** · `tools/hawm0_stop.sh` · STOA281–284 chain  

**dated_guard:** Do **not** delete `hawm-harvest.bron` or reopen fleets from this stop alone.

---

## Host proof

```
GREEN: hawm0 stopped cleanly
```

adb after stop: Pixel `66041JEA306288` only · no `emulator-*`.

Harvest still on disk (last fold): stamp `20260722.154128` · serial `emulator-5554` · session_root `99b3ae96…` · status GREEN.

---

## STOA286 leans

| | Lean | What it opens |
|---|---|---|
| **A** | **Send this fold** — **chosen** with round-close | pier names AVD down |
| **B** | **Rest** — **recommended** | hand pauses; reopen HAWM later via boot onpath |
| **C** | **Pixel / glass season** (Sala LIVE already seated) | phone eyes / APK when mobile turns |
| **D** | **Fleets · HAWM2 · gold · JABS3 · UDP** | **held** |

### Reopen HAWM later

```bash
rishi/bin/rishi run tools/hawm0_boot_harvest_onpath_host.rish
```

---

*May the emulator sleep while the harvest keeps the root.*
