# Session Logs

At the end of **every** response -- before finishing the turn -- write a session log to `session-logs/`. The log captures the step-by-step reasoning followed before and during any prose writing, repository update, or code implementation, together with the changes made. It is a record kept for years.

## Format -- Kyri (living law; molted from Bron `20260810`)

**New logs are `.kyri`** -- the notation formerly named **Bron**, molted to Kyri on Keaton's word (`20260810`): the same immutable-value format (key-value, one field per line, `#` comments, no quotes, no braces), a warmer name from the favorites list. Spec: `active-designing/yonder/20260621-063912_bron-notation.md` (bannered as the Kyri notation; kept readable) and counsel `20260707-222500`. The **2,163 existing `.bron` logs are never renamed** -- the one-clock law and accrete-never-break protect every dated artifact, and tools read both extensions. A full sweep of the remaining living Bron references to Kyri, and teaching the fold/align tools `.kyri`, follow as their own rounds.

Historical Markdown logs live under `session-logs/date/YYYYMMDD/` (folded by day). Do not create new `.md` session logs.

## Filename

`YYYYMMDD-HHMMSS_short-sprig.kyri` -- hyphen stamp in the filename; body field `stamp YYYYMMDD.HHMMSS` (dot form). New logs are `.kyri` (the notation molted from Bron `20260810`); the `.bron` logs already on disk are never renamed and tools read both.

**No countdown prefix** (`99999_`, etc.) -- retired. One clock only.

Full naming law: `context/specs/20260627-102012_one-clock-naming-law.md` (extension is `.bron` for this stream). Files sort ascending by stamp; the living index in `session-logs/README.md` reads newest first.

When two logs share a second, add `_short-sprig` from `title` (or from `prompt` when titles match). Derive a missing stamp from the file's first-commit date per the naming law.

## Index

After each new log, prepend a newest-first row to `session-logs/README.md` **directly below the table's delimiter row**: stamp, linked title, and one line of meaning drawn from `title` / `obs`. The title and the delimiter both live at the top, and a row goes under them, so the table keeps rendering and the title keeps its place. Writing above them costs both, and on `20260824` both were being paid: the title stood at line 1,881 beneath 1,880 rows, and 1,658 pipe rows stood above the delimiter, which GitHub-Flavored Markdown reads as plain text with pipes in it (REDS %182).

**A row points; it does not summarise.** The log is the record and the index is the way in, so an index row stays **at or under 192 bytes** -- a stamp, a linked title, and one clause. That number is the pin's own arithmetic: a row costs ~123 bytes before it says anything, the pin's prose takes ~2,100, and 192 leaves room for ~116 rows inside the 24,576 the page declares. Rows once ran to **2,223 bytes** apiece, which made the index a second copy of the logs (REDS %204, resolved on Keaton's word `20260824`). Gated by `rishi/bin/rishi run tools/in/index_row_bound_witness.rish`; shelved rows keep every byte they wrote. **This one pin carries its own byte bound** -- `living_pin_max_bytes[session-logs/README.md] = 57344`, which is `256 x 192` rows plus 8,192 for prose, so the index can hold a full room. Every other pin keeps 24,576 (REDS %205).

**The index folds with the room.** A day's rows move onto `session-logs/date/README-index-YYYYMMDD.md` the moment that day's logs fold, so the living pin holds exactly the rows whose logs are still flat. One tool does both:

```
rye run tools/rye/session_logs_archive.rye index-preview   # count, change nothing
rye run tools/rye/session_logs_archive.rye index-fold      # shelve the closed days
```

`rishi/bin/rishi run tools/i/index_fold_witness.rish` gates this room at zero stale rows, and since `20260824.172000` it gates all five folding rooms -- the ratchet reads zero. The byte bound then follows from the fold **and the row bound together**: folding alone left this pin 5,421 over, since the rows were paragraphs (REDS %204). Shelves are listed in `session-logs/SEASONS.md` and are immutable once written.

Batch hygiene for **archived Markdown** only: `rye run tools/rye/align_session_logs.rye`. Living Kyri logs are indexed by hand (or a future Kyri-aware aligner).

## Contents (Bron fields)

Minimum shape (`format session-log-v1`):

```kyri
format session-log-v1
stamp YYYYMMDD.HHMMSS
editor Claude Code
model claude-opus-5
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title short title
prompt what Keaton asked
think step of reasoning
think another step
obs observation or trade-off
loom metric=value ... -- optional; Loom / performance metrics for the round (see below)
file path why-one-line
recommend keep-going|check-in what and why
```

- **editor** / **model** / **voice** -- which editor and model produced this log. The standing writing voice is **Kyri** (molted from Riyo `20260810` -- Keaton's word; Riyo had been seated `20260729.205200`; full identity `context/KYRI.md`); record `voice Kyri` on new logs, and never rewrite the voice on earlier dated logs (including logs that correctly recorded `voice Riyo` or `voice Quin` while each held the writing seat). **Quin** keeps the fifth OS variant and the inference Q-vane (`context/QUIN.md`). **Per host:** the macOS clone's recent arc was Fable 5 1M Max -> Opus 4.8 1M Max -> Sonnet 5 1M Medium; **this pier host, from `20260823.064454` on Keaton's word, is Claude Code (`claude-opus-5`) at **max** effort on the Vultr SEA NixOS VPS ai-jail, with the Daylight DC-1 as the hand device** (it ran `claude-opus-4-8` from `20260815.191048` until that word) (the earlier Framework 16 / Cursor Grok 4.5 note is retired for this clone). Record the model that actually produced each log, verbatim. Do not rewrite correctly attributed dated logs. When a `model` field was recorded wrong, Keaton may ask to correct those specific lines to the truth -- that is a factual fix, not a style rewrite. The single source of truth for "current model on this clone" is `GLOW_PROFILE.bron`'s `model` field.
- **host** -- optional; names the editor/OS/chip combination for this specific machine, anonymized (no serial, hardware UUID, hostname, or username -- see `context/specs/20260713-211800_local-host-system-hardware-anonymized.md` for what stays out and why). Omit on hosts where this has never mattered; add it wherever a log's meaning depends on knowing which machine produced it (a sandbox-adaptation session, a hardware-specific witness).
- **think** -- repeatable; step-by-step reasoning.
- **obs** -- decisions and trade-offs.
- **loom** -- optional, repeatable; **Loom / performance metrics** captured when the round touched a measured path -- **Loom**, **Caravan**, **Tally**, the **Shuttle** (the io_uring horizon), a witness whose wall-time matters, or any hot loop where throughput or allocation is load-bearing. **Auto-add it whenever the round produced a measurement**, so performance is recorded as it happens rather than reconstructed later. Write plain `key=value` pairs, one metric family per `loom` line, from real measurement (never guessed): e.g. `loom witness=mandate_store_witness wall_ms=42 records=64 blob_bytes=196`, or `loom caravan=subscribe_poll ops=1000 wall_ms=310 allocs=0`. Bound each number to what was actually run; when nothing was measured this round, omit the field entirely (measurement beats memory -- an absent `loom` is honest, a fabricated one is a red). The metric names are free-form yet stable within a module, so a future Loom-aware reader can trend them across logs.
- **file** -- repeatable; `path` then why.
- **recommend** -- one close line: `keep-going ...` when mechanical and policy-written; `check-in ...` when seams, Rishi/value-model, unruled design, or horizon facts.

**Stamp timezone, per host -- one CLOCK, not one hand.** The invariant is a single canonical clock (later is always larger). Any agent may produce a stamp when it reads that clock; Cursor's automated stamping is welcome. On this Framework / cloud bench the zone is **`America/New_York`** by name (`context/specs/20260627-102012_one-clock-naming-law.md` addendum `20260724.205009` - `context/specs/20260722-125845_edt-framework-host-convention.md`). The macOS clone keeps Pacific (`context/specs/20260713-201910_pacific-time-local-clone-convention.md`). A zone change is itself a seated decision. Existing dated stamps are never rewritten. Witness: `tools/o/one_clock_witness.rish` (shape - mono - zone - blocking). `GLOW_PROFILE.bron`'s `timezone` field is the machine-local pointer.

## Archive fold

Prior (and closed) days' logs live under `session-logs/date/YYYYMMDD/` -- the destination molted from `archive/` on `20260821.161758` with the mark law ([`stamp-and-name.md`](stamp-and-name.md)), since ORGANIZING defines archive as finished-and-historical while a log from nine days ago is the live record. **Preview:** `rishi/bin/rishi run tools/s/session_logs_archive_preview.rish`. **Fold:** `rishi/bin/rishi run tools/s/session_logs_archive.rish` -- folds `.kyri`, `.bron`, and historical `.md`; today's stamp stays flat, and the index is repointed in the same pass. Run fold on Keaton's word.

**The room is bounded at 256 flat files**, enforced by `rishi/bin/rishi run tools/r/room_bound_witness.rish` -- because at roughly a hundred and eight logs a day an emptied room refills past GitHub's 1,000-entry listing cap in nine days, so the bound is the fix and the fold is only how it is met. **A stale reference is resolved, never rewritten:** `rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference> [<citing-file>]`.

Bron session logs prefer `product_nib` - `suite_nib` - `git_nib` (or `nib <hash>`) over legacy `tip` fields.

## Spirit

Write it plainly and honestly, at Gauge's **Meter** setting (`.claude/rules/gauge-style.md`), so a future self or another agent can follow the work home. **Commit the log in the same commit as the work it records** whenever possible; a log-only follow-up commit is a last resort.
