# Expanding Prompt — MUR M2b: Device Wire Twin (was MALA)

**Stamp:** `20260709.201734`
**Voice:** Rio 3
**Status:** **Landed** `20260709.201734` — device lab GREEN; extends `murr_m2_witness` (parity count **201** unchanged)
**Ground:** M2 hosted [`191634`](20260709-191634_mala-m2-mailable-comlink.md) · OA-L2 device lab · SLC-L2 guests
Radiant pass `20260728.052149` — living rename-forward: **MUR** (was MALA); dated paths keep `mala*` / `run_murr_wire_lab` until tool step 3 + module guests; rehearsals u19·u22 seated  
Radiant pass `20260728.054844` — delivery + memos landed u50: `murr_delivery` · `murr:*`
Radiant pass `20260728.053112` — tool-wave u32: living paths → murr_* witnesses/fixture/wire lab; memo mala:* held for module
Radiant pass `20260728.044925` — living rename-forward: **MUR** (was MALA); dated path · guest/witness `mala*` names held for tool/module waves

---

## Scope

Virtio twin of hosted M2: same sealed mint + receipt bytes over QEMU socket pairs (MUR lane; was MALA).

| Hop | Device port | Guests |
|-----|-------------|--------|
| Mint issuer→holder | **15569** | `guest_mala_mint_tx` / `guest_mala_mint_rx` |
| Receipt holder→issuer | **15570** | `guest_mala_receipt_tx` / `guest_mala_receipt_rx` |

Hosted `murr_delivery.rye` unchanged. Extend `tools/murr_m2_witness.rish` with the device lab (parity count stays **201** unless a separate stanza is preferred — keep count unchanged).

## DoD

1. Four guests GREEN banners: sealed mint / sealed receipt.
2. `comlink/run_murr_wire_lab.sh` GREEN.
3. `murr_m2_witness` GREEN with device stanza.
4. Full parity GREEN.
