#!/bin/sh
# FOSSIL -- Class M, prepped 20260906.114734 for the mitra shed; the cut stays RED until circled.
# Living mutant: tools/l/fleet-loop.sh reading construction/fleet-roster.kyri, with
# tools/l/fleet_watch.sh above it. Row and reasons: construction/SHRED_PREP.md.

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
GPG_LINK=/opt/homebrew/bin/gpg
GPG_EXPECTED=/opt/homebrew/Cellar/gnupg/2.5.18/bin/gpg
if [ -z "$AI_JAIL" ] || [ -z "$CODEX" ] || [ ! -x /bin/realpath ] \
  || [ ! -x "$GIT_LINK" ] || [ ! -x "$GPG_LINK" ]; then
  echo "SKIP chatgpt-mind-real-plan: ai-jail, Codex, Homebrew Git, host GPG, or /bin/realpath is unavailable"
  exit 0
fi

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
GIT=$(/bin/realpath "$GIT_LINK")
GPG=$(/bin/realpath "$GPG_LINK")
GIT_WRAPPER="$ROOT/tools/l/mind-bin/git"
GIT_SHELL="$ROOT/tools/l/mind-shell"
GIT_ZSHENV="$GIT_SHELL/.zshenv"
GIT_ZPROFILE="$GIT_SHELL/.zprofile"
RISHI_LINK="$ROOT/rishi/bin/rishi"
RISHI=$(/bin/realpath "$RISHI_LINK")
PRE_COMMIT="$ROOT/tools/hooks/pre-commit"
COMMIT_MSG="$ROOT/tools/hooks/commit-msg"
MIND_LANE="$ROOT/tools/fixtures/c/chatgpt_mind_lane.awk"
GIT_CONFIG="$ROOT/.git/config"
GIT_HEAD="$ROOT/.git/HEAD"
GIT_REFS="$ROOT/.git/refs"
GIT_LOGS="$ROOT/.git/logs"
GIT_PACKED_REFS="$ROOT/.git/packed-refs"
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
[ "$GPG" = "$GPG_EXPECTED" ] || {
  echo "FAIL chatgpt-mind-real-plan: canonical host GPG target drifted" >&2
  exit 1
}
[ -f "$GPG" ] && [ -x "$GPG" ] && [ ! -L "$GPG" ] || {
  echo "FAIL chatgpt-mind-real-plan: canonical host GPG is not a regular executable" >&2
  exit 1
}
[ -f "$GIT_WRAPPER" ] && [ -x "$GIT_WRAPPER" ] && [ ! -L "$GIT_WRAPPER" ] || {
  echo "FAIL chatgpt-mind-real-plan: tracked Git doorway is not a regular executable" >&2
  exit 1
}
for shell_doorway in "$GIT_ZSHENV" "$GIT_ZPROFILE"; do
  [ -f "$shell_doorway" ] && [ ! -L "$shell_doorway" ] || {
    echo "FAIL chatgpt-mind-real-plan: tracked zsh doorway is absent or linked" >&2
    exit 1
  }
done
[ "$RISHI" = "$RISHI_LINK" ] && [ -f "$RISHI" ] && [ -x "$RISHI" ] && [ ! -L "$RISHI" ] || {
  echo "FAIL chatgpt-mind-real-plan: repository-local Rishi is absent, linked, or noncanonical" >&2
  exit 1
}
for hook in "$PRE_COMMIT" "$COMMIT_MSG"; do
  [ -f "$hook" ] && [ -x "$hook" ] && [ ! -L "$hook" ] || {
    echo "FAIL chatgpt-mind-real-plan: protected tracked hook is absent, linked, or non-executable" >&2
    exit 1
  }
done
[ -f "$MIND_LANE" ] && [ ! -L "$MIND_LANE" ] || {
  echo "FAIL chatgpt-mind-real-plan: tracked MIND lane scanner is absent or linked" >&2
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
[ ! -e "$ROOT/.git/objects/info/alternates" ] || {
  echo "FAIL chatgpt-mind-real-plan: standalone clone borrows an object alternate" >&2
  exit 1
}
[ -f "$GIT_CONFIG" ] && [ -f "$GIT_HEAD" ] && [ -d "$GIT_REFS" ] && [ -d "$GIT_LOGS" ] || {
  echo "FAIL chatgpt-mind-real-plan: standalone Git control state is incomplete" >&2
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
render_plan() {
  if [ -f "$GIT_PACKED_REFS" ]; then
    "$AI_JAIL" --dry-run --map "$CANONICAL" --map "$GIT" --map "$GIT_PCRE" --map "$GIT_INTL" \
      --map "$RISHI" --map "$GIT_WRAPPER" --map "$GIT_ZSHENV" --map "$GIT_ZPROFILE" \
      --map "$PRE_COMMIT" --map "$COMMIT_MSG" --map "$MIND_LANE" --map "$GIT_CONFIG" --map "$GIT_HEAD" \
      --map "$GIT_REFS" --map "$GIT_LOGS" --map "$GIT_PACKED_REFS" \
      --exec --private-home --no-save-config "$@"
  else
    "$AI_JAIL" --dry-run --map "$CANONICAL" --map "$GIT" --map "$GIT_PCRE" --map "$GIT_INTL" \
      --map "$RISHI" --map "$GIT_WRAPPER" --map "$GIT_ZSHENV" --map "$GIT_ZPROFILE" \
      --map "$PRE_COMMIT" --map "$COMMIT_MSG" --map "$MIND_LANE" --map "$GIT_CONFIG" --map "$GIT_HEAD" \
      --map "$GIT_REFS" --map "$GIT_LOGS" \
      --exec --private-home --no-save-config "$@"
  fi
}
render_plan /usr/bin/env CODEX_HOME=.mind-state/codex-home TMPDIR=/private/tmp \
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
for mapped_path in "$GIT_PCRE" "$GIT_INTL" "$RISHI" "$GIT_WRAPPER" "$GIT_ZSHENV" "$GIT_ZPROFILE" \
  "$PRE_COMMIT" "$COMMIT_MSG" "$MIND_LANE" "$GIT_CONFIG" "$GIT_HEAD"; do
  mapped_allow="(allow file-read* (literal \"$mapped_path\"))"
  mapped_deny="(deny file-write* (literal \"$mapped_path\"))"
  [ "$(grep -Fxc "$mapped_allow" "$PLAN")" -eq 1 ] || {
    echo "FAIL chatgpt-mind-real-plan: exact Git-closure read mapping is absent or ambiguous" >&2
    exit 1
  }
  [ "$(grep -Fxc "$mapped_deny" "$PLAN")" -eq 1 ] || {
    echo "FAIL chatgpt-mind-real-plan: exact Git-closure write denial is absent or ambiguous" >&2
    exit 1
  }
done
for mapped_dir in "$GIT_REFS" "$GIT_LOGS"; do
  mapped_allow="(allow file-read* (subpath \"$mapped_dir\"))"
  mapped_deny="(deny file-write* (subpath \"$mapped_dir\"))"
  [ "$(grep -Fxc "$mapped_allow" "$PLAN")" -eq 1 ] || {
    echo "FAIL chatgpt-mind-real-plan: exact Git-administration read map is absent or ambiguous" >&2
    exit 1
  }
  [ "$(grep -Fxc "$mapped_deny" "$PLAN")" -eq 1 ] || {
    echo "FAIL chatgpt-mind-real-plan: exact Git-administration write denial is absent or ambiguous" >&2
    exit 1
  }
done
PACKED_ALLOW="(allow file-read* (literal \"$GIT_PACKED_REFS\"))"
PACKED_DENY="(deny file-write* (literal \"$GIT_PACKED_REFS\"))"
if [ -f "$GIT_PACKED_REFS" ]; then
  [ "$(grep -Fxc "$PACKED_ALLOW" "$PLAN")" -eq 1 ] \
    && [ "$(grep -Fxc "$PACKED_DENY" "$PLAN")" -eq 1 ] || {
      echo "FAIL chatgpt-mind-real-plan: existing packed refs lack one exact read-only map" >&2
      exit 1
    }
elif grep -F "$GIT_PACKED_REFS" "$PLAN" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: absent packed refs gained a phantom map" >&2
  exit 1
fi
if grep -E '\(allow file-read\* \(subpath "/opt/homebrew/(Cellar/(pcre2|gettext)|opt/(pcre2|gettext))' "$PLAN" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: Homebrew Git runtime mapping widened to a directory" >&2
  exit 1
fi
if grep -E '\(allow file-read\* \(subpath ".*/tools/l/(mind-bin|mind-shell)' "$PLAN" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: tracked Git doorway mapping widened to a directory" >&2
  exit 1
fi
[ "$(grep -Fxc "$DENY" "$PLAN")" -eq 1 ] || {
  echo "FAIL chatgpt-mind-real-plan: exact canonical write denial is absent or ambiguous" >&2
  exit 1
}
if grep -F "$GPG" "$PLAN" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: Codex plan exposed the host signing executable" >&2
  exit 1
fi
GNUPG_DENY="(deny file-read* (subpath \"$HOME/.gnupg\"))"
[ "$(grep -Fxc "$GNUPG_DENY" "$PLAN")" -eq 1 ] || {
  echo "FAIL chatgpt-mind-real-plan: private-home plan lost its exact GPG-state denial" >&2
  exit 1
}
if grep -E '\(allow file-(read|write).*[/]\.gnupg' "$PLAN" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: private-home plan exposed GPG state" >&2
  exit 1
fi

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

GIT_PATH=PATH=$ROOT/tools/l/mind-bin:/opt/homebrew/Cellar/git/2.53.0_1/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
GIT_ID=GRAIN_MIND_GIT=$GIT_WRAPPER
GIT_RAW=GRAIN_MIND_GIT_RAW=$GIT
GIT_ROOT=GRAIN_MIND_ROOT=$ROOT
GIT_ZDOTDIR=ZDOTDIR=$GIT_SHELL
GIT_DYLD=DYLD_LIBRARY_PATH=/opt/homebrew/Cellar/pcre2/10.47_1/lib:/opt/homebrew/Cellar/gettext/1.0/lib
GIT_NO_SYSTEM=GIT_CONFIG_NOSYSTEM=1
GIT_NO_GLOBAL=GIT_CONFIG_GLOBAL=/dev/null
run_in_jail() {
  if [ -f "$GIT_PACKED_REFS" ]; then
    "$AI_JAIL" --map "$CANONICAL" --map "$GIT" --map "$GIT_PCRE" --map "$GIT_INTL" \
      --map "$RISHI" --map "$GIT_WRAPPER" --map "$GIT_ZSHENV" --map "$GIT_ZPROFILE" \
      --map "$PRE_COMMIT" --map "$COMMIT_MSG" --map "$MIND_LANE" --map "$GIT_CONFIG" --map "$GIT_HEAD" \
      --map "$GIT_REFS" --map "$GIT_LOGS" --map "$GIT_PACKED_REFS" \
      --exec --private-home --no-save-config "$@"
  else
    "$AI_JAIL" --map "$CANONICAL" --map "$GIT" --map "$GIT_PCRE" --map "$GIT_INTL" \
      --map "$RISHI" --map "$GIT_WRAPPER" --map "$GIT_ZSHENV" --map "$GIT_ZPROFILE" \
      --map "$PRE_COMMIT" --map "$COMMIT_MSG" --map "$MIND_LANE" --map "$GIT_CONFIG" --map "$GIT_HEAD" \
      --map "$GIT_REFS" --map "$GIT_LOGS" \
      --exec --private-home --no-save-config "$@"
  fi
}
run_git_in_jail() {
  run_in_jail /usr/bin/env "$GIT_PATH" "$GIT_ID" "$GIT_RAW" "$GIT_ROOT" "$GIT_ZDOTDIR" \
    "$GIT_DYLD" "$GIT_NO_SYSTEM" "$GIT_NO_GLOBAL" "$@"
}
run_git_in_jail "$GIT" --version >"$PEN/git-version" 2>"$PEN/git-version.err"
[ "$(cat "$PEN/git-version")" = 'git version 2.53.0' ] || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Homebrew Git identity drifted" >&2
  exit 1
}
run_git_in_jail "$GIT_WRAPPER" --version >"$PEN/wrapper-version" 2>"$PEN/wrapper-version.err"
[ "$(cat "$PEN/wrapper-version")" = 'git version 2.53.0' ] || {
  echo "FAIL chatgpt-mind-real-plan: tracked doorway did not reach canonical Homebrew Git" >&2
  exit 1
}
run_git_in_jail /bin/zsh -lc 'printf "path=%s\n" "$(command -v git)"; git --version' \
  >"$PEN/zsh-git" 2>"$PEN/zsh-git.err"
[ "$(sed -n '1p' "$PEN/zsh-git")" = "path=$GIT_WRAPPER" ] \
  && [ "$(sed -n '2p' "$PEN/zsh-git")" = 'git version 2.53.0' ] || {
    echo "FAIL chatgpt-mind-real-plan: login zsh did not restore the tracked Homebrew-Git doorway" >&2
    exit 1
  }
run_git_in_jail /bin/sh -c 'printf "path=%s\n" "$(command -v git)"; git --version' \
  >"$PEN/sh-git" 2>"$PEN/sh-git.err"
[ "$(sed -n '1p' "$PEN/sh-git")" = "path=$GIT_WRAPPER" ] \
  && [ "$(sed -n '2p' "$PEN/sh-git")" = 'git version 2.53.0' ] || {
    echo "FAIL chatgpt-mind-real-plan: nested sh did not retain the tracked Homebrew-Git doorway" >&2
    exit 1
  }
if grep -E '/usr/bin/git|/var/select' "$PEN/zsh-git" "$PEN/sh-git" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: nested shell crossed into Apple Git or selector state" >&2
  exit 1
fi
if ! run_git_in_jail "$GIT_WRAPPER" -C "$ROOT" status --porcelain --untracked-files=normal >"$PEN/status" 2>"$PEN/status.err"; then
  cat "$PEN/status.err" >&2
  echo "FAIL chatgpt-mind-real-plan: enclosed Git status probe failed" >&2
  exit 1
fi
if run_git_in_jail "$GIT_WRAPPER" -C "$ROOT" status --porcelain --ignore-submodules=none >"$PEN/submodule-override" 2>"$PEN/submodule-override.err"; then
  echo "FAIL chatgpt-mind-real-plan: inner Git accepted the outer supervisor's exact-submodule authority" >&2
  exit 1
fi
grep -F 'exact submodule dirt belongs to the outer supervisor' "$PEN/submodule-override.err" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: inner Git lost its exact-submodule refusal" >&2
  exit 1
}
[ ! -s "$PEN/status" ] || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git found a dirty clone" >&2
  exit 1
}
run_git_in_jail "$GIT_WRAPPER" -C "$ROOT" worktree list --porcelain >"$PEN/worktrees" 2>"$PEN/worktrees.err"
grep -Fx "worktree $ROOT" "$PEN/worktrees" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git did not report the standalone worktree" >&2
  exit 1
}
run_git_in_jail "$GIT_WRAPPER" -C "$ROOT" rev-list --count HEAD..xy/main >"$PEN/behind" 2>"$PEN/behind.err"
[ "$(cat "$PEN/behind")" = 0 ] || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git found unintegrated xy/main commits" >&2
  exit 1
}
# The real Good/valid verification remains an operator-side Git check. Inside
# the private jail, prove the signed commit envelope without exposing a keyring.
run_git_in_jail "$GIT_WRAPPER" -C "$ROOT" cat-file commit HEAD >"$PEN/head-commit" 2>"$PEN/head-commit.err"
grep -F 'gpgsig -----BEGIN PGP SIGNATURE-----' "$PEN/head-commit" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: enclosed Git did not retain the HEAD signature envelope" >&2
  exit 1
}
run_git_in_jail "$GIT_WRAPPER" -C "$ROOT" merge-base --is-ancestor xy/main HEAD
run_git_in_jail "$GIT_WRAPPER" -C "$ROOT" rev-list --count xy/main..HEAD >"$PEN/ahead" 2>"$PEN/ahead.err"
case "$(cat "$PEN/ahead")" in
  ''|*[!0-9]*) echo "FAIL chatgpt-mind-real-plan: enclosed one-commit arithmetic was not numeric" >&2; exit 1 ;;
esac

LAUNCHER="$ROOT/tools/l/chatgpt-mind.rish"
grep -F 'let pre_commit_run = run-bounded { argv: ([ai_jail] + jail_maps' "$LAUNCHER" \
  | grep -F '"hook" "run" "pre-commit"' >/dev/null || {
    echo "FAIL chatgpt-mind-real-plan: pre-commit hook no longer executes inside the outer jail" >&2
    exit 1
  }
grep -F 'let commit_msg_run = run-bounded { argv: ([ai_jail] + jail_maps' "$LAUNCHER" \
  | grep -F '"hook" "run" "commit-msg"' >/dev/null || {
    echo "FAIL chatgpt-mind-real-plan: commit-message hook no longer executes inside the outer jail" >&2
    exit 1
  }
grep -F '"commit-tree" candidate_tree "-p" before "-S${signing_key}" "-F" commit_message_rel' "$LAUNCHER" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: outer signing no longer creates an off-ref commit object" >&2
  exit 1
}
grep -F 'assert signed-descendant repo_root before signed_commit' "$LAUNCHER" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: explicit signed object verification is absent" >&2
  exit 1
}
grep -F '"update-ref" "-m" "mind: outer signed candidate" branch_ref signed_commit before' "$LAUNCHER" >/dev/null || {
  echo "FAIL chatgpt-mind-real-plan: verified object lacks its compare-and-swap ref update" >&2
  exit 1
}
if grep -F 'git_argv + ["-C" repo_root "commit" ' "$LAUNCHER" >/dev/null; then
  echo "FAIL chatgpt-mind-real-plan: launcher regressed to ref-moving git commit" >&2
  exit 1
fi

echo "GREEN chatgpt-mind-real-plan: ai-jail maps canonical Codex, Homebrew Git, Rishi, tracked shell doorways and hooks, and protected Git control state read-only without GPG; packed refs are conditional; nested shells resolve Homebrew Git; hooks run in the jail; outer signing verifies an off-ref commit object before a compare-and-swap branch update; battery remains telemetry"
