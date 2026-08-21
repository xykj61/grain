# Fill ALES47 — the band-reject, the middle let go

**Stamp:** `20260814.165728` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES47**
**Kin:** [`20260814-165106_fill-ales46-lotus-band-pass.md`](20260814-165106_fill-ales46-lotus-band-pass.md) · [`20260814-161231_fill-ales41-lotus-tone-shelf.md`](20260814-161231_fill-ales41-lotus-tone-shelf.md)

---

## The gesture

ALES46 gave the band-pass — keep the middle, drop the edges. Its complement is the **band-reject**, the **notch**: keep the edges, drop the middle. It is the gesture a keeper reaches for to *remove* a range without touching the rest — the mains hum pulled from a take, the resonant ring notched out of a room, the mud scooped from a mix while the lows and the air stay whole.

Where the band-pass is a **cascade** (high-pass then low-pass, one feeding the next), the band-reject is a **parallel** sum: a low-pass keeps everything below the low cutoff, a high-pass keeps everything above the high cutoff, and the two are added. What neither branch keeps — the middle band between the cutoffs — is what the notch rejects. This is the shelf's own shape (ALES41: scale two bands and sum, clamp once, ALES8's fader lesson), now with both retained bands at unity and no band scaled.

## The elegant crux

Because a low-pass and a high-pass at the **same** coefficient reconstruct the input exactly (ALES40's proven `low_pass + high_pass = x`), a notch whose two cutoffs are **equal** — a reject band of zero width — is the **identity**, byte-for-byte. The narrower the gap between the cutoffs, the less the notch removes; a zero gap removes nothing. That degenerate identity mirrors ALES46's composition crux: the primitive rests on already-proven arithmetic and adds none of its own on the audio path.

## The shape — `lotus/notch.rye`

`notch(clip, start, count, low_num, low_den, high_num, high_den)` — over `[start, start+count)` in place:

1. Copy the span into a scratch clip `low`; `tone.low_pass(&low, …, low_num, low_den)` — keep the lows.
2. Copy the span into a scratch clip `high`; `tone.high_pass(&high, …, high_num, high_den)` — keep the highs.
3. Write `saturate(low[i] + high[i])` back to the span — the two retained bands summed in i64, clamped once over the true total (ALES8's fader lesson via ALES41).

Both cutoffs are checked before any scratch is filled; a zero or above-one coefficient on either refuses `BadCoeff`, an out-of-range span refuses `BadRange`.

## The correctness (each a selftest clause)

1. **Silence stays silence.**
2. **Equal cutoffs are the identity** — `low_num/low_den == high_num/high_den` writes the input byte-for-byte (`low_pass + high_pass = x`): a zero-width reject band removes nothing.
3. **The notch keeps direct current** — a constant input settles to itself: the low-pass keeps the constant (settles to `x`), the high-pass removes it (settles to `0`), so their sum settles to `x`. (The exact contrast to ALES46's band-pass, which drove a constant to zero.)
4. **Distinct cutoffs genuinely reject** — over a mixed signal a notch with distinct cutoffs equals neither the input nor either single filter: a real middle band is removed.
5. **A loud transient saturates rather than wraps** — where the two retained bands sum past the i16 range, the output pins to the ceiling, never wraps.
6. **Refusals by name** — an illegal coefficient on either cutoff refuses `BadCoeff`, an out-of-range span refuses `BadRange`, each before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the coefficients still smooth over sample indices; a notch named in hertz with a real width is the later time-base rung. Every band and the sum run in i64 so nothing overflows before the single clamp.

## Witness

`tools/ales_notch_witness.rish` — build `lotus/notch.rye`, run its selftest, assert `GREEN ales-notch`, and re-prove ALES46's band-pass still stands green (the band-pass and the band-reject are the EQ primitive pair; keeping both green together proves the pair is whole).

---

*The middle let go, the edges kept — the band-reject asks for nothing ALES40 did not already prove, only that a low band and a high band be added and clamped once. May the pair, band-pass and band-reject, stand together for the parametric bell that comes next.*
