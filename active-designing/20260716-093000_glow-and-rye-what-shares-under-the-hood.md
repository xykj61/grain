# What Glow and Rye Share Under the Hood — the Three-Hop Bridge

*Two prior documents already implied this architecture without ever stating it as its own decision: the revival brief said "Hoon-flavoured runes compiling to bounded Rye/RISC-V," and the sameness-and-the-rune brief said "written by hand in the Rye a rune's expansion would generate automatically" and named "the same Rye-to-Zig-to-RISC-V pipeline." This brief gathers those scattered, correct implications into one explicit answer: precisely what Glow owns, precisely what it inherits from Rye unchanged, and precisely where the one real seam sits.*

**Language:** EN
**Version:** `20260716.093000` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Design — proposes the sharing boundary; no `.glow` parser exists yet. Register: mixed (Two Rooms) — Rye's own bridge mechanism, quoted below, is checkable today (real code, read directly); the Glow-side extension is design.
**Grounds in:** [`../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`](../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md) (the revival decision) · [`20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) (the rune grammar this bridges) · [`../rye/README.md`](../rye/README.md) and [`../rye/src/main.rye`](../rye/src/main.rye) (Rye's own real bridge, quoted directly)

---

## What This Answers

Keaton named the real gap: two prior briefs assumed Glow and Rye share *something* under the hood, and both were right, but neither ever stated *what*, precisely, or *how the sharing actually works mechanically*. This brief closes that gap — reading Rye's own real bridge code first, rather than assuming how it works, then proposing the one honest extension Glow needs on top of it.

## First, What Rye Actually Does — Read Directly, Not Assumed

Before proposing anything for Glow, the honest first step is confirming what Rye itself already does, since Glow's own design should extend a *real* mechanism, not an imagined one. Rye's own README states it plainly: *"A `.rye` file is Zig source at heart... Because the toolchain's front-end reads only the `.zig` extension, both `run` and `build` bridge: they copy the `.rye` source to an adjacent `.zig` file, hand that to the compiler — pointed at Rye's standard library — and clear the bridge away."*

Reading `rye/src/main.rye`'s own `bridge_to_zig` and `rewrite_rye_imports` confirms this exactly, and confirms one more fact worth stating precisely: the bridge does **one single textual transformation** — it finds every `@import("some_path.rye")` call and rewrites the `.rye` suffix to `.zig` inside the quoted string. Every other byte of the file passes through unchanged. There is no parser here, no AST, no semantic transformation — Rye's own "front-end" is, today, a file-extension and import-path bridge, nothing more. Every real capability — syntax, type system, safety checks — *is* Zig's, inherited whole, by construction, because the file handed to the compiler is, byte for byte except for import paths, what was written.

This is the mechanism Glow must extend, not replace.

## The Three-Hop Bridge, Proposed

Glow's runes are not valid Zig syntax at all — `|-`, `?:`, `%-` are real new punctuation, not text Rye's own bridge could pass through unchanged the way it does today. Glow therefore needs the one thing Rye has never needed: **an actual parser**, reading rune-shaped text and *emitting* valid Rye source — not constructing Zig's compiler IR directly, and not inventing a second, parallel bridge to Zig. Once Glow's own lowering pass emits `.rye` text, **Rye's existing bridge takes it from there, completely unchanged**:

```
.glow  --[Glow's own parser + rune-expansion lowering, NEW]-->  .rye
.rye   --[Rye's existing bridge_to_zig / rewrite_rye_imports, UNCHANGED]-->  .zig
.zig   --[pinned Zig 0.16.0 toolchain, UNCHANGED]-->  RISC-V (primary) / x86_64 / aarch64
```

Each hop is owned by exactly one layer, and touches only its own concern:

- **Glow's own hop** (the only new work): recognize rune syntax; check every rune's expansion against TAME's bounds *at this point*, per the sameness-and-the-rune brief's own resolved principle; emit real, readable `.rye` text implementing the checked expansion.
- **Rye's hop** (zero new work, reused as-is): the same `bridge_to_zig`, the same `rewrite_rye_imports`, the same `--zig-lib-dir` pointed at Rye's own pristine standard library.
- **Zig's hop** (zero new work, reused as-is): the same pinned 0.16.0 toolchain, the same target list, RISC-V proven across nine keystone pieces this same session.

A hypothetical `glow build foo.glow` would, under this design, do exactly what `rye build` already does one layer up: stage an ephemeral `.rye` file beside the source, hand it to `rye build`, and clear the bridge away when done — the identical discipline, one level higher, never re-implemented.

## Worked Example — a Rune, and the Rye It Would Generate

Concrete, not abstract: the sameness-and-the-rune brief's own bounded trap, `|- (lent ship-list) ... `, would lower to *exactly* the shape already hand-written and already proven green this session in `glow/rune_bounded_trap.rye` and, independently, in `linengrow/neth_sim.rye`'s own bounded loop:

```zig
// Generated .rye text -- NOT hand-authored, NOT hypothetical shape: this is
// the literal pattern already proven, twice, in this tree's own real code.
var tick: u32 = 0;
const bound: u32 = @intCast(ship_list.len);
while (ship_list.len > 0) {
    tick += 1;
    if (tick > bound) return error.BoundExceeded;
    // ... the trap's own body, lowered the same way ...
    ship_list = ship_list[1..];
}
```

A person reading this generated `.rye` file sees ordinary, already-familiar Rye — no rune, no hidden magic — because that is precisely the point of the bridge: the rune is a shorter *spelling* of this, checked once at the point Glow emits it, never a separate execution path with separate rules.

## What Glow and Rye Share — Inherited Whole, Never Duplicated

| Shared thing | Why it stays one thing, not two |
|---|---|
| **The pinned Zig 0.16.0 toolchain** | Neither Rye nor Glow has its own compiler; both bridge to the same one. A second compiler would be the exact private dialect the sameness foundation refuses. |
| **Rye's own standard library** (`rye/lib/std`) | Glow-generated `.rye` text calls the same `@import("std")` any hand-authored Rye file calls. No separate "Glow std" exists or should. |
| **TAME's bounded-everything discipline** | Glow's own rune-expansion check exists *specifically* so the `.rye` text it emits already satisfies the same bounds every hand-authored Rye file must satisfy — one discipline, checked at two different points in two different source forms, never two disciplines. |
| **The runtime and enclosure** (Aurora boots, Caravan supervises and tables capabilities, Tally allocates gardens, Pond bounds and holds customs) | None of this is Glow-aware or needs to be. A Glow-authored program, once lowered, *is* a Rye program, and inherits the whole runtime story for free, the same way any other `.rye` file already does. |
| **The target list** (RISC-V primary, proven across nine keystone pieces this session; x86_64, aarch64 alongside) | Glow does not need its own target story. Whatever Zig already reaches, Glow reaches, the moment its own hop is done. |
| **The witness and parity discipline** (`tools/parity_ch01.rish`, `width-check.rish`, the whole trio) | Glow-generated `.rye` files are simply more `.rye` files in the same tree, checked by the same suite, the same way. |
| **The value model, for everything except Nock interop** | Once lowered, a Glow program's values *are* Rye's — Zig's own native types (structs, unions, sized integers). The noun model (atom or cell) built for the Nock interpreter is Nock's own representation, reached only at the Nock-interop boundary the next section names — never Glow's "normal" value model. |

## What Glow Owns — the One Real Seam

| Glow-only thing | Why it cannot simply be Rye |
|---|---|
| **The rune grammar and its parser** | Real new syntax, not valid Zig text Rye's own textual bridge could pass through. This is the one genuinely new piece of machinery this whole architecture needs, and the only one. |
| **The rune-expansion lowering pass** | The pass that checks a rune's bound and emits the equivalent bounded `.rye` text — the thing the worked example above shows concretely. |
| **Auras, and the cold/warm-atom distinction** | Per the runes-scoping study, a Glow-specific type-level convention layered *on top of* Rye's own type system (itself just Zig's), not a separate type system underneath it. |
| **The Nock second backend** | Glow, and only Glow, also has reason to emit Nock formulas — for Urbit-world interop and verification, per the revival decision. Rye has no Hoon lineage and no reason to ever target Nock; this path runs *alongside* the shared Rye→Zig→RISC-V pipeline, never through it. |
| **A stricter, Hoon-grade style supplement** | Per the runes-scoping study's own proposal: a tighter line/function-length ceiling and mandatory same-line comments on rune-headed blocks, specific to rune-dense code's own readability needs — an addition to TAME's Rye supplement, not a replacement of it. |

## What This Document Does Not Claim

- No `.glow` parser, no lowering pass, and no `glow build`/`glow run` command exist yet; this names the shape they should take, once built, so that when they *are* built, they extend Rye's real bridge rather than inventing a second one.
- It does not re-decide anything the revival brief or the sameness-and-the-rune brief already settled; it makes explicit what both already implied.
- It does not claim Glow's generated `.rye` text must always be human-legible in every case — the worked example is legible by construction for a simple bounded trap; more complex runes may generate less immediately-readable Rye, and that trade-off is not resolved here.
- Seating any Glow-specific supplement content into `context/TAME_GUIDANCE.md` stays gated on Keaton's own word, unchanged by this brief.

## Related

- `../rye/README.md`, `../rye/src/main.rye` — Rye's own real bridge, quoted directly rather than assumed.
- `../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md` — the revival decision this names the mechanics for.
- `20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md` — the rune grammar this bridges, and the bounded-trap example this brief's own worked example draws from.
- `../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md` — the auras and style-supplement proposals this brief names as Glow-owned.
- `../glow/rune_bounded_trap.rye`, `../linengrow/neth_sim.rye` — the two already-real, already-green pieces of code the worked example's generated shape is drawn from, not invented for this brief.

---

*May the bridge stay exactly as thin as Rye's own already is — one honest hop, owning one concern, never reaching down to redo work a layer below it already does.*
