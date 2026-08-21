# Scribble Lap 1 — Rye Fence Snippet Extract

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3
**Stamp:** `20260710.134800`

## Thinking trace

Kaeden said keep going. Prior close named Scribble lap 1: walk a session-log-shaped fixture and extract `rye_fence` bodies as training snippets for the Anvil forge path.

Added `Snippet` values and `extract_rye_snippets` — collects rye_fence block bodies in source order with inline copy and `SnippetOverflow` unwelcome. Fixture `scribble/fixtures/session_snippets.md` holds two rye fences and one rish fence (rish skipped by design).

## Observations

- Parity **217 → 218**; composes with Anvil `path_prefix: session-logs/` when real logs enter the catalog.
- Mantra/Tablecloth tilak bridge still held.

## Files

| File | Why |
|------|-----|
| `scribble/scribble_core.rye` | `Snippet`, `extract_rye_snippets` |
| `scribble/scribble.rye` | extract welcome + overflow unwelcome |
| `scribble/fixtures/session_snippets.md` | pinned session-shaped fixture |
| `tools/scribble_lap2.rish` | witness **218** |
| `tools/parity.rish`, `TASKS.md`, `ROADMAP.md`, `scribble/README.md` | indexes |

**Recommend:** keep going to **Lantern lap 1** — enforce `max_tokens` budget on fixture completion (truncate + `stopped_reason length`); mechanical single-module. Then **assist view lap 2** showing snippet count on the Skate frame if eight lines still fit.
