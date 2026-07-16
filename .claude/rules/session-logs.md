# Session Logs

At the end of **every** response — before finishing the turn — write a session log to `session-logs/`. The log captures the step-by-step reasoning followed before and during any prose writing, repository update, or code implementation, together with the changes made. It is a record kept for years.

## Format — Bron (living law)

**New logs are `.bron`**, not Markdown. Bron carries immutable values at seams (key-value, one field per line, `#` comments, no quotes, no braces). See `active-designing/yonder/20260621-063912_bron-notation.md` and counsel `20260707-222500`.

Historical Markdown logs live under `session-logs/archive/YYYYMMDD/` (folded by day). Do not create new `.md` session logs.

## Filename

`YYYYMMDD-HHMMSS_short-slug.bron` — hyphen stamp in the filename; body field `stamp YYYYMMDD.HHMMSS` (dot form).

**No countdown prefix** (`99999_`, etc.) — retired. One clock only.

Full naming law: `context/specs/20260627-102012_one-clock-naming-law.md` (extension is `.bron` for this stream). Files sort ascending by stamp; the living index in `session-logs/README.md` reads newest first.

When two logs share a second, add `_short-slug` from `title` (or from `prompt` when titles match). Derive a missing stamp from the file's first-commit date per the naming law.

## Index

After each new log, prepend a newest-first row to `session-logs/README.md`: stamp, linked title (`.bron` path), and one line of meaning drawn from `title` / `obs`.

Batch hygiene for **archived Markdown** only: `rye run tools/align_session_logs.rye`. Living Bron logs are indexed by hand (or a future Bron-aware aligner).

## Contents (Bron fields)

Minimum shape (`format session-log-v1`):

```bron
format session-log-v1
stamp YYYYMMDD.HHMMSS
editor Cursor
model Cursor Sonnet 5 1M Medium
voice Riyo
host macOS 26.6 arm64 (Apple M2) — see context/specs/20260713-211800_local-host-system-hardware-anonymized.md
title short title
prompt what Keaton asked
think step of reasoning
think another step
obs observation or trade-off
file path why-one-line
recommend keep-going|check-in what and why
```

- **editor** / **model** / **voice** — which editor and model produced this log. The standing voice is **Riyo** (Quin retired to `context/archive/` `20260715.192400`, following Reya 2 and Rio 3 before it); record `voice Riyo` on new logs, and never rewrite the voice on earlier dated logs. On this local macOS clone (`~/urbit`), the **current model is `Cursor Sonnet 5 1M Medium`** (switched `20260714.045901`; the day's model arc so far: Fable 5 1M Max → Opus 4.8 1M Max (safety-filter auto-switch) → Fable 5 1M Max → Sonnet 5 1M Medium). Record the model that actually produced each log, verbatim; earlier dated logs keep whatever they recorded (`Fable 5 1M Max`, `Opus 4.8 1M Max`, `Cursor Sonnet 5 1M Medium`, or the prior Linux-host `Cursor Grok 4.5`) and are never rewritten. The single source of truth for "current model on this clone" is `GLOW_PROFILE.bron`'s `model` field.
- **host** — optional; names the editor/OS/chip combination for this specific machine, anonymized (no serial, hardware UUID, hostname, or username — see `context/specs/20260713-211800_local-host-system-hardware-anonymized.md` for what stays out and why). Omit on hosts where this has never mattered; add it wherever a log's meaning depends on knowing which machine produced it (a sandbox-adaptation session, a hardware-specific witness).
- **think** — repeatable; step-by-step reasoning.
- **obs** — decisions and trade-offs.
- **file** — repeatable; `path` then why.
- **recommend** — one close line: `keep-going …` when mechanical and policy-written; `check-in …` when seams, Rishi/value-model, unruled design, or horizon facts.

**Stamp timezone, on this local clone.** `context/specs/20260627-102012_one-clock-naming-law.md` names no timezone, and "Stamps come from Kaeden, verbatim" still governs. On this specific macOS clone, Kaeden's clock is Pacific Time (Reno, NV — PDT in summer, PST in winter), seated explicitly in `context/specs/20260713-201910_pacific-time-local-clone-convention.md`. Existing dated stamps from other hosts are never rewritten to match; this note governs stamps written **from here forward** on this clone only.

## Archive fold

Prior (and closed) days' logs live under `session-logs/archive/YYYYMMDD/`. **Preview:** `rishi/bin/rishi run tools/session_logs_archive_preview.rish`. **Fold:** `rishi/bin/rishi run tools/session_logs_archive.rish` (today Markdown-era). Extend the fold for `.bron` when a day closes on Bron logs. Run fold on Kaeden's word.

Bron session logs prefer `product_nib` · `suite_nib` · `git_nib` (or `nib <hash>`) over legacy `tip` fields.

## Spirit

Write it plainly and honestly, in Radiant Style, so a future self or another agent can follow the work home. **Commit the log in the same commit as the work it records** whenever possible; a log-only follow-up commit is a last resort.
