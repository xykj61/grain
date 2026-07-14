# 968 · The Compiler Fork — Rye Becomes Its Own Language

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*A siloed design brief for the moment Rye stops being a derivative and starts compiling its own types. The fork replaces the inherited slice type with one that carries a bounded, explicitly-sized length. The compiler rejects architecture-specific widths in authored source. The standard library surfaces are rewritten module by module, each proven by the gate. The bridge to the inherited toolchain becomes optional — a guest lane, not the host.*

**Language:** EN
**Version:** `20260621.070712` (Rye chronological stamp)
**Last updated:** 2026-06-21
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; explicit widths as language law
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only **Rye**, **Rishi**, **Tally**, **Caravan**, **Aurora**, **Mantra**, **Brushstroke**, **Comlink**, **Pond**, and **Rye OS**. The insight that architecture-specific widths invite silent cross-target drift is a principle we hold; here we speak only what Rye implements.

---

## The Law

**Rye has no architecture-specific integer type in authored code.**

Every length, index, count, and offset uses an explicitly-sized width:

| Width | Role |
|-------|------|
| **`u32`** | Bounded in-memory lengths, indices, counts, offsets. Named maximum at init or compile time. |
| **`u64`** | Wire-persistent sizes, timestamps, MMIO addresses, content offsets. Same meaning on every target. |

No other integer width carries a length or an index in Rye. The compiler enforces this — a source file that uses a banned width token does not compile.

---

## The Slice Type

The inherited slice type carries a length whose width varies by target. Rye replaces it:

```
Rye slice: { ptr: [*]T, len: u32 }
```

- `len` is `u32` — four billion elements, larger than any garden
- Indexing uses `u32`; bounds check against `len` before access
- Subslicing returns a new slice with `u32` length
- Where `u64` length is required (wire formats, store offsets), a separate type is used

The invariant: **a value's size means the same thing on every machine Rye targets.** A `u32` on RISC-V is a `u32` on x86_64. The slice length does not silently widen.

---

## The Fork Path

| Step | What | Gate |
|------|------|------|
| **1** | The compiler rejects the banned width token in `.rye` source | One file compiles clean |
| **2** | All authored `.rye` files eliminate the banned token | `tools/width-check.rish` GREEN for every file |
| **3** | The standard library surfaces use `u32`/`u64` | 90 witnesses re-based, all GREEN |
| **4** | The bridge to the inherited toolchain becomes optional | `rye run` compiles `.rye` directly |
| **5** | The inherited toolchain runs as a guest | Interop lane documented |

Each step is proven by the gate before the next begins. The fork is an accretion — the same method the strengthening series uses.

---

## What the Gate Becomes

Today, the parity gate proves: Rye's strengthened std produces the same output as the inherited vendor std.

After step 3, the parity gate proves: Rye's native std produces the same output as a prior Rye snapshot (or golden test vectors). The gate's promise does not change; its baseline does.

The 90 witnesses are the specification. Each witness exercises one standard library surface. When the surface is rewritten with explicit widths, the witness must still pass. The fork changes the types; the gate proves the behavior is preserved.

---

## The Standard Library, Module by Module

The rewrite follows the strengthening series — one surface at a time, each through the gate:

1. **Memory** — `mem.eql`, `mem.copy`, `mem.find`, `mem.split`, `mem.replace`, `mem.reverse`, etc. 60+ witnesses already cover these.
2. **Formatting** — `fmt.allocPrint`, `fmt.bufPrint`. Witnesses exist.
3. **Filesystem** — `Dir.readFileAlloc`, `Dir.writeFile`, `Dir.iterate`. Witnesses exist.
4. **Crypto** — `sha3`, `ed25519`, `x25519`, `chacha20_poly1305`. Witnesses exist.
5. **Process** — `process.run`, `process.spawn`. Witnesses exist.

Each module is rewritten: public `fn` signatures change from architecture-specific width to `u32`/`u64`. Internal implementation adapts. The witness proves behavior is preserved.

---

## Dogfood

Two tools compile on the forked compiler to prove it works:

1. **`tools/width-check.rish`** — the gate that enforces the ban. Runs in Rishi, which is built by `rye build`.
2. **`tools/parity.rish`** — the parity gate. Runs in Rishi, proves every witness.

When both run green on the forked compiler, the fork is alive.

---

*May Rye become its own language by the same method it became its own standard library — one module, one witness, one gate at a time. May the compiler reject what the discipline forbids. And may every value carry a width we named, the same on every machine, from the first instruction to the last.*
