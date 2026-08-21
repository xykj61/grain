# Session logs archive fold — first run

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260704.202900

**Prompt:** Kaeden asked to run the session-log date archive and continue.

## Thinking trace

`session_logs_archive.rish` failed on first run — rishi interpolated `${f}` and `${day}` in the embedded shell string as undefined names. Extracted logic to `tools/fixtures/session_logs_archive.sh` (same pattern as other witnesses). Re-ran: **moved=500** prior-day logs into `session-logs/archive/YYYYMMDD/` (12 day folders); **40 logs** remain flat for `20260704`. README links rewritten to `archive/...` paths. Added archive-fold note to `session-logs/README.md`.

## Files

| File | Why |
|------|-----|
| `tools/fixtures/session_logs_archive.sh` | Shell body — fixes rish interpolation bug |
| `tools/session_logs_archive.rish` | Delegates to fixture |
| `session-logs/archive/**` | 500 logs folded by date |
| `session-logs/README.md` | Link rewrites + archive convention note |

## Recommend

**Keep going to Amber manifest hygiene lap (I6)** when Kaeden speaks — mechanical today, no new gate; or re-run archive at each day's close.
