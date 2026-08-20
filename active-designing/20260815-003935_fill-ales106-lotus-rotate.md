# Fill ALES106 — the Lotus rotate (cyclic shift, the third pure rearrangement beside reverse and invert)

**Stamp:** `20260815.003935` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES106**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES104`](20260815-002711_fill-ales104-lotus-reverse.md) · [`fill ALES105`](20260815-003415_fill-ales105-lotus-invert.md)
**Stands on:** `lotus/timeline.rye` (ALES2 — the Clip, its `buf`/`len`/`samples`) · `lotus/meter.rye` (ALES13 — the peak/RMS meter, to witness that a pure rearrangement moves no loudness)

## Why this rung, now

ALES104 (reverse) and ALES105 (invert) named the two exact mirrors — position and value. This rung completes the *position* family with the other pure rearrangement every timeline owns: **rotate.** A cyclic shift slides the whole clip left by `k` samples and wraps the `k` that fall off the front back onto the tail — the loop-aligning gesture behind every "rotate loop to downbeat," every phase-aligned wavetable, every circular buffer read at an offset. Like reverse it invents no sample, drops none, and rounds nothing; it is a permutation, exact by construction.

Rotate is Lindy because it is *structure* and it composes: two rotations add, and a rotation's inverse is another rotation. It earns its place beside reverse by being built from the very same primitive — three range-reversals in place — so it stands on proven ground and adds no allocation.

## The shape

`lotus/rotate.rye` exposes `rotate_left(clip, by)` — `by` any `u32`, reduced modulo the length so an over-long shift is simply the equivalent short one. It rotates in place by the classic three-reversal identity: reverse `[0, k)`, reverse `[k, len)`, then reverse `[0, len)`, where `k = by mod len`. One private `reverse_range` helper (the same swap-from-both-ends `reverse` uses) does all three; no second buffer, `len + len/2·3` writes bounded by a small multiple of `len`. An empty or single-sample clip, and any `k` that reduces to zero, return untouched.

## The crux — four laws

1. **The shift law.** After `rotate_left(clip, k)`, result index `j` holds `original[(j + k) mod len]` — the front `k` samples move to the tail, exactly. Proven against a hand-rotated vector at several offsets.
2. **The modular law.** Rotating by `0`, by `len`, or by any multiple of `len` is the identity, and `rotate_left(k)` equals `rotate_left(k mod len)` — a shift past a full turn is the equivalent short shift. Proven by rotating by `k` and by `k + len` and landing identical clips.
3. **The composition-and-inverse law.** `rotate_left(k1)` then `rotate_left(k2)` equals `rotate_left(k1 + k2)`, so rotations add; in particular `rotate_left(k)` then `rotate_left(len − k)` returns to the byte — every rotation's inverse is another rotation, so a keeper who over-rotates rotates the rest of the way back home.
4. **The permutation law.** Rotate is a pure rearrangement: the length is unchanged and the multiset of samples is unchanged, so every order-blind metric is invariant. Witnessed through ALES13 — the peak magnitude before and after a rotate is identical, no value ever changing, only its seat.

## Bounds and laws

- In place through three range-reversals, no allocation and no second buffer.
- `by` is reduced modulo `len` before any work, so no shift is ever out of range; `rotate_left` forwards no `EditError` and is total on any legal `Clip`.
- The postcondition asserts the length is exactly unchanged and the bound still holds — rotate reseats samples, never the count.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It reseats existing samples cyclically and fabricates none; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*Reverse turned the clip end for end, invert flipped it about zero, and rotate slides it around the loop — three pure rearrangements, each its own inverse, each leaving every value it moves exactly itself. Rotate too far and the loop simply carries you the rest of the way home.*
