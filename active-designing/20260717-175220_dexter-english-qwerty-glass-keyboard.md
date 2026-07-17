# Dexter English QWERTY Glass Keyboard

*Graphene’s system IME does not reliably appear on bare NativeActivity. Glow paints its own English QWERTY on Skate — iOS-inspired modes from public notes, clean-room — and drains taps into the seated Dexter Action path. Cursor blink is a sibling lap. Ladder waymark: **ZETA**.*

**Version:** `20260717.175220` (Eastern) · waymark **ZETA** + ZETA0 `20260717.180025`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Mixed — design seated; **ZETA0** layout tables Checkable GREEN; paint still vision (Two Rooms).
**World study:** [`../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md`](../external-research/20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md)
**Compressor:** [`../docs/ZETA.md`](../docs/ZETA.md)

---

## Decisions Seated Here

1. **D3 Pixel look** — GREEN for install + `DEXTER line · glow`; **honest gaps:** no system soft keyboard visible; no blinking cursor.
2. **Do not depend on Graphene/AOSP IME** for glass typing. Keep hardware KEY drain (D3) as a bonus path.
3. **Implement a Glow-owned English QWERTY on-screen keyboard** under the Dexter / Brushstroke / Sala stack — Skate-painted, tap → `window_input.Action`.
4. **Layout family:** iOS English modes as publicly described (letters · numbers · symbols · emoji), Glow names and art. No Apple assets. Other languages later.
5. **Foundations, TAME root, and Glow rune surface stay unmoved.** This is product glass, not a new rune nest.
6. **Waymark ZETA** — drawn `20260717.180025` from input `glow-english-qwerty-glass-keyboard-3` via `tools/waymark_derive.rish`. Living rungs **ZETA0–ZETA5**.
7. **Cursor blink** is lap **ZETA3**.

## Clean-Room Law

Study public layout/behavior notes only. Emit Glow layout tables (Rye). Never vendor iOS keyboard binaries, SF Symbols packs, or copied bitmaps.

## Named Laps (waymark ZETA)

| Lap | Claim | State |
|---|---|---|
| **ZETA0** | English letters + numbers + symbols **layout tables** | **GREEN** · `tools/dexter_glass_keyboard_witness.rish` |
| **ZETA1** | Paint letters mode on Skate; hit boxes | open |
| **ZETA2** | Tap → Dexter Action → live line refresh | open |
| **ZETA3** | Blinking caret on `DEXTER line · …` | open |
| **ZETA4** | Emoji mode SLC (bounded frequent set) | open |
| **ZETA5** | Pixel look — keys + caret + type by tap | open |

## Aligned Next

**ZETA1** — paint the letters page on Skate with hit boxes.

## Related

- Study · layout · waymark law · Dexter reviving silo · [`../docs/ZETA.md`](../docs/ZETA.md)

---

*May every key we show be one we painted, and every blink mark a living line.*
