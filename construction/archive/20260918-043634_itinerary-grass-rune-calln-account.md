# Shelved GRASS account -- `glow/rune_calln.rye` took rune_call2's shape

**Status:** Archived (shelved whole `20260918.043634` per [`the-writer-sheds`](../../.claude/rules/the-writer-sheds.md), the writer's next live account replacing it on the pin)

**GRASS -- `glow/rune_calln.rye` TOOK RUNE_CALL2'S SHAPE; RUNE_CALL3.RYE WAS ALREADY LANDED
BY A PEER.** `glow/rune_calln.rye` (`%*`) gained `assert` on `gate_slice`, `name_at` (a bounds
assert on its index argument too), `parse_ident`'s postcondition, and `parse()`'s postcondition on
the finished spec's `count` and `gate_len`. `rune_call3.rye` was queued the same lap and found
already landed byte-for-byte identical on `xy/main` (a peer's own lap, same shape, same reasoning)
-- the rebase folded it in as a no-op diff rather than a conflict, so nothing here duplicates it.
Witness GREEN on metal before and after the rebase; `tame_style_check` and `width-check` re-run
clean. **YOURS:** none opened this lap; eleven zero-assert `glow/` files remain, same shape,
agent-doable next.
