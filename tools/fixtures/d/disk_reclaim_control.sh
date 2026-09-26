#!/bin/sh
# tools/fixtures/d/disk_reclaim_control.sh -- proves disk_reclaim_scan.sh on a throwaway pen.
#
#   sh tools/fixtures/d/disk_reclaim_control.sh
#
# WHY. A scan that removes bytes earns a control that plants the two ways it could go wrong --
# clearing something not actually gitignored, or clearing the load-bearing toolchain the rest of
# this tree's tools depend on to run at all -- and proves the refusal fires under a planted case,
# the same discipline REDS %729's own control uses for `pen_entry`.
#
# Read-only against the real tree: every case builds a throwaway git repository in a mktemp pen and
# runs the scan there with SCAN_ROOT pointed at the pen, never at the checkout this control runs in.
set -eu

SELF=$(cd "$(dirname "$0")" && pwd)
SCAN="$SELF/disk_reclaim_scan.sh"

pass=0
fail=0
note() {
  if [ "$2" = "1" ]; then
    pass=$((pass + 1))
    echo "leg $1 pass"
  else
    fail=$((fail + 1))
    echo "leg $1 FAIL"
  fi
}

pen=$(mktemp -d) || { echo "control_verdict=refused: pen absent"; exit 1; }
trap 'rm -rf "$pen"' EXIT

build() {
  rm -rf "$pen/t"
  mkdir -p "$pen/t"
  cd "$pen/t" || exit 1
  git init -q
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
}

run_scan() {
  ( cd "$pen/t" && sh "$SCAN" "$@" )
}

# leg 1 -- a genuinely gitignored /rye/bin/ is never touched, even under --apply.
build
mkdir -p rye/bin rishi/bin
: > rye/bin/rye
: > rishi/bin/rishi
printf '/rye/bin/\n/rishi/bin/\n' > .gitignore
git add .gitignore
git commit -qm init
out=$(run_scan --apply)
[ -f rye/bin/rye ] && [ -f rishi/bin/rishi ] && echo "$out" | grep -q 'dir /rye/bin bytes=0 verdict=excluded' && ok=1 || ok=0
note excluded_never_removed "$ok"

# leg 2 -- an ordinary rebuildable bin/ under .gitignore is removed under --apply, and left alone
#          without it.
build
mkdir -p glow/bin
: > glow/bin/glow
printf '/glow/bin/\n' > .gitignore
git add .gitignore
git commit -qm init
out=$(run_scan)
[ -d glow/bin ] && echo "$out" | grep -q 'dir /glow/bin bytes=.* verdict=rebuildable' && ok=1 || ok=0
note report_mode_removes_nothing "$ok"
out=$(run_scan --apply)
[ ! -d glow/bin ] && echo "$out" | grep -q 'verdict=applied' && ok=1 || ok=0
note apply_mode_removes_it "$ok"

# leg 3 -- a directory named like a candidate but NOT actually gitignored (a stale .gitignore line,
#          or a nested .gitignore un-ignoring it) is reported and never removed.
build
mkdir -p mantra/bin
: > mantra/bin/mantra
printf '/mantra/bin/\n' > .gitignore
printf '!bin/\n' > mantra/.gitignore
git add .gitignore mantra/.gitignore
git commit -qm init
out=$(run_scan --apply)
[ -f mantra/bin/mantra ] && echo "$out" | grep -q 'dir /mantra/bin bytes=0 verdict=not_ignored' && ok=1 || ok=0
note stale_ignore_line_refused "$ok"

# leg 4 -- a candidate that does not exist on disk is skipped without a line at all.
build
printf '/absent/bin/\n' > .gitignore
git add .gitignore
git commit -qm init
out=$(run_scan)
echo "$out" | grep -q 'dir /absent/bin' && ok=0 || ok=1
note missing_dir_skipped "$ok"

echo "control_pass=$pass control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=failed"
  exit 1
fi
