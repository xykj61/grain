# Explicit Width Audit — `usize` to `u32` / `u64`

*Expanded at `210812` from the seed: TAME modeled on Tiger Style demands explicitly sized types; our Rye supplement still allowed `usize` for “array indices and lengths,” which contradicts the source discipline and leaves behavior variable across `riscv64` and hosted x86_64.*

**Language:** EN
**Version:** `20260620.210812` (Rye chronological stamp)
**Last updated:** 2026-06-30
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME · Tiger Style (`gratitude/TIGER_STYLE.md`, `external-research/TAME_STYLE.md`) · inherited-names · parity gate

*Reviewed and kept (`2026-06-30`) — width charter, heavily cited.*

---

## The Seed (faithful echo)

> We need a major audit of `usize` versus proper explicit sizes (`u64`, `u32`, …) because TAME / Tiger Style requires exact specificity — no platform variability. Decide the approach in open threads and roadmap, expand this prompt, and run it.

## What We Decided

**There is no `usize64` type to invent.** Rye speaks the widths Zig already gives us: **`u32`** for bounded in-memory counts, **`u64`** for wire-persistent and cross-target quantities. `usize` remains only at the inherited slice seam — convert at the door.

**Policy lives in** `context/TAME_STYLE.md` (Rye supplement, `210812`). **Baseline inventory** lives in `work-in-progress/20260620-212126_usize-width-baseline.md`.

**Strengthening and width are parallel tracks.** Strengthening passes (`9931` and below) keep earning `std` surfaces through parity on **vendor Zig baseline** until fork F3; then witnesses re-base to **Rye spec**. Width migration touches authored `.rye` first, then wire formats, then Rishi internals.

**Language fork (`051312`):** Rye will ban `usize` in authored types — research `external-research/20260621-051312_literal-usize-ban-language-fork.md`, design `active-designing/yonder/20260621-051312_explicit-width-in-rye.md`. Interim seam policy: `968`.

## Phased Migration

| Phase | Scope | Green when | Anchor |
|-------|--------|------------|--------|
| **0 — Baseline** *(this run)* | Policy in TAME spec; inventory; living docs | `992` written; `995`/`996` name the thread | `210812` |
| **1 — Bounded memory** | `tally/*`, `caravan/*`, Skate grid dimensions | Parity green; Tally/Caravan selftests green | `9989`, `10012` |
| **2 — Wire & metal** | `aurora/src/*`, `comlink/*` frame layouts | `aurora/run.sh` + hosted wire tests green | `991`, `10016` |
| **3 — Rishi** | `rishi/src/main.rye` eval indices, line numbers | Rishi regression + parity green | `10023` Track C |
| **4 — std at touch** | Only `usize` in a file already being strengthened | Parity witness for that surface | `9999` |
| **5 — Gate** | Optional `tools/width-audit.rish` — flag `usize` in struct fields / public params in authored `.rye` | CI advisory, then required | new |

## Rules of the Road

1. **Pair every width change with a bound or a wire spec.** `u32` names “fits in this garden”; `u64` names “on the wire forever.”
2. **Assert at every `@intCast` between `usize` and `u32`/`u64`.** `assert(len <= std.math.maxInt(u32))` before narrowing.
3. **Inherited `std` is not wrong — it is inherited.** Do not rename Zig’s public signatures; wrap at our API.
4. **Parity before breadth.** One module per session; gate trio green before the next file.
5. **Document in `992`** as phases close — counts should fall file by file.

## This Run — Phase 0 Deliverables

- [x] Correct `context/TAME_STYLE.md` (remove “lengths are `usize`”; add width table)
- [x] Write `work-in-progress/20260620-212126_usize-width-baseline.md` (inventory + tier tags)
- [x] Update `995_open_threads.md` and `996_roadmap.md`
- [x] Rules in `.cursor` and `.claude`
- [x] **Phase 1a:** `tally/seed.rye` + `tally/gardens.rye` on `u32` (`211712`)

## Next Run — Pick One

**Track A — Phase 1b (`caravan/seed.rye`)**

**Track B — Phase 2 pilot (`aurora/src/posted.rye`)**

- Frame offsets `u64`; in-buffer lengths `u32` with named `MAX_*`
- Freestanding build still links

**Track C — Phase 5 scaffold**

- `tools/width-audit.rish` lists `usize` in authored `.rye` struct fields (regex pass); no gate yet

## Cross-Links

| Topic | Lives in |
|-------|----------|
| Tiger source discipline | `gratitude/TIGER_STYLE.md` § Safety |
| TAME voice | `external-research/TAME_STYLE.md` |
| Inherited names / no std rename | `context/specs/inherited-names.md` |
| Main track ordering | `10023` |
| Style audit pattern | `994_style_audit.md` |

---

*May every count name its width before it names a platform. May the seam stay honest at the slice edge, and the garden stay bounded in `u32`.*
