# HUNK — the single-sprite marketplace index

**Stamp:** `20260813.201500` · **Status:** Mixed -- Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Open Image journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-144218_hunk-season-a-open-image-exploration.md`](20260813-144218_hunk-season-a-open-image-exploration.md) — the HUNK0–HUNK3 Open Image quest, complete
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`image/photos.rye`](../image/photos.rye) (`crop`) · [`image/qoi.rye`](../image/qoi.rye) · [`gratitude/qoi.md`](../gratitude/qoi.md)

---

## Why this round, now

The Open Image journey stands whole — HUNK0 decoded, HUNK1 content-addressed, HUNK2 painted, HUNK3 cropped, each on a green witness. Reading the road **Lindy-first, crux-first**, the next durable, fully agent-doable, ungated crux is the one Season A named for the module the moment it was built: the **parts marketplace**, *"one massive sprite image web-hosted, each product rendered as an index into that single image (their speed trick)."*

That trick — McMaster-Carr's — is high-Lindy: it is how a catalog of thousands of parts stays fast, and it sits directly on the open module the last quest built. No custody gate, no deferred web search; greenfield code over proven, decoded pixels.

## The crux

> **Every product is a bounded window into one decoded sheet — one decode serves the whole catalog, each product renders exactly its own region, and no product can leak a neighbor's pixels.**

The sheet is decoded once (HUNK0's `qoi.decode`). A `SpriteIndex` binds each product name to a rectangle into that single shared image; rendering a product is HUNK3's own `photos.crop` at the product's window. So the marketplace inherits the open module's integrity for free: a rendered product is still an open image that re-encodes and round-trips byte-for-byte.

## The opening rung — HUNK4

`image/sprite.rye` — `SpriteIndex.init(sheet)` opens an index over an already-decoded sheet; `add(name, x, y, w, h)` binds a product name to a window, **bound-checked at add time** (in u64 so a coordinate can never wrap) so a render can never fail on bounds; `render(name)` crops the one sheet at the product's window. Every failure is a named refusal — an unknown name (`UnknownProduct`), a window past the sheet (`WindowOutOfBounds`), an empty window (`EmptyWindow`), a taken name (`NameTaken`), an overlong name (`NameTooLong`), a full catalog (`TooManyProducts`). Bounds named at construction (256 products · 48-byte names); ≥2 positive invariants per function.

The witness (`tools/hunk_sprite_witness.rish`) indexes three products into one 8×8 tagged sheet and proves: each renders exactly its window, disjoint windows carry different pixels, the sheet is shared and unmutated across every render, and a rendered product re-encodes and round-trips — with HUNK3's crop re-run GREEN beneath.

## Where this quest goes next (named intent, not yet built)

- **HUNK5 — the product page.** A rendered product window painted through HUNK2's Skate down-map, so a catalog entry is *seen* on the canvas, not only decoded.
- **HUNK6 — the sheet as a Tablecloth artifact.** The whole sprite stored content-addressed (HUNK1), so the catalog a keeper serves is the exact bytes whose digest the index pins — a tampered sheet refusing before a product renders.
- **HUNK7 — the catalog manifest.** A `format sprite-catalog-v1` Bron record binding names to windows, round-tripping byte-for-byte, so a marketplace travels as text a person can read.

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The window is HUNK3's `crop`; the sheet is HUNK0's `Pixmap`; no new storage, no new codec.
- **Bounds, widths, asserts.** `u32` in-memory coordinates and counts, checked in u64 at the edge; every buffer names a maximum; positive invariants (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — sourcing real parts and hosting a real sheet are Season A's later, gated rounds.
