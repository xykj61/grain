# Season G -- the intra-frame video container (gfv1), the crux after the glyph atlas

**Stamp:** `20260816.225918` - **Status:** Living (design capture) - **Voice:** Kyri - **Style:** Radiant
**Kin:** [`the eight-season double-seat`](20260816-205859_double-seat-expansion-eight-seasons.md) (Season G) - [`image/qoi.rye`](../image/qoi.rye) - [`image/glyph.rye`](../image/glyph.rye) - [`the growing-a-language method`](20260618-184912_growing-a-language.md)
**Teacher, thanked clean-room:** the container lineage of Ogg/Matroska (a self-describing stream of length-delimited frames) -- public shape only, our own Rye.

---

## Why this rung, why now

The open-media family has grown color (`image/color.rye`), image (`image/qoi.rye`), and the glyph atlas (`image/glyph.rye`), each GREEN on metal. Season G names the next open-media rung plainly: **intra-frame video**, and it names how to begin -- *start smallest*: a self-describing, content-addressed **QOI-per-frame** stream, where landscape / portrait / square are container metadata rather than new math (`20260816-205859_double-seat-expansion-eight-seasons.md`, Season G).

This is the growing-a-language method read faithfully (rota doc, this lap): *a complex system that works grew from a simpler system that worked.* A video, at its smallest honest form, is a **table of images** the way a font is a table of glyphs and an image is a table of pixels. We do not reach for an inter-frame codec (motion vectors, P/B frames) -- we reach for the smallest version that runs: a bounded, verified list of whole QOI frames, and we grow it later. The proven ground is `image/qoi.rye`; the video module rests on it and adds only the container.

## The gfv1 format -- self-describing, verify-before-trust

A fixed header, then a length-delimited table of QOI frames, then the family's eight-byte end marker.

```
Header (16 bytes, fixed):
  4  magic          'g' 'f' 'v' '1'
  4  width          u32 BE, shared by every frame
  4  height         u32 BE, shared by every frame
  1  orientation    0 landscape (w>h) - 1 portrait (h>w) - 2 square (w==h)
  1  fps            frames per second, 1..255
  2  frame_count    u16 BE, 1..gfv_max_frames

Per frame (frame_count of them):
  4  frame_len      u32 BE -- the length of this frame's QOI stream
  N  qoi_bytes      exactly frame_len bytes, a whole valid image/qoi.rye stream

End marker (8 bytes): 0 0 0 0 0 0 0 1   -- the same family echo as qoi.rye and glyph.rye
```

**Orientation is a checkable claim, not free metadata.** The decoder derives orientation from width and height and refuses (`BadOrientation`) if the stored byte disagrees -- so the container never carries a lie about its own shape. Each frame's decoded dimensions must equal the container's, or the frame refuses (`FrameDimsMismatch`); an intra-frame clip is one size for its whole length by construction.

**Content-addressing stays external, exactly as for images.** A gfv1 stream is content-addressed the day Tablecloth keys it, the same way a qoi stream is; the container itself carries no hash, so `image/` keeps zero dependency on `crypto/`. The family shape is the invariant here, not a second copy of the digest surface.

## Named refusals (verify before trust)

Every malformed stream refuses by its own name rather than decoding garbage:
`BadMagic` - `Truncated` - `TrailingData` - `BadEndMarker` - `BadDimensions` - `TooLarge` -
`BadOrientation` - `BadFps` - `BadFrameCount` - `FrameTooLarge` - `FrameDimsMismatch`.

## Bounds, named at construction (TAME)

- `gfv_max_frames = 4096` -- a short clip, honest headroom over any UI animation the surface needs.
- Frame dimensions and pixel count reuse `image/qoi.rye`'s own ceilings (`qoi_max_dim`, `qoi_max_pixels`).
- Each frame's byte length is bounded by `qoi.encoded_bound(width*height)` -- a frame can never claim to be larger than a worst-case QOI encode of the container's own dimensions (`FrameTooLarge`).
- In-memory counts are `u32`; the wire is big-endian bytes; `usize` appears only at the allocator seam.

## The witness (the crux, provable on metal)

`tools/frames_video_witness.rish` builds a small clip (three 8x4 landscape frames -- a solid color, a second solid color, a crafted pattern), encodes it to gfv1, decodes it back, and asserts:

1. **Round-trip byte-identical** -- every frame's RGBA pixels recover byte-for-byte, and orientation, fps, and frame_count survive.
2. **Compression is real** -- the encoded clip is smaller than the raw RGBA of all frames stacked.
3. **Every refusal is named** -- deliberate corruptions each return their own error (`BadMagic`, `BadEndMarker`, `TrailingData`, `Truncated`, `BadOrientation`, `FrameDimsMismatch`).

Green looks like a single `GREEN image-frames: ...` line. No network, no key, no funds -- the video container Photos, Skate, Realidream, and Pond read the day a surface wants to show motion, standing on an open format no one had to ask permission to read.

---

*The family gains its fourth member the honest way: a video that is a table of images, proven whole on metal, small enough to hold in one hand and grow from there.*
