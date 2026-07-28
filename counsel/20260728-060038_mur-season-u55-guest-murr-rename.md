# MUR Season u55 — Guest `murr` rename

**Stamp:** `20260728.060038` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u55  
**Prior:** [u54 zig twin sync](20260728-055837_mur-season-u54-zig-twin-sync.md)  
**Order:** [u15 module-wave prep](20260728-050833_mur-season-u15-module-wave-prep.md) step **8**

## Verdict

**Guest rename LANDED GREEN.** Comlink M2b guests and wire-lab elves now carry `murr` names. `murr_m2_witness` GREEN (hosted + device wire).

## What moved

| From | To |
| --- | --- |
| `comlink/guest_mala_{mint,receipt}_{tx,rx}.rye` | `guest_murr_*` |
| Wire-lab elves `mala-*.elf` | `murr-*.elf` |
| Guest say-lines `mala m2b device wire:` | `murr m2b device wire:` |
| Living M2b expanding-prompt guest table | `guest_murr_*` |

`comlink/run_murr_wire_lab.sh` was already landed at u32.

## Witnesses (this stamp)

| Gate | Result |
| --- | --- |
| `gen_murr_fund_prep` | **GREEN** · deploy RED |
| `murr_m1_witness` | **GREEN** |
| `murr_zig_twin_sync_witness` | **GREEN** |
| `murr_m2_witness` (hosted + device) | **GREEN** |

## Held

| Item | Owner |
| --- | --- |
| Currency `"mala"` · settle field `mala_digest` | **u56** step 9 |
| Selftest say-lines · remaining `"mala"` strings · `const mala` locals | step 9 |

## Next

**u56** — remaining `"mala"` say-lines · currency wire · selftest unit strings (step 9).

---

*u55 guest_murr rename · stamp `20260728.060038` · Quin · GREEN*
