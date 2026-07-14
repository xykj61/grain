# AP Mastering — Alain Paul plugin design

**License:** Mixed — AP Mastering **Versatile Compressor**, **Saturation**, and some plugins are **open source**; **Curvature** and others are commercial. We study **public product pages and YouTube design walkthroughs** only — never copy UI assets, shaders, or source into **Lotus**.

**Sources:**

- Plugins: <https://apmastering.com/plugins>
- Curvature: <https://apmastering.com/plugins/curvature>
- YouTube: AP Mastering channel (Alain Paul — plugin development, compression craft, interface design)

**Clean room:** We learn interface *principles* — tiered control surfaces, immediate feedback, skeuomorphic and expert modes in one shell — and express them in **Brushstroke** / **Lotus** with our own vocabulary.

---

## Role for Lotus

Alain Paul's plugin design complements **REAPER's workflow** with **surface craft**:

- **Tiered pages** — Retro (one-knob simplicity), Preset (guided + randomize), Expert (full engine exposed with plain labels)
- **Honest meters** — configurable decay; visual gain reduction and spectrum as first-class UI
- **RAM-conscious graphics** — optional heavy skeuomorphic layer; lightweight mode when retro assets stay off
- **Sidechain and routing made legible** — fast EQ on external chain; oversampling self-evident
- **No installer bloat** — move-in-plugin-folder simplicity; philosophy Lotus can echo for native modules

**Curvature** — multi-model compressor (including novel mathematical models); the *pattern* we honor is **one engine, many faces** — not the algorithms themselves.

Other AP plugins (Versatile Compressor, Saturation, Delta Expose) share the same design language: mastering-grade seriousness with interfaces that teach while you turn.

---

*Study surface for Lotus plugin and meter surfaces. Implementation waits for SLC-2a and the drawn terminal to run.*
