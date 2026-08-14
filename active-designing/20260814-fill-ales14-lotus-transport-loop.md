# ALES14 — Lotus's transport loop, a marked region read round and round

**Stamp:** `20260814.130000` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES13
**Waymark:** ALES · rung ALES14
**Kin:** [`ALES7 — the transport play head`](20260814-fill-ales7-lotus-transport.md) · [`ALES5 — the sample clock`](20260814-fill-ales5-lotus-sample-clock.md) · [`lotus/loop.rye`](../lotus/loop.rye) · [`lotus/transport.rye`](../lotus/transport.rye) (ALES7, the head extended) · [`lotus/clock.rye`](../lotus/clock.rye) (ALES5, the region marked in real time)

---

## Why this round

ALES7 opened the read side of the suite: a play head that reads a master forward, block by block, and stops **exactly at the end** — the end a hard wall. That is the whole of ordinary playback. Yet the read side a musician reaches for second, after "play," is **loop** — mark a region and hear it round and round: the practice loop over a hard bar, the comping cycle a take is punched into, the groove held while a part is dialed in. Lindy-first, crux-first: the playback spine is read on every session for years, and the loop is its next decisive move — the first read that does not end.

## The one crux this rung fixes

**A loop is a play head that wraps at a marked end instead of stopping.** ALES7's head only ever moved forward and halted at `master.len`; a loop keeps a **region** `[start, end)` and, whenever the head reaches `end`, wraps it back to `start` — so a continuous read cycles the region forever, and the block a playback engine pulls is **always full** (a non-empty region never runs dry). The correctness beyond a bare wrap is that the head stays **within the region** after every read (`start ≤ pos < end`, asserted), so the cycle is exact: reading any number of cycles concatenates to the region repeated that many times, no sample skipped at the seam and none doubled. A loop turned **off** is ALES7's forward read exactly, delegated whole — the loop generalizes the transport rather than replacing it.

## The shape

`lotus/loop.rye`:

- `Loop { start, end, on }` — a marked region `[start, end)` and whether the loop is armed. Default off and empty, so a fresh loop is plain forward playback.
- `make(start, end, master_len)` — a validated region, refusing `BadLoop` when `start ≥ end` (empty or inverted) or `end > master_len` (past the master). The one place a region's legality is proven.
- `mark_ms(clock, start_ms, end_ms, master)` — mark the region in **real time** through the ALES5 clock, forwarding its `DurationTooLong`, so a keeper sets loop points in seconds.
- `enter(transport, loop)` — place the head at the region start, arming the cycle.
- `read_block(transport, master, loop, out)` — the looping read: forward when the loop is off (delegating to ALES7), else copy forward and wrap at `end`, always filling the block, the head left within the region.

## What the witness proves (GREEN on metal)

`tools/ales_loop_witness.rish`: a loop turned off reads identically to ALES7's forward `read_block` (the last block honestly short, the read past the end empty); a region `[1, 4)` of a five-sample master cycles `20, 30, 40, 20, 30, 40, …` exactly, and reading K cycles concatenates to the region repeated K times (no sample skipped at the seam, none doubled); the head stays within `[start, end)` after every read; a loop over the whole master `[0, len)` cycles the full master (continuous replay); a single-sample region repeats that one sample; `make` refuses `BadLoop` on an empty, inverted, or past-the-master region; `mark_ms` places the region at real times through the clock; and the loop reads only — the master is never mutated. Purely local — no socket, no network, no keys, no funds, no real device.

## The road on

With play (ALES7), meter (ALES13), and loop (ALES14) in hand, the read side can name a **stereo transport** (reading a two-channel master), a **scrub** (a small movable window a keeper drags), or a **punch region** (record armed only within marked points, tying the read side back to the Mikrophone's capture). The real two-channel sound-card write the transport would ultimately drive stays a paused hardware research round, taken only on Keaton's word.
