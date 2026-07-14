# Mandi — Name Seated

**Stamp:** `20260710.165634` (Kaeden: likes the name suggestions; open what is needed)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Seated — vessel market floor name; lap 1 landed `20260710.165634` (parity **238**); floor view lap 2 `20260710.170700` (parity **240**); listing settle lap 3 `20260710.171202` (parity **242**); settle view lap 4 `20260710.172955` (parity **244**)
**Ground:** study [`../../external-research/20260703-200712_compute-commerce-on-the-network.md`](../../external-research/20260703-200712_compute-commerce-on-the-network.md) · Granary seating [`20260710-163043_granary-name-seated.md`](20260710-163043_granary-name-seated.md)

*Written by Kaeden and Rio 3.*

---

## The ruling

**Mandi** is the name of the produce / vessel market floor — where harvests and amphorae change hands, weighed in daylight and priced in MALA.

It is **not** Granary. Granary is the weave-sharing surface (four doors). Mandi is the commerce room where traveling vessels are listed and sold. Two markets, two roofs.

## Siblings parked

**Mela** (festival fair) and **Haat** (periodic village market) remain parked as warm alternates for related gathering surfaces. **Bazaar** stays parked — live collision with an outside protocol index.

## First lap (landed `20260710.165634`)

Signed vessel listing: `vessel_parent` + MALA price under Kumara; receipt digest without buyer/seller; bind check against a known parent digest; refuse zero price, lying sig, and parent mismatch. Module home `mandi/`; witness `tools/mandi_lap1.rish`; parity **238**. Floor view lap 2 landed `20260710.170700` — Skate `mandiviewtest`; parity **240**. Listing settle lap 3 landed `20260710.171202` — `vessel-settle-v1` binds listing receipt + MALA/WOV payment; parity **242**. Settle view lap 4 landed `20260710.172955` — Skate `mandisettletest`; parity **244**. Amphora purchase delivery remains the carriage rite; Mandi is the floor that names and closes the offer. Live TigerBeetle waits its own gate.

---

*May every vessel sold be bounded and every bound be honest. May the meter read true and the receipt outlive the sale.*
