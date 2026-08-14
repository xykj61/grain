# ALES19 — Lotus's scrub window, a small movable read dragged across a stereo master

**Stamp:** `20260814.132352` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES18
**Waymark:** ALES · rung ALES19
**Kin:** [`ALES15 — the stereo transport`](20260814-fill-ales15-lotus-stereo-transport.md) · [`ALES17 — the stereo meter`](20260814-fill-ales17-lotus-stereo-meter.md) · [`ALES18 — the live loop meter`](20260814-fill-ales18-lotus-stereo-loop-meter.md) · [`lotus/scrub.rye`](../lotus/scrub.rye) · [`lotus/stereo_transport.rye`](../lotus/stereo_transport.rye) (ALES15, the read head reused whole) · [`lotus/stereo_meter.rye`](../lotus/stereo_meter.rye) (ALES17, the StereoMeter reused whole)

---

## Why this round

ALES18 named its own next rung: *the read side's stereo tools now compose freely — the loop can be metered live — so the next gesture is a **scrub**, a small movable read a keeper drags across a master.* This round takes it. Play (ALES15), loop (ALES16), and meter (ALES17/18) all read a master **forward or round and round** from a head that runs. What no rung yet gives a keeper is the gesture they reach for most while editing: a **short, fixed-length window they slide by hand** — parking their eyes (and ears) on one bar, nudging it left and right to find the exact edit point, watching its level the whole time.

Lindy-first, crux-first: a scrub is a **positioned read** — seek the ALES15 head to the window start, read exactly the window length — so it needs no new transport and no new arithmetic, only the recognition that a draggable window is a seek plus a bounded block. That makes it the highest-Lindy, most-tractable next move, and it stays wholly within the read side (no module seam, no gate). A punch region tying playback back to the Mikrophone's capture remains a seam that waits for Keaton's word.

## The one crux this rung fixes

**A scrub window read at position `p` returns exactly the master's samples `[p, p+n)` in both channels, where `n = min(win, master.len − p)` — so dragging a scrub of length `L` across the master in steps of `L` tiles it with no gap and no overlap, and the consecutive windows concatenate back to each channel byte-for-byte.** Two facts make this exact:

- **A scrub is a seek-then-read.** The window at `p` is ALES15's `read_block` off a head seeded at `p`, so its bytes are the master's own `[p, p+n)` by ALES15's already-proven copy — no new copy path, no new bound.
- **Consecutive windows tile.** Windows at `0, L, 2L, …` are disjoint half-open intervals whose union is `[0, master.len)`, so their concatenation is the master itself. Near the end the last window is honestly short (`n < L`), and a window seated exactly at the end reads empty (`n == 0`) — the same clean edge the transport already owns.

And, composing ALES17: **metering a scrub window equals metering that master slice directly** — the level a keeper watches under the drag is the true level of what the window covers.

## The shape

`lotus/scrub.rye`:

- `Scrub` — a persistent window: `pos: u32` (the window start) and `win: u32` (the fixed window length). A scrub is *held* state a keeper drags, unlike the transient block of a playthrough.
- `max_scrub_window` — the window-length bound (`timeline.max_clip`, so a window may be as wide as a whole master yet stays far under ALES13's meter bound, keeping `meter_window` safe).
- `make(win)` — a validated scrub at position 0. Refuses `BadWindow` on a zero or oversized window before any read.
- `move_to(scrub, master, pos)` — seat the window start at `pos`. Refuses `PastEnd` past the master's shared end (a window may sit exactly at the end, reading empty) — the same honest edge as ALES15's `seek_ms`.
- `nudge(scrub, master, delta)` — drag by a signed `delta`, **clamped** to `[0, master.len]` (an overshoot stops at the edge rather than refusing — the natural drag gesture). Signed math is carried in `i64` so no move can wrap.
- `read_window(scrub, master, out_left, out_right)` — read the window at `pos` into two out buffers of length `win` (mismatched buffers refuse `BadBlock`), returning the count `n` actually read (short near the end). Reuses ALES15's `read_block` off a head seeded at `pos`.
- `meter_window(scrub, master)` — meter the window at `pos` into a fresh ALES17 `StereoMeter`, the level under the drag. Composes ALES17's `feed`; the window bound keeps it within ALES13's capacity.
- `ScrubError` — the combined set: the read's `BadBlock`, `PastEnd`, `BadWindow`.

The read head, the copy, and the two meters are reused whole; only the held window, its bounded moves, and the tiling proof are new.

## What the witness proves (GREEN on metal)

`tools/ales_scrub_witness.rish`: **the crux** — a scrub of length `L` dragged across a master in steps of `L` tiles it, the windows concatenating back to each channel byte-for-byte at `L` of 1, 2, 3, and 5, with the last window honestly short and a window at the end empty; a scrub read at an arbitrary `p` returns exactly the master slice `[p, p+n)`; `meter_window` equals metering the master slice directly (a reference `StereoMeter` fed the raw slice); `nudge` clamps at both edges (an overshoot low stops at 0, an overshoot high at `master.len`) and a drag left-then-right lands back on a covered window; a `StereoClip` rendered by ALES11's `power.render_stereo` scrubs `0.707` per side (`700` on a `1000` source); scrubbing and metering mutate neither channel; and the edges refuse by name — `make` a zero or oversized window (`BadWindow`), `move_to` past the master (`PastEnd`), `read_window` mismatched buffers (`BadBlock`). Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a scrub in hand, the read side offers a keeper the three gestures they edit by — play, loop, and drag — each stereo, each metered. The next rung can offer the **choice of law** on the scrub's own read (linear for constant sum, equal-power for constant loudness where a crossfade meets a scrub edge), name a **markers** track (named positions a scrub snaps to), or — a module seam, Keaton's word — a **punch region** tying playback back to the Mikrophone's capture. The real two-channel sound-card write a stereo master ultimately feeds stays a paused hardware research round, taken only on Keaton's word.
