#!/usr/bin/env bash
# chatgpt-mind.sh -- supervised Codex laps for the MIND lane on macOS.
#
# The outer boundary is upstream ai-jail's witnessed macOS Seatbelt backend.
# Codex receives `--sandbox danger-full-access` only after that outer boundary
# has emitted the expected deny-by-default plan and passed a live write-fence
# probe. The inner setting never means an ordinary Mac host is safe to run
# unrestricted.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STATE_DIR="${MIND_STATE_DIR:-$REPO_ROOT/.mind-state}"
CODEX_HOME_DIR="${MIND_CODEX_HOME:-$STATE_DIR/codex-home}"
PROMPT_VERSION="$REPO_ROOT/recursion-prompts/versions/20260826-180017_chatgpt-mind-macos-loop.md"
ARBOR_DESCRIPTOR="arbor/launch-chatgpt-chapter.brix"
PROMPT_FILE="$STATE_DIR/current.prompt"
LOG_DIR="$STATE_DIR/logs"
LOCK_DIR="$STATE_DIR/run.lock"
STOP_FILE="$STATE_DIR/STOP"
CUSTODY_FILE="$STATE_DIR/CUSTODY"

MAX_PROMPT_BYTES=24576
MAX_LOG_BYTES=1048576
MAX_LOG_BLOCKS=2048
MAX_LAPS_HARD=24
MAX_FAILURES_HARD=5
MAX_BACKOFF_SECONDS=300
MAX_LOCAL_AHEAD=32

MODE="${1:-}"
if [ $# -gt 0 ]; then shift; fi
DRY_RUN=false
ARMED=false
MAX_LAPS=1
FAILURE_CEILING=3
BACKOFF_SECONDS=15

usage() {
  cat <<'EOF'
Usage: tools/l/chatgpt-mind.sh COMMAND [options]

Commands:
  print                         Render canonical Arbor voice plus MIND law
  check                         Prove local prerequisites and the outer jail
  once --dry-run                Print one enclosed Codex command; do not run it
  once --arm-once               Run one enclosed, bounded Codex lap
  loop --dry-run [options]      Print the bounded loop plan; do not run it
  loop --arm-loop [options]     Run a supervised bounded loop
  stop                          Ask an armed loop to stop between laps

Loop options:
  --max-laps N                  One through 24; default 1
  --failure-ceiling N           One through 5; default 3
  --backoff-seconds N           Zero through 300; default 15

The armed forms use:

  ai-jail --exec --private-home --no-save-config \
    codex exec --sandbox danger-full-access --ephemeral --strict-config ...

This is unrestricted only inside the proven outer AI jail. It does not alter
power settings, install software, authenticate, fetch, push, or select a model.
EOF
}

refuse() {
  printf 'REFUSE chatgpt-mind: %s\n' "$*" >&2
  exit 1
}

is_uint() {
  case "$1" in
    '' | *[!0-9]*) return 1 ;;
    *) return 0 ;;
  esac
}

bounded_uint() {
  value="$1"
  low="$2"
  high="$3"
  label="$4"
  is_uint "$value" || refuse "$label must be an integer"
  [ "$value" -ge "$low" ] && [ "$value" -le "$high" ] \
    || refuse "$label must be between $low and $high"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --arm-once)
      [ "$MODE" = once ] || refuse "--arm-once belongs only to once"
      ARMED=true
      shift
      ;;
    --arm-loop)
      [ "$MODE" = loop ] || refuse "--arm-loop belongs only to loop"
      ARMED=true
      shift
      ;;
    --max-laps)
      MAX_LAPS="${2:-}"
      shift 2
      ;;
    --failure-ceiling)
      FAILURE_CEILING="${2:-}"
      shift 2
      ;;
    --backoff-seconds)
      BACKOFF_SECONDS="${2:-}"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      refuse "unknown option: $1"
      ;;
  esac
done

[ -n "$MODE" ] || { usage >&2; exit 2; }
case "$MODE" in
  print | check | once | loop | stop) ;;
  *) refuse "unknown command: $MODE" ;;
esac

if [ "$DRY_RUN" = true ] && [ "$ARMED" = true ]; then
  refuse "choose dry-run or an armed form, not both"
fi
if [ "$MODE" = once ] && [ "$DRY_RUN" = false ] && [ "$ARMED" = false ]; then
  refuse "once requires --dry-run or --arm-once"
fi
if [ "$MODE" = loop ] && [ "$DRY_RUN" = false ] && [ "$ARMED" = false ]; then
  refuse "loop requires --dry-run or --arm-loop"
fi
if [ "$MODE" != loop ] && [ "$MAX_LAPS" != 1 ]; then
  refuse "--max-laps belongs only to loop"
fi

bounded_uint "$MAX_LAPS" 1 "$MAX_LAPS_HARD" max-laps
bounded_uint "$FAILURE_CEILING" 1 "$MAX_FAILURES_HARD" failure-ceiling
bounded_uint "$BACKOFF_SECONDS" 0 "$MAX_BACKOFF_SECONDS" backoff-seconds

case "$STATE_DIR" in
  "$REPO_ROOT"/*) ;;
  *) refuse "MIND_STATE_DIR must stay inside this repository" ;;
esac
case "$CODEX_HOME_DIR" in
  "$REPO_ROOT"/*) ;;
  *) refuse "MIND_CODEX_HOME must stay inside this repository" ;;
esac

render_prompt() {
  [ -f "$REPO_ROOT/$ARBOR_DESCRIPTOR" ] || refuse "canonical Arbor descriptor is missing"
  [ -f "$PROMPT_VERSION" ] || refuse "filled MIND operating prompt is missing"
  mkdir -p "$STATE_DIR"
  {
    (cd "$REPO_ROOT" && sh arbor/author.sh render "$ARBOR_DESCRIPTOR")
    printf '\n'
    cat "$PROMPT_VERSION"
  } > "$PROMPT_FILE"
  prompt_bytes="$(wc -c < "$PROMPT_FILE" | tr -d ' ')"
  bounded_uint "$prompt_bytes" 1 "$MAX_PROMPT_BYTES" prompt-bytes
}

if [ "$MODE" = print ]; then
  render_prompt
  cat "$PROMPT_FILE"
  exit 0
fi

mkdir -p "$STATE_DIR" "$LOG_DIR" "$CODEX_HOME_DIR"

if [ "$MODE" = stop ]; then
  : > "$STOP_FILE"
  printf 'chatgpt-mind: stop requested at %s\n' "$STOP_FILE"
  exit 0
fi

resolve_tools() {
  [ "$(uname -s)" = Darwin ] || refuse "the existing enclosure contract is macOS-only"

  AIJAIL_BIN="$(command -v ai-jail 2>/dev/null || true)"
  [ -n "$AIJAIL_BIN" ] && [ -x "$AIJAIL_BIN" ] || refuse "ai-jail is absent from PATH"

  CODEX_BIN="$(command -v codex 2>/dev/null || true)"
  if [ -z "$CODEX_BIN" ] && [ -x /Applications/ChatGPT.app/Contents/Resources/codex ]; then
    CODEX_BIN=/Applications/ChatGPT.app/Contents/Resources/codex
  fi
  [ -n "$CODEX_BIN" ] && [ -x "$CODEX_BIN" ] || refuse "Codex CLI is absent from PATH and ChatGPT.app"

  codex_help="$($CODEX_BIN exec --help 2>&1)" || refuse "Codex exec help did not run"
  printf '%s\n' "$codex_help" | grep -F -- '--sandbox <SANDBOX_MODE>' >/dev/null \
    || refuse "Codex exec does not expose the current --sandbox option"
  printf '%s\n' "$codex_help" | grep -F 'danger-full-access' >/dev/null \
    || refuse "Codex exec does not expose danger-full-access"

  AIJAIL_VERSION="$($AIJAIL_BIN --version 2>&1)" || refuse "ai-jail version check failed"
  codex_version_reading="$($CODEX_BIN --version 2>&1)" || refuse "Codex version check failed"
  CODEX_VERSION="$(printf '%s\n' "$codex_version_reading" | tail -n 1)"
}

verify_jail_plan() {
  jail_plan="$($AIJAIL_BIN --dry-run --exec --private-home --no-save-config sh -c true 2>&1)" \
    || refuse "ai-jail could not render its macOS plan"
  printf '%s\n' "$jail_plan" | grep -F 'sandbox-exec' >/dev/null \
    || refuse "ai-jail did not select the macOS Seatbelt backend"
  printf '%s\n' "$jail_plan" | grep -F '(deny default)' >/dev/null \
    || refuse "the emitted Seatbelt profile is not deny-by-default"
  printf '%s\n' "$jail_plan" | grep -F "$REPO_ROOT" >/dev/null \
    || refuse "the emitted Seatbelt profile does not name this repository"
  printf '%s\n' "$jail_plan" | grep -F '(allow file-write*' >/dev/null \
    || refuse "the emitted Seatbelt profile has no explicit write allowance"
  printf '%s\n' "$jail_plan" | grep -F '/.ssh' >/dev/null \
    || refuse "the emitted private-home profile does not deny the SSH store"
  printf '%s\n' "$jail_plan" | grep -F '/.gnupg' >/dev/null \
    || refuse "the emitted private-home profile does not deny the GPG store"
}

prove_outer_jail() {
  probe_dir="$STATE_DIR/preflight"
  inside="$probe_dir/inside.$$"
  outside="$HOME/.grain-mind-jail-probe.$$"
  mkdir -p "$probe_dir"
  [ ! -e "$outside" ] || refuse "outside probe path already exists: $outside"

  if ! "$AIJAIL_BIN" --exec --private-home --no-save-config \
    sh -c '
      inside=$1
      outside=$2
      printf "inside\n" > "$inside" || exit 70
      if { printf "escape\n" > "$outside"; } 2>/dev/null; then exit 71; fi
      test ! -e "$outside" || exit 72
    ' mind-jail-preflight "$inside" "$outside"
  then
    rm -f "$inside"
    [ ! -e "$outside" ] || rm -f "$outside"
    refuse "live ai-jail write-fence probe failed; run from an ordinary unsandboxed terminal"
  fi

  [ "$(cat "$inside" 2>/dev/null || true)" = inside ] \
    || refuse "the outer jail did not permit its repository-local probe"
  [ ! -e "$outside" ] || {
    rm -f "$outside"
    refuse "the outer jail allowed a write outside the repository"
  }
  rm -f "$inside"
}

power_reading() {
  POWER_SOURCE=unknown
  SYSTEM_SLEEP=unknown
  if command -v pmset >/dev/null 2>&1; then
    if pmset -g batt 2>/dev/null | grep -F 'AC Power' >/dev/null; then
      POWER_SOURCE=ac
    else
      POWER_SOURCE=battery
    fi
    SYSTEM_SLEEP="$(pmset -g custom 2>/dev/null | awk '
      /^AC Power:/ { in_ac=1; next }
      /^[^[:space:]]/ { in_ac=0 }
      in_ac && $1 == "sleep" { print $2; exit }
    ')"
    [ -n "$SYSTEM_SLEEP" ] || SYSTEM_SLEEP=unknown
  fi
}

verify_repository_state() {
  cd "$REPO_ROOT"
  [ -f construction/ITINERARY.md ] || refuse "run inside the Grain repository"
  git remote get-url xy >/dev/null 2>&1 || refuse "personal remote xy is not configured"
  git show-ref --verify --quiet refs/remotes/xy/main \
    || refuse "local xy/main is absent; synchronize manually outside this launcher"

  gitlink="$(git ls-files -s gratitude/grain-sketchbook | awk '{print $1}')"
  [ "$gitlink" = 160000 ] || refuse "the pinned sketchbook is not a gitlink"

  status="$(git status --porcelain --untracked-files=normal --ignore-submodules=none)"
  [ -z "$status" ] || refuse "the worktree is not clean"

  counts="$(git rev-list --left-right --count xy/main...HEAD)"
  set -- $counts
  REMOTE_ONLY="${1:-}"
  LOCAL_ONLY="${2:-}"
  is_uint "$REMOTE_ONLY" && is_uint "$LOCAL_ONLY" || refuse "could not read xy/main divergence"
  [ "$REMOTE_ONLY" -eq 0 ] \
    || refuse "local xy/main contains $REMOTE_ONLY commit(s) not integrated into HEAD"
  [ "$LOCAL_ONLY" -le "$MAX_LOCAL_AHEAD" ] \
    || refuse "local history is $LOCAL_ONLY commits ahead, above the bounded ceiling $MAX_LOCAL_AHEAD"
}

report_configuration() {
  printf 'chatgpt-mind: %s\n' "$AIJAIL_VERSION"
  printf 'chatgpt-mind: %s\n' "$CODEX_VERSION"
  printf 'chatgpt-mind: Codex state is project-local at %s\n' "$CODEX_HOME_DIR"
  printf 'chatgpt-mind: active serving model, effort, and tier are unverified\n'
  if [ -f "$HOME/.codex/config.toml" ]; then
    awk -F ' *= *' '
      /^[[:space:]]*(model|model_reasoning_effort|service_tier)[[:space:]]*=/ {
        key=$1
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
        print "chatgpt-mind: host configured default " key " = " $2
      }
    ' "$HOME/.codex/config.toml"
    printf 'chatgpt-mind: host defaults are evidence only; they are not active-runtime proof\n'
  fi
  power_reading
  printf 'chatgpt-mind: power source %s; AC system sleep %s\n' "$POWER_SOURCE" "$SYSTEM_SLEEP"
  printf 'chatgpt-mind: screensaver and power settings remain unchanged\n'
}

resolve_tools
render_prompt
verify_jail_plan
report_configuration

if [ "$MODE" = check ]; then
  verify_repository_state
  prove_outer_jail
  printf 'GREEN chatgpt-mind: prompt, repository, tool, power reading, and outer jail checks passed\n'
  exit 0
fi

if [ "$DRY_RUN" = true ]; then
  printf 'chatgpt-mind: dry-run only; Codex will not be invoked\n'
  printf 'chatgpt-mind: bounded laps %s, failure ceiling %s, backoff %s seconds\n' \
    "$MAX_LAPS" "$FAILURE_CEILING" "$BACKOFF_SECONDS"
  printf 'chatgpt-mind: planned command:\n  %q %q %q %q %q exec --sandbox danger-full-access --ephemeral --strict-config --cd %q --output-last-message %q - < %q\n' \
    "$AIJAIL_BIN" --exec --private-home --no-save-config "$CODEX_BIN" \
    "$REPO_ROOT" "$LOG_DIR/lap-N.last" "$PROMPT_FILE"
  exit 0
fi

[ -f "$CODEX_HOME_DIR/config.toml" ] \
  || refuse "project-local Codex config is absent; the user must prepare it before arming"
[ ! -e "$STOP_FILE" ] || refuse "STOP is present; remove it deliberately before another armed run"
[ ! -e "$CUSTODY_FILE" ] || refuse "CUSTODY is present; resolve it deliberately before another armed run"

power_reading
if [ "$MODE" = loop ]; then
  [ "$POWER_SOURCE" = ac ] || refuse "armed loop requires a plugged-in Mac"
  [ "$SYSTEM_SLEEP" = 0 ] || refuse "armed loop requires AC system sleep zero; this launcher will not change it"
fi

verify_repository_state
prove_outer_jail

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  refuse "another MIND launcher holds $LOCK_DIR"
fi
cleanup_lock() {
  rmdir "$LOCK_DIR" 2>/dev/null || true
}
trap cleanup_lock EXIT
trap 'exit 130' HUP INT TERM

run_lap() {
  lap="$1"
  verify_repository_state
  [ ! -e "$STOP_FILE" ] || return 20
  [ ! -e "$CUSTODY_FILE" ] || return 21

  before="$(git rev-parse HEAD)"
  out="$LOG_DIR/lap-${lap}.stdout"
  err="$LOG_DIR/lap-${lap}.stderr"
  last="$LOG_DIR/lap-${lap}.last"
  : > "$out"
  : > "$err"
  : > "$last"

  set +e
  (
    ulimit -f "$MAX_LOG_BLOCKS"
    export CODEX_HOME="$CODEX_HOME_DIR"
    "$AIJAIL_BIN" --exec --private-home --no-save-config \
      "$CODEX_BIN" exec \
      --sandbox danger-full-access \
      --ephemeral \
      --strict-config \
      --cd "$REPO_ROOT" \
      --output-last-message "$last" \
      - < "$PROMPT_FILE"
  ) > "$out" 2> "$err"
  code=$?
  set -e

  for log in "$out" "$err" "$last"; do
    bytes="$(wc -c < "$log" | tr -d ' ')"
    if [ "$bytes" -gt "$MAX_LOG_BYTES" ]; then
      printf 'chatgpt-mind: lap %s log exceeded %s bytes: %s\n' \
        "$lap" "$MAX_LOG_BYTES" "$log" >&2
      return 22
    fi
  done

  [ "$code" -eq 0 ] || return "$code"
  [ ! -e "$CUSTODY_FILE" ] || return 21

  status="$(git status --porcelain --untracked-files=normal --ignore-submodules=none)"
  [ -z "$status" ] || return 23
  after="$(git rev-parse HEAD)"
  [ "$after" != "$before" ] || return 24
  git merge-base --is-ancestor "$before" "$after" || return 25
  [ "$(git rev-list --count "$before..$after")" -eq 1 ] || return 26
  sig="$(git log -1 --format=%G?)"
  case "$sig" in
    G | U) ;;
    *) return 27 ;;
  esac
  verify_repository_state
  return 0
}

lap=1
failures=0
delay="$BACKOFF_SECONDS"
while [ "$lap" -le "$MAX_LAPS" ]; do
  if run_lap "$lap"; then
    printf 'chatgpt-mind: lap %s complete with one signed local commit\n' "$lap"
    failures=0
    lap=$((lap + 1))
    continue
  else
    code=$?
  fi

  case "$code" in
    20) printf 'chatgpt-mind: STOP observed between laps\n'; exit 0 ;;
    21) printf 'chatgpt-mind: custody gate recorded at %s\n' "$CUSTODY_FILE"; exit 0 ;;
    23) refuse "lap $lap left a dirty tree; custody returns to the user" ;;
    24) refuse "lap $lap made no commit and named no custody gate" ;;
    25 | 26) refuse "lap $lap did not add exactly one descendant commit" ;;
    27) refuse "lap $lap commit signature did not verify" ;;
  esac

  failures=$((failures + 1))
  printf 'chatgpt-mind: lap %s failed with status %s (%s/%s)\n' \
    "$lap" "$code" "$failures" "$FAILURE_CEILING" >&2
  if [ "$failures" -ge "$FAILURE_CEILING" ]; then
    refuse "circuit breaker opened after $failures consecutive failures"
  fi
  if [ "$delay" -gt 0 ]; then sleep "$delay"; fi
  if [ "$delay" -lt "$MAX_BACKOFF_SECONDS" ]; then
    delay=$((delay * 2))
    [ "$delay" -le "$MAX_BACKOFF_SECONDS" ] || delay="$MAX_BACKOFF_SECONDS"
  fi
done

printf 'chatgpt-mind: bounded loop completed %s lap(s); no push was attempted\n' "$MAX_LAPS"
