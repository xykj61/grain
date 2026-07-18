# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260718.122145` (Eastern) · voice Quin  
**Product nib:** JABS2 bare-ret chat GREEN · **ZETA6 / LULU design seated** (build next)  
**Suite nib:** ZETA4–5 GREEN · mode round-trip GREEN  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **HAWM** | GrapheneOS / Pixel SLC | HAWM0–1 GREEN · HAWM3 real Pixel GrapheneOS |
| **TUBE** | App framework / NativeActivity pack | TUBE0.5 APK GREEN · TUBE1 admitted glass |
| **ZETA** | English QWERTY glass keyboard | ZETA0–5 GREEN · **ZETA6** ret=newline · ↑=send (design) |
| **JABS** | Sala broadcast live-session fold | JABS0–2 GREEN · JABS3 check-in |
| **LULU** | Hearth display · short home · Wired Glass | LULU0+ open · waymark `20260718.122145` |

Canon: [`../docs/HAWM.md`](../docs/HAWM.md) · [`../docs/TUBE.md`](../docs/TUBE.md) · [`../docs/ZETA.md`](../docs/ZETA.md) · [`../docs/JABS.md`](../docs/JABS.md) · [`../docs/LULU.md`](../docs/LULU.md)

---

## Outer terminal (host shell — not ai-jail)

The jail has **no** `/dev/bus/usb`. Pack inside Cursor; install from a plain host terminal:

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices   # must show device (not unauthorized)
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
```

Re-pack after glass edits: `rishi/bin/rishi run tools/tube05_apk_pack_witness.rish` (inside jail is fine).

---

## Phone look (this pack — pre-ZETA6)

1. **ret** — still **submit** until ZETA6 lands; bare ret → `chat ·`; typed → `chat · …`.
2. **em / 123 → abc** — mode round-trip; app stays open (finish-zone).
3. **Close** — only `TAP ABOVE KB TO CLOSE` (Skate 13).
4. After ZETA6: **ret** = newline · **↑** = send.

---

## Open doors

| Door | Kind |
|------|------|
| **ZETA6** newline + ↑ send | **kg** (design seated) |
| **LULU0** Bron hearth `home_id` + preset | **kg** after ZETA6 |
| Host install if APK rebuilt | **kg** |
| JABS3 · TAME Lap 3 · Sensors orientation · Setu name | **check-in** |
| LULU2 Settings UI · Wired Glass metalsmoke | **check-in** |

Silo: [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md)

---

## Words

| Word | Means |
|------|--------|
| **remember** | Reprint this card |
| **kg** | Keep going — not ship |
| **align** | Walk compass · fix plan drift |
| **send** | Commit · push · merge to pier |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
