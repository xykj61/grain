format session-log-v1
stamp 20260921.211700
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
title Cursor resource exhaustion prompt compacted
prompt diagnose resource_exhausted after the Cursor model probe passed
think separate successful model readiness from full-request failure and measure the assembled fleet context
obs the shared baton plus seat prompt is about 20 KB before Cursor adds automatic project context; the full request reconnects and exhausts while the probe passes
think make file-backed context the default, retain CURSOR_INLINE_CONTEXT=1 as an explicit escape hatch, and verify the installed fallback model identifier
obs cursor-agent lists cursor-grok-4.6-high rather than grok-4.6-high; even the compact Grok requests remained slow in this account path, so service/account exhaustion may remain
file tools/l/launch-cursor-incense.sh compact context handoff and input validation
file .cursor/rules/30-grain-fleet.mdc resource-exhaustion guidance and exact fallback
file frontier/cursor-cli/INCENSE-FLEET.md compact mode and fallback documentation
file frontier/cursor-cli/README.md compact context explanation
file session-logs/date/20260921/20260921-211700_cursor-resource-exhaustion-compacted.kyri this record
recommend retry the default compact launcher after the Cursor service recovers; use CURSOR_INLINE_CONTEXT=1 only if Cursor cannot read tracked files, and use cursor-grok-4.6-high only as an explicit fallback
scope Cursor CLI Incense launch path and frontier docs; no GUI work
status ready for commit
