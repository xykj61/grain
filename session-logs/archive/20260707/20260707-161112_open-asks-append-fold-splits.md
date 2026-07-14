# open_asks 70-line ratchet — folds, append helpers, delivery selftests

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.161112

## Prompt

Keep going; then full summary and commits and pushes.

## Thinking trace

Three-file pass on the 70-line law while `open_asks` was warm:

**open_asks.rye:** shared `appendAskThroughAcceptance`, `appendOptionalConsent`, `appendEscrowHoldRelease`; `foldLog` per-kind handlers (matching escrow/reputation pattern).

**open_asks_delivery.rye:** `selftestWireWelcomePath` + `selftestWireUnwelcomeBadRef`.

**open_asks_lap5_delivery.rye:** `Oa5SelftestWire`, `selftestOa5VerifyWireLegs`, `selftestOa5FoldAndReputation`.

Witnesses GREEN: OA-L1 through OA-L5, `tame_style_check`. `open_asks.rye` and `open_asks_delivery.rye` clear of >70-line flags; `selftestOa5VerifyWireLegs` (81) remains advisory.

## Files

| File | Why |
|------|-----|
| `linengrow/open_asks.rye` | Append pipeline + `foldLog` handlers |
| `linengrow/open_asks_delivery.rye` | OA-L2 selftest split |
| `linengrow/open_asks_lap5_delivery.rye` | OA-L5 selftest split |

**Recommend:** keep going on `selftestOa5VerifyWireLegs` or `caravan/subscribe_poll_service` on next touch.
