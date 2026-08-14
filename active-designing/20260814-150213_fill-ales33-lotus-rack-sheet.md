# ALES33 — Lotus's rack travels as text (the slot sheet)

**Stamp:** `20260814.150213` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES32
**Waymark:** ALES · rung ALES33
**Kin:** [`ALES22 — the cue sheet`](20260814-fill-ales22-lotus-cue-sheet.md) (the "travels as text" idiom) · [`ALES30 — the multi-slot rack`](20260814-144031_fill-ales30-lotus-rack.md) · [`lotus/rack_sheet.rye`](../lotus/rack_sheet.rye) · [`lotus/rack.rye`](../lotus/rack.rye) (ALES30, `copy_to` / `name_of` reused whole) · [`lotus/selection.rye`](../lotus/selection.rye) · [`tally/parse_int.rye`](../tally/parse_int.rye)

---

## Why this round

ALES32's road-on named the next agent-doable crux plainly: **let a rack travel as text — a saveable slot sheet, mirroring ALES22's cue sheet, so the whole rack persists across a session close.** Today a keeper fills a handful of named slots (the count-in, the verse, the chorus, the clean bridge take) and reaches for each by name — yet every one lives only in process memory. Close the session and the whole rack is gone. The cue sheet (ALES22) already proved the one primitive that outlives a session: render a structure to canonical text, parse it back to exactly the same structure. This rung hands that same law to the rack.

The difference from the cue sheet is honest and load-bearing: a markers track carries only *positions and names* — small integers. A rack carries **actual stereo audio** in each slot. So a rack sheet must render each slot's held sample buffers, not merely a name and an index. It is the first ALES "travels as text" rung to persist real PCM.

Lindy-first, crux-first: a saveable rack is durable — the file a keeper writes today reads the same on its ten-thousandth day, exactly the Lindy weight a persistence format earns. And it is the hardest *still-tractable* rack rung: the wire-carry alternative (a slot across the ALES0 audio wire) is a module seam that waits for Keaton's word, while the slot sheet is pure local text, agent-doable now.

## The one crux this rung fixes

**A rack rendered to a slot sheet parses back to exactly the same rack — `parse_rack(render_rack(r))` recovers every slot's name and both channels' samples byte-for-byte, and `render_rack(parse_rack(render_rack(r)))` is a fixed point.** Two facts make this exact, the same two the cue sheet leaned on:

- **Render walks the slots in stored (fill) order**, each slot's name and each channel's samples printed canonically — `i16` decimal with no leading zero, a sign only where negative — so the text has no per-render choice to drift.
- **Parse rebuilds each slot through ALES30's own `rack.copy_to`**, reusing every rack bound at the one place rather than re-spelling it. Because `copy_to` fills from a selection over a master, parse builds a tiny temporary master holding exactly the slot's parsed samples, grabs the whole span with `selection.make`, and hands it to `copy_to` — so the parsed rack is name-bounded, duplicate-free, and within the slot ceiling by ALES30's maintained invariant. A corrupt record refuses `BadName`, `Duplicate`, `RackFull`, or `BadSelection` by the rack's own name before a byte is trusted.

## The shape

`lotus/rack_sheet.rye`:

- Header line `format lotus-rack-sheet-v1` — a foreign or corrupt text refuses at the first line before any slot is trusted.
- Per slot, three lines: `slot <name>` (the name is the remainder of the line, so a name may carry spaces, as the cue sheet allowed), then `L <s0> <s1> …` and `R <s0> <s1> …` — the left and right held samples as canonical `i16` decimal.
- `RackSheetError` — `error{ Overflow, BadRecord } || rack.RackError`; a render past the caller's buffer refuses `Overflow`, a malformed header / line order / channel-length mismatch / bad sample refuses `BadRecord`, and every rack bound forwards by its own name.
- `render_rack(r, out) -> u32` — render the whole rack into the caller's buffer, returning the length; refuses `Overflow` rather than writing past the end, exactly as the cue sheet's `render_sheet` does.
- `parse_rack(text, out) -> void` — parse a `lotus-rack-sheet-v1` record into a fresh rack, each slot rebuilt through `rack.copy_to`.

Because a slot's two channels always share one length (a rack slot is filled from a selection, and `selection.make` refuses an empty span), a well-formed record has equal-length `L` and `R` lines; a mismatch is `BadRecord`. `max_rack_sheet_bytes` is a documented compile-time upper bound (header + `max_slots` × three bounded lines); the render bounds by the caller's buffer, so no caller ever needs to allocate the full worst case.

## What the witness proves (GREEN on metal)

`tools/ales_rack_sheet_witness.rish`: a two-slot rack (`"head"` and `"tail"`, disjoint spans over a stereo source) renders to the exact expected `lotus-rack-sheet-v1` text; parse recovers both names and both channels of both slots byte-for-byte (verified by pasting each recovered slot and comparing samples); `render_rack(parse_rack(render_rack(r)))` is a fixed point; a name carrying a space round-trips whole; and every corruption refuses by name — a bad header, a mis-ordered line, an `L`/`R` length mismatch, a non-numeric sample (`BadRecord`), a duplicate slot name (`Duplicate`), a record past the slot ceiling (`RackFull`), and a render into a too-small buffer (`Overflow`) — each before the output rack is trusted. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a saveable slot sheet a keeper's whole rack persists across a session close and travels between benches as plain text. The next rung can give the sheet a **content digest** (a Sha256 line over the record, so a rack sheet verifies before it is trusted, mirroring the ALES0 wire's deframe), or — a module seam, taken on Keaton's word — carry a slot across the ALES0 audio **wire** as a frame so a filed span travels live between two Lotus benches. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
