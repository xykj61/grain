# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260717.213242` (Eastern) · voice Quin  
**Product nib:** JABS2 finish-zone + live chat (device-free GREEN; Pixel eyes pending this pack)  
**Suite nib:** ZETA4 emoji + mode round-trip GREEN  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **HAWM** | GrapheneOS / Pixel SLC | HAWM0–1 GREEN · HAWM3 real Pixel GrapheneOS |
| **TUBE** | App framework / NativeActivity pack | TUBE0.5 APK GREEN · TUBE1 admitted glass |
| **ZETA** | English QWERTY glass keyboard | ZETA0–5 GREEN · mode round-trip GREEN |
| **JABS** | Sala broadcast live-session fold | JABS0–2 GREEN · JABS3 check-in |

Canon: [`../docs/HAWM.md`](../docs/HAWM.md) · [`../docs/TUBE.md`](../docs/TUBE.md) · [`../docs/ZETA.md`](../docs/ZETA.md) · [`../docs/JABS.md`](../docs/JABS.md) · draw `tools/waymark_derive.rish`

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

## Phone look (this pack)

1. **ret** — Dexter submit refreshes JABS2 row as `chat · …` (paint).
2. **em / 123 → abc** — mode round-trip; app must stay open (finish-zone fix).
3. **Close** — only the painted `TAP ABOVE KB TO CLOSE` row (Skate 13). Taps on the audience strip (14–15) stay; they do not finish the app.
4. Emoji faces still insert UTF-8; distinct atlas glyphs.

---

## Open doors

| Door | Kind |
|------|------|
| Host install + Pixel look for finish-zone / mode switch | **kg** |
| JABS3 inference + economics | **check-in** |
| TAME Lap 3 (`mantra/bolt_apply_step`, `tally/kumara`, `tally/pedersen`) | **check-in** |
| Glow Glass orientation (Sensors → layout) | **check-in** |
| Next Glow language rung `(jam …)` / multi-line composition | language lane — see Acme note |

Acme map for first Glow code + open runes: [`../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md`](../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md)

---

## Words

| Word | Means |
|------|--------|
| **remember** | Reprint this card |
| **kg** | Keep going (mechanical next lap) — not ship |
| **align** | Walk compass · fix plan drift |
| **send** | Commit · push · merge to pier |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
