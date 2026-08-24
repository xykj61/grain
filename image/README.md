# Open Image -- a picture you own, all the way down

**Language:** EN - **Voice:** Kyri
**Last updated:** `20260824.082436` (the front door -- the three arc records and the module roster moved to their own pages)
**Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- 227 modules in this directory, every one rostered in [`MODULES.md`](MODULES.md), counted `20260824`

**A picture here is bytes you can check, decoded by code small enough to read whole, into a grid of
pixels you hold. Everything done to it afterward is a pure function that hands back a fresh image
and leaves the first one exactly as it was.**

That is the whole promise. Everything a picture needs in order to open is already on your machine --
the bytes, and the code in this directory that reads them -- and you can read this page start to
finish in about ten minutes.

## Where the name comes from

*Open* is doing real work in the name. An open format is one whose whole specification fits on a
page, so anyone can write a decoder and check it against yours. This module has one, and the codec
beneath it stays small on purpose: a picture belongs to whoever holds it, and that is only true
while the code that opens it is code they could read in an afternoon.

## What a picture is here

Three plain things, in the order they happen.

**Bytes with an address.** A stored picture is named by a digest of its own content. Ask for that
name and you get those exact bytes back, and a single altered byte refuses **by name** rather than
painting garbage. The verification happens first, before the codec reads a pixel.

**A grid.** The codec turns those bytes into a rectangle of pixels, each carrying red, green, blue,
and alpha. Encoding a grid and decoding it again returns the same grid, byte for byte.

**A fresh grid.** Every verb -- crop, blur, rotate, sharpen, find the edges -- reads the grid and
returns a new one. Your original stays whole, which is why an edit here can always be undone: the
history is a list of verbs, and replaying a shorter list is what *undo* means.

## The four arcs

Each arc closed whole, and each has its own page. This one keeps the summary.

**The codec.** [`qoi.rye`](qoi.rye) is a complete open image codec, encode and decode, across all
six chunk kinds. Five kinds of corruption each refuse by name rather than reading past the end. A
picture becomes a content-addressed artifact through
[`../pond/apps/image_artifact.rye`](../pond/apps/image_artifact.rye), which proves every piece
against its digest before the codec sees it, and the same image stored under two names is stored
once.

**Photos** -- [`PHOTOS.md`](PHOTOS.md). The gestures a keeper already knows, each a pure verb over
the grid: orient, resample, soften, crispen, detect edges, adjust color, and an editing history
where undo and redo run along one line, and a fresh edit starts that line again from where you
stand. Nineteen modules carry the gestures, and the paint, text, and video families sit beside them -- forty-five together.

**The parts marketplace** -- [`MARKETPLACE.md`](MARKETPLACE.md). One decoded sheet serves a whole
catalog, each product a bounded window into it. A part is a picture with its facts -- a part number,
a material, and a price recorded as a plain count of cents, which this tree compares and sorts by
while moving money stays a hand's work. On top of it sits a boolean query a keeper types by hand.

**Open Media Primitives** -- [`PRIMITIVES.md`](PRIMITIVES.md). The color and type floor Season G
grew beside the codec: an sRGB algebra held exactly, the palette and ramp and contrast tools a
design system asks for, a 5x7 bitmap font with wide coverage, and the shape-analysis family that
reads what a mask actually holds.

## What runs today

Every line here has a witness behind it that runs green on a real machine.

- **The codec**, round-tripping byte for byte, with each corruption refusing by its own name.
- **The content address**, verified before decode, with a tampered piece refusing `DigestMismatch`.
- **The Photos verbs**, each proven by the algebra it obeys -- four quarter-turns are the identity,
  a mirror is its own inverse, a flat field sharpens to itself.
- **The marketplace query**, where what a keeper types is exactly what a keeper sees, header count
  and page number included.
- **The color and type floor**, where `parse(format(c))` recovers a color exactly and every
  malformed text refuses by name.

## The invariants this module keeps

- **Prove before you paint.** A content-addressed picture is checked against its digest before the
  codec touches a pixel.
- **Pure over the grid.** Every verb returns a fresh image and leaves the source as it was, so an
  edit is data replayed rather than an original spent.
- **Bounded everywhere.** Coordinates and samples run in `u64`, so a rectangle or a resample stays
  inside the size it declared; every list names a maximum, and every outcome carries its own name.
- **Custody first.** A price is a recorded fact this tree compares and sorts by. Moving money stays
  a hand's work, behind a gate.

## Horizons -- named, and waiting

- **Real part values.** The catalog structure stands; filling it from real refurbished-parts
  sources is a research round, and buying a part is a custody gate.
- **A color e-ink render target** for the Grainphone hybrid -- a research round of its own.
- **Richer resamplers and a wider filter grammar**, as Photos grows.

## Where to read next

| Page | What it holds |
|---|---|
| [`MODULES.md`](MODULES.md) | every module in this directory, one row each, held to the directory by a standing guard |
| [`PHOTOS.md`](PHOTOS.md) | the Photos arc: each gesture, what it proves, and the witness that proves it |
| [`MARKETPLACE.md`](MARKETPLACE.md) | the parts catalog, its facts, and the query algebra over them |
| [`PRIMITIVES.md`](PRIMITIVES.md) | color, type, video, and the shape-analysis family of Season G |

**Season:** A -- Hardware & Right-to-Repair - **Waymark:** HUNK - opening journey **Open Image**.
The card that says what comes next is [`../construction/ITINERARY.md`](../construction/ITINERARY.md).

## Gratitude

**QOI** (Dominic Szablewski) is the teacher for the codec, studied from its public one-page spec
alone -- that spec is the whole of what we read, and the reference C stays where it is. Thanked at
[`../gratitude/qoi.md`](../gratitude/qoi.md).
The Photos arc honors the gestures a keeper already knows from the photo apps they have used, and
**McMaster-Carr** is thanked for the single-sheet trick a catalog renders by. We study concepts and
write our own code.

---

*May every picture stay the keeper's own -- decoded in the open, addressed by its own bytes, and
edited without ever losing the first frame. May the wall grow one honest tile at a time, and may no
picture here ever need to phone home to be seen.*
