#!/bin/sh

set -eu

if [ "$(uname -s 2>/dev/null || true)" != Darwin ]; then
  echo "SKIP chatgpt-mind-real-plan: macOS ai-jail plan is unavailable"
  exit 0
fi

AI_JAIL=$(command -v ai-jail 2>/dev/null || true)
CODEX=$(command -v codex 2>/dev/null || true)
if [ -z "$AI_JAIL" ] || [ -z "$CODEX" ] || [ ! -x /bin/realpath ]; then
  echo "SKIP chatgpt-mind-real-plan: ai-jail, Codex, or /bin/realpath is unavailable"
  exit 0
fi

CANONICAL=$(/bin/realpath "$CODEX")
case "$CANONICAL" in
  /*) ;;
  *) echo "FAIL chatgpt-mind-real-plan: canonical Codex path is not absolute" >&2; exit 1 ;;
esac
[ -x "$CANONICAL" ] || {
  echo "FAIL chatgpt-mind-real-plan: canonical Codex path is not executable" >&2
  exit 1
}
[ ! -L "$CANONICAL" ] || {
  echo "FAIL chatgpt-mind-real-plan: canonical Codex path remains a symlink" >&2
  exit 1
}
case "$CANONICAL" in
  *'"'*)
    echo "FAIL chatgpt-mind-real-plan: canonical Codex path needs unsupported quote encoding" >&2
    exit 1
    ;;
esac

PEN=$(mktemp -d "${TMPDIR:-/tmp}/chatgpt-mind-real-plan.XXXXXX")
trap 'rm -rf "$PEN"' EXIT HUP INT TERM
PLAN="$PEN/plan"
ERR="$PEN/err"
"$AI_JAIL" --dry-run --map "$CANONICAL" --exec --private-home --no-save-config \
  /usr/bin/env CODEX_HOME=.mind-state/codex-home TMPDIR=/private/tmp \
  "$CANONICAL" login status >"$PLAN" 2>"$ERR"
cat "$ERR" >>"$PLAN"

ALLOW="(allow file-read* (literal \"$CANONICAL\"))"
DENY="(deny file-write* (literal \"$CANONICAL\"))"
[ "$(grep -Fxc "$ALLOW" "$PLAN")" -eq 1 ] || {
  echo "FAIL chatgpt-mind-real-plan: exact canonical read mapping is absent or ambiguous" >&2
  exit 1
}
[ "$(grep -Fxc "$DENY" "$PLAN")" -eq 1 ] || {
  echo "FAIL chatgpt-mind-real-plan: exact canonical write denial is absent or ambiguous" >&2
  exit 1
}

USERS_METADATA='(allow file-read-metadata (literal "/Users"))'
REQUIREMENTS_READ='(allow file-read* (literal "/etc/codex/requirements.toml"))'
REQUIREMENTS_WRITE_DENY='(deny file-write* (literal "/etc/codex/requirements.toml"))'
for required_rule in "$USERS_METADATA" "$REQUIREMENTS_READ" "$REQUIREMENTS_WRITE_DENY"; do
  [ "$(grep -Fxc "$required_rule" "$PLAN")" -eq 1 ] || {
    echo "FAIL chatgpt-mind-real-plan: narrow Codex compatibility rule is absent or ambiguous" >&2
    exit 1
  }
done
for forbidden_rule in \
  '(allow file-read* (literal "/Users"))' \
  '(allow file-read* (subpath "/Users"))' \
  '(allow file-read-metadata (subpath "/Users"))' \
  '(allow file-read-metadata (literal "/UsersX"))' \
  '(allow file-write* (literal "/Users"))' \
  '(allow file-write* (subpath "/Users"))' \
  '(allow file-read* (literal "/dev/dtracehelper"))' \
  '(allow file-write* (literal "/dev/dtracehelper"))'
do
  if grep -Fx "$forbidden_rule" "$PLAN" >/dev/null; then
    echo "FAIL chatgpt-mind-real-plan: broad or decoy compatibility rule escaped" >&2
    exit 1
  fi
done

echo "GREEN chatgpt-mind-real-plan: ai-jail maps one canonical Codex executable read-only, retains exact managed requirements rules, and grants only literal /Users metadata for private-home Codex startup"
