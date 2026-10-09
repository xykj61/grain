# Bakery -- a capture that failed was reading as a capture that landed

**Shelved whole** from construction/ITINERARY.md on `20261009.164312` (writer-sheds rule, the-writer-sheds.md).

**BAKERY -- A CAPTURE THAT FAILED WAS READING AS A CAPTURE THAT LANDED.**
`capture_evidence` in `tools/fixtures/s/shell_portable.sh` closed on `[ -f "$dst" ]`, and a shell
redirect creates the destination before the producer runs -- so every way the producer can fail left
a file standing and the helper answering yes. Measured on metal before the repair: with `cat` absent
from PATH, `rc=0 bytes=0`; with `head` refusing, `rc=0` and the three header lines this helper exists
to keep were gone. Three readings hold it now -- the producer's own status, the destination's byte
count, and its line count -- and a failed capture removes the stub, since absence says *the answer
was lost* where a zero-byte file says *the guard answered nothing*. Return 3 names a copy that did
not land, apart from 1 and 2. The caller in `standing_equipment_run.sh` is untouched: it already
removed the file, said the answer was lost rather than read, and counted the guard `unrun`.
`shell_portable_control.sh` stands at **81 legs**, 0 failing, five plants lifted, and the two
bounded-branch readings were each made load-bearing by measurement -- with the header plant alone,
dropping either left every leg green, so one leg plants a producer that emits nothing at status zero
and one a producer that answers whole and then refuses. `shell_dialect_witness` GREEN on metal, its
pinned count 71 to 81; `shell_dialect_touch` and `instrument_absence` GREEN beside it.
