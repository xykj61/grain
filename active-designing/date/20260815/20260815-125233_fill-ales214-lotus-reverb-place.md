# Fill ALES214 — Lotus's reverb place (reverberate the master wet, then seat the wet image: how wide AND where)

**Stamp:** `20260815.125233` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES214**
**Kin:** [`20260815-123603_fill-ales213-lotus-reverb-pan.md`](20260815-123603_fill-ales213-lotus-reverb-pan.md) · [`20260815-122004_fill-ales212-lotus-reverb-width.md`](20260815-122004_fill-ales212-lotus-reverb-width.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES212 answered **how wide** the reverb wash sits (`reverb_width`); ALES213 answered **where** it sits (`reverb_pan`). A keeper mixing a stereo master reaches for both at once — seat the reverb return *narrow and slightly left*, or *wide and centred* — yet each rung asked for the other's work to be run as a separate call. This rung is the honest capstone the width and pan sub-series earned: **reverb place** — reverberate the master wet, then seat the wet image with a single call that sets **both** how wide and where.

The design read for ALES213 named its next as a stereo-axis twin (a linked pan or per-return balance). Examined against the proven primitives, a true cross-mixing pan of an already-stereo wet would need **new cross-channel arithmetic** — a DSP design seam that breaks the reverb series' standing discipline of *no new audio arithmetic*. `reverb_place` takes the honest path instead: it composes three stages already proven byte for byte, inventing nothing, and closes the "seat the reverb in the field" pair rather than opening a seam.

## The shape — validate both fractions, reverberate, widen, place

`reverb_place(sc, clk, room, start_ms, count_ms, width_num, width_den, pan_pos, pan_den)`:

1. Validate the **width** fraction (`BadWidth`) **and** the **pan** fraction (`BadPan`), both **before any write** — using ALES211's and ALES213's own bounds verbatim, so a bad fraction leaves the master fully dry and untouched.
2. `stereo_reverb_preset(sc, clk, room, start_ms, count_ms)` — reverberate the master WET in place (ALES191, unchanged; it prechecks its own faults before any write).
3. `stereo_width(sc, width_num, width_den)` — set how wide the reverberated wet sits (ALES211, the width proven legal above so it cannot fault).
4. Read `[w_left, w_right] = power.split(pan_pos, pan_den)` (ALES11, verbatim) and scale each wet channel by its equal-power weight over the field denominator through `timeline.gain` (ALES2, saturating once — a proven no-op, each weight an attenuation ≤ den).

One reverb, then two proven placements. Every sample it writes is written by a stage already proven byte for byte.

## The edges name the two knobs

- **THE WIDTH-AT-CENTRE LAW** — `width_num == 0` (mono collapse) with `pan_pos == pan_den/2` (equal-power centre): the wet folds to its shared mid on both channels, then the centre pan attenuates both equally — a mono wash held centred below the pure wet.
- **THE PAN-AT-UNITY LAW** — `width_den == width_num` (unity, the mid/side round-trip) with `pan_pos == 0` (hard left): the wet keeps essentially its stereo image, then the whole wash routes left (left scaled by `den/den`, right silenced).
- **THE COMPOSITION LAW** — for any legal width and pan, `reverb_place` equals `stereo_reverb_preset` then `stereo_width` then the two equal-power gains, **byte for byte** on both channels; it orders proven stages and invents nothing.
- **THE CENTRED-INVARIANT LAW** — a centred master (`left == right`) reverberates through one shared bank to a centred wet whose side is zero, so width leaves it untouched; a centre pan then keeps `left == right`, each attenuated below the wet.
- **THE FAULT LAW** — a bad width refuses `BadWidth`, a bad pan `BadPan`, each **before the reverb writes**; a span past the clip forwards `DurationTooLong`, an out-of-range span `BadRange`, each before any write, the master left dry, untouched, and balanced.

## The provable laws the witness proves

1. **THE WIDTH-AT-CENTRE LAW** — `width_num == 0`, `pan` centre: both channels equal (mono), each an attenuation of the reverberated shared mid.
2. **THE PAN-AT-UNITY LAW** — `width == unity`, `pan == 0`: the right channel is silenced and the left is the unity-width wet placed left (`≤ 1 LSB` of the pure wet left, ALES210's honest round-trip cost).
3. **THE COMPOSITION LAW** — a general width and off-centre pan equals `stereo_reverb_preset` then `stereo_width` then the two equal-power gains, byte for byte on both channels, and each channel is an attenuation of the widened wet.
4. **THE CENTRED-INVARIANT LAW** — a centred master seated at centre keeps `left == right`, each attenuated below the pure wet.
5. **THE FAULT LAW** — a zero/over-bound width `BadWidth`, a zero/over-bound/over-position pan `BadPan`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange` — each leaving the master dry, untouched, and balanced.

## Honest scope

Software only, purely local. One bounded in-process i16 `StereoClip`, a validated clock, ALES191's fixed banks, siloed to `lotus/`. A pure composition of three proven stages over existing samples — it fabricates none, changes no length, and reads no byte past either channel; it inherits ALES210's honest `≤ 1 LSB` mid/side round-trip cost at unity width. The width and pan laws are routing weights, not psychoacoustic or electrical claims. No real sample rate, no network, no keys, no funds, no real device, no real speaker. **No custody gate.**

## Next after this

`reverb_place` seats the reverb return in the field (how wide and where) over one reverb. With the width and pan sub-series closed, the natural next reverb-family question is whether the family is complete — the reverb suite already carries mix, time, tone, predelay, console-predelay, gate, gated envelope, shelf, early/late, freeze, width, pan, place, and preset. The honest next crux may open a **fresh Lotus family** (a spatial or utility surface) rather than another reverb knob; name it as its own self-approved design round.
