# MUR Season u22 — Module-wave opener rehearsal

**Stamp:** `20260728.051844` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u22  
**Breach:** rename-overwrite **approved · seated** · **No live rename this round**  
**Prior:** [u21 tool GO](20260728-051741_mur-season-u21-tool-wave-go-nogo.md) · [u15 module prep](20260728-050833_mur-season-u15-module-wave-prep.md)

## Verdict

**u48 step 1 is rehearsed — and widened honestly.** Renaming `linengrow/mala_core.rye` → `murr_core.rye` requires **every** `@import("mala_core.rye")` (and zig `mala_core.zig` import sites) to repoint in the same sitting. The u15 line “update imports in `mala.rye` / `mala_delivery` only” names the **selftest gate consumers**, not the full import surface. Symbol `fold_mala_log` and memo consts may travel with later module steps if path-only lands first.

**Prefer tool-wave GO (`kg u32`) before module wave** (u15 step 0). This round waits; it does not open u32 or u48.

## Baseline (this stamp)

| Probe | Result |
| --- | --- |
| `gen_murr` | GREEN · deploy RED |
| `gen_mala` | ABSENT |
| Tool-wave GO card | seated u21 |
| `linengrow/mala_core.rye` | PRESENT |
| Standalone `mala_core.zig` in tree | **ABSENT** (zig sites `@import("mala_core.zig")` — twin/emit discipline at live wave) |
| Linengrow files touching core/fold | **~55** |
| Early `murr_core.rye` | ABSENT (correct) |

## Dry-run — u48 step 1 (core path)

### Moves (when live · after tool wave preferred)

1. `git mv linengrow/mala_core.rye linengrow/murr_core.rye`
2. Header/docs: MALA → MUR (was MALA)
3. **Repoint all** `@import("mala_core.rye")` → `murr_core.rye` (and `mandi/mala_core` / pond paths) in one commit cluster
4. Exit gate: `mala.rye` / M1 selftest still GREEN via updated import (bin may still be `mala` until step 2)
5. Optional same-sitting: `fold_mala_log` → `fold_murr_log` — **wide**; may defer to a symbol pass if path-only is cleaner

### Hold for later module steps

| Item | Owner |
| --- | --- |
| `memo_mint = "mala:mint"` (and send/receipt) | module step 3 |
| `mala.rye` → `murr.rye` · `bin/mala` → `bin/murr` | module step 2 |
| Neth / seva / tube / pool / guests clusters | steps 4–8 |
| Tool witnesses / parity / wire lab | **u32** (GO card) — do first when possible |

### Primary gate consumers (step 1 selftest)

| Path | Role |
| --- | --- |
| `linengrow/mala.rye` | M1 selftest |
| `linengrow/mala_delivery.rye` | M2 hosted |

### Import surface (must repoint with file move)

**Linengrow (sample):** `neth_serial_core` · `neth_root_*` · `seva_*` · `tube1_admission` · `tube4_market_rail` · `pool_host_seam` · `glow_seva_b0_*` · guests via relative `mala_core.rye`  
**Outside:** `mandi/listing_settle.rye` · `mandi/commerce_steward_demo.rye` · `granary/weave_settle.rye` · `pond/apps/drawn_terminal.rye` (`mandi/mala_core.rye`) · `comlink/guest_mala_*.rye`

Full living list: re-run `rg '@import\("mala_core'` at open time — counts drift.

## Relation to tool wave

| If | Then |
| --- | --- |
| Keaton seats **kg u32** | Execute tool GO plan; module rehearsal stays on the shelf |
| Keaton continues u-rounds | u23+ may harden expanding-prompt citations / intentional holds; still no rye rename |
| Keaton seats **kg u48** early | Allowed if circled — step 0 preference is tools-first, not a hard block |

## What this round does *not* do

No `git mv` · no import edits · no symbol rename · no u32 execution · no deploy/shred.

## Next

**Seat `kg u32`** (tool-wave GO) — preferred door — or **u23** continue waiting harden (prose citations / holds).

---

*u22 module-wave opener rehearsal · stamp `20260728.051844` · Quin*
