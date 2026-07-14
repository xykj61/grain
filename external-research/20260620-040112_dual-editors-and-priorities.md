# 969 · Dual Editors and Priorities — What Two Agents Teach About Growing a System

*An honest assessment of tonight's dual-editor session: Claude Opus 4.6 in Claude Code (Zed), Cursor Composer 2.5 in Cursor. What each built, where each excelled, whether we are prioritizing Rye and Rishi enough, and what the balance teaches about how a system grows.*

**Language:** EN
**Version:** `20260620.040112` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy; honest reckoning
**Status:** Research

---

## What Each Agent Built Tonight

### Cursor Composer 2.5 (Sonnet-class, in Cursor)

Cursor built **five new running programs** in Rye:

1. **`caravan/twin.rye`** — two children, separate gardens (128 / 192 bytes). Grew bounded into multi-child.
2. **`caravan/chain.rye`** — ordered startup: wake → prove; per-stage restart; the chain does not rewind. The s6 chain-loading discipline on hosted ground.
3. **`brushstroke/seed.rye`** — the first Brushstroke code. Frame as a value, stdout redraw. Hosted, humble, running.
4. **`brushstroke/wayland_seed.rye`** — a **real Wayland window**. xdg-shell toplevel, SHM buffer filled from a Frame value, compositor commit. Native display code in Rye.
5. **`comlink/hosted_wire.rye`** — a **sealed datagram over localhost UDP**. Ed25519 signing, X25519 key agreement, ChaCha20-Poly1305 AEAD, SHA3-512 content naming. Two processes, one wire.

Cursor also created three design documents (976 seed vocabulary, 977 flow of values, 978 horizon modules), made the parity-selftest purely Rishi, swept the garden vocabulary, and synced documentation.

### Claude Opus 4.6 (1M context, in Claude Code / Zed)

Opus built **two new running programs** and **eleven research and design documents**:

1. **`caravan/bounded.rye`** — supervision + Tally garden composed. The step between seed and microkernel.
2. **`aurora/src/deciding.rye`** — four-stage relay that chooses what runs next. Clean exit on QEMU RISC-V.

Rishi builtins: `read-file`, `write-file`, `list-dir`, `lines`, `starts-with`. Paren depth fix across all parsers. Additive gate migrated to Rishi. 12 TAME assertion fixes. Strengthening pass 9988 (16/16 witnesses GREEN).

Research: s6/SixOS/Nix/infuse (974), Wayland/compositor (972), editors/remoting (971), Mantra forge (973). GPL compliance analysis. Multi-license strategy.

Siloed designs: the whole system (983), the microkernel (984), the forge (982), the desktop (981), the editor (980), Comlink remoting (979).

---

## Where Each Excels

| Dimension | Cursor Composer | Claude Opus 4.6 |
|-----------|----------------|-----------------|
| **Implementation velocity** | Five programs in one session — twin, chain, Brushstroke seed, Wayland window, UDP wire | Two programs; more builtins and fixes |
| **Display layer** | Got a Wayland window open with xdg-shell and SHM buffers | Studied architecture; wrote design briefs |
| **Networking** | Got sealed datagrams over real UDP sockets | Studied protocol design; wrote Comlink remoting brief |
| **Strategic depth** | Three design docs (seeds, flow, horizon) | Eleven research + six siloed designs |
| **Context capacity** | Standard context; focused on current task | 1M context; holds the full project state across sessions |
| **TAME enforcement** | Follows assertions and bounds in new code | Audited 62 gaps; fixed 12; wrote TAME Style spec |
| **Radiant voice** | Good; occasional mechanical phrasing | Stronger; more natural flow |
| **Research breadth** | Narrower; implementation-focused | Broader; GPL law, multi-license, forge vision, compositor study |

The honest summary: **Cursor's implementation velocity is impressive.** Five running programs — including a Wayland window and a crypto UDP wire — is substantial. The code follows TAME style, grows the Caravan arc correctly, and advances the system's living code.

**Opus's strategic depth is the complement.** The whole-system map, the forge vision, the GPL compliance analysis, the multi-license strategy, the TAME Style spec — these are the decisions that shape what the code becomes. The 1M context window holds the full project state, which is why the siloed designs are comprehensive.

**Both together are stronger than either alone.**

---

## Are We Prioritizing Rye and Rishi Enough?

The honest reckoning:

**The code is advancing.** Tonight's combined session produced seven new running programs (Cursor's five + Opus's two), five new Rishi builtins, and a strengthening pass. The Caravan arc grew from seed to chain-loading. Brushstroke opened its first window. Comlink sent its first UDP datagram.

**The design is ahead of the code.** Twenty active-designing documents now exist. The system is designed from boot to forge. Yet some of these designs name modules (Scribble, Lantern, Lattice) that are far-horizon — important to name, yet not important to build now.

**The priority counsel:**

1. **More Rye implementation time, less new research.** The design layer is comprehensive; the next value comes from building, not from studying more projects.
2. **Strengthen what we built.** The assertion backlog has ~50 locations. The strengthening witnesses should grow with each new program.
3. **The Brushstroke Wayland seed is the most important new code.** It opens the display layer — the path to the Pond GUI. Growing it toward text rendering (Skate) is the highest-leverage next step.
4. **The Comlink hosted wire is the most important networking code.** It carries real crypto over real sockets. Growing it toward the device wire (virtio-net) is the next rung.
5. **Rishi needs more builtins for real scripting.** `trim`, `slice`, `length`, `for-each` would let the additive gate run without awk and let configuration scripts express real behavior.

**The balance going forward:** roughly two-thirds implementation (Rye code, Rishi builtins, strengthening), one-third design and research. Build catches up to design.

---

## What Two Editors Teach

Having two agents — one fast at implementation, one deep at strategy — mirrors the very architecture we are building. Cursor is the Rishi hand: terse, fast, typed, doing the immediate work. Opus is the design layer: holding the full context, naming the direction, enforcing the discipline.

The system grows best when both are active. Implementation without strategy drifts; strategy without implementation is prose. Tonight proved that the dual-editor setup (documented in `SOURCE.md` and `context/specs/enclosure-editors.md`) is not a convenience — it is a method, and it earns its keep.

---

*May we build more than we design, and design only what we mean to build. May the code catch up to the prose, and may both carry the same TAME discipline — safety first, performance second, and the joy of the craft sustaining the whole endeavor.*
