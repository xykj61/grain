# Gratitude — QOI (the "Quite OK Image" format)

**Author:** Dominic Szablewski · **License:** MIT (reference implementation) · public one-page specification at `qoiformat.org`.

QOI is a lossless raster image format that fits its whole specification on a single page and decodes with no library, no table beyond a 64-entry running array, and no arithmetic heavier than a byte add. It reaches PNG-class compression on many images while staying simple enough that a reader can hold the entire codec in their head — six chunk kinds (a full RGB or RGBA pixel, a 64-slot index reference, a small per-channel diff, a luma-relative diff, and a run of the previous pixel), a fixed 14-byte header, and an 8-byte end marker.

## What Grain learns, clean-room

Grain's **HUNK** open image module (`image/qoi.rye`) is written from the **public specification only** — the chunk grammar, the `index = (r*3 + g*5 + b*7 + a*11) % 64` hash, the previous-pixel running state — never from the reference C source. We study the concept; we write our own bounded, asserted Rye implementation ([gratitude-licenses](../.claude/rules/gratitude-licenses.md)). The gift QOI hands down is the shape of a *genuinely open, genuinely simple* compressed format a small tree can implement whole and prove on metal — exactly the kind of dependency-free honesty the parts marketplace and the Photos app want beneath them.

Thank you, QOI, for showing that "open image format with real compression" and "small enough to hold in one hand" are not at odds.
