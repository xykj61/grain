# Fill ALES201 — Lotus's stereo gated reverb (the gate across the tail, across a stereo master)

**Stamp:** `20260815.110035` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES201**
**Kin:** [`20260815-105453_fill-ales200-lotus-reverb-gate.md`](20260815-105453_fill-ales200-lotus-reverb-gate.md) · [`20260815-104900_fill-ales199-lotus-stereo-reverb-tone.md`](20260815-104900_fill-ales199-lotus-stereo-reverb-tone.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES200 gave the **mono** reverb its gate — a downward gate slammed across the reverberant tail so only the loud early wash is heard, the classic eighties gated-reverb drum sound. A keeper mixing a **stereo** master still had no such knob, exactly as the tone stopped at mono before ALES199 carried it across. This rung is the thin twin ALES200 named next: the **same gate**, over **both** channels of a `StereoClip`, one shared threshold and ratio, the image held.

By Lindy-first, crux-first this is the highest-Lindy tractable move remaining on the gate axis: it completes the mono/stereo pair the ladder always closes, and it is a **clean composition of proven pieces** — ALES191's stereo wet and ALES49's downward gate, applied per ear with no cross-channel read.

## The shape — reverberate the master wet, then gate each channel

`stereo_reverb_gate(sc, clk, room, start_ms, count_ms, threshold, ratio_num, ratio_den)`:

1. Assert the channels enter balanced; validate the clock; **pre-check the gate's threshold and ratio with the same guards ALES49's gate raises** (a threshold in `[1, sample_max]` → `BadThreshold`; a ratio at least one with a nonzero denominator → `BadRatio`) **before any write**, so a bad gate leaves both channels *dry and balanced* (the atomicity crux, ALES200's inline-precheck precedent carried per ear).
2. Convert the span through ALES5's clock (forwarding `DurationTooLong`) and range-check it against the shared channel length (`BadRange`) before any write.
3. Run ALES191's `stereo_reverb_preset` over the master — the **wet**, in place, unchanged.
4. Gate **each** channel's wet span through ALES49's `gate` with the *same* threshold and ratio — the left ear gates left, the right ear gates right, no cross-channel read, so the stereo image the preset held is held through the gating.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`ratio_num == ratio_den`)** — equals ALES191's `stereo_reverb_preset` over the span, byte for byte on **both** channels. A unit-ratio gate is exactly the un-gated stereo reverb, at any threshold.
2. **IT EQUALS ITS COMPOSITION** — for a firm ratio (8:1), each channel equals `stereo_reverb_preset` then `gate` on that channel, byte for byte; and each gated channel differs from its un-gated wet.
3. **THE TAIL IS GATED** — each gated channel's total energy (summed magnitude) is strictly less than that channel's un-gated wet's.
4. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel through the shared threshold and ratio; a genuinely stereo master keeps its two channels distinct (no crossing).
5. **THE CHANNELS LEAVE BALANCED** and **silence stays silence**.
6. **THE FAULTS FORWARD, ATOMIC** — a bad threshold refuses `BadThreshold` and a bad ratio `BadRatio`, each with both channels **untouched (still dry)**; a span past the clip `DurationTooLong`; an out-of-range span `BadRange`; each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, and ALES191's fixed banks, siloed to `lotus/`. No new audio arithmetic — the gate is ALES49's proven downward gate over the proven stereo wet, run per ear. A wet-tail gate; a true time-following envelope gate remains the named separate horizon. The threshold is a magnitude and the ratio a plain fraction, so the gate means the same at any sample rate. No socket, no network, no keys, no funds, no real device. No custody gate reached — a self-approved design round.

## Next after this

The gate axis stands whole for mono and stereo. Beyond it, a shaped **envelope-gate** rung (an attack/hold/release that opens on the transient and closes over the decay, so the cut has a shaped edge rather than a hard floor) is the richer, genuinely new-primitive horizon; or a fresh reverb axis (width, freeze, or early/late balance).
