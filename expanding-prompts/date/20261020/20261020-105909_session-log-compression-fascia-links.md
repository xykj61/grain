# Session log compression, fascia Markdown links, and `.kyri.md` molt-breach

**Stamp:** `20261020.105909`
**Status:** Expanding prompt -- ready to run
**Room:** checkable
**Kin:** `session-logs.md` - `session-log-provenance.md` - `stamp-and-name.md` - `debride.md` - `collaboration.md`

---

## Intent

Three related moves that together make session logs smaller, faster to navigate, and readable in web interfaces.

---

## Move 1 -- Pointer compression for identical log metadata

**The problem.** In a single Claude Code session, every log repeats the same fields: `editor`, `provider`, `product`, `role`, `modality`, `model`, `model_status`, `configured_model`, `voice`, `host`. On a day with 8 logs, that is 8 x ~10 lines = 80 lines of identical text. The fields that change per log are: `stamp`, `title`, `prompt`, `think`, `obs`, `file`, `recommend`, `orbit`, `scope`, `status`.

**The move.** Introduce a `session-header` convention: the **first log of a session** carries the full metadata block. Subsequent logs in the same session carry:

```kyri
format session-log-v1
stamp YYYYMMDD.HHMMSS
session-header YYYYMMDD.HHMMSS_first-log-sprig.kyri
title ...
prompt ...
think ...
```

The `session-header` field is a relative path pointer to the log that holds the shared metadata. A reader follows it once and holds the shared context. When any field CHANGES -- model switches mid-session, host changes, voice shifts -- the log that records the change carries that field directly, overriding the header.

**Override rule.** A field in the pointing log wins over the same field in the header. A reader: load header fields, then apply any local overrides. The result is the full record.

**What this does not do.** It does not break the self-containment of the first log in each session. It does not rewrite existing logs -- this is a forward-only convention. Existing logs without `session-header` are complete, as they always were.

**Tooling needed.** `scribe/reader.rye` needs a `resolve_session_header` step: when the format is `session-log-v1` and a `session-header` field is present, fetch the named file relative to the log's own path, merge fields (local overrides header). The Scribe reader already has the file-fetch shape from `is_session_log`.

**Calfive orbit fit.** Equinox 1 Gemini -- "say the work aloud." Smaller logs are easier to read aloud and share. This is a teaching-phase efficiency.

---

## Move 2 -- Markdown links in kin/fascia fields

**The problem.** Fields like `kin`, `file`, `recommend`, and cross-references in `obs` and `think` carry relative paths as plain text. In a `.kyri` file on GitHub, those paths are not clickable. Navigation requires copy-paste.

**The move.** Where a field's value IS a relative path (or a space-separated list of paths), write it as a Markdown link where the link text equals the path:

```kyri
file [session-logs/date/20261019/20261019-010800_missing-module-gap-composition.kyri](session-logs/date/20261019/20261019-010800_missing-module-gap-composition.kyri)
```

Or for short-form kin lines:

```kyri
kin [session-logs.md](.claude/rules/session-logs.md) - [stamp-and-name.md](.claude/rules/stamp-and-name.md)
```

**Why the link text equals the path.** The `collaboration.md` rule already says "a link makes two promises" -- the visible text promises where it lives, the target promises it opens. Making them identical honors both promises at once and keeps the Kyri notation's plain-text character: a reader who does not render Markdown still sees the path.

**What this does not change.** The Scribe reader parses `file` fields for path extraction. It already strips leading backtick runs and surrounding text. A Markdown link `[path](path)` -- the reader extracts the parenthesized target path. `scribe/reader.rye` needs one update: recognize `[text](path)` shape in field values and extract the `path` part.

**Cost.** Zero to existing logs (forward-only). Scribe reader update is a small parse addition. Immediate value on GitHub.

**Calfive orbit fit.** AMIR / long return -- fascia weave. This is the "seed legitimacy" goal: make the tree navigable from the web door.

---

## Move 3 -- `.kyri.md` extension molt-breach (flagged -- Keaton's explicit word before running)

**The idea.** Change the extension of all `.kyri` session logs (and optionally other `.kyri` files) from `.kyri` to `.kyri.md`. GitHub renders `.kyri.md` as Markdown. The Kyri key-value content renders as plain paragraphs -- which is correct. Markdown is a superset of plain text, so a Kyri file IS valid Markdown. The `[text](path)` links from Move 2 are then live and clickable on GitHub. No code block needed; the notation is just text and renders fine.

**Honest cost assessment.**

- **Working-tree molt**, not necessarily a deep debride. Content does not change, only filenames. No secrets, no personal data, no reason to rewrite history. Existing history stays readable -- dated artifacts keep every word they wrote; only the extension changes on the living working tree going forward.
- **Scale:** `git ls-files 'session-logs/**/*.kyri'` reads **13,364 files**. Every shelf index row (in `README-index-YYYYMMDD.md` files) links to `.kyri` paths -- those need repointing. The fold tools, resolvers, and census tools all pattern-match `.kyri` -- **513 tool files** reference `.kyri` by extension; the subset that need updating is those that match the extension as a literal string in a pattern (not those that just happen to mention a `.kyri` path by name in a comment).
- **Key tool updates needed:** `tools/d/dated_path_resolve.rish`, `tools/d/dated_path_repoint.rish`, `tools/fixtures/d/dated_spelling_scan.sh`, `tools/s/session_logs_archive.rish`, `tools/rye/session_logs_archive.rye`, `tools/i/index_fold_witness.rish` -- any tool that explicitly names `.kyri` as the session log extension.
- **The `stamp-and-name.md` tools:** The dated-file detection shape is `YYYYMMDD-HHMMSS_sprig.ext` where ext is `kyri`. Changing to `kyri.md` is a compound extension -- `ext` becomes `kyri.md`. The resolvers need to recognize both during the transition period.
- **Transition approach:** Forward-only from a stamp. New logs write `.kyri.md`. Old `.kyri` logs are renamed in a bulk rename commit. Both old and new extension shapes are recognized during the session after the rename, until the tools are updated.

**Recommendation.** This is a real, runnable molt-breach on Keaton's word. The format-honesty concern does not apply -- Kyri notation IS plain text IS valid Markdown. The cost is toolchain updates (real work, one lap each) and the 13,364-file rename (one bulk commit via `git mv` or a rename script). Hold the actual rename for Keaton's explicit circled word naming the breach, but the prompt is ready to run when that word comes.

---

## Calfive orbit fusion

Current orbit round 3/15, Gemini, dual air fun -- "say the work aloud." The three moves fit:

| Move | Calfive fit | Priority |
|---|---|---|
| Move 2 -- Markdown links | AMIR long return, fascia weave -- web door navigability | **first** -- zero cost, immediate value |
| Move 1 -- Pointer compression | Equinox 1 yield, Scribe module work | **second** -- Scribe reader update, forward-only |
| Move 3 -- `.kyri.md` extension | held pending Keaton's word | not scheduled until circled |

**Proposed orbit reorder.** Before the existing planned orbit work (product SLC, hardware, creative suite), seat:

1. Move 2: Markdown links in kin/fascia fields (one Scribe reader update + convention seated in `session-logs.md`)
2. Move 1: Pointer compression (session-header convention + Scribe resolver)

---

## Run plan

**If Keaton circles this prompt to run:**

1. Seat the Markdown link convention in `session-logs.md` and `.claude/rules/session-logs.md` -- add a "Markdown links" subsection under Contents.
2. Update `scribe/reader.rye` to extract `[text](path)` from `file` field values.
3. Seat the `session-header` convention in `session-logs.md` -- add a "Pointer compression" subsection.
4. Update `scribe/reader.rye` to resolve `session-header` fields.
5. Write a session log for this session using the new Markdown link convention as first resident.
6. Hold Move 3 for a separate circled word.

Each step is one kg lap. No deep debride runs until Move 3 is explicitly circled.

---

## What this does not touch

- Existing session logs stay exactly as written -- forward-only conventions.
- The `stamp-and-name.md` extension detection keeps `.kyri` as the session-log extension until Move 3 is circled.
- The `session-logs/README.md` index and shelf structure are unchanged.
- Dated testimony keeps every word it wrote.
