# STOA239 — Pixel Eyes · Embedded Lit Desk Fold

*An Acme Corporation employee reading this gets on-device proof after the embed pack: the Pixel ran the NativeActivity APK, `onCreate` wrote `sala_root.txt` with the HAWM1 hex, and product root `5` landed beside it. Use the SDK `adb`, not a bare PATH `adb`.*

**Language:** EN  
**Version:** `20260722.135605` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260722.135605`  
**Register:** Checkable (Two Rooms) — install proof GREEN; bare `adb` on PATH is absent — use SDK path  

**Grounds in:** STOA238 lean **B** · STOA237 embed · `tube05_install_proof_onpath_host.rish`

**dated_guard:** Do **not** claim bare `adb` is on PATH. Prefer  
`tools/.cache/hawm0/android-sdk/platform-tools/adb`. JABS3 held.

---

## Verdict (one breath)

**PIXEL_EMBED_EYES.** Install Success · `sala_root.txt` = `99b3ae96…c5fe` · product root `5` · install-proof witness GREEN.

---

## Witness / operator

```bash
export ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
rishi/bin/rishi run tools/tube05_install_proof_onpath_host.rish
```

---

## Hold

Glow `face_lit` on product path. JABS3.
