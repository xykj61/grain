# Two-way sync wire — parity 170

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.001512

## Thinking trace

Kaeden said keep going after counsel `000112` seated the in-process lap at parity 169. The wire lap is mechanical: compose the existing NS-L3 sync exchange twice with roles reversed — hosted first, device second — per NS-L3 climb order.

Built `mantra/recall_two_way_sync_delivery.rye` importing `recall_two_way_sync.rye` and reusing `recall_sync_wire` unchanged. Witness catalogs mirror in-process: each peer holds one unique leaf plus a shared digest. Exchange 1 crosses peerB into left; exchange 2 crosses peerA into right. Device lab runs phase 1 with existing `guest_sync_*` guests and phase 2 with new `guest_2way_*` for the reversed direction.

Fixed Zig compile error (`for` over pointer tuple → explicit left/right recall checks). Wire witness GREEN; full parity **170** GREEN on metal.

## Observations

Counsel holds: zero edits to lap1 or sync_wire; composition only. Subscribe-to-changes remains parked — next seam on Kaeden's word.

## Files

- `mantra/recall_two_way_sync_delivery.rye` — hosted two-way sync (new)
- `tools/mantra_recall_two_way_sync_wire.rish` — wire witness (new)
- `comlink/run_recall_two_way_sync_wire_lab.sh` — device lab both directions (new)
- `comlink/guest_2way_{fetcher_tx,source_rx,source_tx,fetcher_rx}.rye` — peerA direction guests (new)
- `tools/parity.rish` — parity 170 block
- `active-designing/20260706-023912_the-referential-namespace.md` — wire lap landed
- `work-in-progress/TASKS.md` — checkbox + next climb
- `work-in-progress/ROADMAP.md` — version + witness count

**Recommend:** check in with Claude before **subscribe-to-changes** — first lap that asks something new of the wire (poll-first smallest step per counsel); host mirror and Tablecloth query keep their seasons behind it.
