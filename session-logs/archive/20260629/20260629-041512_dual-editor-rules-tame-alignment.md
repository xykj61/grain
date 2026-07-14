# Session log — dual-editor rules aligned to TAME Guidance

**Stamp:** `20260629.041512`
**Editor:** Cursor · **Model:** Composer

## Thinking trace

Kaeden asked to confirm or update Claude and Cursor rules for session logging and align everything with TAME Guidance.

Audited `.cursor/rules/` and `.claude/rules/`. Session-log rules were already one-clock but lacked explicit countdown retirement, `**Stamp:**` placement, and `align_session_logs.rye`. Synced `.cursor/rules/session-logs.mdc` and `.claude/rules/session-logs.md` to identical text with those additions.

TAME agent rules had drifted: `.claude/rules/tame-guidance.md` still carried the retired **ABSOLUTE: No `usize`** ban, contradicting `context/TAME_GUIDANCE.md` (seam-only `usize` with assert + `@intCast`). Rewrote both `tame-guidance` rules to cite the operational supplement, seam policy, lint tools (`width-check.rish`, growing `tame-check.rish`), unqualified `assert`, and compiler fork as horizon.

Updated `reya2` rules (both editors), `CLAUDE.md` (code discipline + session-log aligner), and `context/specs/enclosure-editors.md` to name all four disciplines and TAME Guidance paths.

## Observations

- `work-in-progress/20260620-212126_usize-width-baseline.md` still says ABSOLUTE BAN — living WIP, not touched this pass; may want a follow-up to match supplement.
- `work-in-progress/20260623-033012_open-threads.md` accretion still references absolute ban and old `tame-style` paths — honest history / archive candidate per TASKS.

## Files

| File | Why |
|------|-----|
| `.cursor/rules/session-logs.mdc` | One-clock + aligner + no countdown |
| `.claude/rules/session-logs.md` | Mirror Cursor session-log rule |
| `.cursor/rules/tame-guidance.mdc` | Supplement-aligned; lint surface |
| `.claude/rules/tame-guidance.md` | Removed absolute usize ban; seam policy |
| `.cursor/rules/reya2.mdc` | Four disciplines + aligner |
| `.claude/rules/reya2.md` | Mirror |
| `CLAUDE.md` | TAME Guidance section + session logs |
| `context/specs/enclosure-editors.md` | Rule inventory |
