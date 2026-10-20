format session-log-v1
stamp 20260921.152340
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
title Cursor Incense fleet instruction and live model adapter
prompt print an instruction for Cursor CLI with force permissions, latest Cursor Grok, Incense context, FLEET_BARE and FLEET_CAPTAIN inputs, and unified Claude/Codex fleet rules; expand and update frontier documentation
think inspected the Claude and Codex fleet launchers, shared baton, Incense seat prompt, agent jail, current Cursor launcher, and frontier documentation
think verified the installed Cursor CLI exposes --model, --force, and --yolo, and found the current Cursor flagship Grok model as grok-4.7 in current vendor documentation
think ran Cursor against the tracked project config and caught that .cursor/cli.json accepts project permissions only; removed global version/editor keys so the live project config validates
think wrote a bounded one-lap launcher that assembles the baton and Incense prompt, separates bare from jailed execution, exposes captain context, and keeps force approval independent from custody
obs the new Cursor adapter inherits the shared fleet law through the baton and seat stanza; it adds only Cursor invocation concerns and leaves human-only gates manual
obs FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7 CURSOR_FORCE=1 is the requested pier instruction; FLEET_DRY=1 previews without launching
obs syntax, JSON, diff, dry-run, version, and help checks were GREEN; no agent session was launched and no auth state was changed
file .cursor/cli.json project permission schema corrected to permissions-only
file tools/l/launch-cursor-incense.sh reusable Cursor Incense launcher with fleet inputs
file .cursor/rules/30-grain-fleet.mdc shared fleet adapter rule
file frontier/cursor-cli/INCENSE-FLEET.md expanded pasteable instruction and model note
file frontier/cursor-cli/README.md Cursor CLI frontier entry point updated
file frontier/README.md current Cursor Grok seat documented
file frontier/NIXOS_CLI_GUIDE.md harness/model boundary documented
file session-logs/date/20260921/20260921-152340_cursor-incense-fleet-instruction.kyri this record
recommend keep-going use FLEET_DRY=1 first, then run the explicit Incense command on the pier
scope Cursor Agent CLI, Incense fleet context, and frontier documentation; GUI workflows excluded
status ready for commit
