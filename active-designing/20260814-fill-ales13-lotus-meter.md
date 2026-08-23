# ALES13 — Lotus's peak/RMS meter, the same root reading the master

**Stamp:** `20260814.164000` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES12
**Waymark:** ALES · rung ALES13
**Kin:** [`ALES11 — the equal-power law`](20260814-fill-ales11-lotus-equal-power.md) · [`ALES7 — the transport play head`](20260814-fill-ales7-lotus-transport.md) · [`lotus/meter.rye`](../lotus/meter.rye) · [`lotus/power.rye`](../lotus/power.rye) (ALES11, the isqrt reused) · [`lotus/transport.rye`](../lotus/transport.rye) (ALES7, the blocks metered)

---

## Why this round

ALES11 proved a bounded integer square root to shape the stereo **field**, and ALES12 swept that same law across **time**. Both readings *shaped* the audio — they decided how loud each channel or each crossfade sample should be. Every rung since ALES11 named the other use of a square root as the road's next crux: an **RMS level is the square root of a mean square**, and no rung yet **reads** the master to tell a keeper how loud it actually is. A DAW without a meter is a desk with no lights — the one surface a mixing keeper's eyes never leave. Lindy-first, crux-first: metering is read on every playthrough for years, and the crux that makes it honest is the root the suite already proved, now turned around to read rather than shape.

## The one crux this rung fixes

**The meter reuses ALES11's proven `isqrt` — the one true integer square root — over a wider domain, and every measure it reports is bounded by the peak it also reports.** Two truths make the meter honest beyond a bare maximum:

1. **`rms ≤ peak`, always.** The mean of the squares can never exceed the largest square, and `isqrt` is monotone, so the root of the mean is at most the root of the max square, which is the peak exactly. This is asserted at the postcondition, not hoped.
2. **Block-invariance — the tie to the transport.** Peak is a running maximum and mean-square is a running sum divided by a running count; both accumulate associatively. So metering a master **block by block off ALES7's transport** yields the same peak and RMS as metering the whole master at once. The meter reads exactly what the play head plays, at any block size.

The wider domain is the only new fact. ALES11's `isqrt` was bounded to the pan fold (`max_pan_den² = 2²⁴`); a mean square of full-scale i16 samples reaches `32768² = 2³⁰`. So `isqrt` is **widened to the audio square domain** (`2³⁰`, sixteen binary digits) and made public — the pan fold (`≤ 2²⁴`) still fits well inside, so ALES11's callers and its witness are untouched. One root, two readers.

## The shape

`lotus/meter.rye`:

- Reuses [`power.isqrt`](../lotus/power.rye) — the proven root, now public and audio-domain-wide — and [`timeline.Clip`](../lotus/timeline.rye) / [`pan.StereoClip`](../lotus/pan.rye) as the masters it reads.
- `Meter { sum_sq, count, peak }` — a running accumulation: the sum of squared magnitudes, the sample count, and the peak magnitude. Bounded: `count` never exceeds `max_meter_samples`, so `sum_sq` stays well inside u64.
- `feed(meter, block)` — fold one block of samples in (each `|sample|` in `[0, 32768]`, its square in `[0, 2³⁰]`), refusing `MeterFull` past the count bound. This is the call ALES7's `read_block` feeds.
- `peak(meter)` — the largest magnitude seen, in `[0, 32768]`.
- `rms(meter)` — `isqrt(sum_sq / count)`, honestly lossy in the mean (`@divTrunc`), `0` over an empty meter (silence, never a divide fault).
- `measure(clip)` / `measure_stereo(stereo)` — one-shot convenience: feed a whole mono clip, or both channels of a stereo master into `[left, right]` meters.

## What the witness proves (GREEN on metal)

`tools/al/ales_meter_witness.rish`: silence reads peak `0` and RMS `0`; a full-scale constant reads its own magnitude as both peak and RMS (the RMS of a DC signal is its level); `rms ≤ peak` holds across a sweep of signals; **block-invariance** — metering a master in 1-, 2-, and 7-sample blocks off the transport gives the identical peak and RMS as one whole `measure` (the same root reading the same audio, at any block size); a stereo master meters each channel independently; metering never mutates the master (read-only, like the transport); and `feed` refuses `MeterFull` past the bound. Purely local — no socket, no network, no keys, no funds, no real device, no real meter hardware.

## The road on

With a meter reading the master, the suite can name a **stereo balance/width** control (panning an already-stereo source), a transport **loop** over a marked region (extending ALES7), or offer the keeper the **choice of pan/crossfade law** on either axis. The real two-channel sound-card write a metered master would ultimately feed stays a paused hardware research round, taken only on Keaton's word.
