# 965 · The Rye Compiler Fork — How a Language Becomes Its Own

*Rye is forking from Zig. Not as a patch or a dialect — as a separate language with its own compiler, its own type system, its own slice model. This research reads how language forks happen, what the Zig compiler's architecture offers as a starting point, and what the concrete steps are to make `rye build` reject `usize` and compile `[]T` with `u32` length.*

**Language:** EN
**Version:** `20260621.070712` (Rye chronological stamp)
**Last updated:** 2026-06-21
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## Why Fork

Rye began as a Zig derivative — the same toolchain, the same std, the same types. This was the right choice for standing on proven ground (`996`). Yet Rye is its own language now (`../context/specs/rye-as-its-own-language.md`), and its own language cannot carry a type (`usize`) that silently changes width between targets. Tiger Style says: use explicitly-sized types. TAME says: safety first. The fork makes the language match its discipline.

The fork is not a rewrite from scratch. It is an accretion — the same strengthening method that has carried us through 90 passes. The compiler grows from Zig's compiler the way Rye's std grew from Zig's std: one module, one witness, one gate at a time.

---

## What the Fork Changes

### 1. The `usize` keyword is rejected in `.rye` source

The Rye compiler's parser (or a pre-parse lint in the bridge) rejects the token `usize` in any `.rye` file. The error message names the replacement: `u32` for bounded lengths, `u64` for wire-persistent quantities.

### 2. The slice type carries `u32` length

Zig's `[]T` is `{ ptr: [*]T, len: usize }`. Rye's `[]T` becomes `{ ptr: [*]T, len: u32 }`. Indexing uses `u32`. Bounds checks compare against `u32` length. Subslicing returns `u32` new length.

This limits a single slice to 4 billion elements — larger than any garden, larger than any frame buffer, larger than any reasonable in-memory structure. Wire formats that need larger use `u64` explicitly.

### 3. The std surfaces use `u32`/`u64`

Every `pub fn` in `rye/lib/std` that currently takes or returns `usize` is rewritten to use `u32` or `u64`. The 90 parity witnesses become the specification: each witness must produce the same output on the new signatures.

### 4. The parity baseline changes

Today: `rye run` compiles against vendor Zig std; parity proves behavior matches.
After F3: `rye run` compiles against Rye-native std; parity proves behavior matches prior Rye snapshot.

---

## The Concrete Steps

### F1 — Compiler spike (next)

**Goal:** `rye build` rejects `usize` in one `.rye` file.

**Implementation path:** The `rye` command bridges `.rye` → `.zig` via `bridgeRyeTree`. Add a scan step in `bridgeRyeTree` that tokenizes each `.rye` file and rejects if the token `usize` appears outside a comment or string. This is a lint, not a parser change — achievable in the current Zig-based toolchain.

**Deliverable:** `rye build --strict-width caravan/seed.rye` compiles successfully (seed has zero `usize`). `rye build --strict-width rishi/src/main.rye` fails with named error listing the `usize` locations.

### F2 — Authored corpus

**Goal:** Zero `usize` in all published `.rye` files.

**Implementation path:** For each file, replace `usize` locals with `u32` + explicit casts at the Zig std boundary. Some files (Rishi at 37 hits) require substantial refactoring. The `tools/width-check.rish` gate must pass for every file before commit.

**Deliverable:** `rishi run tools/width-check.rish` reports GREEN for all files.

### F3 — Rye-native std

**Goal:** `rye/lib/std` surfaces use `u32`/`u64` instead of `usize`.

**Implementation path:** Module by module, rewrite the public signatures. Each module gets a parity witness that proves behavior matches. The 90 existing witnesses are re-based to the new signatures.

**Deliverable:** `rye build` compiles all `.rye` files against the new std without `usize`. Parity gate GREEN against golden vectors.

### F4 — Bridge sunset

**Goal:** `rye run` without Zig for our tree.

**Implementation path:** Self-hosted Rye compiler. The bridge (`bridgeRyeTree` that copies `.rye` → `.zig`) is removed. Rye reads `.rye` directly. Zig is a guest language, not the host.

### F5 — Guest Zig

**Goal:** Zig code runs on Rye OS as a guest.

**Implementation path:** An interop lane: Zig source compiles to binaries Rye OS loads. Zig's `usize` exists in Zig guest code; it does not exist in Rye.

---

## Sources

- Zig compiler: `gratitude/zig/` — the ground we fork from. MIT.
- Tiger Style: `gratitude/TIGER_STYLE.md` — "use explicitly-sized types; avoid `usize`"
- Rye-as-its-own-language: `context/specs/rye-as-its-own-language.md`
- Width baseline: `work-in-progress/20260620-212126_usize-width-baseline`
- Width design: `active-designing/yonder/20260621-051312_explicit-width-in-rye.md`

---

*May the fork arrive as the language the seam migration was always growing toward. May every `usize` become `u32` or `u64` — named, bounded, and the same on every machine. May the compiler reject what the discipline forbids, and may the gates prove each step before the next begins.*
