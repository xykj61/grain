# Mandi Listing Settle — Seated

**Stamp:** `20260710.171202` (Kaeden: keep going on the best recommended path)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Seated — Mandi lap 3 in-process settle; parity **242**
**Ground:** Mandi seating [`20260710-165634_mandi-name-seated.md`](20260710-165634_mandi-name-seated.md) · MALA M1 · WOV exit honesty

*Written by Kaeden and Rio 3.*

---

## The ruling

A Mandi vessel listing may close with a signed `vessel-settle-v1` slip that binds:

1. **listing_receipt** — digest of the identity-free listing body
2. **payment** — digest of `vessel-payment-v1` (amount + MALA send digest + WOV transfer digest)

Kumara seed `0x68`. No buyer/seller fields. Amphora carriage stays separate. Live TigerBeetle and Granary weave settle wait their own gates.

## First lap (landed `20260710.171202`)

In-process only: MALA mint/send fold + WOV mint/transfer on a memory book; refuse zero amount, lying sig, listing/payment/price mismatch, MALA overdraft, WOV insufficient, and double settle. Module `mandi/listing_settle_core.rye`; witness `tools/mandi_listing_settle.rish`; parity **242**.

---

*May every sale close on digests that outlive the handshake. May the meter and the book agree.*
