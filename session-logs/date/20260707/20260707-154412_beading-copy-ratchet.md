# Beading cluster — copy_disjoint ratchet turn

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.154412

## Prompt

Keep going — `beading.rye` / `recall_beaded.rye`.

## Thinking trace

`mantra/beading.rye` (16 sites) and `mantra/recall_beaded.rye` (5 sites) — bead store, index assembly, reassembly, and catalog compose path. Struct-field copies use `std.mem.asBytes(&field)` at the seam; slice copies use `copy_disjoint(u8, …)` directly.

Witnesses GREEN: beading selftest, recall_beaded, batch wire (beaded demo). `@memcpy` ratchet **46 → 25**. Cumulative from `053212`: **121 → 25** (uncommitted).

## Files

| File | Sites |
|------|-------|
| `mantra/beading.rye` | 16 |
| `mantra/recall_beaded.rye` | 5 |

**Recommend:** keep going to `linengrow/` delivery modules and `rishi/src/main.rye` (2 sites each), or say **go** to commit the ratchet arc at **25** remaining.
