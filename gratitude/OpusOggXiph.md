# Opus, Ogg, and the Xiph.Org Way — the Concepts Beneath `.peal`

*A gratitude note of a different kind than our copyrighted-essay summaries. Opus and Ogg are **permissively licensed** open standards (BSD-style, royalty-free), so unlike `Systemantics.md` or `PathWithHeart.md` we may and do use the real format itself — this file records the concepts we lean on, and names the Glow-compatible extension we give the container in our own tree.*

**Stamp:** `20260714.023700`
**Voice:** Rio 3
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Gratitude — concepts we study and a format we use under a permissive license; our own four-letter mark name recorded plainly.

**With gratitude to:**

- **The Xiph.Org Foundation**, and the IETF working group behind **Opus** (RFC 6716), for a royalty-free audio codec that beats the proprietary options at nearly every bitrate — and for **Ogg**, the equally-free container that carries it. Both are BSD-licensed and free for anyone to implement, serve, and ship.
  - Opus: <https://opus-codec.org/> · Ogg: <https://xiph.org/ogg/>

---

## Why Opus, Plainly

For audio that must be **open, cross-platform, well-compressed, and freely servable**, Opus-in-Ogg is the strongest modern choice, and the reasons are concrete:

- **Royalty-free and BSD-licensed.** No patent toll, no license to hold — the same freedom this project prizes everywhere else. This is the crucial distinction from our copyrighted-essay gratitude notes: we are free to use the actual codec, not merely summarize it.
- **Best-in-class compression.** At the bitrates a music sketch wants, Opus is smaller and clearer than MP3, AAC, or Vorbis — a minute of stereo lands in well under a megabyte with no audible cost.
- **Universally decodable on macOS and Linux.** `ffmpeg`, browsers, and every serious audio stack decode it directly; served with a `audio/ogg` content-type it plays anywhere.
- **Clean to serve.** A single self-contained Ogg stream, no sidecar, no container gymnastics.

## The Name We Give It: `.peal`

Following this project's habit of **four-letter, Urbit/Glow-compatible names** (the vane tradition, and the Tilak type-mark family), the container in our tree carries our own extension rather than the bare `.opus`:

- **`.peal`** — our mark for a compressed audio stream (Opus codec, Ogg container, under the hood). Four letters. *Peal*: the ringing a struck bell — or a struck **anvil** — sends out. The name teaches its function the way every name in `LEXICON.md` is meant to.

**Why not `.opus` on disk?** Two honest reasons. First, clarity: in a tree that works daily beside Claude **Opus**, an `.opus` file invites a moment's confusion every time it is read; `.peal` never does. Second, consistency: our own type-marks (Tilak) and module names are ours, in our own four-letter register, even when the bytes beneath them are a format we gratefully borrow. The *bytes* are Opus-in-Ogg, standard and interoperable; the *mark* is Glow's own. Anything that needs the raw codec can rename or re-probe in one step (`ffprobe` reads it as ordinary Opus regardless of extension), so nothing interoperable is lost.

## What This Seeds

`.peal` is the first audio mark in the tree, and it opens a real design thread rather than closing one: a Glow **Tilak** for audio — a type-mark the system can `absorb`, `express`, and `tend` like any other value at a Weave seam — so that Glow code can one day process, fold over, and render a `.peal` the way it already folds over text and receipts. That thread is named in the roadmap's Realidream/Brushstroke lane; this file only records the format we build it on and the gratitude we owe for it being free.

---

*May the format we borrow stay free, may the name we give it teach its own function, and may the anvil ring true in a container anyone, anywhere, can open.*
