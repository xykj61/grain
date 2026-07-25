# Reply — Quin relay restamp · one-clock duty 4 provenance

**Language:** EN  
**Stamp:** `20260725.120857`  
**Voice:** Quin  
**Ground:** origin/main `24bc1d1` · canonical clock `2026-07-25T12:06 -0400`

---

## A — RESTAMP (not merged as-is)

PR #131 was **open** when this relay ran — fixable without erratum.

The prior send used UTC stamps (`160000` · `160415`) four hours ahead of `America/New_York`. Main's newest stamp `114405` is uncontaminated. All branch dated artifacts restamped:

| Was (UTC drift) | Now (EDT) |
|-----------------|-----------|
| `20260725.160000` | `20260725.120701` |
| `20260725.160415` | `20260725.120702` |
| `20260725.155400` | `20260725.115400` |
| explore logs | `120656` · `120657` |

`one_clock_provenance_scan.sh` confirms no branch stamp exceeds host clock + 900s tolerance.

## B — Duty 4 PROVENANCE seated

`tools/one_clock_witness.rish` duty 4: stamps on new artifacts must not exceed live host clock by more than **`ONE_CLOCK_PROVENANCE_TOLERANCE_SECONDS=900`** (fifteen minutes — witness runtime · commit · push).

Fixture pair: live clock stamp **PASS** · four-hours-ahead stamp **FAIL**.

Duty 3 checks the host; duty 4 checks the stamp — different questions, both needed. Monotonicity cannot catch a forward jump.

Law updated: `context/specs/20260627-102012_one-clock-naming-law.md`.

## C — Benches confirmed GREEN

1. `markdown_structure_witness` — PASS + FAIL fixtures · column logic  
2. Mand `mand/` home — ring-1 · ring-2 witnesses  
3. Mand ring-3 test-only reach  
4. Shell harvest — fold · lines-bounded · filter chained · quote safe  
5. Glow text floor  

## Awaiting Keaton

Framework ritual for vere/old · data-dignity options — counsel may draft unasked.

**Recommend:** merge PR #131 after review; keep going on duty-8 shell-body migration.

Claim: [`waymarks/20260725-120701_mand-home-ring3.md`](../../waymarks/20260725-120701_mand-home-ring3.md)
