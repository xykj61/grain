# MUR Season u71 — Fascia prune · memcpy ratchet tidy

**Stamp:** `20260728.153133` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u71  
**Prior:** [u70 yonder wave](20260728-152117_mur-season-u70-fascia-prune-yonder-wave.md) · tally copy [`../tally/copy.rye`](../tally/copy.rye)  
**Breach:** fascia prune **OPEN** · shred **RED**

## Verdict

**Memcpy app ratchet CLEARED.** The two remaining living `@memcpy(` call sites outside `tally/copy.rye` migrate to sameness (checked copy or comptime byte loop). Fascia 47→49. Amphora GREEN. Shred refuse.

## Changes

| Home | Before | After |
| --- | --- | --- |
| `pond/apps/window_input.rye` | bare `@memcpy` | `tally_copy.copy_disjoint` |
| `linengrow/dexter_glass_emoji.rye` | bare `@memcpy` (comptime seeds) | comptime byte `for` loop |
| `pond/apps/tally_copy.rye` | ABSENT | **symlink** → `../../tally/copy.rye` |

Comptime emoji seeds stay a loop — `copy_disjoint` asserts on pointers at runtime and is the wrong tool there. Runtime UTF-8 insert uses the public tally fold.

## Choir

| Witness | Result |
| --- | --- |
| `dexter_glass_witness` | **GREEN** |
| `murr_m1_witness` | **GREEN** |
| `gen_murr_fund_prep` | **GREEN** · deploy RED |
| `fascia_metric_v0` | **GREEN** · shred RED |

## Meter

| | u70 after | u71 after |
| --- | --- | --- |
| memcpy_app | 2 | **0** |
| ratchet_outstanding | 2 | **1** (parseint only) |
| fascia | 47 | **49** |

## What this round does *not* do

No shred · no parseInt migration sweep · no Inner unpause · no Class A delete.

## Next

**LANDED u72** — archival yonder · setu parseInt lean · glow emit held.

---

*u71 memcpy ratchet prune · stamp `20260728.153133` · Quin · GREEN · shred RED*
