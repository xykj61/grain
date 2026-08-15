# Fill ALES208 — Lotus's frozen reverb (the tail held by iterated reverberation)

**Stamp:** `20260815.115209` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES208**
**Kin:** [`20260815-114348_fill-ales207-lotus-stereo-reverb-early-late.md`](20260815-114348_fill-ales207-lotus-stereo-reverb-early-late.md) · [`20260815-105453_fill-ales200-lotus-reverb-gate.md`](20260815-105453_fill-ales200-lotus-reverb-gate.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES207 closed the **early/late** axis whole — mono and stereo, the first reflections against the diffuse wash. The reverb now carries **which** room (ALES190), **how much** (ALES192/193, the wet/dry balance), **when** (ALES194–197, the pre-delay), **how bright** (ALES198/199, the tone; ALES204/205, the two-band shelf), **how long the tail is heard** (ALES200/201, the gate; ALES202/203, the gated envelope), and **the reflections against the wash** (ALES206/207). ALES207 named the next fresh axis openly — **width** (the stereo spread of the tail) or **freeze** (an infinite-hold sustain).

This rung takes **freeze**, because it composes a proven stage with a clean identity edge exactly as every fresh reverb axis before it did (ALES200's gated reverb is `reverb_preset` then `gate`), while **width** would want genuinely new mid/side arithmetic no proven stage yet carries. A **frozen reverb** is the held pad, the cinematic swell, the shimmer that hangs in the air — a reverberant tail that sustains and thickens instead of decaying to silence. The honest, provable way to voice it without new arithmetic is **iterated reverberation**: reverberate the span, then reverberate the reverberation, and again — each pass smearing the wash into a longer, denser tail. That is precisely what a feedback-fed freeze *is*, modelled by composing ALES190's named-room reverb with itself.

## The shape — reverberate the span, then reverberate the reverberation

`reverb_freeze(clip, clk, room, start_ms, count_ms, passes)`:

1. Assert the clock; refuse a bad freeze depth (`BadPasses` — a zero depth is no reverb at all, a depth past the bound `max_passes` would grow an unbounded loop) **before any write**.
2. Run ALES190's `reverb_preset` over the span `passes` times **in place, unchanged**. The **first** pass prechecks before any write (its own contract), so a span or bank fault leaves the clip *dry* — the atomicity crux. Once the first pass succeeds, every later pass runs over the same span, room, and clock it already validated, so none can fault: the loop either refuses whole up front or completes whole.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`passes == 1`)** — equals ALES190's `reverb_preset` over the span, byte for byte. One pass is exactly the plain wet; the freeze at its shallowest is the un-frozen reverb.
2. **IT EQUALS ITS COMPOSITION** — `passes == 2` equals `reverb_preset` applied twice byte for byte, and `passes == 3` thrice: the freeze IS iterated reverberation, every sample written by a stage already proven byte for byte.
3. **THE FREEZE DEEPENS** — `passes == 2` differs from `passes == 1`: a second pass genuinely changes the tail (a room's wash is not a fixed point), so the freeze knob does real work.
4. **THE ROOMS DIFFER** — room, hall, and plate frozen tails are three different washes: the named banks are real, not three names for one.
5. **SILENCE STAYS SILENCE** — an all-zero clip at any depth stays all zeros; the reverberation of silence is silence, iterated.
6. **THE FAULTS FORWARD, ATOMIC** — a zero or over-bound depth `BadPasses`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with the clip untouched (the first pass prechecks before any write).

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`'s worth of mono `Clip`, a validated clock, ALES190's fixed reverb banks, and a bounded freeze depth (`max_passes`), siloed to `lotus/`. No new audio arithmetic — the freeze is ALES190's proven named-room reverb composed with itself, each pass saturating once as the reverb already does, so an iterated pile-up pins to the rail rather than wrapping. The room is a named word for a tuning, the depth a named count of passes, neither a decibel nor a real decay time in seconds. "Freeze" names iterated reverberation honestly — a longer, denser, held tail — not a literal infinite sustain. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The freeze axis then stands mono. Its thin stereo twin — the same iterated reverberation over both channels of a `StereoClip`, the image held, one shared room and depth — is the round ALES209 takes next, closing the freeze pair before a fresh axis (**width**, wanting its own mid/side primitive) opens.
