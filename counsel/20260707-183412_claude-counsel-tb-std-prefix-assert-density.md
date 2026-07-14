# Claude Counsel — TigerBeetle `std.` Prefixes, Assert Density, and `maybe` Parked to RTAC

**Stamp:** `20260707.183412 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · TigerBeetle `tidy.zig` held against practice
**Register:** Ruling — measured against TB source, not folklore
**Ground:** tigerbeetle `src/` grep counts on this bench · `gratitude/TIGER_STYLE.md` line 374 · authored `.rye` assert import census · `mantra/recall_sync_wire.rye` · `mantra/snapshot_export_delivery.rye`

*Written by Kaeden and Rio 3.*

---

## The Direct Answer on `std.` Prefixes

TigerBeetle **declares** namespace aliases in a minority of files (`mem` in 41 of 244, `math` in 23) — yet **writes the qualified form at most call sites**: `std.mem.` **1,171** vs bare `mem.` **143**; `fmt` **130** vs **16**; `meta` **340** vs **13**. The one genuine inversion is `posix` (352 bare vs 92 qualified in syscall-heavy files). Our tree holds four `std.posix.` calls total — nothing for that pattern to apply to. Their style doc line 374 — *"Don't duplicate variables or take aliases to them"* — matches the practice.

**Ruling:** our heavy `std.` prefixing is TigerBeetle's majority practice. Nothing sweeping wants changing.

## What TB Aliases Near-Universally

| Alias | TB prevalence | Our tree |
|-------|---------------|----------|
| `assert` | 196/244 files | machine-held law — unqualified import |
| scoped `log` | 87 files | print-witness discipline; no need yet |
| **`maybe`** | 57 files | **parked to RTAC** — dual of assert; natural home `tally/` beside `copy.rye` on Kaeden's word |

Import-block ordering and `Allocator`-type aliases ride along as **on-touch** guidance, not a sweep.

## Assert Density — the Gap That Mattered More

Only **49 of 105** scan-dir files imported assert; since qualified asserts are banned and the tree lints clean, the rest called assert nowhere. Most of the gap is honest: virtio guests, Aurora freestanding four, signal handler, font table, exit constants, thin line editor.

**Two were real:** `recall_sync_wire.rye` (268 lines, zero asserts) and `snapshot_export_delivery.rye` (imported assert, never called it). Both predate the density law.

**Repair (this bundle):** twenty-two contract asserts, behavior-neutral — encoder/decoder buffer postconditions, capacity guards before copies, `entry_count == total`, report lanes partitioning total, sealed/opened bounds on send and receive paths per pairing law. Untrusted wire input still refuses with named errors.

## Scan Advisory

`tools/fixtures/tame_style_scan.sh advise` prints **zero assert( files remaining** with an honest-exempt list (guests, aurora, signal handler, font table, line editor, exit vocabulary). Target: **0** non-exempt; review on touch when a new name appears.

---

*May the letter match the source we honor. May assert name what we already prove at the seam. And may `maybe` wait in RTAC until Kaeden's word gives it a home beside `copy_disjoint`.*
