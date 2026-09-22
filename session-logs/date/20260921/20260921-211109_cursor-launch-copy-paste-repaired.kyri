format session-log-v1
stamp 20260921.211109
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
title Cursor launcher copy-paste and probe diagnostics repaired
prompt diagnose the Cursor launcher output after a tablet paste and interrupted probe
think separate Bash trailing-whitespace continuation from the launcher probe behavior
obs the pasted backslash had trailing spaces, causing a blank command; Ctrl-C exposed a cleanup trap that removed probe evidence before tail could read it
think retain EXIT-only cleanup, report timeout or interruption explicitly, and add a one-line copy-safe command to the Cursor setup guides
file tools/l/launch-cursor-incense.sh preserve probe diagnostics and name timeout/interruption
file frontier/cursor-cli/INCENSE-FLEET.md tablet-safe launch forms
file frontier/cursor-cli/README.md tablet-safe launch forms
file session-logs/date/20260921/20260921-211109_cursor-launch-copy-paste-repaired.kyri this record
recommend use the one-line command from a tablet, and let the bounded preflight fail clearly if Grok 4.7 remains unavailable
scope Cursor CLI launcher diagnostics and Termux/Mosh documentation; no GUI work
status ready for commit
