# REDS -- row %721, born on its shelf

**Written:** `20260911.202803` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The scratch is an instrument -- a guard that cannot write its own findings file reports a clean tree.*

Booked at `%718` and renumbered to `%720` and then to `%721` across two rebases. `xy` published a
row against each of `%718`, `%719` and `%720` while this one stood unshared -- the last of them at
`20260911.205727`, a LATER stamp than this row's, which changes nothing: a published number never
moves, and an unshared row derives above every number the spine has bound. The key is the stamp
([`../../.claude/rules/derived-spine.md`](../../.claude/rules/derived-spine.md)).

The row is born here rather than on the living pin, as `%699`, `%703`, `%706`-`%708`, `%711`-`%713`,
`%715`, `%719` and `%720` were: `reds_pin_capacity_scan.sh` read `rows_that_fit=0` against a 2,059-byte
median row. **The round it records was cut mid-send and never committed.** Its whole working tree
was parked by `fleet_round_open.sh` (`%321`), and the roster's own `stash_record` guard named it at
the next lap's open -- `unlanded=1`, a session log in the dead-letter box that no branch carried.
The lap that found it landed the repair whole and re-measured the census before booking, which is
the one edit a recovered row may take: it had yet to be shared.

---

**REDS %721 (`20260911.202803`) -- the guard reading every announced ladder length reports a clean tree when it cannot write its own scratch file.** *What went wrong:* `tools/fixtures/a/announced_length_scan.sh` walked the living pages into `/tmp/al_found.$$` under `2>/dev/null || true`, then read the file back. A scratch that never arrives yields an empty read: `announcements_checked=0`, `forecasts_short=0`, `verdict=no_living_forecast`, **exit 0** -- the same three lines a clean tree prints, and the only string the witness asserts. Proven on metal in a pen holding one sixty-four-rung `WIDE` forecast: writable scratch reads `living_forecast`, unwritable reads `no_living_forecast`, the forecast untouched in both. *What caught it:* the earth rota, row 4 -- the row that breathes in -- reading the scan's scratch line rather than its findings. *What it taught:* **this script kept the prove-before-trust discipline twice and skipped it on the one path that can zero the reading in silence.** `git` is proven present and the living listing non-empty, both citing `%413`; the scratch carrying every finding between those halves was trusted. *Measured -- a singleton, and one shell option makes it one:* **eleven** tracked scans redirect a block into a scratch and read it back. `mktemp` is not a refusal, so the reading is of what actually refuses: **five** carry `|| exit`, **five** carry `set -e` alone, under which a failed assignment ends the run, and this one carried `set -u` and neither -- proven in this shell, `set -eu` exits 1 where `set -u` continues with an empty name. *Repaired:* `mktemp` refusing at exit 2, plus a `#listing-complete` sentinel written last and required back, since `mktemp` says nothing about a write that fails partway; the honest zero still passes, writing that line alone. Control **19 -> 25 legs**, both refusals planted and lifted, two mutations bitten -- with `mktemp` removed the sentinel still caught it, so the checks are layered. GREEN. *Not taken:* the other ten refuse at creation and none requires the write back, so a filesystem filling mid-walk understates all ten in silence. *Recovered:* this round was written, proven and cut mid-send; `stash_record` named it in the dead-letter box and the next lap landed it. **BOOKED.**
