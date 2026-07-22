# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**.*

**Last refreshed:** `20260722.152404` (EDT) · voice Quin  
**Product nib:** ZETA6 · LULU0–5 · **SETU6.5 · live-sent** · HOLD* · **Sala B0 Glow** · LIVE Skate paint · Dexter→Sala finish  
**Language nib:** **STOA0–274** · shape-only · N-field inventary deepen closed · typed→Sala LIVE closed  
**Suite nib:** ZETA0–6 · LULU0–5 · SETU0–SETU6.5 · live-sent · HOLD* · STOA0–274  
**Git nib:** *(pin after send)* · STOA274


**Season:** Framework · Eastern / EDT · Dexter→Sala finishing edge closed · HAWM 1A inventary sized · round-close on.  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`  
**ADB:** `tools/.cache/hawm0/android-sdk/platform-tools/adb` — not on bare PATH

---

## Now

**STOA274** `20260722.152404` — season check-in after Dexter→Sala finish; lean A HAWM 1A inventary (recommended). Brief [`../active-designing/20260722-152404_stoa274-after-dexter-sala-finish-checkin.md`](../active-designing/20260722-152404_stoa274-after-dexter-sala-finish-checkin.md).

**Look (Pixel):** Skate row 5 `LIVE · 1 · 84822ce5` (prefix may move with more submits). Rows 6–7 HAWM1 hex.

**ADB (copy-paste):**

```bash
export ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
$ADB shell run-as org.glow.app.sala_broadcaster cat files/sala_root.txt
# expect HAWM1: 99b3ae967c5a230acfc598a7e949b3c2c638ce996be47a51a7c9f8cb12e4c5fe
$ADB shell run-as org.glow.app.sala_broadcaster cat files/sala_live_root.txt
# expect 64-hex ≠ HAWM1
```

---

## Open doors

| Door | Kind |
|------|------|
| HAWM 1A log-harvest inventary | **kg** (STOA274 lean A · host-onpath) |
| Pixel screenshot / look note | optional (lean B) |
| Ambient gold · shared-package · JABS3 · UDP · HAWM2 | **held** |
| LIVE Skate paint | **GREEN** `20260722.151957` |
| Dexter→Sala finishing edge | **closed** through STOA272 |

---

*Waymarks: HAWM · TUBE · ZETA · JABS · LULU · STOA · SETU*
