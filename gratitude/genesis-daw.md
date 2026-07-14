# Genesis — Andrew Kelley's digital audio workstation

**License:** **GPL-3.0** (see upstream `LICENSE` in `andrewrk/genesis`) — **gitlink / clean-room only**; we never copy Genesis source into **Lotus** or any Rye module.

**Sources:**

- Project: <https://github.com/andrewrk/genesis> (Genesis Digital Audio Workstation)
- Site: <http://genesisdaw.org/>
- Kelley intro to Zig: <https://andrewkelley.me/post/intro-to-zig.html>

**Role for us:** Genesis is why **Zig exists**. Kelley paused Genesis to build a language that could hold the hot loop — live performance where audio must never skip, hardware control without opaque third-party libraries, and craft without GC pauses or month-long Rust font fights.

**Clean room:** We honor Genesis for the **discipline**, not as code to import. Study public posts and design goals; hold the GPL repository at gitlink distance if cloned.

---

## What Genesis aimed at

From the upstream README:

- Cross-platform DAW with peer-to-peer multiplayer editing
- Complete plugin safety
- Built-in community sharing plugins, projects, and samples
- Open source music creation — collaborative, global, free

## What we carry into Lotus

- **Bound the hot loop** — no surprise allocation; prove invariants at the audio seam
- **Invent when control demands it** — libsoundio-style ownership of the stack
- **No C++ dependencies in the performance path** — only Zig and C where necessary
- **Bare-metal kin** — Aurora and RISC-V share the same horizon as a sovereign studio

Kelley's CoRecursive interview and blog are the primary study surface alongside this note. The essay [`../external-research/20260630-030312_the-hot-loop-as-the-forge.md`](../external-research/20260630-030312_the-hot-loop-as-the-forge.md) draws out the lesson for Brushstroke and Lotus. **Lotus** is our own DAW name; Genesis stays in gratitude as the forge that birthed the language we build with.

---

## GPL-3.0 — study boundary

Genesis is copyleft. We study concepts and public writing; we do not link Genesis into Rye binaries we ship. Full license text lives in the upstream repository.
