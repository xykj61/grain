# Dexter English QWERTY Glass Keyboard

*Graphene’s system IME does not reliably appear on bare NativeActivity. Glow paints its own English QWERTY on Skate — iOS-inspired modes from public notes, clean-room — and drains taps into the seated Dexter Action path. Cursor blink is a sibling lap.*

**Version:** `20260717.175220` (Eastern)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** vision — design decision silo; K0–K4 named; no keys painted this send (Two Rooms).
**World study:** [`../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md`](../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md)

---

## Decisions Seated Here

1. **D3 Pixel look** — GREEN for install + `DEXTER line · glow`; **honest gaps:** no system soft keyboard visible; no blinking cursor.
2. **Do not depend on Graphene/AOSP IME** for glass typing. Keep hardware KEY drain (D3) as a bonus path.
3. **Implement a Glow-owned English QWERTY on-screen keyboard** under the Dexter / Brushstroke / Sala stack — Skate-painted, tap → `window_input.Action`.
4. **Layout family:** iOS English modes as publicly described (letters · numbers · symbols · emoji), Glow names and art. No Apple assets. Other languages later.
5. **Foundations, TAME root, and Glow rune surface stay unmoved.** This is product glass, not a new rune nest.
6. **Cursor blink** is lap **K3** — visible caret on the Dexter line — sibling to keys, not blocked by emoji.

## Clean-Room Law

Study public layout/behavior notes only. Emit Glow layout tables (Rye or Bron). Never vendor iOS keyboard binaries, SF Symbols packs, or copied bitmaps.

## Named Laps

| Lap | Claim | Gate |
|---|---|---|
| **K0** | English letters + numbers + symbols **layout tables** (device-free; witnessable) | this silo |
| **K1** | Paint letters mode on Skate (bottom of glass); hit boxes | K0 |
| **K2** | Tap → Dexter Action → live line refresh (replaces reliance on system IME) | K1 |
| **K3** | Blinking caret on `DEXTER line · …` | K2 or parallel after K1 |
| **K4** | Emoji mode SLC (bounded frequent set + few category tabs) | K2 |
| **K5** | Pixel look — keys + caret + type “glow” by tap | K2 · K3 |

Shift / caps, landscape reflow, and non-English layouts stay after K5.

## What Stays Unmoved

- Dexter D0–D3 KEY mapper and demo line.
- Dill gap.
- No Kotlin TextView host for IME attachment.
- `(jam …)` and B2 layout word — still check-in items, not this silo’s next.

## Aligned Next

**K0** — seat the English layout tables with a device-free witness (letters · 123 · symbols pages as data). Then K1 paint.

## Related

- Study: [`../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md`](../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md)
- Dexter silo: [`../active-reviving/20260717-172832_dexter-beside-brushstroke-dill-stays-gap.md`](../active-reviving/20260717-172832_dexter-beside-brushstroke-dill-stays-gap.md)
- Glass: [`../docs/TUBE.md`](../docs/TUBE.md) · [`../docs/COMPASS.md`](../docs/COMPASS.md)
- TAME: [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
- Language pin: [`../glow/README.md`](../glow/README.md)

---

*May every key we show be one we painted, and every blink mark a living line.*
