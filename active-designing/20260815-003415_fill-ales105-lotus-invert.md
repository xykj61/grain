# Fill ALES105 — the Lotus invert (flip every sample's sign, the exact value-mirror of reverse)

**Stamp:** `20260815.003415` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES105**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES104`](20260815-002711_fill-ales104-lotus-reverse.md)
**Stands on:** `lotus/timeline.rye` (ALES2 — the Clip, its `buf`/`len`/`samples`, and `saturate`) · `lotus/meter.rye` (ALES13 — the peak/RMS meter, to witness that a sign flip off the rail moves no loudness)

## Why this rung, now

ALES104 landed reverse — the plainest *position* edit, every seat traded and no value touched. This rung is its exact twin from the other axis: **Invert.** Every editor and DAW ships an Invert (or "Invert Phase") menu item, and it earns real reach — a phase flip is how two mics on one source are brought into agreement, how a difference signal is cancelled, how a stereo side is folded. Where reverse changes every position and no value, invert changes every value and no position: `y = -x`, the whole clip flipped about the zero line.

Invert is Lindy because it is the value-mirror of a proven structure — it stands beside `reverse` as `gain` with `num = -1` already hinted, now named plainly as its own gesture. It rounds nothing and drops nothing; it is the second of the two exact edits the timeline owns.

## The shape

`lotus/invert.rye` exposes `invert(clip)` — no parameters, no faults it can raise from legal input. It walks the clip once and replaces each sample with `saturate(-x)`, reusing ALES2's one true saturation so the signed rail is handled exactly as `gain` already handles it. The length is untouched; the buffer past `len` is never read or written.

## The crux — four laws

1. **The value-mirror law.** After invert, sample `i` holds `saturate(-x)` where `x` was its value — every sample flips sign, no seat moves. Proven against a hand-inverted vector. This is the exact mirror of reverse's order law (position flips, value stays; here value flips, position stays).
2. **The involution law, with an honest rail.** Invert twice returns every sample to the byte — *except* `sample_min` (`-32768`), whose true negation `+32768` is out of the `i16` range and saturates to `sample_max` (`+32767`); inverted again it lands `-32767`, not `-32768`. This is not a bug but the fixed asymmetry of two's-complement: the floor has no positive twin. The law is stated exactly — invert is an involution on `[sample_min+1, sample_max]`, and `sample_min` is its lone off-by-one, saturated by design rather than wrapped. Proven both ways: a clip free of the floor round-trips to the byte; a clip holding the floor round-trips to `-32767` at those seats.
3. **The magnitude law.** Off the rail, invert preserves magnitude exactly (`|-x| = |x|`), so for a clip whose peak sample is not `sample_min` the peak magnitude, re-measured through ALES13, is unchanged — the flip moves the sign, never the loudness.
4. **The fixpoint law.** Zero is the unique fixed point of negation: the all-zero clip and the empty clip are each their own invert (`-0 = 0`), landing on themselves with no special-casing.

## Bounds and laws

- One in-place pass, `len` writes, no allocation and no second buffer.
- `invert` takes no argument that could name an out-of-range span, so it forwards no `EditError`; it is total on any legal `Clip`.
- The postcondition asserts the length is exactly unchanged and the bound still holds — invert flips values, never the count.
- Saturation is not re-derived: `invert` calls `timeline.saturate`, the same clamp `gain` uses, so the rail is handled in exactly one place across the suite.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It flips existing samples about zero and fabricates none; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*Reverse turned every seat and left every value; invert flips every value and leaves every seat. Two mirrors, one on each axis — and the floor sample, alone in two's-complement, keeps its honest off-by-one where the rail admits no twin.*
