# gate — Shared gates

**Language:** EN  
**Last updated:** `20260802.223739` (Equinox e259 — equality arc closes 8/8 · Rye tend)
**Status:** Living -- room open; a1 x9 - a2 whole - equality 8/8 seated, 4/8 heard - Comlink R1
**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`../../docs-geode/tutorials/the-first-hour.md`](../../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

Shared gates and utility pedestals in Glow — the sameness many desks call and none should re-carve.

## The a2 Folding Gates (STOA332–335)

| Gate | Fold | Sides |
|------|------|-------|
| `gate-tally-fold-sumto-u32` | sum 1..n within gardens=8; empty→0; past→0 | 0→0 · 3→6 · 8→36 · 9→0 |
| `gate-tally-fold-pair-sum` | pair-shape fields → one `@u32` | 0 0→0 · 3 5→8 |
| `gate-tally-fold-prodto-u32` | product 1..n within 8; empty→**1**; past→0; bound>12 named refuse | 0→1 · 3→6 · 8→40320 · 9→0 |
| `gate-tally-fold-triple-sum` | triple-shape fields → one `@u32` (STOA335) | 0 0 0→0 · 1 2 3→6 |
| `gate-tally-fold-quad-sum` | quad-shape fields → one `@u32` (emit N-wide) | 0…→0 · 1 1 1 1→4 |
| `gate-mantra-fold-triple-fields` | Mantra Weave desk — triple sum; pair path delegated | 3 5 7→15 · 0 0 0→0 |
| `gate-tally-fold-triple-prod` | triple-shape product (STOA336 — reducer chosen) | 3 5 7→105 · 1 1 1→1 · 0 4 9→0 |

Suite: `rishi/bin/rishi run tools/g/glow_tend_a2_suite.rish`

## The a1 Rishi Walls (elder-citing)

| Gate | Wall | Sides |
|------|------|-------|
| `gate-rishi-env-bindings-bound-u32` | env bindings = 512 | 300→1 · 900→0 |
| `gate-rishi-history-bound-u32` | history = 50 | 12→1 · 80→0 |

Witness: `rishi/bin/rishi run tools/r/rishi_a1_gate_walls_witness.rish` (also era 5/5)

## The Equality Gates (STOA337)

| Gate | Exact | Sides |
|------|-------|-------|
| `gate-aurora-seed-length-eq-u32` | seed_length = 32 | 32→1 · 31→0 · 33→0 |
| `gate-aurora-signature-length-eq-u32` | signature_length = 64 | 64→1 · 63→0 · 65→0 |
| `gate-aurora-living-stages-eq-u32` | living stages = 6 | 6→1 · 5→0 · 7→0 |
| `gate-caravan-exit-meanings-eq-u32` | exit meanings = 3 | 3→1 · 2→0 · 4→0 |
| `gate-mantra-line-fields-eq-u32` | line fields = 3 | 3→1 · 2→0 · 4→0 |
| `gate-mantra-weave-fields-eq-u32` | weave fields = 2 | 2→1 · 1→0 · 3→0 |
| `gate-mantra-diff-fields-eq-u32` | diff fields = 2 | 2→1 · 1→0 · 3→0 |
| `gate-mantra-store-dirs-eq-u32` | store dirs = 3 | 3→1 · 2→0 · 4→0 |

Witnesses: `tools/au/aurora_a1_seed_length_eq_witness.rish` - `tools/au/aurora_a1_signature_length_eq_witness.rish` - `tools/au/aurora_a1_living_stages_eq_witness.rish` - `tools/ca/caravan_c4_exit_meanings_eq_witness.rish` - `tools/rye/mantra_a1_line_fields_eq_witness.rye` - `tools/rye/mantra_a1_weave_fields_eq_witness.rye` - `tools/rye/mantra_a1_diff_fields_eq_witness.rye` - `tools/rye/mantra_a1_store_dirs_eq_witness.rye` -- eight gates, each proven at its seating.

**Four of the eight are heard, and four await a runner** (measured `20260906`). The Mantra four run every cadence lap under [`tools/m/mantra_a1_equality_witness.rish`](../../tools/m/mantra_a1_equality_witness.rish), which builds each witness against the desk it reads and asserts both its claim and its just-over side. The Aurora three and the Caravan one stand on no roster, and a grep across `tools/` and `construction/` returns their names only here -- so a lane that rosters them turns four silent proofs into four heard ones, and each is a short lap in its own room. All eight stood that way until this line was written. The sentence this replaced read *the equality arc stands closed (8/8)*, true of the seating and by now a claim about the present that something measures (REDS %482).

## The a1 Deciding Gates (STOA331)

Seven gates, four families, both sides each — proven whole in one lap by `tools/g/glow_tend_a1_suite.rish`. The era also has two honestly separated laps:

```
rishi/bin/rishi run tools/g/glow_tend_era_suite.rish   # pure lap (v20): a1 + R1 socketless; walls by seated wording; any host
rishi/bin/rishi run tools/co/comlink_r1_dual_stack_witness.rish  # metal lap: binds both families
rishi/bin/rishi run tools/g/glow_tend_a1_suite.rish    # a1 alone
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

Witness: `rishi/bin/rishi run tools/co/comlink_r1_dual_stack_witness.rish` — **leg A** pure · **leg B** metal (Framework GREEN; counsel RED without IPv6) · no wire-semantics change. Rival `families=2` pedestal withdrawn e222.

Structure museum pieces for Tend live under [`../shape/`](../shape/README.md).

## First residents

| Desk | Role | Witness |
| --- | --- | --- |
| [`gate-surface-double-u32.glow`](gate-surface-double-u32.glow) | Thin bartis · double one `@u32` | `tools/gen/chapter/src_first_resident_witness.rish` |
| [`gate-surface-inc-u32.glow`](gate-surface-inc-u32.glow) | Thin bartis · inc one `@u32` | same |

## Tally Glow Tend (Equinox B · nest-only Ashvini)

| Desk | Role | Witness |
| --- | --- | --- |
| [`shape-tally-max-gardens.glow`](shape-tally-max-gardens.glow) | Names `max_gardens=8` beside `tally/gardens.rye` | `tools/t/tally_glow_tend_limb1_witness.rish` |
| [`shape-tally-max-name-len.glow`](shape-tally-max-name-len.glow) | Names `max_name_len=32` beside `tally/gardens.rye` | `tools/t/tally_glow_tend_limb2_witness.rish` |
| [`shape-tally-copy-preconditions.glow`](shape-tally-copy-preconditions.glow) | Names `copy_disjoint` two preconditions beside `tally/copy.rye` | `tools/t/tally_glow_tend_limb3_witness.rish` |
| [`shape-tally-maybe-poles.glow`](shape-tally-maybe-poles.glow) | Names `maybe` two poles beside `tally/maybe.rye` | `tools/t/tally_glow_tend_limb5_witness.rish` |

## Caravan Glow Tend (bound pedestals; structures also in sur/)

| Desk | Role | Witness |
| --- | --- | --- |
| [`shape-caravan-max-dependents.glow`](shape-caravan-max-dependents.glow) | Names `max_dependents=4` beside `caravan/capabilities.rye` | `tools/ca/caravan_glow_tend_limb1_witness.rish` |
| [`shape-caravan-max-caps-per-dependent.glow`](shape-caravan-max-caps-per-dependent.glow) | Names `max_caps_per_dependent=8` beside `caravan/capabilities.rye` | `tools/ca/caravan_glow_tend_limb2_witness.rish` |

```
rishi/bin/rishi run tools/t/tally_glow_tend_limb5_witness.rish
rishi/bin/rishi run tools/t/tally_glow_tend_limb3_witness.rish
rishi/bin/rishi run tools/ca/caravan_glow_tend_limb4_witness.rish
rishi/bin/rishi run tools/au/aurora_glow_tend_limb1_witness.rish
```

Further candidates: Tally stack · more bartis gates. Sur holds C3–C4 · T4 · A1.
