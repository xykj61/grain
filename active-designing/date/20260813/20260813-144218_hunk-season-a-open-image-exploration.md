# HUNK — Season A opens: the open image module

**Stamp:** `20260813.144218` · **Status:** Mixed -- Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (drawn `20260813` from `season-a-open-image-decode-and-photos-surface`; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md), the derive script, and [`../context/LEXICON.md`](../context/LEXICON.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`gratitude/qoi.md`](../gratitude/qoi.md) · Tablecloth ([`../pond/apps/tablecloth.rye`](../pond/apps/tablecloth.rye)) · Skate ([`../brushstroke/skate_grid.rye`](../brushstroke/skate_grid.rye))

---

## Why this round, now

The Mycelium consensus season (Season D's protocol half) stands whole and witnessed — ninety-eight modules, eighty green witnesses, a foundation and a front-door README seated. That is a clean season close. Reading the whole road **Lindy-first, crux-first**, the next durable, fully agent-doable, ungated crux is **Season A's open image module**.

Season A names it plainly: *"Tablecloth holds the sprite in an existing open-source image format with the compression wanted; Skate + Brushstroke paint it,"* and the Photos app is *"built on the open image module above."* One primitive sits beneath **two** named products — the McMaster-Carr-style parts marketplace and the Photos app — so an image module is high-Lindy by construction: every hour spent on it compounds through both.

It is also fully in the near room: greenfield code over already-proven substrate, no custody gate, no deferred web search. (The e-ink panel, refurb-parts sourcing, and MCP marketplace APIs each stay their own later research round; buying real hardware stays custody gate #2/#3.)

## The crux

> **An image is verified bytes that decode, deterministically and within named bounds, to a pixel grid — a malformed or truncated stream refusing by name rather than painting garbage.**

For "an existing open-source image format with the compression wanted," the teacher is **QOI** (the Quite OK Image format — [gratitude/qoi.md](../gratitude/qoi.md)): genuinely open, a real lossless compressor (index · diff · luma · run chunks), yet small enough to implement *whole* in bounded, asserted Rye with no dependency. That is the tree's aesthetic exactly — a primitive that fits in one hand and proves itself on metal. Written from the public one-page spec, clean-room, never from the reference C.

## The opening quest — HUNK0–HUNK3

Four rounds, each one keystone, each its own signed increment and green witness:

- **HUNK0 — the codec (the crux).** `image/qoi.rye`: `decode(allocator, bytes) → Pixmap` reads the 14-byte header (magic `qoif` · width · height · channels · colorspace), bound-checks the dimensions, and runs the six-chunk loop (RGB · RGBA · INDEX · DIFF · LUMA · RUN) over the 64-entry running index and previous-pixel state into a bounded RGBA pixel buffer; a wrong magic, a zero or over-max dimension, a truncated stream, a bad end marker, or trailing bytes each refuse with a **named** error. A reference `encode` emits all six chunk kinds so the witness proves the property that matters: `decode(encode(pixmap))` recovers the pixmap **byte-for-byte**, across a pattern that exercises every op. Bounds named at construction; ≥2 asserts per function.
- **HUNK1 — content-addressed.** The image is a **Tablecloth** artifact: `store` beads the encoded bytes under a name, `fetch_artifact` returns exactly the bytes whose digest the name pins, and only then does the decode run — so a tampered bead refuses (`DigestMismatch`) before a single pixel is read. Content-addressed storage becomes the image's integrity guarantee for free (the pattern J8 gave the intelligence, carried to pixels).
- **HUNK2 — painted.** The decoded grid meets **Skate** — a bounded down-map from the RGBA pixels to Skate's palette-indexed cell grid (nearest-cell / block average), proven on metal (lit pixels reach the canvas), so an image is not only decoded but *seen*. Opens the single-sprite marketplace-index trick (one sprite sheet, each product a bounded window into it) as its own later rung.
- **HUNK3 — Photos gestures.** A **crop** (and the common view gestures) as a pure, bounded function over the decoded grid — the first Photos-app verb, built on the open module, never on a proprietary one.

## Discipline this round keeps

- **Clean-room.** QOI enters through the spec and the gratitude note, never through its C source ([gratitude-licenses](../.claude/rules/gratitude-licenses.md)).
- **Two rooms.** Every claim here becomes a green `mycelium`-shaped witness (`tools/hunk_qoi_witness.rish`, and one per later rung) or it stays named intent, not settled fact ([the two rooms](../context/TWO_ROOMS.md)).
- **Bounds, widths, asserts.** `u32` in-memory dims/indices, `u8` channel bytes, wire is bytes; every buffer names a maximum; each function states its invariants positively (TAME).
- **Gates stay the fence.** No rung of this quest touches funds, keys, provisioning, or the network — buying hardware and sourcing real parts are Season A's later, gated rounds.

---

*A picture is only ever a hunk of honest bytes that a reader can decode the same way twice. May this small codec stay plain enough to hold in one hand on its ten-thousandth decode, and may every image the tree ever shows rest on an open format no one had to ask permission to read.*
