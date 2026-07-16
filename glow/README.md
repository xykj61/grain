# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-16 (the bounded `|-` rune's front half landed — real text, parsed, real mechanism)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — one small, real parser prototype, GREEN

---

This is where Glow's own language tooling lives once a design earns real code, rather than staying prose alone. The first tenant is the smallest, most load-bearing piece the [sameness-and-the-rune brief](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) named as unbuilt: a real parser for the one rune Glow's own bound discipline changes.

| File | Proves |
|---|---|
| [`rune_bounded_trap.rye`](rune_bounded_trap.rye) | Parses `\|-  32` and `\|-  (lent records)` — Glow's own bounded-trap rune, both stated shapes — and the checked mechanism a real trap's expansion runs: a counter, checked against the bound, refusing cleanly with `BoundExceeded` rather than looping |
| [`rune_bounded_trap_witness.rye`](rune_bounded_trap_witness.rye) | Nine claims: both bound shapes parse correctly, a trailing trap body doesn't confuse the scan, three malformed inputs each refuse their own named error, the checked mechanism's welcome and unwelcome paths both prove out, and one end-to-end claim ties parsed text straight through to the exact mechanism the design brief's own RISC-V section already quoted from real disassembly |

## What This Is, and Is Not

This closes the one gap the design brief named plainly: *"What remains unbuilt is only the front half: the parser that reads `\|-  (lent ship-list)` and the pass that lowers it to this exact Zig shape."* The front half now parses real text. The back half was never guesswork — it was already disassembled, real RISC-V, from `linengrow/neth_sim.rye`'s own hand-written loop.

This is **not** a general Glow grammar, a lexer for the other twenty-nine runes the design brief's own table names, or a step toward a full compiler. It is exactly what a first, real, load-bearing prototype should be: the smallest slice that proves a real design connects to real code, built once a design earned the right to become one.

---

*May the next rune's own front half arrive the same way this one did — small, real, and connected to a mechanism already proven true, rather than argued and left waiting.*
