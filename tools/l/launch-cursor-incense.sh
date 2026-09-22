#!/usr/bin/env bash
# launch-cursor-incense.sh -- one Cursor Agent CLI lap with the Incense ship context.
#
# The input variables deliberately mirror the fleet's Claude/Codex vocabulary:
#   FLEET_BARE=1       run Cursor on the pier host; unset/0 uses agent-jail.sh
#   FLEET_CAPTAIN=1    add Incense's captain's-hat context to the prompt
#   CURSOR_MODEL=...   model ID, defaulting to Cursor Grok 4.7 at high effort
#   CURSOR_FORCE=1     pass Cursor's --force permission flag; default enabled
#   CURSOR_PREFLIGHT=1 run a bounded model probe before the full prompt
#   CURSOR_PREFLIGHT_TIMEOUT=45 seconds allowed for that probe
#   CURSOR_INLINE_CONTEXT=0 read the tracked baton and seat files in place; 1 embeds them
#   CURSOR_RUN_TIMEOUT=900 seconds allowed for the full print-mode lap; 0 disables the bound
#   CURSOR_OUTPUT_FORMAT=text text output; stream-json can show live events
#   CURSOR_STREAM_PARTIAL_OUTPUT=0 stream partial deltas when output format is stream-json
#   FLEET_DRY=1        print the resolved command shape and run nothing
#
# Example:
#   FLEET_BARE=1 FLEET_CAPTAIN=1 CURSOR_MODEL=grok-4.7-high \
#     tools/l/launch-cursor-incense.sh
#
# The shared baton and Incense stanza are read from tracked files. Auth, model cache, and runtime
# transcripts stay in the ignored Cursor state room or session-output, never in this script.
set -euo pipefail

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"

seat=incense
bare=${FLEET_BARE:-0}
captain=${FLEET_CAPTAIN:-0}
force=${CURSOR_FORCE:-1}
model=${CURSOR_MODEL:-grok-4.7-high}
preflight=${CURSOR_PREFLIGHT:-1}
preflight_timeout=${CURSOR_PREFLIGHT_TIMEOUT:-45}
inline_context=${CURSOR_INLINE_CONTEXT:-0}
run_timeout=${CURSOR_RUN_TIMEOUT:-900}
output_format=${CURSOR_OUTPUT_FORMAT:-text}
stream_partial=${CURSOR_STREAM_PARTIAL_OUTPUT:-0}
baton=tools/f/fleet_baton.txt
seat_prompt=tools/i/incense_seat_prompt.txt
FLEET_BARE=$bare
FLEET_CAPTAIN=$captain
CURSOR_FORCE=$force

for value_name in FLEET_BARE FLEET_CAPTAIN CURSOR_FORCE; do
  value=${!value_name}
  case "$value" in
    0|1) ;;
    *) echo "launch-cursor-incense: $value_name must be 0 or 1" >&2; exit 2 ;;
  esac
done
[ -r "$baton" ] || { echo "launch-cursor-incense: missing $baton" >&2; exit 2; }
[ -r "$seat_prompt" ] || { echo "launch-cursor-incense: missing $seat_prompt" >&2; exit 2; }
[ -n "$model" ] || { echo "launch-cursor-incense: CURSOR_MODEL must not be empty" >&2; exit 2; }
case "$preflight" in 0|1) ;; *) echo "launch-cursor-incense: CURSOR_PREFLIGHT must be 0 or 1" >&2; exit 2 ;; esac
case "$preflight_timeout" in ''|*[!0-9]*) echo "launch-cursor-incense: CURSOR_PREFLIGHT_TIMEOUT must be a nonnegative integer" >&2; exit 2 ;; esac
case "$inline_context" in 0|1) ;; *) echo "launch-cursor-incense: CURSOR_INLINE_CONTEXT must be 0 or 1" >&2; exit 2 ;; esac
case "$run_timeout" in ''|*[!0-9]*) echo "launch-cursor-incense: CURSOR_RUN_TIMEOUT must be a nonnegative integer" >&2; exit 2 ;; esac
case "$output_format" in text|json|stream-json) ;; *) echo "launch-cursor-incense: CURSOR_OUTPUT_FORMAT must be text, json, or stream-json" >&2; exit 2 ;; esac
case "$stream_partial" in 0|1) ;; *) echo "launch-cursor-incense: CURSOR_STREAM_PARTIAL_OUTPUT must be 0 or 1" >&2; exit 2 ;; esac
if [ "$stream_partial" = 1 ] && [ "$output_format" != stream-json ]; then
  echo "launch-cursor-incense: CURSOR_STREAM_PARTIAL_OUTPUT=1 requires CURSOR_OUTPUT_FORMAT=stream-json" >&2
  exit 2
fi

if [ "${FLEET_DRY:-0}" != 1 ] && [ "$preflight" = 1 ]; then
  probe_file=$(mktemp "${TMPDIR:-/tmp}/cursor-incense-probe.XXXXXX")
  # Keep the probe output available to the failure handler. EXIT cleanup also runs after an
  # interrupt, while trapping INT/TERM here would delete the evidence before it can be shown.
  trap 'rm -f "$probe_file"' EXIT
  probe_args=(--model "$model")
  [ "$force" = 1 ] && probe_args+=(--force)
  probe_args+=(-p 'Reply with exactly: CURSOR_MODEL_READY')
  echo "launch-cursor-incense: probing $model for up to ${preflight_timeout}s"
  if [ "$bare" = 1 ]; then
    if timeout "$preflight_timeout" cursor-agent "${probe_args[@]}" >"$probe_file" 2>&1; then
      probe_code=0
    else
      probe_code=$?
    fi
  else
    if timeout "$preflight_timeout" ./tools/ag/agent-jail.sh cursor-agent "${probe_args[@]}" >"$probe_file" 2>&1; then
      probe_code=0
    else
      probe_code=$?
    fi
  fi
  if [ "$probe_code" -ne 0 ] || ! grep -q 'CURSOR_MODEL_READY' "$probe_file"; then
    if [ "$probe_code" -eq 124 ]; then
      echo "launch-cursor-incense: model probe timed out after ${preflight_timeout}s" >&2
    elif [ "$probe_code" -eq 130 ]; then
      echo "launch-cursor-incense: model probe interrupted" >&2
    else
      echo "launch-cursor-incense: model probe failed (code $probe_code)" >&2
    fi
    tail -20 "$probe_file" >&2 || true
    echo "launch-cursor-incense: try cursor-agent models, then set CURSOR_MODEL to an available ID" >&2
    exit 3
  fi
  echo "launch-cursor-incense: model probe passed"
fi

prompt=$(
  if [ "$inline_context" = 1 ]; then
    cat "$baton"
    printf '\n'
    cat "$seat_prompt"
    printf '\n'
  else
    printf '%s\n' "Read these tracked files whole, in this order, before acting: $baton; $seat_prompt. They are the shared fleet baton and Incense seat context. Do not replace them with a summary."
    printf '%s\n\n' "Keep this context file-backed rather than quoting it into the prompt; use repository tools to read it from the current tree."
  fi
  printf '%s\n' "YOU ARE $seat -- Cursor Agent CLI, running $( [ "$bare" = 1 ] && printf bare || printf inside-ai-jail ) on the pier, in this tree."
  printf '%s\n' "Use the Cursor CLI model selected by this launch: $model. Record configured_model $model as an explicit fleet CLI selection and keep active runtime identity separate."
  if [ "$captain" = 1 ]; then
    printf '%s\n' "FLEET_CAPTAIN=1: Incense carries the captain's hat for law, review, and custody. Keep the captain's human-only gates manual; do not spend keys, funds, provisioning, identity, or seed authority."
  else
    printf '%s\n' "FLEET_CAPTAIN=0: run the Incense lane without captain authority; stop and surface captain-only choices rather than deciding them."
  fi
)

if [ "${FLEET_DRY:-0}" = 1 ]; then
  echo "launch-cursor-incense: FLEET_DRY=1 -- no agent launched"
  printf 'FLEET_BARE=%s FLEET_CAPTAIN=%s CURSOR_MODEL=%s CURSOR_FORCE=%s CURSOR_PREFLIGHT=%s CURSOR_INLINE_CONTEXT=%s CURSOR_RUN_TIMEOUT=%s CURSOR_OUTPUT_FORMAT=%s\n' "$bare" "$captain" "$model" "$force" "$preflight" "$inline_context" "$run_timeout" "$output_format"
  if [ "$bare" = 1 ]; then
    printf 'cursor-agent --model %q %s -p <assembled Incense prompt>\n' "$model" "$( [ "$force" = 1 ] && printf -- '--force' || true )"
  else
    printf './tools/ag/agent-jail.sh cursor-agent --model %q %s -p <assembled Incense prompt>\n' "$model" "$( [ "$force" = 1 ] && printf -- '--force' || true )"
  fi
  exit 0
fi

args=(--model "$model")
[ "$force" = 1 ] && args+=(--force)
args+=(--output-format "$output_format")
[ "$stream_partial" = 1 ] && args+=(--stream-partial-output)
args+=(-p "$prompt")

run_agent() {
  if [ "$run_timeout" = 0 ]; then
    "$@"
  else
    timeout --foreground "$run_timeout" "$@"
  fi
}

if [ "$bare" = 1 ]; then
  command -v cursor-agent >/dev/null 2>&1 || {
    echo "launch-cursor-incense: cursor-agent is not on PATH" >&2
    exit 2
  }
  if run_agent cursor-agent "${args[@]}"; then
    exit 0
  else
    code=$?
  fi
else
  if run_agent ./tools/ag/agent-jail.sh cursor-agent "${args[@]}"; then
    exit 0
  else
    code=$?
  fi
fi

if [ "$code" -eq 124 ]; then
  echo "launch-cursor-incense: full Cursor lap timed out after ${run_timeout}s" >&2
elif [ "$code" -eq 130 ]; then
  echo "launch-cursor-incense: full Cursor lap interrupted" >&2
fi
exit "$code"
