#!/bin/sh
# chatgpt_mind_full_clone_control.sh -- local, no-network MIND clone proof.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
GIT_LINK=/opt/homebrew/bin/git
GIT=/opt/homebrew/Cellar/git/2.53.0_1/bin/git
PIN=99b87f20f1fdbd2fc216cb13c07bdd0531916d27
XY_URL=ssh://git@github.com/xykj61/grain.git

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

if grep -E 'run \["git"|run-bounded \{ argv: \["git"' "$ROOT/tools/l/chatgpt-mind.rish" >/dev/null; then
  echo "FAIL chatgpt-mind-full-clone: launcher retained PATH-selected Git argv" >&2
  exit 1
fi
grep -F 'let git_expected = "/opt/homebrew/Cellar/git/2.53.0_1/bin/git"' "$ROOT/tools/l/chatgpt-mind.rish" >/dev/null
grep -F 'GRAIN_MIND_GIT=${git_exec}' "$ROOT/tools/l/chatgpt-mind.rish" >/dev/null

echo "GREEN chatgpt-mind-full-clone: one self-contained Git boundary holds parent and pinned sketchbook objects without alternates or hardlinks; only xy remains; Homebrew Git 2.53.0 owns every MIND probe"
