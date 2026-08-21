# Claude rules aligned with Cursor session-log discipline

**Stamp:** `20260628.141827`
**Editor:** Cursor · **Model:** Composer

## Thinking trace

Kaeden asked that Claude rules match the one-clock session-log conventions already fixed in Cursor. Compared `.claude/rules/session-logs.md`, `.cursor/rules/session-logs.mdc`, `CLAUDE.md`, and `.claude/rules/reya2.md`.

Gaps: Claude Spirit section still said "commit alongside" rather than same-commit-first; Editor/Model examples differed; `CLAUDE.md` scoped logs to "changes the repo or substantial reasoning" instead of every response; `reya2.md` lacked the session-logs working-convention bullet present in Cursor.

## Changes

Synced `.claude/rules/session-logs.md` Spirit and examples with Cursor; expanded `CLAUDE.md` Session logs section with filename, Stamp, Editor/Model, README, and commit discipline; added Working conventions to `.claude/rules/reya2.md`; added cross-editor identification line to `.cursor/rules/session-logs.mdc` for full parity.

## Files

| File | Why |
|------|-----|
| `.claude/rules/session-logs.md` | Same-commit discipline + unified Editor/Model examples |
| `.claude/rules/reya2.md` | Session-logs bullet + working conventions |
| `CLAUDE.md` | Every-response scope + one-clock checklist |
| `.cursor/rules/session-logs.mdc` | Cross-editor identification line |
