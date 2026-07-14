# Graceful stop rings 2–3 — parity 178

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.020512

**Prompt:** Keep following the recommendations (counsel `20260707.014212` rings 2–3).

## Thinking trace

Counsel `014212` ordered four rings: exit vocabulary (177), sentinel at poll boundary (178), wire supervisor semantics (178), SIGTERM deferred (ring 4). Ring 1 (`supervisor_exit`, `restart_on_ok`) was built locally but uncommitted; rings 2–3 were in flight when context rolled.

**Ring 2 — delivery:** Added `stop_requested = 8` (comment-linked to Caravan), `stopSentinelPresent` via `std.Io.Dir.cwd().access`, and `runFetcherPollOnce` — one wire cycle, exit 0 or 8. Renamed the two-cycle path `fetcher-poll-legacy` for demo/selftest/fall witness. `source-loop` now `while (true)` with `continue` on recv timeout so a long-lived source survives sequential witness cycles.

**Ring 3 — supervisor:** Rewrote `subscribe_poll_service` to import `supervisor_exit`, require `<delivery> <sentinel> [witness-stop-after-N]`, restart on `cycle_ok`, halt on `stop_requested`, write sentinel after N ordinary cycles in witness mode, kill source child on stop (source never exits on its own).

**Witness fixes:** `mantra_recall_subscribe_poll_stop.rish` uses `nohup … >/dev/null` so background source-loop does not hold the `run` pipe open. Service witness drops planned-fail path; proves sentinel end-to-end.

**Build seams:** Pristine std uses `std.Io.Dir.cwd().access(io, …)` not `std.fs.cwd()`. After `kill`, do not `wait` on source child — Zig asserts `child.id != null`.

## Observations

All three witnesses GREEN on metal: `mantra_recall_subscribe_poll_stop`, `caravan_subscribe_poll_service`, `caravan_restart_on_ok`. Parity slot **178** added for stop sentinel; ring 1 files land in the same commit batch.

## Files

| File | Why |
|------|-----|
| `caravan/supervisor_exit.rye` | Three-way exit vocabulary (ring 1) |
| `caravan/restart_on_ok.rye` | Ring D proof supervisor (ring 1) |
| `caravan/subscribe_poll_service.rye` | Ring 3 — restart on cycle_ok, stop on sentinel |
| `mantra/recall_subscribe_poll_delivery.rye` | Ring 2 — fetcher-poll-once + sentinel |
| `tools/mantra_recall_subscribe_poll_stop.rish` | Delivery boundary witness |
| `tools/caravan_restart_on_ok.rish` | Exit-code ring witness |
| `tools/caravan_subscribe_poll_service.rish` | End-to-end supervisor witness |
| `tools/parity.rish` | Slots 177–178 |
| `context/specs/20260707-011412_*` | Production scheduling + Caravan row |
| `work-in-progress/TASKS.md` · `ROADMAP.md` | Parity 178 hygiene |

**Recommend:** keep going to ring 4 (SIGTERM → sentinel) when Kaeden wants host signal wiring — crosses process/signal seam; otherwise I2 snapshot export is the next mechanical NS item on TASKS.
