# MUR Season u50 — Module-wave step 3 live (delivery + `murr:*`)

**Stamp:** `20260728.054844` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u50  
**Prior:** [u49 entry/bin](20260728-054644_mur-season-u49-module-entry-bin-live.md)

## Verdict

**Module step 3 LANDED GREEN.** Delivery is `murr_delivery.rye` / `bin/murr-delivery`. Wire memos are `murr:mint` · `murr:send` · `murr:receipt` (was `mala:*`). Fixture + thin-view string literals updated. `fold_mala_log` and `guest_mala_*` names still held.

## What moved

| From | To |
| --- | --- |
| `linengrow/mala_delivery.rye` | `linengrow/murr_delivery.rye` |
| `linengrow/bin/mala-delivery` | `linengrow/bin/murr-delivery` |
| `memo_* = "mala:…"` in `murr_core` | `"murr:…"` |
| `tools/fixtures/murr_m1_mint.bron` memo | `murr:mint` |
| `drawn_terminal` mint display strings | `murr:mint` |
| `murr_m2_witness` build path | `murr_delivery` → `murr-delivery` |

## Witnesses (this stamp)

| Gate | Result |
| --- | --- |
| `murr_m1_witness` | **GREEN** |
| `murr_m2_witness` | **GREEN** (hosted + device) |

## Held

| Item | Owner |
| --- | --- |
| `fold_mala_log` symbol | later symbol / cluster pass |
| `guest_mala_*` guest names | step 8 |
| Variable names `const mala = @import(murr_core)` in mandi/granary | optional polish |

## Next

**u51** — neth importer cluster choir (step 4), or light symbol pass `fold_mala_log` → `fold_murr_log` if he seats it first.

---

*u50 delivery + memos live · stamp `20260728.054844` · Quin · GREEN*
