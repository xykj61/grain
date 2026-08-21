# MUR Season u61 — Settle dual-digest design seat

**Stamp:** `20260728.062029` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u61  
**Prior:** [u60 unify brief](20260728-061801_mur-season-u60-wov-unify-brief.md)  
**Step:** design order **2** · design GREEN this stamp

## Verdict

**Keep both.** Living settle payment (`weave-payment-v1` / Mandi sibling) continues to require **`murr_digest` + `wov_digest`**. No field delete. No single-currency payment format this block. A staged **payment-v2** single-story lean is named as a *future design option only* — opens only after retirement (or an explicit later seat) proposes migration.

## Why keep both

| Reason | Note |
| --- | --- |
| Unify brief | WOV keeps `wov_digest` until retire |
| Hard line | no WOV delete / no early field merge |
| Living witnesses | mandi · granary · commerce · tube4 GREEN on dual proof |
| Honesty | collapsing digests before retire would pretend WOV is gone |

## Living law (seated)

```text
format weave-payment-v1
amount <digits>
currency murr
murr_digest <hex64>    # MUR send (or mint path) proof
wov_digest <hex64>     # WOV transfer (or book) proof
```

Both digests **required**. Currency token is **`murr`**. Format name stays `weave-payment-v1` until a versioned successor is seated.

## Staged option (not opened)

| Name | Lean | Gate |
| --- | --- | --- |
| **payment-v2** (proposed only) | Single-story payment under MUR product narrative — shape TBD | After WOV retirement plan seats migration, **or** a separate circled seat that accepts dual→single migration cost |

Until that gate: do not implement v2; do not weaken v1 dual require.

## Candidates weighed (not chosen for live)

| Lean | Cost | Verdict |
| --- | --- | --- |
| A — Keep both (v1) | none now | **seated** |
| B — Optional `wov_digest` | breaks conservation story at settle | refuse |
| C — Drop `wov_digest` now | early WOV erase | refuse |
| D — payment-v2 now | migration + witness churn without retire story | hold |

## Living prose touch (this stamp)

Settle-core headers still said “MALA send” — rename-forward to **MUR send** in:

- `granary/weave_settle_core.rye`
- `mandi/listing_settle_core.rye`

(No field or wire change.)

## What this round does *not* do

No `PaymentFields` shape change · no witness string churn beyond comment · no WOV retire · no payment-v2 code.

## Next

**kg u62** — exit-honesty rename-forward (MUR-native *names* for the same proofs) · design only.

---

*u61 dual-digest keep-both · stamp `20260728.062029` · Quin · design GREEN*
