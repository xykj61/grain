# Fill ALES130 — `lotus/stereo_fade.rye`, the fade envelope carried into stereo, one shared ramp

**Stamp:** `20260815.030651` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES130**
**Kin:** [`20260815-025919_fill-ales129-lotus-stereo-normalize.md`](20260815-025919_fill-ales129-lotus-stereo-normalize.md) · [`20260814-fill-ales4-lotus-fade-envelope.md`](20260814-fill-ales4-lotus-fade-envelope.md)

---

## Where the ladder stands

ALES129 opened the stereo **amplitude** class on its crux — normalization, where the honest lift shares *one measured scalar* across both channels. This rung carries the class's most-reached-for member, ALES4's **fade** (the fade-in from silence, the fade-out to silence, the click-free open and close every editor ships), into stereo. A fade differs from normalize in a clarifying way: its gain is not a measured scalar but a *positional ramp* the caller names (num0/den → num1/den across the span). The stereo lift applies the **same ramp** to both channels — and because a positional gain is identical for both, that shared ramp preserves the stereo image for free.

## The crux this round

`stereo_fade(sc, start, count, num0, num1, den)` ramps the gain of `[start, start+count)` in **both** channels of a `StereoClip` from `num0/den` to `num1/den`, running ALES4's proven mono `fade` on each with the **same** ramp arguments. A fade-in opens both speakers together from silence; a fade-out closes them together; a stereo fade-out laid under a stereo fade-in is a stereo crossfade. It validates **both channels before either is mutated**: `fade` can refuse `BadGain` (a zero denominator) or `BadRange` (a span outside the samples), and because both channels enter equal-length, the denominator and span are checked **once** against the shared length up front — so a refusal never desynchronises the channels. `FadeError` is reused whole.

## The four laws proven

- **THE STEREO FADE LAW** — each channel equals ALES4's mono `fade` with the *same* ramp `(num0, num1, den)` over the same span, byte for byte, in both directions: a fade-in leaves the first sample silent and the last unchanged, a fade-out mirrors it, per channel.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a fade writes values only, never the count, so the stereo image stays aligned.
- **THE SHARED-RAMP IMAGE LAW** — the crux made checkable: the same positional ramp scales both channels at each seat, so the inter-channel ratio is held sample by sample. A master whose right channel is twice its left, faded in, keeps that 1:2 ratio at every seat (a panned source stays panned through the fade); an identical-channel master stays identical.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (a zero denominator, a span past the samples) leaves **both** channels byte for byte untouched and still balanced; `count = 0` is the identity on both, a sub-span fade leaves the rest of each channel untouched, and a full-span fade-in opens both channels from silence.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES4's own `fade` (itself reusing ALES2's one true saturate), fabricating none and changing no length; the ramp runs across sample **indices**, not seconds (no real time base), and the levels are plain fractions, not decibels. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_fade.rye` — the module.
- `tools/ales_stereo_fade_witness.rish` — the witness.
