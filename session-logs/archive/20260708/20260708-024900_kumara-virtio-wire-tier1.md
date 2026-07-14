**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

# Kumara virtio wire tier 1 — receipt, batch, snapshot guests

**Stamp:** 20260708.024900

## Thinking trace

Kaeden sent **`kg`** — implement and verify the next mechanical cluster. TASKS named virtio guest cluster as priority one, tiered by wire capability rather than one sweep.

I read the six smallest wire-capability guests that still reached for `Ed25519` directly:
- `guest_receipt_tx` / `guest_receipt_rx` (SLC-L2)
- `guest_batch_source_tx` / `guest_batch_fetcher_rx` (resin-batch wire)
- `guest_snapshot_source_tx` / `guest_snapshot_fetcher_rx` (snapshot lap 3 device)

`comlink/kumara.rye` symlink already existed. Migration followed the established pattern: import `kumara`, replace `generateDeterministic` with `keypair_from_seed`, `sign` with `kumara.sign`, signature length with `kumara.signature_length`, seed length with `kumara.seed_length`.

Fourteen `guest_open_asks_*` files remain — the product-surface virtio tier for the next **`kg`**.

## Verification

| Witness | Result |
|---------|--------|
| `tools/slcl2_receipt.rish` | GREEN (hosted + device) |
| `tools/mantra_recall_batch_wire.rish` | GREEN (hosted + device, chunk + beaded) |
| `tools/mantra_snapshot_wire.rish` | GREEN (hosted + device) |
| `tools/tame_style_scan_advise_selftest.rish` | GREEN at **73** |
| `tools/tame_style_check.rish` | GREEN |

Ed25519 ratchet: **91 → 73** (18 sites across 6 files).

## Observations

- Sync, 2way, catchup, pattern, and sealed guests never used `Ed25519` — they were already clean.
- Open asks virtio guests mirror the linengrow migration already landed in `015312`; next pass is mechanical copy of the same `pubkey_hex` / `keypair_from_seed` idiom.

## Files

- `comlink/guest_receipt_tx.rye`, `guest_receipt_rx.rye` — Kumara repoint
- `comlink/guest_batch_source_tx.rye`, `guest_batch_fetcher_rx.rye` — Kumara repoint
- `comlink/guest_snapshot_source_tx.rye`, `guest_snapshot_fetcher_rx.rye` — Kumara repoint
- `tools/tame_style_scan_advise_selftest.rish` — ratchet pinned **73**
- `context/TAME_GUIDANCE.md` — ratchet line updated
- `work-in-progress/TASKS.md` — virtio tier 1 checked, next bench table updated

**Recommend:** keep going to virtio open_asks guest cluster on the next **`kg`** — fourteen files, mechanical, same idiom as `015312` product surface.
