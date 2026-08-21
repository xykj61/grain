# open_asks fold and selftest — 70-line splits

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.160312

## Prompt

Keep going — split `foldReputationLog` / `foldEscrowLog` in `open_asks.rye`.

## Thinking trace

Continued the 70-line ratchet on `linengrow/open_asks.rye`. Extracted per-kind handlers for `foldEscrowLog` (four arms) and `foldReputationLog` (five arms + tally helper). Split `runSelftest` into `appendOa1WelcomeLog`, `appendOa1CompletionPayment`, and `runSelftestUnwelcomeBadRef`.

Witnesses GREEN: OA-L1, OA-L3, OA-L4, `tame_style_check`. The three originally flagged functions (`foldEscrowLog`, `foldReputationLog`, `runSelftest`) no longer appear on the >70-line ratchet.

## Files

| File | Why |
|------|-----|
| `linengrow/open_asks.rye` | Fold handlers + OA-L1 selftest seam splits |

**Recommend:** say **go** to commit; or keep going on `appendEscrowCompletedAsk` (77 lines) in the same file on next touch.
