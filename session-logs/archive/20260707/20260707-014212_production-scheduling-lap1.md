# Production scheduling lap 1 — Caravan supervises poll wire

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** `20260707.014212`

## Thinking trace

Kaeden said follow the recommendation: wire subscribe poll under Caravan service supervision. Smallest ring: `caravan/subscribe_poll_service.rye` spawns `recall_subscribe_poll_delivery` source-loop, supervises fetcher-poll with one planned mid-service fall and restart. Added `fetcher-poll fail` mode to delivery for witness. Parity **176**.

## Observations

- Composes across Caravan/Mantra seam without editing `recall_subscribe_poll.rye` or catch-up beneath.
- Source child exits on recv timeout after fetcher completes — no double-wait panic.
- Graceful stop and real unattended clock still open.

## Files

| File | Why |
|------|-----|
| `caravan/subscribe_poll_service.rye` | Supervisor ring C |
| `mantra/recall_subscribe_poll_delivery.rye` | `fetcher-poll fail` for witness |
| `tools/caravan_subscribe_poll_service.rish` | Witness parity **176** |
| `tools/parity.rish` | New witness slot |
| `tools/width-check.rish` | Roster |
| Docs | TASKS, ROADMAP, namespace brief, reference spec |

**Recommend:** keep going to commit/push parity 176 — mechanical; graceful stop needs counsel before OS signals.
