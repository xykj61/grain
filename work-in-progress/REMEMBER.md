# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260718.130756` (Eastern) · voice Quin  
**Product nib:** ZETA6 Pixel GREEN · **LULU0–2 sent** (hold-open perfect)  
**Suite nib:** ZETA0–6 · LULU0–2  

**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **HAWM** | GrapheneOS / Pixel SLC | HAWM0–1 GREEN · HAWM3 real Pixel |
| **TUBE** | App framework / NativeActivity pack | TUBE0.5 APK GREEN |
| **ZETA** | English QWERTY glass keyboard | ZETA0–6 GREEN (Pixel look) |
| **JABS** | Sala broadcast live-session fold | JABS0–2 GREEN · JABS3 check-in |
| **LULU** | Hearth display · short home · Wired Glass | **LULU0–2 sent** · next: Wired Glass · home_id |

Canon: [`../docs/HAWM.md`](../docs/HAWM.md) · [`../docs/TUBE.md`](../docs/TUBE.md) · [`../docs/ZETA.md`](../docs/ZETA.md) · [`../docs/JABS.md`](../docs/JABS.md) · [`../docs/LULU.md`](../docs/LULU.md)

---

## Outer terminal (host shell — not ai-jail)

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
```

---

## Phone look (ZETA6 · LULU closed)

1. Short tap row 1 → cycle presets (persists).  
2. Hold row 1 ~½s → list under finger; tap a name to set.  
3. `ret` = newline; `^` = send.

## Witnesses (device-free)

```bash
rishi/bin/rishi run tools/hearth_lulu0_witness.rish
rishi/bin/rishi run tools/hearth_lulu1_witness.rish
rishi/bin/rishi run tools/hearth_lulu2_witness.rish
```

---

## Open doors

| Door | Kind |
|------|------|
| **Wired Glass / Setu** (affirmed next) | **check-in** thin face |
| **home_id editor** (affirmed next) | **check-in** thin face |
| JABS3 · TAME Lap 3 | **check-in** |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
