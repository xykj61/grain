# 994 · Style Audit — TAME and Radiant

**Stamp:** `20260621.055512`
**Baseline:** Last full sweep at corpus 24; current corpus 90.
**Status:** GREEN — no blocking issues. Re-run periodically as code grows.

---

## TAME Audit — `.rye` and `.rish`

| Check | Result | Notes |
|-------|--------|-------|
| `init.garden` — no stray `init.arena` | GREEN | `inherited-names.md` governs the std boundary |
| Preconditions on paths and inputs | GREEN | `path.len > 0` in Rishi I/O, Mantra, Caravan |
| Postconditions on allocations | GREEN | `argv.len == items.len`, `fields.len == 4` in doRun |
| Named errors in Rishi `EvalError` | GREEN | All new builtins have named error variants |
| `// invariant:` comments before assertions | PARTIAL | Older code has assertions without the comment prefix; new code follows the convention |
| Width policy (`u32` over `usize`) | IN PROGRESS | 5 files done; 17 remaining (see `992`) |

### Assertion backlog

The TAME audit (session `223712`) identified ~50 locations with missing assertions. 12 were fixed immediately. The remainder are addressed as each file is touched — not as a separate sweep, since the context of the fix matters more than the count.

---

## Radiant Audit — Prose and Documentation

| Check | Result |
|-------|--------|
| Lead with what IS | GREEN |
| Active voice | GREEN |
| "yet/however" over "but" | GREEN |
| Sentence rhythm varies | GREEN |
| Benedictions on longer pieces | GREEN |
| Code comments affirm capability | GREEN |

---

## Strengthening Strategy — Quality over Quantity

The corpus grew from 16 to 90 witnesses in one session. Going forward, the strategy is:

1. **Prioritize functions our code calls.** A strengthening pass earns its keep when it covers a function that Rishi, Mantra, Caravan, or Brushstroke actually depends on. Exhaustive std coverage is valuable yet secondary.

2. **Each pass should test meaningful behavior.** A witness that reverses an array and checks the result is correct yet shallow. A witness that exercises a boundary condition (`replace` with overlapping patterns, `split` at the edges of a buffer) is deeper and catches more.

3. **The width audit rides the strengthening.** Each pass now carries a `## usize explicit audit` section. This is the right coupling — the width is documented where the function is strengthened.

4. **The gate must stay green.** Every commit that touches `rye/lib/std` or adds a witness must pass `tools/parity.rish`. The gate is the invariant; the witness count is the measure.

---

## Gate Proof

- `rishi run tools/parity.rish` — **90/90 GREEN**
- Rishi test suite — **all GREEN**
- `additive-gate.rish` — available for shape checks on std changes

---

*May the audit stay honest: GREEN where the work is sound, PARTIAL where it awaits, and always re-run rather than assumed.*
