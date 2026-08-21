# Caravan rings 1–2 — footgun guard and source-crash recovery

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.051012

## Thinking trace

Continued counsel `044112` seated order. Ring 1 (`witness_stop_after` footgun) and ring 2 (source-crash recovery) landed in one pass.

Ring 1: `CARAVAN_WITNESS_MODE=1` gate; `tools/caravan_witness_stop_footgun.rish`.

Ring 2: supervisor polls source with `linux.waitpid` WNOHANG at loop top and while fetcher runs — fetcher otherwise blocks forever on `recvWire` when source dies. Named halt exit **3**. Witness kills source via `pgrep -P` fixture script.

Parity **187** GREEN (~133s).

## Observations

`set -e` in the fixture script caused `wait` to propagate supervisor exit 3 as script failure — fixed with `wait || super_exit=$?`. Avoid `pkill -f` patterns that match the witness shell's own argv.

Next in order: snapshot device wire (lap 3 virtio leg), then host-mirror under supervision, then TASKS sweep.

## Files

- `counsel/20260707-044112_claude-recommendation-path.md` — counsel order filed
- `caravan/subscribe_poll_service.rye` — footgun gate + source poll + multiplexed fetcher wait
- `tools/caravan_witness_stop_footgun.rish` — ring 1 witness
- `tools/caravan_subscribe_poll_source_crash.rish` + `tools/fixtures/caravan_subscribe_poll_source_crash.sh` — ring 2 witness
- `tools/caravan_subscribe_poll_service.rish` — witness mode env
- `tools/parity.rish` — two new slots
- `work-in-progress/TASKS.md` · `ROADMAP.md` — parity **187**

**Recommend:** keep going to snapshot device wire — lap 3 finishing on virtio, same pattern as other Mantra wire laps; mechanical once virtio ports are allocated.
