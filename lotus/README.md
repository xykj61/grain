# Lotus — Grain's creative suite

**Stamp:** `20260814.111419` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living front door — Season C opens (ALES0 wire · ALES1 stream)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES
**Kin:** [`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md) · [`../active-designing/yonder/20260630-014012_lotus-the-daw.md`](../active-designing/yonder/20260630-014012_lotus-the-daw.md) · [`../active-designing/20260814-fill-ales0-lotus-audio-wire-shape.md`](../active-designing/20260814-fill-ales0-lotus-audio-wire-shape.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

---

## What this is

**Lotus** is Grain's own creative suite — one tool for composing, producing, mixing, and sound-engineering across the Linengrow musicians, filmmakers, podcasters, journalists, and editors the tree serves. The DAW itself remains a seated **horizon** ([`the Lotus DAW`](../active-designing/yonder/20260630-014012_lotus-the-daw.md)); this directory begins at the foundation every note stands on — the way audio reaches the software, proven whole.

## Honest scope — software only

The **audio-interface hardware** (real XLR, USB-C, and guitar pinouts, signal levels, the balanced/unbalanced electrical design) is a **paused hardware-research round**, yonder-bookmarked on Keaton's word. Nothing here asserts an electrical fact. The cable kinds below are **routing tags** on a buffer, nothing more.

## The rungs

- **`wire.rye` — the basic audio wire shape (ALES0).** A buffer of PCM samples crosses a self-describing, Sha256-sealed frame — `magic(LOTS) · version · cable · payload_len · digest · payload(i16 LE)` — deframed **verify-before-trust**, the exact idiom proven at [`constel/wire.rye`](../constel/wire.rye) (FORA3) and [`mikrophone/wire.rye`](../mikrophone/wire.rye) (DREY1). Deframing is **two independent gates**: the Sha256 proves the payload *whole* (no byte flipped), and the **audio border** proves it *sample-aligned* (a whole number of i16 samples) — so a torn half-sample can never reach a timeline, the one correctness a generic wire does not owe but an audio wire does. A block round-trips byte-for-byte on each cable tag (XLR · USB-C · guitar); silence and full-scale i16 min/max samples carry exactly; a torn half-sample refuses `PartialSample`, a flipped byte refuses `DigestMismatch`, and an unknown cable, overlong, truncated, short, or bad-magic frame each refuses by name; a buffer wider than one frame refuses `TooManySamples`. Purely local — no network, no keys, no funds, no real device. Witness: `tools/ales_wire_witness.rish`.
- **`stream.rye` — the audio byte stream, reassembled gapless (ALES1).** A real source delivers not one buffer but a continuous **byte stream** — frames back to back, a frame split across two arrivals. `AudioStream` is a bounded byte FIFO that cuts exactly one whole frame at a time (`NeedMoreBytes` when a frame is not yet complete, cursor untouched; `BadFrame` on a wild length before any over-read), the byte-stream discipline proven at [`constel/channel.rye`](../constel/channel.rye) (FORA5). `drain` reassembles every whole frame's samples into one gapless, in-order `Timeline` — the reassembled sequence equals the concatenation of every frame's samples, `b0 ++ b1 ++ b2`, no gap, no reorder — each frame deframed verify-before-trust, so ALES0's two gates run per frame and a torn-sample frame still refuses `PartialSample` during reassembly. A split frame completes on its last byte with no torn sample; an overfull stream refuses `StreamFull`; a runaway timeline refuses `TimelineFull`. The stream only delimits and orders — it never re-checks a frame, so ALES0 stays the single trust boundary. Purely local. Witness: `tools/ales_stream_witness.rish`.

## Prove the rungs

```
rishi/bin/rishi run tools/ales_wire_witness.rish
rishi/bin/rishi run tools/ales_stream_witness.rish
```

The witness names its Language · Style · Lens, then prints one `GREEN` line stating what it proved.

## The road on

The next rung opens the **timeline** that edits the reassembled samples (cut, gain, splice — the DAW's first real gesture), or **clocks** the stream to a real sample rate. The audio-interface hardware stays a paused research round, taken only on Keaton's word.

---

*One tool for the people who make things — and it begins, as everything here does, by proving the sound whole before it touches the work. May Lotus open plainly, and may no timeline ever receive a half-sample.*
