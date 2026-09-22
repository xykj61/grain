# Incense on Cursor Agent CLI

**Status:** Living — one-lap terminal instruction

This is the pasteable Cursor counterpart to the Claude and Codex fleet launch recipes. It gives
Cursor the same ship memory and the same custody posture while leaving the engine-specific syntax
at the door.

## The instruction

From the repository root on the pier, inside the `tmux` session that holds the work:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high CURSOR_FORCE=1 \
  tools/l/launch-cursor-incense.sh
```

The backslash above must be the final character on its line. To avoid copy/paste whitespace from
a tablet terminal, the same launch may be entered as one line:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high CURSOR_FORCE=1 tools/l/launch-cursor-incense.sh
```

The launcher reads, in order, the shared fleet baton and the Incense seat prompt. It then adds the
engine name, selected model, and captain role before invoking Cursor Agent CLI with:

```sh
cursor-agent --model grok-4.7-high --force -p '<assembled baton + Incense prompt>'
```

The prompt is assembled from tracked files rather than copied into a second long command. That
keeps the shared fleet law, the Incense lane, and this Cursor engine in one readable chain.

## The four inputs

| Input | Default | Meaning |
|---|---:|---|
| `FLEET_BARE` | `0` | `1` runs `cursor-agent` directly on the pier; `0` runs it through `agent-jail.sh`. |
| `FLEET_CAPTAIN` | `0` | `1` adds Incense's captain's-hat context for law, review, and custody. |
| `CURSOR_MODEL` | `grok-4.7-high` | Explicit Cursor model ID. Override it without editing the launcher. |
| `CURSOR_FORCE` | `1` | `1` passes Cursor's `--force`; `0` keeps approval prompts. |
| `CURSOR_PREFLIGHT` | `1` | Run a bounded model probe before the full prompt. |
| `CURSOR_PREFLIGHT_TIMEOUT` | `45` | Seconds allowed for the model probe. |
| `CURSOR_INLINE_CONTEXT` | `0` | `0` asks Cursor to read the tracked context files in place; `1` embeds their contents in the prompt. |
| `CURSOR_RUN_TIMEOUT` | `900` | Seconds allowed for the full print-mode lap; `0` disables the bound. |
| `CURSOR_OUTPUT_FORMAT` | `text` | Cursor print output format: `text`, `json`, or `stream-json`. |
| `CURSOR_STREAM_PARTIAL_OUTPUT` | `0` | `1` streams partial deltas; requires `CURSOR_OUTPUT_FORMAT=stream-json`. |
| `FLEET_DRY` | `0` | `1` prints the resolved command shape without starting an agent. |

`FLEET_BARE` and `CURSOR_FORCE` are separate axes. Bare mode says where the process runs. Force
mode says how Cursor handles tool approvals. A bare process is not automatically force-enabled, and
a jailed process can still receive `--force`.

`FLEET_CAPTAIN=1` is a role marker, not a key. Incense may carry law, review, and the captain's
view of the fleet, but human-only gates remain human-only: no key use, funds, provisioning,
maintainer identity, or public-seed publication.

## Cost-effective operating profile

The default is `grok-4.7-high` because it is the strongest general-purpose choice in the current
Cursor Grok family and its ordinary published token rates match Grok 4.6. “High” is an effort
setting, not a separate price tier; difficult work may still consume more output and reasoning
tokens. Keep the prompt narrow, work in one bounded lap, and ask for inspection before edits when
the task is uncertain. This preserves effectiveness without paying for unnecessary context.

The launcher does not request Cursor's fast or 500k long-context pricing tiers. It hands Cursor the
tracked baton and seat paths by default, so Cursor reads the source files in the repository rather
than receiving a second pasted copy in the prompt. This compact handoff avoids duplicated context
and is the recommended mode. Set `CURSOR_INLINE_CONTEXT=1` only when a particular CLI path cannot
read the files itself. Avoid pasting large files into the prompt; point the agent at tracked files
instead. The default preflight is a small
bounded model probe that prevents a dead terminal when a model is unavailable. After a successful
probe on the same pier/account, `CURSOR_PREFLIGHT=0` removes that extra request for repeated laps:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high \
  CURSOR_FORCE=1 CURSOR_PREFLIGHT=0 tools/l/launch-cursor-incense.sh
```

Print mode normally buffers plain text until the agent completes. The launcher therefore bounds a
full lap at 900 seconds and reports a named timeout. For visible live activity, opt into Cursor's
streaming event format:

```sh
CURSOR_OUTPUT_FORMAT=stream-json CURSOR_STREAM_PARTIAL_OUTPUT=1 \
  FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high \
  CURSOR_FORCE=1 tools/l/launch-cursor-incense.sh
```

For short, latency-sensitive work, use the available Grok 4.6 variant explicitly. It is not
cheaper per token in the normal pricing table, but it may be more responsive on a path where
Grok 4.7 is slow or unavailable:

```sh
FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=cursor-grok-4.6-high \
  CURSOR_FORCE=1 tools/l/launch-cursor-incense.sh
```

Check `cursor-agent models` before changing the model ID. Account availability and Cursor's
selected billing mode control the final rate; this repository does not silently select a cheaper
model or claim that a fallback model ran.

## Safer variants

Preview the exact shape without launching:

```sh
FLEET_DRY=1 FLEET_BARE=1 FLEET_CAPTAIN=1 \
  tools/l/launch-cursor-incense.sh
```

Keep the jail while retaining the same model and captain context:

```sh
FLEET_BARE=0 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high CURSOR_FORCE=1 \
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

At this writing, Cursor's current flagship Grok model is Grok 4.7. This CLI exposes its documented
high-effort variant as `grok-4.7-high`. Model availability is account- and plan-dependent. If the
bounded preflight refuses that ID, run `cursor-agent models` or choose an available model
explicitly; do not silently fall back to Auto and then record Grok as if it ran.

See Cursor's [CLI parameters](https://cursor.com/docs/cli/reference/parameters), [model reference](https://cursor.com/docs/models/grok-4-7),
and [rules guide](https://cursor.com/docs/rules) for the vendor surface this adapter calls.
