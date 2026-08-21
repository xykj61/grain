# Dimeroll — Hammock Scope (Lap 1)

*Centralized books of record for Linengrow: chart, journal, fold, Skate view. Complements MUR (mailable; was MALA) and keeps each role clear. Visual Track: books seen through Brushstroke/Skate on the drawn terminal — Realidream thin-view pattern.*
Radiant pass `20260728.052441` — living L1 rename-forward: **MUR** (was MALA); prefer **kg u32** · fixture path held for tool step 4  
Radiant pass `20260728.045307` — living L1 rename-forward: **MUR** (was MALA)

**Stamp:** `20260710.125953`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME · SLC · Gall's Law
**Status:** Checkable-room hammock — lap 1 green (chart · journal · fold · books view); parity **207**/**208**; exception **267**; journal view **285**; sight journal **290**; **lap 4 closed** tip **394** (`230433`)
**Ground:** clean-room study [`../external-research/20260710-125953_dimeroll-kick-digits-clean-room.md`](../external-research/20260710-125953_dimeroll-kick-digits-clean-room.md) · Visual Track · thin-view exception [`../context/specs/20260709-225343_thin-view-dexter-exception.md`](../context/specs/20260709-225343_thin-view-dexter-exception.md) · resins/Amber seasons plainly

*Written by Kaeden and Rio 3 (Grok).*

---

## Mission

Ship the **first honest room** of Dimeroll: a steward can post balanced journal entries into an append-only log, fold a trial balance that conserves to zero, refuse unwelcome posts, and see the books as a Skate frame. Bank sync, AI categorization, tax package, and multi-entity wait later rooms.

## In Scope (Lap 1)

| Piece | Claim |
|-------|--------|
| Chart | Four accounts: `cash` · `revenue` · `expense` · `equity` |
| Journal | Debit + credit + amount + memo + stamp; debit amount = credit amount |
| Fold | Per-account net (debit-positive); sum of nets = 0 |
| Unwelcome | Unknown account · unbalanced amounts · zero/negative amount |
| Visual | `drawn-terminal booksviewtest` — trial-balance lines from fixture + fold |
| Home | `dimeroll/dimeroll_core.rye` + `dimeroll.rye` (own root module) |

## Out of Scope (Later Laps)

- Bank/feed sync, AI categorization, rules engine  
- Multi-entity, AR/AP, invoicing, bill pay  
- Tax package export, reconciliations, documents vault  
- Full Realidream module, Dexter graduation, Pond policy  
- Tablecloth v1 as app DB (query may index Dimeroll facts later)  
- Bridging MUR receipts into journal lines (was MALA)  

## Architecture

```
dimeroll_core  →  journal log  →  fold trial balance
                         ↓
              booksview (Skate lines)
                         ↓
              drawn_terminal booksviewtest
```

Brushstroke/Skate remains the pixel path. Tablecloth stays the horizon store; lap 1 uses fixtures + in-memory log like MUR M1 (was MALA).

## Visual Track Tie-In

| Existing | Dimeroll lap 1 |
|----------|------------------|
| `thinviewtest` | MUR mint + WOV bundle → 5 lines (was MALA) |
| `booksviewtest` | Dimeroll trial balance + P&L net + BS → 8 Skate lines |
| `sightviewtest` | Carriage (MUR/WOV; was MALA) + books → unified 8-line frame |
| Realidream full viewer | Still horizon |

## Success

- `dimeroll/bin/dimeroll selftest` prints GREEN  
- Witness in parity; books view witness green headless  
- Edit 5: no second designed-not-built functional spec (status names lap 1 green when wired)

---

*May the first room of the books close green. May candy mean the joy of a balanced fold.*
