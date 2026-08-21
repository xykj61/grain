# Fill ALES180 — Lotus's stereo_flanger: the short modulated delay with a feedback path, carried into stereo, the same LFO and feedback on both channels, each channel reading its own LIVE buffer — the fifth rung of the stereo modulation class, and the first stereo modulation that reads its own output

**Stamp:** `20260815.084450` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES180
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-083932_fill-ales179-lotus-stereo-chorus.md`](20260815-083932_fill-ales179-lotus-stereo-chorus.md)

---

## The next crux, honestly chosen

ALES178 and ALES179 carried the two snapshot delay-line modulations — the vibrato and its parent the chorus — into stereo, each channel reading a **frozen** copy of its own dry so a moving read never reads a sample it just wrote. The **flanger** (ALES73) is the delay-line family's first rung that does the opposite: it reads its short modulated delay off the **live** buffer and **feeds the delayed voice back into itself**, the moving comb it makes — notches sliding up and down and deepened by the feedback — the jet-plane whoosh a keeper reaches for by name. That feedback returns a fault the snapshot rungs never had: **BadFeedback** (a zero denominator or a feedback at or above unity, which would never decay — a runaway). Carrying it into stereo completes the delay-line trio and is the harder crux precisely because each channel now reads **its own output** rather than a frozen copy.

## The shape — the same LFO and feedback on both channels, each on its own live buffer

`stereo_flanger(sc, start, count, centre_scaled, depth_scaled, period, fb_num, fb_den)` validates the LFO, feedback, and span **once** against the shared length (ALES73's own `precheck`, newly factored out exactly as ALES71/72/75's were), then runs ALES73's proven mono `flanger` on each channel with the **same** LFO and the **same** `fb_num/fb_den` feedback:

- **The LFO and feedback are both shared** — a flanger's centre, depth, period, and feedback are all scaled units or fractions the caller names, not scalars measured across the field, so the same parameters on each channel sweep both combs in lockstep and preserve the stereo image for free.
- **Each channel reads its OWN LIVE buffer** — mono `flanger` reads the delay off the clip buffer itself (the delay line *is* the buffer), so run once per channel the left feeds back through the left's buffer and the right through the right's, never crossed. There is no cross-channel feedback — the two channels never hear each other — and no snapshot at all, because the delay is at least one whole sample, so both interpolation neighbours sit strictly before the write index (already-written outputs, dry, or silence).
- **The safety carries whole** — feedback strictly below unity decays, so each echo is smaller than the last and a constructive sum past the rail saturates once, per channel.

## The laws proven

- **The stereo flanger law:** each channel equals ALES73's mono `flanger` with the same LFO and feedback over the same span byte for byte, proven side by side with genuinely different per-channel content (the two outputs genuinely differ).
- **The dry-identity law:** a zero-feedback (`fb_num = 0`) stereo flanger is the exact dry master on both channels — no delayed voice added, the identity — proving the feedback genuinely governs the comb.
- **The echo-degenerate law:** a zero-depth stereo flanger is exactly ALES66's echo at its centre on both channels (the periodic driver reduces to the fixed one at rest), carried per channel — the flanger with its motion stilled is a plain feedback echo.
- **The image law (identical-channel):** an identical-channel (centred) master stays identical through the flanger — each channel's feedback loop stays wholly within its own buffer, so a centred voice never splits. Honestly noted: unlike the snapshot rungs (vibrato, chorus), the flanger does **not** preserve an exact panned integer ratio — the feedback path accumulates `@divTrunc` truncation, so a right exactly half the left drifts from that ratio by ones once the loop has fed a few samples. An accumulating feedback comb is not a linear scaler; the identical-channel law is the sense a mix cares about most (a centred voice stays centred), and it is the one proven.
- **The balance / silence / atomicity / degenerate law:** an all-silent master flanges to silence on both; `left.len == right.len` after; a bad period, a bad depth, a bad delay top, a bad feedback, and an out-of-range span each refuse by name with both channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each rung through ALES73's own live-buffer feedback delay — the triangle and the fractional interpolation in i64, each channel reading and feeding back through its own buffer, the fed sum saturating once. The LFO is counted in scaled units (256 = unity) and the period in samples, not hertz; the feedback is a named fraction strictly below unity, not a decibel. No cross-channel feedback, no snapshot, no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round. With this the stereo modulation class holds its whole delay-line wing (vibrato · chorus · flanger) beside the amplitude pair (tremolo · ring modulator).
