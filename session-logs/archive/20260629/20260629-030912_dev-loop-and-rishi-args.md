# Session log — dev-loop scaffold and Rishi script args roadmapped

**Stamp:** `20260629.030912`
**Editor:** Cursor · **Model:** Composer

## Thinking trace

Kaeden's gated pass: land the Cursor-in-jail scaffold safely, then write the aspiration surfaced by the seam — Rishi cannot read script invocation arguments yet, so flags live in POSIX shell until Rishi graduates the scaffold.

**Gitignore split (verified):**
- `squashfs-root/`, `.cursor-state/`, `Cursor-*.AppImage` — ignored (`!!` in `git status --ignored`)
- `tools/cursor-jail.sh`, `tools/launch-cursor.rish` — tracked (`??` → committed)
- Added explicit `/squashfs-root/` and `/Cursor-*.AppImage` lines beside existing `/.cursor-state/` for plain reading

**Committed:** cursor-jail launcher, SOURCE.md, enclosure docs, gitignore, roadmap/tasks infusion.

**Aspiration roadmapped:** **Rishi script arguments** — `runFile` today reads only `args[2]`; expose `args[3..]` to scripts as an `args` list, then a flag-parse helper; first beneficiary is `launch-cursor.rish` taking `--appimage`, retiring `cursor-jail.sh` flag layer.

**Priority:** SLC-1 acceptance already sealed; Rishi script arguments leads **Next** beside TAME-hardening — dev loop compounds every session, yet this is graduation not emergency.

## Files

| File | Why |
|------|-----|
| `tools/cursor-jail.sh` | Tracked POSIX launcher |
| `tools/launch-cursor.rish` | Rishi entry (apprun let) |
| `.gitignore` | Explicit squashfs-root + AppImage |
| `SOURCE.md`, `enclosure-editors.md`, `enclosure.conf.example` | Docs |
| `work-in-progress/TASKS.md` | Scaffold landed; args + graduation Next |
| `work-in-progress/ROADMAP.md` | Rishi script arguments in Horizon 1 |
| `expanding-prompts/20260629-030912_cursor-rishi-args-and-dev-loop.md` | Gated prompt filed |
