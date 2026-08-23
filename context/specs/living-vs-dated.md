# Living vs Dated — Header Law

*The RTAC living-header pattern is the one lawful way a file declares itself living. Proof-sealed bytes and named freeze classes stay absolute; dated seats match the practice they describe.*

**Stamp:** living ledger (born `20260712.065146` bench-clock) · refreshed `20260802.182720` (e237 dated-law path — Keaton's word: narrow to freeze classes · counsel lean seated)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living
**Voice:** Kyri
**Ground:** one-clock naming [`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) · TAME root §4 [`../TAME_GUIDANCE.md`](../TAME_GUIDANCE.md) · RTAC [`../../crux/ready-to-ask-claude.md`](../../crux/ready-to-ask-claude.md) · doorway finding [`../../counsel/date/20260802/20260802-182500_e236-the-guard-is-a-doorway.md`](../../counsel/date/20260802/20260802-182500_e236-the-guard-is-a-doorway.md)

---

## The disease this cures

The seam-season hammock and the T1 field map took careful post-merge diffs while still carrying dated filenames. The *content* was exemplary; the *shape* repeated the same drift the RTAC ledger recovered from — a dated artifact edited after it had merged, without naming the kind of edit. Ticks and status belong on living surfaces (`TASKS.md`, plain-named twins). A second disease arrived later: a law written narrower than its practice, counting hundreds of quiet amendments as if they were faults. e236 measured the record; e237 seats the honest width.

## Three tiers (accrete-never-break)

Canon: TAME root §4. Only Tier 1 is absolute. Reason: this is a compatibility law, and the project has no external dependents yet — so it binds where proofs and freeze classes bind.

### Tier 1 — Sealed by proof

Never edited, regardless of dependents. Digests, signatures, roots, pinned fixture bytes, signed commit content. `dated_guard` refuses these paths outright when staged as modifications. Roster: `tools/fixtures/dated_guard_tier1.txt`.

### Tier 2 — Dated seats (amendable until superseded)

Counsel memos and replies, design briefs, session logs, claim briefs, expanding prompts, and their siblings under the amendable roofs (see Machine gate). These are **photographs** (e223). They may be amended after merge when the tree needs the truth more than the freeze — of-the-hour counts, errata, forward corrections, Radiant passes — and a **superseding seat** is always preferred when the claim itself moves.

Two named forms remain first-class:

1. **Recorded Radiant pass** — add a header line `Radiant pass <stamp>` (dot form `YYYYMMDD.HHMMSS`). Style only; no claim change. Honesty gate: `tools/claim_preserve_witness.rish`.
2. **Erratum line** — factual error stays visible; the correction is named beside it, rather than silently overwritten.

Freeze-pointer stubs (`Living twin:` + `immutable after merge`) remain blessed. Aging counts inside a dated seat are written **of-the-hour** (e235), or they live outside the seat.

Hundreds of historical amendments under this roof are a **description of the record**, not a task list of violations (e236).

### Tier 2-freeze — Named freeze classes

Witnesses, goldens, receipts, and key material stay frozen after merge. Staged modifications of dated paths in these classes are **red** unless the working tree declares living ledger, freeze pointer, or `Radiant pass <stamp>`. The doorway watches these hours; it does not audit the past (e236).

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

## Machine gate

**Shared classifier (e116 · ported to Rishi `20260809`):** `tools/fixtures/dated_classify.rish` — one definition of dated/live for every roof, Rishi owning the interface over a POSIX-sh `rg` seam (elder `dated_classify.py` kept as a fossil until the last consumer migrates). Dated name is a path-anchored stamp segment `YYYYMMDD-HHMMSS_`, matched as `(^|/)\d{8}-\d{6}_`; living header is `**Stamp:** living ledger` or `living ledger (born`. Shed census and fascia-health both source this definition. Divergence witness `tools/fixtures/dated_roof_divergence_scan.sh` goes RED while `dated_testimony` differs across roofs. Law: when two roofs carry one name, either they agree or the name is doing two jobs.

`tools/dated_guard.rish` — **a doorway, not an auditor** (e236). It inspects *staged* MODIFIED paths only.

- **Tier 1** roster paths — always red when staged as modifications.
- **Freeze-class dated paths** (witness · golden · receipt · `keys/`) already on `main` — red unless living ledger, freeze pointer, or Radiant pass.
- **Amendable-roof dated paths** (`counsel/` · `active-designing/` · `expanding-prompts/` · `session-logs/` · `foundations/` · `waymarks/` · `active-reviving/` · `external-research/` · `edu/` · `press/` · `saga/` · `classical-vedic-astrology/` · `crux/` · `rye-learning-process/` · dated `context/specs/`) — OK; amendable until superseded.
- Vacuous green when the index has no staged freeze/Tier-1 mods.

`tools/claim_preserve_witness.rish` — before/after token sets on every file a Radiant pass touches; STOP on mismatch.

`tools/radiant_lint.rish` — advisory Radiant surface (bare but-word, emoji, benediction and header duties).

## Seam-season example

| Path | Role |
|------|------|
| `active-designing/seam-season-hammock.md` | Living twin — edit here (Tier 3) |
| `active-designing/date/20260712/20260712-052806_seam-season-hammock.md` | Dated original — amendable until superseded; freeze pointer still blessed |

---

*May living files say so in their headers. May a doorway watch the hours it can watch. May freeze classes stay frozen, and may every other seat earn a superseding page when the claim itself moves.*
