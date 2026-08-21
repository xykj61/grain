# Dimeroll Lap 3 — Sight View (Carriage + Books on One Frame)

*Implements the horizon essay's sight altitude: MUR/WOV carriage facts (was MALA) and Dimeroll books projections on one Skate fold. Amphora, Dexter graduation, and Pond policy wait their own gates.*
Radiant pass `20260728.045307` — living L1 rename-forward: **MUR** (was MALA)

**Stamp:** `20260710.132548`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME · SLC · Gall's Law
**Status:** Checkable-room hammock — lap 3 green (books P&L/BS lines + unified sight frame); parity **210**
**Ground:** horizon [`../external-research/20260710-131956_seen-books-living-desktop-horizon.md`](../external-research/20260710-131956_seen-books-living-desktop-horizon.md) · lap 2 [`20260710-131212_dimeroll-lap2-reports.md`](20260710-131212_dimeroll-lap2-reports.md) · thin-view exception [`../context/specs/20260709-225343_thin-view-dexter-exception.md`](../context/specs/20260709-225343_thin-view-dexter-exception.md)

*Written by Kaeden and Rio 3 (Grok).*

---

## Mission

Make the **seen books** vision checkable on the bench: extend `booksviewtest` with P&L and balance-sheet lines; add `sightviewtest` that folds carriage (MUR mint + WOV bundle; was MALA) and books (Dimeroll journal) into one ten-line Skate frame.

## In Scope

| Piece | Claim |
|-------|--------|
| Books view | Ten lines: trial balance + P&L + BS |
| Sight view | Ten lines: carriage + books + fold marker |
| Witness | `tools/dimeroll_sight_view.rish`; books witness updated |
| Exception | Thin-view pattern — local fixtures, no Pond/Dexter |

## Out of Scope

- Live window / Realidream module  
- MUR→journal bridge (was MALA)  
- Tax package / Amphora cargo  

## Success

- `drawn-terminal booksviewtest` → lines=10 GREEN  
- `drawn-terminal sightviewtest` → lines=10 GREEN  
- Parity **210**

---

*May carriage and books share one glass. May the fold stay green.*
