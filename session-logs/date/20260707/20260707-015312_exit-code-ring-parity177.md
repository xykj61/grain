# Exit-code ring — restart on cycle_ok, stop on reserved code

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** `20260707.015312`

## Thinking trace

Kaeden relayed Claude counsel `20260707.014212` reframing graceful stop: success-as-finish-line is wrong for pollers; build exit-code ring first. Filed counsel to `external-research/`. Implemented `caravan/supervisor_exit.rye` (`cycle_ok` = 0, `stop_requested` = 8) and `caravan/restart_on_ok.rye` ring D — supervisor restarts on ordinary zero, stops only on stop code, falls still restart. Parity **177**. Sentinel + delivery loop deferred per counsel.

## Observations

- `service.rye` and `subscribe_poll_service.rye` unchanged — pure Caravan proof first.
- OA-L4/167 collision named in counsel as counting artifact; `open_asks.rye` fold is real.

## Files

| File | Why |
|------|-----|
| `counsel/20260707-014212_claude-counsel-graceful-stop-reframed.md` | Filed counsel |
| `caravan/supervisor_exit.rye` | Shared three-way exit vocabulary |
| `caravan/restart_on_ok.rye` | Ring D witness |
| `tools/caravan_restart_on_ok.rish` | Parity **177** |
| `tools/parity.rish` · `width-check.rish` | Suite + roster |
| `work-in-progress/TASKS.md` · `ROADMAP.md` | Next = sentinel ring |

**Recommend:** keep going to sentinel + bounded `pollCycles` loop in delivery when Kaeden says — counsel ring 2; then wire `subscribe_poll_service` to new supervisor semantics.
