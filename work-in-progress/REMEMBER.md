# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260718.190720` (Eastern) · voice Quin  
**Product nib:** ZETA6 · LULU0–5 · SETU5 · **HOLD0**  
**Suite nib:** ZETA0–6 · LULU0–5 · SETU0–SETU5 · HOLD0  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **HAWM** | GrapheneOS / Pixel SLC | HAWM0–1 GREEN · HAWM3 real Pixel |
| **TUBE** | App framework / NativeActivity pack | TUBE0.5 APK GREEN |
| **ZETA** | English QWERTY glass keyboard | ZETA0–6 GREEN (Pixel look) |
| **JABS** | Sala broadcast live-session fold | JABS0–2 GREEN · JABS3 check-in |
| **LULU** | Hearth · short home · Wired Glass | **LULU0–5 closed** |
| **SETU** | USB hearth carry Glass↔Desk | **SETU0–SETU5 · HOLD0 GREEN** · HOLD1 / SETU6 check-in |

Canon: [`../docs/HAWM.md`](../docs/HAWM.md) · [`../docs/TUBE.md`](../docs/TUBE.md) · [`../docs/ZETA.md`](../docs/ZETA.md) · [`../docs/JABS.md`](../docs/JABS.md) · [`../docs/LULU.md`](../docs/LULU.md) · [`../docs/SETU.md`](../docs/SETU.md)

---

## Outer terminal (host shell — not ai-jail)

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
# SETU0→HOLD0 — pull hearth · station · ping gate · Desk hold line
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
rishi/bin/rishi run tools/setu_desk_hold0_witness.rish
```

---

## Phone look (LULU closed)

Hold row 1 → Settings: presets · `home ·` · `wire ·` · `cell ·` — all Pixel GREEN.

## Open doors

| Door | Kind |
|------|------|
| Ship HOLD0 stale-bin honesty | **send** |
| **HOLD1** Desk Skate chrome from station | **check-in** |
| **SETU6** QEMU/Pixel CDC-NCM lab | **check-in** (parked) |
| Amber/Amphora Glass↔Desk fuse | **declined** — compose later (`133455`) |
| JABS3 · TAME Lap 3 | **check-in** |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
