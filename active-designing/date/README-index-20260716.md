# active-designing season index -- 20260716

**Language:** EN
**Status:** Season index -- immutable once folded
**Season:** `20260716`
**Folded:** `20260824.144912` from the living pin

Closed rows for `20260716`, in the order the pin held them.
Living pin: [`../README.md`](../README.md).

| Stamp | Log | What it recorded |
|---|---|---|
| `20260716.093000` | [What Glow and Rye share under the hood -- the three-hop bridge](../yonder/20260716-093000_glow-and-rye-what-shares-under-the-hood.md) | Reads Rye's own real bridge code first (a pure textual `.rye`->`.zig` import-path rewrite, no parser) rather than assuming it, then proposes Glow's own one new hop (`.glow`->`.rye`) stacked on top, unchanged below - names everything shared (toolchain, std, TAME bounds, runtime, targets, witnesses) versus Glow-owned (the rune parser, the lowering pass, auras, the Nock second backend) - a worked example shows the exact Rye a rune would generate, drawn from already-green code, not invented |
| `20260716.033000` | [Sameness and the rune -- Glow's grammar, composed and bounded, on RISC-V](20260716/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) | Resolves whether a rune is sameness or cleverness (closed - regular - checked-at-expansion) - curates Glow's own rune table - redesigns `\|-` as a bounded trap - a complicated two-level composition (Neth's own fold, in shape) - the RISC-V codegen claim quotes real disassembly, not guesswork |
