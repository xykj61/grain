# Dimeroll — Centralized Books of Record

**Language:** EN
**Last updated:** 2026-07-10 (filters `230433`; parity **394**)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room module — laps 1–4 green; sight, exception, P&L, BS, TB, journal, chart, cash-account, memo-prefix, cash-flow, and sum-amounts views on Skate

---

Dimeroll is Linengrow's **centralized books**: one steward's chart of accounts, journal entries as facts, balances as a pure fold, reports as projections, and Skate views so the books can be *seen*. It complements **MUR** (mailable money; was MALA), holding each role clear.
Radiant pass `20260728.050004` — living L1 rename-forward: **MUR** (was MALA)

| Lap | Claim | Witness |
|-----|--------|---------|
| **1** | Chart · journal · trial-balance fold · unwelcome paths · Skate books view | parity **207** / **208** |
| **2** | Income statement · balance sheet · exception queue | parity **209** |
| **3** | Sight view — books P&L/BS on Skate + unified carriage+books frame | parity **210** |
| **4** | Account filter · memo prefix · cash flow · sum amounts + Skate views | parity **387**–**394** · `tools/dimeroll_lap4.rish`–`lap7.rish` |
| **exception view** | Refused drafts → five-line Skate frame | parity **267** · `tools/dimeroll_exception_view.rish` |
| **P&L view** | Income statement alone → five-line Skate frame | parity **271** · `tools/dimeroll_pnl_view.rish` |
| **BS view** | Balance sheet alone → five-line Skate frame | parity **274** · `tools/dimeroll_bs_view.rish` |
| **TB view** | Trial balance alone → six-line Skate frame | parity **277** · `tools/dimeroll_tb_view.rish` |
| **journal view** | Entry memos alone → five-line Skate frame | parity **285** · `tools/dimeroll_journal_view.rish` (`191112`) |
| **chart view** | Account names alone → six-line Skate frame | parity **292** · `tools/dimeroll_chart_view.rish` (`192749`) |
| **cash account view** | Entries involving cash → five-line Skate frame | parity **391** · `tools/dimeroll_cash_account_view.rish` (`230433`) |
| **memo prefix view** | Memo prefix stipend → five-line Skate frame | parity **392** · `tools/dimeroll_memo_prefix_view.rish` (`230433`) |
| **cash flow view** | Inflow/outflow/net → five-line Skate frame | parity **393** · `tools/dimeroll_cash_flow_view.rish` (`230433`) |
| **sum amounts view** | Journal amount total → five-line Skate frame | parity **394** · `tools/dimeroll_sum_amounts_view.rish` (`230433`) |
| **sight** | Chart of accounts on steward glass | parity **301** · `tools/dimeroll_sight_view_lap3.rish` (`200203`) |

## Layout

| Path | Role |
|------|------|
| [`dimeroll_core.rye`](dimeroll_core.rye) | Chart, parse, fold, reports, exceptions, lap-4 filters |
| [`dimeroll.rye`](dimeroll.rye) | Selftest binary |
| [`fixtures/journal.bron`](fixtures/journal.bron) | Pinned welcome journal |
| `bin/dimeroll` | Build output |
| `pond/apps/dimeroll/` | Symlinks for drawn-terminal import |

```bash
rishi/bin/rishi run tools/dimeroll_lap1.rish
rishi/bin/rishi run tools/dimeroll_lap2.rish
rishi/bin/rishi run tools/dimeroll_lap4.rish
rishi/bin/rishi run tools/dimeroll_books_view.rish
rishi/bin/rishi run tools/dimeroll_sight_view.rish
rishi/bin/rishi run tools/dimeroll_exception_view.rish
rishi/bin/rishi run tools/dimeroll_pnl_view.rish
rishi/bin/rishi run tools/dimeroll_bs_view.rish
rishi/bin/rishi run tools/dimeroll_tb_view.rish
rishi/bin/rishi run tools/dimeroll_journal_view.rish
rishi/bin/rishi run tools/dimeroll_chart_view.rish
rishi/bin/rishi run tools/dimeroll_cash_account_view.rish
rishi/bin/rishi run tools/dimeroll_memo_prefix_view.rish
rishi/bin/rishi run tools/dimeroll_cash_flow_view.rish
rishi/bin/rishi run tools/dimeroll_sum_amounts_view.rish
rishi/bin/rishi run tools/dimeroll_sight_view_lap3.rish
```

**Design:** hammock [`../active-designing/date/20260710/20260710-125953_dimeroll-hammock.md`](../active-designing/date/20260710/20260710-125953_dimeroll-hammock.md) · reports [`../active-designing/date/20260710/20260710-131212_dimeroll-lap2-reports.md`](../active-designing/date/20260710/20260710-131212_dimeroll-lap2-reports.md) · sight [`../active-designing/date/20260710/20260710-132548_dimeroll-lap3-sight-view.md`](../active-designing/date/20260710/20260710-132548_dimeroll-lap3-sight-view.md) · filters [`../active-designing/20260710-230433_dimeroll-lap4-filters.md`](../active-designing/yonder/20260710-230433_dimeroll-lap4-filters.md) · horizon [`../external-research/20260710-131956_seen-books-living-desktop-horizon.md`](../external-research/20260710-131956_seen-books-living-desktop-horizon.md)

---

*May the books stay foldable. May green mean the trial balance closed.*
