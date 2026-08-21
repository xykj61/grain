# recall_sync_wire + recall_catch_up snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.172139

## Prompt

kg.

## Thinking trace

Next cluster after `recall_lap1` / `recall_beaded`: wire sync and catch-up compose modules.

**`mantra/recall_sync_wire.rye`** — **8** fns (`encode_request`, `decode_request`, `build_response`, `apply_sync_response`, …).

**`mantra/recall_catch_up.rye`** — **3** fns (`max_revision_held`, `catch_up_to_latest`, `run_selftest`).

Repointed **21** callers via `sw.*` and `cu.*` import prefixes only (guest sync/catch-up/2way, delivery modules, `recall_batch_wire` forwarders, subscribe poll).

Ratchet **421 → 410** (−11). Witnesses GREEN: catch-up (+ wire), lap3, subscribe poll (+ wire), two-way wire, batch_wire, `tame_style_check`.

Stacks on uncommitted receipt + resin_batch + recall_lap1 + recall_beaded bundle from prior kg.

## Files

| Cluster | Why |
|---------|-----|
| `mantra/recall_sync_wire.rye` | wire encode/decode/apply API |
| `mantra/recall_catch_up.rye` | bounded catch-up loop API |
| 21 callers | `sw.*` / `cu.*` prefix repoint |

**Recommend:** say **go** to commit the full uncommitted snake_case bundle; **keep going** to `recall_batch_wire.rye` module-level camelCase on the next kg.
