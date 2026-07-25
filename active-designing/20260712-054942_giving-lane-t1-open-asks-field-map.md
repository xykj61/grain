# Giving-Lane T1 — Open Asks Stipend Field Map

*Gap list only. One living gift path — the OA-L1 animation micro-gig stipend — mapped field-by-field against the seated giving-lane asymmetry: private payer · transparent payee. No code. No new fact shapes.*

**Stamp:** `20260712.054942`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Lens:** CIVIC · giving lane T0 · consent architecture
**Status:** Checkable-room — gap map; T1 landed; T2 (glass / SLC-L4 wire) waits on word
**Ground:** T0 [`../foundations/20260629-014512_money-that-stays-close-to-home.md`](../foundations/20260629-014512_money-that-stays-close-to-home.md) · study 4 [`../external-research/20260712-054521_taler-giving-lane-asymmetry.md`](../external-research/20260712-054521_taler-giving-lane-asymmetry.md) · OA-L1 hammock [`20260706-002912_open-asks-hammock-scope.md`](20260706-002912_open-asks-hammock-scope.md) · OA-L4 consent · civic sight tip **430** · consumer-surface audit [`../counsel/20260711-060112_claude-counsel-consumer-surface-protection-audit.md`](../counsel/20260711-060112_claude-counsel-consumer-surface-protection-audit.md)

---

## The gift under the glass

**Path:** Open Asks closed loop — post → apply → accept → complete (stipend) → optional consent.  
**Fixture meaning:** poster pays applicant a stipend (movement micro-gig shape; civic sight golden shows lifecycle · escrow · consented · stipend aggregates).  
**Payer:** poster (`from` on completion).  
**Payee:** applicant (`to` on completion).

## Field map

| Fact / surface | Field | On the fold today | Giving-lane face | Fit |
|----------------|-------|-------------------|------------------|-----|
| Request | `poster` | Public (signed fact) | Payer identity | **Gap** — payer named at ask time |
| Request | `title` · `skills` · `bounds` · `deadline` | Public | Commons context | Fit — work description is public good |
| Request | `stipend` | Public exact integer | Payer amount (offered) | **Gap** — exact offer amount public before pay |
| Application | `applicant` | Public | Payee identity | Fit — payee face wants identity visible to poster; on shared log it is world-visible |
| Application | `message` | Public | Payee note | Ambiguous — cover note may be personal |
| Acceptance | `poster` · `applicant` · `request_ref` | Public | Both sides named | **Gap** on payer; fit on payee |
| Completion (SLC-L1) | `from` | Public | **Payer** | **Gap** — exact payer identity on payment fact |
| Completion | `to` | Public | **Payee** | Fit — transparent payee |
| Completion | `amount` | Public exact | **Payer amount** | **Gap** — exact gift amount public (SLC-L4 tier proof exists, not wired here) |
| Completion | `memo` (`completion request_ref=…`) | Public | Linkage | Fit — binds loop without new privacy |
| Escrow (OA-L3) | hold / release amounts · Nyasa | Public on fold | Payer funds in transit | **Gap** — amount trail visible |
| Consent (OA-L4) | `applicant` · `consent` grant/withhold | Public fact; tally counts grant only | Payee reputation choice | Fit — self-sovereign; silence = privacy for *reputation counting* |
| Civic sight | `consented` · `stipend` aggregates · `withheld=excluded` | Aggregates only, no identity rows | Commons audit | Fit — payee-side glass; does not hide underlying log |

## What already holds

- **Consent-before-counting** is excellent for *reputation*: only the applicant’s key grants; withhold and silence exclude; civic sight prints `withheld=excluded`.
- **Payee identity and receipt of funds** are on the fold — transparent payee face is largely met for the stipend path.
- **Civic sight** shows aggregates, not identity-tied donor rows — the glass leans the right way even when the log is still plain.

## Gaps (ranked smallest-first for a later T2)

1. **Exact `amount` on completion is public** — giving-lane wants payer-amount privacy (tier or sealed); SLC-L4 fixed-tier Sigma is the in-tree tool, not yet composed into OA complete.
2. **`from` (payer) on completion is public** — giving-lane wants payer identity private by default; no OA fact shape yet for “pay without naming the poster on the public payment line.”
3. **Request `stipend` and `poster` are public at post** — offer side leaks payer identity and exact budget before the gift moves.
4. **Escrow amount trail** — same amount privacy question during Nyasa hold/release.
5. **Application `message`** — may need a private lane or pass-gated read (consumer edge) when cover notes carry sensitive biography.

**Non-gaps:** `to` on completion; consent grant/withhold semantics; civic sight aggregate posture; digest≠capability (Granary) — orthogonal but held.

## Counsel for T2’s shape (`061012` — not seated)

Recorded in [`../counsel/20260712-061012_claude-counsel-post-seam-disposition.md`](../counsel/20260712-061012_claude-counsel-post-seam-disposition.md). Three additions that leave this map’s ranking intact:

1. **Loop-scoped, not line-scoped.** Sealing `from` on completion alone buys little while request and acceptance name the poster (gap 3). Real payer quiet means a per-ask pseudonymous poster key from post through completion, with Nyasa as the trust bridge.
2. **Two honest shapes — do not confuse.** *Quiet by courtesy* — consent-gated withholding on the glass (OA-L4 / `withheld=excluded`); fold still tells; small and shippable. *Private by proof* — tier mudra / buds on the fold; real log privacy; crosses MALA plaintext conservation (`fold_mala_log`); wants its own brief before wire. Claude’s lean: courtesy as T2, proof as T3 in the ZK season (warm names still **proposed** — [`../context/specs/20260712-061012_bud-and-mudra-names-seated.md`](../context/specs/20260712-061012_bud-and-mudra-names-seated.md)).
3. **Gap 5 meets Door 3.** Pass-gated cover notes are the consumer-edge pass arriving on this lane; the grain agrees.

## What T1 does not open

- No new `.bron` fields
- No SLC-L4 wire into OA-L5
- No change to civic sight golden
- No sanctuary care-log map (parallel path; same asymmetry applies when its season opens)
- No T2 wire — choice brief awaits word after sync-and-parks

## Return to the bench

| Item | Status |
|------|--------|
| Giving-lane T1 | **Landed** — this gap map |
| Giving-lane T2 | **Choice seated** `062656` — courtesy now · proof as T3 — [`20260712-062656_giving-lane-t2-choice-brief.md`](20260712-062656_giving-lane-t2-choice-brief.md); wire awaits word |
| Tip **430** green | Untouched |

---

*May the map name every field honestly. May the gaps we list be small enough to close with care. May the payee stay in the light, and the payer keep a quiet door.*
