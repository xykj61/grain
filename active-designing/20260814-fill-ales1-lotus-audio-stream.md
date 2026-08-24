# ALES1 -- Lotus's audio byte stream, reassembled gapless

**Stamp:** `20260814.112048` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES0
**Waymark:** ALES - rung ALES1
**Kin:** [`ALES0 -- the basic audio wire shape`](20260814-fill-ales0-lotus-audio-wire-shape.md) - [`lotus/stream.rye`](../lotus/stream.rye) - byte-stream idiom twin [`constel/channel.rye`](../constel/channel.rye) (FORA5)

---

## Why this round

ALES0 framed **one** buffer of samples, proven whole and sample-aligned. A real recorder or audio interface does not hand over one buffer -- it delivers a continuous **byte stream**: frames arrive back to back, a frame may be split across two arrivals, and the samples of many frames must reassemble into **one** continuous timeline in order. That is the one concern a live source forces and a single frame does not, and it is exactly the leap `constel/channel.rye` (FORA5) proved for the handshake. ALES1 takes the same leap for audio.

## The one crux this rung fixes

**Many frames off a byte stream reassemble into one gapless, in-order sample timeline, and a frame boundary never tears a sample.** Two properties compose:

1. **Delimiting** -- cut exactly one whole frame out of the stream, waiting (`NeedMoreBytes`) without moving the cursor when a frame is not yet complete, refusing a wild declared length (`BadFrame`) before any over-read. The same discipline FORA5 proved, on the shared LOTS header (payload length at offset 6).
2. **Ordered reassembly** -- drain every whole frame and lay its samples end to end into one timeline, in arrival order, so the reassembled sequence equals the concatenation of every frame's samples: `b0 ++ b1 ++ b2`, no gap, no reorder. Each frame is deframed **verify-before-trust**, so ALES0's two gates (the Sha256 and the audio border) run per frame -- a torn-sample frame read cleanly by the delimiter still refuses `PartialSample` during reassembly.

The stream only delimits and orders; it never re-checks a frame's integrity, so ALES0 stays the single trust boundary.

## The shape

`lotus/stream.rye`:

- `AudioStream` -- a bounded byte FIFO (`max_stream = 2 x wire.max_frame`) with `push` (refusing `StreamFull`), `available`, and `read_frame` (one whole frame or `NeedMoreBytes`/`BadFrame`, cursor untouched on refusal); a drained stream compacts to the start on the next write.
- `Timeline` -- a bounded ordered reassembly (`max_timeline = 4 x wire.max_samples`): the samples of every drained frame, concatenated, plus the frame count.
- `drain(stream, timeline)` -- reads every whole frame available, deframes each verify-before-trust, appends its samples in order, and returns cleanly at `NeedMoreBytes` (the end of what has arrived), leaving a partial trailing frame in place; refuses `TimelineFull` rather than overrun, and propagates a real frame fault (`BadFrame`, `PartialSample`, `DigestMismatch`) with every whole frame before it already reassembled.
- Bounded, TAME-clean: fixed buffers, `u32` counts, `i16` samples, copy loops (never a bare memcpy), >=2 asserts per function.

## What the witness proves (GREEN on metal)

`tools/al/ales_stream_witness.rish`: three frames back to back reassemble into `b0 ++ b1 ++ b2` sample-for-sample and in order; a frame split across two arrivals refuses `NeedMoreBytes` without moving the cursor and completes on its last byte with no torn sample; a wild length refuses `BadFrame`; an overfull stream refuses `StreamFull`; and a torn-sample frame read cleanly by the delimiter still refuses `PartialSample` at the audio border during reassembly. GREEN on the first build. Purely local -- no socket, no network, no keys, no funds, no real device.

## The road on

The next Lotus rung can open the **timeline** that edits these reassembled samples (cut, gain, splice -- the DAW's first real gesture), or **clock** the stream to a real sample rate. The audio-interface **hardware** stays a paused research round, taken only on Keaton's word.

---

*A stream of sound arrives the way a river does -- many parts, one flow -- and Lotus keeps it whole from the first byte to the last sample. May the timeline stay gapless, and may no frame ever tear a note in two.*
