# lib — Libraries

**Language:** EN  
**Last updated:** `20260802.011503` (Equinox e195 — Caravan Glow Tend limb 2)  
**Status:** Living — room open; Tally T1–T3 + Caravan C1–C2 seated

Shared gates and bound pedestals in Glow — the utility sameness that many desks call and none should re-carve.

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

## Caravan Glow Tend (Equinox B · nest-only Ashvini)

| Desk | Role | Witness |
| --- | --- | --- |
| [`shape-caravan-max-dependents.glow`](shape-caravan-max-dependents.glow) | Names `max_dependents=4` beside `caravan/capabilities.rye` | `tools/caravan_glow_tend_limb1_witness.rish` |
| [`shape-caravan-max-caps-per-dependent.glow`](shape-caravan-max-caps-per-dependent.glow) | Names `max_caps_per_dependent=8` beside `caravan/capabilities.rye` | `tools/caravan_glow_tend_limb2_witness.rish` |

```
rishi/bin/rishi run tools/glow_run.rish src/lib/gate-surface-double-u32.glow 21
rishi/bin/rishi run tools/glow_run.rish src/lib/gate-surface-inc-u32.glow 21
rishi/bin/rishi run tools/gen/season/src_first_resident_witness.rish
rishi/bin/rishi run tools/tally_glow_tend_limb1_witness.rish
rishi/bin/rishi run tools/tally_glow_tend_limb2_witness.rish
rishi/bin/rishi run tools/tally_glow_tend_limb3_witness.rish
rishi/bin/rishi run tools/caravan_glow_tend_limb1_witness.rish
rishi/bin/rishi run tools/caravan_glow_tend_limb2_witness.rish
rishi/bin/rishi run tools/active_designing_cycle.rish 7
```

Further candidates: Caravan C3 `max_name_len=48` · Tally T4 Glow runes · Aurora A1.
