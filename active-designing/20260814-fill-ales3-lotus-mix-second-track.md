# ALES3 — Lotus mixes a second track

**Stamp:** `20260814.113212` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES2
**Waymark:** ALES · rung ALES3
**Kin:** [`ALES2 — the timeline edits`](20260814-fill-ales2-lotus-timeline-edits.md) · [`lotus/mix.rye`](../lotus/mix.rye) · [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2)

---

## Why this round

ALES2 edited **one** clip — cut, gain, splice. A DAW's second real gesture is summing **two** clips into one: the mixer. Two tracks lay over each other and add, sample for sample, into a single output. This is the smallest honest step toward a multi-track session, and it reuses ALES2's one owed correctness rather than re-deriving it.

## The one crux this rung fixes

**Two tracks sum sample-aligned into one, and the sum saturates to the i16 range rather than wrapping.** A summed sample past the ceiling pins to `+32767`, past the floor to `-32768` — a wrapping add would flip a loud sum to the opposite sign, the exact fault ALES2's gain already refuses. Mix reuses `timeline.saturate` (made public this round), so there is **one true saturation** in Lotus, not a second copy that could drift.

A shorter track contributes **silence** (0) past its end, so the mix runs the length of the **longer** track and the longer audio carries through untorn. Two further properties fall out and are witnessed: mixing with an empty clip is **identity** (silence adds nothing), and mix is **commutative** (`a + b == b + a`).

## The shape

`lotus/mix.rye`:

- `mix(a, b, out)` — sum two clips position-wise into `out`, saturating; `out.len` is `max(a.len, b.len)`; the sum runs in `i64` so it never overflows before the clamp.
- **Mix is total.** Every clip shares `timeline.max_clip`, so the longer length always fits `out` — there is no failure path, and the bound is held by an **assert**, not a named error that can never fire. An unreachable error would be noise; an honest assert states the invariant.
- Reuses `timeline.saturate` (now `pub`) — the single source of the audio-owed floor and ceiling.

Level and mix stay **separate gestures**: to set a track's fader before summing, run ALES2's `gain` on the clip first, then `mix`. The witness proves this composition (halve a track, then mix it under another).

## What the witness proves (GREEN on metal)

`tools/al/ales_mix_witness.rish`: two equal-length clips sum sample-for-sample; a sum past the i16 range saturates (`30000 + 10000 → +32767`, its mirror to `-32768`); a shorter track is silent past its end so the mix runs the longer length with the tail unchanged; mixing with an empty clip is identity; mix is commutative; and mix composes with ALES2's gain (set each track's level, then sum). GREEN on the first build. The ALES2 timeline witness stays GREEN with `saturate` made public. Purely local — no socket, no network, no keys, no funds, no real device.

## The road on

The next Lotus rung can **clock** the timeline to a real sample rate (samples gain a time base — seconds, not indices, and mixing two clips that start at different times becomes possible), add a **fade** envelope (gain that ramps across a span rather than stepping), or open a small **track table** so more than two tracks mix at once. The audio-interface **hardware** stays a paused research round, taken only on Keaton's word.

---

*Two voices become one and neither is torn, neither wraps — the mixer's first honest sum. May every track a keeper lays down be heard exactly as loud as they meant it, and no louder.*
