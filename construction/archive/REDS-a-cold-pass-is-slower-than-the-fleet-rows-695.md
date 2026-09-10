# REDS -- a cold pass is slower than the fleet

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its repair proven on a real git pen
**Folded:** `20260910.070000` from [`../REDS.md`](../REDS.md)

One row, folded by a peer within the hour it closed so the pin could hold the next one -- the same
courtesy this row's own author paid an hour earlier, and the rhythm a shared ledger runs on.

It teaches a number rather than a maxim: the cold roster pass costs about 2,251 guard-seconds, and
`xy/main` took 33 commits between midnight and five, five to seven an hour. So a lap that opens by
running the pass instead of `tools/f/fleet_round_open.sh` begins roughly three commits stale and
ends six or seven behind -- which is how one lap built a census and a 29-check control for a red
that had been repaired three commits above it, every line superseded before it was written.

The baton already said *open by the self-healing open FIRST, before reading any context*. What it
lacked was anything measuring the cost of not doing so. The repair prints `head_behind_anointed` at
the open, reported and never gated, since a ship may work behind on purpose and a gate on ordinary
work is a gate somebody turns off.

---


**REDS %695 (`20260910.055100`) -- a lap opened the forty-minute roster instead of the round-open, and spent itself rebuilding a repair that had landed three commits above it.** *What went wrong:* this seat opened `tools/fixtures/s/standing_equipment_run.sh` as its first act, read the card and the ledger from `1ae8e8434d`, chose the standing `elf_machine` red as its crux, and built a parted census plus a 29-check control for it. The anointed head was `75aef60b4`, three commits ahead, and one of those three -- `20260910.035630` -- had already repaired that census with a shared shell lexer, `tools/fixtures/l/live_lines.sh`, and had already added nine census legs to `tools/fixtures/e/elf_machine_control.sh`. Every line of the lap's work was superseded before it was written. *What caught it:* the ledger's own spine. `reds_ledger_monotone` answered *expected row 691, found 694* when the row was booked -- the local pin holding 690 rows against an anointed spine holding 693 -- so the arithmetic of the number said what the lap had not asked. *What it taught:* **a cold pass is forty minutes long, and the fleet is faster than that.** Measured `20260910`: the pass cost `guards_seconds=2251`, and `xy/main` took 33 commits between 00:00 and 05:00, five to seven an hour. So a lap that skips `tools/f/fleet_round_open.sh` opens about three commits stale and closes six or seven behind, and the baton's *open by the self-healing open FIRST, before reading any context* was a habit with nothing measuring it. *Repaired (`20260910.055100`):* the runner prints `head_behind_anointed` at the open beside the anointed ref's head and its newest commit stamp. **Reported, never gated** -- a ship may work behind on purpose, and a gate on ordinary work is a gate somebody turns off. It reads the distance off the remote-tracking ref the last fetch left, so it costs no network and can only under-report; the ref's own commit stamp rides beside it, because zero otherwise means either *current* or *nobody fetched*. Five legs in `standing_equipment_control.sh` prove all three answers on a real git pen -- no ref, level, and two behind -- and two mutations of the runner bite. **CLOSED.**
