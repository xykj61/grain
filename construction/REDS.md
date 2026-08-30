# REDS -- the ledger of what we got wrong

**Language:** EN
**Stamp:** living ledger (born `20260729.222000`) - refreshed `20260801.162056` (self-work arc - rows 58-60 accreted)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living pin -- one row per red, oldest first
**Key:** each row's identity is its one-clock **stamp**; the `%N` is a view allocated by the anointed remote `xy` (`.claude/rules/derived-spine.md`, seated `20260827.181605`). A published number never moves. Book the next with `sh tools/fixtures/r/reds_spine_derive_scan.sh --next`. **Three status words** (door B, `20260829`, Keaton's word): **OPEN** is a live defect and stays on the pin; **BOOKED** means the instances stand repaired and the remainder is a ratchet, a seat, or a booked lap, and such a row may fold; **CLOSED** closed on a witness. The last bold marker decides, read one way by `reds_fold.sh` and both status scans.
**Bound:** under `living_pin_max_bytes` (24576)
**Room:** Checkable -- every row names where it was caught

*A red owned in conversation is a memory. A red recorded here is a proof. This ledger exists because a check at Voice v9 found six reds written into the tree and twenty owned out loud -- so fourteen lessons were living only in a chat window that closes.*

---

## Why this file, and what belongs in it

Own-reds-immediately has been a house law for a long time, and it worked: reds were named the moment they were found, out loud, without excuse. What the law never said is **where**. So the ones that happened to land inside a witness header or a spec erratum survived, and the ones that happened in a sentence did not.

Three fields per row, because a red with fewer teaches nothing:

- **What went wrong** -- stated plainly, no softening.
- **What caught it** -- a compiler, a stopwatch, a guard, a second look. Never "I noticed."
- **What it taught** -- the transferable rule, which is the only part that outlives the incident.

A red enters this ledger when it is found. Rows are never edited or removed; a later correction accretes as a new row pointing back.

---

## Voice Chapter - opened `20260729`

| # | What went wrong | What caught it | What it taught |
|---|---|---|---|

**Rows: 348 - in the tree before the ledger: 6 - recovered by opening it: 14 - added under the reds-first law: 328** -- counted from the ledger and its archives on `20260829.223821` by `tools/gen/chapter/reds_ledger_monotone_witness.rish`, which reads the spine off disk rather than from a list, so the tally moves with a measurement rather than with a memory, since a tally repeated from memory drifts (REDS %93). Only the first number is measured; the other three are the opening census of `20260729` -- 6 already written into the tree and 14 recovered out of chat windows, 20 together -- and the remainder, which is every row added since. That remainder read 84 for a long while and had stopped moving as rows accreted, so the three no longer summed to the total. It is derived now (rows minus the opening 20) rather than recited, which is REDS %110's own lesson applied to the ledger's own headline. The whole fold recital -- which rows folded, on what stamp, and onto which shelf -- reads at [`archive/REDS-fold-recital.md`](archive/REDS-fold-recital.md); it had grown to 5,999 bytes inside this headline, longer than the rest of this page's prose and parsed by nothing. Every number from 1 to 348 is used; the elder rows wear `#` and the living ones wear `%` (`.claude/rules/git-signing.md`).

**REDS %348 (`20260829.222718`) -- the hook's fixed interpreter spelling crashed two jailed loops from one line.** *What went wrong:* `tools/hooks/pre-commit` invoked its pin scan as a literal `/bin/sh` -- itself the `20260828` repair for a jail whose PATH `sh` was the macOS selector wrapper -- and the `20260829` Codex jail denies that wrapper's own read of `/private/var/select/sh`, leaving it half-alive: the scan's opening substitution-plus-cd garbled, the wall refused every commit, Mystery's finished lap died at the signer, and Mind reached custody with a proven candidate stranded in `stash@{0}`. *What caught it:* both supervisors refusing honestly -- and Mind proving the repair from both sides before parking: the same scan under explicit bash answers `verdict=ok` inside the same jail. *What it taught:* **an interpreter is an environment fact, so a wall that needs one probes at run time on the exact shape that fails** -- a fixed spelling repairs one bench by breaking the next, and an honest probe is the failing operation itself (a substitution, a CDPATH-clean cd, a pwd), never a no-op. *Repaired (`20260829.222718`):* the hook probes `/bin/bash`, `bash`, `/bin/sh` in order and runs both scan call sites under the winner; proven by `tools/p/pin_bound_touch_witness.rish` -- 36 cases arming the repaired hook in real pens -- and by both interpreters answering the live scan identically on this bench. **CLOSED.**

**REDS %347 (`20260829.212731`) -- a line bound sized to the wrong verb refused a valid maximum crop.** *What went wrong:* `image/photo_edits.rye` declared `per_line_bound = 48` with a comment sizing the longest line to `adjust -255 65536 65536` -- but crop's four u32 fields at their maxima render `crop 4294967295 4294967295 4294967295 4294967295` plus newline at exactly **49 bytes** (4 + 1 + 4x10 + 3 + 1), so a fully valid edit overflowed the bound its own module promised to hold, and the record capacity read 3,094 where the true arithmetic is 3,158. *What caught it:* **Mind's supervised lap, from a bench that could not touch Rye** -- it measured 48- and 49-byte crop controls, named the mismatch a tree defect against its two machine limits, parked the ruling as custody, and handed the repair across the orbit rule; the second cross-bench catch of the day after the surface-claims exact-length drift. *What it taught:* **a bound's said-why must name the worst case, not a familiar case** -- the comment's example was honest and irrelevant, and every reviewer since read the example instead of doing the arithmetic; a said-why that shows the worst-case computation is a bound a reader can check in their head. *Repaired (`20260829.212731`):* `per_line_bound` widens to 49 on the granted word with the crop worst case computed in the comment, `max_edits_bytes` follows by derivation, and `tools/h/hunk_photo_edits_witness.rish` answers GREEN over the widened bound -- render-parse fixed points, refusals, and the whole verb vocabulary standing. **CLOSED.**

**REDS %346 (`20260829.192321`) -- the seat that swept a vocabulary wrote its retired word into a commit subject the same day.** *What went wrong:* commit `fa34b7a43` -- the interpreter wall raise -- carried *child-stream* in its subject, twice in its body, and in fresh comments in `rishi/src/main.rye` and `tools/l/chatgpt-mind.rish`, written by the seat that had carried the dependent molt and seated its rules. The word arrived by inheritance: the elder comment under edit said *child-stream*, and the editor propagated it into new living prose instead of molting it on touch. *What caught it:* Keaton reading the pushed commit on GitHub -- the second commit-read catch of the day, after the file-count read that caught %345. *What it taught:* **a retired word inherited from the text under edit slips past its own banner because it arrives as quotation** -- the sweep-on-touch duty covers the words a lap copies forward, not only the words it invents, and the moment of inheritance is exactly when the banner is weakest. *Repaired (`20260829.192321`):* eight living comment hits swept across the two files (identifiers and `std.process` seam names keep Zig's words; directory-child refusal strings keep their different sense; the one behavior string changed rides a rebuild), and the message molted by the seated breach pattern -- checkpoint `be976e4227`, a message-only rewrite over `fa34b7a43~1..HEAD` re-signing every commit with the tree held byte-identical, both remotes force-pushed on Keaton's word naming the commit. **CLOSED at booking.**

**REDS %345 (`20260829.163628`) -- a hook-refusal retry dropped its pathspec, and the commit swept a peer's staged lap out to both remotes.** *What went wrong:* commit `fa34b7a43` was built as a two-file change (the interpreter wall raise in `rishi/src/main.rye` and the harness wall in `tools/l/chatgpt-mind.rish`), staged with `git add`, and refused twice by the commit-msg hook; the reworded retry was typed WITHOUT the `-- <paths>` pathspec, and in the add-to-commit window the peer seat had staged its own ten-file lap -- so the commit took 12 files and the push carried the peer's work to both remotes under this seat's message. The peer's work landed whole; its own commit message never got to tell its story. This is the %291 index-sweep class recurring in its fourth spelling of the day (a peer's commit taking 3 of 16 staged paths; an autostash destaging a peer five times; and now a bare retry sweeping inward), done by the seat that diagnosed the other three. *What caught it:* reading the commit's file count against the change just built -- 12 where 2 were staged -- the exact habit %291's amendment seated this morning, which is why it was caught in the same minute it shipped. *What it taught:* **on a shared index the pathspec goes on EVERY commit, retries included** -- a refusal-and-retype is a fresh commit crossing the shared window again, and the discipline that guarded the first attempt guards nothing if the retry drops it. The deeper form: a safety habit attached to composing a command detaches when the command is recomposed, so the habit belongs on the SEND, not the draft. *Repaired (`20260829.163628`):* the peer was messaged within the minute with the full account and the open offer of an `--allow-empty` commit to carry its intended message; nothing was rewritten or force-pushed (the work is correct in content, wrong only in attribution, and a history rewrite for attribution is a deep debride nobody asked for). This row is the first booked into the pin the door-B drain healed, on the day the ledger could finally hold it. **CLOSED at booking** -- the remainder is the habit, which is this row's own teaching.

---

## What the pattern says

Read down the *what caught it* column and almost nothing was caught by thinking harder. A compiler, a stopwatch, a file-type check, a guard's first run, seven witnesses at once, a pack catching its own author. **The machine caught nineteen of twenty.**

That is not a complaint about judgment; it is the argument for the whole apparatus. Witnesses exist because the author is the last person able to see their own gap, and this column is twenty lines of evidence for that claim rather than one more assertion of it.

Read down the *what it taught* column and four rules recur: **measure before claiming**, **scope before shipping**, **fixture rather than remember**, and **narrow the objection**. Those four have paid for themselves repeatedly in a single sitting.

---

*May every red find this page on the day it happens. May the lesson outlive the incident. And may the count of what we got wrong be as witnessed as the count of what we got right.*

*The `autoproject96` -> `debrided` standfast folded to [`archive/REDS-the-organization-rename-standfast.md`](archive/REDS-the-organization-rename-standfast.md) on `20260823.204456` as row %175 carried the living pin past its bound. **It still stands** -- the living rename is done, and the deep debride of 11 commit-message occurrences awaits Keaton's word.*

*Elder rows fold onto shelves under [`archive/`](archive/) as the pin nears its 24,576-byte bound, and the whole recital -- which rows, on what stamp, onto which shelf -- reads at [`archive/REDS-fold-recital.md`](archive/REDS-fold-recital.md). One note stands here rather than one per fold, because a note per fold grows this pin by exactly what folding shrinks -- %232's own lesson, turned on the note itself. **The pin keeps what is open**, so a row still reading OPEN stays flat however old it is.*




