# SLC-L2 sealed delivery — parity 155

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.000812

## Thinking trace

Continued from parity **154** and the dependency survey. The recommended path was SLC-L2 on hosted Comlink first — mechanical, follows SLC-L1 + `hosted_wire` patterns.

Seated lap brief [`active-designing/20260706-000812_slcl2-sealed-delivery.md`](../active-designing/20260706-000812_slcl2-sealed-delivery.md). Extracted shared receipt logic to `linengrow/receipt_core.rye` so SLC-L1 witness surface stays stable while SLC-L2 reuses sign/verify/fold. Added `wire_format.sealMessage` for arbitrary bounded plaintext (refactored `sealDatagram` to call it — hosted and device wire witnesses unchanged).

Compact payload (`sig[64] | fact_len u32 | fact`) fits `max_message` (324 bytes); hex log line would not. Built `linengrow/delivery.rye` with selftest + demo on port **38473**. Rye module path cannot cross directories — added symlink `linengrow/wire_format.rye` → `comlink/wire_format.rye` (format does not fork).

Witness `tools/slcl2_receipt.rish` wired into `parity.rish`. Full suite GREEN (~60s).

## Observations

- Outer Comlink seal (Alice→Bob fixture keys) and inner SLC-L1 signer (deterministic seed) are two honest layers.
- Device wire variant of SLC-L2 is optional next — carriage already green at sub-lap 3.
- Open Asks remains parallel design thread per eight-asks A4.

## Files

- `linengrow/receipt_core.rye` — shared receipt + compact payload (new)
- `linengrow/receipt.rye` — refactored to import receipt_core
- `linengrow/delivery.rye` — SLC-L2 send/recv/demo (new)
- `linengrow/wire_format.rye` — symlink to comlink (new)
- `comlink/wire_format.rye` — `sealMessage` added
- `tools/slcl2_receipt.rish` — witness (new)
- `tools/parity.rish` — SLC-L2 block
- `tools/width-check.rish` — receipt_core + delivery
- `active-designing/20260706-000812_slcl2-sealed-delivery.md` — lap brief (new)
- `work-in-progress/ROADMAP.md`, `TASKS.md`, `linengrow/README.md` — parity **155**
- `session-logs/20260706-000812_slcl2-sealed-delivery-parity-155.md` — this log

**Recommend:** keep going to **SLC-L2 device wire variant** — extend `guest_sealed_*` or a thin lab script to carry compact receipt payload over virtio (mechanical, reuses delivery encode + virtio_net); or pause for Kaeden on **Open Asks hammock scope note** if Linengrow design thread should lead.
