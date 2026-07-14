# Apply Claude Cursor-bot arc audit — WOV money split

**Editor:** Cursor · **Model:** Cursor Grok 4.5 · **Voice:** Rio 3
**Stamp:** `20260711.054800`

## Thinking trace

Kaeden pasted Claude 4.8 Opus's deep audit of the iOS bot arc (tips 379→430) with zip `files (46).zip`. Unpacked apply prompt + counsel + payload. Parent tip `1a8c5bb` / our HEAD `e464a22` (pull log only) — safe to apply.

Claude verified: MALA mint issuer-only double-guarded; send conserves; naming/symlink hygiene held. Concrete fix: split three over-length WOV money functions via `build_attested_bundle`, `write_root_memo`, `append_signed_line`. Open question for Kaeden: WOV pinned-TigerBeetle vs self-contained direction — not ruled.

Applied payload; re-ran `wov_exit_honesty`, `wov_dual_monarch`, `mala_m1_witness` — all GREEN. TAME style ratchet no longer lists the three money fns; remaining over-70: `run_selftest` (77) and `run_poster` (73) — left deliberately.

## Observations

- No phantom `monarch_context` / `attester.sign` in the landed `wov_core.rye`.
- Parity tip stays **430**; this is a width/duplication refactor, not a new tip.
- Zip left untracked at repo root (root allowlist).

## Files

| File | Why |
|------|-----|
| `linengrow/wov_core.rye` | Three money fns split + shared helpers |
| `counsel/20260711-053412_claude-counsel-cursor-bot-arc-audit.md` | Full audit counsel |
| `expanding-prompts/20260711-053412_apply-cursor-bot-arc-audit.md` | Apply prompt record |
| `work-in-progress/TASKS.md`, `ROADMAP.md` | Audit row + open TB question |
| `counsel/README.md`, `expanding-prompts/README.md` | Indexes |

**Recommend:** check in with Kaeden on the **WOV/TigerBeetle self-contained tension** before the next money-adjacent climb — that is the open door Claude named, not a mechanical keep-going.
