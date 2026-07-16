# Quin's Dispatch Loop — Pseudocode Over the Four Voices' Real APIs

**Language:** EN
**Version:** `20260715.183700` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Design exploration only — no vane code, no new type landed anywhere. Register: design/research (Two Rooms — proposal, not a bound claim). Every signature quoted below is real, read directly from the four voices' own `_core.rye` files; every Quin-side type is proposed, unbuilt.

---

## Why This Doc, and Why Now

Quin is confirmed (`context/specs/20260713-235600_names-awaiting-confirmation.md`) as the inference **Q-vane** — the fifth thing four already-built voices make together — yet it is also named as **kernel-quiet**, built only "when Glow can host an agent." No pseudocode has ever walked through what Quin's own dispatch loop actually does, turn by turn, against the four voices' real, current APIs. This is the most abstract genuinely unimplemented design surface in the tree today: everything Quin would sit atop already exists and is green; Quin itself is zero lines, by design, waiting on a gate that has not yet opened. Written while Keaton is away from the keyboard, to have on hand rather than to build.

## The Four Voices, As They Actually Are Today

Pulled directly from each module's own `_core.rye`, not paraphrased:

**Lattice** (`lattice/lattice_core.rye`) — bounded `f32` tensors, `max_dim: u32 = 8`. Core type `Matrix{ rows, cols, data }`. Representative ops: `matmul(a, b, out) TensorError!void`, `softmax`, `sigmoid`, `reduce_sum`. Every op takes pre-shaped output buffers and returns `error.ShapeMismatch` rather than allocating — no hidden growth, ever.

**Lantern** (`lantern/lantern_core.rye`) — the bounded request/response contract. `Request{ model_hash, prompt, max_tokens, temperature, seed, top_p, stop_sequence, ... }`, capped by named constants (`max_prompt_len: u32 = 256`, `max_budget_tokens: u32 = 512`). `Response{ text, tokens_in, tokens_out, stopped_reason: StoppedReason }`. The real entry points: `validate_request(req) LanternError!void`, `complete_fixture(req, fixture_text) LanternError!Response`, `complete_allowed(req, fixture_text, allow_text) LanternError!Response` (the allow-list gate before completion).

**Anvil** (`anvil/anvil_core.rye`) — the corpus catalog. `Chunk{ path, kind: ChunkKind, lines }`, `Catalog{ chunks: [max_chunks]Chunk, count }` with `max_chunks: u32 = 64`. Query shape: `CorpusQuery{ kind, path_prefix, path_suffix, min_lines, max_lines }`, dispatched through `query_corpus(catalog, query, out_indices) CorpusError!u32` or `sum_lines(catalog, query) u32`.

**Scribble** (`scribble/scribble_core.rye`) — markdown to bounded value blocks. `Block{ kind: BlockKind, depth, lang, text }`, parsed by `parse_markdown(text, out) ParseError!u32` (`max_doc_bytes: u32 = 8192`). Extraction helpers: `extract_rye_snippets`, `extract_headings_at_depth`, `count_fence_kinds`.

The pattern across all four, worth naming once rather than four times: **every function takes pre-sized output storage and a query/request struct, and returns a bounded count or an explicit error — nothing grows, nothing allocates mid-call, every overflow is a named error rather than a panic.** Quin's own dispatch loop has to keep this promise, not merely sit on top of modules that keep it.

## What Quin Is Proposed to Add — a Bounded Turn, Not a New Primitive

Quin does not reimplement inference, corpus search, or markdown parsing — it composes the four calls above into one **turn**, TAME-bounded the same way each voice already bounds itself. The proposed shape, named plainly as unbuilt:

```
// PROPOSED — quin/quin_core.rye, unwritten. Mirrors the four voices' own
// bounded-struct-plus-error-return shape; introduces nothing they do not
// already model.

const max_turn_context_chunks: u32 = 8;   // Anvil results folded into one turn
const max_turn_snippets: u32 = 4;         // Scribble extracts folded into one turn

const QuinError = error{
    ContextOverflow,
    SnippetOverflow,
} || lantern.LanternError || anvil.CorpusError || scribble.ParseError;

const QuinTurn = struct {
    // The bounded request a caller actually wants answered.
    prompt_source: []const u8,        // raw markdown/text, <= scribble.max_doc_bytes
    corpus_query: anvil.CorpusQuery,  // what context to pull, if any
    lantern_request: lantern.Request, // the bounded completion ask itself
    allow_list: []const u8,           // Lantern's own model allow-list fixture
};

const QuinResult = struct {
    response: lantern.Response,
    context_chunks_used: u32,   // <= max_turn_context_chunks
    snippets_folded: u32,       // <= max_turn_snippets
};
```

## The Dispatch Pseudocode

```
fn run_turn(turn: QuinTurn, catalog: *const anvil.Catalog) QuinError!QuinResult {
    // Step 1 — Scribble: the raw source becomes bounded blocks. Fails loud
    // and early (DocTooLarge, BlockOverflow) exactly as scribble_core.rye
    // already does; Quin adds no new size check here, it inherits Scribble's.
    var blocks: [scribble.max_blocks]scribble.Block = undefined;
    const block_count = try scribble.parse_markdown(turn.prompt_source, &blocks);

    // Step 2 — Scribble: pull the rye/rish snippets a corpus-aware prompt
    // likely wants folded in, capped at Quin's own turn-level bound (not
    // Scribble's document-level bound -- a turn may want fewer than a
    // whole document's worth).
    var snippets: [max_turn_snippets]scribble.Snippet = undefined;
    const snippet_n = try scribble.extract_rye_snippets(blocks[0..block_count], &snippets);
    if (snippet_n > max_turn_snippets) return error.SnippetOverflow;

    // Step 3 — Anvil: resolve the corpus query against the already-loaded
    // catalog, bounded at Quin's own turn-level chunk cap. query_corpus
    // itself already refuses to overflow its own out_indices buffer
    // (ResultOverflow) -- Quin's cap is a *tighter* bound layered on top,
    // not a replacement for Anvil's own.
    var context_indices: [max_turn_context_chunks]u32 = undefined;
    const context_n = try anvil.query_corpus(catalog, turn.corpus_query, &context_indices);
    if (context_n > max_turn_context_chunks) return error.ContextOverflow;

    // Step 4 — Lantern: the actual bounded completion ask, gated through
    // the allow-list exactly as complete_allowed already enforces (empty
    // allow-list refused, model membership checked before anything runs).
    // Quin does not touch temperature/top_p/seed bounds -- those stay
    // entirely Lantern's own validate_request concern.
    const response = try lantern.complete_allowed(
        turn.lantern_request,
        fixture_for(turn.lantern_request.model_hash), // resolved by caller, not Quin
        turn.allow_list,
    );

    return .{
        .response = response,
        .context_chunks_used = context_n,
        .snippets_folded = snippet_n,
    };
}
```

**What this pseudocode deliberately does not do:** call Lattice. That absence is honest, not an oversight — none of the four voices' real current APIs produce an embedding vector or a scored-similarity ranking Lattice's own `Matrix` ops could consume; `Anvil`'s query is purely structural (path/kind/line-count filters), not semantic. A future lap where Anvil's catalog carries embeddings, scored by Lattice's `matmul`/`softmax` against a query vector, would be the natural place Lattice actually enters a turn — named here as a real, later rung, not folded in prematurely just to use all four voices in one pass.

## The Halting Bound, Named Explicitly

The composed loop above runs each of the four calls **at most once per turn**, in a fixed order, with no branch that could re-enter Scribble, Anvil, or Lantern from within the same turn. This matters more than it looks: an inference dispatch loop is exactly the kind of code that silently grows a retry-until-success while-loop over time, and TAME's own root discipline (bounded execution, no `usize`-shaped unbounded growth) applies to *control flow*, not only to buffer sizes. If Quin ever wants retries (a failed Lantern call retried with a shorter prompt, say), that is a **second, explicit rung** — `max_retries_per_turn: u32`, a named bound, never an open `while (true)`.

## Where the Sandbox Composition (Already Confirmed) Meets This Loop

The prior Quin research (`external-research/20260714-042545_quin-q-vane-inference-voices.md`) already settled that nested agent-testing sandboxes are **Quin × Puddle × Neth**, composed rather than a new vane. `run_turn` above is exactly the unit Puddle would spawn into an ephemeral, snapshot-able region, and exactly the unit Neth's seeded deterministic harness would replay byte-for-byte: `QuinTurn` is already a plain, serializable struct (no hidden state, no open handles), so seeding its `lantern_request.seed` and freezing `catalog` as a fixture input is sufficient for byte-identical replay — the same "same inputs, same outputs, no ambient state" discipline Neth's own laps already prove for settlement, applied here to one inference turn instead of one ledger root.

## What Would Actually Gate This Open

Per the vane's own settled build timing: "built when Glow can host an agent." Concretely, that gate is **Lantern moving past `complete_fixture`/`complete_allowed`'s fixture-served laps into a real, live model backend** — until a `Request` resolves against something other than a pinned fixture text, there is no live turn for Quin to dispatch, and this pseudocode stays exactly what it is today: a design a future lap can pick up verbatim, not a promise of working code.

## Related

- `external-research/20260714-042545_quin-q-vane-inference-voices.md` — the vane's own naming, confirmation, and sandbox-composition decision this doc assumes settled.
- `context/specs/20260713-235600_names-awaiting-confirmation.md` — Quin's confirmed entry, build timing named.
- `lattice/lattice_core.rye`, `lantern/lantern_core.rye`, `anvil/anvil_core.rye`, `scribble/scribble_core.rye` — the four real modules every signature above is read from, not paraphrased.
- `context/TAME_GUIDANCE.md` — the bounded-execution discipline this pseudocode extends to control flow, not only buffer sizes.

---

Four voices already sing on their own; this is only the page where the fifth part — never a new instrument, only the turn that lets the four play in time — gets written down before anyone plays it.
