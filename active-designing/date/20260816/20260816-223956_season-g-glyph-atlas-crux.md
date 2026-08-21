# Season G, the open glyph atlas -- fonts, the second rung after color

**Stamp:** `20260816.223956` -- **Status:** Mixed -- Living (self-approved design round) -- **Voice:** Kyri -- **Style:** Radiant
**Season:** G (Open Media Primitives) -- the open-font rung, beside `image/color.rye` (color) and `image/qoi.rye` (image)
**Kin:** [`the eight-season double-seat`](20260816-205859_double-seat-expansion-eight-seasons.md) (Season G) -- [`the color crux`](20260816-210735_season-g-color-algebra-crux.md) -- `image/qoi.rye` (the codec whose shape this echoes)
**Teacher, thanked clean-room:** [`../gratitude/bdf-bitmap-font.md`](../gratitude/bdf-bitmap-font.md) -- Adobe's public BDF bitmap-font spec and the run-length lineage; the public shape only, never a copied line.

---

## Why this rung, why now

Season G finishes the open-media family that image (QOI, HUNK) and audio (the wire, ALES) began. The color
algebra landed first -- the smallest tractable crux, floor math that waits on nothing. The next rung the
itinerary names is **fonts**: "a bounded, content-addressed, permissively-licensed glyph format ... decoded
verify-before-trust into a glyph grid the surface can paint, sitting beside QOI and the audio wire."

This is that rung's crux, and it is genuinely tractable now. A glyph is a small coverage grid -- how much ink
covers each cell -- and a font is a table of them keyed by codepoint. That is exactly the shape `image/qoi.rye`
already proved for pixels: verified bytes that decode, deterministically and within named bounds, to a grid,
where a malformed stream refuses **by name** rather than painting garbage. The font codec is QOI's twin one
family over: single-channel coverage instead of four-channel color, keyed records instead of one raster.

Rendering stays paused with Brushstroke and DJINN's Bit Design System. This rung is *not* rendering -- it is the
open container the renderer will read the day it wakes, the same way `color.rye` is the color model it will read.
Building it now means the surface finds a proven glyph format waiting rather than a blank.

## What the crux is

A self-describing, bounded **glyph atlas** in Rye, owning both halves so the property that matters is provable on
metal: `decode(encode(atlas))` recovers the atlas **byte-for-byte** -- every codepoint, advance, and coverage
byte identical -- and every deliberate corruption refuses with its own named error.

### The wire shape (GFA1)

```
Header (fixed, 8 bytes):
  4  magic  "gfa1"
  1  cell_w   (1..64)          -- coverage-grid width in cells
  1  cell_h   (1..64)          -- coverage-grid height in cells
  2  glyph_count (u16 BE, 1..glyph_max)

Then glyph_count glyph records, codepoints strictly ascending:
  4  codepoint (u32 BE)
  1  advance   (0..255, pen-advance in cells)
  a coverage stream that RLE-decodes to EXACTLY cell_w*cell_h bytes:
     op RUN = 0x01, count C (1..255), value V   -> emit V, C times
     op LIT = 0x00, count C (1..255), C bytes    -> emit the C literal bytes

Trailer:
  8  end marker { 0,0,0,0,0,0,0,1 }              -- the same eight-byte family echo as QOI
```

Coverage is one byte per cell: `0` = no ink, `255` = full ink, between = partial. Glyph coverage runs long (a
row of background, a stroke of ink), so the two-op RLE is real compression, not a raw copy -- the witness proves
encoded < raw. The two ops carry their own count byte, so the stream is unambiguous and self-describing; a
coverage byte never has to double as an op tag.

### Named refusals (verify before trust)

`BadMagic` -- `BadCellSize` (a zero or over-64 dimension) -- `BadGlyphCount` (zero, or over the ceiling) --
`UnsortedCodepoints` (a record not strictly greater than the last) -- `BadOp` (a stream op that is neither RUN
nor LIT) -- `CoverageOverrun` / `CoverageShort` (an RLE that decodes to more or fewer than cell_w*cell_h bytes) --
`Truncated` -- `BadEndMarker` -- `TrailingData`. Nothing past the header is trusted until the whole atlas decodes
to exactly its declared glyphs and the stream ends in the canonical marker with no trailing byte.

### The decoded shape

`GlyphAtlas { cell_w, cell_h, glyphs: []Glyph }`, each `Glyph { codepoint, advance, coverage: []u8 }` with
`coverage.len == cell_w*cell_h`. A `lookup(codepoint)` scans the ascending table and returns the glyph or null --
the smallest honest reader a surface needs.

## The bounds, named

- `glyph_cell_max: u32 = 64` -- a coverage grid is at most 64x64 cells; a right-to-repair panel's UI type is far
  smaller, so the bound is honest headroom.
- `glyph_max: u32 = 4096` -- an atlas holds at most 4096 glyphs (a generous ceiling over a Latin + punctuation +
  symbol working set).
- `coverage_max: u32 = glyph_cell_max * glyph_cell_max` -- 4096 coverage bytes per glyph, named at construction.
- `encoded_bound(...)` -- a caller sizes its buffer by a proven worst case (header + per-glyph literal-run
  framing + trailer), never guessing.

Every count is `u32` in memory, `u8` for a coverage byte, wire quantities big-endian bytes -- the same width
discipline `image/qoi.rye` keeps.

## What it proves (the witness)

`tools/glyph_atlas_witness.rish` builds `image/glyph.rye` to a binary and runs its selftest, which:

1. Crafts a small atlas -- a few codepoints, each a coverage grid mixing long background runs and an ink stroke,
   so the encoder reaches for both RUN and LIT.
2. Encodes, then decodes, and asserts the round-trip is **byte-for-byte** across every glyph.
3. Asserts real compression -- encoded bytes < raw coverage bytes.
4. Proves `lookup` finds a present codepoint and misses an absent one.
5. Fires each named refusal by a deliberate corruption -- bad magic, a zero cell size, an unsorted codepoint,
   a coverage overrun, a broken end marker, a trailing byte -- and checks each returns **its own** error.

Green looks like one line: `GREEN image-glyph: NxM atlas round-trip byte-identical; ops run=.. lit=..; encoded
.. bytes < raw ..; refusals ... all named`.

## Where it sits, honestly

- **Crux, agent-doable now** -- floor code, no network, no key, no funds, no paused dependency.
- **Not rendering** -- painting the coverage into pixels is a later Skate/Brushstroke rung, held with the design
  system. This is the container beneath it.
- **Not yet a full font** -- kerning, ligatures, hinting, and vector outlines are horizons past this bitmap
  floor; the itinerary starts smallest on purpose, exactly as the video rung starts intra-frame.
- **Content-addressing rides in Tablecloth**, not the codec -- the same boundary QOI keeps.

---

*May the letters a surface paints stand on a format no one had to ask permission to read, and may the first
glyph decode as true as the last.*
