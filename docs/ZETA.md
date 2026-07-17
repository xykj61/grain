# ZETA — Glow English QWERTY glass keyboard ladder

*Waymark for Dexter’s on-Skate English keyboard. Own keys; Graphene IME stays optional hardware path. Compresses the silo; never replaces it.*

**Status:** Checkable — operator compressor
**Depth:** guide
**Ceiling:** ≤80 lines
**Last updated:** 2026-07-17
**Compresses:** [`20260717-175220_dexter-english-qwerty-glass-keyboard.md`](../active-designing/20260717-175220_dexter-english-qwerty-glass-keyboard.md) · study [`20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md`](../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md)

---

## Thesis — paint the hand

Bare NativeActivity does not attach Graphene/AOSP soft IME reliably. **ZETA** is Glow’s own English QWERTY on Skate: layout tables → paint → tap → Dexter `Action`. iOS-inspired modes from public notes; clean-room.

**Waymark draw:** input `glow-english-qwerty-glass-keyboard-3` · SHA3-512 · flw.txt → **ZETA** (`tools/waymark_derive.rish`, `20260717.180025`).

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **ZETA0** | Letters · numbers · symbols layout tables | `tools/dexter_glass_keyboard_witness.rish` | **GREEN** `20260717.180025` |
| **ZETA1** | Paint letters mode on Skate; hit boxes | same witness · pack | **GREEN** `20260717.180558` · Pixel look `20260717.180933` |
| **ZETA2** | Tap → Dexter Action → live line | same witness · pack | **GREEN** `20260717.180933` · Pixel typing look `20260717.183345` |
| **ZETA3** | Blinking caret on Dexter line | `dexter_glass_witness` · pack · timerfd | **GREEN** `20260717.182826` · Pixel blink look `20260717.183345` |
| **ZETA2b** | Hit boxes match paint · phone density · portrait fill | same witness · pack | **GREEN** `20260717.183842` · Pixel look `20260717.184837` |
| **ZETA4** | Emoji mode SLC — frequent + 4 tabs · UTF-8 · monochrome atlas | same witness · pack | **GREEN** `20260717.185520` · Pixel look `20260717.190045` · distinct glyphs polish |
| **ZETA5** | Pixel look — keys + caret + type by tap | ZETA2 · ZETA3 · ZETA2b | **GREEN** `20260717.184837` |

## Hands-on

```bash
rishi/bin/rishi run tools/waymark_derive.rish   # input_name = …-keyboard-3
rishi/bin/rishi run tools/dexter_glass_keyboard_witness.rish
```

Layout: [`linengrow/dexter_glass_keyboard_layout.rye`](../linengrow/dexter_glass_keyboard_layout.rye).

---

*May every rung name its ladder, and every key prove before it paints.*
