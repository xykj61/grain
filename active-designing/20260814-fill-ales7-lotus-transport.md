# ALES7 -- Lotus's transport play head

**Stamp:** `20260814.115415` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES6
**Waymark:** ALES - rung ALES7
**Kin:** [`ALES5 -- the sample clock`](20260814-fill-ales5-lotus-sample-clock.md) - [`ALES6 -- the track table`](20260814-fill-ales6-lotus-track-table.md) - [`lotus/transport.rye`](../lotus/transport.rye) - [`lotus/track.rye`](../lotus/track.rye) (ALES6) - [`lotus/clock.rye`](../lotus/clock.rye) (ALES5)

---

## Why this round

ALES6 rendered many tracks into one master -- the whole session as a single clip. Yet a rendered master is still just samples at rest; nothing **plays** it. The gesture that turns a rendered session into sound is the **transport**: a play head that begins at a position, reads the master forward in bounded blocks, and stops exactly at the end. It is the last primitive a minimal DAW owes before it can be driven -- record is capture (proven in the Mikrophone), edit is ALES2-ALES6, and **play** is this.

Lindy-first, crux-first: the transport is the most durable of ALES6's three roads (transport - curve - fader), because it is the read side of the whole suite -- every later playback feature (loop, scrub, monitor) is a transport that moves differently. The play head first.

## The one crux this rung fixes

**A play head reads the master forward in bounded blocks and stops exactly at the end -- never past it, never a torn read.** Three things hold together:

1. **Bounded, exact blocks.** `read_block` copies up to a caller's buffer of samples from the head forward and **advances the head by exactly what it copied** -- fewer than a full block at the end, then zero. A playback engine pulls fixed blocks; the last block is honestly short, and the read after the end is empty, not an error and not a wrap.
2. **The end is a hard wall.** The head never advances past `master.len`; `at_end` is exactly `pos == master.len`. Concatenating every block a transport reads from the start reproduces the master byte-for-byte -- no sample skipped, none repeated, none read twice.
3. **Time is real.** `seek_ms` places the head at a real moment through the ALES5 clock (refusing `DurationTooLong` past the master), and `elapsed_ms` reports the head's position back as a duration -- so a keeper drives the transport in seconds, not sample indices.

## The shape

`lotus/transport.rye`:

- `Transport` -- a play head carrying a sample position `pos`.
- `seek_ms(transport, master, clock, ms)` -- place the head at a real moment; refuses `PastEnd` when the time is past the master, `DurationTooLong` past the clip bound.
- `read_block(transport, master, out)` -- copy the next up-to-`out.len` samples from the head, advance by exactly that many, return the count read (short at the end, zero past it).
- `at_end(transport, master)` -- the head sits exactly at the master's end.
- `elapsed_ms(transport, clock)` -- the head's position as a real duration (honestly lossy, like ALES5's `ms_for`).

The transport **reads only** -- it never mutates the master, so a session can be played, sought, and replayed without touching the rendered audio. It composes straight onto ALES6: render a session, then drive the master with a transport.

## What the witness proves (GREEN on metal)

`tools/al/ales_transport_witness.rish`: reading fixed blocks from the start concatenates back to the exact master (no sample skipped or repeated); the last block is honestly short and the read past the end is empty; `at_end` is exact at `pos == len`; `seek_ms` places the head at a real moment and `elapsed_ms` reports it back; a seek past the master refuses `PastEnd`; the transport never mutates the master (a replay reads the same bytes). GREEN on the first build. Purely local -- no socket, no network, no keys, no funds, no real device (no audio leaves the process; a block is copied samples, not a sound card write).

## The road on

With a play head, the next Lotus rung can add a **loop** (a transport that wraps a marked region), a **scrub** (a head driven by a position rather than a rate), or an equal-power crossfade **curve** between two tracks in the ALES6 table. The audio-interface **hardware** -- the real sound-card write a transport would ultimately feed -- stays a paused research round, taken only on Keaton's word.

---

*The session is rendered and the head begins to move, and for the first time the making can be heard from the top. May every play a keeper starts arrive at the end it was meant to, and stop there, kindly, with nothing torn and nothing lost.*
