# STOA284 — HAWM Harvest Carries HAWM1 `session_root`

*An Acme Corporation employee reading this gets the lean-A close after STOA283: HAWM1 ran GREEN on `emulator-5554` beside the Pixel, the 64-hex Sala session root was captured, and `hawm-harvest-v1` folds it as `session_root`.*

**Language:** EN  
**Version:** `20260722.154128` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260722.154128`  
**Register:** Checkable (Two Rooms) — HAWM1 + harvest witness GREEN; fleets still Intent  

**Grounds in:** STOA283 lean **A** approved · HAWM1 · hawm-harvest-v1  

**dated_guard:** Fleets · HAWM2 · gold · JABS3 · UDP stay held.

---

## Proof

| Claim | Evidence |
|---|---|
| HAWM1 on AVD | GREEN · serial `emulator-5554` · Pixel listed |
| Session root | `99b3ae967c5a230acfc598a7e949b3c2c638ce996be47a51a7c9f8cb12e4c5fe` (native ≡ on-device) |
| Harvest field | `session_root` 64-hex · witness `hawm_harvest_session_root_witness` GREEN |

## Surfaces

| Path | Role |
|---|---|
| `tools/hawm0_emulator_serial.sh` | print `emulator-*` without Rish escape mangling |
| `tools/hawm1_capture_session_root.sh` | stdin → `hawm1-session-root.txt` |
| `tools/hawm_log_harvest_worker.sh` | folds `session_root` (or `pending`) |
| `tools/hawm_harvest_session_root_witness.rish` | GREEN |

---

*May every harvest name the root the emulator already proved.*
