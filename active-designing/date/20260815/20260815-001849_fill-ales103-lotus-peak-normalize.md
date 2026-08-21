# Fill ALES103 — the Lotus peak normalize (measure the loudest sample, then scale the clip so it lands on the target)

**Stamp:** `20260815.001849` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES103**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES102`](20260815-001200_fill-ales102-lotus-smoothed-silence-trim.md)
**Stands on:** `lotus/meter.rye` (ALES13 — the peak/RMS meter, its `measure` and `peak`) · `lotus/timeline.rye` (ALES2 — the Clip and the saturating `gain`) · `lotus/power.rye` (ALES11 — the isqrt the meter is built on, reached only through ALES13)

## Why this rung, now

The silence family (ALES96–102) is whole — strip, split, top-and-tail, pad, collapse, smooth, and the smoothed trim that ties them together. That family answered *where is the sound?* This rung answers the question a keeper asks the instant the sound is found: *how loud is it, and can every take be the same loudness?*

**Peak normalization is the single most-reached-for gesture in every editor and DAW** — the "Normalize" menu item, one click on a whole clip. A take recorded quiet and a take recorded hot both leave the same peak after normalize, so a keeper mixes without fighting the input level. It is a Lindy crux precisely because it is *level*, the thing every other level tool (the fader, the compressor, the limiter) is measured against — and it is the first Lotus rung to **fuse the reader and the writer**: ALES13 reads the loudest sample, ALES2 scales the clip, and normalize is nothing but the one composed on the other.

## The shape

`lotus/normalize.rye` exposes `normalize_peak(clip, target)` — `target` a magnitude in `[1, sample_max]`. It measures the clip's peak through ALES13's `measure`; a silent clip (peak 0) is left **exactly as it is** (no peak to lift, and the guard that keeps the division below from ever dividing by zero); otherwise it scales the whole clip `[0, clip.len)` by `target/peak` through ALES2's `gain`. Amplify (peak below target) and attenuate (peak above target) are the same call — one fraction, two directions.

## The crux — four laws

1. **The scale law.** Normalize is nothing but ALES13's `measure` followed by ALES2's `gain(clip, 0, len, target, peak)` — it invents no new arithmetic, so it can never drift from the meter it reads or the gain it delegates to. A peak of 8000 to 16000 is a clean ×2; a peak of 30000 to 15000 a clean ×0.5.
2. **The peak law.** After normalize to `target`, the clip's peak magnitude equals `target` **exactly**, for any non-silent clip at any target. The peak sample, at magnitude `peak`, maps to exactly ±target (`divTrunc(±peak·target, peak) = ±target`), and every quieter sample maps strictly inside ±target — so nothing overshoots and the new peak is the target on the nose. Proven by re-measuring, including the i16 minimum (−32768, magnitude 32768) at the meter's domain ceiling.
3. **The silence law.** An all-zero clip — and an empty clip — is unchanged whatever the target: no peak, no gain, no fault.
4. **The idempotence law.** Normalize to a target, then again to the same target, is a no-op the second time — the peak already sits on the target, so the second gain is unity and every sample maps to itself. Normalize is settled once it lands.

## Bounds and laws

- Reuses ALES13's whole read (bounds run before any write) and ALES2's saturating gain (the peak sample lands exactly on ±target, so no sample ever actually saturates — the ceiling is respected, not reached).
- Errors: `NormalizeError = meter.MeterError || timeline.EditError || error{BadTarget}` — no new machinery beyond `BadTarget`. The forwarded `MeterFull` (a Clip is bounded well inside the meter's window) and `BadGain`/`BadRange` (a measured non-zero denominator, a whole-clip span) are honestly unreachable here, named for parity.
- The postcondition asserts the length is exactly unchanged — normalize touches values only.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. The `target` is a plain sample magnitude, **not** a decibel level (no real reference level exists yet — that conversion is a later rung), and no loudness model (K-weighting, LUFS) is claimed — this is **peak** normalization, the plainest reading. No transcript, no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*The silence family found the sound; ALES103 makes every take meet the same ceiling. One measure, one scale, and a quiet recording stands as tall as a hot one — the loudest sample landing exactly where the keeper asked, never a sample past it.*
