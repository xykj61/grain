# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**.*

**Last refreshed:** `20260722.152631` (EDT) · voice Quin  
**Product nib:** ZETA6 · LULU0–5 · **SETU6.5 · live-sent** · HOLD* · LIVE paint · **HAWM harvest-v1**  
**Language nib:** **STOA0–276** · shape-only · Dexter→Sala LIVE closed · HAWM inventary GREEN  
**Suite nib:** ZETA0–6 · LULU0–5 · SETU0–SETU6.5 · live-sent · HOLD* · STOA0–276  
**Git nib:** *(pin after send)* · STOA275–276


**Season:** Framework · Eastern / EDT · HAWM harvest inventary GREEN · host boot→harvest next · round-close on.  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`  
**ADB:** `tools/.cache/hawm0/android-sdk/platform-tools/adb` — not on bare PATH  

---

## Now

**STOA276** `20260722.152631` — HAWM harvest inventary GREEN; lean B host boot→harvest chain. Brief [`../active-designing/20260722-152631_stoa276-after-hawm-harvest-checkin.md`](../active-designing/20260722-152631_stoa276-after-hawm-harvest-checkin.md).

**Harvest (device-free):**

```bash
rishi/bin/rishi run tools/hawm_log_harvest_witness.rish
# output: tools/.cache/hawm0/hawm-harvest.bron
```

**ADB / Pixel (copy-paste):**

```bash
export ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
$ADB shell run-as org.glow.app.sala_broadcaster cat files/sala_root.txt
$ADB shell run-as org.glow.app.sala_broadcaster cat files/sala_live_root.txt
```

---

## Open doors

| Door | Kind |
|------|------|
| Host boot → harvest chain | **kg** (STOA276 lean B · needs `/dev/kvm` host) |
| HAWM1 root into harvest Bron | lean C |
| Fleets · HAWM2 · gold · JABS3 · UDP | **held** |
| HAWM log-harvest inventary | **GREEN** `20260722.152523` |
| Dexter→Sala finishing edge | **closed** through STOA272 |

---

*Waymarks: HAWM · TUBE · ZETA · JABS · LULU · STOA · SETU*
