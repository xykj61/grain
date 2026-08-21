# Fill ALES102 — the Lotus smoothed silence trim (smooth the runs before you strip; declick the pause, keep the gap)

**Stamp:** `20260815.001200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES102**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES101`](20260815-000323_fill-ales101-lotus-run-length-smoother.md)
**Stands on:** `lotus/trim_silence.rye` (ALES96 — the silence stripper, the min-zero twin) · `lotus/smooth_runs.rye` (ALES101 — the run-length smoother) · `lotus/segment.rye` (ALES95) · `lotus/timeline.rye` (ALES2 — the Clip and `cut`)

## Why this rung, now

ALES101 built the smoothing hysteresis; this rung is where it *pays off*. ALES96 strips every `.silent` run from the raw segmentation, and the raw segmentation flickers: a single loud tick buried in a pause reads `.voiced`, so ALES96 **keeps the click**; a single quiet frame between two words reads `.silent`, so ALES96 **cuts the gap** and the words run together. Both are exactly the artefacts a real editor complains about.

Run ALES101 *before* the strip and both vanish. Smooth the runs with a `min_run`, and the tick — being shorter than `min_run` — is relabeled to the silence around it and stripped away; the short gap — being shorter than `min_run` — is relabeled to the speech around it and **kept**. One knob, `min_run`, turns a literal silence remover into a *speech-aware* one. This is the Lindy crux of the whole silence family: the tool a keeper actually wants is not "remove every quiet sample" but "remove the dead air, spare the breath, drop the click."

## The shape

`lotus/smooth_trim.rye` exposes `smooth_trim` — the same segment-then-cut shape as ALES96 with one stage inserted: **segment → smooth (ALES101) → cut the smoothed `.silent` runs.** Because ALES101's coverage law guarantees the smoothed runs tile the *same* span exactly (same starts, same total), every smoothed `.silent` run is a valid span in the original clip, cut back-to-front exactly as ALES96 cuts.

## The crux

1. **The min-zero law.** `smooth_trim(…, 0)` equals ALES96's `trim_silence(…)` byte for byte — a `min_run` of zero is the identity smoothing, so the two tools share their boundary exactly, and ALES102 is a strict generalization.
2. **The concat law.** The result equals, byte for byte, the hand-built concatenation of the non-silent *smoothed* runs read from the original — ALES102 is nothing but ALES96 reading ALES101's labels instead of the raw ones, so it can never drift.
3. **The declick law.** On a clip with a short `.voiced` tick buried in silence, a `min_run` past the tick removes it — `smooth_trim` is strictly shorter than `trim_silence`, the click gone.
4. **The keep-gap law.** On a clip with a short `.silent` gap between two words, a `min_run` past the gap keeps it — `smooth_trim` is strictly longer than `trim_silence`, the breath preserved.

Honestly named: `smooth_trim` is **not monotone** in `min_run` — a larger `min_run` removes more clicks yet keeps more gaps, so the output length can rise or fall. The declick and keep-gap laws are two sides of that, and the witness proves both rather than pretending a single ordering.

## Bounds and laws

- Reuses ALES96's whole validation (span and band through ALES92's `precheck`, the floor ceiling, `frame_len` dividing `clip.len`); an empty clip refuses `BadFrame` before any smoothing.
- Errors: `SmoothTrimError = trim_silence.TrimError || smooth_runs.SmoothError` — no new error; `min_run` is a `u32` count with no illegal value (`0` the identity, a huge `min_run` coalescing every run into one).
- The postcondition asserts the trimmed length equals the original minus the smoothed silent total exactly.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It edits only by removing whole smoothed-silent frames through ALES2's own `cut`, fabricating no sample and reordering nothing. The smoothing is ALES101's *causal* hold — it cannot rescue a too-short opening run — and this rung is no adaptive VAD. Not a transcript; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*ALES96 removed every quiet sample; ALES102 removes the dead air, spares the breath, and drops the click — one knob teaching the stripper what a listener already knows. May every pause the keeper meant survive, and every click they never wanted vanish.*
