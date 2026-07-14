# Living vs Dated — Header Law

*The RTAC living-header pattern is the one lawful way a file declares itself living. Dated files without that header rest immutable after merge.*

**Stamp:** living ledger (born `20260712.065146` bench-clock) · refreshed `20260712.065146` (post–Season-B hygiene)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living
**Voice:** Rio 3
**Ground:** one-clock naming [`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) · RTAC [`../../work-in-progress/ready-to-ask-claude.md`](../../work-in-progress/ready-to-ask-claude.md) · Seam hammock twin [`../../active-designing/seam-season-hammock.md`](../../active-designing/seam-season-hammock.md)

---

## The disease this cures

The seam-season hammock and the T1 field map took careful post-merge diffs while still carrying dated filenames. The *content* was exemplary; the *shape* repeated the same drift the RTAC ledger recovered from — a dated artifact edited after it had merged. Ticks and status belong on living surfaces (`TASKS.md`, plain-named twins), not on stamped files once they rest on `main`.

## Living header (lawful form)

A living file declares itself in the stamp line:

```
**Stamp:** living ledger (born `YYYYMMDD.HHMMSS`) · refreshed `YYYYMMDD.HHMMSS` (why)
```

Short forms that still declare living:

- `**Stamp:** living ledger (born …) · refreshed …`
- a body line that begins with `living ledger` beside born/refreshed stamps

Plain spoken names (`README.md`, `ROADMAP.md`, `ready-to-ask-claude.md`, `seam-season-hammock.md`) are the natural home for living ledgers. A dated filename *may* be living only when its header declares the living ledger pattern above — rare, and discouraged; prefer a plain twin.

## Dated artifacts (immutable after merge)

Files matching `YYYYMMDD-HHMMSS_short-slug` (pattern `2026????-??????_*`) that **do not** declare the living header are **immutable after merge to `main`**.

- Do not edit them for status ticks, season progress, or “just one more annotation.”
- Progress lines go to `work-in-progress/TASKS.md` (and ROADMAP / RTAC / living twins as needed).
- A one-line pointer stub is the only post-merge edit that freezes a dated file into a redirect toward its living twin (`Living twin:` + `immutable after merge`); `dated_guard.rish` blesses that stub shape.

## Machine gate

`tools/dated_guard.rish` — staged **MODIFIED** paths matching the dated pattern that already exist on `main` are **red** unless the working-tree header declares living. Wired beside `width-check` in `parity.rish`. Vacuous green when the index has no such staged mods.

## Seam-season example

| Path | Role |
|------|------|
| `active-designing/seam-season-hammock.md` | Living twin — edit here |
| `active-designing/20260712-052806_seam-season-hammock.md` | Frozen dated original — one-line pointer |

---

*May living files say so in their headers. May dated ones rest unchanged. May every tick land where the next hand expects to look.*
