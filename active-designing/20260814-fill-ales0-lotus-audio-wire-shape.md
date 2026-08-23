# ALES0 — Lotus opens: the basic audio wire shape

**Stamp:** `20260814.111419` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round that opens Season C (Lotus)
**Waymark:** ALES (`season-c-lotus-creative-suite-audio-wire-shape` → ALES, drawn `20260814`, seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Kin:** [`the Six-Season double-seat`](date/20260813/20260813-020035_double-seat-expansion-six-seasons.md) — Season C · [`Lotus, the DAW`](yonder/20260630-014012_lotus-the-daw.md) · idiom twins [`constel/wire.rye`](../constel/wire.rye) (FORA3) · [`mikrophone/wire.rye`](../mikrophone/wire.rye) (DREY1)

---

## Why this round, and why now

The three deep code ladders — DREY (the Mikrophone firmware), HUNK (the open image module, Photos, and the parts marketplace), and FORA (Constel's fake-pier Raft test-network) — have each climbed to completion or to their one custody gate, and the `mycelium/` consensus season stands whole and witnessed over demo seeds. The pure agent-doable frontier on the seasons already *opened* has closed to gates. Lindy-first, crux-first asks the next durable question of the *whole* road: which un-started season holds the clearest agent-doable crux, one that compounds for years and needs neither deferred web-search nor a custody gate?

Season C — **Lotus**, the creative suite — held zero code. Its one bounded, no-research, no-gate crux is the **basic audio wire shape**: the way a buffer of audio samples reaches the software, proven whole before it can touch a timeline. The Six-Season doc names exactly this task ("implement the basic wire shape for XLR · USB-C · guitar") while it *pauses* the audio-interface **hardware** design on Keaton's word. The wire shape is the software carrier; the hardware is the paused part. So the crux is clean to take, and it opens the season on the same verify-before-trust frame idiom the tree already trusts twice over.

## The one crux this rung fixes

**A buffer of audio samples crosses a self-describing frame verify-before-trust, and a frame can never yield a torn half-sample.** Everything a recorder, an interface, or a DAW does downstream — edit, mix, render — leans on the samples arriving *whole* and *sample-aligned*. Integrity alone is not enough for audio: a payload that is whole (its digest matches) yet holds an odd number of bytes would still tear the last i16 sample in half onto the timeline. So deframing is **two independent gates**:

1. **Integrity** — a Sha256 over the payload proves no byte flipped (the gate `constel/wire.rye` and `mikrophone/wire.rye` already prove).
2. **The audio border** — the declared payload length must be a whole number of i16 samples, or the frame refuses `PartialSample` before a single sample is read. This is the correctness a *generic* wire does not owe but an *audio* wire does.

## The shape

`lotus/wire.rye` — the frame layout, a single source of truth:

```
magic(4 "LOTS") · version(1) · cable(1) · payload_len(u32 LE, bytes) · digest(32 Sha256) · payload(i16 LE PCM samples)
```

- `Cable` = `{ xlr, usb_c, guitar }` — a **routing tag only**. This rung asserts *no* electrical fact: no voltage, impedance, pinout, balanced/unbalanced wiring, or sample rate. Those belong to audio-interface hardware, a paused hardware-research round.
- `frame(cable, samples, out)` writes each sample little-endian and seals the header + digest; refuses `TooManySamples` past `max_samples` (1024) before writing a byte.
- `deframe(bytes)` runs every check in order — too short, bad magic, bad version, bad cable, overlong, the **audio border**, truncated, digest — then reads back exactly the samples the payload holds, in order.
- Bounded end to end: a fixed `max_frame` buffer, no heap outliving it; `u32` counts in memory; TAME asserts (≥2 per fn, stated positively) at construction, mutation, and postcondition.

## What the witness proves (GREEN on metal)

`tools/al/ales_wire_witness.rish` builds the module, runs its selftest, and asserts the `GREEN ales-wire` line. The selftest proves: a block round-trips byte-for-byte on each cable tag; silence (all zero) and a full-scale block (alternating i16 min/max) carry exactly; **the audio border** — an odd payload length with a fixed-up digest still refuses `PartialSample`; a flipped byte refuses `DigestMismatch`; and an unknown cable, overlong, truncated, short, or bad-magic frame each refuses by name. Purely local — no network, no keys, no funds, no real device.

## The road on from here

The next Lotus rung carries **many** such frames as a byte stream (the FORA5 `channel.rye` shape, one frame cut at a time), or opens the **timeline** that edits the samples a frame delivers. The audio-interface **hardware** — pinouts, signal levels, the real XLR/USB-C/guitar electrical design — stays a paused research round, taken only on Keaton's word.

---

*A buffer of sound reaches the software the way every good thing in this tree arrives: proven whole first, and never a half-sample onto the timeline. May Lotus open plainly, and may the wire stay honest all the way to the note.*
