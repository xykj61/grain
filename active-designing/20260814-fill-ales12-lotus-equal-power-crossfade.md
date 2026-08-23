# ALES12 — Lotus's equal-power crossfade, the same law swept over time

**Stamp:** `20260814.123255` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES11
**Waymark:** ALES · rung ALES12
**Kin:** [`ALES11 — the equal-power law`](20260814-fill-ales11-lotus-equal-power.md) · [`ALES4 — a fade envelope`](20260814-fill-ales4-lotus-fade-envelope.md) · [`ALES3 — mix a second track`](20260814-fill-ales3-lotus-mix-second-track.md) · [`lotus/crossfade.rye`](../lotus/crossfade.rye) · [`lotus/power.rye`](../lotus/power.rye) (ALES11)

---

## Why this round

ALES11 opened the equal-power law across the stereo **field** — pan, where the two speakers' powers sum to a constant so a track holds its loudness wherever it sits. The same dip the linear pan left at center, a **linear crossfade leaves in time**: butt two clips and cross them with weights that sum to one, and the overlap sags in the middle, a moment quieter than either clip alone. Lindy-first, crux-first: the most durable next thing is not a new law but the **completion** of the one just proven — carry equal power from the field into time, so the suite crossfades without a dip. And the crux is a recognition rather than new arithmetic: **a crossfade is the equal-power pan swept over the overlap.** Position across the stereo field and position through a time overlap are the same parameter; ALES11's `isqrt` and its split already answer both.

## The one crux this rung fixes

**The outgoing and incoming weights are ALES11's equal-power split, read at each sample of the overlap — so the crossfade reuses the proven law rather than re-deriving it.** Over an overlap of `den + 1` samples, at position `i` from `0` to `den`, the outgoing clip is scaled by `split(i, den)[0]` and the incoming by `split(i, den)[1]` — exactly the left/right weights of a pan at position `i`. Because those two weights already satisfy the constant-power law (`out_power + in_power = den²`, `out² + in² ≤ den²` within the proven `isqrt` truncation), the overlap holds constant power for free, and the two properties a crossfade owes fall straight out:

> **The overlap begins as pure outgoing and ends as pure incoming** — at `i = 0` the outgoing weight is `den` (full) and the incoming `0` (silent); at `i = den` the mirror. So a crossfade splices seamlessly onto the clip before it and the clip after it.

> **The center holds power, not sum** — at `i = den/2` each side is `isqrt(den²/2) ≈ 0.707·den` (−3 dB), where a linear crossfade would give `0.5·den` (−6 dB). Two uncorrelated clips crossed this way stay level through the overlap.

The sum itself is ALES3's mixer discipline unchanged — each scaled sample runs in a wide `i64` and the result **saturates** once to the i16 range (`timeline.saturate`, the one true clamp), so a loud overlap pins to the ceiling rather than wrapping.

## The shape

`power.rye` gains one additive, named reuse point (the equal-power law is now shared, not copied):

- `split(pos, den)` — the equal-power split `[outgoing, incoming]` as two `u32` weights, the same `weights` ALES11's pan folds, exposed so a crossfade over time reads exactly the pan the field would.

`lotus/crossfade.rye`:

- `crossfade(out_clip, in_clip, out)` — cross two equal-length overlap windows: `out[i] = saturate(out_clip[i]·wᵒ/den + in_clip[i]·wⁱ/den)`, the weights `power.split(i, den)` with `den = len − 1`. Refuses `BadRange` on a length mismatch or an overlap shorter than two samples, `BadGain` never reached (the split's denominator is the validated `den`). Reuses ALES3's saturation whole.

## What the witness proves (GREEN on metal)

`tools/al/ales_crossfade_witness.rish`: the overlap **begins as pure outgoing and ends as pure incoming** (seamless splice); the **center holds equal power** — each side `0.707·den`, distinctly louder than a linear crossfade's `0.5·den`, the audible proof the curve is angular; crossing a clip with **itself** holds constant loudness across the whole overlap (the equal-power promise); a loud overlap **saturates** rather than wraps; the weights match ALES11's pan split exactly (the law is one, field and time); a length mismatch and a too-short overlap each refuse `BadRange` by name. Purely local — no socket, no network, no keys, no funds, no real device, no real speaker.

## The road on

With equal power proven in both axes — field (pan) and time (crossfade) — the suite can offer a keeper the choice of law on either, and the `isqrt` at the root now reaches honest **stereo metering** (an RMS level is a square root of a mean square) and a **peak/RMS meter** over the transport's read blocks. The audio-interface hardware — the real two-channel sound-card write these would ultimately feed — stays a paused research round, taken only on Keaton's word.
