# 978 · Scribble, Lantern, and Lattice — Horizon Modules on One Value Grammar

*A siloed design brief for the modules that extend our stack toward human-readable docs, GPU-aware editing, local inference, and honest tensors. **Scribble** parses markdown into values. **Brix** and JSON share one record grammar. **Lantern** runs models in Pond enclosures. **Lattice** holds tensor math in Tally gardens. **Anvil** names training-scale work on the far horizon. The editor grows from `980` with GPU frame discipline on Brushstroke and Skate. This brief names only our modules and speaks only on our ground.*

**Language:** EN
**Version:** `20260620.020712` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only what is ours — **Scribble**, **Lantern**, **Lattice**, **Anvil**, **Brix**, **Tablecloth**, **Mantra**, **Brushstroke**, **Skate**, **Pond**, **Tally**, **Caravan**, **Rishi**, and **Rye** — together with **RISC-V** and **x86_64** where hardware matters. Markdown, JSON, tensors, and GPU text rendering enter as concepts. The close reading that named external teachers lives in `../external-research/20260620-020712_formats-editors-inference-and-tensors.md`.

---

## One Grammar, Three Faces

Brix describes what a system is made of. That description is already a value: records of named fields, lists of bricks, version stamps. The unification principle:

- **Brix surface** — human-editable descriptors (`.brix` today: `name`, `version`, `file` entries).
- **JSON wire** — the same records serialized for Forge APIs, Comlink messages, and interchange with tools outside Rye.
- **Rishi literals** — the same records in the shell; no shadow type system.

A parser for either face produces the same in-memory value. Shape-cast at the door: nesting depth, string length, and collection size each carry a stated maximum. A document that exceeds its budget fails with a named error before allocation grows.

Tablecloth stores the content-addressed artifacts Brix names. JSON does not replace Tablecloth — it carries brick *descriptions*, while Tablecloth carries brick *bytes*.

---

## Scribble — Markdown as Values

Scribble turns human prose into a value tree the rest of the stack can render and diff.

**Input.** A bounded byte slice — a file from Mantra, a Forge page, a research document.

**Output.** A list of block values: headings, paragraphs, code fences, links, lists. Each block is a record with a `kind` field and typed children. Scribble never executes code embedded in prose; code fences are opaque strings until a downstream module chooses to highlight or run them under Pond policy.

**Invariants.**

- Maximum document bytes stated at `parse` entry.
- Maximum heading depth and list nesting depth asserted during the walk.
- Maximum link count and code-fence count — soft guards against adversarial expansion.
- Allocation from a Tally garden; the garden clears when the parse completes.

**Consumers.** Mantra renders weave annotations beside Scribble blocks. The Forge draws Scribble trees through Brushstroke. Research and session logs remain Markdown source; Scribble is the runtime face.

Scribble grows from a **CommonMark subset** first — headings, paragraphs, emphasis, links, fenced code — then accretes tables and task lists when a second pass earns them.

---

## The Editor — `980` Extended with GPU Discipline

The TAME editor (`980`) already holds select-then-act editing, Brix for settings, and Rishi for behavior. The horizon extension adds **GPU frame discipline** without a new configuration language:

- **Skate** owns the character grid — monospaced cells, cursor, selection highlights.
- **Brushstroke** owns the window and input events.
- **The editor module** owns buffer text, modes, undo history, and command values.

Each frame, the editor produces a styled grid value; Skate renders it. Each key event arrives as a value; Rishi maps key sequences to command values when configured. Syntax coloring consumes a Scribble- or grammar-shaped tree incrementally — parse once per saved buffer region, reuse on redraw.

Multiplayer editing, when it arrives, is shared buffer state over Comlink — the same value-sync model as remote shells (`979`), applied to text.

---

## Lantern — Local Inference in Enclosure

Lantern pulls and runs language models inside Pond.

**Model artifact.** Weights live in Tablecloth, named by hash. Brix declares which model hashes a given enclosure may load.

**Run contract.**

```
Lantern request (value):
  model:   content hash
  prompt:  string (bounded length)
  budget:  max tokens, temperature, seed

Lantern response (value):
  text:         completion string
  tokens_in:    integer
  tokens_out:   integer
  stopped_reason: enum (length | eos | error)
```

**Pond policy example.**

```
read:   [model blob by hash]
write:  [response buffer]
net:    false
mem_mb: stated per model
procs:  1
```

Caravan supervises the worker; a crash clears the garden and restarts. Lantern speaks values; streaming, when enabled, yields a sequence of chunk values with stated maximum chunk size.

---

## Lattice — Tensors in Tally Gardens

Lattice is the tensor and autograd module — small, explicit, parity-gated.

**Tensor value.**

```
Tensor:
  dtype:   f32 | f64 | i32 | ...
  shape:   list of positive integers
  strides: list of integers (compatible with shape)
  data:    handle into a Tally garden (offset, byte length)
```

**Operations** assert shape compatibility at entry. Matmul, add, reshape, and reduce each pass through the strengthening series before they ride hot paths. Autograd records operations as a list of value records — backward replay walks the list with a stated maximum depth.

Lattice comes **before** Lantern in build order: a model runtime needs matmul that has already met the parity gate.

---

## Anvil — Training Scale on the Far Horizon

Anvil names distributed training, dataset pipelines, and checkpoint rhythms — the scale PyTorch and TensorFlow occupy. Anvil opens only after Lattice holds:

- parity-green primitives,
- a single-model forward pass in Pond,
- and a Tablecloth checkpoint format named by content hash.

Until then, Anvil is a reserved name and a study direction, not a build target.

---

## Composition with the Whole

| Module | Sits beside | Provides |
|--------|-------------|----------|
| **Scribble** | Mantra, Forge | Prose as values |
| **Brix + JSON** | Tablecloth, Pond | Composition and policy as values |
| **Editor (`980`)** | Skate, Brushstroke | Text editing as values |
| **Lantern** | Pond, Tablecloth, Tally | Inference as bounded request/response |
| **Lattice** | Tally, parity gate | Tensors as bounded buffers |
| **Anvil** | Caravan, Tablecloth | Training orchestration (horizon) |

The through-line from `983` holds: a Mantra line, a Brix brick, a Scribble block, a Brushstroke frame, a Lantern completion, and a Lattice tensor are the same kind of thing — named, bounded, owned, passing as values across seams that stay closed.

---

*Scribble reads what we write. Brix names what we build. Lantern answers what we ask. Lattice counts what we learn. Anvil waits until the numbers are honest. The horizon extends the stack we already stand on.*
