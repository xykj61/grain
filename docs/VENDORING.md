# Vendoring — three homes and the pin habit

*Teacher sources pin at commit; workbench droppings stay in cache; gratitude holds the clean-room study shelf.*

**Status:** Checkable — vendor · gratitude · cache recipe
**Depth:** recipe
**Ceiling:** ≤150 lines
**Last updated:** 2026-07-12
**Compresses:** [`20260712-204549_proven-seat-g1-claude-close.md`](../active-designing/20260712-204549_proven-seat-g1-claude-close.md) · [`20260712-214900_signed-kumara-monocypher-pin.md`](../active-designing/20260712-214900_signed-kumara-monocypher-pin.md) · [`ORGANIZING.md`](../ORGANIZING.md) · [`external-research/20260620-014412_system.md`](../external-research/20260620-014412_system.md) (Gratitude Licenses)

---

## Three homes

| Home | Holds | Git | Ship rule |
|------|-------|-----|-----------|
| **`vendor/`** | Third-party source the **build leans on** — submodules at pinned commits | Tracked (submodule pointer + allow-list) | Never link AGPL/LGPL teachers into Rye binaries we ship; guest artifacts and host tools only where license allows |
| **`gratitude/`** | Works we **honor whole** for clean-room study | Gitlinks / submodules | **Never copy** code or text into our modules — study concepts, write our own |
| **`tools/.cache/`** | Workbench — builddirs, tarballs, contrib, META shelves, pinned binaries | Gitignored | Droppings stay out of porcelain; witnesses write META here |

**Placement test:** if the tree needs it to **compile or link today**, it belongs in `vendor/` (with a fetch witness). If we **read to understand**, it belongs in `gratitude/`. If the tool **generates or downloads** during a lap, it belongs in cache.

**Docs law:** compression pages cite witnesses — see [`README.md`](README.md). Run the witness; do not trust prose for byte pins.

---

## Submodule-at-commit

1. Add submodule in `.gitmodules` with teacher URL and path under `vendor/` or `gratitude/`.
2. Check out the **exact commit** (tag optional; commit is the content address).
3. Write a **fetch witness** that runs `git submodule update --init` and asserts `HEAD` equals pin.
4. Record tag, remote, and home in cache **META** (see two-bank below).
5. Close with gratitude lines in the lap note and license row in the canonical table.

**Init recipe (any seated vendor submodule):**

```bash
git submodule update --init vendor/<name>
rishi/bin/rishi run tools/<lap>_fetch.rish   # asserts HEAD
```

---

## Two-bank hash habit

Every pin lives in **two banks** that must agree:

| Bank | Where | Role |
|------|-------|------|
| **Witness assert** | `tools/*_fetch.rish` (or scorecard) | Machine gate — `HEAD == pinned` or sha256 match |
| **META shelf** | `tools/.cache/<lap>/*-meta.txt` | Human audit trail written on GREEN — same fields, same bytes |

Drift between banks is a visible failure. Living `docs/` pages name the witness path, not the pin string.

**G1 META trio example:** toolchain · sources · ground — separate fetch witnesses write `g1-toolchain-meta.txt` and `g1-sources-meta.txt`. Crossing pin: [`20260712-195339`](../active-designing/20260712-195339_proven-seat-g1-crossing-pin.md).

---

## `ignore = untracked` stitch

When a teacher submodule **must be written inside** during builds (Genode `contrib/`, port prepare), add to `.gitmodules`:

```ini
[submodule "vendor/genode"]
	ignore = untracked
	path = vendor/genode
	…
```

Untracked files inside the submodule stay out of `git status` at the superproject root. **Workbench** paths (`CONTRIB_DIR`, builddirs, toolchain tarballs) still prefer `tools/.cache/` when the tool accepts an outside location — cache first, ignore-stitch when the teacher insists on in-tree writes.

Seated: `vendor/genode` per [`204549`](../active-designing/20260712-204549_proven-seat-g1-claude-close.md).

---

## Teacher table (seated pins)

| Name | Home | Pinning witness | License | Role |
|------|------|-----------------|---------|------|
| **Genode** | `vendor/genode` | `tools/proven_seat_g1_fetch_sources.rish` | AGPL (teacher) | G1 posix/libc sources · guest only |
| **Monocypher** | `vendor/monocypher` | `tools/proven_seat_signed_kumara_fetch.rish` | CC0 · BSD dual | signed-Kumara `crypto_ed25519_check` |
| **Zig toolchain** | `vendor/zig-toolchain` | naming-law fetch (see `context/specs/20260627-102012_one-clock-naming-law.md`) | MIT | Rye/Zig compiler prebuilt |
| **ai-jail** | `gratitude/ai-jail` + `tools/.cache/bin/ai-jail` | `tools/enclosure.conf.example` + host pin notes | teacher license in gratitude | Daily enclosure · binary in cache |
| **libqrencode** | `gratitude/libqrencode` | gitlink commit | LGPL-2.1 | Key-card CLI in `tools/.build/` only |

Full gratitude license matrix: [`external-research/20260620-014412_system.md`](../external-research/20260620-014412_system.md) → Gratitude Licenses and the Clean Room.

---

## What never crosses

- AGPL Genode **into** Rye ship binaries — guest artifacts under cache only.
- LGPL **into** Rye runtime — host tools beside the work, not embedded.
- Gratitude **into** `rye/` · `rishi/` · `tally/` — clean room; our vocabulary only.
- Cache **into** git — `.gitignore` and witness porcelain checks guard this.

---

## Dependencies

| Teacher | Role |
|---------|------|
| **Genode Labs** | `vendor/genode` submodule precedent · `ignore=untracked` |
| **Loup Vaillant (Monocypher)** | Permissive crypto vendor row |
| **TigerBeetle / Zig** | `vendor/` vs `gratitude/` split in naming law |

---

*May every teacher rest at a pinned commit, every droppings path stay in cache, and every witness keep the two banks honest.*
