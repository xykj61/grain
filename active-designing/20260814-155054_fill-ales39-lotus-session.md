# Fill ALES39 — Lotus's session file: a keeper's whole project as one sealed document

**Stamp:** `20260814.155054` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES39**
**Stands on:** [`../lotus/seal.rye`](../lotus/seal.rye) (ALES38) · [`../lotus/rack_sheet.rye`](../lotus/rack_sheet.rye) (ALES33) · [`../lotus/cue_sheet.rye`](../lotus/cue_sheet.rye) (ALES22) · [`../lotus/rack.rye`](../lotus/rack.rye) (ALES30) · [`../lotus/markers.rye`](../lotus/markers.rye) (ALES20)

---

## Why this rung, and why now

A keeper saves **two** kinds of thing — the **rack** (the held audio spans, ALES33) and the **cue sheet** (the arrangement map, ALES22) — yet they save and load **separately**, as two files that can drift apart: a rack loaded beside a cue sheet from a different take, a map whose marks no longer name the audio. A keeper's project is one thing; it deserves one document. ALES38 made this rung clean — the seal is now one parser-agnostic primitive that frames a **composite** body zero-scratch, exactly what a bundle wants.

**Lindy-first:** the top-level save/load a keeper reaches for every session — open my project, save my project — is the most-read gesture the suite has; a single sealed document that carries the whole project verified is the durable culmination of the persistence arc. **Crux-first:** the hard-but-tractable core is **exact sectioning under one seal** — `parse_rack` and `parse_sheet` each consume their whole text, so the bundle must hand each parser *exactly* its own bytes, and the whole must verify before either half is trusted. ALES38's `seal.open` gives the whole-project gate; a small length manifest gives the exact split.

Purely local — a Sha256 over an in-process text record. No signature, no key, no socket, no network, no funds, no device.

## The crux

**A session document round-trips a keeper's whole project — rack and cue sheet over one master — and the whole document verifies before either half is trusted.** `seal.open` recomputes the Sha256 over the entire body (manifest + rack record + cue record) and refuses `DigestMismatch` before a single slot or marker is parsed; only then is the body split by its manifest and each half handed to its own ALES parser. Because `parse_rack` and `parse_sheet` each consume their whole input, the split must be **exact** — a byte manifest names each section's length, so each parser sees exactly its own record and nothing of the other's.

The body is length-delimited, never delimiter-scanned: a slot name or marker name may contain any character, so a sentinel line could collide with real content — a byte-length manifest cannot. The manifest also carries its own integrity check: the payload after it must measure **exactly** `rack_len + cue_len`, or the document refuses `BadRecord`.

## Shape

A new module `lotus/session.rye`, over `seal` · `rack_sheet` · `cue_sheet` (and `parse_int` for the manifest):

- `save(r: *const rack.Rack, m: *const markers.Markers, out: []u8) SessionError!u32` — render the rack record and the cue record, write a `format lotus-session-v1` manifest (`rack <n>` · `cue <n>`) then the two records verbatim, and seal the whole under a `format lotus-session-sealed-v1` header via ALES38's `seal.begin` / `seal.finish`.
- `load(text: []const u8, master: *const pan.StereoClip, out_rack: *rack.Rack, out_markers: *markers.Markers) SessionError!void` — the whole-project gate: `seal.open` verifies the entire body, the manifest splits it, and `rack_sheet.parse_rack` / `cue_sheet.parse_sheet` rebuild each half (the cue's `master` position-bound passed through, after the gate).
- `SessionError = seal.SealError || rack_sheet.RackSheetError || cue_sheet.MarkerTextError` — Zig merges by name, so `BadRecord` / `Overflow` coincide across the three rather than tripling.

The sealed header is distinct from every other Lotus sealed header, so no document is ever mistaken for a bare rack or cue seal.

## What the witness proves

`tools/ales_session_witness.rish`, GREEN on metal:

1. **The crux** — a two-slot rack and a four-marker cue sheet over one master round-trip through `save` / `load`, every slot's audio byte-for-byte and every marker's position and name recovered.
2. **Whole-project integrity** — a single flipped body byte (in either the rack half or the cue half) refuses `DigestMismatch`, both outputs left empty.
3. **Truncated tail** — a dropped last byte refuses `DigestMismatch`.
4. **Malformed manifest** — a wrong session header, a bad `rack`/`cue` length line, and a payload whose length disagrees with the manifest each refuse `BadRecord`.
5. **Section isolation** — the rack half never sees the cue half's bytes and vice versa (proven by a cue-only edit refusing without touching the rack parse path).
6. **Overflow** — a save into a too-small buffer refuses `Overflow`.

## The road on

With the session file, the purely-local persistence arc is whole — file, edit, save, seal, load, merge, rename, and now **one document for the whole project, verified before trust**. The **signed** carry (who wrote a session, via a Kumara key) and the **wire** carry stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a keeper's project arrive as one whole thing, its map and its music never parted, and may the single seal over both keep faith on the ten-thousandth open.*
