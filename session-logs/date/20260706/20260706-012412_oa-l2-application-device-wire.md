# OA-L2 application-return device wire — full virtio round trip

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.012412

## Thinking trace

Kaeden said go on the recommended bench: OA-L2 application-return device wire. Added `guest_open_asks_application_tx.rye` (witness application under seal) and `guest_open_asks_poster_rx.rye` (verify + `foldAppliedLog`). Extended `run_open_asks_wire_lab.sh` to two hops — request on **15557**, application on **15558**. Both hops GREEN; OA-L2 witness and full parity GREEN (~76s).

## Observations

- Poster RX holds canonical request locally (witness sign) and appends wire-verified application — same discipline as hosted `open_asks_delivery` poster path.
- OA-L2 device wire now mirrors hosted round trip: request out, application back, fold `applied`.

## Files

- `comlink/guest_open_asks_application_tx.rye` · `comlink/guest_open_asks_poster_rx.rye` — application hop (new)
- `comlink/run_open_asks_wire_lab.sh` — two-hop lab
- `active-designing/20260706-011512_open-asks-cross-party-delivery.md` · `work-in-progress/TASKS.md`
- `session-logs/20260706-012412_oa-l2-application-device-wire.md` — this log
- `session-logs/README.md` — index row

**Recommend:** check in with Claude before **OA-L3 hammock brief** (MALA escrow crosses module seams); settlement ladder softenings still await Kaeden word.
