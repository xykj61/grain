# Fill ALES195 — Lotus's stereo reverb pre-delay

**Stamp:** `20260815.102559` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES195**
**Kin:** [`20260815-102052_fill-ales194-lotus-reverb-predelay.md`](20260815-102052_fill-ales194-lotus-reverb-predelay.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES194 gave the mono reverb its **when** — the pre-delay, the short silent gap that sits the room a hair behind the dry so a voice reads clear of its own tail. Yet a keeper mixing a **stereo master** still had no such knob; the pre-delay comfort stopped at mono, exactly as the wet/dry balance did before ALES193 carried it across. This rung is the thin twin ALES194 itself named next: the **same shift, over both channels of a `StereoClip`, one shared gap, the image held.**

By Lindy-first, crux-first this is the highest-Lindy tractable move: it completes the pre-delay axis for stereo — read for years by anyone mixing two channels — as a **clean composition of proven pieces**, no new audio arithmetic, only a bounded per-channel reindex of ALES191's stereo wet.

## The shape — reverberate the master wet, then shift each channel's wet onset later within the span

`stereo_reverb_predelay(sc, clk, room, start_ms, count_ms, predelay_ms)`:

1. Assert the two channels enter balanced (`sc.left.len == sc.right.len`) and the clock is valid.
2. Convert the span through ALES5's clock (forwarding `DurationTooLong`) and validate it against the balanced channel length (`BadRange`) **before any write**. One bound governs both channels.
3. Convert `predelay_ms` through the SAME clock; refuse `BadPredelay` if it exceeds `count` (a gap wider than the span is no pre-delay at all).
4. Run ALES191's `stereo_reverb_preset` over the master — the **wet**, in place, unchanged.
5. **Snapshot each channel's wet** into its own bounded stack buffer, then rewrite each channel shifted right by `predelay`: `out[i] = 0` for `i < predelay`, `out[i] = wet[i − predelay]` otherwise. One shared gap, no cross-channel read — the left ear delays left, the right ear delays right — so the stereo image the preset held is held through the delay.

## The provable laws the witness proves

1. **THE ZERO-DELAY EDGE (predelay = 0)** — equals ALES191's `stereo_reverb_preset` over the span, byte for byte on **both** channels. No gap is exactly the un-delayed stereo reverb.
2. **THE FULL-DELAY EDGE (predelay = count)** — the whole wet is shifted off the span end on both channels; the span is all zeros on both ears.
3. **THE SHIFT IS EXACT** — for `0 < predelay < count`, the first `predelay` samples of each channel are zero and the rest are that channel's own wet shifted by exactly `predelay`, byte for byte against the un-delayed wet computed side by side.
4. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel through any pre-delay (one shared gap); a genuinely stereo master keeps its two channels distinct — no crossing.
5. **THE CHANNELS LEAVE BALANCED and silence stays silence** — an all-zero master at any pre-delay stays all zeros on both channels, the channels balanced.
6. **THE FAULTS FORWARD** — a pre-delay past the span refuses `BadPredelay`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with both channels untouched and balanced.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, ALES191's fixed banks, and two bounded stack snapshots (max_clip = 4096 samples each), siloed to `lotus/`. No new audio arithmetic — the pre-delay is a bounded per-channel reindex of the proven stereo wet, so no value is ever recomputed or can wrap; the gap is filled with true zeros. A **wet-domain** stereo pre-delay: it delays the reverberant onset within the span on both ears; combined with the dry through ALES193's stereo wet/dry mix it is the classic console pre-delay, and that composition is a later rung. The pre-delay is a named duration in milliseconds, so it means the same gap at any sample rate. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

With the pre-delay axis complete for mono and stereo, the reverb has *which room*, *how much*, and *when* on both. The next genuinely new expressive control on the proven network is a **damping** knob (a high-frequency roll-off inside the tail, so the room darkens as it decays) or the **dry-composed** pre-delay (ALES194/195's wet-domain shift blended against the dry through the ALES192/193 mix, the true console pre-delay end to end).
