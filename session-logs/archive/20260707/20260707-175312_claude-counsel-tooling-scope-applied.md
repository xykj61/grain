# Claude counsel applied — rye/src joins scan, tools deferred

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.175312

**Prompt:** Kaeden relayed Claude counsel on tooling scope (`20260707-175312_claude-counsel-tooling-scope-ruling.md`) — verify ratchet close, rule on `rye/src`, `tools/`, and intentional-violation fixtures.

## Thinking trace

Filed counsel at `counsel/20260707-175312_claude-counsel-tooling-scope-ruling.md`. Applied the mechanical parts of the ruling:

1. **`rye/src` joins scan roster** — `tools/fixtures/tame_style_scan.sh` now includes `rye/src` alongside the nine prior dirs.
2. **Eight renames in `rye/src/main.rye`** — `print_usage`, `print_version`, `bridge_to_zig`, `resolve_rye_lib`, `bridge_zig_path`, `rewrite_rye_imports`, `bridge_already_staged`, `bridge_rye_tree` (in-file only).
3. **TAME ban on join** — added `const assert = std.debug.assert` and unqualified `assert` in the comptime block (scan caught `std.debug.assert` once `rye/src` entered roster).
4. **Standing rules in `context/TAME_GUIDANCE.md`** — scan roster listed; `tools/` deferred as its own counted season; `width_check_authored_usize.rye` named permanently exempt (intentional-violation fixtures).

Rebuilt `rye/bin/rye` from updated source; `rye version` and `version_test` GREEN. `tame_style_check` at tip: **0** camelCase, **1** `@memcpy`, empty >70-line ledger.

## Observations

Claude's verification narrative matches this bench: the >70-line ledger is real (`run_reputation_selftest` split, not detector artifact). Tools surface (`enrich/` + `align_session_logs`) stays out until counted — breadth honesty, not disdain.

## Files

| File | Why |
|------|-----|
| `counsel/20260707-175312_claude-counsel-tooling-scope-ruling.md` | Filed counsel from root |
| `rye/src/main.rye` | snake_case + assert import |
| `tools/fixtures/tame_style_scan.sh` | `rye/src` in roster; tools/fixture notes |
| `context/TAME_GUIDANCE.md` | Scan roster, tools deferral, fixture exemption |
| `rye/bin/rye` | Rebuilt on bench (if tracked) |

**Recommend:** say **`go`** to commit counsel + rye/src + scan/TAME_GUIDANCE — mechanical ship. **`keep going`** to open the **tools counted season** when Kaeden wants the enrich/align_session_logs census first.
