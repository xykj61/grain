# Gratitude Licenses — Clean-Room Discipline

**Canonical reference:** `external-research/20260620-014412_system.md` → section **Gratitude Licenses and the Clean Room** (full Radiant notes per project). Mirror: `.cursor/rules/gratitude-licenses.mdc`.

`gratitude/` is a reading library, not a dependency. We study concepts; we never copy code.

## GPL-3.0 — gitlinks or not cloned

| Project | How we hold it | Study boundary |
|---------|----------------|----------------|
| **sixos**, **ai-jail**, **damus** | Gitlinks only — our git history never contains their source | Design concepts only; clean-room briefs in `active-designing/` |
| **River** (Isaac Freund) | **Not cloned** | GPL-3.0. Public Wayland protocol specs + public project documentation only |

Per-project Radiant notes: see **997_SYSTEM.md**.

## LGPL-2.1 — gitlink or local clone, never linked into Rye

| Project | How we hold it | Study boundary |
|---------|----------------|----------------|
| **Nix** | Local clone; not tracked by git | Store model → Brix, Tablecloth; do not link libnix |
| **libqrencode** | Gitlink | Build CLI to gitignored `tools/.build/` only; do not link into Rye binaries |

LGPL limits **embedding** library code in programs we distribute — not learning ideas or running tools separately. Full notes: **997_SYSTEM.md**.

## The microkernel family -- verified `20260821.041056` (license read granted by Keaton)

Read from each project's own authoritative text, not from memory. Full verdict and sources: [`../../external-research/20260821-041056_the-microkernel-license-read.md`](../../external-research/20260821-041056_the-microkernel-license-read.md).

| Component | License | How we may hold it |
|---|---|---|
| **seL4 kernel** | **GPL-2.0** | study only -- no kernel source in our history |
| **seL4 userlevel** (`libsel4`, libraries, tools, syscall headers) | **BSD-2-Clause** | **permissive -- a real dependency is thinkable**, vendored like Monocypher on a later word |
| **seL4 Microkit** | **BSD-2-Clause** (code), CC-BY-SA-4.0 (docs) | permissive |
| **LionsOS** | **BSD-2-Clause** (code), CC-BY-SA-4.0 (docs) | permissive |
| **Genode** | **AGPLv3** + open-source linking clause, dual-licensed commercially | study only -- strong copyleft, unchanged |
| **musl** | **MIT** | permissive |

**The load-bearing sentence**, from seL4's own `LICENSE.md`: the kernel's GPL *"does not cover user-level code that uses kernel services by normal system calls"*, and such usage *"does not fall under the heading of 'derived work'."* Caravan is a root task on the userlevel side of that line.

**The obligation that rides with it:** a **per-file SPDX sweep at fetch time**. seL4 issue #245 (2020) reported ~14 GPL-tagged files inside `libsel4`; the two most prominent read `BSD-2-Clause` on master today, checked directly, yet a project that once shipped mixed headers can again. Intent is not a licence -- check every file's own tag and record it.

**FETCHED `20260821.042612` on Keaton's word** (*I grant the fetch, vendor sel4 userlevel and microkit*). Both are **gitlink submodules**, so no vendored source enters our git history: `vendor/sel4` (the whole seL4 repo -- the BSD userlevel is what we may link, the GPL kernel rides along on disk and is neither linked nor in our history) and `vendor/microkit`.

**The per-file sweep is now a standing check, not a one-time read:** [`../../tools/sel4_userlevel_license_witness.rish`](../../tools/sel4_userlevel_license_witness.rish) over [`../../tools/fixtures/vendored_license_scan.sh`](../../tools/fixtures/vendored_license_scan.sh), GREEN on metal with both RED legs proven.

| Measured `20260821.042612` | Count |
|---|---|
| `libsel4` files / tagged / **BSD-2-Clause** / GPL | 185 / 185 / **185** / **0** |
| seL4 kernel (`src/` + `include/`) GPL tags | 618 -- the split is proven from both sides |
| Microkit BSD-2-Clause | 303 |
| Microkit GPL, **by path** | exactly 2, both board device-tree overlays under `custom_dts/`, neither linkable code |

**seL4 issue #245 is genuinely resolved** -- checked file by file rather than taken on intent. Microkit's two GPL files are bounded **by path** rather than by count, so a new one anywhere else reds on the lap it arrives. The witness audits SPDX **tags**, never licence text; counsel stays the authority where distribution or money is at stake.

## skarnet (s6, skalibs) — ISC, not GPL

**s6** and **skalibs** (Laurent Bercot) are **ISC** — permissive, not GPL. **SixOS** (Adam Joseph) is the GPL-3.0 project that composes s6 with Nix.

- Local clones may exist on disk for reading; they are **not tracked by git**
- Prefer **public API reference and design docs on the web** (skarnet.org) as the legal study surface
- **Caravan** inherits s6's supervision *discipline*; **Tally** inherits skalibs' bounded-allocation *discipline* — our own names, our own Rye code (`external-research/974`)

## Other local-only clones (nix — NOT tracked by git)

- **Nix**: LGPL-2.1 — see 997 for full note
- Never add local nix clone to git

## LGPL gitlinks (libqrencode)

- **libqrencode**: LGPL-2.1 gitlink; build CLI to `tools/.build/` only — see 997

## Permissive projects (zig, dvui, urbit, tigerbeetle, sui, primal, manyana, infuse.nix, Ghostty, Monocypher)

- MIT, ISC, Apache 2.0, public domain / CC0 — safe to study freely
- **Monocypher** — CC0 · 2-clause BSD dual; vendored at `vendor/monocypher` @ 4.0.3 for signed-Kumara guest verify
- Still write our own implementations; concepts enter through the clean room

## The clean-room path

External research (`external-research/`) studies the world with attribution. Active designing (`active-designing/`) names only our own modules. The boundary between reading and building is the boundary between `gratitude/` and `rye/`, and it is never crossed by code — only by understanding.
