#!/bin/sh
# FOSSIL -- Class M, prepped 20260906.114734 for the mitra shed; the cut stays RED until circled.
# Living mutant: tools/f/fleet-loop.sh reading construction/fleet-roster.kyri, with
# tools/f/fleet_watch.sh above it. Row and reasons: construction/SHRED_PREP.md.
# chatgpt_mind_full_clone_control.sh -- local, no-network MIND clone proof.

set -eu

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
GIT_LINK=/opt/homebrew/bin/git
GIT=/opt/homebrew/Cellar/git/2.53.0_1/bin/git
GPG_LINK=/opt/homebrew/bin/gpg
GPG=/opt/homebrew/Cellar/gnupg/2.5.18/bin/gpg
PIN=99b87f20f1fdbd2fc216cb13c07bdd0531916d27
XY_URL=ssh://git@github.com/xykj61/grain.git
MIND_GIT="$ROOT/tools/m/mind-bin/git"
MIND_SHELL="$ROOT/tools/m/mind-shell"
MIND_ZSHENV="$MIND_SHELL/.zshenv"
MIND_ZPROFILE="$MIND_SHELL/.zprofile"
MIND_PATH="$ROOT/tools/m/mind-bin:/opt/homebrew/Cellar/git/2.53.0_1/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
LAUNCHER="$ROOT/tools/c/chatgpt-mind.rish"
RISHI="$ROOT/rishi/bin/rishi"
PRE_COMMIT="$ROOT/tools/hooks/pre-commit"
COMMIT_MSG="$ROOT/tools/hooks/commit-msg"
MIND_LANE="$ROOT/tools/fixtures/c/chatgpt_mind_lane.awk"

[ "$(/bin/realpath "$GIT_LINK")" = "$GIT" ] || {
  echo "FAIL chatgpt-mind-full-clone: Homebrew Git target drifted" >&2
  exit 1
}
[ -f "$GIT" ] && [ -x "$GIT" ] && [ ! -L "$GIT" ] || {
  echo "FAIL chatgpt-mind-full-clone: Homebrew Git is not a regular executable" >&2
  exit 1
}
[ "$("$GIT" --version)" = 'git version 2.53.0' ] || {
  echo "FAIL chatgpt-mind-full-clone: Homebrew Git version drifted" >&2
  exit 1
}
[ "$(/bin/realpath "$GPG_LINK")" = "$GPG" ] || {
  echo "FAIL chatgpt-mind-full-clone: host GPG target drifted" >&2
  exit 1
}
[ -f "$GPG" ] && [ -x "$GPG" ] && [ ! -L "$GPG" ] || {
  echo "FAIL chatgpt-mind-full-clone: host GPG is not a regular executable" >&2
  exit 1
}

[ -f "$MIND_GIT" ] && [ -x "$MIND_GIT" ] && [ ! -L "$MIND_GIT" ] || {
  echo "FAIL chatgpt-mind-full-clone: tracked Git doorway is not a regular executable" >&2
  exit 1
}
for shell_doorway in "$MIND_ZSHENV" "$MIND_ZPROFILE"; do
  [ -f "$shell_doorway" ] && [ ! -L "$shell_doorway" ] || {
    echo "FAIL chatgpt-mind-full-clone: tracked zsh doorway is absent or linked" >&2
    exit 1
  }
done
[ "$("$GIT" -C "$ROOT" ls-files -s -- tools/m/mind-bin/git | awk '{print $1 " " $4}')" \
  = '100755 tools/m/mind-bin/git' ] || {
  echo "FAIL chatgpt-mind-full-clone: Git doorway is not tracked executable content" >&2
  exit 1
}
grep -F 'exec /usr/bin/env -i' "$MIND_GIT" >/dev/null || {
  echo "FAIL chatgpt-mind-full-clone: tracked Git doorway no longer rebuilds a finite environment" >&2
  exit 1
}
grep -F '"$git_exec" -c diff.ignoreSubmodules=all "$@"' "$MIND_GIT" >/dev/null || {
  echo "FAIL chatgpt-mind-full-clone: tracked Git doorway lost its inner submodule boundary" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" ls-files -s -- tools/m/mind-shell/.zshenv | awk '{print $1 " " $4}')" \
  = '100644 tools/m/mind-shell/.zshenv' ] || {
  echo "FAIL chatgpt-mind-full-clone: zsh environment doorway is not tracked mode-0644 content" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" ls-files -s -- tools/m/mind-shell/.zprofile | awk '{print $1 " " $4}')" \
  = '100644 tools/m/mind-shell/.zprofile' ] || {
  echo "FAIL chatgpt-mind-full-clone: zsh profile doorway is not tracked mode-0644 content" >&2
  exit 1
}
/bin/sh -n "$MIND_GIT"
/bin/zsh -n "$MIND_ZSHENV" "$MIND_ZPROFILE"
[ -f "$RISHI" ] && [ -x "$RISHI" ] && [ ! -L "$RISHI" ] \
  && [ "$(/bin/realpath "$RISHI")" = "$RISHI" ] || {
    echo "FAIL chatgpt-mind-full-clone: repository-local Rishi is absent, linked, or noncanonical" >&2
    exit 1
  }
for hook_path in tools/hooks/pre-commit tools/hooks/commit-msg; do
  [ "$("$GIT" -C "$ROOT" ls-files -s -- "$hook_path" | awk '{print $1 " " $4}')" \
    = "100755 $hook_path" ] || {
      echo "FAIL chatgpt-mind-full-clone: protected hook is not tracked executable content" >&2
      exit 1
    }
done
for hook in "$PRE_COMMIT" "$COMMIT_MSG"; do
  [ -f "$hook" ] && [ -x "$hook" ] && [ ! -L "$hook" ] || {
    echo "FAIL chatgpt-mind-full-clone: protected hook is absent, linked, or non-executable" >&2
    exit 1
  }
done
[ -f "$MIND_LANE" ] && [ ! -L "$MIND_LANE" ] || {
  echo "FAIL chatgpt-mind-full-clone: tracked MIND lane scanner is absent or linked" >&2
  exit 1
}

NESTED_GIT=$(/usr/bin/env PATH="$MIND_PATH" GRAIN_MIND_GIT="$MIND_GIT" \
  GRAIN_MIND_GIT_RAW="$GIT" GRAIN_MIND_ROOT="$ROOT" ZDOTDIR="$MIND_SHELL" \
  DYLD_LIBRARY_PATH=/opt/homebrew/Cellar/pcre2/10.47_1/lib:/opt/homebrew/Cellar/gettext/1.0/lib \
  GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null \
  /bin/zsh -lc 'printf "path=%s\n" "$(command -v git)"; git --version')
[ "$NESTED_GIT" = "path=$MIND_GIT
git version 2.53.0" ] || {
  echo "FAIL chatgpt-mind-full-clone: login zsh did not resolve the tracked Homebrew-Git doorway" >&2
  exit 1
}

[ -d "$ROOT/.git" ] && [ ! -L "$ROOT/.git" ] || {
  echo "FAIL chatgpt-mind-full-clone: repository .git is not an internal directory" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" rev-parse --path-format=absolute --git-dir)" = "$ROOT/.git" ] || {
  echo "FAIL chatgpt-mind-full-clone: worktree Git administration escapes" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" rev-parse --path-format=absolute --git-common-dir)" = "$ROOT/.git" ] || {
  echo "FAIL chatgpt-mind-full-clone: common Git administration escapes" >&2
  exit 1
}
[ ! -e "$ROOT/.git/objects/info/alternates" ] || {
  echo "FAIL chatgpt-mind-full-clone: parent object database borrows alternates" >&2
  exit 1
}
for control_file in "$ROOT/.git/config" "$ROOT/.git/HEAD"; do
  [ -f "$control_file" ] && [ ! -L "$control_file" ] || {
    echo "FAIL chatgpt-mind-full-clone: standalone Git control file is absent or linked" >&2
    exit 1
  }
done
for control_dir in "$ROOT/.git/refs" "$ROOT/.git/logs"; do
  [ -d "$control_dir" ] && [ ! -L "$control_dir" ] || {
    echo "FAIL chatgpt-mind-full-clone: standalone Git control directory is absent or linked" >&2
    exit 1
  }
done
if [ -e "$ROOT/.git/packed-refs" ]; then
  [ -f "$ROOT/.git/packed-refs" ] && [ ! -L "$ROOT/.git/packed-refs" ] || {
    echo "FAIL chatgpt-mind-full-clone: packed refs are not a regular optional file" >&2
    exit 1
  }
fi
if find "$ROOT/.git/objects" -type f -links +1 -print -quit | grep . >/dev/null; then
  echo "FAIL chatgpt-mind-full-clone: parent object database contains hardlinks" >&2
  exit 1
fi

[ "$("$GIT" -C "$ROOT" remote)" = xy ] || {
  echo "FAIL chatgpt-mind-full-clone: remote set is not exactly xy" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" remote get-url xy)" = "$XY_URL" ] || {
  echo "FAIL chatgpt-mind-full-clone: xy URL drifted" >&2
  exit 1
}
"$GIT" -C "$ROOT" show-ref --verify --quiet refs/remotes/xy/main || {
  echo "FAIL chatgpt-mind-full-clone: local xy/main truth is absent" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" rev-list --count HEAD..xy/main)" = 0 ] || {
  echo "FAIL chatgpt-mind-full-clone: xy/main has unintegrated commits" >&2
  exit 1
}
case "$("$GIT" -C "$ROOT" rev-list --count xy/main..HEAD)" in
  ''|*[!0-9]*) echo "FAIL chatgpt-mind-full-clone: local divergence is not numeric" >&2; exit 1 ;;
esac

SIGNING_KEY=$("$GIT" -C "$ROOT" config --local --get user.signingkey)
[ "${#SIGNING_KEY}" -eq 40 ] || {
  echo "FAIL chatgpt-mind-full-clone: project-local signing fingerprint is not forty bytes" >&2
  exit 1
}
case "$SIGNING_KEY" in
  *[!0-9A-F]*)
    echo "FAIL chatgpt-mind-full-clone: project-local signing fingerprint is not uppercase hexadecimal" >&2
    exit 1
    ;;
esac
[ "$("$GIT" -C "$ROOT" config --local --get gpg.format)" = openpgp ] || {
  echo "FAIL chatgpt-mind-full-clone: project-local signing format is not OpenPGP" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" config --local --get gpg.program)" = "$GPG" ] || {
  echo "FAIL chatgpt-mind-full-clone: project-local signing program is not canonical host GPG" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" config --local --bool --get commit.gpgsign)" = true ] || {
  echo "FAIL chatgpt-mind-full-clone: project-local signed-commit law is not true" >&2
  exit 1
}
[ "$("$GIT" -C "$ROOT" config --local --get core.hooksPath)" = tools/hooks ] || {
  echo "FAIL chatgpt-mind-full-clone: project-local hooks path drifted" >&2
  exit 1
}
[ -n "$("$GIT" -C "$ROOT" config --local --get user.name)" ] \
  && [ -n "$("$GIT" -C "$ROOT" config --local --get user.email)" ] || {
    echo "FAIL chatgpt-mind-full-clone: project-local author identity is incomplete" >&2
    exit 1
  }

[ "$("$GIT" -C "$ROOT" ls-files -s gratitude/grain-sketchbook | awk '{print $1 " " $2}')" = "160000 $PIN" ] || {
  echo "FAIL chatgpt-mind-full-clone: sketchbook gitlink drifted" >&2
  exit 1
}
SUB_GIT=$("$GIT" -C "$ROOT/gratitude/grain-sketchbook" rev-parse --path-format=absolute --git-dir)
case "$SUB_GIT" in
  "$ROOT/.git/modules/gratitude/grain-sketchbook") ;;
  *) echo "FAIL chatgpt-mind-full-clone: submodule administration escapes the parent .git" >&2; exit 1 ;;
esac
[ "$("$GIT" -C "$ROOT/gratitude/grain-sketchbook" rev-parse HEAD)" = "$PIN" ] || {
  echo "FAIL chatgpt-mind-full-clone: initialized sketchbook revision drifted" >&2
  exit 1
}
[ ! -e "$SUB_GIT/objects/info/alternates" ] || {
  echo "FAIL chatgpt-mind-full-clone: submodule object database borrows alternates" >&2
  exit 1
}
if find "$SUB_GIT/objects" -type f -links +1 -print -quit | grep . >/dev/null; then
  echo "FAIL chatgpt-mind-full-clone: submodule object database contains hardlinks" >&2
  exit 1
fi

[ -z "$("$GIT" -C "$ROOT" status --porcelain --untracked-files=normal --ignore-submodules=none)" ] || {
  echo "FAIL chatgpt-mind-full-clone: worktree or submodule is dirty" >&2
  exit 1
}
"$GIT" -C "$ROOT" fsck --full --strict >/dev/null
"$GIT" -C "$ROOT/gratitude/grain-sketchbook" fsck --full --strict >/dev/null

if grep -E 'run \["git"|run-bounded \{ argv: \["git"' "$LAUNCHER" >/dev/null; then
  echo "FAIL chatgpt-mind-full-clone: launcher retained PATH-selected Git argv" >&2
  exit 1
fi
require_launcher() {
  grep -F "$1" "$LAUNCHER" >/dev/null || {
    echo "FAIL chatgpt-mind-full-clone: launcher lost bounded contract: $2" >&2
    exit 1
  }
}

require_launcher 'let git_expected = "/opt/homebrew/Cellar/git/2.53.0_1/bin/git"' 'canonical Homebrew Git'
require_launcher 'let git_wrapper_abs = repo_root + "/tools/m/mind-bin/git"' 'tracked Git doorway'
require_launcher 'let git_path_arg = "PATH=${repo_root}/tools/m/mind-bin:/opt/homebrew/Cellar/git/2.53.0_1/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"' 'wrapper-first PATH'
require_launcher 'let git_exec_arg = "GRAIN_MIND_GIT=${git_wrapper_abs}"' 'child Git doorway identity'
require_launcher 'let git_raw_arg = "GRAIN_MIND_GIT_RAW=${git_exec}"' 'raw Homebrew Git identity'
require_launcher 'let git_root_arg = "GRAIN_MIND_ROOT=${repo_root}"' 'child repository root'
require_launcher 'let git_zdotdir_arg = "ZDOTDIR=${git_shell_abs}"' 'tracked zsh startup root'
require_launcher 'let git_argv = ["/usr/bin/env" "-i"' 'finite outer Git environment'
require_launcher 'let gpg_argv = ["/usr/bin/env" "-i"' 'finite host GPG environment'
require_launcher 'let rishi_abs = trim rishi_real.out' 'canonical repository-local Rishi'
require_launcher 'let git_config_abs = git_metadata + "/config"' 'protected Git config'
require_launcher 'let git_head_abs = git_metadata + "/HEAD"' 'protected Git HEAD'
require_launcher 'let git_refs_abs = git_metadata + "/refs"' 'protected Git refs'
require_launcher 'let git_logs_abs = git_metadata + "/logs"' 'protected Git reflogs'
require_launcher 'let git_packed_refs_abs = git_metadata + "/packed-refs"' 'optional packed refs'
require_launcher 'let packed_refs_maps = ?: git_packed_refs_file.ok (["--map" git_packed_refs_abs]) ([]' 'conditional packed-refs map'
require_launcher 'let jail_maps = ["--map" codex_exec "--map" git_exec "--map" git_pcre "--map" git_intl "--map" rishi_abs "--map" git_wrapper_abs "--map" git_zshenv_abs "--map" git_zprofile_abs "--map" pre_commit_hook "--map" commit_msg_hook "--map" mind_lane_scan "--map" git_config_abs "--map" git_head_abs "--map" git_refs_abs "--map" git_logs_abs] + packed_refs_maps' 'exact jailed runtime and protected-control closure'
require_launcher '"CODEX_HOME=${codex_home_abs}" "TMPDIR=/private/tmp" codex_exec "--disable" "unbounded_connection_retries" "features" "list"' 'isolated finite connection-retry feature probe'
require_launcher 'codex_exec "exec" "--disable" "unbounded_connection_retries" "--sandbox" "danger-full-access"' 'finite connection-retry live invocation'
require_launcher 'assert (jail_plan contains gpg_exec) == false' 'host GPG exclusion'
require_launcher 'let pre_commit_run = run-bounded { argv: ([ai_jail] + jail_maps' 'jailed pre-commit hook'
require_launcher 'git_wrapper_abs "-C" repo_root "hook" "run" "pre-commit"' 'pre-commit hook command'
require_launcher 'let commit_msg_run = run-bounded { argv: ([ai_jail] + jail_maps' 'jailed commit-message hook'
require_launcher 'git_wrapper_abs "-C" repo_root "hook" "run" "commit-msg" "--" commit_message_rel' 'commit-message hook command'

require_launcher 'let max_commit_message_bytes = 4096' 'commit-message byte wall'
require_launcher 'let max_candidate_paths = 64' 'candidate path ceiling'
require_launcher 'let commit_message_rel = signing_rel + "/commit-message.txt"' 'repository-local signing request'
require_launcher 'let phase_rel = log_rel + "/lap.phase"' 'structured phase receipt'
require_launcher 'fn phase-valid value: phase_values contains value' 'phase allowlist validation'
require_launcher 'let phase_codex_running = write-phase "codex-exec reason=running"' 'live Codex phase receipt'
require_launcher 'stdout-path: phase_rel, stdout-max: 128' 'phase receipt byte wall'
require_launcher 'assert candidate_count <= max_candidate_paths' 'candidate path enforcement'
require_launcher 'let mind_lane_scan = repo_root + "/tools/fixtures/c/chatgpt_mind_lane.awk"' 'Brushstroke and Surf machine lane'
require_launcher 'assert candidate_lane_run.ok else "REFUSE chatgpt-mind: staged candidate escapes the authored regular Brushstroke, Surf, and Skate lane"' 'pre-hook lane enforcement'
require_launcher 'assert hook_lane_run.ok else "REFUSE chatgpt-mind: jailed hooks escaped the authored regular Brushstroke, Surf, and Skate lane"' 'post-hook lane enforcement'
require_launcher 'stdout-path: candidate_diff, stdout-max: max_log_bytes' 'candidate diff byte wall'
require_launcher 'assert (trim message_mode_run.out) == "600"' 'private commit-message mode'
require_launcher 'assert message_size <= max_commit_message_bytes' 'commit-message byte enforcement'
require_launcher 'git_argv + ["-C" repo_root "commit-tree" candidate_tree "-p" before "-S${signing_key}" "-F" commit_message_rel]' 'off-ref signed commit object'
require_launcher 'assert signed-descendant repo_root before signed_commit' 'explicit signed-object verification'
require_launcher 'git-run ["-C" root "log" "-1" "--format=%G?" after]' 'explicit-object signature status'
require_launcher 'git-run ["-C" root "log" "-1" "--format=%GP" after]' 'explicit-object signer fingerprint'
require_launcher 'git_argv + ["-C" repo_root "update-ref" "-m" "mind: outer signed candidate" branch_ref signed_commit before]' 'compare-and-swap branch update'
require_launcher 'let phase_complete = write-phase "complete reason=signed-commit"' 'signed completion receipt'
require_launcher 'let transaction_open = run ["mkdir" "-m" "700" transaction_rel]' 'persistent signing transaction'
require_launcher 'assert repo-clean repo_root else "REFUSE chatgpt-mind: post-CAS worktree is not clean"' 'post-CAS clean-tree proof'
require_launcher 'signing_probe_run.overflow == ""' 'host signing-probe byte wall'
require_launcher 'signing_verify_run.overflow == ""' 'host signing-verification byte wall'

PHASE_VALUES=$(grep -F 'let phase_values = [' "$LAUNCHER")
[ -n "$PHASE_VALUES" ] || {
  echo "FAIL chatgpt-mind-full-clone: structured phase allowlist is absent" >&2
  exit 1
}
if grep 'write-phase ' "$LAUNCHER" | grep -v 'fn write-phase' | grep -v 'write-phase "' >/dev/null; then
  echo "FAIL chatgpt-mind-full-clone: launcher writes a dynamic unstructured phase" >&2
  exit 1
fi
sed -n 's/.*write-phase "\([^"]*\)".*/\1/p' "$LAUNCHER" \
  | while IFS= read -r phase_value; do
      case "$PHASE_VALUES" in
        *\"$phase_value\"*) ;;
        *)
          echo "FAIL chatgpt-mind-full-clone: phase writer escaped its fixed allowlist" >&2
          exit 1
          ;;
      esac
      [ "$(printf '%s\n' "$phase_value" | wc -c | tr -d ' ')" -le 128 ] || {
        echo "FAIL chatgpt-mind-full-clone: structured phase value crosses 128 bytes" >&2
        exit 1
      }
    done

if grep -E 'assert .*(power_source|system_sleep|battery_sleep)' "$LAUNCHER" >/dev/null; then
  echo "FAIL chatgpt-mind-full-clone: a power reading became an execution assertion" >&2
  exit 1
fi
require_launcher 'AC and battery readings are telemetry only; neither grants nor refuses work' 'power telemetry law'
require_launcher 'on battery -- the loop runs; a battery death cuts one lap and the pull resumes it' 'battery execution notice'
require_launcher 'battery sleep is observed, not changed or used as an execution gate' 'battery sleep notice'

if grep -F 'git_argv + ["-C" repo_root "commit" ' "$LAUNCHER" >/dev/null; then
  echo "FAIL chatgpt-mind-full-clone: launcher regressed to ref-moving git commit" >&2
  exit 1
fi

echo "GREEN chatgpt-mind-full-clone: one self-contained Git boundary holds parent and pinned sketchbook objects without alternates or hardlinks; the jail closure includes Rishi, tracked Git and zsh doorways, protected hooks and Git control state, with packed refs conditional and GPG outside; hooks execute in jail; outer signing verifies an off-ref object before compare-and-swap; bounded receipts remain; AC and battery are telemetry"
