# lib — Libraries

**Language:** EN  
**Last updated:** `20260802.194158` (Equinox e244 — Rishi walls · a2 pair-sum)
**Status:** Living — room open; a1 ×9 · a2 folds ×2 · Comlink R1 · pure + metal laps

Shared gates and utility pedestals in Glow — the sameness many desks call and none should re-carve.

## The a2 Folding Gates (STOA332 · STOA333)

| Gate | Fold | Sides |
|------|------|-------|
| `gate-tally-fold-sumto-u32` | sum 1..n within gardens=8; empty→0; past→0 | 0→0 · 3→6 · 8→36 · 9→0 |
| `gate-tally-fold-pair-sum` | pair-shape fields → one `@u32` | 0 0→0 · 3 5→8 |

Suite: `rishi/bin/rishi run tools/glow_tend_a2_suite.rish`

## The a1 Rishi Walls (elder-citing)

| Gate | Wall | Sides |
|------|------|-------|
| `gate-rishi-env-bindings-bound-u32` | env bindings = 512 | 300→1 · 900→0 |
| `gate-rishi-history-bound-u32` | history = 50 | 12→1 · 80→0 |

Witness: `rishi/bin/rishi run tools/rishi_a1_gate_walls_witness.rish` (also era 5/5)

## The a1 Deciding Gates (STOA331)

Seven gates, four families, both sides each — proven whole in one lap by `tools/glow_tend_a1_suite.rish`. The era also has two honestly separated laps:

```
rishi/bin/rishi run tools/glow_tend_era_suite.rish   # pure lap (v20): a1 + R1 socketless; walls by seated wording; any host
rishi/bin/rishi run tools/comlink_r1_dual_stack_witness.rish  # metal lap: binds both families
rishi/bin/rishi run tools/glow_tend_a1_suite.rish    # a1 alone
```


| Gate | Wall | Sides |
|------|------|-------|
| `gate-tally-dec-u32` | predecessor (call body) | EXIT-proof |
| `gate-tally-garden-bound-u32` | gardens = 8 | 3→1 · 9→0 |
| `gate-caravan-dependents-bound-u32` | dependents = 4 | 2→1 · 5→0 |
| `gate-aurora-wire-bound-u32` | wire = 512 | 128→1 · 600→0 |
| `gate-mantra-gen-floor-u32` | gen ≥ 1 | 1→1 · 0→0 |
| `gate-tally-name-len-bound-u32` | name-len = 32 | 12→1 · 40→0 |
| `gate-caravan-caps-bound-u32` | caps/dependent = 8 | 4→1 · 9→0 |

## Comlink R1 (e222 · pier pedestal wins · width face accreted)

| Gate | Wall | Sides |
|------|------|-------|
| `gate-comlink-dual-stack-bind-u32` | dual-stack policy on | 1→1 · 0→0 |
| `gate-comlink-addr-width-u32` | addr width ≤ 16 (tracks pedestal `ipv6_addr_len=16`) | 4→1 · 16→1 · 20→0 |

Witness: `rishi/bin/rishi run tools/comlink_r1_dual_stack_witness.rish` — **leg A** pure · **leg B** metal (Framework GREEN; counsel RED without IPv6) · no wire-semantics change. Rival `families=2` pedestal withdrawn e222.

Structure museum pieces for Tend live under [`../sur/`](../sur/README.md).

## First residents

| Desk | Role | Witness |
| --- | --- | --- |
| [`gate-surface-double-u32.glow`](gate-surface-double-u32.glow) | Thin bartis · double one `@u32` | `tools/gen/season/src_first_resident_witness.rish` |
| [`gate-surface-inc-u32.glow`](gate-surface-inc-u32.glow) | Thin bartis · inc one `@u32` | same |

## Tally Glow Tend (Equinox B · nest-only Ashvini)

| Desk | Role | Witness |
| --- | --- | --- |
| [`shape-tally-max-gardens.glow`](shape-tally-max-gardens.glow) | Names `max_gardens=8` beside `tally/gardens.rye` | `tools/tally_glow_tend_limb1_witness.rish` |
| [`shape-tally-max-name-len.glow`](shape-tally-max-name-len.glow) | Names `max_name_len=32` beside `tally/gardens.rye` | `tools/tally_glow_tend_limb2_witness.rish` |
| [`shape-tally-copy-preconditions.glow`](shape-tally-copy-preconditions.glow) | Names `copy_disjoint` two preconditions beside `tally/copy.rye` | `tools/tally_glow_tend_limb3_witness.rish` |
| [`shape-tally-maybe-poles.glow`](shape-tally-maybe-poles.glow) | Names `maybe` two poles beside `tally/maybe.rye` | `tools/tally_glow_tend_limb5_witness.rish` |

## Caravan Glow Tend (bound pedestals; structures also in sur/)

| Desk | Role | Witness |
| --- | --- | --- |
| [`shape-caravan-max-dependents.glow`](shape-caravan-max-dependents.glow) | Names `max_dependents=4` beside `caravan/capabilities.rye` | `tools/caravan_glow_tend_limb1_witness.rish` |
| [`shape-caravan-max-caps-per-dependent.glow`](shape-caravan-max-caps-per-dependent.glow) | Names `max_caps_per_dependent=8` beside `caravan/capabilities.rye` | `tools/caravan_glow_tend_limb2_witness.rish` |

```
rishi/bin/rishi run tools/tally_glow_tend_limb5_witness.rish
rishi/bin/rishi run tools/tally_glow_tend_limb3_witness.rish
rishi/bin/rishi run tools/caravan_glow_tend_limb4_witness.rish
rishi/bin/rishi run tools/aurora_glow_tend_limb1_witness.rish
```

Further candidates: Tally stack · more bartis gates. Sur holds C3–C4 · T4 · A1.
