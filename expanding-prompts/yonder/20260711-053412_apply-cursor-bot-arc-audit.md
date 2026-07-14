# Cursor Apply-Prompt — Cursor-Bot Arc Audit

**Stamp:** `20260711.053412 UDT` · **Parent:** `1a8c5bb` (tip 430) · **Voice:** Rio 3
**Bundle:** `20260711-053412_cursor-bot-arc-audit.zip`

An audit of the whole Cursor-bot arc (tips 379→430, PRs #85–#112). One verified money-code refactor plus docs — no parity regression, one open question flagged for Kaeden.

## What Lands

- **`linengrow/wov_core.rye`** — three over-length money functions split via three new shared leaf helpers (`build_attested_bundle`, `write_root_memo`, `append_signed_line`): `publish_root` 72→32, `publish_root_dual` 73→36, `accept_exit_dual` 74→68. Behavior-preserving — both `wov_exit_honesty` and `wov_dual_monarch` witnesses run GREEN against the refactored code on the counsel bench. No behavior change, only length and duplication removed.
- **`counsel/20260711-053412_...`** — the full audit: what held (money code sound, naming/symlink hygiene, WOV well-witnessed), the fix done-not-recommended, and the one honest tension.
- **`TASKS.md` / `ROADMAP.md`** — audit findings and the open WOV question recorded.

## Steps

1. Tree at `1a8c5bb`; unzip at root.
2. Rebuild rishi + rye, then re-run the WOV witnesses to confirm GREEN on your metal:
   - `rishi/bin/rishi run tools/wov_exit_honesty.rish`
   - `rishi/bin/rishi run tools/wov_dual_monarch.rish`
   - `rishi/bin/rishi run tools/mala_m1_witness.rish`
3. Run the TAME lint (`tools/tame_style_check.rish`) — the three WOV functions should no longer appear in the over-70-lines list.
4. Parity should be unchanged (the refactor touches no witness).

## Held for Kaeden — Not This Bundle

- **The WOV/TigerBeetle tension** — `wov_tb_ensure_binary.sh` builds pinned TigerBeetle via a separate Zig 0.14.1 toolchain and runs it as an external process. Faithful to WOV's original design, in tension with the no-external-interpreters direction. This is Kaeden's call, not a mechanical fix — do not act on it in this bundle.
- **`run_selftest` (77) and `run_poster` (73)** — left deliberately for a later touch; splitting unverifiable-in-one-pass code is how a clean refactor grows a quiet bug.

---

*May the money code stay exactly as guarded as it already is, and grow only more so.*
