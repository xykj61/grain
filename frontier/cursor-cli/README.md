# Cursor Agent CLI frontier

**Status:** Living — terminal-only operating door for the Grain pier

This room is the current, practical companion to the fossil material under
`.cursor-archive/`. It is written for Cursor Agent CLI running on the NixOS pier, reached from
the Daylight DC-1 tablet through Termux over Mosh. It deliberately excludes Cursor GUI/editor
operations.

## Start here

1. Read [`../../AGENTS.md`](../../AGENTS.md) for the shared project door.
2. Read [`TERMUX-MOSH-PIER.md`](TERMUX-MOSH-PIER.md) for the tablet-to-pier lane.
3. Read [`INCENSE-FLEET.md`](INCENSE-FLEET.md) for the unified Incense launch instruction.
4. Start the agent through [`../../tools/ag/agent-jail.sh`](../../tools/ag/agent-jail.sh), not
   by copying private state into the repository.
5. Keep the agent inside a named `tmux` session so a transport interruption does not end the work.

The project-side permission file is [`../../.cursor/cli.json`](../../.cursor/cli.json). Cursor's
personal model selection and login remain in the global CLI config and auth store; they are not
project configuration and must not be committed. The ignored `loops/cursor/` directory is runtime
state, not documentation.

## Live rule boundary

Cursor CLI discovers `.cursor/rules/*.mdc` and also reads root `AGENTS.md`/`CLAUDE.md`. The live
rules here are intentionally a small adapter to the shared canon:

- [`../../.cursor/rules/00-grain-cli.mdc`](../../.cursor/rules/00-grain-cli.mdc) — CLI scope and
  reading order.
- [`../../.cursor/rules/10-grain-safety.mdc`](../../.cursor/rules/10-grain-safety.mdc) — remote
  terminal and secret-handling boundary.
- [`../../.cursor/rules/20-grain-touch-rules.mdc`](../../.cursor/rules/20-grain-touch-rules.mdc) —
  TAME, docs-sync, and session-log touch points.

The old per-rule `.mdc` copies remain whole as fossils. They are not loaded into the live CLI
context; `.cursorignore` keeps the archive and runtime state out of indexing.

## CLI commands

```sh
# from the repository root, inside tmux on the pier
./tools/ag/agent-jail.sh cursor-agent
./tools/ag/agent-jail.sh cursor-agent --continue
./tools/ag/agent-jail.sh cursor-agent -p 'inspect the current worktree; do not edit'
```

## Incense fleet launch

The unified one-lap instruction is documented in [`INCENSE-FLEET.md`](INCENSE-FLEET.md) and
implemented by a tracked script. It prepends the shared fleet baton and the
Incense seat context, selects the latest Cursor Grok model explicitly, and makes the two fleet
axes visible at the shell boundary:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high CURSOR_FORCE=1 \
  tools/l/launch-cursor-incense.sh
```

If entering this from a tablet, keep the `\` as the last character on its line; trailing spaces
turn the continuation into a separate shell command. A one-line form is also safe:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high CURSOR_FORCE=1 tools/l/launch-cursor-incense.sh
```

`FLEET_BARE=1` means the agent runs directly on the pier; use `FLEET_BARE=0` to run through the
repository's `agent-jail.sh`. `FLEET_CAPTAIN=1` adds Incense's law/review/custody role to the
prompt, but never crosses a human-only gate. `CURSOR_FORCE=1` passes Cursor's `--force` flag,
which is the CLI equivalent of allowing commands without an approval prompt unless a denial still
applies. Preview the resolved command without launching it with `FLEET_DRY=1`.

The shared baton, seat stanza, round-open, stop markers, one-writer rule, session-output window,
commit, and Kyri close remain the same fleet shape used by Claude and Codex. The Cursor-specific
adapter is [`../../.cursor/rules/30-grain-fleet.mdc`](../../.cursor/rules/30-grain-fleet.mdc).

Use the CLI's model picker or `--model` for a session choice. The current default in the tracked
Incense launcher is `grok-4.7-high`; the explicit variable keeps that choice inspectable. The
launcher preflights the model for a bounded period so unavailable models fail clearly. For cost,
the launcher keeps the prompt file-backed, avoids the 500k long-context tier, and permits
`CURSOR_PREFLIGHT=0` after the model path has already been proven. Grok 4.6 is a responsive
fallback, not a cheaper per-token tier. Do not bake a personal model ID, email, auth token, or
telemetry payload into this tree. The official CLI configuration locations
and permission schema are maintained in Cursor's documentation; the tracked project file contains
only the project permission layer.

## What is out of scope

Cursor desktop, GUI settings, editor extensions, desktop keybindings, visual layout, and local
tablet GUI automation do not belong in this room. The tablet is the keyboard-and-pointer end of a
terminal wire; the pier is where the repository and agent run.
