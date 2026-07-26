# STOA278 — After Boot→Harvest Chain · Check-In

*An Acme Corporation employee reading this gets the fork after the HAWM0 boot→harvest chain is authored: the harvest half is GREEN in-jail, the onpath script refuses without `/dev/kvm` as designed, and the next door is either a real host boot GREEN or extending the Bron with a Sala root field.*

**Language:** EN  
**Version:** `20260722.152849` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — lean **A** send done · lean **B** attempted `20260722.153130` → serial race → STOA279  
**Register:** Checkable (Two Rooms) — STOA277 chain authored; host full GREEN still Intent until serial-pin retry  

**Grounds in:** STOA277 chain · STOA276 lean B · HAWM0 host seat  

**dated_guard:** Do **not** claim full boot→harvest GREEN without a host onpath printout. Fleets · HAWM2 · gold · JABS3 stay held.

---

## What just closed

STOA277: `hawm0_boot_harvest_onpath_host` · chain witness GREEN · onpath REFUSE without kvm (proved) · harvest half GREEN from meta/fixture.

---

## STOA278 leans

| | Lean | What it opens |
|---|---|---|
| **A** | **Send STOA277** — **chosen** with round-close | pier carries boot→harvest chain |
| **B** | **Host onpath full GREEN** — **attempted** → STOA279 | Pixel raced bare adb; serial pin then retry |
| **C** | **HAWM1 / Pixel root into harvest Bron** | extend `hawm-harvest-v1` with sala root (Pixel adb works in this seat) |
| **D** | **Fleets · HAWM2 · gold · JABS3 · UDP** | thicker — **held** |

---

## Host one-shot (lean B)

```bash
# plain host terminal — not ai-jail
cd ~/urbit   # or this clone path
rishi/bin/rishi run tools/hawm0_boot_harvest_onpath_host.rish
# expect: GREEN: STOA277 — HAWM0 boot then hawm-harvest-v1 onpath.
cat tools/.cache/hawm0/hawm-harvest.bron
```

---

*May every refuse name the host path that earns the next GREEN.*
