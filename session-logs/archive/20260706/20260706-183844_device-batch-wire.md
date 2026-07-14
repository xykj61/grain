# Device batch wire (NS-L3 lap 3w-4)

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.183844

**Prompt:** keep going with your rec — finish device batch wire on virtio (ports 15563/15564).

## Thinking trace

Continued from parity **166** hosted batch wire. The recommendation was virtio guests mirroring the sync-wire two-hop pattern: sealed batch request on **15563**, sealed resin-batch response on **15564**.

Built four guests (`guest_batch_fetcher_tx/rx`, `guest_batch_source_rx/tx`) and `run_recall_batch_wire_lab.sh`. Lab GREEN on first run (~5s). Extended `mantra_recall_batch_wire.rish` with device lab step; full parity **166** GREEN (~90s) after restoring `checkable-room` in the namespace brief Status line (doorway witness).

Added comlink symlinks `recall_batch_wire.rye` and `resin_batch.rye` for guest imports. Updated namespace brief, TASKS, ROADMAP witness roster text, and parity suite labels to hosted + device.

## Observations

- Witness bolt unchanged (peerB/b/1, alpha held, beta need) — single 263 B batch still fits the 340 B wire frame.
- Parity count stays **166**; device lap extends the existing batch-wire witness rather than opening parity **167**.
- Signer seed `0x61` for batch matches hosted lab convention.

## Files

- `comlink/guest_batch_fetcher_tx.rye` — fetcher sends sealed batch request
- `comlink/guest_batch_fetcher_rx.rye` — fetcher applies batch, recalls beta
- `comlink/guest_batch_source_rx.rye` — source verifies request
- `comlink/guest_batch_source_tx.rye` — source sends sealed resin-batch
- `comlink/run_recall_batch_wire_lab.sh` — two-hop device lab script
- `comlink/recall_batch_wire.rye` — symlink to mantra (guest import)
- `comlink/resin_batch.rye` — symlink to mantra (guest import)
- `tools/mantra_recall_batch_wire.rish` — device lab witness step
- `tools/parity.rish` — suite label hosted + device
- `active-designing/20260706-023912_the-referential-namespace.md` — device row + ports
- `work-in-progress/TASKS.md` — device batch wire checked
- `work-in-progress/ROADMAP.md` — witness roster wording

**Recommend:** keep going to multi-frame batch chunking when a bolt exceeds 340 B — mechanical follow-on within NS-L3 wire policy, single-module horizon unless chunk framing needs a new bead kind.
