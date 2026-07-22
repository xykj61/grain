# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**.*

**Last refreshed:** `20260722.152849` (EDT) · voice Quin  
**Product nib:** ZETA6 · LULU0–5 · **SETU6.5 · live-sent** · HOLD* · LIVE paint · **HAWM harvest-v1** · boot→harvest chain  
**Language nib:** **STOA0–278** · shape-only · Dexter→Sala LIVE closed · HAWM harvest chain authored  
**Suite nib:** ZETA0–6 · LULU0–5 · SETU0–SETU6.5 · live-sent · HOLD* · STOA0–278  
**Git nib:** *(pin after send)* · STOA277–278


**Season:** Framework · Eastern / EDT · boot→harvest chain authored · jail has no `/dev/kvm` · host onpath for full GREEN · round-close on.  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`  
**ADB:** `tools/.cache/hawm0/android-sdk/platform-tools/adb` — not on bare PATH  

---

## Now

**STOA278** `20260722.152849` — boot→harvest chain authored; lean B host onpath full GREEN. Brief [`../active-designing/20260722-152849_stoa278-after-boot-harvest-chain-checkin.md`](../active-designing/20260722-152849_stoa278-after-boot-harvest-chain-checkin.md).

**Host onpath (lean B — needs `/dev/kvm`, plain terminal):**

```bash
rishi/bin/rishi run tools/hawm0_boot_harvest_onpath_host.rish
cat tools/.cache/hawm0/hawm-harvest.bron
```

**Device-free chain check:**

```bash
rishi/bin/rishi run tools/hawm0_boot_harvest_chain_witness.rish
```

**ADB / Pixel:**

```bash
export ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
```

---

## Open doors

| Door | Kind |
|------|------|
| Host onpath full boot→harvest GREEN | **host** (STOA278 lean B · `/dev/kvm`) |
| HAWM1 / Pixel root into harvest Bron | **kg** after approve (lean C · Pixel adb works here) |
| Fleets · HAWM2 · gold · JABS3 · UDP | **held** |
| Boot→harvest chain authored | **GREEN** harvest half `20260722.152801` |

---

*Waymarks: HAWM · TUBE · ZETA · JABS · LULU · STOA · SETU*
