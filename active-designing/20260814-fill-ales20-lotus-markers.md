# ALES20 — Lotus's markers track, named positions a keeper navigates and snaps to

**Stamp:** `20260814.133106` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES19
**Waymark:** ALES · rung ALES20
**Kin:** [`ALES19 — the scrub window`](20260814-fill-ales19-lotus-scrub.md) · [`ALES14 — the transport loop`](20260814-fill-ales14-lotus-transport-loop.md) · [`lotus/markers.rye`](../lotus/markers.rye) · [`lotus/scrub.rye`](../lotus/scrub.rye) (ALES19, the scrub snapped) · [`lotus/loop.rye`](../lotus/loop.rye) (ALES14, the region between two markers)

---

## Why this round

ALES19 gave the read side its third gesture — a scrub a keeper drags across a master — and named its own next want: *a **markers** track, named positions a scrub snaps to.* This round takes it. Play, loop, meter, and scrub all read a master by **raw sample index**, yet a keeper thinks in **named places** — the verse, the chorus, the edit point, the downbeat. A markers track is the one primitive that turns a number into a name, and every gesture already built reads better through it: a scrub **snaps** to the nearest named place, a loop is the **region between two markers**, a transport **jumps** to a marker by name.

Lindy-first, crux-first: markers are read on every editing session for years, and the crux — keeping named positions **sorted and unique** so the nearest-marker query is exact — is small and wholly tractable, composing ALES19's `move_to` and ALES14's `make` over their public APIs. It stays entirely within the read side (no module seam, no gate). A punch region tying playback back to the Mikrophone's capture remains a seam that waits for Keaton's word.

## The one crux this rung fixes

**A markers track keeps its named positions sorted and unique, so the nearest-marker query returns the true nearest named place in one ordered pass — and a scrub snapped to it lands exactly there.** Two facts make this exact:

- **Insertion keeps the invariant.** Every `add` refuses a duplicate position and inserts in sorted order, so the track is always a strictly-ascending run of positions. The order is a maintained invariant, not a re-sort per query.
- **Sorted means the nearest is unambiguous.** Over an ascending run, the marker of least distance to a query position is well-defined, and ties resolve to the **lower** position (the first encountered in order) — so `snap` is deterministic, never flapping between two equidistant marks.

And composing ALES14: **the region between marker `i` and marker `j` (`i < j`) is exactly the loop `[pos_i, pos_j)`** — a keeper marks two places and loops between them, the region validated by ALES14's own edge.

## The shape

`lotus/markers.rye`:

- `Marker` — a named position: `pos: u32` and a bounded name (`[max_name]u8` with a length), so a place carries a word (`verse`, `chorus`) rather than a raw index.
- `Markers` — a bounded, sorted set: `items: [max_markers]Marker` and a `count`. A fresh track is empty.
- `max_markers`, `max_name` — the two bounds, named at construction and enforced at the edge.
- `add(markers, master, pos, name)` — insert a named position, kept sorted ascending. Refuses `BadName` (empty or oversized name), `PastEnd` (past the master's shared end — a marker at the end is a valid boundary), `Duplicate` (a marker already at `pos`), `MarkersFull` (past the bound), each before any insert.
- `nearest(markers, pos)` — the index of the marker nearest `pos`, ties to the lower position. Refuses `NoMarkers` on an empty track.
- `pos_of` / `name_of` — read a marker's position and name by index.
- `snap(scrub, markers, master)` — move a scrub to the nearest marker to its current position, composing ALES19's `move_to`. Returns the marker index landed on.
- `region_between(markers, i, j, master)` — the ALES14 loop `[pos_i, pos_j)`, composing `loop.make`. Refuses `BadPair` when `i` and `j` are not an ascending pair of valid indices.
- `MarkerError` — the combined set: `BadName`, `PastEnd`, `Duplicate`, `MarkersFull`, `NoMarkers`, `BadPair`, plus ALES19's `ScrubError` for the snap.

The scrub move and the loop region are reused whole; only the sorted named set and its nearest query are new.

## What the witness proves (GREEN on metal)

`tools/ales_markers_witness.rish`: **the crux** — markers added out of order stay sorted and unique, `nearest` returns the true nearest at several query points with ties resolving to the lower position, and a scrub `snap`ped to a track lands exactly on the nearest marker's position; a marker carries its name back byte-for-byte; `region_between` yields exactly the loop `[pos_i, pos_j)` and drives a real ALES14 loop; and the edges refuse by name — a duplicate position (`Duplicate`), a position past the master (`PastEnd`), an empty or oversized name (`BadName`), a track filled past the bound (`MarkersFull`), a nearest query on an empty track (`NoMarkers`), a non-ascending index pair (`BadPair`). Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With markers, a keeper reads the master by name — snap a scrub, loop between two marks, jump the transport. The next rung can carry markers into **real time** (mark a place in seconds through the ALES5 clock, the twin of `loop.mark_ms`), offer the keeper the **choice of law** where a crossfade meets a marked edit, or — a module seam, Keaton's word — a **punch region** armed between two markers, tying playback back to the Mikrophone's capture. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
