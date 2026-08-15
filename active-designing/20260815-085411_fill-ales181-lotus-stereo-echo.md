# Fill ALES181 — Lotus's stereo_echo: the feedback delay carried into stereo, the same delay and feedback on both channels, each channel reading and feeding back through its own live buffer — the first rung of the stereo time-based wing

**Stamp:** `20260815.085411` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES181
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-084450_fill-ales180-lotus-stereo-flanger.md`](20260815-084450_fill-ales180-lotus-stereo-flanger.md)

---

## The next crux, honestly chosen

ALES176–180 carried the whole **modulation class** into stereo — the amplitude pair (tremolo, ring modulator) beside the delay-line trio (vibrato, chorus, flanger). That class is now whole, so the next durable move opens a **new stereo wing** rather than accreting one more modulation. The **echo** (ALES66) is that wing's foundation: it opened the mono *time-based* wing with its primitive, the feedback delay `y[i] = x[i] + fb·y[i-d]`, and the chorus, the flanger, and the reverb are each a delay line read a different way of that same primitive. Carrying it into stereo opens the **stereo time-based wing** exactly as ALES66 opened the mono one — one primitive, then compositions.

It is the honest crux to take next precisely because the flanger (ALES180) already reached into its own **live** output through a feedback path — so the echo, the plain longer feedback delay the flanger's zero-depth case reduces to, is the base that whole wing already stands on. It is the **simpler** live-feedback carry (a fixed whole delay, no LFO), which makes it the right rung to seat a wing's foundation on: least new machinery, most reuse.

## The shape — the same delay and feedback on both channels, each on its own live buffer

`stereo_echo(sc, start, count, delay, fb_num, fb_den)` validates the delay, feedback, and span **once** against the shared length (ALES66's own `precheck`, newly factored out exactly as ALES73's was for the flanger), then runs ALES66's proven mono `echo` on each channel with the **same** `delay` and the **same** `fb_num/fb_den` feedback:

- **The delay and feedback are both shared** — an echo's delay is a sample count and its feedback a named fraction the caller *names*, not scalars measured across the field, so the same parameters on each channel decay both trains in lockstep and preserve the stereo image for free.
- **Each channel reads its OWN LIVE buffer** — mono `echo` reads the delayed output off the clip buffer itself (the delay line *is* the buffer), so run once per channel the left feeds back through the left's buffer and the right through the right's, never crossed. There is no cross-channel feedback, and no carried state — because the delay is at least one whole sample, `buf[i-delay]` sits strictly before the write index (an already-written output, the dry audio, or silence).
- **The safety carries whole** — feedback strictly below unity decays, so each echo is smaller than the last and a constructive sum past the rail saturates once, per channel.

## The laws proven

- **The stereo echo law:** each channel equals ALES66's mono `echo` with the same delay and feedback over the same span byte for byte, proven side by side with genuinely different per-channel content (the two outputs genuinely differ, so no channel is crossed).
- **The dry-identity law:** a zero-feedback (`fb_num = 0`) stereo echo is the exact dry master on both channels — no delayed voice added, the identity — proving the feedback genuinely governs the train.
- **The image / balance / silence / atomicity / degenerate law:** an identical-channel (centred) master stays identical (each channel's feedback loop wholly within its own buffer); an all-silent master echoes to silence on both; `left.len == right.len` after; a bad delay, a bad feedback, and an out-of-range span each refuse by name with both channels byte for byte untouched and still balanced; `count = 0` is the identity on both. Honestly noted: like the flanger and unlike the snapshot rungs, the echo does **not** preserve an exact panned integer ratio — the feedback path accumulates `@divTrunc` truncation, so a right exactly half the left drifts from that ratio by ones once the loop has fed a few samples. An accumulating feedback delay is not a linear scaler; the identical-channel law is the sense a mix cares about most (a centred voice stays centred), and it is the one proven.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each rung through ALES66's own live-buffer feedback delay — one delayed read and at most one multiply-divide per sample, run in i64, each channel reading and feeding back through its own buffer, the fed sum saturating once. The delay is a count of sample indices, not milliseconds against a clock; the feedback is a named fraction strictly below unity, not a decibel. No cross-channel feedback, no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round. With this the stereo time-based wing opens on its foundation, the plain feedback echo, ready for its own compositions (a real-time echo through the clock, a multitap, a stereo chorus/reverb) to climb next.
