# TB std-prefix counsel applied — contract asserts on sync wire + sed

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.183412

**Prompt:** Kaeden relayed Claude counsel on TigerBeetle `std.` prefixes, assert density, `maybe` parked to RTAC; repairs to `recall_sync_wire` and `snapshot_export_delivery`.

## Thinking trace

The attached zip was not on this bench; applied from counsel narrative. Measured gap: `recall_sync_wire.rye` had zero asserts; `snapshot_export_delivery.rye` imported assert unused. Added **12** contract asserts to sync wire (encode/decode/build/apply postconditions) and **16** to snapshot export delivery (seal/open/send/recv bounds, batch assembly, snapshot buffer). Filed [`counsel/20260707-183412_claude-counsel-tb-std-prefix-assert-density.md`](../counsel/20260707-183412_claude-counsel-tb-std-prefix-assert-density.md). Extended `tame_style_scan.sh advise` with zero-assert counter + honest exempt list (guests, aurora, signal handler, font, line editor, exit constants) — reads **0** non-exempt at tip.

Witnesses GREEN: `tame_style_check`, `mantra_recall_lap3_wire`, `mantra_snapshot_wire`.

## Observations

`std.` prefix habit affirmed — matches TB majority practice; no alias sweep. `maybe` parked to RTAC beside `tally/copy.rye` on Kaeden's word.

## Files

| File | Why |
|------|-----|
| `mantra/recall_sync_wire.rye` | assert import + 12 contract asserts |
| `mantra/snapshot_export_delivery.rye` | 16 contract asserts on wire paths |
| `tools/fixtures/tame_style_scan.sh` | zero-assert advisory |
| `counsel/20260707-183412_*` + README | Counsel filed |

**Recommend:** say **`go`** to commit and push — mechanical ship; parity unchanged, existing wire stanzas re-prove both files.
