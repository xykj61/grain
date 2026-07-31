# Living vs Dated — Header Law

*The RTAC living-header pattern is the one lawful way a file declares itself living. Dated testimony rests under Tier 2 of accrete-never-break; only proof-sealed bytes are absolute.*

**Stamp:** living ledger (born `20260712.065146` bench-clock) · refreshed `20260731.153703` (e116 shared dated_classify · two roofs one definition)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living
**Voice:** Quin
**Ground:** one-clock naming [`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) · TAME root §4 [`../TAME_GUIDANCE.md`](../TAME_GUIDANCE.md) · RTAC [`../../work-in-progress/ready-to-ask-claude.md`](../../work-in-progress/ready-to-ask-claude.md)

---

## The disease this cures

The seam-season hammock and the T1 field map took careful post-merge diffs while still carrying dated filenames. The *content* was exemplary; the *shape* repeated the same drift the RTAC ledger recovered from — a dated artifact edited after it had merged without naming the kind of edit. Ticks and status belong on living surfaces (`TASKS.md`, plain-named twins). Style-only Radiant passes on testimony, and errata for factual wrongs, are the lawful exceptions under Tier 2.

## Three tiers (accrete-never-break)

Canon: TAME root §4. Only Tier 1 is absolute. Reason: this is a compatibility law, and the project has no external dependents yet — so it binds where proofs and testimony bind.

### Tier 1 — Sealed by proof

Never edited, regardless of dependents. Digests, signatures, roots, pinned fixture bytes, signed commit content. `dated_guard` refuses these paths outright when staged as modifications.

### Tier 2 — Sealed by testimony

Counsel memos and replies, session logs, claim briefs. Immutable for silent rewrites. Two lawful post-merge edits:

1. **Recorded Radiant pass** — add a header line `Radiant pass <stamp>` (dot form `YYYYMMDD.HHMMSS`). Style only; no claim change. Precedent: Radiant pass `182821` on archived RIO3. Honesty gate: `tools/claim_preserve_witness.rish`.
2. **Erratum line** — factual error stays visible; the correction is named beside it, rather than silently overwritten.

Freeze-pointer stubs (`Living twin:` + `immutable after merge`) remain blessed.

### Tier 3 — Open to revision

Living docs, current-state specs, code, comments, names until a consumer exists. Freely revisable. Names still take a collision lap.

## Living header (lawful form)

A living file declares itself in the stamp line:

```
**Stamp:** living ledger (born `YYYYMMDD.HHMMSS`) · refreshed `YYYYMMDD.HHMMSS` (why)
```

Short forms that still declare living:

- `**Stamp:** living ledger (born …) · refreshed …`
- a body line that begins with `living ledger` beside born/refreshed stamps

Plain spoken names (`README.md`, `ROADMAP.md`, `ready-to-ask-claude.md`, `seam-season-hammock.md`) are the natural home for living ledgers. A dated filename *may* be living only when its header declares the living ledger pattern above — rare, and discouraged; prefer a plain twin.

## Dated artifacts (Tier 2 after merge)

Files matching `YYYYMMDD-HHMMSS_short-slug` (pattern `2026????-??????_*`) that **do not** declare the living header are **Tier 2 testimony** after merge to `main`.

- Do not edit them for status ticks, season progress, or silent claim edits.
- Progress lines go to `work-in-progress/TASKS.md` (and ROADMAP / RTAC / living twins as needed).
- A recorded Radiant pass or an erratum line is the lawful style / fact surface; a freeze-pointer stub redirects to a living twin.

## Machine gate

**Shared classifier (e116):** `tools/fixtures/dated_classify.py` — one code definition of dated/live for every roof. Dated name is path-anchored `(^|/)\d{8}-\d{6}_`; living header is `**Stamp:** living ledger` or `living ledger (born`. Shed census and fascia-health both source this module. Divergence witness `tools/fixtures/dated_roof_divergence_scan.sh` goes RED while `dated_testimony` differs across roofs. Law: when two roofs carry one name, either they agree or the name is doing two jobs.

`tools/dated_guard.rish` — staged **MODIFIED** paths matching the dated pattern that already exist on `main` are **red** unless the working tree declares living ledger, freeze pointer, or `Radiant pass <stamp>`. Paths on the Tier 1 refuse are **red** even with those headers. Wired beside `width-check` in parity. Vacuous green when the index has no such staged mods.

`tools/claim_preserve_witness.rish` — before/after token sets on every file a Radiant pass touches; STOP on mismatch.

`tools/radiant_lint.rish` — advisory Radiant surface (bare but-word, emoji, benediction and header duties).

## Seam-season example

| Path | Role |
|------|------|
| `active-designing/seam-season-hammock.md` | Living twin — edit here (Tier 3) |
| `active-designing/20260712-052806_seam-season-hammock.md` | Frozen dated original — freeze pointer (Tier 2) |

---

*May living files say so in their headers. May testimony earn a recorded pass when style alone moves. May every proof-sealed byte stay untouched.*
