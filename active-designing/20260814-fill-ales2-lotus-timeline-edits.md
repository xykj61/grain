# ALES2 -- Lotus's timeline edits: cut, gain, splice

**Stamp:** `20260814.112555` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES1
**Waymark:** ALES - rung ALES2
**Kin:** [`ALES1 -- the audio byte stream`](20260814-fill-ales1-lotus-audio-stream.md) - [`lotus/timeline.rye`](../lotus/timeline.rye) - [`lotus/stream.rye`](../lotus/stream.rye) (ALES1) - [`lotus/wire.rye`](../lotus/wire.rye) (ALES0)

---

## Why this round

ALES0 framed **one** buffer of samples, proven whole and sample-aligned. ALES1 reassembled **many** frames off a byte stream into one gapless `Timeline`. Neither *changes* a sample -- they carry and order the audio, no more. A creative suite exists to **edit**, so the next rung opens the first real DAW gesture: an editable buffer of samples and the three edits every timeline owes.

## The one crux this rung fixes

**The three edit gestures -- cut, gain, splice -- transform a sample timeline exactly and in order, and gain's arithmetic saturates rather than wraps.** Saturation is the ALES2 analog of ALES0's audio border: the one correctness an audio editor owes that a generic integer buffer does not. A sample scaled past the i16 range must pin to the extreme (`+32767` / `-32768`), never wrap to the opposite sign -- a doubled `20000` is `+32767`, not a wrapped negative; a phase-inverted `-32768` clamps to `+32767` because its true negation `+32768` is out of range.

Three properties compose, each bounded and checked at the edge:

1. **cut(start, count)** -- remove a span and shift the tail left, so the audio stays gapless and everything after the cut is preserved in order. Refuses `BadRange` (checked without underflow -- `count` against the remainder) before any shift.
2. **gain(start, count, num, den)** -- scale a span's loudness by `num/den`, the multiply run in `i64` before a clamp to the i16 range. A negative `num` inverts phase. Refuses `BadGain` on a zero denominator, `BadRange` on a span outside the samples, before any write.
3. **splice(at, ins)** -- insert samples at a position and shift the tail right, so the inserted audio lands in order and everything after follows unchanged. Refuses `ClipFull` on overflow, `BadRange` past the samples, before any shift.

`splice` then `cut` over the same span are exact inverses -- the round-trip restores the original, the cleanest proof the two shifts are honest.

## The shape

`lotus/timeline.rye`:

- `Clip` -- a bounded editable buffer of i16 PCM samples (`max_clip = stream.max_timeline`, so a drained Timeline always loads).
- `load(timeline, clip)` -- copy a reassembled ALES1 Timeline into a Clip (the seam that ties the rung to the road: bytes -> frames -> gapless timeline -> editable clip), refusing `ClipFull` rather than truncate.
- `cut`, `gain`, `splice` -- the three edits above, each >=2 asserts, each refusing by name at the edge.
- `saturate(i64) i16` -- the clamp helper; the audio-editor's one owed correctness, named plainly against `sample_min` / `sample_max`.
- Bounded, TAME-clean: fixed buffer, `u32` counts, `i16` samples, copy loops (never a bare memcpy), the gain multiply widened to `i64` so it never overflows before the clamp.

## What the witness proves (GREEN on metal)

`tools/al/ales_timeline_witness.rish`: cut removes a span exactly and closes the gap; gain saturates rather than wraps (`20000x2 -> +32767`) and a negative num inverts phase clamping i16-min's negation; a sub-span gain leaves the rest untouched; splice inserts in order; splice then cut the same span round-trips to the original; an out-of-range cut refuses `BadRange` leaving the clip untouched; a zero-denominator gain refuses `BadGain`; an overflowing splice refuses `ClipFull`; and the rung composes on ALES1 -- a byte stream reassembles into a gapless Timeline, a Clip loads it, and an edit lands on the reassembled audio. GREEN on the first build. Purely local -- no socket, no network, no keys, no funds, no real device.

## The road on

The next Lotus rung can **clock** the timeline to a real sample rate (samples gain a time base -- seconds, not just indices), open a **second track** so two clips mix, or add **fade** envelopes (gain that ramps rather than steps). The audio-interface **hardware** stays a paused research round, taken only on Keaton's word.

---

*Three gestures, and the sound stays whole under every one -- cut closes the gap, gain holds the ceiling, splice keeps the order. May the first real edit a keeper makes land exactly where they meant it.*
