# Fill ALES211 — Lotus's stereo width (the image narrowed or widened, spending the mid/side primitive)

**Stamp:** `20260815.121345` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES211**
**Kin:** [`20260815-120505_fill-ales210-lotus-mid-side.md`](20260815-120505_fill-ales210-lotus-mid-side.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES210 laid the **mid/side** primitive and named the rung that would first spend it: **width**. This round takes it, proving the primitive was worth laying first — width is exactly `scale the side, recombine`, and now that mid/side stands proven, width composes it with the already-proven `timeline.gain` and **invents no new audio arithmetic** of its own. A keeper mixing a stereo master reaches for width more than almost any knob: pull the image toward mono to seat a part back, or push it out past the speakers for air.

## The shape — encode, scale the side, decode

`stereo_width(sc, width_num, width_den)`:

1. Validate the width fraction (`BadWidth` on a zero or over-bound denominator, or an over-bound numerator) **before any write**.
2. `mid_side.encode(sc)` — fold LEFT/RIGHT into MID/SIDE in place (ALES210, total).
3. `timeline.gain(&sc.right /* the side */, 0, len, width_num, width_den)` — scale the side by the width fraction, saturating once (ALES2, proven).
4. `mid_side.decode(sc)` — fold MID/SIDE back into LEFT/RIGHT in place (ALES210, total).

Because the width is prechecked and the gain runs over the full valid span with a non-zero denominator, the gain and decode cannot fault — the op refuses whole up front or completes whole, the master untouched on any refusal.

## The three edges name the knob

- **THE UNITY EDGE** — `width == den` scales the side by one, so `stereo_width` is exactly `decode(encode)`: on a same-parity master, the original byte for byte. The knob at rest moves nothing.
- **THE MONO COLLAPSE** — `width == 0` zeroes the side, so decode gives both channels the shared `mid = (l+r)/2`: the image pulled fully to centre, `left == right` everywhere.
- **THE WIDEN LAW** — `width > den` grows the side, so the per-sample channel difference `|L−R|` grows, the image pushed outward (saturating at the rail, never wrapping).

## The provable laws the witness proves

1. **THE UNITY EDGE** — width == den returns the same-parity original byte for byte.
2. **THE MONO COLLAPSE** — width == 0 makes both channels the shared mid, identical.
3. **THE WIDEN LAW** — width == 2·den doubles the side (proven byte for byte), and `|L−R|` grows per sample.
4. **THE CENTRED-INVARIANT LAW** — a centred master (l == r) is untouched at any width; a mono signal has no width to turn.
5. **THE BALANCE / FAULT LAW** — both channels stay balanced at even and odd lengths; a zero, over-bound-denominator, or over-bound-numerator width refuses `BadWidth` with the master untouched.

## Honest scope

Software only, purely local. Two bounded in-process i16 `Clip`s on one bench, siloed to `lotus/`. A pure composition of proven stages over existing samples — it fabricates none, changes no length, reads no byte past either channel's len, and inherits ALES210's honest ≤ 1 LSB round-trip cost at unity. No real sample rate, no network, no keys, no funds, no real device, no real speaker. **No custody gate.**

## Next after this

`stereo_width` is the general width control on any stereo master. The **reverb width** rung (`reverb_width` — reverberate the master wet, then widen the wet tail with exactly this control) is the natural next reverb-family rung, closing the width axis the reverb series opened. Beyond it, the front-door drift found in the ALES210 lap (the Lotus README Status line stops at ALES159) still waits its own dedicated README + REMEMBER living-edge sync round.
