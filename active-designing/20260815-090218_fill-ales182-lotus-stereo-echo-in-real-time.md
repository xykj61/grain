# Fill ALES182 — Lotus's stereo_echo_time: the stereo echo spoken in MILLISECONDS, a thin twin over ALES181 the clock adds only the units to — the first real-time face of the stereo time-based wing

**Stamp:** `20260815.090218` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES182
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-085411_fill-ales181-lotus-stereo-echo.md`](20260815-085411_fill-ales181-lotus-stereo-echo.md)

---

## The next crux, honestly chosen

ALES181 opened the **stereo time-based wing** with its primitive — the feedback delay carried onto both channels, each reading and feeding back through its own live buffer. Its delay, though, is a count of sample **indices** ("an echo every 12000 samples"). A musician thinks in **time** — "an echo an eighth of a second later" — and the one missing fact is the sample rate, which ALES5's validated `Clock` already holds. The mono wing earned its real-time twin the instant its primitive landed: ALES66's `echo` was followed straight away by ALES67's `echo_ms`. The stereo wing earns the same twin now, for the same reason and by the same thin move.

It is the honest crux to take next — the **thinnest, highest-confidence** carry that opens a whole new lane. No stereo module yet speaks in milliseconds; `stereo_echo_time` is the **first real-time face in stereo**, and it seats the pattern every later stereo real-time twin (a timed multitap, a timed reverb) will follow. Least new machinery, most reuse: it composes two already-proven, already-witnessed tools — ALES181's `stereo_echo` and ALES5's `clock.samples_for` — and adds no arithmetic on the audio path.

## The shape — the clock adds only the units, never the audio; the same conversion feeds both channels

`stereo_echo_ms(sc, clk, start_ms, count_ms, delay_ms, fb_num, fb_den)` converts `start_ms`, `count_ms`, and `delay_ms` **once** through ALES5's proven `clock.samples_for` (bounded, refusing `DurationTooLong` past the clip), then delegates to ALES181's `stereo_echo` **unchanged** with the converted delay and span and the caller's named feedback:

- **The conversion is shared, so the image is held for free** — one `delay_ms` becomes one sample delay applied identically to both channels, exactly as ALES181 already shares its delay and feedback. The clock speaks the same number to each channel, so both trains still decay in lockstep.
- **The clock adds only the units** — `samples_for` is `divTrunc(rate·ms, 1000)`, a pure conversion; the audio path is ALES181's, untouched. So a millisecond-named stereo echo lands **byte-for-byte** the same samples on each channel as the index-named stereo echo over the converted delay and span.
- **A sub-sample delay refuses honestly** — because `samples_for` truncates, a `delay_ms` too short to be one whole sample converts to `0`, which ALES181 (through ALES66's `precheck`) already refuses `BadDelay` on both channels before a write — so a sub-sample echo refuses by name rather than silently doing nothing.

`StereoEchoTimeError = clock.ClockError || echo.EchoError` — the clock's `DurationTooLong` beside the echo's `BadDelay` / `BadFeedback` / `BadRange`, every fault refusing by name before either channel is touched.

## The laws proven

- **The clock-adds-only-units law:** at a legible clock (1 sample per ms), `stereo_echo_ms` lands byte-for-byte the same samples on **both** channels as ALES181's index-named `stereo_echo` over the converted delay and span — both tools run side by side and demanded equal, so the timed face adds no arithmetic on the audio path.
- **The real-rate law:** at 48 kHz, 1 ms converts to `divTrunc(48000·1, 1000) = 48` samples on both channels; a stereo echo at `delay_ms = 1` lands its first echo exactly 48 samples after the impulse on each channel, matching the index-named form at delay 48.
- **The dry-identity law:** a zero-feedback (`fb_num = 0`) timed stereo echo is the exact dry master on both channels in real time too — the feedback still governs the train after the units change.
- **The forwarding / atomicity / balance law:** a sub-sample delay (0 ms) refuses `BadDelay`; a delay past the clip refuses `DurationTooLong`; a feedback at unity refuses `BadFeedback`; an out-of-range span refuses `BadRange` — each by name, with **both channels byte for byte untouched and still balanced** (`left.len == right.len`), and `count_ms = 0` the identity on both. The image law is inherited whole: an identical-channel master stays identical through the timed echo (the same conversion, then the same live-buffer feedback on each channel).

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right) and a validated `Clock`; three millisecond conversions through the clock's own bounded `samples_for`, then ALES181's proven stereo echo delegated unchanged — no new arithmetic on the audio path. The clock is a samples-per-second count, not a claim about any hardware clock; the delay is spoken in milliseconds and the feedback is a named fraction strictly below unity, not a decibel. No cross-channel feedback, no real sample rate device, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round. With this the stereo time-based wing gains its real-time face, ready for its timed compositions (a timed multitap, a timed reverb) to climb next.
