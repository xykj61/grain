# Nock — the Second Backend, for Interop and Verification

**Language:** EN
**Last updated:** 2026-07-16 (lap 1 landed — noun, slot addressing, opcodes 0-5, autocons, all bounded)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — the primitive core, opcodes 0-5, GREEN

---

**Nock is Glow's second backend, never its execution floor.** Per [`../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`](../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md), Glow's primary path compiles straight through Zig to RISC-V — proven, green, byte-identical across four keystone vane families. This interpreter exists for one purpose only: Urbit-world interop and verification, so Glow can meet the Nock world and be checked against it, the way Hoon itself once needed Nock as the floor a decade before RISC-V existed to be one.

## Lap 1 — the Primitive Core

Per [`../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md`](../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md)'s phased plan, this lap proves the Turing-complete primitive core:

| File | Proves |
|---|---|
| [`nock_core.rye`](nock_core.rye) | A noun (atom or cell, fixed-capacity pool, no heap); `/` slot addressing (tree addressing by bit-walk); `*[a 0 b]` through `*[a 5 b c]`; the autocons rule (`*[a [b c] d] = [*[a b c] *[a d]]`); opcodes 6–11 refused honestly with `UnimplementedOpcode` |
| [`nock_core_witness.rye`](nock_core_witness.rye) | Eleven fixture-driven claims — every opcode's own stated reduction rule, plus the honest boundary and the depth bound |

**The one place this file could have quietly exempted itself, and did not:** Nock's own semantics are naturally recursive, and TAME's root rule 2 states plainly that "recursion stays out, so that everything which should be bounded stays bounded." Rather than treat this interpreter as an implicit carve-out, `eval` and `eql` both carry an explicit depth counter, checked before every recursive step, refusing cleanly with `DepthExceeded` rather than trusting the host stack — witnessed directly (claim 11: a formula nested past the ceiling refuses, rather than overflowing). This is the [sameness-and-the-rune brief](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md)'s own resolved principle, kept here in running code rather than only argued in prose.

## What Lap 1 Does Not Claim

- Opcodes 6–11 (the macro/sugar layer — conditionals, composition, Hoon's own calling convention, edits, hints) are a later lap, named honestly rather than silently approximated.
- No Hoon-to-Nock compiler exists; this interpreter reduces hand-built nouns, not parsed Hoon source.
- No jet (acceleration) layer exists yet; every reduction runs the plain interpreter, unaccelerated.
- This is not, and is never meant to become, Glow's execution floor — RISC-V already holds that role, proven at [`../tools/glow_riscv_target_witness.rish`](../tools/glow_riscv_target_witness.rish).

---

*May the primitive core stay small enough to read in one sitting, and may every opcode this interpreter ever grows keep the same bound the first six already prove: checked, not merely trusted.*
