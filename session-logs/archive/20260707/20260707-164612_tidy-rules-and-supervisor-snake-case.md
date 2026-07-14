# Tidy rules brief and supervisor snake_case

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.164612

## Prompt

Go, update Claude and Cursor rules with tidy rules for TAME guidance, document for next Claude round, then keep going.

## Thinking trace

**Commit scope (with prior OA-L5 turn):** OA-L5 delivery snake_case (27 fns, 654→627); supervisor cluster snake_case (`supervisor_stops`, `install_handlers`, `stop_requested`, …) with call sites in subscribe poll service and restart_on_ok (627→622).

**Rules and counsel:** seated tidy bans and ratchets in `.cursor/rules/tame-guidance.mdc`, `.claude/rules/tame-guidance.md`, `context/TAME_GUIDANCE.md` **What We Check** table, `CLAUDE.md` lint pointer, and `active-designing/20260707-164612_tame-tidy-rules-brief.md` for the next Claude round.

Witnesses GREEN: `open_asks_lap5`, caravan subscribe poll + signal, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `linengrow/open_asks_lap5_delivery.rye` | OA-L5 snake_case |
| `caravan/supervisor_exit.rye` | public API snake_case |
| `caravan/supervisor_signal.rye` | handler API snake_case |
| `caravan/subscribe_poll_service.rye` | repointed imports |
| `caravan/restart_on_ok.rye` | repointed imports |
| `active-designing/20260707-164612_tame-tidy-rules-brief.md` | Claude round brief |
| `context/TAME_GUIDANCE.md` | ratchet table + 70-line advisory note |
| `.cursor/rules/tame-guidance.mdc` | tidy rules section |
| `.claude/rules/tame-guidance.md` | tidy rules section |
| `CLAUDE.md` | tame_style_check pointer |

**Recommend:** keep going on-touch camelCase in `linengrow/open_asks_delivery.rye` or the next delivery module the bench touches.
