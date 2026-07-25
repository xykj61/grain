# 967 · Literal `usize` Ban — Forking Rye as Its Own Width Model

*We have been living a seam policy: `usize` at the Zig slice door, `u32`/`u64` everywhere we author. That policy is honest for a Zig derivative. It is not the destination Tiger Style points at — and we are building Rye OS from scratch, converting gratitude into Rye, and do not need Zig sources to run as Rye on our own ground. This exploration records the decision to fork the language toward a literal `usize` ban in Rye itself.*

**Language:** EN
**Version:** `20260621.051312` (Rye chronological stamp)
**Last updated:** 2026-06-21
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Status:** Exploration — decision recorded; design siloed at `active-designing/yonder/20260621-051312_explicit-width-in-rye.md`

**Prior art:** [`20260621-050312_usize-boundary-not-design.md`](20260621-050312_usize-boundary-not-design.md) (seam policy while on Zig ground) · [`TAME_STYLE.md`](TAME_STYLE.md) · [`../gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) · [`../context/specs/rye-as-its-own-language.md`](../context/specs/rye-as-its-own-language.md)

---

## The Question

Tiger Style says *use explicitly-sized types like `u32`; avoid architecture-specific `usize`.* TAME operationalized that as **`usize` is a boundary type, not a design type** — with Tier C carve-outs for inherited Zig `std`.

We asked: should we go further and **ban `usize` in Rye altogether**?

The answer, for this project, is **yes** — as a **language fork**, not as a style lint on top of Zig compatibility forever.

---

## Why the seam policy was right — and why it is interim

**Right while:** Rye ran through a Zig bridge; `rye/lib/std` had to stay Zig-shaped; parity proved our strengthenings against vendor Zig `std`; every `[]T` and `.len` spoke Zig's type system.

**Interim because:** We are not shipping "Zig with a stamp." We are shipping **Rye OS** — Rye programs, Rye `std`, seeds and metal in `.rye`, gratitude **converted** to our vocabulary. Zig remains welcome as a **guest** language on the platform; it does not need to define Rye's core widths.

968 documents the seam world precisely. **967 names the fork beyond it.**

---

## What we decide

| Layer | Decision |
|-------|----------|
| **Rye the language** | **No `usize` in Rye-authored types.** Slice lengths, indices, counts in public APIs: **`u32`** by default; **`u64`** for wire-persistent and cross-target quantities that must exceed 32-bit garden bounds. |
| **Rye `std`** | Rewrite surfaces over time to the Rye width model — not preserve Zig `pub fn … usize` forever. Strengthening becomes **Rye-spec invariants**, not vendor parity. |
| **Toolchain** | `rye run` → Zig bridge is a **bootstrap shim**, sunset on the horizon. Self-hosted Rye compiler is the destination. |
| **Parity gate** | Evolves: witnesses prove **Rye behavior + assertions**, baseline arm becomes **prior Rye snapshot** or spec vectors — not `RYE_LIB=vendor/zig`. |
| **Gratitude / vendor Zig** | Stay in `gratitude/` as reference; **convert** into Rye at our pace. No requirement that `.zig` files execute as Rye. |
| **Zig on Rye OS** | Supported as **interop** (build guest, call at FFI) — not as the definition of Rye's slice type. |
| **FFI / metal** | Machine-sized integers at hardware doors become **named adapter types** — same role seam `usize` plays today, but smaller and explicit (`u64` MMIO, `u32` frame caps). |

---

## What changes in practice

### Today (until fork lands)

- **Authored `.rye`:** migrate to `u32`/`u64` per `992` Phase 1–3 (continue).
- **Strengthening passes:** finish the mem/crypto arc on current `std`; usize explicit audit documents seam policy (`968`).
- **Gates:** parity against vendor Zig remains green — **last season of that contract.**

### Fork horizon (phased)

| Phase | Work | Green when |
|-------|------|------------|
| **F0 — Decide** | This note + siloed design `970` | Recorded `051312` |
| **F1 — Type story** | Rye slice/index model: `u32` len, `u32` indices; `u64` wire | Design brief complete; one compiler spike |
| **F2 — Authored corpus** | All published `.rye` zero `usize`; `width-audit.rish` required | Gate advisory → required |
| **F3 — `std` rewrite** | Rye-native `mem`, `fmt`, … signatures; witnesses per surface | Gate trio on Rye baseline |
| **F4 — Bridge sunset** | `rye run` without Zig for our tree | Self-host compile of enricher + witnesses |
| **F5 — Guest Zig** | Document Zig interop lane for Rye OS | Optional hosted builds |

We do **not** big-bang rewrite `rye/lib/std` in one commit. We **accrete** — the same law as strengthening — with a new north star.

---

## Relationship to Tiger / TAME idealism

This fork **aligns more highly** with TAME idealism than perpetual Tier C:

- Tiger's one-line rule becomes **literally true in Rye source**, not stratified into "inherited seam OK."
- Cross-target exactness is **structural** — not "we hope nobody stores `slice.len`."
- `996` safety rule — explicit sizes everywhere — is the **language**, not a supplement fighting the compiler.

The cost is honest: we own the compiler, the std rewrite, and a new gate story. That cost matches **building everything from scratch.**

---

## What we are not claiming

- **Not** "the universe has no pointer-sized integers" — hardware and C FFI still do.
- **Not** "delete `gratitude/`" — we thank, study, convert.
- **Not** "break parity tonight" — we finish the current arc green, then re-point the gate.
- **Not** "confuse 968" — it remains the accurate manual for **today's** Zig-ground strengthenings.

---

## Cross-links

| Topic | Lives in |
|-------|----------|
| Seam policy (interim) | `20260621-050312_usize-boundary-not-design.md` |
| Siloed design (clean room) | `active-designing/yonder/20260621-051312_explicit-width-in-rye.md` |
| Rye is its own language | `context/specs/rye-as-its-own-language.md` |
| Width migration inventory | `work-in-progress/20260620-212126_usize-width-baseline.md` |
| Living threads | `work-in-progress/TASKS.md`, `work-in-progress/ROADMAP.md` |
| Roadmap | `work-in-progress/ROADMAP.md` |
| Growing a language | `active-designing/yonder/20260618-184912_growing-a-language.md` |

---

*May Rye name every width it owns. May the fork be accretive, gated, and grateful — and may Tiger's discipline become grammar, not footnote.*
