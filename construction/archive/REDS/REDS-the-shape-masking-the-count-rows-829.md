# REDS -- the shape masking the count

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a scan's one-verdict-word answer hid a second, larger failing shape
**Folded:** `20261002.004700` from [`../REDS.md`](../../REDS.md)

One row, folded to hold the pin under its bound. It teaches that a scan answering in one verdict
word can hide a second failure behind a louder one for as long as the louder one stands -- the only
way to find it is to fix the louder one and read what is left underneath.

**REDS %829 (`20261001.143449`) -- the louder shape masked a larger one underneath it.** *What went wrong:* `tools/s/shim_reason_witness.rish` reads `tools/fixtures/s/shim_reason_scan.sh`'s four shapes in one verdict word, and `verdict=rostered_late_say` was the answer printed while a second shape, `unsaid_rostered`, already stood at 984 against a ceiling of 903 -- 81 over, before today's repair touched anything. *What caught it:* fixing the eight rostered late-say bindings named in the row's own prior readings (`fascia_metric_v0.rish`, the five `gen_*_fund_prep.rish` witnesses, and `process_fanout_witness.rish`'s two bindings) moved each `say` above its first assert, and the scan's verdict then fell through to the shape standing beneath it. *What it taught:* a scan that answers in one verdict word can hide a second failure behind a louder one for as long as the louder one stands, and the only way to find it is to fix the louder one and read what is left. **OPEN** -- the eight late-say bindings are repaired and GREEN; `unsaid_rostered=984` against `unsaid_rostered_ceiling=903` is a different, much larger body of work (naming a `say` for roughly eighty rostered bindings that currently report nothing of their run), named here rather than attempted in the same lap. The check at Voice v9 that opened this ledger found six reds written into the tree and twenty owned out loud. *Closed* (`20261001.200053`, commit `9b8879d432`): the scan now credits a guarded say and a bare presence test; `unsaid_rostered=869` under the unchanged ceiling `903`; `shim_reason_witness.rish` answers `verdict=ok`. **CLOSED.**
