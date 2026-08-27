#!/usr/bin/env bash
# chatgpt_mind_loop_control.sh -- two-sided local proof for the MIND launcher peers.
# No Codex or network service is contacted; a planted CLI records arguments.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCE="$ROOT/tools/l/chatgpt-mind.sh"
RISHI_SOURCE="$ROOT/tools/l/chatgpt-mind.rish"
HANDOFF_SOURCE="$ROOT/tools/l/launch-mind-cardinal-chapter.rish"
PRINTER_SOURCE="$ROOT/tools/l/print-mind-cardinal-prompt.rish"
RISHI_BIN="$ROOT/rishi/bin/rishi"
ELDER="$ROOT/tools/l/launch-claude-chapter.rish"
EXPECTED_SOURCE_SHA256=ee508804d2e441884cc55706da401eaadbf19d06542da0bb7c7f5652a576a234
EXPECTED_ELDER_SHA256=f94c6fa1f0191fa78d68004150d45cb4a4047347b7f8ea427149baca2d04b12b
PEN="$(mktemp -d "${TMPDIR:-/tmp}/chatgpt-mind-control.XXXXXX")"
cleanup() {
  if [ "${KEEP_MIND_CONTROL:-0}" = 1 ]; then
    printf 'chatgpt-mind control kept at %s\n' "$PEN" >&2
  else
    rm -rf "$PEN"
  fi
}
trap cleanup EXIT

REPO="$PEN/repo"
HOME_PEN="$PEN/home"
BIN="$PEN/bin"
PACKAGE_ROOT="$PEN/packages/standalone"
RELEASE_ROOT="$PACKAGE_ROOT/releases/control-aarch64"
REAL_CODEX="$RELEASE_ROOT/bin/codex"
CURRENT_CODEX="$PACKAGE_ROOT/current/bin/codex"
FAKE_LOG="$PEN/codex-invocations"
FAKE_STATUS_LOG="$PEN/codex-status-invocations"
FAKE_JAIL_LOG="$PEN/jail-invocations"
mkdir -p "$REPO/tools/l" "$REPO/tools/fixtures" "$REPO/arbor" "$REPO/recursion-prompts/versions" \
  "$REPO/construction" "$REPO/gratitude" "$REPO/scribble" "$REPO/lattice" \
  "$REPO/lantern" "$REPO/ember" "$HOME_PEN/.codex" "$BIN" "$RELEASE_ROOT/bin"
REPO_CANONICAL=$(cd "$REPO" && /bin/pwd)

cp "$SOURCE" "$REPO/tools/l/chatgpt-mind.sh"
cp "$RISHI_SOURCE" "$REPO/tools/l/chatgpt-mind.rish"
cp "$HANDOFF_SOURCE" "$REPO/tools/l/launch-mind-cardinal-chapter.rish"
cp "$PRINTER_SOURCE" "$REPO/tools/l/print-mind-cardinal-prompt.rish"
cp "$ROOT/tools/fixtures/dquote.txt" "$REPO/tools/fixtures/dquote.txt"
cp "$ROOT/arbor/author.sh" "$REPO/arbor/author.sh"
cp "$ROOT/arbor/launch-chatgpt-chapter.brix" "$REPO/arbor/launch-chatgpt-chapter.brix"
cp "$ROOT/arbor/launch-chatgpt-chapter.arbor" "$REPO/arbor/launch-chatgpt-chapter.arbor"
cp "$ROOT/arbor/launch-chatgpt-chapter.corpus.bron" "$REPO/arbor/launch-chatgpt-chapter.corpus.bron"
cp "$ROOT/scribble/scribble_core.rye" "$REPO/scribble/scribble_core.rye"
cp "$ROOT/lattice/lattice_core.rye" "$REPO/lattice/lattice_core.rye"
cp "$ROOT/lantern/lantern_core.rye" "$REPO/lantern/lantern_core.rye"
cp "$ROOT/ember/ember_core.rye" "$REPO/ember/ember_core.rye"
cp "$ROOT/recursion-prompts/versions/20260826-180017_chatgpt-mind-macos-loop.md" \
  "$REPO/recursion-prompts/versions/20260826-180017_chatgpt-mind-macos-loop.md"
printf 'control itinerary\n' > "$REPO/construction/ITINERARY.md"
printf '/.mind-state/\n' > "$REPO/.gitignore"
printf 'model = "gpt-5.6-sol"\n' > "$HOME_PEN/.codex/config.toml"

cat > "$REAL_CODEX" <<'EOF'
#!/usr/bin/env bash
set -eu
if [ "${1:-}" = exec ] && [ "${2:-}" = --help ]; then
  printf '%s\n' 'Usage: codex exec --sandbox <SANDBOX_MODE>'
  printf '%s\n' 'possible values: read-only, workspace-write, danger-full-access'
  exit 0
fi
if [ "${1:-}" = --version ]; then
  printf '%s\n' 'codex-cli control'
  exit 0
fi
if [ "${1:-}" = login ] && [ "${2:-}" = status ]; then
  printf '%s\n' 'login status' >> "$FAKE_STATUS_LOG"
  if [ -n "${FAKE_CODEX_STATUS_BLOCKS:-}" ]; then
    dd if=/dev/zero bs=4096 count="$FAKE_CODEX_STATUS_BLOCKS" 2>/dev/null
  else
    printf '%s\n' 'Logged in (synthetic control)'
  fi
  exit "${FAKE_CODEX_LOGIN_EXIT:-0}"
fi
printf '%s\n' "$*" >> "$FAKE_LOG"
if [ "${FAKE_RECORD_PWD:-}" = 1 ]; then
  printf 'pwd=%s\n' "$PWD" >> "$FAKE_LOG"
fi
if [ -n "${FAKE_CODEX_SLEEP:-}" ]; then
  printf '%s\n' "$$" > "$FAKE_CODEX_PID"
  exec sleep "$FAKE_CODEX_SLEEP"
fi
if [ -n "${FAKE_CODEX_OUTPUT_BLOCKS:-}" ]; then
  printf 'blocks=%s\n' "$FAKE_CODEX_OUTPUT_BLOCKS" >> "$FAKE_LOG"
  dd if=/dev/zero bs=4096 count="$FAKE_CODEX_OUTPUT_BLOCKS" 2>/dev/null
fi
cat >/dev/null
if [ "${FAKE_CODEX_LIVE:-0}" = 1 ]; then
  printf '%s\n' 'synthetic bounded progress' >&2
  if [ -n "${FAKE_CODEX_LIVE_DELAY:-}" ]; then
    sleep "$FAKE_CODEX_LIVE_DELAY"
  fi
  printf '%s\n' 'synthetic bounded final'
fi
exit "${FAKE_CODEX_EXIT:-0}"
EOF
chmod +x "$REAL_CODEX"
ln -s "$RELEASE_ROOT" "$PACKAGE_ROOT/current"
ln -s "$CURRENT_CODEX" "$BIN/codex"
REAL_CODEX=$(/bin/realpath "$REAL_CODEX")

cat > "$BIN/ai-jail" <<'EOF'
#!/usr/bin/env bash
set -eu
printf '%s\n' "$*" >> "$FAKE_JAIL_LOG"
if [ "${1:-}" = --version ]; then
  printf '%s\n' 'ai-jail control'
  exit 0
fi
dry=false
mapped=
while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) dry=true; shift ;;
    --map) mapped=${2:-}; shift 2 ;;
    --exec|--private-home|--no-save-config) shift ;;
    *) break ;;
  esac
done
if [ "$dry" = true ]; then
  if [ -n "$mapped" ]; then
    mapped=$(/bin/realpath "$mapped")
  fi
  printf '%s\n' '# sandbox-exec command:'
  printf '%s\n' 'sandbox-exec -p profile'
  if [ ! -e "$HOME/bad-plan" ]; then
    printf '%s\n' '(deny default)'
  fi
  printf '%s\n' '(allow file-write*'
  printf '  (subpath "%s"))\n' "$PWD"
  if [ -n "$mapped" ]; then
    printf '(allow file-read* (literal "%s"))\n' "$mapped"
    printf '(deny file-write* (literal "%s"))\n' "$mapped"
  fi
  printf '(deny file-read* (subpath "%s/.ssh"))\n' "$HOME"
  printf '(deny file-read* (subpath "%s/.gnupg"))\n' "$HOME"
  exit 0
fi
if [ "${1:-}" = /usr/bin/touch ]; then
  case "${2:-}" in
    "$HOME"/*) exit 73 ;;
    *) exec /usr/bin/touch "${2:-}" ;;
  esac
fi
if [ "${1:-}" = /usr/bin/env ]; then
  [ -n "$mapped" ] || exit 74
  mapped_seen=false
  home_seen=false
  tmpdir_seen=false
  for arg in "$@"; do
    [ "$arg" != "$mapped" ] || mapped_seen=true
    case "$arg" in
      CODEX_HOME=/*) exit 75 ;;
      CODEX_HOME=.mind-state/codex-home) home_seen=true ;;
      TMPDIR=/private/tmp) tmpdir_seen=true ;;
      TMPDIR=*) exit 76 ;;
    esac
  done
  [ "$mapped_seen" = true ] || exit 74
  [ "$home_seen" = true ] || exit 75
  if [ "${FAKE_REQUIRE_TMPDIR:-}" = 1 ]; then
    [ "$tmpdir_seen" = true ] || exit 76
  fi
fi
case "${1:-}" in
  */packages/standalone/releases/*/bin/codex) [ -n "$mapped" ] && [ "$mapped" = "$1" ] || exit 74 ;;
esac
if [ "${1:-}" = sh ]; then
  count=$#
  eval "inside=\${$((count - 1))}"
  printf 'inside\n' > "$inside"
  exit 0
fi
exec "$@"
EOF
chmod +x "$BIN/ai-jail"

cat > "$BIN/pmset" <<'EOF'
#!/usr/bin/env bash
if [ "${2:-}" = batt ]; then
  printf "Now drawing from 'AC Power'\n"
else
  printf 'AC Power:\n sleep 0\n'
fi
EOF
chmod +x "$BIN/pmset"

(
  cd "$REPO"
  git init -q
  git config user.name Control
  git config user.email control@example.invalid
  git config commit.gpgsign false
  git remote add xy https://example.invalid/xy/grain
  git add .
  git update-index --add --cacheinfo \
    160000,99b87f20f1fdbd2fc216cb13c07bdd0531916d27,gratitude/grain-sketchbook
  git commit -q -m base
  git update-ref refs/remotes/xy/main HEAD
  mkdir -p gratitude/grain-sketchbook
  mkdir -p .mind-state/codex-home
  printf 'model = "gpt-5.6-sol"\n' > .mind-state/codex-home/config.toml
)

export HOME="$HOME_PEN"
export PATH="$BIN:/usr/bin:/bin"
export FAKE_LOG FAKE_STATUS_LOG FAKE_JAIL_LOG

run_launcher() {
  (cd "$REPO" && tools/l/chatgpt-mind.sh "$@")
}

run_rishi_launcher() {
  (cd "$REPO" && MIND_RISHI_BIN="$RISHI_BIN" "$RISHI_BIN" run tools/l/chatgpt-mind.rish "$@")
}

run_rishi_printer() {
  (cd "$REPO" && "$RISHI_BIN" run tools/l/print-mind-cardinal-prompt.rish)
}

run_rishi_handoff() {
  (cd "$REPO" && "$RISHI_BIN" run tools/l/launch-mind-cardinal-chapter.rish)
}

ELDER_SHA256="$(shasum -a 256 "$ELDER" | awk '{print $1}')"
[ "$ELDER_SHA256" = "$EXPECTED_ELDER_SHA256" ] \
  || { echo "FAIL: elder Claude launcher changed" >&2; exit 1; }
SOURCE_SHA256="$(shasum -a 256 "$SOURCE" | awk '{print $1}')"
[ "$SOURCE_SHA256" = "$EXPECTED_SOURCE_SHA256" ] \
  || { echo "FAIL: shell compatibility witness changed" >&2; exit 1; }

grep -F -- '--sandbox danger-full-access' "$SOURCE" >/dev/null
if grep -E -- '--full-auto|--ignore-rules|--ignore-user-config|dangerously-bypass' "$SOURCE" >/dev/null; then
  echo "FAIL: launcher carries a deprecated or rule-bypassing Codex option" >&2
  exit 1
fi

prompt="$(run_launcher print)"
printf '%s\n' "$prompt" | grep -F 'Begin this chapter as Mind' >/dev/null
printf '%s\n' "$prompt" | grep -F 'four facts are proven' >/dev/null
printf '%s\n' "$prompt" | grep -F 'ordinary write lane is `skate/` and `brushstroke/`' >/dev/null
printf '%s\n' "$prompt" | grep -F 'Caravan, Tally, and Scribe belong to Sound' >/dev/null
printf '%s\n' "$prompt" | grep -F 'Glow rune lowering and' >/dev/null
printf '%s\n' "$prompt" | grep -F 'outer AI jail remains the' >/dev/null
printf '%s\n' "$prompt" | grep -F 'A seated source-adaptation grant lets MIND consider one eligible non-Rye source per lap.' >/dev/null
printf '%s\n' "$prompt" | grep -F 'No booking means no conversion.' >/dev/null

dry="$(run_launcher once --dry-run)"
printf '%s\n' "$dry" | grep -F -- '--sandbox danger-full-access' >/dev/null
printf '%s\n' "$dry" | grep -F 'dry-run only; Codex will not be invoked' >/dev/null
[ ! -e "$FAKE_LOG" ] || { echo "FAIL: dry-run invoked Codex" >&2; exit 1; }

touch "$HOME_PEN/bad-plan"
if run_launcher once --dry-run >/dev/null 2>&1; then
  echo "FAIL: malformed outer-jail plan was accepted" >&2
  exit 1
fi
rm -f "$HOME_PEN/bad-plan"
[ ! -e "$FAKE_LOG" ] || { echo "FAIL: bad plan reached Codex" >&2; exit 1; }

run_launcher check >/dev/null

if run_launcher once >/dev/null 2>&1; then
  echo "FAIL: unarmed once was accepted" >&2
  exit 1
fi

mv "$REPO/.mind-state/codex-home/config.toml" "$PEN/config.saved"
if run_launcher once --arm-once >/dev/null 2>&1; then
  echo "FAIL: armed run accepted absent project-local Codex config" >&2
  exit 1
fi
mv "$PEN/config.saved" "$REPO/.mind-state/codex-home/config.toml"

if run_launcher once --arm-once >/dev/null 2>&1; then
  echo "FAIL: fake no-commit Codex lap reported success" >&2
  exit 1
fi
grep -F -- '--sandbox danger-full-access' "$FAKE_LOG" >/dev/null
if grep -E -- '--full-auto|--ignore-rules|--ignore-user-config|dangerously-bypass' "$FAKE_LOG" >/dev/null; then
  echo "FAIL: invoked Codex with a deprecated or rule-bypassing option" >&2
  exit 1
fi

: > "$FAKE_LOG"
mkdir "$REPO/.mind-state/run.lock"
if run_launcher once --arm-once >/dev/null 2>&1; then
  echo "FAIL: a held single-instance lock was ignored" >&2
  exit 1
fi
rmdir "$REPO/.mind-state/run.lock"
[ ! -s "$FAKE_LOG" ] || { echo "FAIL: held lock reached Codex" >&2; exit 1; }

run_launcher stop >/dev/null
if run_launcher loop --arm-loop --max-laps 2 >/dev/null 2>&1; then
  echo "FAIL: a present STOP file was ignored" >&2
  exit 1
fi
rm -f "$REPO/.mind-state/STOP"

: > "$FAKE_LOG"
export FAKE_CODEX_EXIT=9
if run_launcher loop --arm-loop --max-laps 3 --failure-ceiling 2 --backoff-seconds 0 \
  >/dev/null 2>&1
then
  echo "FAIL: failure ceiling did not open the circuit" >&2
  exit 1
fi
unset FAKE_CODEX_EXIT
[ "$(wc -l < "$FAKE_LOG" | tr -d ' ')" -eq 2 ] \
  || { echo "FAIL: circuit breaker did not stop after two failures" >&2; exit 1; }

: > "$FAKE_LOG"

shell_prompt="$PEN/shell.prompt"
rishi_prompt="$PEN/rishi.prompt"
printer_prompt="$PEN/printer.prompt"
run_launcher print > "$shell_prompt"
run_rishi_launcher print > "$rishi_prompt"
run_rishi_printer > "$printer_prompt"
cmp "$shell_prompt" "$rishi_prompt"
cmp "$shell_prompt" "$printer_prompt"

shell_help="$(run_launcher once --help)"
rishi_help="$(run_rishi_launcher once --help)"
for public_command in print check once loop stop; do
  printf '%s\n' "$shell_help" | grep -F "$public_command" >/dev/null
  printf '%s\n' "$rishi_help" | grep -F "$public_command" >/dev/null
done

shell_edge="$(run_launcher loop --dry-run --max-laps 24 --failure-ceiling 5 --backoff-seconds 300)"
rishi_edge="$(run_rishi_launcher loop --dry-run --max-laps 24 --failure-ceiling 5 --backoff-seconds 300)"
printf '%s\n' "$shell_edge" | grep -F 'bounded laps 24, failure ceiling 5, backoff 300 seconds' >/dev/null
printf '%s\n' "$rishi_edge" | grep -F 'bounded laps 24, failure ceiling 5, backoff 300 seconds' >/dev/null
for edge_args in \
  'loop --dry-run --max-laps 25' \
  'loop --dry-run --failure-ceiling 6' \
  'loop --dry-run --backoff-seconds 301'
do
  set -- $edge_args
  if run_launcher "$@" >/dev/null 2>&1; then
    echo "FAIL: shell launcher accepted the just-over bound: $edge_args" >&2
    exit 1
  fi
  if run_rishi_launcher "$@" >/dev/null 2>&1; then
    echo "FAIL: Rishi launcher accepted the just-over bound: $edge_args" >&2
    exit 1
  fi
done

mind_prompt="$REPO/recursion-prompts/versions/20260826-180017_chatgpt-mind-macos-loop.md"
mv "$mind_prompt" "$PEN/mind-prompt.saved"
{
  cat "$PEN/mind-prompt.saved"
  dd if=/dev/zero bs=1024 count=25 2>/dev/null | tr '\000' x
} > "$mind_prompt"
if run_launcher print >/dev/null 2>&1; then
  echo "FAIL: shell launcher accepted a prompt beyond its byte wall" >&2
  exit 1
fi
if run_rishi_launcher print >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher accepted a prompt beyond its byte wall" >&2
  exit 1
fi
mv "$PEN/mind-prompt.saved" "$mind_prompt"

printer_program="$PEN/printer.program"
sed '/^[[:space:]]*#/d' "$PRINTER_SOURCE" > "$printer_program"
if grep -E 'run-bounded|(^|[^-])run[[:space:]]|write-file|acquire-lock|codex|ai-jail|git|env[[:space:]]' "$printer_program" >/dev/null; then
  echo "FAIL: pure printer carries operational authority" >&2
  exit 1
fi
handoff_program="$PEN/handoff.program"
sed '/^[[:space:]]*#/d' "$HANDOFF_SOURCE" > "$handoff_program"
if grep -Ev '^[[:space:]]*(say[[:space:]]|$)' "$handoff_program" >/dev/null; then
  echo "FAIL: handoff carries authority beyond printing literal lines" >&2
  exit 1
fi
grep -F 'tools/l/print-mind-cardinal-prompt.rish' "$RISHI_SOURCE" >/dev/null
if grep -F 'tools/l/launch-mind-cardinal-chapter.rish' "$RISHI_SOURCE" >/dev/null; then
  echo "FAIL: operational launcher consumes the public handoff instead of the pure prompt" >&2
  exit 1
fi
launcher_program="$PEN/launcher.program"
sed '/^[[:space:]]*#/d' "$RISHI_SOURCE" > "$launcher_program"
if grep -F 'Begin this chapter as Mind' "$launcher_program" >/dev/null; then
  echo "FAIL: Rishi launcher duplicates the prompt body" >&2
  exit 1
fi
if grep -E 'chatgpt-mind\.sh|sh -c|--full-auto|--ignore-rules|--ignore-user-config|dangerously-bypass' "$launcher_program" >/dev/null; then
  echo "FAIL: Rishi launcher relays through shell or bypasses rules" >&2
  exit 1
fi

handoff_out="$PEN/mind-handoff.out"
handoff_commands="$PEN/mind-handoff.commands"
run_rishi_handoff > "$handoff_out"
grep '^GRAIN_ROOT=' "$handoff_out" > "$handoff_commands"

handoff_verdict() {
  candidate=$1
  [ "$(grep -c '^GRAIN_ROOT=' "$candidate")" -eq 8 ] || return 1
  [ "$(grep -c 'cd "\$GRAIN_ROOT"' "$candidate")" -eq 8 ] || return 1
  [ "$(grep -c '"\$GRAIN_ROOT/tools/l/chatgpt-mind.rish"' "$candidate")" -eq 5 ] || return 1
  [ "$(grep -c '"\$GRAIN_ROOT/rishi/bin/rishi" run ' "$candidate")" -eq 5 ] || return 1
  grep -F 'chatgpt-mind.rish" check)' "$candidate" >/dev/null || return 1
  grep -F 'chatgpt-mind.rish" once --arm-once)' "$candidate" >/dev/null || return 1
  grep -F 'chatgpt-mind.rish" loop --arm-loop --max-laps 3 --failure-ceiling 2 --backoff-seconds 15)' "$candidate" >/dev/null || return 1
  grep -F 'chatgpt-mind.rish" stop)' "$candidate" >/dev/null || return 1
  grep -F 'chatgpt-mind.rish" print)' "$candidate" >/dev/null || return 1
  ! grep -F 'chatgpt-mind.sh' "$candidate" >/dev/null
}

handoff_verdict "$handoff_commands" || {
  echo "FAIL: emitted MIND handoff lacks its exact quoted launcher contract" >&2
  exit 1
}
while IFS= read -r command_line; do
  printf '%s\n' "$command_line" | /bin/sh -n
  printf '%s\n' "$command_line" | /bin/zsh -n
done < "$handoff_commands"

plant_handoff() {
  planted=$1
  shift
  sed "$@" "$handoff_commands" > "$planted"
  if handoff_verdict "$planted"; then
    echo "FAIL: planted handoff drift escaped: $planted" >&2
    exit 1
  fi
}
plant_handoff "$PEN/handoff-wrong-path" 's@tools/l/chatgpt-mind\.rish@tools/l/missing-mind.rish@g'
plant_handoff "$PEN/handoff-unquoted-root" 's/"\$GRAIN_ROOT"/\$GRAIN_ROOT/g'
plant_handoff "$PEN/handoff-unarmed-loop" 's/ --arm-loop//'
plant_handoff "$PEN/handoff-unbounded-loop" 's/ --max-laps 3 --failure-ceiling 2 --backoff-seconds 15//'
plant_handoff "$PEN/handoff-shell-fallback" 's/chatgpt-mind\.rish/chatgpt-mind.sh/g'

SPACE_REPO="$PEN/repo with spaces"
SPACE_LOG="$PEN/space-handoff.log"
mkdir -p "$SPACE_REPO/sub dir" "$SPACE_REPO/tools/l" "$SPACE_REPO/tools" \
  "$SPACE_REPO/rye/bin" "$SPACE_REPO/rishi/bin" "$SPACE_REPO/vendor/zig-toolchain"
(
  cd "$SPACE_REPO"
  git init -q
)
SPACE_ROOT="$(cd "$SPACE_REPO" && pwd -P)"
cat > "$SPACE_REPO/tools/fetch-toolchain.sh" <<'EOF'
printf '%s\n' fetch-toolchain >> "$SPACE_LOG"
EOF
cat > "$SPACE_REPO/rye/bootstrap.sh" <<'EOF'
printf '%s\n' rye-bootstrap >> "$SPACE_LOG"
EOF
cat > "$SPACE_REPO/rye/bin/rye" <<'EOF'
#!/bin/sh
printf 'rye' >> "$SPACE_LOG"
for arg in "$@"; do printf ' <%s>' "$arg" >> "$SPACE_LOG"; done
printf '\n' >> "$SPACE_LOG"
EOF
cat > "$SPACE_REPO/rishi/bin/rishi" <<'EOF'
#!/bin/sh
printf 'rishi' >> "$SPACE_LOG"
for arg in "$@"; do printf ' <%s>' "$arg" >> "$SPACE_LOG"; done
printf '\n' >> "$SPACE_LOG"
EOF
chmod +x "$SPACE_REPO/rye/bin/rye" "$SPACE_REPO/rishi/bin/rishi"
export SPACE_LOG
for command_shell in /bin/sh /bin/zsh; do
  while IFS= read -r command_line; do
    (cd "$SPACE_REPO/sub dir" && "$command_shell" -c "$command_line")
  done < "$handoff_commands"
done
grep -Fx 'fetch-toolchain' "$SPACE_LOG" >/dev/null
grep -Fx 'rye-bootstrap' "$SPACE_LOG" >/dev/null
grep -F "rye <build> <$SPACE_ROOT/rishi/src/main.rye> <-femit-bin=$SPACE_ROOT/rishi/bin/rishi>" "$SPACE_LOG" >/dev/null
for command_name in check once loop stop print; do
  grep -F "rishi <run> <$SPACE_ROOT/tools/l/chatgpt-mind.rish> <$command_name>" "$SPACE_LOG" >/dev/null
done
grep -F '<once> <--arm-once>' "$SPACE_LOG" >/dev/null
grep -F '<loop> <--arm-loop> <--max-laps> <3> <--failure-ceiling> <2> <--backoff-seconds> <15>' "$SPACE_LOG" >/dev/null

rishi_dry="$(run_rishi_launcher once --dry-run)"
printf '%s\n' "$rishi_dry" | grep -F -- '--sandbox danger-full-access' >/dev/null
printf '%s\n' "$rishi_dry" | grep -F 'dry-run only; Codex will not be invoked' >/dev/null
[ ! -s "$FAKE_LOG" ] || { echo "FAIL: Rishi dry-run invoked Codex" >&2; exit 1; }

touch "$HOME_PEN/bad-plan"
if run_rishi_launcher once --dry-run >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher accepted malformed outer-jail plan" >&2
  exit 1
fi
rm -f "$HOME_PEN/bad-plan"
[ ! -s "$FAKE_LOG" ] || { echo "FAIL: Rishi bad plan reached Codex" >&2; exit 1; }

export FAKE_REQUIRE_TMPDIR=1
run_rishi_launcher check >/dev/null
[ -s "$FAKE_STATUS_LOG" ] \
  || { echo "FAIL: Rishi check did not prove isolated login status" >&2; exit 1; }
grep -F -- "--map $REAL_CODEX --exec" "$FAKE_JAIL_LOG" >/dev/null \
  || { echo "FAIL: Rishi jail did not map the canonical executable" >&2; exit 1; }
grep -F -- "/usr/bin/env CODEX_HOME=.mind-state/codex-home TMPDIR=/private/tmp $REAL_CODEX login status" "$FAKE_JAIL_LOG" >/dev/null \
  || { echo "FAIL: Rishi jail did not prove the repository-relative isolated login and exact temporary root" >&2; exit 1; }
if (
  cd "$REPO"
  "$BIN/ai-jail" --map "$REAL_CODEX" --exec --private-home --no-save-config \
    /usr/bin/env "CODEX_HOME=$REPO_CANONICAL/.mind-state/codex-home" TMPDIR=/private/tmp \
    "$REAL_CODEX" login status
) >/dev/null 2>&1; then
  echo "FAIL: absolute isolated Codex home did not reproduce the canonicalization refusal" >&2
  exit 1
fi
unset FAKE_REQUIRE_TMPDIR
if (
  cd "$REPO"
  "$BIN/ai-jail" --map "$REAL_CODEX" --exec --private-home --no-save-config \
    /usr/bin/env CODEX_HOME=.mind-state/codex-home TMPDIR=/private/tmp-decoy \
    "$REAL_CODEX" login status
) >/dev/null 2>&1; then
  echo "FAIL: decoy Codex TMPDIR assignment escaped the exact temporary-root gate" >&2
  exit 1
fi

plan_verdict() {
  candidate=$1
  canonical=$2
  [ "$(grep -Fxc "(allow file-read* (literal \"$canonical\"))" "$candidate")" -eq 1 ] || return 1
  [ "$(grep -Fxc "(deny file-write* (literal \"$canonical\"))" "$candidate")" -eq 1 ] || return 1
}

captured_plan="$REPO/.mind-state/preflight/jail-plan.out"
plan_verdict "$captured_plan" "$REAL_CODEX" || {
  echo "FAIL: real-format fake plan lacks the exact canonical read-only mapping" >&2
  exit 1
}
if grep -F "$CURRENT_CODEX" "$captured_plan" >/dev/null; then
  echo "FAIL: real-format fake plan preserved the one-hop symlink spelling" >&2
  exit 1
fi
if plan_verdict "$captured_plan" "$CURRENT_CODEX"; then
  echo "FAIL: the prior one-hop verifier accepted ai-jail's canonical plan" >&2
  exit 1
fi

plan_pen="$PEN/plan-verdicts"
mkdir -p "$plan_pen"
space_codex="$PEN/release with spaces/bin/codex"
printf '(allow file-read* (literal "%s"))\n(deny file-write* (literal "%s"))\n' \
  "$space_codex" "$space_codex" > "$plan_pen/space"
plan_verdict "$plan_pen/space" "$space_codex" || {
  echo "FAIL: exact plan verifier rejected an argv-safe path with spaces" >&2
  exit 1
}

plan_refusal() {
  candidate=$1
  canonical=$2
  label=$3
  if plan_verdict "$candidate" "$canonical"; then
    echo "FAIL: exact plan verifier accepted $label" >&2
    exit 1
  fi
}

printf '(allow file-read* (literal "%s-extra"))\n(deny file-write* (literal "%s-extra"))\n' \
  "$REAL_CODEX" "$REAL_CODEX" > "$plan_pen/prefix"
plan_refusal "$plan_pen/prefix" "$REAL_CODEX" 'a prefix collision'
printf '(allow file-read* (literal "%s-copy"))\n(deny file-write* (literal "%s-copy"))\n' \
  "$REAL_CODEX" "$REAL_CODEX" > "$plan_pen/wrong-destination"
plan_refusal "$plan_pen/wrong-destination" "$REAL_CODEX" 'a wrong destination'
printf '(allow file-read* file-write* (literal "%s"))\n' "$REAL_CODEX" > "$plan_pen/read-write"
plan_refusal "$plan_pen/read-write" "$REAL_CODEX" 'a read-write mapping'
printf '(allow file-read* (literal "codex"))\n(deny file-write* (literal "codex"))\n' > "$plan_pen/basename"
plan_refusal "$plan_pen/basename" "$REAL_CODEX" 'a basename-only decoy'
printf '(allow file-read* (literal "%s"))\n(deny file-write* (literal "%s"))\n' \
  "$CURRENT_CODEX" "$CURRENT_CODEX" > "$plan_pen/symlink-source"
plan_refusal "$plan_pen/symlink-source" "$REAL_CODEX" 'a noncanonical symlink source'
: > "$plan_pen/omitted"
plan_refusal "$plan_pen/omitted" "$REAL_CODEX" 'an omitted mapping'
quoted_codex="$PEN/release\"quoted/bin/codex"
printf '(allow file-read* (literal "%s"))\n(deny file-write* (literal "%s"))\n' \
  "$quoted_codex" "$quoted_codex" | sed 's/"quoted/\\"quoted/g' > "$plan_pen/escaped-quote"
plan_refusal "$plan_pen/escaped-quote" "$quoted_codex" 'an escaped-quote spelling'

: > "$FAKE_LOG"
: > "$FAKE_STATUS_LOG"
export FAKE_CODEX_LOGIN_EXIT=7
if run_rishi_launcher check >"$PEN/login-absent.out" 2>"$PEN/login-absent.err"; then
  echo "FAIL: Rishi check accepted absent isolated login" >&2
  exit 1
fi
grep -F 'isolated Codex login is absent or unreadable' "$PEN/login-absent.err" >/dev/null
if run_rishi_launcher once --arm-once >"$PEN/login-once.out" 2>"$PEN/login-once.err"; then
  echo "FAIL: Rishi once accepted absent isolated login" >&2
  exit 1
fi
unset FAKE_CODEX_LOGIN_EXIT
[ ! -s "$FAKE_LOG" ] \
  || { echo "FAIL: absent login reached the fake model command" >&2; exit 1; }
[ "$(wc -l < "$FAKE_STATUS_LOG" | tr -d ' ')" -eq 2 ] \
  || { echo "FAIL: login refusal did not use the status command exactly once per attempt" >&2; exit 1; }

: > "$FAKE_LOG"
export FAKE_CODEX_STATUS_BLOCKS=2
if run_rishi_launcher check >"$PEN/login-overflow.out" 2>"$PEN/login-overflow.err"; then
  echo "FAIL: Rishi check accepted login-status output beyond its byte wall" >&2
  exit 1
fi
unset FAKE_CODEX_STATUS_BLOCKS
grep -F 'isolated Codex login status crossed its byte wall' "$PEN/login-overflow.err" >/dev/null
[ ! -s "$FAKE_LOG" ] \
  || { echo "FAIL: overflowing login status reached the fake model command" >&2; exit 1; }

if run_rishi_launcher once >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher accepted unarmed once" >&2
  exit 1
fi

mv "$REPO/.mind-state/codex-home/config.toml" "$PEN/rishi-config.saved"
if run_rishi_launcher once --arm-once >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher accepted absent project-local Codex config" >&2
  exit 1
fi
mv "$PEN/rishi-config.saved" "$REPO/.mind-state/codex-home/config.toml"

: > "$FAKE_LOG"
export FAKE_RECORD_PWD=1
if run_rishi_launcher once --arm-once >"$PEN/no-commit.out" 2>"$PEN/no-commit.err"; then
  echo "FAIL: Rishi fake no-commit lap reported success" >&2
  exit 1
fi
grep -F 'phase=git-postcondition reason=no-commit' "$PEN/no-commit.err" >/dev/null \
  || { echo "FAIL: Rishi outer once swallowed the no-commit phase" >&2; exit 1; }
[ ! -d "$REPO/.mind-state/run.lock" ] \
  || { echo "FAIL: failed Rishi lap left its run lock" >&2; exit 1; }
grep -F -- '--sandbox danger-full-access' "$FAKE_LOG" >/dev/null
rishi_exec_invocation="$(grep -F -- "CODEX_HOME=.mind-state/codex-home TMPDIR=/private/tmp $REAL_CODEX exec" "$FAKE_JAIL_LOG" | tail -n 1)"
[ -n "$rishi_exec_invocation" ] \
  || { echo "FAIL: Rishi Codex execution omitted the exact private temporary root" >&2; exit 1; }
grep -Fx "pwd=$REPO_CANONICAL" "$FAKE_LOG" >/dev/null \
  || { echo "FAIL: ai-jail did not seat Codex in the repository root" >&2; exit 1; }
unset FAKE_RECORD_PWD
if printf '%s\n' "$rishi_exec_invocation" | grep -F -- ' --cd ' >/dev/null; then
  echo "FAIL: Rishi Codex execution retained the absolute checkout argument" >&2
  exit 1
fi

: > "$FAKE_LOG"
export FAKE_CODEX_LIVE=1 FAKE_CODEX_LIVE_DELAY=1
run_rishi_launcher once --arm-once >"$PEN/live-relay.out" 2>"$PEN/live-relay.err" &
live_pid=$!
live_wait=0
while ! grep -F 'synthetic bounded progress' "$PEN/live-relay.err" >/dev/null 2>&1; do
  live_wait=$((live_wait + 1))
  if [ "$live_wait" -ge 200 ]; then
    kill -TERM "$live_pid" 2>/dev/null || true
    wait "$live_pid" 2>/dev/null || true
    echo "FAIL: bounded progress did not reach the terminal while the child lived" >&2
    exit 1
  fi
  sleep 0.02
done
if ! kill -0 "$live_pid" 2>/dev/null; then
  echo "FAIL: bounded progress appeared only after the child completed" >&2
  exit 1
fi
if wait "$live_pid"; then
  echo "FAIL: synthetic live-relay lap without a commit reported success" >&2
  exit 1
fi
unset FAKE_CODEX_LIVE FAKE_CODEX_LIVE_DELAY
[ "$(grep -Fc 'synthetic bounded final' "$PEN/live-relay.out")" -eq 1 ] \
  || { echo "FAIL: final stdout was not relayed exactly once" >&2; exit 1; }
[ "$(grep -Fc 'synthetic bounded progress' "$PEN/live-relay.err")" -eq 1 ] \
  || { echo "FAIL: progress stderr was not relayed exactly once" >&2; exit 1; }
[ "$(grep -Fc 'synthetic bounded final' "$REPO/.mind-state/logs/lap-1.stdout")" -eq 1 ] \
  || { echo "FAIL: final stdout did not remain in its bounded lap file" >&2; exit 1; }
[ "$(grep -Fc 'synthetic bounded progress' "$REPO/.mind-state/logs/lap-1.stderr")" -eq 1 ] \
  || { echo "FAIL: progress stderr did not remain in its bounded lap file" >&2; exit 1; }
[ "$(stat -f '%Lp' "$REPO/.mind-state/logs/lap-1.stdout")" = 600 ]
[ "$(stat -f '%Lp' "$REPO/.mind-state/logs/lap-1.stderr")" = 600 ]
grep -F 'phase=git-postcondition reason=no-commit' "$PEN/live-relay.err" >/dev/null \
  || { echo "FAIL: live relay hid the typed postcondition refusal" >&2; exit 1; }
if grep -E -- '--full-auto|--ignore-rules|--ignore-user-config|dangerously-bypass' "$FAKE_LOG" >/dev/null; then
  echo "FAIL: Rishi launcher invoked Codex with a bypassing option" >&2
  exit 1
fi

: > "$FAKE_LOG"
export FAKE_CODEX_OUTPUT_BLOCKS=300
if run_rishi_launcher once --arm-once >"$PEN/output-overflow.out" 2>"$PEN/output-overflow.err"; then
  echo "FAIL: Rishi launcher accepted child output beyond its byte wall" >&2
  exit 1
fi
unset FAKE_CODEX_OUTPUT_BLOCKS
grep -F 'phase=codex-output reason=byte-wall' "$PEN/output-overflow.err" >/dev/null \
  || { echo "FAIL: Rishi outer once swallowed the output-overflow phase" >&2; exit 1; }
overflow_bytes="$(wc -c < "$REPO/.mind-state/logs/lap-1.stdout" | tr -d ' ')"
[ "$overflow_bytes" -eq 1048576 ] \
  || {
    echo "FAIL: Rishi output wall held $overflow_bytes bytes, not its exact ceiling" >&2
    sed -n '1,20p' "$REPO/.mind-state/logs/supervisor.err" >&2 || true
    sed -n '1,20p' "$REPO/.mind-state/logs/lap-1.stderr" >&2 || true
    tail -n 5 "$FAKE_LOG" >&2 || true
    tail -n 5 "$FAKE_JAIL_LOG" >&2 || true
    exit 1
  }
[ ! -d "$REPO/.mind-state/run.lock" ] \
  || { echo "FAIL: output overflow left the Rishi run lock" >&2; exit 1; }

: > "$FAKE_LOG"
mkdir "$REPO/.mind-state/run.lock"
if run_rishi_launcher once --arm-once >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher ignored a held lock" >&2
  exit 1
fi
rmdir "$REPO/.mind-state/run.lock"
[ ! -s "$FAKE_LOG" ] || { echo "FAIL: Rishi held lock reached Codex" >&2; exit 1; }

run_rishi_launcher stop >/dev/null
if run_rishi_launcher loop --arm-loop --max-laps 2 >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher ignored STOP" >&2
  exit 1
fi
rm -f "$REPO/.mind-state/STOP"

: > "$FAKE_LOG"
touch "$REPO/.mind-state/CUSTODY"
if run_rishi_launcher once --arm-once >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher ignored CUSTODY" >&2
  exit 1
fi
rm -f "$REPO/.mind-state/CUSTODY"
[ ! -s "$FAKE_LOG" ] || { echo "FAIL: Rishi CUSTODY gate reached Codex" >&2; exit 1; }

: > "$FAKE_LOG"
printf 'dirty\n' > "$REPO/mind-control-dirty"
if run_rishi_launcher check >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher accepted a dirty repository" >&2
  exit 1
fi
rm -f "$REPO/mind-control-dirty"
[ ! -s "$FAKE_LOG" ] || { echo "FAIL: Rishi dirty-tree gate reached Codex" >&2; exit 1; }

mkdir "$PEN/outside-state"
ln -s "$PEN/outside-state" "$REPO/state-link"
if (
  cd "$REPO"
  exec env MIND_STATE_DIR="$REPO/state-link" MIND_RISHI_BIN="$RISHI_BIN" \
    "$RISHI_BIN" run tools/l/chatgpt-mind.rish print
) >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher accepted a symlink state directory" >&2
  exit 1
fi
rm -f "$REPO/state-link"

mv "$REPO/.mind-state/codex-home/config.toml" "$PEN/rishi-config-target"
ln -s "$PEN/rishi-config-target" "$REPO/.mind-state/codex-home/config.toml"
if run_rishi_launcher once --arm-once >/dev/null 2>&1; then
  echo "FAIL: Rishi launcher accepted a symlink project config" >&2
  exit 1
fi
rm -f "$REPO/.mind-state/codex-home/config.toml"
mv "$PEN/rishi-config-target" "$REPO/.mind-state/codex-home/config.toml"

: > "$FAKE_LOG"
export FAKE_CODEX_EXIT=9
if run_rishi_launcher once --arm-once >"$PEN/codex-nonzero.out" 2>"$PEN/codex-nonzero.err"; then
  echo "FAIL: Rishi launcher accepted a nonzero Codex child" >&2
  exit 1
fi
grep -F 'phase=codex-exec reason=nonzero' "$PEN/codex-nonzero.err" >/dev/null \
  || { echo "FAIL: Rishi outer once swallowed the Codex nonzero phase" >&2; exit 1; }
grep -F 'enclosed Codex lap exited nonzero code=9' "$REPO/.mind-state/logs/supervisor.err" >/dev/null \
  || { echo "FAIL: Rishi private detail discarded the Codex child exit code" >&2; exit 1; }
: > "$FAKE_LOG"
if run_rishi_launcher loop --arm-loop --max-laps 3 --failure-ceiling 2 --backoff-seconds 0 \
  >"$PEN/circuit.out" 2>"$PEN/circuit.err"
then
  echo "FAIL: Rishi failure ceiling did not open the circuit" >&2
  exit 1
fi
unset FAKE_CODEX_EXIT
grep -F 'phase=codex-exec reason=nonzero' "$PEN/circuit.err" >/dev/null \
  || { echo "FAIL: Rishi circuit swallowed the last Codex failure phase" >&2; exit 1; }
[ "$(grep -c -- '--sandbox danger-full-access' "$FAKE_LOG")" -eq 2 ] \
  || { echo "FAIL: Rishi circuit did not stop after two failures" >&2; exit 1; }

: > "$FAKE_LOG"
FAKE_CODEX_PID="$PEN/fake-codex.pid"
export FAKE_CODEX_PID FAKE_CODEX_SLEEP=30
(
  cd "$REPO"
  exec env MIND_RISHI_BIN="$RISHI_BIN" \
    "$RISHI_BIN" run tools/l/chatgpt-mind.rish once --arm-once
) >"$PEN/signal.out" 2>"$PEN/signal.err" &
rishi_pid=$!
signal_wait=0
while [ ! -f "$FAKE_CODEX_PID" ] || [ ! -d "$REPO/.mind-state/run.lock" ]; do
  signal_wait=$((signal_wait + 1))
  if [ "$signal_wait" -ge 200 ]; then
    kill -TERM "$rishi_pid" 2>/dev/null || true
    echo "FAIL: Rishi signal fixture did not reach its supervised child" >&2
    exit 1
  fi
  sleep 0.02
done
kill -TERM "$rishi_pid"
if wait "$rishi_pid"; then
  echo "FAIL: signalled Rishi launcher returned success" >&2
  exit 1
fi
unset FAKE_CODEX_SLEEP
[ ! -d "$REPO/.mind-state/run.lock" ] \
  || { echo "FAIL: signalled Rishi launcher left its run lock" >&2; exit 1; }
codex_pid="$(cat "$FAKE_CODEX_PID")"
if kill -0 "$codex_pid" 2>/dev/null; then
  kill -KILL "$codex_pid" 2>/dev/null || true
  echo "FAIL: signalled Rishi launcher orphaned its child" >&2
  exit 1
fi

cp "$PRINTER_SOURCE" "$PEN/printer-drift.rish"
printf '%s\n' 'say "planted printer drift"' >> "$PEN/printer-drift.rish"
if (cd "$REPO" && "$RISHI_BIN" run "$PEN/printer-drift.rish") | cmp - "$shell_prompt" >/dev/null 2>&1; then
  echo "FAIL: planted printer drift escaped byte comparison" >&2
  exit 1
fi

cp "$PRINTER_SOURCE" "$PEN/printer-authority.rish"
printf '%s\n' 'let planted = run ["true"]' >> "$PEN/printer-authority.rish"
sed '/^[[:space:]]*#/d' "$PEN/printer-authority.rish" > "$PEN/printer-authority.program"
if ! grep -E '(^|[^-])run[[:space:]]' "$PEN/printer-authority.program" >/dev/null; then
  echo "FAIL: planted printer authority escaped the static refusal" >&2
  exit 1
fi

cp "$RISHI_SOURCE" "$PEN/launcher-drift.rish"
sed -i.bak 's/danger-full-access/workspace-write/g' "$PEN/launcher-drift.rish"
if grep -F -- '--sandbox danger-full-access' "$PEN/launcher-drift.rish" >/dev/null; then
  echo "FAIL: planted Rishi launcher drift escaped option check" >&2
  exit 1
fi

cp "$RISHI_SOURCE" "$PEN/relay-drift.rish"
sed -i.bak 's/stdout-relay: true, stderr-relay: true/stdout-relay: false, stderr-relay: false/g' "$PEN/relay-drift.rish"
if [ "$(grep -Fc 'stdout-relay: true, stderr-relay: true' "$PEN/relay-drift.rish")" -eq 2 ]; then
  echo "FAIL: planted live-relay drift escaped launcher check" >&2
  exit 1
fi

cp "$SOURCE" "$PEN/shell-drift.sh"
printf '%s\n' '# planted shell drift' >> "$PEN/shell-drift.sh"
[ "$(shasum -a 256 "$PEN/shell-drift.sh" | awk '{print $1}')" != "$EXPECTED_SOURCE_SHA256" ] \
  || { echo "FAIL: planted shell drift escaped source hash" >&2; exit 1; }

echo "GREEN chatgpt-mind-loop: shell witness preserved; pure prompt is byte-identical; public handoff survives spaces; Rishi maps the resolved CLI, carries exact private TMPDIR, inherits the jailed repository root without absolute --cd, gates isolated login before service work, relays bounded progress and final output exactly once while retaining private files and typed phases, and owns jail, lock, STOP/CUSTODY, circuit, and signal behavior; planted handoff, printer, launcher, relay, and shell drift are caught"
