# MUR Season u48 — Module-wave step 1 live (`murr_core`)

**Stamp:** `20260728.053811` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u48  
**Prior:** [u34 tool spine](20260728-053632_mur-season-u34-tool-wave-harden.md) · [u22 opener](20260728-051844_mur-season-u22-module-wave-opener-rehearsal.md) · [u15 prep](20260728-050833_mur-season-u15-module-wave-prep.md)

## Verdict

**Module step 1 LANDED GREEN.** `linengrow/mala_core.rye` → `murr_core.rye`; all rye `@import` sites and install symlinks (`mandi` · `comlink` · `granary` · pond apps) repointed. `fold_mala_log` and `mala:*` memos **held** for later module steps. Entry/bin still `mala.rye` / `bin/mala`.

## What moved

| From | To |
| --- | --- |
| `linengrow/mala_core.rye` | `linengrow/murr_core.rye` |
| Symlinks `*/mala_core.rye` | `*/murr_core.rye` → `linengrow/murr_core.rye` |
| `@import("mala_core.rye")` (~47 rye) | `@import("murr_core.rye")` |
| `pond` `mandi/mala_core.rye` | `mandi/murr_core.rye` |

**Held:** `fold_mala_log` · `memo_mint = "mala:mint"` (etc.) · `mala.rye` / `mala_delivery.rye` / `bin/mala` · `guest_mala_*` names

## Witnesses (this stamp)

| Gate | Result |
| --- | --- |
| `gen_murr` | GREEN · deploy RED |
| `murr_m1_witness` | **GREEN** |
| `murr_m2_witness` | **GREEN** (after comlink symlink fix) |

## Note

Broken `comlink/mala_core.rye` symlink after the rename caused a first M2b RED; retargeting to `comlink/murr_core.rye` restored GREEN. Same pattern applied at granary / pond app symlink farms.

## Next

**u49** — module step 2: rename entry + bin (`mala.rye` → `murr.rye` · `bin/mala` → `bin/murr`) and point witnesses at new paths.

---

*u48 module core live · stamp `20260728.053811` · Quin · GREEN*
