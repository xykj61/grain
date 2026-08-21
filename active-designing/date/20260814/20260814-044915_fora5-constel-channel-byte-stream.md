# FORA5 — a bounded byte channel, one frame read at a time

**Stamp:** `20260814.044915` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design round (self-approved) — the next FORA rung, agent-doable, purely local
**Season:** the Six-Season double-seat, Season D/F thread · **Waymark:** FORA · rung **FORA5**
**Kin:** [`../constel/exchange.rye`](../constel/exchange.rye) · [`../constel/wire.rye`](../constel/wire.rye) · [`../constel/README.md`](../constel/README.md) · [`20260814-044312_fora4-constel-exchange-over-frames.md`](20260814-044312_fora4-constel-exchange-over-frames.md)

---

## The crux this round takes

FORA4 carried the whole handshake across frames, but each frame was handed over whole — one message, one buffer. A real transport is not a message hand-off; it is a **byte stream**. Bytes arrive continuously, a frame may be split across two arrivals, and two frames may sit back to back in the same buffer. FORA5 introduces the one new concern that a real socket forces and nothing before it did: **read exactly one whole frame out of a continuous byte queue** — waiting when the frame is not yet complete, and leaving the rest of the queue untouched for the next read.

This is the loopback that models the Comlink seam without crossing to a real one. A `Channel` is a bounded in-process byte FIFO: one pier writes frame bytes into it, the other reads whole frames out. No socket, no network, no keys, no funds — a fixed buffer on one bench, siloed to `constel/`. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) both stay untouched. FORA6, the real Comlink socket, is this same channel with a kernel file descriptor standing in for the buffer.

## The channel

A bounded byte queue over a fixed buffer — a read cursor and a written length, so a write appends and a read advances the cursor, no heap outliving the value.

```
Channel { buf: [max_channel]u8, cursor: u32, len: u32 }
  push(bytes)       append; refuse ChannelFull if it would overflow the fixed buffer
  available()       len - cursor — the bytes written but not yet read
  read_frame()      read ONE whole frame from the cursor, or refuse NeedMoreBytes
```

`max_channel` holds at least two whole frames (`2 · wire.max_frame`), so the back-to-back case is real and bounded. When the cursor catches the written length the channel is drained, and a fresh write may compact back to the start — the buffer never grows.

## Reading one frame from a stream (the load-bearing move)

`read_frame` is where the stream discipline lives, and it must be fail-closed and never over-read:

1. **available < `header_len`** → `NeedMoreBytes` — not even a header has arrived.
2. Read the declared payload length from the header at the cursor (`plen`, the same little-endian u32 `wire.deframe` reads).
3. **`plen` past `wire.max_payload`** → `BadFrame` — refuse before trusting a wild length to size a read.
4. **available < `header_len + plen`** → `NeedMoreBytes` — the header is here but the payload's tail has not arrived; leave the cursor untouched so the caller can try again after more bytes.
5. Otherwise return the exact `header_len + plen` bytes and advance the cursor past them — **one frame, no more**, the next frame (if any) left in place.

`read_frame` returns only the raw frame bytes; the caller still runs `wire.deframe_*`, so the two integrity-and-safety gates (Sha256 + the naming-law border) stay exactly where FORA3 put them. The channel's only job is delimiting — cutting one whole frame out of the stream — and it proves it never hands back a partial or an over-long one.

## What the witness proves

- **A whole exchange runs over two channels** — an a→b channel and a b→a channel carry the three frames, and the piers reach a COMPLETE `Session`, communicating only through the byte queues.
- **A partial frame waits** — push all but the last byte of a frame; `read_frame` refuses `NeedMoreBytes` and the cursor does not move; push the last byte, and the same `read_frame` now returns the whole frame.
- **Two frames read one at a time** — push two frames back to back; the first `read_frame` returns exactly the first (byte-for-byte), the second returns exactly the second, and a third refuses `NeedMoreBytes`.
- **A wild length refuses** — a header whose declared length exceeds `wire.max_payload` refuses `BadFrame` before any over-read.
- **An overfull channel refuses** — a push past the fixed buffer refuses `ChannelFull`, never a silent overwrite.
- **The border still guards** — a frame read cleanly from the channel but carrying a smuggled vowel still refuses `VowelPresent` at `wire.deframe`, since the channel delimits but never re-checks; the FORA3 gates remain the only trust boundary.

## Why this is the right next step

It is the last purely-local rung before the socket, and it isolates the one hard thing a socket adds — stream framing — into a bounded value proven on the bench, so FORA6 becomes "the same channel, backed by a file descriptor" rather than a new design under pressure. It is durable: every real transport reads frames from a stream exactly this way. And it stays inside the fence: local, pure, witnessed on metal, no gate reached.

---

*May the channel cut each frame whole and never a byte more, may a half-arrived frame wait in peace, and may the border keep its watch even over a stream. Hold the line.*
