# lib — Libraries

**Language:** EN  
**Last updated:** `20260802.012507` (Equinox e199 — Tally T5 maybe poles)  
**Status:** Living — room open; Tally Tend utilities + Caravan C1–C2 bound pedestals

Shared gates and utility pedestals in Glow — the sameness many desks call and none should re-carve. Structure museum pieces for Tend live under [`../sur/`](../sur/README.md).

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
