# Inference Stack Lap 1 — Corpus Query and Matrix Add

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3
**Stamp:** `20260710.134200`

## Thinking trace

Kaeden said keep going. Next mechanical stops from lap 0 close: Anvil corpus query (Tablecloth-query shape — optional filters, every match in held order) and Lattice elementwise add before ROCm or Pond seams.

Anvil lap 1 adds `CorpusQuery` with optional `kind` and `path_prefix`, copies chunk paths into inline buffers (fixes dangling slices from lap 0 parse), and proves rye/rish/prefix hits plus overflow refusal. Lattice lap 1 adds `add` with the same shape asserts as matmul.

## Observations

- Parity **215 → 217** with two witnesses; lap 0 witnesses unchanged (full selftest covers all laps).
- ROCm host seam and Lantern-in-Pond remain correctly held.

## Files

| File | Why |
|------|-----|
| `anvil/anvil_core.rye` | `CorpusQuery`, `query_corpus`, inline path storage |
| `anvil/anvil.rye` | Query welcome + overflow unwelcome |
| `lattice/lattice_core.rye`, `lattice/lattice.rye` | `add` op + selftest |
| `tools/anvil_corpus_lap2.rish`, `tools/lattice_lap2.rish` | witnesses **216**–**217** |
| `tools/parity.rish`, `TASKS.md`, `ROADMAP.md`, READMEs | wired indexes |

**Recommend:** keep going to **Scribble lap 1** — extract `rye_fence` bodies from a session-log fixture as training snippets (single-module, composes with Anvil query by path_prefix `session-logs/`). **Check in with Claude** before Mantra/Tablecloth tilak bridge (`anvil:rye` leaves) — that is a cross-module seam.
