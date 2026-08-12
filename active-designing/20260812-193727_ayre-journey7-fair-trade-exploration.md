# AYRE Journey 7 — Fair-trade certification: a certificate a record satisfies

**Stamp:** `20260812.193727` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens Season 2, Journey 7 (Fair-trade) under the seated **AYRE** waymark
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`../pond/apps/tablecloth_brix.rye`](../pond/apps/tablecloth_brix.rye) · [`../pond/apps/commerce_trade.rye`](../pond/apps/commerce_trade.rye) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

---

## Where the road stands

Season 2 (Yield) proved every reading and owning module on real data: GISM Journey 5 read real tree documents end to end, Journey 6 gave a real document a Kumara-signed content-addressed chain of custody, and the spool arc (chunking · naming · owner-signed · receipt-travels) closed red #73 so provenance stands on documents too large for one resin. The itinerary's Season 2 names a second durable promise beyond *stands on real data*: **trades fairly.** Its Journey 7 is **Fair-trade (AYRE)**, and its crux is written plainly — *a certificate a store satisfies, the Brix-declaration pattern (BUHR-J7r3) carried to a real cooperative record.*

## The crux, named

A fair-trade certificate should mean exactly one honest thing: **a set of criteria a cooperative record either satisfies in full or fails by name.** Not a badge a seller prints; a *join* between a declaration of what fair trade requires and a record of what a cooperative actually holds — so certification can never claim a criterion the record does not meet.

This is the same shape BUHR-J7r3 already proved for artifacts: `tablecloth_brix.evaluate` reads a `format tablecloth-decl-v1` descriptor (one `require <name>` line per needed artifact) and evaluates it *against a live store* into a manifest of exactly those artifacts, refusing the whole evaluation (`Unsatisfied`) when the store cannot serve a required name. Fair-trade certification is that pattern carried from artifacts to **fair-trade criteria** against a cooperative's **record of attestations**.

## Grounding — real modules, no new abstraction

- **The declaration idiom** is `tablecloth_brix`'s own `format …-decl-v1` / `require <name>` shape, read line by line as flat Bron. The certificate reuses it: `format fairtrade-cert-v1`, one `require <criterion>` line per fair-trade requirement.
- **The record** is a bounded set of named attestations a cooperative holds — the criteria it can honestly claim. Evaluating a certificate against a record is the same *every-required-name-is-held* join, refusing `Unsatisfied` on the first criterion the record lacks, never certifying a gap.
- **Later rungs reach the signed and the booked halves** (below), grounded in `kumara`'s signing (as `commerce_trade_signed` binds a trade to two identities) and `dimeroll`'s trial-balance conservation (as `commerce_trade` books a fair-value trade) — so a certificate is not only satisfied but *signed by the parties* and *tied to a fairly-booked trade*. Disbursement stays custody gate #3.

## The four rounds (Lindy-first, crux-first)

1. **AYRE-J7r1 — the certificate satisfied (the crux).** A `format fairtrade-cert-v1` certificate declaring required criteria is evaluated against a cooperative record of held attestations; a record holding every required criterion yields a satisfied certificate naming exactly the criteria met, in declared order; a record missing any required criterion refuses the whole evaluation (`Unsatisfied`) rather than certify a gap. A malformed or empty certificate refuses (`BadCertificate`). Pure declaration-satisfaction, no signing yet — the spine the later rungs wire real identity and books into, known correct first.
2. **AYRE-J7r2 — the certificate signed.** Each criterion's attestation is signed by the attesting party over the exact fact (mirroring `commerce_trade_signed`); a satisfied certificate requires every attestation's signature to verify, so a steward cannot certify a criterion no party vouched for.
3. **AYRE-J7r3 — the certificate travels.** The satisfied certificate renders to a `format fairtrade-cert-v1` (or paired manifest) Bron record and parses back byte-for-byte, still satisfied — a portable, verifiable certificate a recipient checks offline (mirroring the receipt-travel rungs).
4. **AYRE-J7r4 — the certificate tied to a fair trade.** The certified cooperative's trade books fairly in Dimeroll (each book nets to zero, the pair conserves across the cash line, as `commerce_trade` proves), so a fair-trade certificate is bound to an honestly-booked fair-value trade — facts only; disbursement is custody gate #3, licensed counsel.

## Discipline this round keeps

- **Facts only.** Dimeroll records; no funds move, no key is held, no rail opens — custody gate #3 stays the maintainer's hand.
- **Additive.** Each rung composes public API and re-runs the modules beneath it GREEN; nothing already seated is retired.
- **Demo seeds only.** No real cooperative, no real identity — the shape is proven on demo attestations, exactly as the commerce and provenance rungs proved theirs.
- **Witness before narrative.** Every rung closes on a GREEN witness on metal, TAME + width clean.

---

*May a certificate mean only what a record can honestly bear, and may fair trade read the same to the producer as to the buyer.*
