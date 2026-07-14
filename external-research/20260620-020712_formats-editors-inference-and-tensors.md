# 970 · Formats, Editors, Inference, and Tensors — What the Horizon Modules Inherit

*Six open threads share one through-line: values that cross seams without losing their shape. This research reads JSON and Brix together, surveys markdown parsers in Zig and Rust, studies Zed's editor architecture and GPUI's permissive frame discipline, and reads Ollama, Tinygrad, PyTorch, and TensorFlow for what **Scribble**, **Lantern**, **Lattice**, and **Anvil** should become in tame Rye. The distilled design lives in silo at `../active-designing/20260620-020712_scribble-lantern-and-lattice.md`.*

**Language:** EN
**Version:** `20260620.020712` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## The Shared Question

Every format we adopt, every surface we draw, every model we run — does it speak **values**, or does it smuggle behavior across a wire? Rich Hickey named the pattern early: JSON, EDN, and their kin won because they carry data; RPC schemes that shipped code lost. Our stack already keeps one value model from Rishi through Mantra, Brix, Pond, and Comlink (`983`). The horizon work extends that line outward: **Brix** and JSON as one grammar, **Scribble** for human-readable docs, a GPU-aware editor layer beside Kakoune-shaped editing (`971`, `980`), and **Lantern** / **Lattice** / **Anvil** for inference and tensors — each bounded, each enclosed, each honest about what it owns.

---

## JSON Unified with Brix

### What JSON Teaches

JSON is the interchange face the world already speaks: strings, numbers, booleans, null, arrays, objects. It is deliberately small. It carries no behavior. It round-trips through every language. Its weakness is the same as its strength — it names nothing globally, validates nothing at the boundary, and offers no stated limits on depth or size unless the reader imposes them.

### What Brix Already Is

Brix is the composing language: a course of named bricks, declared in plain key-value lines today (`.brix` at the repository root). Mantra parses it directly. Each `file` entry names one brick; `name` and `version` declare the project. The descriptor is data, not a command — the same discipline JSON keeps, with project-specific keys layered on top.

### The Unification

The recommendation is not a second format beside Brix. It is **one value grammar**:

| Layer | Role |
|-------|------|
| **Brix surface** | Human-editable course descriptors, brick lists, Pond policies, editor settings — key-value lines today, nested records as the language grows |
| **JSON wire** | Interchange with the outside world, Forge APIs, Comlink messages where text serialization is required |
| **Rishi literals** | The same records in the shell — no translation layer between what you type and what Brix stores |

A Brix brick record and a JSON object describing that brick should be the same shape: field names identical, nesting identical, serialization a mechanical mapping. Tablecloth holds the hashed artifacts; Brix names the composition; JSON is how a brick record crosses a HTTP boundary or lands in a log. TAME bounds apply at parse time: maximum nesting depth, maximum string length, maximum array length — stated before the parser runs, asserted at the door.

**Lesson:** Hickey's observation that systems talk in values is the license to unify. Brix grows from the `.brix` descriptor already in Mantra; JSON is its wire face, not a rival format.

---

## Scribble — Markdown for Docs Surfaces

### The Need

Mantra views, Forge pages, and research itself are written in Markdown today. A tame Rye parser — **Scribble** — turns human prose into a value tree (headings, paragraphs, links, code fences) that Brushstroke and the Forge can render without shelling out to another language. The parser must be bounded: input size cap, nesting depth cap, allocation budget per document, failure named loudly.

### Zig Candidates (Permissive)

| Project | License | Notes |
|---------|---------|-------|
| **Zmd** (Jetzig) | MIT | Pure Zig, zero dependencies; Markdown → HTML translator; small surface, good close-reading target |
| **Koino** | MIT | Zig port of Comrak; CommonMark + GFM compatibility; larger, battle-tested against the spec |
| **md4zig** | MIT | Thin Zig wrapper around **md4c** (MIT C library); callback-driven parser; useful if we want md4c's event model without writing the lexer |

### Rust Candidates (Permissive)

| Project | License | Notes |
|---------|---------|-------|
| **pulldown-cmark** | MIT | Pull parser for CommonMark; fast, widely used, optional GFM extensions; excellent spec reference even for a clean-room Zig port |
| **Comrak** (via Koino) | MIT | GFM superset; Koino already ports it to Zig |

### What Scribble Should Inherit

- **Pull parsing, not DOM-first.** Stream events (start heading, text, end heading) into a value list without retaining the whole document twice.
- **Stated limits before parse.** Maximum bytes, maximum heading depth, maximum link count — TAME at the boundary.
- **No HTML execution.** Scribble produces a value tree or a safe static HTML string; script tags and raw HTML injection are declined or escaped by policy.
- **Clean-room Rye implementation.** Study permissive parsers in `gratitude/` or public repos; ship Scribble in Rye on our ground. md4c may be linked only if LGPL obligations are respected — prefer pure Zig/Rye paths first.

**Lesson:** Zmd and pulldown-cmark are the two best close-reading targets: small, MIT, and explicit about the CommonMark contract. Koino bridges them if we want GFM tables and task lists on day one.

---

## Zed, GPUI, and the GPU Editor Layer

### Licenses (Gratitude Boundaries)

| Component | License | How we hold it |
|-----------|---------|----------------|
| **Zed editor core** | GPL-3.0-or-later | Public design study only — same boundary as River (`997`) |
| **GPUI** (UI framework) | Apache-2.0 | Reusable patterns; may be read and studied for frame discipline |
| **Tree-sitter** | MIT | Parser generator Zed co-created; grammar files are the model for syntax highlighting |
| **Collab / cloud services** | AGPL-3.0 | Out of scope for our forge; we build sovereign Pond enclosures instead |

### What Zed Teaches (TAME-Aligned)

- **Core/UI separation.** The editor logic runs apart from the GPU renderer; they communicate through a typed protocol. This matches Neovim's headless model and Brushstroke's value-in, frame-out discipline (`971`).
- **GPU-accelerated text.** Every frame redraws from state; the grid is a value, not a retained widget tree. Skate already targets this pattern for the terminal (`981`).
- **Multiplayer as shared state.** Collaborative editing is state synchronization, not byte streaming — the same Comlink-shaped insight applied to buffers.
- **Tree-sitter-shaped syntax.** Grammars compile to a shared incremental parser; highlights and folds follow syntax trees, not regex hacks.

### What to Decline

- **Shipping Rust.** Our editor extends `980` — select-then-act, Brix settings, Rishi behavior — on Brushstroke + Skate in tame Rye.
- **GPL source incorporation.** Study architecture and public blog posts; implement on our ground.
- **A fourth configuration language.** Modes and keymaps remain Rishi values; layout remains Brix.

**Lesson:** GPUI's Apache-2.0 frame model and Tree-sitter's MIT grammar pipeline are the permissive gifts. Kakoune's editing model (`980`) plus Zed's performance model is the synthesis we aim for.

---

## Lantern — Local Inference (Ollama-Shaped)

**Ollama** (MIT) runs large language models locally: pull a model by name, serve inference over a simple HTTP API, manage model files on disk. It composes llama.cpp and related runtimes under the hood.

**What Lantern should inherit:**

- **Model as a named artifact.** Content-addressed weights in Tablecloth; Brix declares which models a Pond may load.
- **Inference inside Pond.** Each run is enclosed: memory cap in Tally, no network unless the policy grants it, stdout/stderr bounded.
- **Value-based API.** Request and response are records (prompt, temperature, max tokens → completion text, token counts) — not an unbounded stream unless the policy explicitly enables streaming chunks as values.
- **Pull, then run.** The operator names a model; Lantern fetches or verifies the hash, then loads into a bounded garden.

**What to decline:**

- **Opaque bundled runtimes without license audit.** Ollama's dependency tree mixes MIT and other terms; we study for behavior, implement inference ground in Rye, and link only what gratitude licenses allow.
- **Always-on daemon without Caravan.** Lantern runs under supervision; a crashed inference worker restarts clean.

**Lesson:** Ollama proves local inference is practical and pleasant. Lantern carries the enclosure and value discipline Ollama leaves implicit.

---

## Lattice — Tensors and Autograd (Tinygrad-Shaped)

**Tinygrad** (MIT) is a minimal tensor library: explicit operations, autograd, multiple backends (CPU, GPU), small enough to read in an afternoon. George Hotz and contributors optimized for **understandability over framework sprawl**.

**What Lattice should inherit:**

- **Smallest honest tensor surface.** Rank, shape, dtype, stride stated at creation; operations assert compatible shapes at the door.
- **Buffers in Tally gardens.** A tensor's storage is a bounded region; overflow fails with a named error, never silent corruption.
- **Autograd as a value graph.** The computation graph is a record of operations — replayable, inspectable, bounded in node count.
- **Parity-gated numerics.** Add, multiply, matmul, and reduction primitives pass through the strengthening series before any model code ships.

**What to decline:**

- **Python as the implementation language.** Lattice is Rye; Tinygrad is the close-reading guide, not the runtime we embed.
- **Unbounded graph growth.** Training steps have a stated maximum graph size or checkpoint interval.

**Lesson:** Tinygrad is the preferred teacher over PyTorch and TensorFlow for our horizon — small enough to port principles, MIT-clean, aligned with TAME's "state the limit" habit.

---

## Anvil — Training Scale (PyTorch / TensorFlow-Shaped, Far Horizon)

| Project | License | Scale |
|---------|---------|-------|
| **PyTorch** | BSD-style | Full training framework, dynamic graphs, vast ecosystem |
| **TensorFlow** | Apache-2.0 | Static graph + eager modes, production deployment focus |

**Anvil** is the name reserved for training-framework scale — distributed training, checkpointing, dataset pipelines — **only after Lattice proves the numeric ground**. Until then, Anvil is study-only: what PyTorch gets right about operator coverage, what TensorFlow gets right about serving graphs, and what both do that violates TAME (hidden allocation, implicit GPU sync, unbounded autograd retention).

**Lesson:** Read Anvil's teachers for discipline; grow Lattice first. A forge that trains models is a Pond job with a Caravan supervisor and a Tablecloth of checkpoints — Anvil names that world, yet the first brick is a single matmul that passes the parity gate.

---

## Recommendations — What Crosses into Active Design

1. **Unify JSON and Brix now** in spec — one record grammar, three faces (`.brix` lines, JSON wire, Rishi literals).
2. **Scribble seed** — CommonMark subset parser in Rye; close-read Zmd and pulldown-cmark; bounds at the door.
3. **Editor** — extend `980` with GPU frame discipline studied from GPUI; Tree-sitter-shaped syntax as a later Scribble sibling or shared grammar crate.
4. **Lattice before Lantern before Anvil** — numeric primitives, then local inference, then training scale.
5. **Every module Pond-enclosed** — inference and tensors are high-risk; policy-as-a-value is non-negotiable.

The siloed design brief at `../active-designing/20260620-020712_scribble-lantern-and-lattice.md` states these modules on our own ground.

---

*Values in, values out — across prose, bricks, pixels, and tensors. The horizon modules extend the line we already hold; they do not fork it.*
