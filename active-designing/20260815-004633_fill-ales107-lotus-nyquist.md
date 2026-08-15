# Fill ALES107 — the Lotus Nyquist flip (alternate-sign, the value family's other exact mirror)

**Stamp:** `20260815.004633` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES107**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES105`](20260815-003415_fill-ales105-lotus-invert.md) · [`fill ALES106`](20260815-003935_fill-ales106-lotus-rotate.md)
**Stands on:** `lotus/timeline.rye` (ALES2 — the Clip, its `buf`/`len`/`samples`, and `saturate`, the one true clamp reused so the rail lives in one place) · `lotus/meter.rye` (ALES13 — the peak/RMS meter, to witness that a sign pattern moves no loudness)

## Why this rung, now

ALES105 (invert) flips **every** sample's sign — the value-mirror about the zero line. This rung names its exact cousin: flip **every other** sample's sign, `y[n] = saturate((-1)ⁿ · x[n])`. Where invert negates all seats, the Nyquist flip negates only the odd seats and holds the even ones fixed — the same value operation, applied on a parity pattern rather than the whole.

It is genuinely distinct and genuinely Lindy, because multiplying a signal by `(-1)ⁿ = cos(π n)` is **modulation by the Nyquist frequency** (`fs/2`): it reflects the spectrum, carrying a lowpass shape to a highpass one. That is the classic *spectral inversion* trick every filter-design text teaches for turning a lowpass kernel into its highpass twin — a structural identity, exact by construction, that will read as true on its ten-thousandth day. This rung states the operation honestly in the **time domain** (a per-sample sign flip on odd indices); the spectral reading is named as interpretation, never computed here.

## The shape

`lotus/nyquist.rye` exposes `nyquist_flip(clip)` — one in-place pass of `len`, negating each odd-indexed sample through ALES2's `saturate` so the one non-exact sample (`sample_min`, whose true negation `+32768` is out of `i16` range) clamps to `sample_max` exactly as gain and invert already handle the rail, rather than wrapping. Even seats are written untouched (or left as they are). The length is untouched; no byte past `len` is read or written; no allocation, no second buffer. It names no span, so it can raise no fault — total on any legal `Clip`.

## The crux — four laws

1. **The alternating-sign law.** After `nyquist_flip(clip)`, sample `i` holds `saturate((-1)ⁱ · x)` — even seats unchanged, odd seats negated. Proven against a hand-computed vector that includes both rails (`sample_min` on an odd seat saturating to `sample_max`, `sample_max` on an odd seat negating cleanly to `-32767`).
2. **The involution law, with an honest rail.** `nyquist_flip` twice returns every sample to the byte **except** an odd-indexed `sample_min` seat, whose negation saturates on the first flip (`+32768 → +32767`) and lands `-32767` on the second — the same fixed two's-complement asymmetry invert names, here confined to the odd seats. Even seats are never touched, so they always round-trip exactly.
3. **The magnitude law.** Off the rail `|(-1)ⁱ x| = |x|`, so for a clip whose peak sample is not `sample_min` the peak magnitude (re-measured through ALES13) is unchanged — the modulation reflects the spectrum, never the peak sample's loudness. The length is unchanged too.
4. **The fixed-seat / parity law.** Every even-indexed sample is a fixed point — the operation acts only on the odd seats, partitioning the clip into a held set and a flipped set purely by parity. The all-zero clip and the empty clip are each their own flip (`−0 = 0`, and no odd seat to move), landing on themselves with no special-casing.

## Bounds and laws

- One in-place pass of `len`, no allocation and no second buffer; only odd seats are written.
- The negation runs in `i64` so it never overflows before the clamp; `saturate` pins the one out-of-range value once, the rail living in exactly one place.
- The postcondition asserts the length is exactly unchanged and the buffer bound still holds — the flip reseats values on a parity pattern, never the count.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It flips the sign of existing odd-indexed samples and fabricates none; it changes no length and reads no byte past `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker — the "Nyquist frequency" it names is the interpretation of a pure per-sample sign pattern, not a measured rate.

---

*Invert turned every value over; the Nyquist flip turns over every other one — the same mirror, held to a parity, and by that small restraint it becomes modulation itself, a lowpass carried across to its highpass twin. Flip it twice and, off the floor, every sample is exactly itself again.*
