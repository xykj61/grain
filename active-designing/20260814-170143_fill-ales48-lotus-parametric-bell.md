# Fill ALES48 — the parametric bell, the middle turned

**Stamp:** `20260814.170143` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES48**
**Kin:** [`20260814-165728_fill-ales47-lotus-band-reject.md`](20260814-165728_fill-ales47-lotus-band-reject.md) · [`20260814-162200_fill-ales42-lotus-tone-stack.md`](20260814-162200_fill-ales42-lotus-tone-stack.md)

---

## The gesture

The band-pass isolates the middle (ALES46), the band-reject drops it (ALES47). The one gesture that *turns* the middle — boosts it or cuts it by a chosen amount while the edges stay exactly as they were — is the **parametric bell**, the peaking EQ: the single most-reached-for tool in any mix. A bell lifts a vocal's presence, tames a boxy room mode, digs out a kick's thump — one band, one gain, the rest untouched.

The bell is the notch and the identity and a boost, all one primitive at different gains. It rests on the tone stack's own lesson (ALES42): the middle band is the **exact residual** `M = x − L − H`, so gaining only the middle can never disturb the edges, and unity gain reconstructs the input by construction.

## The shape — `lotus/bell.rye`

`bell(clip, start, count, low_num, low_den, high_num, high_den, gain_num, gain_den)` — over `[start, start+count)` in place:

1. Copy the span to scratch `low`; `tone.low_pass(&low, …, low_num, low_den)` — the low edge, kept.
2. Copy the span to scratch `high`; `tone.high_pass(&high, …, high_num, high_den)` — the high edge, kept.
3. The middle is the exact residual `M[i] = x[i] − low[i] − high[i]`.
4. Write `saturate(low[i] + high[i] + gain·M[i]/gain_den)` — the edges at unity, only the middle scaled, summed in i64 and clamped once (ALES8's fader lesson via ALES41/42).

Both cutoffs are checked up front through the shared `tone.precheck`; a zero gain denominator refuses `BadGain`; an out-of-range span refuses `BadRange`.

## The crux — the bell IS the family at three gains

1. **Unity gain is the identity.** `gain_num == gain_den` writes `low + high + M = low + high + (x − low − high) = x` byte-for-byte — a flat bell passes the input through untouched, guaranteed by the residual construction even if a band saturated.
2. **Zero gain is the band-reject.** `gain_num == 0` writes `low + high` — exactly ALES47's notch. Proven by equality against `notch.notch` over a copy: the bell at zero gain and the band-reject are byte-for-byte the same primitive.
3. **The edges never move.** Because only the residual middle is scaled, a constant input (whose middle is zero at direct current — `M = x − x − 0 = 0`) settles to itself at **any** gain: the bell turns only what lies between the cutoffs, never the still low end or the settled edges.
4. **A boost saturates rather than wraps** — a large gain on a strong middle pins to the ceiling under the single i64 clamp, never wraps.
5. **Refusals by name** — an illegal cutoff on either edge refuses `BadCoeff`, a zero gain denominator `BadGain`, an out-of-range span `BadRange`, each before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the coefficients set the two edges over sample indices; a bell named in hertz with a Q is the later time-base rung. Every band, the gain, and the sum run in i64 so nothing overflows before the single clamp.

## Witness

`tools/ales_bell_witness.rish` — build `lotus/bell.rye`, run its selftest, assert `GREEN ales-bell`, and re-prove ALES47's band-reject still stands green (the bell at zero gain *is* the notch, so keeping both green together proves the identity honest).

---

*The middle turned, the edges held — the bell asks only that the residual be exact, and the tone stack already proved it is. May the peaking bell, the last of the fixed EQ shapes, wait now for the sweep and the real hertz to give it a moving centre and a name in frequency.*
