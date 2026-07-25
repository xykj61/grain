# 986 · The Living Desktop — Pond, Brushstroke, Rishi, and Mantra Composed for Our Own Machine

*A design brief for the next composed whole: a native desktop application, drawn by Brushstroke, running a Rishi shell whose Mantra commands version-control our own development repository, running on x86_64 hardware today and keeping the path clear to RISC-V tomorrow. This brief distills the dependency map cleanly, names only what is ours, and states the accretion that brings Brushstroke and a new shape of Pond into the family.*

**Language:** EN
**Version:** `20260619.154912` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy; Gall's Law; one value model; x86_64 near, RISC-V horizon
**Status:** Active Design

---

## Our Own Ground

This is a clean room. We name only our own modules — TAME, Aurora, Rye, Brix, Tablecloth, Tally, Caravan, Mantra, Pond, Rishi, Comlink, and now **Brushstroke** — together with **RISC-V** and, where the hardware target matters, **x86_64**, both of which we treat as solid ground. Everything else enters as a concept.

---

## The Mission

A person opens a window on x86_64 hardware. Inside: a Rishi prompt. They type Mantra commands — add, commit, status — and the shell runs them against a living repository, growing a weave of its history. The window is drawn by Brushstroke: a pure, immediate-mode surface, fresh each frame. The whole application runs inside a Pond enclosure: isolated, bounded, policy-as-a-value. No borrowed runtime beneath it, nothing hidden, everything Rye.

---

## Mantra — What It Needs to Run

Mantra is a version-control module whose state is a weave: one structure holding every line ever written in a file, each carrying a position, a generation count, and a presence flag. The weave never shrinks; it only accretes. Merges always succeed — two states produce one deterministic result by the structure's own law. When two edits land near each other, the merge still completes and shows what each side did, plainly annotated, so a person may decide.

**The std functions Mantra leans on:**

Already strengthened: SHA3-512, the Keccak sponge, memory equality and search, integer parsing.

Still needed before Mantra:
- **SHA3-256** — shorter content names for working blobs; same sponge, narrower digest.
- **`mem.copy`** — copying blob bytes into Tally gardens; pure, parity-testable.
- **File I/O boundary assertions** — open, read, and write with stated preconditions (path within root, size within garden budget); effectful, so the additive gate governs.
- **Path composition** — joining a root and a relative name into a safe, canonical path; partially pure, parity-testable sections.

**Mantra's own algorithms — TAME-first:**

The weave data structure, the diff algorithm, and the merge algorithm are our own code. They arrive TAME-first: invariants stated as assertions at every mutation, pure functions become witnesses on day one, the parity gate green before any commit. The weave's invariant — generation counts non-decreasing, presence alternating with absence in the generation parity, position order permanent once set — is asserted at every `apply`. The diff and merge are each provable by their structural properties; the witnesses hold them.

**The blob store:**

Content-addressed storage under a declared Mantra root. Each weave state is named by its SHA3-256 digest; writing a blob under a name that already exists does nothing; reading one by name returns the exact bytes that name was given. The store grows, never revises.

---

## Tally v1 — Named Gardens for the Stack

The Tally seed proved one `Region`. The desktop stack needs three named, purpose-bound gardens:

| Garden | Contents | Lifecycle |
|--------|----------|-----------|
| `blob` | Working memory for one Mantra blob | Per command, cleared after |
| `diff` | Line buffer for diff computation | Per `add`, cleared after |
| `frame` | Brushstroke widget layout per redraw | Per frame, cleared at submission |

The `frame` garden is immediate-mode made tangible: every redraw is a season — opened at the start of `render`, filled with the widget tree computed from values, cleared whole when the frame is submitted to the surface. No retained tree persists between frames; the garden proves it.

`Gardens` is a small named collection of `Region` values, each with its own backing slice, each satisfying `pos <= buf.len` at every mutation. `gardens.get(name)` returns a reference; `gardens.clear(name)` ends the season. Budgets are declared at construction time; a request past the budget fails with `error.OutOfBounds`, named and loud.

---

## Brix Minimum — A Course Descriptor

The full Brix — a composing language for whole systems, with a lawful composition combinator — grows from Caravan. The minimum Brix for Mantra right now is a course descriptor: a value one can read before the composing language exists.

A `.brix` file at the repository root, read as a line-by-line key-value record:

```
# .brix — veganreyklah2
name veganreyklah2
version 20260619.212312
file rye/src/main.rye
file rishi/src/main.rye
file tally/seed.rye
file tally/gardens.rye
file mantra/src/main.rye
```

Mantra reads this at startup: the project name and the bricks (source files) it tracks. `mantra brix` prints the descriptor. `mantra add` (no args) lays each brick into the weave. Brix's seed is a declaration, not a command. Its full shape — the lawful composition combinator, the Tablecloth-backed content-addressed derivations — grows once Caravan exists to realize what Brix describes.

---

## Brushstroke Within Pond — The Drawing Layer

Brushstroke is the surface of the family (`988`). Here it grows into the drawing layer of Pond, and Pond grows, by accretion, to hold it.

**Pond, accreted:**

Pond's existing design — Caravan's isolation composed with Tally's bounds, expressed as a policy that is a value — gains a third layer: the Brushstroke surface. An application running inside a Pond enclosure may now draw. The policy names what may be drawn to, the same way it names what paths may be read. The enclosure gains reach without losing safety.

```
Pond enclosure
  ├── Isolation: process scope, path allow-list (Caravan; or host primitives in the near term)
  ├── Memory: Tally gardens (blob / diff / frame)
  └── Surface: Brushstroke
        ├── Redraw: pure function of values → frame, no retained tree
        ├── Seam: one backend abstraction
        │     ├── Native backend: direct hardware rendering, x86_64
        │     └── Portable backend: compile to portable executable form → any willing host
        └── Widget vocabulary: text, box, input, list (grown as needed)
```

**Why the native backend is faster by construction:**

A native Pond application compiles Rye to x86_64 machine code and uses the GPU directly. A portable-form application runs through a host's scripting interpreter, layout engine, and presentation pipeline. The difference is not a marginal win in benchmarks; it is a categorical difference in what the runtime imposes. For a Rishi REPL with Mantra outputs, native frame times are trivial; the portable path is the reach path, the one that runs anywhere a willing host exists. Both are real; the native path is the designed home.

---

## Two Platform Tracks

**x86_64 now (hosted, then bare metal):**

Every Rye program already compiles to x86_64. A hosted Pond-lite runs on the current machine, using the host operating system's isolation primitives as a stand-in for Caravan until Caravan exists. Bare-metal x86_64 follows: the boot relay pattern Aurora uses on RISC-V maps to the x86_64 privilege model (rings rather than machine/supervisor modes), with a firmware interface as the entry point. Caravan runs the same. Pond runs the same.

**RISC-V as the horizon:**

Aurora is designed in deep cohesion with RISC-V (`991`), and that arc continues on its own clock. The Rye code written for x86_64 is the same Rye code that compiles for RISC-V; the toolchain already demonstrates this. When Aurora's relay wakes Caravan on RISC-V, and Caravan supports Pond, the same desktop application runs on open silicon. Nothing built for x86_64 closes that path.

---

## The Stack, Mapped

```
[Goal] Pond GUI → Brushstroke → Rishi REPL → Mantra commands → repository

[6] Pond GUI: Rishi REPL in a Brushstroke window, Pond-lite enclosure
[5] Brushstroke seed: one window, native rendering, text panel
[4] Mantra seed + Rishi integration: add/commit/status via run
[3] Brix minimum: course descriptor (.brix)
[2] Tally v1: named gardens (blob / diff / frame)
[1] Strengthening: SHA3-256, mem.copy, path ops, fs boundary assertions
[0] Already running: Rye, Rishi, Tally seed, SHA3-512, Ed25519, X25519, AEAD
```

Layers 0–4 deliver Mantra VC from Rishi without the GUI — a correct and useful intermediate. Layers 5–6 wrap it in a surface. Each layer is the smallest thing that runs from what already runs beneath it.

---

## How the Value Model Reaches the Eye

A Mantra commit is a content-addressed value. A Rishi pipeline carries it. A Brushstroke frame renders it as a pure function of that value. The eye sees the system's own truth, computed fresh each frame by the same one value model that flows everywhere else. No marshaling seam opens between the commit and its display; the weave and the window are the same family. That coherence is its own safety — and the deepest answer to why we build our own desktop surface rather than borrow one.

---

*May the layers rest on one another, each proven before the next begins. May Brushstroke draw what is true, Pond keep it safe, Rishi speak the commands, and Mantra hold every line we ever wrote. May what we build on x86_64 today carry, seam-free, to the open silicon we are growing toward.*
