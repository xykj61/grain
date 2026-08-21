# Fill ALES183 — Lotus's stereo_taps: the multi-tap delay carried into stereo, the same tap set on both channels, each channel read off its own frozen dry snapshot — the second rung of the stereo time-based wing, the echo's snapshot sibling

**Stamp:** `20260815.090818` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES183
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-090218_fill-ales182-lotus-stereo-echo-in-real-time.md`](20260815-090218_fill-ales182-lotus-stereo-echo-in-real-time.md)

---

## The next crux, honestly chosen

ALES181 opened the stereo time-based wing with the feedback echo, and ALES182 gave that echo its real-time face. The wing's other primitive is the **multi-tap** (ALES68) — several **fixed** taps of the dry signal, each at its own delay and level, summed with the dry. It is a genuinely different way to read a delay line: the echo reads its own **live output** (a decaying feedback train), while the multi-tap reads a **frozen dry snapshot** (independent early reflections — a snare hitting three walls at three distances — that stand at their own chosen levels and never feed each other). Carrying it into stereo is the natural next crux: it opens the wing's second lane, and it is the honest one to take before the reverb (the wing's large composition), because the reverb is built from exactly these bounded early-reflection stages.

Crux-first, it is also the **cleanly-tractable** rung. Because the multi-tap reads a snapshot and its sum is **linear** in the input away from saturation, its stereo carry preserves the panned integer ratio **exactly** — the stronger both-cases image law the snapshot rungs (vibrato ALES178, chorus ALES179) already earn, and the one the feedback echo could not (its `@divTrunc` feedback truncation drifts a panned ratio by ones). So this rung is both a new primitive and a return to the clean image law.

## The shape — the same tap set on both channels, each read off its own dry snapshot

`stereo_multitap(sc, start, count, tap_set)` validates the tap set and span **once** against the shared length (ALES68's own validation, newly factored into a `pub precheck` exactly as ALES71/72/73's were), then runs ALES68's proven mono `multitap` on each channel with the **same** tap set:

- **The tap set is shared** — a tap's delay is a sample count and its level a named fraction the caller *names*, not scalars measured across the field, so the same tap set on each channel lands both early-reflection patterns in lockstep and preserves the stereo image for free.
- **Each channel reads its OWN dry snapshot** — mono `multitap` snapshots the dry prefix of its own clip before writing, so run once per channel the left reads the left's dry and the right the right's, never crossed. No cross-channel snapshot — the mono discipline twice.
- **The safety carries whole** — the whole sum (dry plus every tap) accumulates in i64 and saturates **once** through `timeline.saturate` per channel, so a constructive pile-up pins to the i16 rail rather than wrapping. Unlike the feedback echo, a tap **at unity** is legal (a full-level discrete echo) — a multi-tap has no loop to run away.

`StereoTapError = taps.TapError` — `BadTapCount`, `BadDelay`, `BadLevel`, `BadRange` reused whole; the stereo lift adds no fault.

## The laws proven

- **The stereo multi-tap law:** each channel equals ALES68's mono `multitap` with the same tap set over the same span byte for byte, proven side by side with genuinely different per-channel content (the two outputs differ, so no channel is crossed).
- **The dry-identity law:** an all-zero-level (`num = 0`) stereo multi-tap is the exact dry master on both channels — no reflection added, the identity — so the levels genuinely govern the reflections.
- **The image / balance / silence / atomicity / degenerate law:** an identical-channel (centred) master stays identical **and** a panned pair kept off the rail keeps its exact integer ratio (the snapshot read is linear, so a right exactly half the left stays exactly half after); an all-silent master taps to silence on both; `left.len == right.len` after; a bad tap count, a bad delay, a bad level, and an out-of-range span each refuse by name with both channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each rung through ALES68's own bounded snapshot multi-tap — one frozen dry snapshot and at most `max_taps` multiply-divides per sample, run in i64 and summed once per channel. A tap delay is a count of sample indices, not milliseconds against a clock (a real-time twin through the ALES5 clock is a later rung, exactly as `stereo_echo_time` followed `stereo_echo`); each tap level is a named fraction at or below unity, not a decibel. No cross-channel snapshot, no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round. With this the stereo time-based wing holds both its primitives (the feedback echo and the snapshot multi-tap), ready for the reverb — the wing's large composition, built from bounded early-reflection stages — to climb next.
