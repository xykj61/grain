# OA-L4 escrow-release fold compatibility

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.023812

**Prompt:** Claude counsel `20260707.023512` — MALA graduation ruling + fold gap.

## Thinking trace

Counsel verified: MALA graduation has **not** fired — `foldReputationLog` is an independent fold, not a consumer of escrow's public surface. Sharper finding: `classifyFact` buckets escrow hold/release as `.completion`, but reputation only accepted `completion request_ref=` memos — escrow-mediated bounties would refuse whole.

Implemented the **smaller fix** counsel named: `completionRequestRef` accepts plain completion and `escrow-release`, skips `escrow-hold` silently. Extended witness bolt with `req_d` (escrow + grant) and `req_e` (escrow + withhold); counts now 3 consented / 300 stipend.

## Observations

Deeper fix (reputation calls `foldEscrowLog`) deferred — value-model seam for Kaeden. MALA module extraction stays on hold.

## Files

| File | Why |
|------|-----|
| `counsel/20260707-023512_claude-counsel-mala-graduation-and-fold-gap.md` | Counsel filed |
| `linengrow/open_asks.rye` | `completionRequestRef` + witness bolt |
| `work-in-progress/TASKS.md` | MALA on hold; fold gap closed |

**Recommend:** keep going to **real clock in poll loop** — mechanical Caravan/Mantra; MALA/`mala/` waits on graduation or Kaeden's deeper-fix word.
