# tally + aurora snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.173844

## Prompt

kg.

## Thinking trace

Touched foundation layers outside mantra/comlink:

**Tally** — `copy.rye` (`run_selftest`), `seed.rye` + `gardens.rye` (`buf_len_u32`, `clear_one`, `clear_all`, `total_remaining`) — **6** fns, in-file only.

**Aurora** — six `aurora/src/*.rye` stages — **22** fns (`stage_wake` + asm `j stage_wake`, `read_csr`, `write_str`, …). Export entry symbols updated with asm labels together.

Ratchet **178 → 150** (−28). Witnesses GREEN: `foundation_seeds`, `tally_copy`, aurora relay/deciding/sealed under QEMU, `tame_style_check`.

Stacks on uncommitted `virtio_net` cluster from prior go-then-kg.

## Files

| Cluster | Why |
|---------|-----|
| `tally/copy.rye`, `seed.rye`, `gardens.rye` | hosted foundation |
| `aurora/src/*.rye` (6) | freestanding boot stages |

**Recommend:** say **go** to commit virtio_net + tally + aurora together; **keep going** to `pond/apps/window_input.rye` or `brushstroke/skate_grid.rye` on the next kg.
