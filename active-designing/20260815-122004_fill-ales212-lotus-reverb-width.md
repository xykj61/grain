# Fill ALES212 — Lotus's reverb width (reverberate the master wet, then widen the wet result)

**Stamp:** `20260815.122004` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES212**
**Kin:** [`20260815-121345_fill-ales211-lotus-stereo-width.md`](20260815-121345_fill-ales211-lotus-stereo-width.md) · [`20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md`](20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES211 laid the general **width** control and named the reverb series' own next rung: **reverb width** — reverberate the master wet, then set how wide the reverberated result sits. This is the width axis the long reverb series opened, closed with the primitive ALES210 laid and ALES211 first spent. A keeper wants a reverb that sits wide across the whole field for air, or narrow toward the centre so the wash does not smear the mix — and that is exactly *reverberate, then widen*.

The rung proves the two proven stages compose whole: it invents **no new audio arithmetic**, adds only the ordering discipline (validate the width first so a bad fraction never lets the reverb write), and forwards each stage's faults by name.

## The shape — validate width, reverberate wet, widen the result

`reverb_width(sc, clk, room, start_ms, count_ms, width_num, width_den)`:

1. Validate the width fraction (`BadWidth` on a zero or over-bound denominator, or an over-bound numerator) **before any write** — before the reverb runs, so a bad width leaves the master fully dry and untouched.
2. `stereo_reverb_preset(sc, clk, room, start_ms, count_ms)` — reverberate the master WET in place (ALES191, unchanged). It prechecks its own faults before any write, so a reverb fault leaves the master dry.
3. `stereo_width(sc, width_num, width_den)` — widen the now-wet master (ALES211). The width was proven legal in step 1, so this stage **cannot fault** — the op refuses whole up front or completes whole.

Every sample it writes is written by a stage already proven byte for byte.

## The edges name the knob

- **THE UNITY EDGE** — `width == den` widens the wet by one, so `reverb_width` is `stereo_width(reverb, den, den)` — the mid/side round-trip over the reverberated master. On the wet result it holds ALES210's honest **≤ 1 LSB** round-trip cost per sample, byte-exact wherever the wet channel pair sums even. The knob at rest returns essentially the pure stereo reverb.
- **THE MONO COLLAPSE** — `width == 0` zeroes the wet's side, so both channels become the reverberated master's shared mid: a fully centred wash, `left == right` everywhere.
- **THE WIDEN LAW** — `width > den` grows the wet's side, so the reverberated channel difference `|L−R|` grows, the wash pushed outward (saturating at the rail, never wrapping).
- **THE CENTRED-INVARIANT LAW** — a centred master (`left == right`) reverberates through one shared bank to a centred wet (`left == right`), whose side is zero, so width leaves it untouched at any setting — a mono source has no reverb width to turn.
- **THE FAULT LAW** — a bad width refuses `BadWidth` before the reverb writes; a span past the clip forwards `DurationTooLong`, an out-of-range span `BadRange`, each before any write, the master left dry, untouched, and balanced.

## The provable laws the witness proves

1. **THE MONO COLLAPSE** — `width == 0` makes both channels the reverberated master's shared mid, identical.
2. **THE WIDEN LAW** — `width == 2·den` doubles the wet's side (proven byte for byte against the mid/side of the pure reverb), and `|L−R|` grows per sample.
3. **THE UNITY EDGE** — `width == den` stays within ≤ 1 LSB of the pure `stereo_reverb_preset` on every sample of both channels.
4. **THE CENTRED-INVARIANT LAW** — a centred master stays identical channel-to-channel through the reverberate-then-widen at any width.
5. **THE FAULT LAW** — a zero, over-bound-denominator, or over-bound-numerator width refuses `BadWidth`; a span past the clip `DurationTooLong`, an out-of-range span `BadRange` — each leaving the master dry, untouched, and balanced.

## Honest scope

Software only, purely local. One bounded in-process i16 `StereoClip`, a validated clock, ALES191's fixed banks, siloed to `lotus/`. A pure composition of two proven stages over existing samples — it fabricates none, changes no length, and inherits ALES210's honest ≤ 1 LSB round-trip cost at unity. No real sample rate, no network, no keys, no funds, no real device, no real speaker. **No custody gate.**

## Next after this

`reverb_width` closes the width axis the reverb series opened. The natural next reverb-family rung is **reverb balance** (`reverb_pan` — reverberate wet, then pan the wet image left or right through ALES10's proven equal-power pan), setting *where* the wash sits after *how wide*. Beyond the reverb family, the front-door drift first noted in the ALES210 lap (the Lotus README Status line stops at ALES159) still waits its own dedicated README + REMEMBER living-edge sync round.
