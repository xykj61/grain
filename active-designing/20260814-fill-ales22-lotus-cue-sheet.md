# ALES22 — Lotus's cue sheet, the marker track travels as text

**Stamp:** `20260814.134526` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES21
**Waymark:** ALES · rung ALES22
**Kin:** [`ALES20 — the markers track`](20260814-fill-ales20-lotus-markers.md) · [`ALES21 — markers in real time`](20260814-fill-ales21-lotus-marker-time.md) · [`lotus/cue_sheet.rye`](../lotus/cue_sheet.rye) · [`lotus/markers.rye`](../lotus/markers.rye) (ALES20, the sorted track and its one `add` reused whole) · [`image/filter_preset.rye`](../image/filter_preset.rye) (HUNK31, the proven "travels as text" idiom this rung mirrors) · [`tally/parse_int.rye`](../tally/parse_int.rye) (strict decimal at the text edge)

---

## Why this round

ALES20 gave a keeper named places over a master, and ALES21 let them be set and read in seconds. Yet every marker a keeper drops lives only in process memory — close the session and the verse, the chorus, the edit point are gone. A cue sheet is the one primitive that lets a keeper's named places **persist and travel**: a whole markers track rendered as shareable text, and parsed back into exactly the same sorted, named track.

The audio world already has a word for this — a **cue sheet** is a list of named time positions handed from one hand to the next (a broadcast log, a mastering marker list, a chapter map). This rung earns that word for Lotus: `format lotus-cue-sheet-v1`, one `mark <pos> <name>` line per marker, read and written whole.

Lindy-first, crux-first: persistence outlives every in-session gesture, so a saveable cue sheet is a higher-Lindy move than one more live transform — a keeper's marks are worth keeping. It mirrors an idiom already proven in the tree (HUNK31's `render_book` / `parse_book` for filter presets), so it carries the least risk of the road-on's rungs, and it reuses ALES20's one `add` path so the sorted-and-unique invariant is enforced **at the text edge** rather than re-spelled. It stays wholly local — text in, text out, no module seam, no gate.

## The one crux this rung fixes

**A markers track rendered to a cue sheet parses back to exactly the same track — `parse(render(m))` recovers every position and name byte-for-byte — and `render(parse(render(m)))` is a fixed point.** Two facts make this exact:

- **Render walks the sorted track in order.** ALES20 keeps the track strictly ascending, so `render_sheet` emits `mark <pos> <name>` lines already sorted; the text is canonical (positions strictly ascending, decimal with no leading zero) with no per-render choice to drift.
- **Parse enforces every bound through the one `add`.** `parse_sheet` hands each line's position and name to `markers.add`, so the parsed track is sorted, unique, within the master, and within the marker ceiling by ALES20's own maintained invariant — a corrupt record that repeats a position refuses `Duplicate`, one past the master refuses `PastEnd`, an oversized name refuses `BadName`, a record past the ceiling refuses `MarkersFull`, each by the marker track's own name, before a byte is trusted.

## The shape

`lotus/cue_sheet.rye`:

- `render_sheet(markers, out)` — render a whole track as its `format lotus-cue-sheet-v1` record into `out`, returning the length. A header line, then one `mark <pos> <name>` line per marker in stored (ascending) order. Refuses `Overflow` rather than writing past the caller's buffer.
- `parse_sheet(text, master, out)` — parse a `format lotus-cue-sheet-v1` record into a fresh track over `master`. A bad header, a line that is not a `mark` line, a missing name, or a malformed position refuses `BadRecord`; every bounds fault forwards from `markers.add` by its own name.
- `MarkerTextError` — `error{ Overflow, BadRecord } || markers.MarkerError` — one honest edge error for the text grammar, every track bound forwarded unchanged.

The position is parsed through `tally/parse_int.rye` strict decimal (a leading zero refuses, so `007` can never masquerade as `7` in a cue sheet); the name is the remainder of the line, so a marker named with a space (`the chorus`) survives the round-trip.

## What the witness proves (GREEN on metal)

`tools/al/ales_cue_sheet_witness.rish`: a track of named places renders to the exact expected `format lotus-cue-sheet-v1` text; `parse_sheet` recovers every position and name byte-for-byte; `render(parse(render(x)))` is a fixed point; a cue sheet whose lines arrive **out of order** still parses to the same sorted track (ALES20's `add` re-sorts); a name carrying a space round-trips whole; and every corruption refuses by name — a bad header, a non-`mark` line, a missing name, a leading-zero or non-numeric position (`BadRecord`), a duplicate position (`Duplicate`), a position past the master (`PastEnd`), an oversized name (`BadName`), a record past the ceiling (`MarkersFull`), and a render into a too-small buffer (`Overflow`). Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a cue sheet a keeper's marks outlive the session and travel to another hand. The next rung can name a **selection** (a marked span a keeper cuts or gains as one), offer the **choice of law** where a crossfade meets a marked edit, or — a module seam, Keaton's word — carry the cue sheet across the ALES0 audio **wire** as its own framed payload, tying a shared marker map to the Mikrophone's capture. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
