# REDS shelf -- a count with no names, in the roster's own scan

**Language:** EN
**Style:** Gauge, Meter setting (see [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md))
**Status:** Shelf -- immutable once written
**Voice:** Kyri
**Folded:** `20260908.005322`
**Rows:** `%600`

One row, folded on the lap it was booked. The roster scan carried six named lists and one bare
count, and the bare one was the only reading it gates on -- so the guard that reds most often was
the guard a lap could act on least. `%592` taught the sentence one instrument over; this row is
the same sentence arriving where the gate lives, and the repair that answered it in one line.


**REDS %600 (`20260908.005322`) -- the one gated ratchet in the roster scan printed a count and no name, so two laps in a row hand-walked 246 records with awk to find the guard that arrived.** *What went wrong:* `tools/fixtures/s/standing_equipment_scan.sh` reports `guards_undeclared_tier=N` against a ceiling, and that reading is the roster's only gated ratchet -- yet it was the one class in the scan that printed no rows. Every neighbour already named its own: `missing:`, `half_written:`, `unknown_tier:`, `unknown_host:`, `unrostered:`, `red:`. The cold open read `63` against `62`, which reds the roster for every ship on the pier, and the only way to learn WHICH guard had arrived undeclared was to re-parse `construction/standing-equipment.kyri` by hand. That happened on `20260907`, when the answer was `log_file_claim`, and again this lap, when it was `tool_letter_room`. *What caught it:* reading the scan's own report block after the ratchet reddened a second time, and noticing that the class carrying the gate was the only class without a list. *What it taught:* **a count with no names is the second half of a guard nobody runs** -- `%592`'s own sentence, one instrument over, and it reached a scan whose every other reading already knew it. The repair records each undeclared guard against its own `seated` stamp and prints the newest five, because the repairable question is never *which sixty-three* but *which one arrived*, and the newest is the one whose author still holds the context. Bounded at five and printed only when the count is above zero, since a list that prints on a clean roster reads as a finding. `tool_letter_room` then cost one line: its seater had written *tier lap because the fault is born with a FILE* in a **comment** and left the **field** empty, so the decision existed and the meter could not see it -- the same braid the session-log `rota` field was seated to cut, where prose naming a thing cannot be counted. Four control legs prove the naming both ways on a planted roster: the silent guard is named with its stamp, the declared guard beside it is absent from the list, the count stays the whole population, and a clean roster names nobody. **CLOSED**
