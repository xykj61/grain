#!/bin/sh

set -eu

if [ "$(uname -s 2>/dev/null || true)" != Darwin ]; then
  echo "SKIP chatgpt-mind-real-plan: macOS ai-jail plan is unavailable"
  exit 0
fi

AI_JAIL=$(command -v ai-jail 2>/dev/null || true)
CODEX=$(command -v codex 2>/dev/null || true)
GIT_LINK=/opt/homebrew/bin/git
GIT_EXPECTED=/opt/homebrew/Cellar/git/2.53.0_1/bin/git
GIT_PCRE=/opt/homebrew/Cellar/pcre2/10.47_1/lib/libpcre2-8.0.dylib
GIT_INTL=/opt/homebrew/Cellar/gettext/1.0/lib/libintl.8.dylib
if [ -z "$AI_JAIL" ] || [ -z "$CODEX" ] || [ ! -x /bin/realpath ] || [ ! -x "$GIT_LINK" ]; then
  echo "SKIP chatgpt-mind-real-plan: ai-jail, Codex, Homebrew Git, or /bin/realpath is unavailable"
  exit 0
fi

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
GIT=$(/bin/realpath "$GIT_LINK")
[ "$GIT" = "$GIT_EXPECTED" ] || {
  echo "FAIL chatgpt-mind-real-plan: canonical Homebrew Git target drifted" >&2
  exit 1
}
[ -f "$GIT" ] && [ -x "$GIT" ] && [ ! -L "$GIT" ] || {
  echo "FAIL chatgpt-mind-real-plan: canonical Homebrew Git is not a regular executable" >&2
  exit 1
}
[ "$("$GIT" --version)" = 'git version 2.53.0' ] || {
  echo "FAIL chatgpt-mind-real-plan: canonical Homebrew Git version drifted" >&2
  exit 1
}
[ "$(/bin/realpath /opt/homebrew/opt/pcre2/lib/libpcre2-8.0.dylib)" = "$GIT_PCRE" ] || {
  echo "FAIL chatgpt-mind-real-plan: Homebrew Git PCRE2 runtime drifted" >&2
  exit 1
}
[ "$(/bin/realpath /opt/homebrew/opt/gettext/lib/libintl.8.dylib)" = "$GIT_INTL" ] || {
  echo "FAIL chatgpt-mind-real-plan: Homebrew Git gettext runtime drifted" >&2
  exit 1
}
[ -f "$GIT_PCRE" ] && [ ! -L "$GIT_PCRE" ] && [ -f "$GIT_INTL" ] && [ ! -L "$GIT_INTL" ] || {
  echo "FAIL chatgpt-mind-real-plan: Homebrew Git runtime closure is not regular" >&2
  exit 1
}
[ -d "$ROOT/.git" ] && [ ! -L "$ROOT/.git" ] || {
  echo "FAIL chatgpt-mind-real-plan: checkout is not a full standalone clone" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" rev-parse --path-format=absolute --git-dir)" = "$ROOT/.git" ] || {
  echo "FAIL chatgpt-mind-real-plan: Git administration escapes the clone" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" rev-parse --path-format=absolute --git-common-dir)" = "$ROOT/.git" ] || {
  echo "FAIL chatgpt-mind-real-plan: Git common administration escapes the clone" >&2
  exit 1
}

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
"$AI_JAIL" --dry-run --map "$CANONICAL" --map "$GIT" --map "$GIT_PCRE" --map "$GIT_INTL" --exec --private-home --no-save-config \
  /usr/bin/env CODEX_HOME=.mind-state/codex-home TMPDIR=/private/tmp \
  "$CANONICAL" login status >"$PLAN" 2>"$ERR"
cat "$ERR" >>"$PLAN"

ALLOW="(allow file-read* (literal \"$CANONICAL\"))"
DENY="(deny file-write* (literal \"$CANONICAL\"))"
[ "$(grep -Fxc "$ALLOW" "$PLAN")" -eq 1 ] || {
  echo "FAIL chatgpt-mind-real-plan: exact canonical read mapping is absent or ambiguous" >&2
  exit 1
}
GIT_ALLOW="(allow file-read* (literal \"$GIT\"))"
GIT_DENY="(deny file-write* (literal \"$GIT\"))"
[ "$(grep -Fxc "$GIT_ALLOW" "$PLAN")" -eq 1 ] || {
  echo "FAIL chatgpt-mind-real-plan: exact Homebrew Git read mapping is absent or ambiguous" >&2
  exit 1
}
[ "$(grep -Fxc "$GIT_DENY" "$PLAN")" -eq 1 ] || {
  echo "FAIL chatgpt-mind-real-plan: exact Homebrew Git write denial is absent or ambiguous" >&2
  exit 1
}
if grep -E '/usr/bin/git|/var/select|/\.git/worktrees/' "$PLAN" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: plan admitted Apple Git, selector state, or external worktree administration" >&2
  exit 1
fi
for runtime_path in "$GIT_PCRE" "$GIT_INTL"; do
  runtime_allow="(allow file-read* (literal \"$runtime_path\"))"
  runtime_deny="(deny file-write* (literal \"$runtime_path\"))"
  [ "$(grep -Fxc "$runtime_allow" "$PLAN")" -eq 1 ] || {
    echo "FAIL chatgpt-mind-real-plan: exact Homebrew Git runtime read mapping is absent or ambiguous" >&2
    exit 1
  }
  [ "$(grep -Fxc "$runtime_deny" "$PLAN")" -eq 1 ] || {
    echo "FAIL chatgpt-mind-real-plan: exact Homebrew Git runtime write denial is absent or ambiguous" >&2
    exit 1
  }
done
if grep -E '\(allow file-read\* \(subpath "/opt/homebrew/(Cellar/(pcre2|gettext)|opt/(pcre2|gettext))' "$PLAN" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: Homebrew Git runtime mapping widened to a directory" >&2
  exit 1
fi
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

GIT_PATH=PATH=/opt/homebrew/Cellar/git/2.53.0_1/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
GIT_ID=GRAIN_MIND_GIT=$GIT
GIT_DYLD=DYLD_LIBRARY_PATH=/opt/homebrew/Cellar/pcre2/10.47_1/lib:/opt/homebrew/Cellar/gettext/1.0/lib
GIT_NO_SYSTEM=GIT_CONFIG_NOSYSTEM=1
GIT_NO_GLOBAL=GIT_CONFIG_GLOBAL=/dev/null
run_in_jail() {
  "$AI_JAIL" --map "$CANONICAL" --map "$GIT" --map "$GIT_PCRE" --map "$GIT_INTL" --exec --private-home --no-save-config "$@"
}
run_git_in_jail() {
  run_in_jail /usr/bin/env "$GIT_PATH" "$GIT_ID" "$GIT_DYLD" "$GIT_NO_SYSTEM" "$GIT_NO_GLOBAL" "$@"
}
run_git_in_jail "$GIT" --version >"$PEN/git-version" 2>"$PEN/git-version.err"
[ "$(cat "$PEN/git-version")" = 'git version 2.53.0' ] || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Homebrew Git identity drifted" >&2
  exit 1
}
run_git_in_jail "$GIT" -C "$ROOT" status --porcelain --untracked-files=normal --ignore-submodules=none >"$PEN/status" 2>"$PEN/status.err"
[ ! -s "$PEN/status" ] || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git found a dirty clone" >&2
  exit 1
}
run_git_in_jail "$GIT" -C "$ROOT" worktree list --porcelain >"$PEN/worktrees" 2>"$PEN/worktrees.err"
grep -Fx "worktree $ROOT" "$PEN/worktrees" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git did not report the standalone worktree" >&2
  exit 1
}
run_git_in_jail "$GIT" -C "$ROOT" rev-list --count HEAD..xy/main >"$PEN/behind" 2>"$PEN/behind.err"
[ "$(cat "$PEN/behind")" = 0 ] || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git found unintegrated xy/main commits" >&2
  exit 1
}
# The real Good/valid verification remains an operator-side Git check. Inside
# the private jail, prove the signed commit envelope without exposing a keyring.
run_git_in_jail "$GIT" -C "$ROOT" cat-file commit HEAD >"$PEN/head-commit" 2>"$PEN/head-commit.err"
grep -F 'gpgsig -----BEGIN PGP SIGNATURE-----' "$PEN/head-commit" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git did not retain the HEAD signature envelope" >&2
  exit 1
}
run_git_in_jail "$GIT" -C "$ROOT" merge-base --is-ancestor xy/main HEAD
run_git_in_jail "$GIT" -C "$ROOT" rev-list --count xy/main..HEAD >"$PEN/ahead" 2>"$PEN/ahead.err"
case "$(cat "$PEN/ahead")" in
  ''|*[!0-9]*) echo "FAIL chatgpt-mind-real-plan: enclosed one-commit arithmetic was not numeric" >&2; exit 1 ;;
esac

echo "GREEN chatgpt-mind-real-plan: ai-jail maps canonical Codex and Homebrew Git read-only; the full clone holds Git administration inside its fence; enclosed status, worktree, xy divergence, signature-envelope, and one-commit arithmetic execute without Apple Git or /var/select"
