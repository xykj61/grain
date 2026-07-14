# Outer subscribe poll — parity 173

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.004812

## Thinking trace

Kaeden relayed Claude counsel `20260707.004712` resolving outer subscribe and host mirror. Caravan seed proves restart-on-failure until success — not a poller; no OS signal graceful-stop pattern exists in tree. Counsel: build bounded outer loop with test-only cycle count composing `recall_catch_up`; host mirror = named peer/bolt list per cycle, not a separate seam.

Filed counsel. Built `mantra/recall_subscribe_poll.rye` — `pollOneCycle` / `pollCycles` with `max_cycles` and optional `interval_ns` (zero in witness). Witness: rev lands after cycle 1, caught cycle 2; empty cycles cost one ask; two-pair mirror config. Parity **173** GREEN.

## Observations

Subscribe arc complete through witnessable outer poll in-process. Production scheduling, graceful stop, crash recovery remain open. Wire lap next mechanical climb.

## Files

- `counsel/20260707-004712_claude-counsel-outer-subscribe-and-host-mirror.md` — counsel (filed)
- `mantra/recall_subscribe_poll.rye` — outer poll (new)
- `tools/mantra_recall_subscribe_poll.rish` — witness (new)
- Docs, parity, width-check updated

**Recommend:** keep going to **outer subscribe poll wire lap** — bounded cycles over catch-up wire; mechanical. Production unattended scheduling waits on Caravan scheduling half or real need.
