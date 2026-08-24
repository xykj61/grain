# ALES4 -- Lotus's fade envelope

**Stamp:** `20260814.113625` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES3
**Waymark:** ALES - rung ALES4
**Kin:** [`ALES2 -- the timeline edits`](20260814-fill-ales2-lotus-timeline-edits.md) - [`ALES3 -- mix a second track`](20260814-fill-ales3-lotus-mix-second-track.md) - [`lotus/fade.rye`](../lotus/fade.rye) - [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2)

---

## Why this round

ALES2's `gain` scaled a span by **one** constant fraction. The gesture every editor reaches for next is a **fade** -- a gain whose fraction **ramps** across the span, opening a clip from silence (fade-in) or closing it to silence (fade-out). A fade is what keeps a cut from clicking: the waveform arrives and departs at zero rather than jumping. It is the smallest honest step from a flat scale to an envelope, and it reuses ALES2's one owed correctness.

## The one crux this rung fixes

**A fade scales a span by a fraction that interpolates linearly from a start level to an end level, with exact endpoints, and it saturates when the ramp climbs past unity.** Two things must hold together:

1. **Exact endpoints, linear middle.** At position `0` the fraction is exactly `num0/den`; at the last position it is exactly `num1/den`; between, the ramp steps linearly. A fade-in (`0 -> den`) leaves the first sample silent and the last unchanged; a fade-out (`den -> 0`) mirrors it. The interpolation runs in `i64`, so a wide level difference never overflows before it is scaled.
2. **Saturation, still.** A ramp that climbs past `1x` pins each result to the i16 range rather than wrapping -- the same floor and ceiling ALES2's gain keeps, **reused** from `timeline.saturate`. One true saturation across gain, mix, and now fade.

## The shape

`lotus/fade.rye`:

- `fade(clip, start, count, num0, num1, den)` -- scale the span by the ramp `num0/den -> num1/den`, saturating; values only, never the length. Refuses `BadGain` (zero denominator) and `BadRange` (span outside the samples) at the edge, before any write.
- `ramp_num(num0, num1, i, count)` -- the linear interpolation `num0 + (num1 - num0)-i / (count - 1)`, in `i64`; a single-sample span is the degenerate ramp and takes the end level.
- Reuses `timeline.saturate` and `timeline.Clip`.

A fade is a gain whose fraction moves, so it composes cleanly: ALES3's `mix` sums a track under a **fade-out** with another under a **fade-in** -- a crossfade -- with no new machinery.

## What the witness proves (GREEN on metal)

`tools/al/ales_fade_witness.rish`: a fade-in ramps `0 -> full` with exact endpoints (first sample silent, last unchanged) and a linear middle; a fade-out mirrors it to silence; a ramp past unity saturates (`20000x2` and `x3` pin to `+32767`); a sub-span fade leaves the rest untouched; a single-sample fade takes the end level; a zero denominator refuses `BadGain`; an out-of-range span refuses `BadRange` leaving the clip untouched. GREEN on the first build. Purely local -- no socket, no network, no keys, no funds, no real device, no real sample rate (the ramp runs across sample indices, not seconds).

## The road on

The next Lotus rung can **clock** the timeline to a real sample rate (so a fade length is named in milliseconds, not sample counts, and a crossfade aligns two clips in time), open a small **track table** so more than two tracks mix at once, or add a **curve** to the fade (equal-power rather than linear, for a click-free crossfade). The audio-interface **hardware** stays a paused research round, taken only on Keaton's word.

---

*The sound arrives from silence and returns to it, and never once wraps or clicks on the way. May every fade a keeper draws open as gently as they meant, and close as kindly.*
