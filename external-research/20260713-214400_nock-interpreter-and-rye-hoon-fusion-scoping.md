# A Nock Interpreter and a Fused Rye-Hoon Language — Scoping Only

**Language:** EN
**Version:** `20260713.214400`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research for understanding — scoping only; no interpreter code, no language grammar written yet

---

## What This Answers

Kaeden asked for a Nock interpreter, paired with a new language merging Rye and Hoon — keeping Hoon's rune tradition, governed by TAME — fused to the lowest current Kelvin version of Nock. This document scopes that honestly: the full Nock spec, what a minimal interpreter needs, prior art already funded by the Urbit Foundation for nearly this exact task, and the one real design tension this fusion must resolve before any code is written.

---

## The Nock Spec, in Full (Nock 4K, the current version)

Nock operates on **nouns** — an atom (a natural number) or a cell (an ordered pair of nouns). Every computation is `*[subject formula]`: a formula (code) evaluated against a subject (data), producing a new noun.

**Primitive opcodes (0-5) — Turing-complete on their own:**

| Op | Name | Rule | Meaning |
|---|---|---|---|
| `0` | Slot | `*[a 0 b]` = `/[b a]` | Address `b` into subject `a` (tree addressing: even = left, odd = right) |
| `1` | Constant | `*[a 1 b]` = `b` | Return the literal noun `b`, ignoring the subject |
| `2` | Evaluate | `*[a 2 b c]` = `*[*[a b] *[a c]]` | Compute a new subject and formula from `a`, then evaluate them against each other — this is Nock calling itself |
| `3` | Cell test | `*[a 3 b]` = `?*[a b]` | `0` if the result is a cell, `1` if an atom |
| `4` | Increment | `*[a 4 b]` = `+*[a b]` | Add 1 (atoms only) |
| `5` | Equality | `*[a 5 b c]` = `=[*[a b] *[a c]]` | `0` if equal, `1` otherwise |

**Macro opcodes (6-11) — sugar, expressible in terms of 0-5, kept for compactness and speed:**

| Op | Name | Meaning |
|---|---|---|
| `6` | Conditional | if/then/else |
| `7` | Compose | sequential evaluation, `b` then `c` |
| `8` | Extend | push a new value onto the subject (`let`-like) |
| `9` | Invoke | Hoon's calling convention — extract an arm from a core and call it |
| `10` | Edit | replace the noun at address `b` |
| `11` | Hint | metadata for the interpreter (jets, tracing); semantically a no-op |

**On "the lowest Kelvin version"** — Kaeden's ask names Nock's own Kelvin-versioned history (Nock has itself had versions counting down, following the same discipline Arvo now follows). Nock 4K is the current, longstanding version referenced throughout current Urbit documentation as of this research. Confirming whether a lower (more stable) Nock Kelvin has since shipped needs a live check against `docs.urbit.org/nock/specification` or a running ship's own `nock` version report at build time — this document treats 4K as the working target until that check is made, rather than asserting a number sight-unseen.

---

## Prior Art the Urbit Foundation Is Already Funding

The Grants program (`urbit.org/grants`) lists open bounties directly overlapping this ask, as of this research:

- **`%wock`** — "Lightweight Nock interpreter to run Hoon in the browser." This is close to a browser/WASM-target Nock interpreter, a different runtime target than this project's native Zig/Rye path, but the interpreter core (opcodes 0-11 over nouns) is target-independent — its design choices are worth reading before this project writes its own.
- **"WebAssembly Interpreter in Nock — Phase II"** — a second, related bounty; "Phase II" implies a Phase I already exists and may have landed code worth studying directly, rather than re-deriving the same interpreter from the spec alone.

**Recommendation:** before any interpreter code is written in a future pass, read both bounty specifications in full and, if Phase I's code is public, read it — Gall's Law itself says a complex system that works grows from a simple one that already works, and if the Foundation has already funded a working simple Nock interpreter, that is the system to grow from, not a reason to start over.

---

## The Real Design Tension: Hoon's Runes vs. TAME's Bounded-Everything Rule

This is the one finding in this document that is not a research fact but a genuine, load-bearing design conflict, named plainly rather than glossed over:

**Hoon leans on unbounded recursion as an idiom.** Its own standard library gate-recursion patterns (`|-` for a trap, tail-recursive arms calling themselves) are the normal way to write a loop in Hoon — there is no separate "bounded loop" construct; recursion *is* the loop construct, and Hoon's own compiler does not require a stated upper bound before it accepts a recursive definition.

**TAME's root rule states the opposite as an absolute:** "Control flow stays simple and explicit; recursion stays out, so that everything which should be bounded stays bounded" ([`context/specs/TAME_GUIDANCE.md`](../context/specs/TAME_GUIDANCE.md), Root rule 2). Every loop in authored Rye names its maximum size at construction and asserts it at the boundary.

**These two rules cannot both hold for the same construct without a real decision.** Three honest paths, none secretly free:

1. **Keep Hoon's runes as *surface syntax* only, and require every rune that would normally desugar to unbounded recursion (`|-` traps, self-calling arms) to desugar instead to a **bounded** loop form in the fused language — with the bound stated at the rune site, the same way `width-check.rish` already demands a named bound for `u32` counts.** This keeps the rune *look* Kaeden asked for while keeping TAME's actual safety property intact. This is the option that best honors "keeping the Hoon rune tradition" as a promise about *readability*, not about *semantics*.
2. **Accept genuine unbounded recursion for the fused language, scoped only to code that plays Hoon's own historical role (kernel/app logic interpreted by the Nock VM), and treat it as an explicitly named exception to TAME's root rule** — the same way Aurora's freestanding paths already get their own carve-out from the hosted `width-check` policy for a different, hardware-driven reason. This is honest but weakens TAME's universal claim ("root... holds for Rye, Brix, Rishi, and every module written in them") unless the fused language is named as a fourth family member with its own supplement, the same way Rye/Brix/Rishi each get one.
3. **Do not fuse at the rune-semantics level at all — write Hoon-flavored *syntax* that compiles straight through to bounded Rye, and treat "Nock" as strictly the *target* runtime representation (a real Nock interpreter exists, and this fused language compiles to it), never a place where TAME's own bound gets waived.** This is the most TAME-faithful option and the one this document leans toward recommending, though it is Kaeden's call to make, not a default.

None of these three is free, and picking one is a real ruling this project's own `collaboration.md` says to pause for ("opens a new domain... raises a design or width question no written policy answers") — this document names the fork; it does not resolve it.

---

## A Phased Implementation Plan (Future Pass, Not This Session)

If and when Kaeden gives the word to move from scoping to a first landed witness, the smallest-lovable-complete shape, matching this project's own SLC discipline:

1. **Noun representation** — a Bron-adjacent value (atom or cell) as the interpreter's data model; Bron's existing one-value model is very close to a noun already, per the naming-mapping proposal's own finding
2. **Opcodes 0-5 only, first** — the Turing-complete primitive core, with a witness proving each opcode's stated reduction rule against hand-written fixture formulas, the same fixture-driven witness style this project already uses everywhere
3. **Opcodes 6-11 second** — the macro/sugar layer, each opcode's witness proving it reduces to the same result as its stated 0-5 expansion (this is directly testable: the spec literally defines each macro op as an expression in terms of the primitives)
4. **No Hoon-fusion syntax work until the bare interpreter is green** — Gall's Law again: grow the simple, working Nock core first; decide the fused-language rune question (above) only once there is a real target to compile onto

---

## What This Document Does Not Do

- It does not write a single line of interpreter code.
- It does not decide the Hoon-runes-vs-TAME-bounds question — it names the fork honestly and recommends a direction without deciding on Kaeden's behalf.
- It does not pin an exact "lowest current Nock Kelvin" number — that needs a live-ship or live-spec check this research pass did not perform.

---

*May the spec stay small enough to hold in one page, and may the fusion we choose keep both traditions' real virtues — Hoon's directness, TAME's bound — rather than quietly losing one to gain the other.*

---

## RISC-V as the Substrate Nock Stood In For — a Lens, and an Evaluation (`20260715.213500`)

Accreted after a clarifying insight: Hoon compiles to **Nock** because, over a decade ago, there was no open, frozen, universal *hardware* substrate to target — x86 was proprietary and messy, ARM was licensed. Nock filled that absence in software: a tiny, mathematical, frozen, hardware-independent combinator VM, the "permanent substrate." **RISC-V's frozen, open, royalty-free base ISA is now that permanent substrate in hardware** — the thing that did not exist when Nock had to stand in for it. So Glow can target RISC-V *directly* where Hoon *needed* Nock. This reframes this whole document's fork (above) and the recent design work below.

### The two-backend strategy this implies

Glow is already a thin frontend on pinned **Zig 0.16.0**, and Zig's backend already targets RISC-V (as it targets aarch64 — proven green by the M0 lap, `context/specs/20260715-193000_two-dev-environments-and-mobile-emulation.md`). So:

- **Primary backend — Glow → Zig 0.16.0 → RISC-V** (and aarch64, x86_64): the real execution path, standing and now **green across three keystone vanes** — `tools/glow_riscv_target_witness.rish` cross-builds Sala B0, Neth's minimal witness, and Pool P0 for `riscv64-linux-musl` and runs each under `qemu-riscv64-static`, each one's entire stdout byte-identical to its native x86_64 run. The shared-IR research already concluded the Zig backend *is* the shared IR, so this was a parity witness, not a new compiler.
- **Second backend — Glow → Nock**: for *Urbit-world interop and verification*, not for execution. This corrects the bridge direction — the useful artifact is "Glow also emits Nock," not "compile RISC-V down to Nock." It aligns with Ojjo's Hoon/Glow parity, the diverse-redundant pair idea, and the Glow↔Hoon round-trip. The Nock interpreter this document scopes is therefore an **interop seam**, not the execution foundation.

**The one honest trade:** Nock gave determinism and replayability *for free* at the VM level (the ground of Arvo's event-log replay). Target RISC-V directly and Glow must **re-earn that determinism with discipline** — TAME's bounds, no unbounded recursion, deterministic folds, witness-before-truth, the fold-over-signed-log spine. Determinism moves *from the VM to the discipline*. This resolves the fork above in favour of **option 3** (Hoon-flavoured syntax compiling to bounded Rye/RISC-V; Nock strictly a target, never a place TAME's bound is waived) — now with a clear *reason*: RISC-V is the execution substrate, so Nock never needs to be one.

### Recent design decisions, evaluated through this lens

- **Validated — the Neth/Sala/Pool green laps are the proof the strategy works.** Every deterministic fold that ran green on native (and emulated aarch64 at M0) is evidence that disciplinary determinism holds *without* a Nock VM. Neth's byte-for-byte replay, Sala's session root, Pool's verified fold — these are exactly the determinism Nock gave for free, re-earned by TAME on native code. The build stretch is retroactively the RISC-V-direct thesis, proven.
- **Sharpened — the runtime (Aurora + Caravan + Tally).** Aurora-as-Vere-parallel boots onto *RISC-V via Zig*, not onto a Nock VM; the runtime revival hosts Glow-native execution, and the kelvin/Nock interop is a seam, not the core (`20260714-013700_aurora-vere-arvo-boot-fusion-and-kelvin-strategy.md`).
- **Sharpened — the T-vane / runtime unification stays held, and the lens makes it *less* fraught.** Urbit keeps the pure-Nock-kernel / impure-runtime split precisely because determinism lives in the VM. Glow's determinism lives in the *discipline*, so unifying kernel and runtime loses less than it would in Urbit — a real point in the proposal's favour, still not a now-build.
- **Sharpened — the Glowphone and mikroPhone.** M0 already proved Glow's code is arch-portable via Zig (aarch64; riscv64 is the same move). mikroPhone's RISC-V central MCU is *exactly* this substrate — a real, funded proof that the target Glow compiles to is a shipping open ISA.
- **Unchanged — the SLC honesty.** The SLC rests on the runtime's green pieces; the runtime is more foundational, the SLC ships now. The lens confirms it: the SLC already runs on RISC-V-portable native code (M0), so it is honest about its substrate.

The owned decision is siloed into `../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`.
