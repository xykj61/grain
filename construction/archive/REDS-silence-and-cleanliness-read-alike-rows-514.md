# REDS shelf -- silence and cleanliness read alike, row %514

**Language:** EN
**Stamp:** `20260906.211015`
**Status:** Shelf -- immutable once written
**Rows:** `%514` -- folded from [`../REDS.md`](../REDS.md) on `20260906.211120`
**Voice:** Kyri
**Kin:** the first firing of this lantern, in a third meter, is recorded in the
[`133344` landed-accounts shelf](20260906-133344_itinerary-landed-accounts.md).

Two shipped meters ran their counting awk with stderr dropped and then read an empty answer as a
zero. That idiom makes a refused instrument and a spotless tree print the same line -- and both
meters sat exactly AT their ceilings, which is where a silent zero reads as the largest sweep
either had ever recorded rather than as a fault.

**The lantern had already fired once, in my own hand.** `tools/fixtures/a/ascii_document_scan.sh`
carried the identical shape in its first draft, answered a clean zero for all 5,529 tracked
documents, and was repaired and controlled on `20260906.133800`. That lap named these two meters as
a sibling find and declined to reach for them, since they belong to another seat's family and were
green. Green was the symptom.

**The repair is a status read, not a wider gate.** The awk moves into a function whose exit status
the caller examines, and three answers are told apart rather than collapsed: an **absent** path is
skipped and counted, never fatal, because `git ls-files` reads the index and a rename staged
mid-rebase is ordinary; a **refused** read is fatal and names the path; a **non-numeric** answer is
refused too, since `END { print n + 0 }` prints a number whenever the program runs at all.

**Both directions are proven against the elder scans themselves.** The pre-repair files were
restored out of `HEAD` into a throwaway pen and read by the very same controls, so each new leg is
shown failing before it is shown passing -- a refusal proven only in the passing direction cannot
be told from a bypass.

---


**REDS %514 (`20260906.211015`) -- two shipped meters ran their awk with stderr dropped and read an empty answer as a clean zero, so a refused instrument and a spotless tree printed the same line -- and both meters sat AT their ceilings, where a silent zero reads as the largest sweep either ever recorded.** *What went wrong:* `tools/fixtures/s/shell_comment_ascii_scan.sh` and `tools/fixtures/r/rye_comment_ascii_scan.sh` each ran `n=$(LC_ALL=C awk ... "$f" 2>/dev/null)` and then `[ -z "$n" ] && n=0`. The redirect discarded awk's complaint, the assignment's exit status was never examined, and the empty string became a zero -- so a file the meter could not open, and a whole awk program awk refused to parse, both counted as clean prose. *What caught it:* my own previous lap named it as a sibling find and did not take it (`20260906.133800`): `tools/fixtures/a/ascii_document_scan.sh` carried the identical fault in its first draft, answered a clean zero for all 5,529 documents, and was repaired and controlled -- so this is the same lantern firing a second and third time, in two meters that ship. *Proven on metal, both directions, in throwaway git repositories:* against the repaired scans every leg reads the good answer; against the pre-repair scans, restored from `HEAD` into a pen and read by the very same controls, every leg reads the failing one -- `broken_instrument_named=no`, `broken_instrument_refuses=no` (a perfect `under_ceiling=yes` over every tracked source it never opened), `unreadable_verdict=no -- counted a zero for a file it could not open`, and `absent_counted=no`. GNU Awk 5.4.1 exits **1** on a syntax error and **2** on a file it cannot open, so the status was there to read the whole time. *An erratum inside the finding, worth the row on its own:* my first plant put a comment between a trailing `||` and its continuing newline -- the exact shape that broke the document scan -- and I read the resulting `files=0 chars=0` as an awk refusal. It was not. This awk accepts that program; `line = $0 || 0` merely makes `line` a boolean, so no line ever begins with `#` and the meter honestly counts nothing. Same symptom, different mechanism, and the second plant -- an unclosed `if (`, a syntax error in every dialect -- is what actually proves the leg. *What it taught:* **a guard that never reads its instrument's status cannot tell silence from cleanliness**, and the two are byte-identical exactly when the meter sits at its ceiling and a green is most wanted. *Repaired:* the awk moves into a `count_file()` function whose status is read, with three answers told apart -- **absent** is skipped and COUNTED, never fatal, since `git ls-files` reads the index and a rename staged mid-rebase is ordinary; **refused** is fatal and names the path; a **non-numeric** answer is refused too, since `END { print n + 0 }` prints a number whenever the program runs at all. Both meters now print `instrument=ok` and `opened=`/`absent=` beside the count, and the witness asserts `instrument=ok` on each living reading -- the one line that tells a meter which opened nothing from a meter which opened everything. Controls **15 -> 18** and **9 -> 12** legs, each asserted; the closing count is read off the pen rather than recited (`%110`). *Readings unmoved by the repair, which is the point:* shell `files=153 chars=505 opened=3159`, Rye `files=313 chars=3793 opened=1717`. *Reported, not taken:* **12 of 244** tracked `*_scan.sh` run awk with stderr dropped; two are these, and the remaining **10** span five lanes -- `announced_length`, `caravan_ladder_reach`, `declared_ceiling`, `dep_crawl`, `fleet_key_locality`, `foundations_link`, `pond_enclosure_ephemeral`, `radiant_negation`, `rye_harness_roster`, `shipped_binary_claim`. Each wants its own witness run rather than a sweep from here. **CLOSED.**
