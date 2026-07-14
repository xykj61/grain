# recall_two_way_sync + beading + snapshot_export snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.173003

## Prompt

kg.

## Thinking trace

Three mantra library modules on touch:

| Module | Fns | Callers |
|--------|-----|---------|
| `recall_two_way_sync.rye` | **2** (`sync_both_ways`, `run_selftest`) | `tw.*` in delivery |
| `beading.rye` | **7** (`bead_content_defined`, `verify_bead_index`, …) | `beading.bead_content_defined` in `recall_beaded` |
| `snapshot_export.rye` | **33** (export/import/horizon API + helpers) | `snap.*` + `.peer_slice()` / `.bolt_slice()` in delivery |

Ratchet **284 → 242** (−42). Witnesses GREEN: two-way sync, beading, recall_beaded, snapshot horizon/replay/wire, `tame_style_check`.

Full uncommitted bundle from committed tip: **462 → 242** (−220).

## Files

| File | Why |
|------|-----|
| `mantra/recall_two_way_sync.rye` | symmetric sync API |
| `mantra/beading.rye` | bead-index ring API |
| `mantra/snapshot_export.rye` | I2 snapshot export/import |
| 3 callers | scoped prefix/dot repoint |

**Recommend:** say **go** to commit the full uncommitted bundle; **keep going** to `recall_by_mark.rye`, `recall_tablecloth_query.rye`, `recall_subscribe_poll.rye` on the next kg.
