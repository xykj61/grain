# Expanding Prompt — MALA M2b: Device Wire Twin

**Stamp:** `20260709.201734`
**Voice:** Rio 3
**Status:** **Landed** `20260709.201734` — device lab GREEN; extends `mala_m2_witness` (parity count **201** unchanged)
**Ground:** M2 hosted [`191634`](20260709-191634_mala-m2-mailable-comlink.md) · OA-L2 device lab · SLC-L2 guests

---

## Scope

Virtio twin of hosted M2: same sealed mint + receipt bytes over QEMU socket pairs.

| Hop | Device port | Guests |
|-----|-------------|--------|
| Mint issuer→holder | **15569** | `guest_mala_mint_tx` / `guest_mala_mint_rx` |
| Receipt holder→issuer | **15570** | `guest_mala_receipt_tx` / `guest_mala_receipt_rx` |

Hosted `mala_delivery.rye` unchanged. Extend `tools/mala_m2_witness.rish` with the device lab (parity count stays **201** unless a separate stanza is preferred — keep count unchanged).

## DoD

1. Four guests GREEN banners: sealed mint / sealed receipt.
2. `comlink/run_mala_wire_lab.sh` GREEN.
3. `mala_m2_witness` GREEN with device stanza.
4. Full parity GREEN.
