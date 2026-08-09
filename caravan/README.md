# Caravan — Process Supervision

**Language:** EN
**Last updated:** 2026-07-10 (Radiant Style pass round 2 · host mirror under supervision)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — process supervision ladder

**Caravan supervises.** It watches a dependent process, restarts it when it falls, and grows — one accretion at a time — toward the fuller shape a real service needs: bounded memory per dependent, more than one dependent, ordered startup, a named capability table, and a real exit-code vocabulary that tells restart-on-fall apart from an ordinary cycle and a deliberate stop.

Every ring here composes over the one before it. A later ring imports an earlier one, or restates its shape one step further out — nothing is rewritten to make room for the next proof.

## The Ladder

| Ring | File | Proves |
|------|------|--------|
| seed | [`seed.rye`](seed.rye) | one parent, one dependent, restart on fall |
| bounded | [`bounded.rye`](bounded.rye) | supervision composed with a dependent's Tally garden |
| twin | [`twin.rye`](twin.rye) | two dependents, separate gardens, independent restart |
| chain | [`chain.rye`](chain.rye) | ordered startup stages, each restarting on its own fall |
| service (B) | [`service.rye`](service.rye) | one long-running dependent, a bounded multi-tick loop, a fall mid-sequence restarting the whole sequence |
| capabilities | [`capabilities.rye`](capabilities.rye) | a bounded table naming what each dependent may do |
| exit vocabulary | [`supervisor_exit.rye`](supervisor_exit.rye) | the three-way exit code: `cycle_ok` (0) spawns again, `stop_requested` (8) halts, anything else falls and restarts |
| restart-on-ok (D) | [`restart_on_ok.rye`](restart_on_ok.rye) | the exit vocabulary proven pure, argv-driven, before any wire work touches it |
| signal ring | [`supervisor_signal.rye`](supervisor_signal.rye) | a real `SIGTERM`/`SIGINT` handler whose entire body is one atomic store; the loop top creates the same sentinel a manual `touch` would |
| poll service (C) | [`subscribe_poll_service.rye`](subscribe_poll_service.rye) | production scheduling — Caravan supervises Mantra's real subscribe-poll wire work, single pair and host-mirror pair-list alike |

## Why the Exit Code Carries Three Meanings, Not Two

A supervisor that only knows "zero means done, anything else means retry" stalls a poller — an ordinary, successful cycle looks identical to a finished job, and the supervisor stops exactly when it should keep going. `supervisor_exit.rye` names the third answer: zero is *ordinary*, rather than *finished* — restart regardless. A reserved code, `stop_requested`, alone halts the loop, and it means the same thing whether a human created a sentinel file by hand or `supervisor_signal.rye`'s handler created it from a real signal. Counsel: [`counsel/20260707-014212_claude-counsel-graceful-stop-reframed.md`](../counsel/20260707-014212_claude-counsel-graceful-stop-reframed.md), [`counsel/20260707-021012_claude-counsel-ring4-signal-handler.md`](../counsel/20260707-021012_claude-counsel-ring4-signal-handler.md).

## Held

Extended-run stability (dozens of supervised cycles, watched for resource growth) waits for a genuine indefinite consumer to make the longer run mean something — see [`counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md`](../counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md) for the reasoning. Nothing here reaches toward Pond's policy layer or Brix's composition layer; Caravan supervises processes, and stops exactly there.

---

*May every dependent that falls be caught, and every dependent that finishes ordinarily be trusted to go again. May a stop always mean the same thing, however it arrives.*
