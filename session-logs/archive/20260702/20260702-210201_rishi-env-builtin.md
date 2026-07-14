# Rishi Env Builtin — Witness-First Growth

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260702.210201`

## Thinking trace

Continued ungated diet after committing sitting three (`82ec4a0`). Next horizon: one Rishi builtin per round — **env**.

Implemented `env "NAME"` in `rishi/src/main.rye`: reads `init.environ_map` through a `host_environ` field on `Env`, returns owned string or empty when unset. Rebuilt with `rye build`. Witness-first: `tools/rish_env_witness.rish` (requires `RISHI_ENV_WITNESS_TEST=pinned`) and `rishi/tests/env.rish`. Discovered assert does not parse `>` comparisons — used `!= 0` for length checks.

Parity **142** GREEN unchanged (env witness unwired, preserving Edit 5 at **143**). Updated manual §4 and §13, rishi README, TASKS, RTAC.

## Observations

- `read-file` / `write-file` / `list-dir` already live in the interpreter; the remaining "file-reading" horizon in TASKS may mean script-surface documentation alignment rather than new code — park clarification if needed.
- Next builtin round: named exit-code vocabulary (Caravan restart policy).

## Files

| File | Why |
|------|-----|
| `rishi/src/main.rye` | `env` builtin + `host_environ` on Env |
| `tools/rish_env_witness.rish` | Standalone GREEN witness |
| `rishi/tests/env.rish` | Std test script |
| `manual/reference/rishi-language.md` | §4 env, § renumber, §13 gaps |
| `rishi/README.md` | Builtin list + test command |
| `work-in-progress/TASKS.md` | Framework growth progress |
| `work-in-progress/ready-to-ask-claude.md` | Diet update |
