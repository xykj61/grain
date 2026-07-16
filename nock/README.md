# Nock — the Second Backend, for Interop and Verification

**Language:** EN
**Last updated:** 2026-07-16 (lap 2 landed — the macro layer, opcodes 6-9 and 11, each proven equal to its own literal 0-5 expansion)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — opcodes 0-9 and 11, GREEN; opcode 10 (edit) honestly unimplemented

---

**Nock is Glow's second backend, never its execution floor.** Per [`../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`](../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md), Glow's primary path compiles straight through Zig to RISC-V — proven, green, byte-identical across seven keystone pieces, this interpreter's own two laps among them (see [`../tools/glow_riscv_target_witness.rish`](../tools/glow_riscv_target_witness.rish)). This interpreter exists for one purpose only: Urbit-world interop and verification, so Glow can meet the Nock world and be checked against it, the way Hoon itself once needed Nock as the floor a decade before RISC-V existed to be one.

## Lap 1 — the Primitive Core

Per [`../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md`](../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md)'s phased plan, this lap proves the Turing-complete primitive core:

| File | Proves |
|---|---|
| [`nock_core.rye`](nock_core.rye) | A noun (atom or cell, fixed-capacity pool, no heap); `/` slot addressing (tree addressing by bit-walk); `*[a 0 b]` through `*[a 5 b c]`; the autocons rule (`*[a [b c] d] = [*[a b c] *[a d]]`) |
| [`nock_core_witness.rye`](nock_core_witness.rye) | Eleven fixture-driven claims — every opcode's own stated reduction rule, plus the honest boundary (opcode 10) and the depth bound |

**The one place this file could have quietly exempted itself, and did not:** Nock's own semantics are naturally recursive, and TAME's root rule 2 states plainly that "recursion stays out, so that everything which should be bounded stays bounded." Rather than treat this interpreter as an implicit carve-out, `eval` and `eql` both carry an explicit depth counter, checked before every recursive step, refusing cleanly with `DepthExceeded` rather than trusting the host stack — witnessed directly (claim 11: a formula nested past the ceiling refuses, rather than overflowing). This is the [sameness-and-the-rune brief](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md)'s own resolved principle, kept here in running code rather than only argued in prose.

## Lap 2 — the Macro Layer, Proven Against Lap 1

The phased plan's own stated test for this lap: *"each opcode's witness proving it reduces to the same result as its stated 0-5 expansion."* `nock_core.rye` gains native, direct implementations of opcodes 6 (if/then/else), 7 (compose), 8 (extend the subject), 9 (invoke an arm — Hoon's own core-calling convention), and 11 (hint, semantically inert) — each fast and readable in its own right.

| File | Proves |
|---|---|
| [`nock_lap2_witness.rye`](nock_lap2_witness.rye) | Eleven claims. Every opcode proven **twice**: once through its native call, once through a hand-built formula using *only* primitives lap 1 already proved — opcode 6's own expansion, `*[a 6 b c d] = *[a *[[c d] 0 *[[2 3] 0 *[a 4 4 b]]]]` (per `old/doc/spec/nock/4.txt`, held whole in this fork's own tree — quoted exactly, bracket for bracket), reconstructed literally, one nested star at a time; opcodes 7, 8, and 9 each expressed as a pure opcode-2/autocons composition — and asserted to agree exactly, not merely argued to |

Opcode 10 (edit — splice a new value into a tree at an address, the constructive counterpart to slot addressing) needs a genuinely new tree-splice primitive this module has not yet built, and stays honestly unimplemented, refusing `UnimplementedOpcode` — a lap 3, not silently approximated as any opcode above.

## What This Interpreter Does Not Claim

- Opcode 10 (edit) is a later lap, named honestly rather than silently approximated.
- No Hoon-to-Nock compiler exists; this interpreter reduces hand-built nouns, not parsed Hoon source.
- No jet (acceleration) layer exists yet; every reduction runs the plain interpreter, unaccelerated.
- This is not, and is never meant to become, Glow's execution floor — RISC-V already holds that role, proven at [`../tools/glow_riscv_target_witness.rish`](../tools/glow_riscv_target_witness.rish).

---

*May the primitive core stay small enough to read in one sitting, and may every opcode this interpreter ever grows keep the same bound the first ten already prove: checked, and shown to reduce to what came before, not merely trusted.*
