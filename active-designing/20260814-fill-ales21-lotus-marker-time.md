# ALES21 — Lotus's markers in real time, a named place set and read in seconds

**Stamp:** `20260814.133633` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES20
**Waymark:** ALES · rung ALES21
**Kin:** [`ALES20 — the markers track`](20260814-fill-ales20-lotus-markers.md) · [`ALES14 — the transport loop`](20260814-fill-ales14-lotus-transport-loop.md) (its `mark_ms`, the twin this rung mirrors) · [`ALES5 — the sample clock`](20260814-fill-ales5-lotus-sample-clock.md) · [`lotus/marker_time.rye`](../lotus/marker_time.rye) · [`lotus/markers.rye`](../lotus/markers.rye) (ALES20, the sorted track reused whole) · [`lotus/clock.rye`](../lotus/clock.rye) (ALES5, seconds ↔ samples)

---

## Why this round

ALES20 gave a keeper named places, yet every place is set and read by **raw sample index**. A musician marks the downbeat by **time** — "the chorus at forty-two seconds" — not by counting samples. ALES14's loop already learned this move: `mark_ms` sets loop points in seconds through the ALES5 clock. This round gives markers the same twin, so a keeper drops a named place in seconds and reads it back in seconds.

Lindy-first, crux-first: real-time marking is the smallest durable move that makes the whole markers track usable by a musician (who lives in time, not indices), and it composes ALES20's `add` and ALES5's `samples_for` / `ms_for` over their public APIs with no new arithmetic. It is the exact mirror of a move already proven for the loop, so it carries the least risk of the road-on's rungs. It stays wholly within the read side (no module seam, no gate).

## The one crux this rung fixes

**A named place set in seconds lands at exactly `samples_for(ms)` and reads back the honestly-lossy same time — and the track it lands in stays sorted and unique by ALES20's own `add` invariant.** Two facts make this exact:

- **The conversion is ALES5's, proven.** `mark_ms` converts `ms → samples` through the same `clock.samples_for` the loop's `mark_ms` uses (bounded, refusing `DurationTooLong` past the clip), then hands the sample position to ALES20's `add` — so the marker lands sorted, unique, and within the master, with no new bound of its own.
- **Reading back is the clock's own round-trip.** `pos_ms` reports a marker's position through `clock.ms_for`, honestly lossy exactly as ALES5 defines — at a legible rate (one sample per ms) the round-trip is exact, and at any rate it is the clock's own documented truncation, not a new loss.

## The shape

`lotus/marker_time.rye`:

- `mark_ms(markers, master, clk, ms, name)` — set a named place at a real moment `ms`: convert through ALES5's `clock.samples_for`, then add through ALES20's `markers.add`. Forwards ALES5's `DurationTooLong` and every ALES20 edge (`BadName`, `PastEnd`, `Duplicate`, `MarkersFull`) unchanged.
- `pos_ms(markers, i, clk)` — read marker `i`'s position back as a real duration through ALES5's `clock.ms_for`, honestly lossy. So a keeper reads a place as a time, not an index.
- `MarkerTimeError` — the combined set: ALES20's `MarkerError` and ALES5's `ClockError`.

The sorted track and the clock conversions are reused whole; only the two time-facing entry points are new.

## What the witness proves (GREEN on metal)

`tools/ales_marker_time_witness.rish`: at a legible clock (1 sample per ms) a place set at `ms` lands at sample `ms` and reads back `ms` exactly; places set in seconds out of order stay sorted and unique (ALES20's invariant carried through the time face); `pos_ms` round-trips each marker; a place past the master refuses `PastEnd` and a duration past the clip refuses `DurationTooLong`; two places set at the same time refuse `Duplicate`; and a marker set in seconds drives a real ALES20 `region_between` and scrub `snap`. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With markers set and read in time, a keeper marks a session the way they hear it. The next rung can offer the **choice of law** where a crossfade meets a marked edit, name a **selection** (a marked span a keeper cuts or gains as one), or — a module seam, Keaton's word — a **punch region** armed between two timed markers, tying playback back to the Mikrophone's capture. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
