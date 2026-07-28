# MUR Season u49 — Module-wave step 2 live (entry + bin)

**Stamp:** `20260728.054644` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u49  
**Prior:** [u48 murr_core](20260728-053811_mur-season-u48-module-core-live.md)

## Verdict

**Module step 2 LANDED GREEN.** Entry `linengrow/mala.rye` → `murr.rye`; witnesses emit and run `linengrow/bin/murr`. Delivery remains `mala_delivery` / `bin/mala-delivery` until step 3. Wire memos `mala:*` and `fold_mala_log` still held.

## What moved

| From | To |
| --- | --- |
| `linengrow/mala.rye` | `linengrow/murr.rye` |
| `linengrow/bin/mala` (emit) | `linengrow/bin/murr` |
| `tools/murr_m1_witness.rish` build/run | `murr.rye` → `bin/murr` |
| `tools/murr_m2_witness.rish` M1 path | same (delivery still `mala-delivery`) |
| Selftest say-lines | MUR M1 (was MALA) |

## Witnesses (this stamp)

| Gate | Result |
| --- | --- |
| `murr_m1_witness` | **GREEN** |
| `murr_m2_witness` | **GREEN** |

## Held for later module steps

| Item | Owner |
| --- | --- |
| `mala_delivery.rye` · `bin/mala-delivery` | step 3 |
| `mala:*` memos · `fold_mala_log` | step 3 / symbol pass |
| `guest_mala_*` names | step 8 |

## Next

**u50** — module step 3: delivery + wire memos `murr:*`; M2 GREEN under new delivery home.

---

*u49 module entry/bin live · stamp `20260728.054644` · Quin · GREEN*
