# Width Baseline — explicit widths in authored Rye

**Stamp:** `20260621.070712`
**Last updated:** 2026-06-29 (aligned to `context/TAME_GUIDANCE.md` — seam policy; fork as horizon)
**Policy:** `context/TAME_GUIDANCE.md` · `gratitude/TIGER_STYLE.md` · `active-designing/970`
**Status:** Living inventory. Prefer `u32`/`u64` in authored APIs; `usize` only at the inherited-std seam with assert + `@intCast`. Compiler fork (slice `len: u32`) is a **horizon** — active track is explicit widths + lint beside SLC.

*Reviewed in the yonder sweep on 2026-06-29 and kept active — canonical width inventory.*

---

## The Law

**`usize` is a boundary type, not a design type** (Tiger Style + TAME Guidance).

| Width | Use |
|-------|-----|
| **`u32`** | In-memory counts, indices, lengths bounded by a named constant (`max_*`, garden capacity, grid dimension). |
| **`u64`** | Wire-persistent sizes, timestamps, MMIO addresses, cross-target quantities. |
| **`usize`** | **Avoid** in authored Rye. **Only** at the inherited-std seam: assert `len <= maxInt(u32)` (or named bound), arithmetic in `u32`, `@intCast` for the Zig API call. Seam casts are correct Tiger code — see `tally/seed.rye` `bufLenU32`. |

**Never** `usize` in struct fields, public parameters, or return types we publish.

**Compiler fork (F1–F5):** deferred horizon — `active-designing/20260628-043542_thin-frontend-slc-direction.md`. Authored-width migration (Phase 1b, `mantra/*` next) continues **decoupled** from any fork.

---

## Current Corpus (inventory)

| File | `usize` hits | Status |
|------|-------------|--------|
| `rishi/src/main.rye` | 37 | Migration target (`TH-5`) |
| `brushstroke/skate_grid.rye` | 18 (seam casts) | Phase 1b done (`235812`) |
| `caravan/chain.rye` | 2 (seam casts) | Phase 1b done (`235512`) |
| `comlink/hosted_wire.rye` | 12 | Migration target |
| `aurora/src/deciding.rye` | 11 | Migration target |
| `aurora/src/posted.rye` | 11 | Migration target |
| `brushstroke/wayland_seed.rye` | 0 | Phase 1b done (`235812`) |
| `aurora/src/relay.rye` | 8 | Migration target |
| `tally/gardens.rye` | 5 (seam casts) | Seam + migration |
| `mantra/src/main.rye` | 5 | Migration target (`TH-3`) |
| `tally/seed.rye` | 2 (seam casts) | Exemplar — sanctioned seam |
| `rye/src/main.rye` | 2 | Migration target |
| `caravan/bounded.rye` | 2 (seam casts) | Seam |
| `caravan/twin.rye` | 2 (seam casts) | Seam |
| `caravan/seed.rye` | 0 | Clean |

Re-run inventory: `tools/tame_usize_audit.rye` / `width-check.rish` after each migration pass.

---

## Gates

| Gate | Role | Status |
|------|------|--------|
| `tools/width-check.rish` | Seam-aware scan for authored `usize` in published `.rye` | Live — **refined** (TH-1; blesses `@intCast` / `@as(usize` seam casts) |
| `tools/tame-check.rish` | Assert style, whitespace, `Self = @This()` | Live — **gate** (TH-2c; hosted corpus clean) |
| `tools/width-check.rish` | No authored `usize` (seam casts blessed) | Live gate (TH-1); **RED** until Comlink/Aurora migrate; **outside parity** until global zero |

Ruling #1 (approved): seam-aware `width-check` so sanctioned `@intCast` / `@as(usize` pass while authored `usize` still fails.

---

## Fork Horizon (not the active primary track)

| Step | What | Status |
|------|------|--------|
| **F0** | Policy: explicit widths + seam discipline | **Active** — `context/TAME_GUIDANCE.md` |
| **F1–F5** | Compiler fork: reject `usize`, native slice `len: u32`, self-host | **Horizon** — research in `active-designing/yonder/20260621-070712_the-compiler-fork.md` |

The 120 parity witnesses (116 + four SLC-1) specify behavior the living desktop must keep. A fork is deliberated only from a mature whole.

---

## Known Issue: Enricher Wrong Functions

`tools/enrich_strengthening_docs.rye` grabs wrong functions by bare name (e.g., `Atomic.replace` instead of `mem.replace`). Fix: match by full module path. Re-run on all 86 docs.

---

*Prefer fixed widths. Assert at the seam. Grow the lint beside the work — TH-1 through TH-5 on the bench.*
