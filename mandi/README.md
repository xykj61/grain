# Mandi

**Vessel market floor** — where harvests and amphorae change hands, weighed in daylight and priced in MALA.

**Language:** EN
**Last updated:** 2026-07-11 (steward demo nib **419** `004652`)
**Status:** Seated — name + listing (`165634`); floor view (`170700`); listing settle (`171202`); settle view (`172955`); **steward demo** list→settle→Dimeroll (`004652`, nib **419**); live TigerBeetle rests until its brief
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Seating:** [`../context/specs/20260710-165634_mandi-name-seated.md`](../context/specs/20260710-165634_mandi-name-seated.md) · settle [`../context/specs/20260710-171202_mandi-listing-settle-seated.md`](../context/specs/20260710-171202_mandi-listing-settle-seated.md) · steward [`../active-designing/20260711-004652_commerce-citizen-steward-demo-hammock.md`](../active-designing/20260711-004652_commerce-citizen-steward-demo-hammock.md)
**Study:** [`../external-research/20260703-200712_compute-commerce-on-the-network.md`](../external-research/20260703-200712_compute-commerce-on-the-network.md)

## What this room is

Mandi names the offer: a signed `vessel-listing-v1` binds `vessel_parent` + MALA price under Kumara (seed `0x67`). The receipt is a digest of the canonical body — quiet about buyer and seller. A sale closes with `vessel-settle-v1` (seed `0x68`) binding that receipt to a payment digest of MALA send + WOV transfer. Amphora purchase delivery rides the carriage rite.

**Sister room:** Granary holds the weave-sharing four doors. Mela and Haat stay parked as warm siblings.

## Listing

| Piece | Role |
|-------|------|
| `mandi_core.rye` | Sign / verify / receipt / parent bind |
| `mandi.rye` | Selftest binary |
| `tools/mandi_lap1.rish` | Witness → parity **238** |

```sh
rishi/bin/rishi run tools/mandi_lap1.rish
```

## Floor view

Citizen window on Skate — five lines: floor title, vessel parent prefix, price, receipt prefix, fold green. Lying listing refused.

```sh
rishi/bin/rishi run tools/mandi_floor_view.rish
```

Witness → parity **240** (`mandiviewtest`).

## Listing settle

In-process close: listing receipt + `vessel-payment-v1` (MALA send digest + WOV transfer digest) under seed `0x68`. Refuses zero, lying, mismatches, overdraft, insufficient, double settle.

```sh
rishi/bin/rishi run tools/mandi_listing_settle.rish
```

Witness → parity **242**.

## Settle view

Citizen window on Skate — six lines: settle title, listing receipt, price, payment prefix, settled, fold green. Double settle refused.

```sh
rishi/bin/rishi run tools/mandi_settle_view.rish
```

Witness → parity **244** (`mandisettletest`).

## Held

Live TigerBeetle settlement rests until its own gate.

---

*May every vessel sold be bounded and every bound be honest.*
