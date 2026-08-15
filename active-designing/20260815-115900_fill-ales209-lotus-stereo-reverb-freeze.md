# Fill ALES209 — Lotus's stereo frozen reverb (the held tail carried across a stereo master)

**Stamp:** `20260815.115900` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES209**
**Kin:** [`20260815-115209_fill-ales208-lotus-reverb-freeze.md`](20260815-115209_fill-ales208-lotus-reverb-freeze.md) · [`20260815-114348_fill-ales207-lotus-stereo-reverb-early-late.md`](20260815-114348_fill-ales207-lotus-stereo-reverb-early-late.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES208 gave the **mono** reverb its freeze — a held tail sustained by iterated reverberation. Yet a keeper mixing a **stereo master** still had no such knob; the freeze stopped at mono, exactly as the early/late balance did before ALES207 carried *it* across. This rung is the thin twin ALES208 named next: the **same** iterated reverberation, over **both** channels of a `StereoClip`, one shared room and depth, the image held.

The ladder always closes the mono/stereo pair before opening a fresh axis — crux-first within the finishing edge. It composes one proven stage exactly as ALES208 did, only the stereo one: ALES191's `stereo_reverb_preset` run over the master `passes` times in place, each pass reverberating the reverberation on each channel's own audio with no cross-channel read.

## The shape — reverberate the master, then reverberate the reverberation, per ear

`stereo_reverb_freeze(sc, clk, room, start_ms, count_ms, passes)`:

1. Assert the channels enter balanced; assert the clock; refuse a bad freeze depth (`BadPasses`) **before any write**.
2. Run ALES191's `stereo_reverb_preset` over the master `passes` times **in place, unchanged**. The **first** pass prechecks before any write, so a span or bank fault leaves both channels *dry and balanced* — the atomicity crux. Once the first pass succeeds it has validated the span, room, and clock; every later pass over the same master cannot fault, so the loop refuses whole up front or completes whole. One shared bank feeds both channels, each reverberating its own audio, so the image the preset held is held across every pass.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`passes == 1`)** — each channel equals ALES191's `stereo_reverb_preset` over the master, byte for byte. One pass is exactly the plain stereo wet.
2. **IT EQUALS ITS COMPOSITION** — `passes == 2` equals `stereo_reverb_preset` applied twice byte for byte on both channels, and `passes == 3` thrice: the stereo freeze IS iterated reverberation.
3. **THE FREEZE DEEPENS** — `passes == 2` differs from `passes == 1` on the stereo master: a second pass genuinely changes the tail.
4. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel at any depth; a genuinely stereo master keeps its channels distinct — no crossing.
5. **THE CHANNELS LEAVE BALANCED** and silence stays silence.
6. **THE FAULTS FORWARD, ATOMIC** — a zero or over-bound depth `BadPasses`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with both channels untouched and balanced (the first pass prechecks before any write).

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, ALES190's fixed reverb banks, and a bounded freeze depth (`max_passes`), siloed to `lotus/`. No new audio arithmetic — the freeze is ALES191's proven stereo reverb composed with itself, each pass saturating once as the reverb already does. The depth is a named count of passes, not a decay time in seconds; "freeze" names iterated reverberation honestly, not a literal infinite sustain. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The freeze axis then stands whole, mono and stereo. A fresh reverb axis opens next — **width** (the stereo spread of the tail), which wants its own mid/side primitive and so opens a small primitive round before the reverb rung that spends it.
