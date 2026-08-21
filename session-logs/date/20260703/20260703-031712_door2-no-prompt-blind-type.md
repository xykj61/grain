# Door 2 — no rishi> prompt; blind type + host fallback

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260703.031712`

## Thinking trace

Kaeden never sees `rishi>` in ai-jail; GNOME Wait loop. Code review: `rishi>` prints only on stdin_ready, not at startup; live loop may starve Wayland ping in jail. Advised Force Quit, host terminal, blind type at shell; optional UX fix deferred until after close or explicit word.

## Files

| File | Why |
|------|-----|
| `session-logs/20260703-031712_door2-no-prompt-blind-type.md` | Troubleshooting note |
