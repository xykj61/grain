# Mandi Listing Settle -- Seated

**Stamp:** `20260710.171202` (Kaeden: keep going on the best recommended path)
**Language:** EN
**Style:** Gauge (see `../GAUGE_STYLE.md`)
**Status:** Seated -- Mandi lap 3 in-process settle; parity **242**
**Ground:** Mandi seating [`20260710-165634_mandi-name-seated.md`](20260710-165634_mandi-name-seated.md) - MUR M1 (was MALA) - WOV exit honesty

*Written by Kaeden and Rio 3.*
Radiant pass `20260725.035955`  
Radiant pass `20260728.044002` -- living L1 rename-forward: **MUR** (was MALA)

---

## The ruling

A Mandi vessel listing may close with a signed `vessel-settle-v1` slip that binds:

1. **listing_receipt** -- digest of the identity-free listing body
2. **payment** -- digest of `vessel-payment-v1` (amount + MUR send digest + WOV transfer digest; was MALA)

Kumara seed `0x68`. No buyer/seller fields. Amphora carriage stays separate. Live TigerBeetle and Granary weave settle wait their own gates.

## First lap (landed `20260710.171202`)

In-process only: MUR mint/send fold + WOV mint/transfer on a memory book (was MALA); refuse zero amount, lying sig, listing/payment/price mismatch, MUR overdraft, WOV insufficient, and double settle. Module `mandi/listing_settle_core.rye`; witness `tools/mandi_listing_settle.rish`; parity **242**.

---

*May every sale close on digests that outlive the handshake. May the meter and the book agree.*
