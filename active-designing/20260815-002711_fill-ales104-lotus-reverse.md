# Fill ALES104 — the Lotus reverse (turn the clip end for end, the plainest exact edit)

**Stamp:** `20260815.002711` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES104**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES103`](20260815-001849_fill-ales103-lotus-peak-normalize.md)
**Stands on:** `lotus/timeline.rye` (ALES2 — the Clip, its `buf`/`len`/`samples`) · `lotus/meter.rye` (ALES13 — the peak/RMS meter, to witness that a permutation moves no loudness)

## Why this rung, now

ALES103 fused reader and writer over the whole clip — measure the peak, scale to a target. This rung answers a different, equally reached-for gesture, and it does it with the plainest arithmetic in the whole suite: **Reverse.** Every editor and DAW ships a Reverse menu item, and it carries a real creative charge — the reversed cymbal swell, the backwards reverb, the pre-echo before a downbeat. It is also the cleanest *exact* edit left on the timeline: a pure permutation that invents no sample, drops none, and rounds nothing.

Reverse is Lindy because it is *structure*, not *value* — it is the timeline read end-for-end, the mirror of `cut`/`gain`/`splice`. It earns its place beside normalize precisely by being their opposite: normalize changes every value and no position; reverse changes every position and no value.

## The shape

`lotus/reverse.rye` exposes `reverse(clip)` — no parameters, no faults it can raise from legal input. It walks the clip from both ends inward, swapping `buf[i]` with `buf[len-1-i]` until the two indices meet. The middle sample of an odd-length clip is its own mirror and never moves. The length is untouched; the buffer past `len` is never read or written.

## The crux — four laws

1. **The order law.** After reverse, sample `i` holds what sample `len-1-i` held before — the first becomes the last, the last the first, exactly. Proven against a hand-reversed vector.
2. **The involution law.** Reverse twice is the identity, for any clip — the swap is its own inverse, so a keeper who reverses by mistake reverses back to the byte. This is the law that makes reverse *safe* to reach for.
3. **The permutation law.** Reverse is a pure rearrangement: the length is unchanged and the multiset of samples is unchanged, so every order-blind metric is invariant. Witnessed through ALES13 — the peak magnitude before and after a reverse is identical, because no sample's value ever changes, only its seat.
4. **The fixpoint law.** An empty clip, a single-sample clip, and a palindrome are each their own reverse — the degenerate cases land on themselves, no special-casing, the same loop that turns a long clip leaves these exactly as they are.

## Bounds and laws

- One in-place pass, `len/2` swaps, no allocation and no second buffer — the tightest possible edit.
- `reverse` takes no argument that could name an out-of-range span, so it forwards no `EditError`; it is total on any legal `Clip`. (The witness still proves it leaves an all-zero and an empty clip untouched.)
- The postcondition asserts the length is exactly unchanged and the bound still holds — reverse moves seats, never the count.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It rearranges existing samples and fabricates none; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*Normalize changed every value and left every seat; reverse changes every seat and leaves every value. One loop from both ends to the middle, and the backwards cymbal rings — turned end for end and, turned again, exactly itself once more.*
