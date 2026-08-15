# Fill ALES206 — Lotus's reverb early/late balance (the first reflections against the diffuse wash)

**Stamp:** `20260815.113645` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES206**
**Kin:** [`20260815-112822_fill-ales205-lotus-stereo-reverb-shelf.md`](20260815-112822_fill-ales205-lotus-stereo-reverb-shelf.md) · [`20260815-100815_fill-ales192-lotus-reverb-wet-dry-mix.md`](20260815-100815_fill-ales192-lotus-reverb-wet-dry-mix.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES205 closed the tone axis whole — mono and stereo, plain darkness and full two-band shelf. The tone axis rests; the reverb now opens a **fresh axis** ALES205 itself named next: **early/late balance**, the ratio of a room's first reflections to its diffuse wash. This is the control that places a source in a space more honestly than any tone or level knob — the *early reflections* are the few discrete echoes off the near walls that tell the ear how big and how close the room is, and the *late reverberation* is the dense diffuse tail that tells it how live the room is. A reverb that carries only the diffuse wash sounds distant and washed; carrying both, balanced, is how a plate sits bright and immediate while a hall breathes around it.

Lotus already holds both halves, each proven byte for byte. The **early reflections** are exactly what ALES68's multi-tap delay was built to voice — its own banner names them "the discrete early-reflection pattern (a snare hitting three walls at three distances)." The **late wash** is ALES190's named-room reverb preset. So this rung invents no new audio arithmetic: it is a clean **crossfade** between the discrete early reflections and the diffuse late wash, at the same linear balance ALES192 already proved for wet/dry, now dialing early ↔ late.

## The shape — the early reflections against the late wash, one balance knob

`reverb_early_late(clip, clk, room, start_ms, count_ms, balance_num, balance_den)`:

1. Assert the clock; refuse a bad balance fraction (`BadBalance` — a zero denominator or a numerator past it) before any write.
2. Compute the **EARLY** signal on a full **copy** of the original clip: ALES69's `multitap_ms` over the room's fixed early-reflection tap bank (published constants, named in milliseconds). The copy absorbs every fault the multi-tap could raise, so the real clip stays untouched on refusal.
3. Compute the **LATE** signal in place on the real clip: ALES190's `reverb_preset` UNCHANGED — the room's diffuse wash. It prechecks before any write, so a fault here leaves the clip dry.
4. **Blend** early against late over the span, one linear weighted average per sample, saturated once:
   `out[i] = saturate((balance_den − balance_num)·early[i]/balance_den + balance_num·late[i]/balance_den)`.

The early bank and the late preset are the SAME named room, so one word (`hall` · `room` · `plate`) chooses both a room's reflections and its wash; they can never name two different rooms.

## The provable laws the witness proves

1. **THE EARLY EDGE (`balance == 0`)** — equals ALES69's `multitap_ms` over the room's published early bank, byte for byte. Fully toward early is exactly the discrete first reflections.
2. **THE LATE EDGE (`balance == den`)** — equals ALES190's `reverb_preset` over the span, byte for byte. Fully toward late is exactly the diffuse preset.
3. **THE BLEND IS BETWEEN** — a half balance differs from both edges, and each sample is the honest weighted average of the early and the late, byte for byte: `out[i] == saturate(early[i]/2 + late[i]/2)`.
4. **THE ROOMS DIFFER** — the early edge for `room`, `hall`, and `plate` produce genuinely different reflections — the named early banks are real, not three names for one bank.
5. **SILENCE STAYS SILENCE** — an all-zero clip at any balance stays silence; both halves add nothing to nothing.
6. **THE FAULTS FORWARD, ATOMIC** — a bad balance fraction `BadBalance`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with the clip untouched (the early multi-tap runs on the copy, the late preset prechecks, so no refusal ever half-writes the clip).

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `Clip`, a validated clock, ALES190's fixed reverb banks and this rung's fixed early-tap banks, and one bounded full-clip copy for the early signal (the width the reverb itself already carries per comb), siloed to `lotus/`. The one arithmetic is the linear blend — a weighted average of two i16 spans summed in i64 and saturated once, so it can never wrap — the exact blend ALES192 proved, now between early and late rather than dry and wet. The early banks are named in **milliseconds**, so one room sounds the same at any sample rate; at a clock so slow an early tap converts to under a sample, the multi-tap refuses `BadDelay` honestly rather than doing nothing. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The **stereo** early/late balance — the same crossfade over both channels of a `StereoClip`, one shared early bank, room, and balance, the image held — is the thin twin (ALES207). Then the early/late axis stands whole, mono and stereo, and a fresh reverb axis opens: **width** (the stereo spread of the tail) or **freeze** (an infinite-hold sustain).
