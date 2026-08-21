# drawn-terminal live — rishi> prompt fix

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260703.032112`

## Thinking trace

Kaeden waited ~1 min with no `rishi>` — live loop only printed prompt on stdin_ready (after typing). Restructured runLive to print banner + `rishi>` before poll wait (matches rishi REPL); rebuild GREEN on host.

## Files

| File | Why |
|------|-----|
| `pond/apps/drawn_terminal.rye` | Prompt before blocking poll |
| `session-logs/20260703-032112_drawn-terminal-prompt-fix.md` | Fix record |
