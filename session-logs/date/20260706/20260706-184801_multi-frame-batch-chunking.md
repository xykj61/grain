# Multi-frame batch chunking (NS-L3 lap 3w-4)

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.184801

**Prompt:** keep going — multi-frame batch chunking for bolts > 340 B.

## Thinking trace

Extended `recall_batch_wire.rye` with kind **0x04** chunk frames: 9-byte header (index, count, total_len) plus up to **331 B** body per sealed datagram. `BatchAssembler` reassembles in order before `applyBatch` runs. Single-frame kind **0x03** unchanged for small batches.

`recall_batch_delivery.rye` gained `sendBatchPayload` / `recvBatchPayload`, chunk section in selftest (660 B batch over 2 frames), and `chunkdemo` localhost hop. Witness bolt uses **400 B** beta resin (`plain-bytes`) with alpha held.

Device guests upgraded to the large batch; virtio lab exposed multi-packet bugs in `virtio_net`: TX must increment `avail.idx` per send; RX must `repost()` and read `used.ring[slot]` not always slot 0. After fix, device lab GREEN in ~5s.

Parity **166** extended (witness count unchanged); full suite GREEN (~96s).

## Observations

- No new frame kind in `resin_batch` — chunking is wire-only carriage.
- Chunk witness: 660 B batch, 2 frames; device virtio sends both under seal.
- `virtio_net` fix benefits any future multi-datagram Comlink hop.

## Files

- `mantra/recall_batch_wire.rye` — chunk encode/decode, `BatchAssembler`, `runChunkWireSelftest`
- `mantra/recall_batch_delivery.rye` — chunk selftest, `chunkdemo`, send/recv helpers
- `comlink/guest_batch_source_tx.rye` — multi-send large batch
- `comlink/guest_batch_fetcher_rx.rye` — multi-recv assembler loop
- `comlink/virtio_net.rye` — multi-packet TX/RX ring discipline
- `tools/mantra_recall_batch_wire.rish` — `chunkdemo` step
- `active-designing/20260706-023912_the-referential-namespace.md` — chunking row + carriage note
- `work-in-progress/TASKS.md`, `ROADMAP.md` — chunking landed

**Recommend:** keep going to **beaded bolt full crossing** — index + `.bN` leaves over batch wire; composes recall_beaded with chunking already seated.
