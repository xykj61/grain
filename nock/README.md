# Nock — the Second Backend, for Interop and Verification

**Language:** EN
**Last updated:** 2026-07-16 (lap 3 landed — the edit primitive and opcode 10; opcodes 0 through 11, the whole of Nock's own numbered core, are now real)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — opcodes 0 through 11, GREEN

---

**Nock is Glow's second backend, never its execution floor.** Per [`../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`](../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md), Glow's primary path compiles straight through Zig to RISC-V — proven, green, byte-identical across eight keystone pieces, this interpreter's own three laps among them (see [`../tools/glow_riscv_target_witness.rish`](../tools/glow_riscv_target_witness.rish)). This interpreter exists for one purpose only: Urbit-world interop and verification, so Glow can meet the Nock world and be checked against it, the way Hoon itself once needed Nock as the floor a decade before RISC-V existed to be one.

## Lap 1 — the Primitive Core

Per [`../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md`](../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md)'s phased plan, this lap proves the Turing-complete primitive core:

| File | Proves |
|---|---|
| [`nock_core.rye`](nock_core.rye) | A noun (atom or cell, fixed-capacity pool, no heap); `/` slot addressing (tree addressing by bit-walk); `*[a 0 b]` through `*[a 5 b c]`; the autocons rule (`*[a [b c] d] = [*[a b c] *[a d]]`) |
| [`nock_core_witness.rye`](nock_core_witness.rye) | Eleven fixture-driven claims — every opcode's own stated reduction rule, plus the honest boundary (opcode 12, now that opcodes 0 through 11 are all real) and the depth bound |

**The one place this file could have quietly exempted itself, and did not:** Nock's own semantics are naturally recursive, and TAME's root rule 2 states plainly that "recursion stays out, so that everything which should be bounded stays bounded." Rather than treat this interpreter as an implicit carve-out, `eval` and `eql` both carry an explicit depth counter, checked before every recursive step, refusing cleanly with `DepthExceeded` rather than trusting the host stack — witnessed directly (claim 11: a formula nested past the ceiling refuses, rather than overflowing). This is the [sameness-and-the-rune brief](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md)'s own resolved principle, kept here in running code rather than only argued in prose.

## Lap 2 — the Macro Layer, Proven Against Lap 1

The phased plan's own stated test for this lap: *"each opcode's witness proving it reduces to the same result as its stated 0-5 expansion."* `nock_core.rye` gains native, direct implementations of opcodes 6 (if/then/else), 7 (compose), 8 (extend the subject), 9 (invoke an arm — Hoon's own core-calling convention), and 11 (hint, semantically inert) — each fast and readable in its own right.

| File | Proves |
|---|---|
| [`nock_lap2_witness.rye`](nock_lap2_witness.rye) | Eleven claims. Every opcode proven **twice**: once through its native call, once through a hand-built formula using *only* primitives lap 1 already proved — opcode 6's own expansion, `*[a 6 b c d] = *[a *[[c d] 0 *[[2 3] 0 *[a 4 4 b]]]]` (per `old/doc/spec/nock/4.txt`, held whole in this fork's own tree — quoted exactly, bracket for bracket), reconstructed literally, one nested star at a time; opcodes 7, 8, and 9 each expressed as a pure opcode-2/autocons composition — and asserted to agree exactly, not merely argued to |

## Lap 3 — the Edit Primitive, and Opcode 10

Opcode 10 needed a genuinely new primitive lap 2 named honestly and left open: `#[axis value tree]`, the constructive counterpart to `slot()`'s own tree addressing. Same bit-walk, same address convention — but where `slot()` only reads, `edit()` records each level's untouched sibling on the way down and rebuilds the whole tree on the way back up, splicing the new value in at exactly the addressed leaf and nothing else. Bounded by a `u64` axis's own width alone (at most 64 levels can ever exist) — no separate ceiling, no recursion, two plain loops.

| File | Proves |
|---|---|
| [`nock_lap3_witness.rye`](nock_lap3_witness.rye) | Eight claims — `edit()` directly (the trivial whole-tree replace, a shallow head/tail replace, and a deep edit worked out by hand, touching only the one addressed leaf); opcode 10's bare-atom hint form; opcode 10's real edit form, dispatched end to end from real formula text and proven equal to a direct `edit()` call *and* to an independent, hand-built reconstruction of the official `#[b *[a c] *[a d]]` rule; the honest boundary (opcode 12) re-checked now that 0 through 11 is whole; and `edit()`'s own address boundary, matching `slot()`'s |

With this lap, **opcodes 0 through 11 — the whole of Nock's own numbered core — are real.** Opcode 12 and beyond remain the honest boundary, refusing `UnimplementedOpcode` rather than silently misbehaving.

## What This Interpreter Does Not Claim

- No Hoon-to-Nock compiler exists; this interpreter reduces hand-built nouns, not parsed Hoon source.
- No jet (acceleration) layer exists yet; every reduction runs the plain interpreter, unaccelerated.
- This is not, and is never meant to become, Glow's execution floor — RISC-V already holds that role, proven at [`../tools/glow_riscv_target_witness.rish`](../tools/glow_riscv_target_witness.rish).

---

*May the primitive core stay small enough to read in one sitting, and may every opcode this interpreter ever grows keep the same bound its first twelve already prove: checked, bounded without recursion where a plain loop will do, and shown to reduce to what came before, not merely trusted.*
