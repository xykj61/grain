# SLC-L2 device wire variant

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.001512

## Thinking trace

Continued from parity **155** hosted SLC-L2. Recommended path: carry compact receipt payload through virtio sealed guests for civic end-to-end proof.

Added `witness_canonical_fact` to `receipt_core.rye`. Created `guest_receipt_tx.rye` / `guest_receipt_rx.rye` importing `receipt_core` via symlink `comlink/receipt_core.rye`. Lab script `run_receipt_wire_lab.sh` on port **15556**.

First runs: RX timeout, TX silent. Debug showed TX completed seal but hung in `tx.send` — root cause: frame total **490 bytes** with `max_frame = 256`. Receipt wire datagram is **464 bytes** (`sealMessage` over 276-byte compact payload); rye-field message fits in 243 bytes.

Raised `virtio_net.max_frame` to **512** to match `wire_format.wire_capacity`. Receipt lab GREEN; device wire sub-laps 2–3 still GREEN. Extended `slcl2_receipt.rish` with device wire lab. Full parity **155** GREEN (~62s).

## Observations

- Frame bound must track wire letter capacity — a silent assert in freestanding TX looked like a hang.
- RX guest proves verify+fold on metal; TX signs on device (not just pinned bytes).
- Parity count stays **155** — witness extended, not a new block.

## Files

- `comlink/guest_receipt_tx.rye`, `guest_receipt_rx.rye` — virtio receipt guests (new)
- `comlink/run_receipt_wire_lab.sh` — lab script (new)
- `comlink/receipt_core.rye` — symlink to linengrow (new)
- `comlink/virtio_net.rye` — `max_frame` 256 → 512
- `linengrow/receipt_core.rye` — witness canonical fact constant
- `tools/slcl2_receipt.rish` — device wire lab in witness
- `active-designing/20260706-000812_slcl2-sealed-delivery.md` — device variant section
- `work-in-progress/TASKS.md` — SLC-L2 complete both paths
- `session-logs/20260706-001512_slcl2-device-wire-variant.md` — this log

**Recommend:** keep going to **Open Asks hammock scope note** — cheap Linengrow design doc, no new module names; or check in with Kaeden before SLC-L3 / settlement horizon — crosses module seam toward Sui.
