# Rishi File I/O and Exit Vocabulary — Sitting Five

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260702.210650`

## Thinking trace

Continued ungated diet after env builtin (`011c2b5`). Two framework-growth rounds this sitting:

**File I/O (`20260702.210435`):** `read-file`, `write-file`, and `list-dir` already lived in the interpreter — the gap was reference and a tools witness. Added `tools/rish_file_io_witness.rish` using `tools/fixtures/rish_io/` (generated `*.txt` gitignored). Manual gained §5.

**Exit vocabulary (`20260702.210650`):** Pre-bound `exit-ok` (0), `exit-temporary` (112), `exit-permanent` (111), `exit-could-not-begin` (125) at script/REPL entry; added `exit EXPR` statement with optional `ExitSlot` on Env (optional pointer so Pond's drawn terminal keeps `Env{}`). Witness runs three fixture scripts via `run`. Manual §6 documents the table.

All four witnesses stay **unwired** from parity — Edit 5 reserved for **143**. Parity **142** GREEN on push.

## Observations

- Framework-growth witness track for this season is complete; Aurora manual and bare-print remain opportunistic.
- Exit values follow execline/s6 lineage as cited in userland research — Caravan integration waits its season.

## Files

| File | Why |
|------|-----|
| `tools/rish_file_io_witness.rish` | File I/O witness |
| `tools/fixtures/rish_io/README.md` | Fixture anchor |
| `.gitignore` | Ignore witness scratch txt |
| `tools/rish_exit_codes_witness.rish` | Exit vocabulary witness |
| `tools/fixtures/exit_*.rish` | Three exit-code fixtures |
| `rishi/src/main.rye` | Exit vocabulary + `exit` statement |
| `manual/reference/rishi-language.md` | §5–§6, §15 gaps closed |
| `work-in-progress/TASKS.md` | Framework growth checked |
| `work-in-progress/ready-to-ask-claude.md` | Diet update |
