# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260719.204340` (Eastern) · voice Quin  
**Product nib:** ZETA6 · LULU0–5 · **SETU6.5** · HOLD0–HOLD1 · HOLD-W  
**Language nib:** **STOA0–89** GREEN · STOA90 open  
**Suite nib:** ZETA0–6 · LULU0–5 · SETU0–SETU6.5 · HOLD0–HOLD1 · HOLD-W · STOA0–89  
**Git nib:** `f29414bb99` STOA89 rune alphabet · fixture/generator wording  
 
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Now (language)

**STOA89** rune pronunciation alphabet · RISC-V notes · fixture/generator wording GREEN `20260719.204001` — Hoon glyph alphabet adopted as Glow canon; Lexicon **Fixture desk** · **Generator** · **Sample** · **Glow gate** · **Rune alphabet**; roadmap G0–G5 seated. Next door: **STOA90** check-in.

Canon: [`../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) · Acme [`../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md`](../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md)

Hold: closed pronunciation table (G1) · argv sample generator (G3) · token-driven lower · tidy `lower_mold` · Sala B0 rewrite.

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **HAWM** | GrapheneOS / Pixel SLC | HAWM0–1 GREEN · HAWM3 real Pixel |
| **TUBE** | App framework / NativeActivity pack | TUBE0.5 APK GREEN |
| **ZETA** | English QWERTY glass keyboard | ZETA0–6 GREEN (Pixel look) |
| **JABS** | Sala broadcast live-session fold | JABS0–2 GREEN · JABS3 check-in |
| **LULU** | Hearth · short home · Wired Glass | **LULU0–5 closed** |
| **SETU** | USB hearth carry Glass↔Desk | **SETU0–SETU6.5 · HOLD0–HOLD1 · HOLD-W GREEN** · live “sent” eyes check-in |
| **STOA** | Glow language SLC · nest · composition | **STOA0–89 GREEN** · alphabet roadmap · STOA90 next |

Canon: [`../docs/HAWM.md`](../docs/HAWM.md) · [`../docs/TUBE.md`](../docs/TUBE.md) · [`../docs/ZETA.md`](../docs/ZETA.md) · [`../docs/JABS.md`](../docs/JABS.md) · [`../docs/LULU.md`](../docs/LULU.md) · [`../docs/SETU.md`](../docs/SETU.md) · [`../docs/STOA.md`](../docs/STOA.md)

---

## Outer terminal (host shell — not ai-jail)

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
# STOA73 A on-device half (hawm0 or Pixel):
# rishi/bin/rishi run tools/hawm0_boot_onpath_host.rish   # if no device yet
rishi/bin/rishi run tools/stoa73_product_root_install_onpath_host.rish
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
# SETU0→HOLD1 — pull · station · ping gate · hold line · Skate cells
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
# SETU6 + SETU6.5 — lab card · TX gate (stand-in SKIP without usb0/ncm)
rishi/bin/rishi run tools/setu6_lab_probe_onpath_host.rish
rishi/bin/rishi run tools/setu65_lab_tx_onpath_host.rish
# device-free Skate + Wayland raster
rishi/bin/rishi run tools/setu_desk_hold_wayland_witness.rish
# eyes (host Wayland session — close the window when done):
# linengrow/bin/setu_desk_hold_wayland_look
```

---

## Phone look (LULU closed)

Hold row 1 → Settings: presets · `home ·` · `wire ·` · `cell ·` — all Pixel GREEN.

## Open doors

| Door | Kind |
|------|------|
| **STOA90** next language (pronunciation table · argv sample · token lower · tidy mold · Sala B0) | **check-in** |
| Live SETU6.5 **sent** on usb0/ncm | **check-in** (needs gadget/QEMU) |
| Amber/Amphora Glass↔Desk fuse | **declined** — compose later (`133455`) |
| JABS3 · TAME Lap 3 | **check-in** |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
