# Fill ALES207 — Lotus's stereo reverb early/late balance (the first reflections against the diffuse wash, per ear)

**Stamp:** `20260815.114348` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES207**
**Kin:** [`20260815-113645_fill-ales206-lotus-reverb-early-late.md`](20260815-113645_fill-ales206-lotus-reverb-early-late.md) · [`20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md`](20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES206 gave the **mono** reverb its early/late balance — a crossfade between a room's discrete first reflections and its diffuse late wash. Yet a keeper mixing a **stereo master** still had no such knob; the early/late balance stopped at mono, exactly as the wet/dry mix did before ALES193 carried *it* across. This rung is the thin twin ALES206 named next: the **same** crossfade, over **both** channels of a `StereoClip`, one shared early bank, room, and balance, the image held.

The ladder always closes the mono/stereo pair before opening a fresh axis — crux-first within the finishing edge. It composes proven stages exactly as ALES193 did: the early reflections per ear are ALES69's `multitap_ms` (run once per channel, each reading its own dry), the late wash is ALES191's `stereo_reverb_preset`, and the blend is the same linear balance run per channel with no cross-channel read.

## The shape — the early reflections against the late wash, per ear, one balance knob

`stereo_reverb_early_late(sc, clk, room, start_ms, count_ms, balance_num, balance_den)`:

1. Assert the channels enter balanced; assert the clock; refuse a bad balance fraction (`BadBalance`) before any write.
2. Compute the **EARLY** signal on a full **copy** of the master: ALES69's `multitap_ms` over the room's fixed early bank (ALES206's own published banks), run on **each** channel of the copy — the left ear reads the left's dry, the right the right's, never crossed. The copy absorbs every fault the multi-tap could raise, so the real master stays untouched and balanced on refusal.
3. Compute the **LATE** signal in place on the master: ALES191's `stereo_reverb_preset` UNCHANGED — the room's diffuse wash across both channels. It prechecks before any write, so a fault here leaves both channels dry and balanced.
4. **Blend** each channel's early against its own late over the span, the same linear weighted average per sample, saturated once, with no cross-channel read:
   `out[i] = saturate((balance_den − balance_num)·early[i]/balance_den + balance_num·late[i]/balance_den)`.

## The provable laws the witness proves

1. **THE EARLY EDGE (`balance == 0`)** — each channel equals ALES69's `multitap_ms` over the room's published early bank, byte for byte. Fully toward early is exactly the discrete first reflections, per ear.
2. **THE LATE EDGE (`balance == den`)** — equals ALES191's `stereo_reverb_preset` over the span, byte for byte on both channels.
3. **THE BLEND IS BETWEEN** — a half balance differs from both edges on each channel, and each sample of each channel is the honest weighted average of its own early and its own late, byte for byte.
4. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel; a genuinely stereo master keeps its channels distinct — no crossing.
5. **THE CHANNELS LEAVE BALANCED** and silence stays silence.
6. **THE FAULTS FORWARD, ATOMIC** — a bad balance fraction `BadBalance`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with both channels untouched and balanced (the early multi-tap runs on the copy, the late preset prechecks).

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, ALES191's fixed reverb banks and ALES206's fixed early-tap banks, and one bounded full-master copy for the early signal, siloed to `lotus/`. No new audio arithmetic — the crossfade is ALES206's proven linear blend run per ear, each channel's early and late computed by a proven stage, saturated once. The early banks are named in **milliseconds**, so one room sounds the same at any sample rate; the balance is a named fraction, not a decibel. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The early/late axis then stands whole, mono and stereo. A fresh reverb axis opens next — **width** (the stereo spread of the tail) or **freeze** (an infinite-hold sustain).
