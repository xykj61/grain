# STOA270 — NativeActivity Submit → Live Root

*An Acme Corporation employee reading this gets the glass wire: Dexter `.submit` calls `commit_live_typed_memo` through `dexter_sala_append`, and `files/sala_live_root.txt` holds the live typed-append digest beside HAWM1 `sala_root.txt`. OnCreate seeds one live append from held demo `glow` so install eyes can prove the path without a tap; later submits append into the same live log.*

**Language:** EN  
**Version:** `20260722.151515` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260722.151515`  
**Register:** Checkable (Two Rooms) — pack + install prove HAWM1 pin and distinct live root  

**Grounds in:** STOA269 lean **B** · STOA268 Dexter helper · STOA266 typed memo · STOA263 authored-fold eyes  

**dated_guard:** Do **not** overwrite `sala_root.txt` with the live root. Do **not** claim UDP hop or JABS3. Live digest may change when more submits land — install eyes assert shape and ≠ HAWM1, not a fixed live pin.

---

## Verdict (one breath)

**GLASS_LIVE_APPEND.** `.submit` → helper · `sala_live_root.txt` · `glow_last_live_root_hex` · HAWM1 `sala_root` still `99b3ae96…c5fe` · live `84822ce5…9b1a` (seeded `glow`).

---

## Witness / operator

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
export ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
rishi/bin/rishi run tools/dexter_sala_append_witness.rish
rishi/bin/rishi run tools/tube05_apk_pack_witness.rish
rishi/bin/rishi run tools/tube05_install_proof_onpath_host.rish
```

---

## Hold

HAWM 1A · gold · shared-package · JABS3 · UDP · fixed live-root pin (digest moves with more events).
