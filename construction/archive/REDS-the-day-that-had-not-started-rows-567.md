# REDS -- row %567, folded from the living pin

**Folded:** `20260907.114500` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*An empty subject and an absent subject are two different readings, and a census that cannot tell
them apart reds on the calendar rather than on the tree.*

The row stands here exactly as it was written. A closed row leaves the living pin so the pin stays
the length a reader will actually read; the lesson travels forward in the tool the round repaired --
`tools/fixtures/r/rota_declared_scan.sh`, which answers from the newest shelf that holds a corpus
and names which day answered -- and the row itself stays one click away.

---


**REDS %567 (`20260907.114500`) -- a census whose subject was "today" refused every night at midnight, and a withheld receipt made eight ships pay a full cold pass for a clock fact.** *What went wrong:* `tools/fixtures/r/rota_declared_scan.sh` took its subject from `TZ=America/New_York date +%Y%m%d` and read that shelf with `git ls-files`, which reads the INDEX -- so between 00:00 and the day's first COMMITTED log the corpus was empty and the scan exited 2. It was right about the corpus (a corpus of zero is a red, never a reading -- `%170`) and wrong about the subject: the day had not gone missing, it had not started. *What caught it:* the roster's own prose, which recorded the state at 00:12 on `20260907` -- `guards_red=2` on a first cold pass of the day, this guard plus `standing_equipment` reading its own roster's red -- and named the cost without closing it. A red guard withholds the roster receipt, so `--scoped` refuses and every ship pays a FULL cold pass; daily, fleet-wide, and healed an hour later by the day's first commit, which is worse than a standing red because it looks like somebody's fault and then vanishes. *The repair:* the open day falls back to the newest shelf that HOLDS tracked logs, walking shelf NAMES on disk in descending order so no date arithmetic enters, bounded at seven shelves so a genuinely abandoned tree still refuses rather than reporting a fortnight-old census as today's; `day_source=open|fallback|asked` is printed beside `day=`, so a reader tells the two readings apart. **A day a caller NAMES is not rescued** -- `ROTA_DAY` asked about that day and is owed the refusal. Control 11 behaviors to 18, the seven new ones covering both halves of the midnight state (no shelf at all, and a shelf whose logs are still untracked), the named-day refusal, and the bound. *What it taught:* **an empty subject and an absent subject are two readings, and a guard that cannot tell them apart reds on the calendar.** `%170` taught that zero is never a reading; the half it left open is that the right answer to an empty corpus is sometimes a different corpus rather than a refusal. **CLOSED** -- `rishi/bin/rishi run tools/r/rota_declared_witness.rish` GREEN on metal.
