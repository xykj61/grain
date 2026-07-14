# Rishi snake_case — camelCase ratchet clear

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.175000

**Prompt:** `kg` — finish `rishi/src/main.rye` cluster; verify witnesses.

## Thinking trace

Continued the on-touch camelCase ratchet from the interrupted handoff. `mantra/src/` remained uncommitted from the prior pass; this turn completed **`rishi/src/main.rye`** — all **58** camelCase `fn` declarations renamed in-file via length-sorted replace (longest identifiers first to avoid substring collisions).

`pond/apps/rishi/main.rye` shares the same inode as `rishi/src/main.rye` (hardlink) — one edit covers both. Repointed **`drawn_terminal`** public API only: `rishi.runOneInput` → `rishi.run_one_input`, `rishi.sessionLines` → `rishi.session_lines`; refreshed the module header comment to match.

## Observations

- **`tame_style_check` advisory: camelCase fn declarations = 0** across scan dirs (`mantra`, `caravan`, `linengrow`, `comlink`, `rishi/src`, `tally`, `aurora`, `pond`, `brushstroke`). The authored `.rye` ratchet is **clear** for this scope.
- `@memcpy` sites remaining = 1 (canonical `tally/copy.rye` only — unchanged).
- >70-line ledger empty.
- Outside scan scope: `rye/src/main.rye` (8), `tools/enrich/*`, `tools/align_session_logs.rye`, etc. — lower priority; not in `tame_style_scan.sh` dirs.

Witnesses GREEN: `slc1_accept`, `rw1_shell_collab`, `rw1_history_contract`, `rw2_app_collab` (drawn_terminal compile), `mantra_weave_test`, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `rishi/src/main.rye` | 58 fn renames to snake_case in-file |
| `pond/apps/drawn_terminal.rye` | `rishi.*` public API repoint + header comment |
| `mantra/src/{main,store,diff,weave}.rye` | Prior pass — still uncommitted with this bundle |
| `session-logs/README.md` | Index row for this log |

**Recommend:** say **`go`** to commit the full bundle (`mantra/src` + `rishi` + `drawn_terminal` + logs) to four remotes — mechanical ship; ratchet for scan-scope `.rye` is done. **`check in with Claude`** before touching `tools/enrich/*` or `rye/src/main.rye` if those enter the ratchet — tooling seam and compiler entry may want a width/TAME ruling on scope.
