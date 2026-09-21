# Incense on Cursor Agent CLI

**Status:** Living — one-lap terminal instruction

This is the pasteable Cursor counterpart to the Claude and Codex fleet launch recipes. It gives
Cursor the same ship memory and the same custody posture while leaving the engine-specific syntax
at the door.

## The instruction

From the repository root on the pier, inside the `tmux` session that holds the work:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7 CURSOR_FORCE=1 \
  tools/l/launch-cursor-incense.sh
```

The launcher reads, in order, the shared fleet baton and the Incense seat prompt. It then adds the
engine name, selected model, and captain role before invoking Cursor Agent CLI with:

```sh
cursor-agent --model grok-4.7 --force -p '<assembled baton + Incense prompt>'
```

The prompt is assembled from tracked files rather than copied into a second long command. That
keeps the shared fleet law, the Incense lane, and this Cursor engine in one readable chain.

## The four inputs

| Input | Default | Meaning |
|---|---:|---|
| `FLEET_BARE` | `0` | `1` runs `cursor-agent` directly on the pier; `0` runs it through `agent-jail.sh`. |
| `FLEET_CAPTAIN` | `0` | `1` adds Incense's captain's-hat context for law, review, and custody. |
| `CURSOR_MODEL` | `grok-4.7` | Explicit Cursor model ID. Override it without editing the launcher. |
| `CURSOR_FORCE` | `1` | `1` passes Cursor's `--force`; `0` keeps approval prompts. |
| `FLEET_DRY` | `0` | `1` prints the resolved command shape without starting an agent. |

`FLEET_BARE` and `CURSOR_FORCE` are separate axes. Bare mode says where the process runs. Force
mode says how Cursor handles tool approvals. A bare process is not automatically force-enabled, and
a jailed process can still receive `--force`.

`FLEET_CAPTAIN=1` is a role marker, not a key. Incense may carry law, review, and the captain's
view of the fleet, but human-only gates remain human-only: no key use, funds, provisioning,
maintainer identity, or public-seed publication.

## Safer variants

Preview the exact shape without launching:

```sh
FLEET_DRY=1 FLEET_BARE=1 FLEET_CAPTAIN=1 \
  tools/l/launch-cursor-incense.sh
```

Keep the jail while retaining the same model and captain context:

```sh
FLEET_BARE=0 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7 CURSOR_FORCE=1 \
  tools/l/launch-cursor-incense.sh
```

Keep approvals visible for a supervised lap:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_FORCE=0 \
  tools/l/launch-cursor-incense.sh
```

## What the Cursor adapter inherits

The baton and Incense stanza carry the shared Claude/Codex rules: one writer per checkout,
round-open before work, stop markers, the council-rota read, TAME and Gauge habits, docs/code
synchrony, custody gates, session output, commit discipline, and a Kyri close. Cursor's adapter
adds only what the other engines cannot provide: `--model`, `--force`, the Cursor model identity,
and the bare-versus-jail selection.

The launcher does not publish, push, spend, provision, or cross a human gate by itself. It starts
one bounded agent session. A later fleet loop or watcher may be built around this same entry point;
until then, the one-lap command is the honest ability this room proves.

## Current model note

At this writing, Cursor's current flagship Grok model is `grok-4.7`, with model ID `grok-4.7` in
the CLI. Model availability is account- and plan-dependent. If the CLI refuses that ID, run
`cursor-agent models` or choose an available model explicitly; do not silently fall back to Auto
and then record Grok as if it ran.

See Cursor's [CLI parameters](https://cursor.com/docs/cli/reference/parameters), [model reference](https://cursor.com/docs/models/grok-4-7),
and [rules guide](https://cursor.com/docs/rules) for the vendor surface this adapter calls.
