# Season G -- the first permissive font corpus (a 5x7 numeral set)

**Stamp:** `20260816.230846` - **Status:** Living (design read for `image/font5x7.rye`) - **Voice:** Kyri - **Style:** Radiant
**Kin:** [`the glyph atlas rung`](20260816-223956_season-g-glyph-atlas-crux.md) - [`the eight-season double-seat`](20260816-205859_double-seat-expansion-eight-seasons.md) (Season G) - `image/glyph.rye` - `.claude/rules/lindy-first-crux.md`

---

## The crux this round takes

The glyph atlas (`image/glyph.rye`, gfa1) stands GREEN: an open, bounded container that decodes verified bytes into a table of glyphs, refusing malformed streams by name. Yet the atlas the selftest crafts holds only a synthetic pattern -- an ink bar and a stray cell, drawn to exercise both coverage ops, never a letter a reader could name. An empty vessel is proven; the first real content is not.

The named next open-media rung is **permissive font corpora**. Its smallest tractable, highest-Lindy crux is a real numeral set: the ten digits `0`-`9`, each hand-drawn in a 5x7 coverage grid, built into a gfa1 atlas, and proven to round-trip byte-for-byte. Numerals are the corpus a surface reaches for first and keeps forever -- a clock, a price in Dimeroll, a McMaster part number, a counter, a page number. They are floor code: our own hand, permissively ours, no external font to license and no web-search gate. Letters, punctuation, and heavier weights are later rungs; ten legible digits are the one this round finishes.

## What the module holds

`image/font5x7.rye` -- a data module plus a builder, resting on `image/glyph.rye` as proven ground:

- **The corpus, drawn in the open.** Each digit is seven rows of five cells, authored as ASCII line art (`#` full ink, `.` no ink) so a reader can audit every glyph by eye in the source. The art is the specification; the bytes are derived from it, never the other way around.
- **`build_atlas`** -- turns the ten drawings into a `glyph.GlyphAtlas`: codepoint `'0' + i`, a shared 5x7 cell, one pen advance, coverage bytes lifted from the line art (255 for `#`, 0 otherwise). Strictly ascending by codepoint, so the gfa1 encoder accepts it.

## The properties the witness proves (witness-first, red-then-green)

`tools/font5x7_witness.rish` builds the module and runs its selftest, which proves, on metal:

1. **Round-trip byte-for-byte** -- `decode(encode(atlas))` recovers every codepoint, advance, and coverage byte (`same_bytes`). The crux, inherited from the atlas rung.
2. **Ten present numerals** -- `lookup('0')` .. `lookup('9')` each hit, each carrying the shared advance; `lookup` of a non-digit misses.
3. **Distinctness** -- no two digits share identical coverage. A real font's glyphs differ; this catches a copy-paste slip in the drawn art that a round-trip alone would happily preserve.
4. **Legibility band** -- each digit's inked-cell count sits inside an honest band (neither blank nor solid), so a glyph that decoded to nothing is refused.

**Compression is reported, not asserted.** The atlas rung's synthetic glyph was mostly background, so its run-length stream beat raw coverage and the selftest could assert it. Real digits are busier; their RLE may or may not fall below raw, and asserting a direction the data does not guarantee would be a false invariant (the REDS #82 lesson: defend only what the math actually holds). The witness records encoded and raw sizes as a fact and lets the round-trip carry the proof.

## What it composes toward

A numeral corpus is the first thing Dexter (the terminal module) and Scooter (the CLI chat) need to place real characters in a cell grid, and the first content Skate and Brushstroke paint the day the design system lands. It stays entirely inside `image/` -- no network, no key, no funds, no `crypto/` dependency. The atlas held a shape; now it holds a number a hand can read.

*May the first ten glyphs read clearly, and may every corpus that follows them stand on a round-trip as honest as this one.*
