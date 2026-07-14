# Caravan runSupervisor — 70-line split

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.162112

## Prompt

Keep going.

## Thinking trace

Split `runSupervisor` (88 lines) in `caravan/subscribe_poll_service.rye` at natural seams: `buildFetcherArgv`, `applyFetcherExit`, `printSupervisorSuccess`, thin loop orchestrator. Preserved `interval_buf` lifetime in the supervisor loop (caller-owned buffer for argv).

Witnesses GREEN: subscribe poll service, SIGTERM, host mirror, source-crash, witness-stop footgun, `tame_style_check`. `subscribe_poll_service.rye` clear of >70-line flags.

Uncommitted from prior turn: OA-L5 wire-verify split (`open_asks_lap5_delivery.rye`).

## Files

| File | Why |
|------|-----|
| `caravan/subscribe_poll_service.rye` | `runSupervisor` split |

**Recommend:** say **go** to commit OA-L5 + caravan splits together; next ratchet: `recall_subscribe_poll.runSelftest` (71) or `drawn_terminal.runLive` (78).
