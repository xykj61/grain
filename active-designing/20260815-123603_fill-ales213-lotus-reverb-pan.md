# Fill ALES213 — Lotus's reverb pan (reverberate the master wet, then place the wet image in the field)

**Stamp:** `20260815.123603` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES213**
**Kin:** [`20260815-122004_fill-ales212-lotus-reverb-width.md`](20260815-122004_fill-ales212-lotus-reverb-width.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES212 closed the reverb series' **width** axis — *how wide* the wash sits. Its own closing line named the next reverb-family rung: **reverb pan** — reverberate the master wet, then place the reverberated result *where* it sits in the field. Width answered how wide; pan answers where. A keeper wants the wash pushed toward one side while the dry mix holds centre — a reverb return panned left or right — and that is exactly *reverberate, then pan the wet image*.

The rung invents **no new audio arithmetic**. It composes ALES191's stereo reverb, ALES11's proven equal-power split (`power.split`), and ALES2's proven `timeline.gain`, adding only the ordering discipline: validate the pan first so a bad position never lets the reverb write.

## The shape — validate pan, reverberate wet, place the wet image

`reverb_pan(sc, clk, room, start_ms, count_ms, pan_pos, pan_den)`:

1. Validate the pan fraction (`BadPan` on a zero or over-bound denominator, or a position past the field) **before any write** — so a bad pan leaves the master fully dry and untouched.
2. `stereo_reverb_preset(sc, clk, room, start_ms, count_ms)` — reverberate the master WET in place (ALES191, unchanged). It prechecks its own faults before any write, so a reverb fault leaves the master dry.
3. Read the two equal-power weights `[w_left, w_right] = power.split(pan_pos, pan_den)` (ALES11, verbatim) and scale each wet channel by its weight over the field denominator: `gain(left, w_left/den)`, `gain(right, w_right/den)` (ALES2, saturating once — a proven no-op, since each weight is an attenuation ≤ den). The pan was proven legal in step 1 and each span is the whole clip, so neither gain can fault.

Every sample it writes is written by a stage already proven byte for byte.

## The edges name the knob

- **THE HARD-LEFT LAW** — `pan_pos == 0` gives weights `[den, 0]`: the left channel is scaled by `den/den` (identity) and the right by `0/den` (silence), so the whole wet wash routes to the left channel and the right goes quiet.
- **THE HARD-RIGHT LAW** — `pan_pos == den` mirrors it: the wash routes wholly to the right, the left goes quiet.
- **THE CENTRE LAW** — `pan_pos == den/2` gives equal weights `isqrt(den²/2) ≈ 0.707·den` on both sides: the equal-power centre holds the wash's loudness (−3 dB per channel) rather than the linear −6 dB, so a centred wet stays centred and both channels are attenuated equally below the pure wet.
- **THE COMPOSITION LAW** — for any legal position, `reverb_pan` equals `stereo_reverb_preset` then `gain(left, w_left/den)` and `gain(right, w_right/den)` byte for byte; it orders proven stages and invents nothing.
- **THE FAULT LAW** — a bad pan refuses `BadPan` before the reverb writes; a span past the clip forwards `DurationTooLong`, an out-of-range span `BadRange`, each before any write, the master left dry, untouched, and balanced.

## The provable laws the witness proves

1. **THE HARD-LEFT LAW** — `pan_pos == 0` leaves the left channel byte-exact the pure wet left and zeroes the right.
2. **THE HARD-RIGHT LAW** — `pan_pos == den` zeroes the left and leaves the right byte-exact the pure wet right.
3. **THE COMPOSITION LAW** — an off-centre pan equals `stereo_reverb_preset` then the two equal-power gains, byte for byte on both channels, and each channel is an attenuation (`|out| ≤ |wet|`).
4. **THE CENTRE-SYMMETRY LAW** — a centred master reverberates to a centred wet, and the equal-power centre gives equal weights, so panning it to centre keeps `left == right`, each attenuated below the wet.
5. **THE FAULT LAW** — a zero denominator, an over-bound denominator, and a position past the field each refuse `BadPan`; a span past the clip `DurationTooLong`, an out-of-range span `BadRange` — each leaving the master dry, untouched, and balanced.

## Honest scope

Software only, purely local. One bounded in-process i16 `StereoClip`, a validated clock, ALES191's fixed banks, siloed to `lotus/`. A pure composition of proven stages over existing samples — it fabricates none, changes no length, and reads no byte past either channel. The pan law is a routing weight, not a psychoacoustic or electrical claim. No real sample rate, no network, no keys, no funds, no real device, no real speaker. **No custody gate.**

## Next after this

`reverb_pan` places *where* the wash sits after ALES212's *how wide*. The natural next reverb-family rung is its stereo-axis-whole twin (a linked left/right pan or a per-return balance), keeping the reverb series' habit of a control rung followed by its stereo companion.
