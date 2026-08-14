# Fill ALES68 — Lotus's multi-tap delay: several fixed taps of the dry signal

**Stamp:** `20260814.192743` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the second delay-line reading, contrasting ALES66's feedback with a snapshotted-dry multi-tap, reusing the graft/clipboard snapshot idiom and the one true saturate)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES68**
**Kin:** [`../lotus/echo.rye`](../lotus/echo.rye) (ALES66 — the feedback delay this contrasts) · [`../lotus/graft.rye`](../lotus/graft.rye) (ALES24 — the dry-span snapshot idiom this reuses) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and the one true saturate)

---

## Why this rung

ALES66 opened the time-based wing with the **feedback** delay, where each echo feeds the next and the delay line *is* the clip buffer itself. Its comment names the road above it — "the chorus, the flanger, and the reverb — each one a delay line read a different way." The next, most tractable way to read a delay line is the one a feedback loop cannot give: **several fixed taps of the *dry* signal**, each at its own delay and level, summed with the dry — the discrete early-reflection pattern (a snare hitting three walls at three distances) that a single feeding echo cannot voice, because a feedback tap decays geometrically while independent taps stand at their own chosen levels.

Lindy-first, the multi-tap is the building block every richer delay effect stands on (the reverb's early-reflection network is a multi-tap); crux-first, the decisive move is the contrast with ALES66 — a delay line read from a **snapshot of the dry audio** rather than the written-in-place output, so the taps never feed each other.

## The crux — the taps read the dry snapshot, so they never feed each other

ALES66's echo reads `buf[i-delay]` *after* writing left to right, so a tap reads the output — true feedback. A multi-tap delay owes the opposite: **every tap reads the original dry sample, never a written one.** The exact idiom the tree already proves is the graft/clipboard **snapshot before write** (ALES24/25): copy the dry prefix `[0, end)` into a bounded scratch first, then for each `i` in the span write

```
y[i] = saturate( dry[i] + Σ_k  g_k · dry[i − d_k] )
```

where `dry[j] = 0` for `j < 0` (silence before the clip). Because every read is from the frozen `dry`, the taps are independent — a two-tap delay lands two distinct copies of the impulse at their two delays, *neither* attenuating the other, the sharp contrast with the feedback train. The sum accumulates in `i64` and clamps once through `timeline.saturate` (ALES3's one true saturation, reused), so a constructive pile-up pins to the i16 rail rather than wrapping.

## Shape

`lotus/taps.rye` offers `multitap(clip, start, count, taps)` over a bounded slice of `Tap = struct { delay: u32, num: u32, den: u32 }`. Unlike the feedback echo — where unity is a runaway refused `BadFeedback` — a multi-tap has no loop, so a tap **at unity is legal** (a full-level discrete echo); only `num > den` (a tap louder than the dry, which a reflection is not) and `den == 0` refuse. The scratch is one `[max_clip]i16` on the stack, the exact width and stack cost graft already carries.

## The laws to prove

1. **Two taps are two independent copies** — an impulse with taps at `(d1, 1/2)` and `(d2, 1/4)` lands the dry impulse plus a half copy at `d1` and a quarter copy at `d2`, computed by hand byte-for-byte — *neither tap feeds the other* (the contrast with ALES66's decaying train).
2. **The dry snapshot, not feedback** — a single tap at `(d, 1/1)` over a signal lands one full copy of the *original* dry `d` samples later, never a copy-of-a-copy; running the same tap where a feedback echo would compound proves the taps read the frozen dry.
3. **Silence and the dry identity** — silence stays silence; an empty-effect (a single tap whose delay reaches before the clip, contributing only silence) leaves the dry untouched; a tap gain of `0/den` adds nothing.
4. **A loud sum saturates, never wraps** — a dry loud sample under a loud in-phase tap pins to `sample_max` (ALES3's ceiling), the one owed correctness.
5. **Order-independence** — the taps sum commutatively; the same tap set in any order lands the identical audio (the sum is over the frozen dry, so no tap sees another's write).
6. **Every fault refuses by name, the clip untouched** — zero taps or more than `max_taps` refuses `BadTapCount`; a tap delay of zero or past `max_clip` refuses `BadDelay`; a tap `num > den` or `den == 0` refuses `BadLevel`; a span outside the samples refuses `BadRange` — each before any write.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip and a bounded tap slice, siloed to `lotus/`. The delay is a count of sample **indices**, not milliseconds — the real-time twin (`multitap_ms` through the ALES5 clock) follows exactly as `echo_ms` followed the index-named echo. No lookahead beyond the snapshot read, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With independent taps proven, the modulated delay (chorus, flanger, whose tap position *moves* and wants interpolation) and the reverb's early-reflection network follow as later rungs on this foundation.
