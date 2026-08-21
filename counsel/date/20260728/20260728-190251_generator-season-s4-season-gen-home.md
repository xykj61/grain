# Generator Season s4 — Live `tools/gen/season` home

**Stamp:** `20260728.190251` · **Voice:** Quin · **Season:** Generator · **Scope:** sext · **Round:** s4  
**Prior:** [s3 f4 rehearsal](20260728-190017_generator-season-s3-f4-first-home-rehearsal.md)  
**Ask:** waymark s3 complete / s4 next · kg live season-cohort move

## Verdict

**s4 LANDED.** Five Rishi generators home at `tools/gen/season/`. Old `tools/*.rish` paths stay as accrete shims (forward one argv; never default-run matrix). Dispatch and aliases speak the new home. O3 Glow desks untouched.

## Moved

| From | To |
| --- | --- |
| `tools/prin.rish` | `tools/gen/season/prin.rish` |
| `tools/prin_scope.rish` | `tools/gen/season/prin_scope.rish` |
| `tools/prin_ticker.rish` | `tools/gen/season/prin_ticker.rish` |
| `tools/sundial.rish` | `tools/gen/season/sundial.rish` |
| `tools/fascia_metric_v0.rish` | `tools/gen/season/fascia_metric_v0.rish` |

Living pin to edit: **`tools/gen/season/prin_scope.rish`**.

## Choir

| Path | Result |
| --- | --- |
| `rishi run tools/gen/season/prin.rish scope` | **GREEN** |
| `rishi run tools/prin.rish scope` (shim) | **GREEN** |
| `sundial` new + shim · shred refuse | **GREEN** / RED refuse |
| `fascia_metric_v0` new + shim | **GREEN** · fascia=86 |
| `gen_murr` · `gen_gren` · `gen_linn` | **GREEN** · deploy RED |
| `gen_home glow/gen` | **GREEN** · 317 / 12 |
| `prin once` | **GREEN** |

## Shim lesson

An early shim that always ran the target with zero args first launched `%prin matrix` (live TTY) and hung. Fixed: exclusive `length args == 0` / `!= 0` branches — one run only.

## What this round does *not* do

No O3 · no glow_* move · no fund-prep second wave · no shred · no MUR unpause · no whole-tree 610.

## Next

**LANDED s5** — `tools/gen/fund/` LIVE · six fund-prep · shims green.

---

*s4 season gen home · stamp `20260728.190251` · Quin · GREEN*
