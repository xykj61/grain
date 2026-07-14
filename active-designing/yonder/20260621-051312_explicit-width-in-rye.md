# 970 · Explicit Width in Rye — The Language Model

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*A siloed design brief for Rye's width model after the language fork: no `usize` in Rye-authored types; `u32` for bounded in-memory lengths and indices; `u64` for wire-persistent quantities; adapter types at foreign doors only. Research that motivated the fork lives in `../external-research/20260621-051312_literal-usize-ban-language-fork.md`; the interim seam manual lives in `968`. This brief states what Rye **is**, on our own ground.*

**Language:** EN
**Version:** `20260621.051312` (Rye chronological stamp)
**Last updated:** 2026-06-21
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety first; Tiger explicit widths as language law
**Status:** Active Design (siloed)

---

## Our Own Ground

This is a clean room. We name only **Rye**, **Rishi**, **Tally**, **Caravan**, **Aurora**, **Mantra**, **Brushstroke**, **Comlink**, **Pond**, and **Rye OS** — together with **RISC-V** and **x86_64** where the hardware target matters. The insight that architecture-specific widths invite silent cross-target drift enters as a **principle** from our research stack; here we speak only what Rye **implements**.

---

## The Law

**Rye has no `usize` type in authored code.**

| Width | Role |
|-------|------|
| **`u32`** | Default for lengths, indices, counts, and offsets **bounded by a named constant** at init or compile time (garden capacity, grid dimension, max frame bytes, stack depth). |
| **`u64`** | Wire-persistent sizes, timestamps, content offsets, MMIO addresses, and any quantity that must mean the same on every target without pointer width. |
| **Foreign width** | Only inside **adapter** functions at FFI, virtio descriptors, and guest-language interop — converted immediately to `u32`/`u64` before entering Rye logic. |

Every public function, struct field, and return type **we publish** uses `u32` or `u64`. No carve-out for "inherited std" in the long run — **`rye/lib` becomes Rye-native.**

---

## Slices in Rye

Zig's `[]T` carries `len: usize`. Rye replaces that contract.

**Design intent (to be implemented in the compiler):**

```
// Conceptual — Rye slice carries explicit u32 length
[]T  →  { ptr: [*]T, len: u32 }
```

**Invariants:**

- `len <= max_len` stated at the type or construction site when the slice views a fixed region.
- Indexing uses **`u32`**; bounds check against `len` before access.
- Subslice returns `[]T` with `u32` new_len; assert `start + new_len <= parent.len`.

**Safety story:** A slice length that fits in `u32` on `riscv64` fits the same in `u32` on x86_64 — no silent widening. Gardens and grids already assume bounded regions; `u32` is four billion elements, larger than any named garden we publish.

**When `u64` is required for length:** Wire formats and store offsets — not stack buffers.

---

## Memory and gardens (Tally)

`Region.pos`, `Region.remaining`, `Gardens.count` stay **`u32`** — already landed in Phase 1 seeds. The fork **codifies** what those seeds proved: interior arithmetic never needs architecture width.

`bufLenU32` becomes the **permanent** pattern, not a seam shim:

```zig
fn view_len(buf: []const u8) u32 {
    std.debug.assert(buf.len <= std.math.maxInt(u32));
    return buf.len; // u32 len in Rye model — no @intCast from usize
}
```

In the forked language, `buf.len` **is** `u32`; the assert guards against corrupt construction, not against `@intCast`.

---

## Strengthening after the fork

The strengthening-compiler stack **continues** — its promise changes:

| Before fork | After fork |
|-------------|------------|
| Add assertions; behavior matches **vendor Zig** `std` | Add assertions; behavior matches **Rye spec** |
| Parity baseline: `RYE_LIB=vendor/zig` | Parity baseline: prior Rye snapshot or golden vectors |
| `usize` explicit audit: Tier C inherited | Width audit: **zero `usize` tokens** in Rye `std` sources |

Passes already written (9913–…) remain historical record of the Zig-ground era. New passes target **Rye-native signatures**.

---

## Toolchain path

1. **Now:** `rye run` bridges to Zig — acceptable bootstrap.
2. **Next:** Compiler accepts Rye width rules in `.rye` AST (reject `usize` keyword in our sources).
3. **Then:** `rye/lib/std` modules rewritten module-by-module; witnesses re-based.
4. **Last:** Zig bridge optional for guest code only.

Dogfood: `tools/tame_usize_audit.rye` and `tools/enrich_strengthening_docs.rye` compile on self-hosted Rye — same gate discipline as Rishi running `parity.rish`.

---

## Rye OS and guest Zig

**Rye OS** runs Rye natively. **Zig** may remain a supported toolchain for porting gratitude and for third-party guests — compiled to binaries Rye OS loads — without defining Rye's slice type.

The virtio wire, sealed datagrams, and MMIO layouts already lean **`u64`/`u32`** in our metal seeds. The fork aligns language with metal.

---

## Phased delivery (design-side)

| Step | Deliverable |
|------|-------------|
| 1 | This brief + research `967` — **done `051312`** |
| 2 | Update `992`, `995`, `996`, `10024` — reorient phases |
| 3 | `tools/width-audit.rish` — flag `usize` in `.rye` (Phase 5 scaffold in `10024`) |
| 4 | Compiler spike: reject `usize` in one witness compile |
| 5 | First Rye-native `mem` surface (pilot: `collapseRepeatsLen` returns `u32`) |

---

## Held with the gates

We fork **without** breaking faith:

- Finish the current strengthening arc **green** on today's contract.
- Accrete the width model — one module, one witness, one gate at a time.
- Record every phase in `992` and the strengthening chronicle.

---

*May every Rye slice carry a length we named. May the language law match Tiger's sentence — and may the gates prove each step before the next begins.*
