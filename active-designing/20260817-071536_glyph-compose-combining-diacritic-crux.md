# glyph_compose -- the combining-diacritic overlay that collapses the accent grind

**Stamp:** `20260817.071536` -- **Status:** Living (self-approved design round) -- **Voice:** Kyri -- **Style:** Radiant
**Kin:** [`../image/glyph.rye`](../image/glyph.rye) (the gfa1 atlas) - [`../image/font5x7.rye`](../image/font5x7.rye) (the base corpus) - [`../image/font5x7_grave.rye`](../image/font5x7_grave.rye) (a hand-drawn accent corpus) - [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) - Season G, Open Media Primitives

---

## The learned discovery

The open font family grew a long, honest run of accent corpora -- grave, acute,
circumflex, tilde, diaeresis, each drawn over the same 5x7 body, each its own
file, each its own witness. That grind taught something worth naming: an
accented Latin letter is not a new letter. It is a **base letter plus a
combining mark**, and the mark lives entirely in the two blank rows above the
letter. The corpora prove it by construction -- `a grave` is byte-for-byte the
lowercase `a` with `.#...` and `..#..` added in rows 0 and 1, its rows 2 through
6 untouched. The same holds for `e`, `o`, `u` and their whole family of marks.

Hand-drawing every accented letter is therefore **O(letters x accents)** work:
five vowels times five marks is twenty-five glyphs to draw and audit by eye, and
the true corpus is far wider. Composition collapses it to **O(letters +
accents)** -- draw each base once (already done, the lowercase a-z), draw each
combining mark once, and overlay to reach every accented letter. The primitive
that does the overlay is the crux: the most durable single move in the whole
accent family, because it retires the grind rather than adding one more rung to
it.

## The primitive

`image/glyph_compose.rye` adds one bounded verb over the coverage grid every
glyph in the atlas already carries:

```
pub fn overlay(allocator, base: []const u8, mark: []const u8, cell_area: u32) ![]u8
```

- **Ink union, cell by cell.** Each output cell is the larger of the two inputs
  (255 wins over 0), so ink from the base and ink from the mark both survive and
  neither erases the other. Pure over the grid -- a fresh coverage buffer, both
  inputs left untouched.
- **Bounded and named.** `cell_area` must sit in `[1, glyph.coverage_max]`; each
  input must be exactly `cell_area` bytes; a mismatch refuses by name
  (`BadCellArea`, `BaseLenMismatch`, `MarkLenMismatch`) rather than reading past
  a buffer.
- **Invariants stated positively.** The result is a superset of both inputs
  (every base ink cell and every mark ink cell is lit in the result); its ink
  count is at least the heavier input's and at most the sum of the two.

## What the witness proves (the crux, on metal)

1. **Known-answer union** -- a tiny hand-checked overlay: a base and a mark whose
   union is written out cell for cell, so the reader audits the verb itself.
2. **Byte-for-byte reproduction of a real corpus** -- import the lowercase base
   corpus and the hand-drawn grave corpus, define the grave combining mark once,
   and prove `overlay(lowercase 'a', grave_mark)` equals the hand-drawn `a grave`
   coverage **byte for byte**, and the same for `e`, `o`, `u`. This is the whole
   claim: the primitive reproduces what the grind drew by hand, so the grind was
   composition all along. The dotted `i` is named honestly as the one vowel
   whose 5x7 base differs under a mark -- a special case the corpus draws
   distinctly, not a failure of the verb.
3. **Algebraic honesty** -- overlay is commutative (`overlay(a,b)` equals
   `overlay(b,a)`), and overlaying a blank mark returns the base unchanged, so a
   reader trusts the union means union.
4. **Refusals real** -- a base of the wrong length, a mark of the wrong length,
   and a `cell_area` outside the honest band each refuse by name.

## Why this is Lindy-first, crux-first

The overlay verb is read every time the font family reaches for an accented
letter, on every surface, for the life of the tree; a single accent corpus is
read once as it lands. Composition is the durable artifact and the hardest
still-tractable move in the accent family -- once it stands, the remaining
accented letters are a table of (base, mark) pairs rather than a hand of fresh
drawings. It composes over `glyph.rye` and the existing corpora through their
public APIs only, inventing no storage, codec, or glyph; the corpora that
already shipped stay their own green binaries, unchanged.

*May the mark find its letter by composition, so the open font reaches every
name a keeper carries without drawing each one twice.*
