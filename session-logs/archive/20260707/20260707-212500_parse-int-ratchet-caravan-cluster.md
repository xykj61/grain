# parseInt ratchet — caravan cluster

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.212500

**Prompt:** `kg` — migrate caravan `parseInt(` cluster.

## Thinking trace

Added `caravan/parse_int.rye` symlink; migrated **4** CLI sites in `seed.rye`, `service.rye`, `subscribe_poll_service.rye`. Strict default for exit codes, attempt counts, witness-stop, and poll interval.

Witnesses GREEN: `caravan_seeds`, `caravan_subscribe_poll_service`, `caravan_witness_stop_footgun`. Ratchet **8→4**.

## Files

| File | Why |
|------|-----|
| `caravan/parse_int.rye` | Symlink to tally |
| `caravan/{seed,service,subscribe_poll_service}.rye` | 4 CLI parsers |

**Recommend:** **keep going** to final 4 sites on next `kg` — `rishi/src/main.rye` + `mantra/recall_subscribe_poll_delivery.rye` closes the ratchet.
