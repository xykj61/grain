# STOA279 — HAWM Emulator Serial Pin Beside USB Pixel

*An Acme Corporation employee reading this gets the fix after a host boot→harvest attempt failed with Pixel attached: bare `adb wait-for-device` / `adb shell` raced the phone, `set -e` tore the AVD down mid-wait, and the harvest Bron on disk was a stale earlier fold — not a new GREEN.*

**Language:** EN  
**Version:** `20260722.153358` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — device-free serial-pin witness GREEN `20260722.153358` · host re-run pending  
**Register:** Checkable (Two Rooms) — serial pin GREEN; full boot→harvest still Intent until host onpath reprints GREEN  

**Grounds in:** STOA278 lean B host run `20260722.153130` · HAWM0 boot worker · Pixel `66041JEA306288`  

**dated_guard:** Do **not** treat `hawm-harvest.bron` as fresh unless its stamp is newer than the boot meta and the chain printed GREEN. Fleets · HAWM2 · gold · JABS3 stay held.

---

## What the host printout showed

1. KVM path opened; emulator launched; snapshot `default_boot` loaded.
2. Meta stopped at `waiting for sys.boot_completed=1` with no 10s pulse and no RED timeout — cleanup killed the AVD (~91 ms after snapshot).
3. `cat hawm-harvest.bron` showed stamp `20260722.152849` / GREEN — **stale** jail harvest half, not this boot.

Root cause: USB Pixel already on the adb server. Bare `wait-for-device` returned on the phone; bare `shell getprop` hit multi-device / wrong target under `set -e`.

---

## What landed

| Surface | Change |
|---|---|
| `hawm0_boot_worker.sh` | wait for `emulator-*` serial; `adb -s $SERIAL` for all shell/getprop; soft poll |
| `hawm1_sala_witness.rish` | push/shell/chmod/rm pin `-s ${serial.out}` |
| `hawm0_emulator_serial_pin_witness.rish` | device-free GREEN |

---

## Host retry (after send)

Paste **only** these lines (skip comment lines — a markdown `#` can confuse some pastes):

```bash
cd ~/urbit
rishi/bin/rishi run tools/hawm0_boot_harvest_onpath_host.rish
grep -E '^(stamp|status|boot_completed|model|serial)' tools/.cache/hawm0/hawm-harvest.bron
tail -20 tools/.cache/hawm0/hawm0-boot-meta.txt
```

Expect meta lines naming `emulator-…` and a harvest stamp **newer** than `20260722.152849`.

---

*May every adb call name the device it means.*
