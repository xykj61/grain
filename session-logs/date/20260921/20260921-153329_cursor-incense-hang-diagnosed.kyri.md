format session-log-v1
stamp 20260921.153329
editor OpenCode
provider Together AI
product OpenCode
role repository maintainer
modality text
model unverified
model_status active runtime unverified
configured_model gpt-5.6-luna
configured_status user-selected personal default
evidence ~/.codex/config.toml; user instruction 2026-09-21
voice Kyri
host NixOS workspace; America/New_York
title Cursor Incense hang diagnosed and bounded
prompt the Cursor Incense script hangs outside the Codex session
think timed prompt assembly, Cursor authentication status, direct model probes, and the full launch path separately
think found prompt assembly GREEN and status GREEN; the direct grok-4.7 request timed out while grok-4.6 returned CURSOR_ALIVE
think queried cursor-agent models and found effort-qualified Grok 4.7 IDs; corrected the launcher from the unlisted grok-4.7 alias to grok-4.7-high
think added a bounded preflight that reports a named model or transport failure and never leaves the terminal waiting without a limit
obs latest Grok 4.7 is visible in the account model list but did not return within the bounded probe on this installed CLI/account path; the launcher does not silently fall back to Auto
obs the project .cursor/cli.json remains valid permissions-only configuration; no login or agent session was changed by the diagnostic
file tools/l/launch-cursor-incense.sh effort-qualified model and bounded preflight repair
file .cursor/rules/30-grain-fleet.mdc timeout and model-selection rule
file frontier/cursor-cli/INCENSE-FLEET.md updated command, inputs, and recovery note
file frontier/cursor-cli/README.md updated launcher and preflight guidance
file frontier/NIXOS_CLI_GUIDE.md harness/model boundary updated
file frontier/README.md current model identifier updated
file session-logs/date/20260921/20260921-153329_cursor-incense-hang-diagnosed.kyri this record
recommend check-in (either) -- retry with CURSOR_MODEL=grok-4.6 if immediate work matters, or investigate the Grok 4.7 service/account path after the bounded failure is observed
scope Cursor Agent CLI Incense launcher and current model/transport behavior; no GUI work
status ready for commit
