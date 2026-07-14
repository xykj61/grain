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
