# Drawn terminal snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.163712

## Prompt

Keep going.

## Thinking trace

Continued camelCase on-touch after the subscribe-poll cluster (`163412`). Migrated all 17 camelCase `fn` declarations in `pond/apps/drawn_terminal.rye` to snake_case — frame helpers, witnesses, live loop, poll/stdin paths. All references are internal; no cross-file repoint needed.

Ratchet **671 → 654** (−17 cumulative **692 → 654** with prior turn uncommitted). Witnesses GREEN: `pond_build_drawn_terminal`, SLC-2a, SLC-2b, RW-2, `tame_style_check`.

**Uncommitted snake_case bundle (two turns):** subscribe-poll cluster (3 files) + `drawn_terminal.rye`.

## Files

| File | Why |
|------|-----|
| `pond/apps/drawn_terminal.rye` | snake_case for every local `fn` |

**Recommend:** say **go** to commit and push the four-file snake_case bundle (caravan + mantra ×2 + pond) with both session logs.
