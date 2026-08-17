# Gratitude -- BDF (the Glyph Bitmap Distribution Format) and the run-length lineage

**Author:** Adobe Systems (X Consortium / public specification) - **License:** the BDF spec is public and freely
implementable; PackBits-style run-length encoding is a long-public technique. Public specification only.

BDF is a plain-text, human-readable format for distributing bitmap fonts: a small header (cell dimensions,
glyph count) followed by one record per glyph, each carrying its encoding (the codepoint), a pen advance, a
bounding box, and the glyph's bitmap as rows of on/off cells. It is beloved because a person can read a whole
font in a text editor and a decoder can be written in an afternoon -- the glyph table is a flat, ordered list of
small coverage grids, nothing hidden.

Run-length encoding -- collapsing a repeated byte into a (value, count) pair, and a stretch of distinct bytes
into a (length, bytes) literal -- is the oldest honest compression there is, public for decades (PackBits and its
kin). Glyph coverage runs long by nature: a row of background, then a stroke of ink. That is exactly what RLE was
made for.

## What Grain learns, clean-room

Grain's open **glyph atlas** (`image/glyph.rye`, Season G) is written from these **public shapes only** -- the
idea of a header-plus-ordered-glyph-records table keyed by codepoint, and the idea of a two-op run-length
coverage stream -- never from any particular library's source. We study the concept; we write our own bounded,
asserted, named-refusal Rye implementation ([gratitude-licenses](../.claude/rules/gratitude-licenses.md)). The
gift BDF hands down is the same one QOI hands down one family over: an *open, genuinely simple* format a small
tree can implement whole and prove on metal -- verified bytes that decode, within named bounds, to a grid a
surface can paint, a malformed stream refusing by name.

Thank you, BDF, for showing that a font can be a plain, readable table anyone is free to open, and thank you to
the run-length lineage for showing that honest compression need not be clever to be real.
