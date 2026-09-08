# Mandi

**Vessel market floor** -- where harvests and amphorae change hands, weighed in daylight and priced in MUR.

**Language:** EN
**Last updated:** `20260908.034500` (what a verified listing proves; MUR was MALA) -- elder 2026-07-11 (steward demo nib **419** `004652`)
**Status:** Seated -- name + listing (`165634`); floor view (`170700`); listing settle (`171202`); settle view (`172955`); **steward demo** list->settle->Dimeroll (`004652`, nib **419**); live TigerBeetle rests until its brief
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Seating:** [`../context/specs/20260710-165634_mandi-name-seated.md`](../context/specs/20260710-165634_mandi-name-seated.md) - settle [`../context/specs/20260710-171202_mandi-listing-settle-seated.md`](../context/specs/20260710-171202_mandi-listing-settle-seated.md) - steward [`../active-designing/date/20260711/20260711-004652_commerce-citizen-steward-demo-hammock.md`](../active-designing/date/20260711/20260711-004652_commerce-citizen-steward-demo-hammock.md)
**Study:** [`../external-research/20260703-200712_compute-commerce-on-the-network.md`](../external-research/20260703-200712_compute-commerce-on-the-network.md)

## What a verified listing proves, and what it does not

Both seeds -- `0x67` for the listing and `0x68` for the settle -- are constants written in
`mandi_core.rye` and `listing_settle_core.rye`, so any reader of this tree can regenerate either
keypair. Verification therefore proves the body parses to its canonical form and the signature
over that form is intact. It proves nothing about **who** signed, which means this floor cannot
refuse a well-formed false price: a second listing naming the same vessel at another price
verifies exactly as well as the first. The lap shows that rather than claiming it -- the case
prints `forged listing accepted -- integrity proven, authority not` -- and what the floor rewards
today is a well-formed offer, never an authorized one. Binding a listing to a seller's own key
waits behind the identity-key gate.

## What this room is

Mandi names the offer: a signed `vessel-listing-v1` binds `vessel_parent` + MUR price under Kumara (seed `0x67`). The receipt is a digest of the canonical body -- quiet about buyer and seller. A sale closes with `vessel-settle-v1` (seed `0x68`) binding that receipt to a payment digest of MUR send + WOV transfer. Amphora purchase delivery rides the carriage rite.

**Sister room:** Granary holds the weave-sharing four doors. Mela and Haat stay parked as warm siblings.

## Listing

| Piece | Role |
|-------|------|
| `mandi_core.rye` | Sign / verify / receipt / parent bind |
| `mandi.rye` | Selftest binary |
| `tools/m/mandi_lap1.rish` | Witness -> parity **238** |

```sh
rishi/bin/rishi run tools/m/mandi_lap1.rish
```

## Floor view

Citizen window on Skate -- five lines: floor title, vessel parent prefix, price, receipt prefix, fold green. A listing with a tampered signature is refused.

```sh
rishi/bin/rishi run tools/m/mandi_floor_view.rish
```

Witness -> parity **240** (`mandiviewtest`).

## Listing settle

In-process close: listing receipt + `vessel-payment-v1` (MUR send digest + WOV transfer digest) under seed `0x68`. Refuses a zero amount, a tampered signature, mismatched receipt or payment or price, an overdraft, an insufficient balance, and a second close of one receipt.

```sh
rishi/bin/rishi run tools/m/mandi_listing_settle.rish
```

Witness -> parity **242**.

## Settle view

Citizen window on Skate -- six lines: settle title, listing receipt, price, payment prefix, settled, fold green. Double settle refused.

```sh
rishi/bin/rishi run tools/m/mandi_settle_view.rish
```

Witness -> parity **244** (`mandisettletest`).

## Held

Live TigerBeetle settlement rests until its own gate.

---

*May every vessel sold be bounded and every bound be honest.*
