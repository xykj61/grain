# Door 2 — GNOME unresponsive dialog on live drawn-terminal

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260703.031412`

## Thinking trace

Kaeden saw GNOME "Unknown is not responding" after `pond/bin/drawn-terminal` in ai-jail. Metalsmoke passed; live mode uses stdin in the **terminal** (keyboard-from-window is SLC-2b). Likely jail+Wayland ping or user focus on window vs shell. Advised Wait, type at `rishi>` in jail terminal, host fallback if stuck.

## Files

| File | Why |
|------|-----|
| `session-logs/20260703-031412_door2-unresponsive-dialog.md` | Troubleshooting note |
