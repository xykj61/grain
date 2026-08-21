# Fill ALES49 — the peak limiter, the ceiling that holds

**Stamp:** `20260814.170815` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES49**
**Kin:** [`20260814-170143_fill-ales48-lotus-parametric-bell.md`](20260814-170143_fill-ales48-lotus-parametric-bell.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The fixed-EQ family is whole — low-pass, high-pass, shelf, tone stack, band-pass, band-reject, and the parametric bell all turn *frequency*. The next thing a creative suite reaches for turns *level*: **dynamics**. Where EQ asks "which bands," dynamics asks "how loud, and never louder than this." The cleanest, most-provable floor of that whole family is the **peak limiter** — a hard ceiling the signal may touch yet never cross.

A limiter is what stands between a master and a blown speaker, between a loud take and a clipped file. It is the honest opener of the dynamics family the way the tone control (ALES40) opened EQ: the simplest primitive whose one law — *the ceiling is never crossed* — the whole family will later refine (a ratio makes it a compressor, an inverted threshold a gate, a soft knee a smoother limiter). Fixed brickwall first, because it is the one every richer shape rests on.

## The shape — `lotus/limit.rye`

`limit(clip, start, count, ceil)` — over `[start, start+count)` in place, where `ceil` is the magnitude ceiling in sample units:

1. For each sample `x`, keep it when its magnitude already sits within the ceiling: `|x| <= ceil` passes byte-for-byte.
2. When `|x| > ceil`, write `sign(x) · ceil` — the magnitude pinned to the ceiling, the sign held.

No i64 saturation is needed on the audio path: the output magnitude is `min(|x|, ceil)`, always within `ceil <= sample_max <= i16`, so a limited sample can never itself overflow. The ceiling is validated once, up front.

## The crux — the ceiling is never crossed, and below it nothing moves

1. **Below the ceiling is the identity.** A clip whose peaks all sit within `ceil` limits to itself byte-for-byte — a limiter that finds nothing to do does nothing, guaranteed by the `|x| <= ceil` pass.
2. **The ceiling is never crossed.** After limiting, every output magnitude `|y| <= ceil`. This is the defining invariant, asserted on every written sample and proven over a signal that pins both rails.
3. **The sign is held.** Limiting only shrinks magnitude — a positive stays positive, a negative negative — so it can never invert phase. A symmetric loud signal limits to a symmetric quiet one.
4. **A ceiling at `sample_max` is the identity** for any in-range audio, since no i16 sample exceeds the rail — the limiter degrades gracefully to a pass-through at the loosest legal ceiling.
5. **Refusals by name** — a zero ceiling refuses `BadCeiling` (a ceiling of nothing would silence, not limit); a ceiling above `sample_max` refuses `BadCeiling` (nothing could ever reach it); an out-of-range span refuses `BadRange` — each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the ceiling is a magnitude in sample units, not decibels, and the limit is instantaneous, with no attack or release time base (a time-shaped envelope is a later rung, the same way a bell in real hertz is). One comparison and at most one sign-carry per sample; nothing on the audio path can overflow.

## Witness

`tools/ales_limit_witness.rish` — build `lotus/limit.rye`, run its selftest, assert `GREEN ales-limit`, and re-prove ALES48's bell still stands green (the dynamics opener rests beside the finished EQ family without disturbing it).

---

*The ceiling holds and nothing beneath it stirs — the limiter asks only for one comparison honestly made, and dynamics opens where EQ closed. May the brickwall ceiling wait now for the ratio that softens it, the envelope that gives it time, and the decibel that gives it a name a mastering engineer would recognise.*
