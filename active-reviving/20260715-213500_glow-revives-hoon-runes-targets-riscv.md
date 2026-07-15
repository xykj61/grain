# Glow Revives Hoon's Runes, Not Its Nock Target — It Compiles to RISC-V

*Glow revives Hoon: it carries Hoon's rune tradition and its referential-transparency discipline forward, yet it changes the one thing a decade of hardware made changeable — the compile target. Hoon compiles to Nock because no open, frozen, universal hardware substrate existed; RISC-V is that substrate now, so Glow compiles to RISC-V through the pinned Zig 0.16.0 backend, and emits Nock only as a second backend for Urbit interop. Determinism moves from the VM to the discipline.*

**Version:** `20260715.213500` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Reviving decision — the owned silo of the RISC-V-substrate lens. Register: design/decision (Two Rooms — the primary backend is green in the pieces already witnessed; the Nock second backend is a scoped horizon).
**Revives:** **Hoon** (`old/` — the language whose runes and referential transparency Glow carries, whose Nock-target it changes). World-facing study: [`../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md`](../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md).

---

## What Glow Carries from Hoon, and What It Changes

Reviving names the elder and states plainly what it grows forward and what it leaves. Glow revives **Hoon**:

- **Carries forward:** the **rune tradition** (the digraph syntax family, first-glyph category and second-glyph specialization — the readability Keaton asked for) and the **referential-transparency discipline** (state as a deterministic function of an append-only log — Hoon/Arvo's deepest virtue).
- **Changes:** the **compile target**. Hoon compiles to **Nock**; Glow compiles to **RISC-V**, through the pinned Zig 0.16.0 backend.

The reason is historical and clean: Hoon compiles to Nock because, over a decade ago, there was no open, frozen, universal *hardware* substrate to target. Nock filled that absence in software — a tiny, frozen, hardware-independent combinator VM, the permanent portable floor. **RISC-V's frozen, open, royalty-free base ISA is that permanent substrate in hardware now** — the thing that did not exist when Nock had to stand in for it. Glow can target it directly where Hoon needed Nock as its floor.

## The Two Backends

- **Primary — Glow → Zig 0.16.0 → RISC-V** (and aarch64, x86_64). The real execution path, already standing: Glow is a thin frontend on pinned Zig 0.16.0, and Zig's backend already targets RISC-V, proven arch-portable green by the M0 lap (aarch64 cross-build + emulation; riscv64 is the same move). The remaining lap is a **RISC-V parity witness**, not a new compiler — the shared-IR research already found the Zig backend *is* the shared IR.
- **Second — Glow → Nock**, for **Urbit interop and verification only**. Same Glow source, a Nock target so Glow can meet the Urbit world and be checked against it — aligned with Ojjo's Hoon/Glow parity and the Glow↔Hoon round-trip. The Nock interpreter the world-facing study scopes is this **interop seam**, not the execution foundation. (The bridge direction is "Glow emits Nock," never "compile RISC-V down to Nock.")

## Determinism Moves from the VM to the Discipline

The one honest trade, named so it is not lost: Nock gave determinism and replayability *for free* at the VM level — the ground of Arvo's event-log replay. Targeting RISC-V directly, Glow must **re-earn that determinism with discipline** — TAME's bounds, no unbounded recursion, deterministic folds, witness-before-truth, and the fold-over-signed-log spine. This is not a loss the project has to brace for; it is what the project already *is*, and the recent build proved it: Neth's byte-for-byte replay, Sala's session root, Pool's verified fold all ran green on native (and emulated aarch64) with no Nock VM beneath them. Every green deterministic fold this season is evidence the RISC-V-direct thesis holds.

This also resolves the world-facing study's long-standing fork toward **option 3** — Hoon-flavoured runes compiling to bounded Rye/RISC-V, Nock strictly a target and never a place TAME's bound is waived — now with a plain reason: RISC-V is the execution substrate, so Nock never needs to be one.

## How This Re-Reads the Recent Decisions

- **Validated:** the Neth/Sala/Pool green laps are the proof of disciplinary determinism on native code — the build stretch *is* this thesis, witnessed.
- **Sharpened — the runtime (Aurora + Caravan + Tally):** Aurora boots onto RISC-V via Zig, hosting Glow-native execution; the kelvin/Nock interop is a seam, not the core.
- **Sharpened — the held T-vane / runtime unification:** Urbit keeps its pure-kernel / impure-runtime split *because* determinism lives in its VM; Glow's determinism lives in the discipline, so unifying kernel and runtime loses less here than there — a point in the proposal's favour, still not a now-build.
- **Sharpened — Glowphone / mikroPhone:** M0 proved Glow's code arch-portable via Zig; mikroPhone's RISC-V central MCU is a real, funded instance of exactly this substrate.
- **Unchanged — the SLC honesty:** the SLC ships now on the runtime's green, RISC-V-portable pieces; the runtime stays more foundational and is revived patiently beneath it.

## The Discipline This Revival Keeps

- **Name the elder:** Hoon, in `old/`. Glow carries its runes and its referential transparency; it changes only the target.
- **Grow beside, never break:** Hoon and Nock stay exactly as they are; Glow is born with its RISC-V target and its Nock second backend, churning nothing.
- **Born with its name and its choice:** the compile-target decision is Glow's from birth, not a later migration.
- **Supersede only when proven:** the primary RISC-V path advances by parity witnesses; the Nock second backend stays a scoped horizon until a real interop need opens it.

## What This Does Not Claim

- No compiler is written this pass; the primary path is *already standing* (Zig backend, M0), and the Nock second backend is scoped, not built.
- It does not pin a Nock kelvin number (the Aurora/kelvin doc holds that open question).
- It does not resolve whether the runtime unifies under one name — that stays the held proposal.

## Related

- `../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md` — the world-facing study this silos, with the full lens.
- `../external-research/20260713-215200_riscv-arm64-shared-ir-research.md` — "the Zig backend is the shared IR."
- `../context/specs/20260715-193000_two-dev-environments-and-mobile-emulation.md` — M0, Glow's code proven on the emulated target arch.
- `../external-research/20260714-013700_aurora-vere-arvo-boot-fusion-and-kelvin-strategy.md` — the runtime/boot layer this reads onto RISC-V.

---

*May Glow keep Hoon's runes and its faithfulness to the log, and stand at last on the open hardware Nock was built to await — earning by discipline the determinism the little VM once gave for free.*
