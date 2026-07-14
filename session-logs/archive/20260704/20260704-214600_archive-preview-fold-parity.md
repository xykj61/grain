# Archive lap — preview/fold split + parity wire

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260704.214600

**Prompt:** Continue on recommended path — verify read-vs-mutate vow on session archive lap.

## Thinking trace

Verified `fold --dry-run` violated seated silo vow (one flag that sometimes writes). Split into `preview` (read) and `fold` (mutate) subcommands in `session_logs_archive.rye`; added selftest that preview leaves fixture flat. Created `session_logs_archive_preview.rish`; simplified production `session_logs_archive.rish`. Wired witness into `parity.rish`. Updated silo catalog, ER example, ORGANIZING, session-logs README. Witness + preview + full parity GREEN on metal.

## Files

| File | Why |
|------|-----|
| `tools/session_logs_archive.rye` | `preview` / `fold` subcommands; preview selftest |
| `tools/session_logs_archive_preview.rish` | Read-only shell entry |
| `tools/session_logs_archive.rish` | Mutate-only fold |
| `tools/parity.rish` | Archive hygiene witness wired |
| `ORGANIZING.md` · `session-logs/README.md` · silo · ER | Docs aligned |

## Observations

Production preview reports `moved=0` — archive already folded earlier today. Parity suite still reports all GREEN; archive witness is additive hygiene, not a new numbered parity stop.

## Recommend

**Keep going** to commit this batch when Kaeden asks — archive tooling + silo accretion + ER trio form one coherent lap-law land.
