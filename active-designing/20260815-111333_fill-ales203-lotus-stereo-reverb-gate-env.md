# Fill ALES203 — Lotus's stereo envelope-gated reverb (the shaped-edge gated tail, per ear)

**Stamp:** `20260815.111333` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES203**
**Kin:** [`20260815-110731_fill-ales202-lotus-reverb-gate-env.md`](20260815-110731_fill-ales202-lotus-reverb-gate-env.md) · [`20260815-110035_fill-ales201-lotus-stereo-reverb-gate.md`](20260815-110035_fill-ales201-lotus-stereo-reverb-gate.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES202 gave the **mono** reverb its shaped-edge gated tail — the time-following envelope gate whose release holds the gate open over the decay, so the tail breathes rather than chops. Yet a keeper mixing a **stereo master** still had only the static stereo gate (ALES201); the shaped edge stopped at mono, exactly as the static gate did before ALES201 carried it across. This rung is the thin twin ALES202 named next: the **same** envelope gate, over **both** channels of a `StereoClip`, one shared threshold, ratio, and attack/release, the image held.

The ladder always closes the mono/stereo pair before opening a fresh axis — crux-first within the finishing edge. It is a clean composition of proven stages: ALES191's stereo named-room wet, then ALES54's `gate_follow` run per ear.

## The shape — reverberate the master wet, then follow-gate each ear

`stereo_reverb_gate_env(sc, clk, room, start_ms, count_ms, threshold, ratio_num, ratio_den, attack_num, attack_den, release_num, release_den)`:

1. Assert the channels enter balanced; validate the clock; **pre-check the threshold, ratio, and both attack/release coefficients** with the same guards ALES54 raises, **before any write**, so a bad setting leaves both channels *dry and balanced* (the atomicity crux).
2. Convert the span through ALES5's clock (`DurationTooLong`) and range-check it (`BadRange`, one bound governs both balanced channels) before any write.
3. Run ALES191's `stereo_reverb_preset` over the master — the **wet**, in place, unchanged.
4. Follow-gate **each** channel's wet span through ALES54's `gate_follow` at the **same** threshold, ratio, and coefficients, with **no cross-channel read** — the left ear follow-gates left, the right ear follow-gates right, so the image the preset held is held.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`ratio_num == ratio_den`)** — equals ALES191's `stereo_reverb_preset` over the span, byte for byte on **both** channels, at any threshold and coefficients.
2. **IT EQUALS ITS COMPOSITION** — for a firm ratio with a real attack/release, each channel equals `stereo_reverb_preset` then `gate_follow` on that channel, byte for byte; and each shaped-gated channel differs from its wet.
3. **THE INSTANTANEOUS LIMIT IS ALES201** — with unit attack and unit release, `stereo_reverb_gate_env` equals the static `stereo_reverb_gate` (ALES201) byte for byte on both channels — the static stereo gate is this rung's zero-smoothing limit.
4. **THE TAIL IS GATED** — each shaped-gated channel's total energy is strictly less than its wet's.
5. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel; a genuinely stereo master keeps its channels distinct — no crossing.
6. **THE CHANNELS LEAVE BALANCED** and silence stays silence.
7. **THE FAULTS FORWARD, ATOMIC** — a bad threshold `BadThreshold`, a bad ratio `BadRatio`, an illegal coefficient `BadCoeff`, each with **both channels untouched (still dry)**; a span past the clip `DurationTooLong`; an out-of-range span `BadRange`; each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, and ALES191's fixed banks, siloed to `lotus/`. No new audio arithmetic — the gate is ALES54's proven envelope-following gate over the proven stereo wet, run per ear. A **wet-tail** stereo envelope gate; the attack/release are fractions per sample index, so the gate means the same relative shape at any sample rate. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The gate axis then stands whole for mono and stereo in both its static and shaped forms. A fresh reverb axis opens next — **width** (the stereo spread of the tail), **freeze** (an infinite-hold sustain), or **early/late balance** (the ratio of the first reflections to the diffuse wash).
