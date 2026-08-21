# Device wire sub-lap 2 climb and grain check

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260705.230100

## Prompt

Continue with our recommendation (sub-lap 2: two QEMU `virt` guests, fixed-pattern TX/RX) and check that we are following our grain.

## Thinking trace

Kaeden asked to continue the Linengrow-via-Comlink season at sub-lap 2 while verifying grain alignment. Sub-lap 1 was already landed at `7aae056`.

I extracted shared virtio types into `comlink/virtio_net.rye`, added freestanding `guest_pattern_tx.rye` and `guest_pattern_rx.rye`, and a shell lab `comlink/run_device_wire_lab.sh` (socket netdev, RX listen / TX connect). Refactored `device_wire.rye` to import `virtio_net` for sameness with guests.

Bring-up on QEMU 8.2 `riscv64 virt` revealed the virtio-net device lands at MMIO slot 7 (`0x10008000`), version register 1 (transitional), with modern `queue_num_max` at offset `0x02c` reading zero — legacy PFN path required. Explored legacy vring layout, split-queue xv6 pattern, volatile used-ring polling, hdr_len, single vs chained descriptors, and fixed guest RAM pages. TX `used.idx` never advanced; RX guest boots and times out waiting for a frame. Sub-lap 1 hosted selftest remains GREEN.

## Grain audit

| Strand | Sub-lap 2 alignment |
|--------|---------------------|
| TAME order | Safety first — MMIO discovery scan, bounded queues, pattern match refuses early; performance — fixed RAM pages, no heap; joy deferred until rye-field message crosses (sub-lap 3) |
| Bounded everything | `queue_depth`, `max_frame`, `link_pattern_len` explicit in `virtio_net.rye` |
| Sameness | One `virtio_net.rye` letter for hosted algebra and freestanding guests; `wire_format.rye` untouched |
| Core + shell | Core guests prove carriage; shell lab script observes; witness stays on sub-lap 1 until link greens |
| Witnesses first | No parity inflation; linktest not wired until GREEN |
| Seam honesty | QEMU socket netdev and transitional virtio-MMIO named openly in brief |
| Gall's Law | Sub-lap 1 fixtures green before live link; sub-lap 2 blocked on smallest NIC TX completion, not format fork |
| Accretion | Brief and TASKS updated in place; debug probes removed after use |

## Observations

The honest blocker is virtio-net TX completion on QEMU 8.2's transitional MMIO transport (version register 1, device at slot 7). A gratitude close-reading pass (xv6-riscv virtio-net uses version 2 + split queues at `VIRTIO1`) should settle legacy vs modern queue programming before we wire linktest into the witness.

## Files

| File | Why |
|------|-----|
| `comlink/virtio_net.rye` | Shared virtio types, pattern constant, freestanding driver seed |
| `comlink/guest_pattern_tx.rye` | Sub-lap 2 TX guest |
| `comlink/guest_pattern_rx.rye` | Sub-lap 2 RX guest |
| `comlink/run_device_wire_lab.sh` | Two-guest socket lab orchestration |
| `comlink/device_wire.rye` | Import `virtio_net`; selftest negotiation aligned |
| `tools/comlink_device_wire.rish` | Sub-lap 1 witness only (linktest deferred) |
| `active-designing/20260705-225412_comlink-device-wire.md` | Sub-lap 2 marked in flight with blocker note |
| `work-in-progress/TASKS.md` | Sub-lap 2 status refreshed |

**Recommend:** check in with Claude before the next virtio driver pass — QEMU 8.2 transitional MMIO (slot 7, version 1, modern `queue_num_max` zero) needs a ruled close-reading against `gratitude/` and the xv6-riscv virtio-net init sequence; once TX completion greens, sub-lap 2 linktest and sub-lap 3 sealed payload are mechanical on the ladder already seated.
