# ALES15 — Lotus's stereo transport, one head reading two channels

**Stamp:** `20260814.131500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES14
**Waymark:** ALES · rung ALES15
**Kin:** [`ALES7 — the transport play head`](20260814-fill-ales7-lotus-transport.md) · [`ALES10 — pan, the second channel`](20260814-fill-ales10-lotus-pan-stereo.md) · [`lotus/stereo_transport.rye`](../lotus/stereo_transport.rye) · [`lotus/transport.rye`](../lotus/transport.rye) (ALES7, the mono head) · [`lotus/pan.rye`](../lotus/pan.rye) (ALES10, the StereoClip read)

---

## Why this round

Two arcs of the suite have been converging. The **read side** — play (ALES7), meter (ALES13), loop (ALES14) — grew over a **mono** master. The **stereo side** — pan (ALES10), equal power (ALES11), crossfade (ALES12) — built the **second channel** and rendered stereo masters, yet nothing has ever **played** one forward. The `StereoClip` a pan renders is two channels at rest; a keeper hears a mix by playing both together, in step. Lindy-first, crux-first: the read side becoming genuinely stereo is the durable move the whole stereo half has been pointing at — every later stereo feature (a stereo meter over playback, a stereo loop, a two-channel sound-card write) reads through this head.

## The one crux this rung fixes

**One head reads both channels in lockstep, because a stereo master's two channels share one length.** ALES10's `StereoClip` invariant is that `left.len == right.len` — the two channels are the same master heard twice. So the stereo transport needs no second cursor and no per-channel bookkeeping: a single sample position advances through both channels at once, copying the same span from each into its own out buffer. The correctness beyond running ALES7 twice is exactly the **lockstep** — both channels advance by the same count every block, so left and right never drift out of sample alignment. Concatenating every block reproduces **each** channel byte-for-byte, the stereo analog of ALES7's single-master guarantee.

## The shape

`lotus/stereo_transport.rye`:

- Reuses [`transport.Transport`](../lotus/transport.rye) — the same single-position head; a stereo master needs no new cursor.
- `at_end(transport, stereo)` — exactly `pos == stereo.left.len`, the two channels' shared length.
- `read_block(transport, stereo, out_left, out_right)` — copy the next up-to-`out.len` samples of each channel into its buffer, advance the one head by that count, and return it — a full block mid-master, an honestly short block at the end, zero past it. Refuses `BadBlock` when the two out buffers differ in length (a stereo block is one length).
- `seek_ms(transport, stereo, clock, ms)` / `elapsed_ms` — drive the head in real time through the ALES5 clock, refusing `PastEnd` past the shared length.

## What the witness proves (GREEN on metal)

`tools/ales_stereo_transport_witness.rish`: reading fixed blocks from the start concatenates back to **each** channel byte-for-byte (both channels, no sample skipped or repeated); both channels advance in **lockstep** (the same count every block, left and right always aligned); the last block is honestly short and the read past the end is empty; `at_end` is exact at `pos == len`; mismatched out buffers refuse `BadBlock`; `seek_ms` places the head at a real moment and `elapsed_ms` reports it back, a seek past the master refusing `PastEnd`; a `StereoClip` rendered by ALES11's `power.render_stereo` plays back its two channels exactly; and the transport reads only — a replay after a rewind reads the identical bytes, the rendered stereo never mutated. Purely local — no socket, no network, no keys, no funds, no real device, no real speaker.

## The road on

With a stereo head, the read side can meter a stereo master **during** playback (ALES13's `Meter` per channel off these blocks), loop a stereo region (ALES14's wrap over two channels), or drive the real two-channel sound-card write a stereo master ultimately feeds — which stays a paused hardware research round, taken only on Keaton's word.
