# Fill ALES199 — Lotus's stereo reverb tone (the darkness knob, across a stereo master)

**Stamp:** `20260815.104900` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES199**
**Kin:** [`20260815-104206_fill-ales198-lotus-reverb-tone.md`](20260815-104206_fill-ales198-lotus-reverb-tone.md) · [`20260815-102559_fill-ales195-lotus-stereo-reverb-predelay.md`](20260815-102559_fill-ales195-lotus-stereo-reverb-predelay.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES198 gave the **mono** reverb its darkness knob — a high-cut on the reverberant tail, so the room absorbs highs the way a real space does. A keeper mixing a **stereo** master still had no such knob, exactly as the pre-delay comfort stopped at mono before ALES195 carried it across. This rung is the thin twin ALES198 named next: the **same high-cut**, over **both** channels of a `StereoClip`, one shared coefficient, the image held.

By Lindy-first, crux-first this is the highest-Lindy tractable move remaining on the tone axis: it completes the mono/stereo pair the ladder always closes, and it is a **clean composition of proven pieces** — ALES191's stereo wet and ALES40's one-pole low-pass, applied per ear with no cross-channel read.

## The shape — reverberate the master wet, then darken each channel

`stereo_reverb_tone(sc, clk, room, start_ms, count_ms, tone_num, tone_den)`:

1. Assert the channels enter balanced; validate the clock; convert the span through ALES5's clock (forwarding `DurationTooLong`) and validate it against the (shared) channel length (`BadRange`) **before any write**.
2. **Pre-check the tone coefficient through ALES40's `tone.precheck`** against the span — refuse `BadTone` on an illegal coefficient **before the wet is written**, so a bad tone leaves both channels *dry* and balanced (the atomicity crux).
3. Run ALES191's `stereo_reverb_preset` over the master — the **wet**, in place, unchanged.
4. Low-pass **each** channel's wet span through `tone.low_pass` with the *same* coefficient — the left ear darkens left, the right ear darkens right, no cross-channel read, so the stereo image the preset held is held through the darkening.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`tone_num == tone_den`)** — equals ALES191's `stereo_reverb_preset` over the span, byte for byte on **both** channels. A full-open tone is exactly the un-darkened stereo reverb.
2. **IT EQUALS ITS COMPOSITION** — for a sub-unity coefficient, each channel equals `stereo_reverb_preset` then `tone.low_pass` on that channel, byte for byte; and each darkened channel differs from its un-darkened wet.
3. **THE TAIL DARKENS** — each darkened channel's high-frequency roughness (summed first-difference) is strictly less than that channel's un-darkened wet's.
4. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel through the shared coefficient; a genuinely stereo master keeps its two channels distinct (no crossing).
5. **THE CHANNELS LEAVE BALANCED** and **silence stays silence**.
6. **THE FAULTS FORWARD, ATOMIC** — an illegal tone coefficient refuses `BadTone` with both channels **untouched (still dry)**, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, and ALES191's fixed banks, siloed to `lotus/`. No new audio arithmetic — the tone is ALES40's proven one-pole low-pass over the proven stereo wet, run per ear. A wet-tail tone; a true in-loop damped-comb Freeverb damping remains the named separate horizon. The coefficient is a plain fraction, so it means the same roll-off at any sample rate. No socket, no network, no keys, no funds, no real device. No custody gate reached — a self-approved design round.

## Next after this

The tone axis stands whole for mono and stereo. Beyond it, a **damped-comb primitive** (a low-pass inside each comb's feedback, so later echoes darken progressively — true Freeverb damping) is the richer, genuinely new-primitive horizon; or a fresh reverb axis (width, freeze, or early/late balance).
