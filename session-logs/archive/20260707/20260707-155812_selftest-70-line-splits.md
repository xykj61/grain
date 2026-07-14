# 70-line function ratchet — selftest splits

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.155812

## Prompt

Keep going — after parity **191**.

## Thinking trace

`tame_style_scan.sh advise` named two functions past the 70-line law on files we had already touched: `runReputationSelftest` (124) in `linengrow/open_asks.rye` and `runSelftest` (122) in `mantra/recall_beaded.rye`. Split each at welcome/unwelcome seams per TAME policy — one idea per function, no behavior change.

**recall_beaded:** `selftestDirectAndBeadedRoundTrip`, `selftestBeadedRevisionDedup`, `selftestUnwelcomePaths`; thin `runSelftest` orchestrator.

**open_asks:** `appendReputationWitnessBolt`, `verifyReputationWelcomeFold`, `reputationUnwelcomeConsentBeforeCompletion`, `reputationUnwelcomeDoubleConsent`; thin `runReputationSelftest`.

Witnesses GREEN: `mantra_recall_beaded`, `open_asks_lap4`, `tame_style_check`. The two originally flagged selftests no longer appear on the >70-line ratchet; other elders in `open_asks.rye` remain for on-touch splits.

## Files

| File | Why |
|------|-----|
| `mantra/recall_beaded.rye` | Split `runSelftest` into three helpers + orchestrator |
| `linengrow/open_asks.rye` | Split `runReputationSelftest` into four helpers + orchestrator |

**Recommend:** say **go** to commit the splits; or keep going to split `foldEscrowLog` / `foldReputationLog` in `open_asks.rye` on the next touch of that file.
