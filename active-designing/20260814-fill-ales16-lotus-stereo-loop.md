# ALES16 -- Lotus's stereo loop, one region cycled through two channels

**Stamp:** `20260814.130009` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES15
**Waymark:** ALES - rung ALES16
**Kin:** [`ALES14 -- the transport loop`](20260814-fill-ales14-lotus-transport-loop.md) - [`ALES15 -- the stereo transport`](20260814-fill-ales15-lotus-stereo-transport.md) - [`lotus/stereo_loop.rye`](../lotus/stereo_loop.rye) - [`lotus/loop.rye`](../lotus/loop.rye) (ALES14, the mono loop reused whole) - [`lotus/stereo_transport.rye`](../lotus/stereo_transport.rye) (ALES15, the stereo head)

---

## Why this round

ALES15 made the read side genuinely stereo -- one head reading two channels of a master in lockstep. Yet that head still only reads **forward and stops**, the plain playback of ALES7 carried to two channels. The read a musician reaches for second is the same one ALES14 opened for mono: **loop** -- mark a region and hear it round and round. The stereo side now renders masters (pan, equal power, crossfade) and the read side now plays them (ALES15); the practice loop over a stereo bar is the next durable rung, and every later stereo read -- a scrub window, a punch region tied back to capture -- reads through a head that can cycle. Lindy-first, crux-first: bringing the loop to stereo completes the read side's second tool over two channels, the twin of the move ALES15 already proved for play.

## The one crux this rung fixes

**One region and one head cycle both channels in lockstep, because a stereo master's two channels share one length.** ALES10's `StereoClip` invariant is `left.len == right.len`, so a loop needs no second region and no second cursor: a single marked region `[start, end)` and a single wrapping head advance through both channels at once, copying the same span from each into its own out buffer and wrapping both the instant the one head reaches `end`. The correctness beyond running ALES14 twice is exactly the **lockstep across the seam** -- both channels wrap on the same sample every cycle, so left and right never drift out of alignment even as the region repeats forever. Reading K cycles concatenates to **each** channel's region repeated K times, no seam sample skipped or doubled in either channel.

## The shape

`lotus/stereo_loop.rye`:

- Reuses [`loop.Loop`](../lotus/loop.rye) whole -- the region `[start, end)` and the armed flag; a stereo master shares one length, so one region governs both channels. `make`, `mark_ms`, and `enter` are ALES14's, called against the shared length (`stereo.left.len`).
- Reuses [`transport.Transport`](../lotus/transport.rye) -- the same single-position head ALES15 reads with; no new cursor.
- `read_block(transport, stereo, loop, out_left, out_right)` -- when the loop is **off**, delegates to ALES15's `stereo_transport.read_block` whole (a short block at the end, zero past it); when **on**, copies the next `out.len` samples of each channel, wrapping the one head at the region end, so the block is always full and the head is left within `[start, end)`. Refuses `BadBlock` when the two out buffers differ in length (a stereo block is one length).

## What the witness proves (GREEN on metal)

`tools/al/ales_stereo_loop_witness.rish`: a loop **off** reads identically to ALES15's stereo forward read (both channels concatenate byte-for-byte, short last block, empty past the end); a region `[1,4)` cycles **both** channels in lockstep, K cycles concatenating to each channel's region repeated K times with no seam sample skipped or doubled; the head stays within `[start,end)` after every read at any block size; a loop over the whole master cycles both channels continuously; a single-sample region repeats that one sample in each channel; mismatched out buffers refuse `BadBlock`; `mark_ms` places the region at real times through the ALES5 clock; a `StereoClip` rendered by ALES11's `power.render_stereo` loops back its two channels exactly (a center pan's `0.707` per side); and the loop reads only -- both channels are byte-for-byte unchanged after many cycles. Purely local -- no socket, no network, no keys, no funds, no real device, no real speaker.

## The road on

With play and loop both stereo, the read side can meter a stereo master **during** playback (ALES13's `Meter` per channel off these blocks), name a **scrub** window (a small movable read a keeper drags across either a mono or stereo master), a **punch region** (record armed only within marked points, tying playback back to the Mikrophone's capture), or drive the real two-channel sound-card write a stereo master ultimately feeds -- which stays a paused hardware research round, taken only on Keaton's word.
