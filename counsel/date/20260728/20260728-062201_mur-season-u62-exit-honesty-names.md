# MUR Season u62 — Exit-honesty MUR-native names

**Stamp:** `20260728.062201` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u62  
**Prior:** [u61 dual-digest](20260728-062029_mur-season-u61-settle-dual-digest.md) · exit honesty [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md)  
**Step:** design order **3** · design GREEN this stamp

## Verdict

**Names seated; wire unchanged.** Living memos stay `wov:root` / `wov:exit` and bundle header `wov-exit-bundle/v1`. MUR-native **aliases** are named for the same proofs so the product story can say MUR without pretending WOV grammar is gone. No prefix migration this round.

## Living wire (law until migration)

| Surface | Living token |
| --- | --- |
| Root fact memo | `wov:root …` |
| Exit fact memo | `wov:exit …` |
| Exit bundle header | `wov-exit-bundle/v1` |
| Code home | `linengrow/wov_core.rye` |
| Spec home | dated `…_wov-exit-honesty.md` (path kept) |

## MUR-native aliases (design · future)

| Living | Alias (proposed) | Same proof |
| --- | --- | --- |
| `wov:root` | `murr:book-root` | monarch-signed L2 state root on MUR log |
| `wov:exit` | `murr:book-exit` | holder exit credit into MUR |
| `wov-exit-bundle/v1` | `murr-book-exit-bundle/v1` | content-addressed balance table |

**Why “book”:** names the L2 conservation book without stealing `murr:mint|send|receipt` and without claiming Mycelium.

## Migration rule (not opened)

1. **Today:** emit and accept **only** living `wov:*` tokens.  
2. **Dual-accept lap** (future seat): accept `wov:*` **or** alias; emit still `wov:*` (or emit alias only after a circled cutover).  
3. **Retirement block** (charter u96+): propose dropping `wov:*` emit after dual-accept GREEN long enough.  

No dual-accept code until a later kg seats it.

## Prose / edu lean (now)

When teaching unify: say **MUR book root / book exit** in Radiant prose, and point at living `wov:*` wire as the current bytes. Specs keep dated paths; Radiant-pass lines may cite the alias table.

## Living comment polish (this stamp)

`wov_core.rye` comments that still sold **MALA** as the L1 log → **MUR** (seeds line keeps “was MALA” width note). Wire strings untouched.

## What this round does *not* do

No memo prefix change in rye · no bundle header bump · no witness golden rewrite · no WOV delete.

## Next

**LANDED u63** — choir GREEN · design 0–5 done · prefer check-in.

---

*u62 exit-honesty names · stamp `20260728.062201` · Quin · design GREEN*
