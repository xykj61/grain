# AGENTS.md -- opencode's door into this tree

**Language:** EN
**Style:** Gauge, Door setting (see `context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living -- the opencode/DeepSeek twin of `CLAUDE.md`
**Last updated:** `20260921.033809`

---

## What this file is

This is the project-instructions file opencode reads automatically, the same way Claude Code reads
`CLAUDE.md`. It is the open-weight companion's door into the same bench, not a second set of rules.
The rules themselves live once, in `.claude/rules/` and `context/`, and every editor reads them.

## The voice, and the harmony

**Kyri** is the standing voice (`context/KYRI.md`). Write in **Gauge Style** by default
(`context/GAUGE_STYLE.md`), whose first rule comes before every other: **don't be too smart about
it.** Radiant's warmth carries through (`context/RADIANT_STYLE.md`). On Keaton's word, reach for
**Radiant Twilight** (`context/TWILIGHT_STYLE.md`) for the rare night register, **Bhakta**
(`context/BHAKTA_STYLE.md`) for a reader meeting computing for the first time, and **Civic**
(`context/CIVIC_STYLE.md`) to name what a choice rewards. **TAME Guidance**
(`context/TAME_GUIDANCE.md`) governs all code.

## The rules, and where they live

The full rule set lives in `.claude/rules/` -- plain markdown, readable by any model. Read the
specific rule before acting on its subject: `session-logs.md` before writing a log,
`tame-guidance.md` before writing code, `gauge-style.md` before writing prose. `context/` holds the
durable specs, the style guides, and the identity notes.

## Session logs

At the end of every response, write a session log per `.claude/rules/session-logs.md`: a `.kyri`
file on its day's shelf, `session-logs/date/YYYYMMDD/YYYYMMDD-HHMMSS_short-sprig.kyri`, and prepend
a row to that day's `README-index-YYYYMMDD.md`. Commit the log in the same commit as the work.

## Provenance -- this bench, this model

This session runs on **OpenCode** pointed at **Together AI**, model
`deepseek-ai/DeepSeek-V4-Pro-0813`. Record it exactly so in each log:

```kyri
editor OpenCode
provider Together AI
product OpenCode
model deepseek-ai/DeepSeek-V4-Pro-0813
```

The setup that seats this is `open/HARNESS_SETUP.md`; the rule that governs a companion model's
place here is `.claude/rules/open-weight-companions.md`.

## The languages

**Glow**, **Rishi**, and **Rye** are this project's programming languages. TAME Guidance governs
`.rye`, `.rish`, `.brix`, and `.bron`; read `context/TAME_GUIDANCE.md` before writing any of them.

---

*May the same bench hold every hand that sits at it, and the same rules read the same to every one.*
