# SETU6.5 Live-Sent GREEN — Pixel CDC-NCM as `enx*`

*Keaton approved lean A and said kg with the Pixel tethered. Desk armed on systemd’s predictable name `enx96e56705b13c` (driver `cdc_ncm`), unicasted the SETU5 framed payload to the tether gateway `10.201.192.38:38503`, and earned **sent**.*

**Language:** EN  
**Version:** `20260720.233805` (UDT)  
**Style:** Radiant  
**Voice:** Quin  
**Status:** Checkable — host onpath **GREEN** live-sent  
**Grounds in:** [`20260718-201601_setu65-lab-tx-gate.md`](20260718-201601_setu65-lab-tx-gate.md) · [`20260720-233109_setu65-live-sent-attempt-stand-in.md`](20260720-233109_setu65-live-sent-attempt-stand-in.md) · [`../docs/SETU.md`](../docs/SETU.md)

---

## Claim

| Item | Value |
|------|--------|
| Iface | `enx96e56705b13c` · `cdc_ncm` · Pixel `18d1:4eec` |
| Peer | `10.201.192.38` (default route on that iface) |
| Payload | 289b SETU5 framed |
| Result | **sent** · host `setu65_lab_tx_onpath_host` GREEN |

## What changed to earn it

1. **Probe** recognizes `enx*` CDC-NCM (`tools/fixtures/setu6_find_gadget_iface.sh`) — Graphene tether rarely names `ncm0`.  
2. **Rishi armed path** exits before stand-in asserts (false `if` arms still typecheck unbound `card`).  
3. **TX** unicasts to the iface gateway (limited broadcast needs CAP_NET_RAW).

## Hands

```bash
rishi/bin/rishi run tools/setu6_lab_probe_onpath_host.rish
rishi/bin/rishi run tools/setu65_lab_tx_onpath_host.rish
# → framed payload sent on enx…
```

---

*May the tether peer take the frame, and may enx stay an honest name for NCM.*
