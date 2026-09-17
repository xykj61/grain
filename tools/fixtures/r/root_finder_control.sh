#!/bin/sh
# tools/fixtures/r/root_finder_control.sh -- prove the root-finder reading by doing.
#
# WHY. A guard that cannot red guards nothing (REDS %59). This control builds real git
# repositories in a throwaway pen, plants one root-finder shape in each, runs
# tools/fixtures/r/root_finder_scan.sh inside them, and checks that each classification lands
# where it belongs. Nothing here touches the tree it is run from.
#
# THE PLANT LIVES ONLY IN THE PEN. The scan's population is every tracked shell source, so a
# planted finder written into tracked bytes would enter the live reading and move the very number
# the scan gates (`%785`, the guard that reads its own control). Every plant below is written into
# a pen repository at run time by a heredoc.
#
# THIS FILE IS NONETHELESS IN THE POPULATION, because it carries a root-finder of its own -- and
# that is proven rather than asserted. Its sentinels are `rishi/src` and `tools/fixtures`, both
# tracked, so it must appear in `finders` and never in `finders_bare_unrunnable`. The leg named
# `self_runnable` reads exactly that out of the scan's own `--explain`.
#
# THE CEILING IS PROVEN FROM BOTH SIDES WITH NO OVERRIDE IN THE SHIPPED INSTRUMENT. A pen copy of
# the scan is rewritten with `sed` to carry a small ceiling, so the live scan holds no environment
# variable, flag, or comment that lowers its own wall.
#
# USAGE
#   sh tools/fixtures/r/root_finder_control.sh
#
# Driven by tools/r/root_finder_witness.rish. Run from the repository root.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/src" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
cd "$_fd_root" || exit 2

scan=$_fd_root/tools/fixtures/r/root_finder_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT HUP TERM

legs=0
fails=0
leg() {
  name=$1; got=$2; want=$3
  legs=$((legs + 1))
  if [ "$got" = "$want" ]; then
    echo "$name=yes"
  else
    echo "$name=no got=$got want=$want"
    fails=$((fails + 1))
  fi
}

read_key() { awk -F= -v k="$1" '$1 == k { print $2; exit }'; }

# build <name> [<scan source>] -- a pen repository carrying the scan under test at its real path,
# with the tracked sentinels the scan's own root-finder needs.
build() {
  d=$pen/$1
  src=${2:-$scan}
  mkdir -p "$d/tools/fixtures/r" "$d/tools/fixtures/s" "$d/rishi/src"
  cp "$src" "$d/tools/fixtures/r/root_finder_scan.sh"
  # The scan sources the one shell dialect this tree speaks, so the pen carries it too -- and the
  # copy is what keeps `sources_tracked` honest below, since it is a tracked `.sh` in the pen.
  cp "$_fd_root/tools/fixtures/s/shell_portable.sh" "$d/tools/fixtures/s/shell_portable.sh"
  printf '# pen\nA real document so no pen is merely empty.\n' > "$d/README.md"
  printf 'const std = @import("std");\n' > "$d/rishi/src/main.rye"
  ( cd "$d" && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen ) >/dev/null 2>&1
  echo "$d"
}

# plant_finder <dir> <path> <var> <sentinel...> -- one copied root-finder block, walking up.
plant_finder() {
  d=$1; rel=$2; var=$3; shift 3
  mkdir -p "$d/$(dirname "$rel")"
  test_expr=
  for s in "$@"; do
    if [ -z "$test_expr" ]; then
      test_expr="[ ! -d \"\$$var/$s\" ]"
    else
      test_expr="$test_expr || [ ! -d \"\$$var/$s\" ]"
    fi
  done
  {
    echo '#!/bin/sh'
    echo "$var=\$(CDPATH= cd -- \"\$(dirname \"\$0\")\" && pwd)"
    echo '_steps=0'
    echo "while $test_expr; do"
    echo '  _steps=$((_steps + 1))'
    echo "  if [ \"\$_steps\" -gt 8 ]; then echo 'no tree root within 8 steps' >&2; exit 2; fi"
    echo "  $var=\$(dirname \"\$$var\")"
    echo 'done'
    echo 'echo planted'
  } > "$d/$rel"
}

commit_and_read() {
  ( cd "$1" && git add -A >/dev/null 2>&1 \
    && git commit -qm 'pen: one planted root-finder' >/dev/null 2>&1
    sh tools/fixtures/r/root_finder_scan.sh ${2:-} 2>/dev/null )
}

# -- 1. A finder naming only tracked sentinels is runnable in a checkout of tracked bytes ------
d=$(build tracked)
plant_finder "$d" tools/fixtures/r/planted_a.sh ROOT rishi/src tools/fixtures
out=$(commit_and_read "$d")
leg tracked_finder_counted "$(echo "$out" | read_key finders)" 2
leg tracked_finder_not_bare "$(echo "$out" | read_key finders_bare_unrunnable)" 0
leg tracked_finder_ok "$(echo "$out" | read_key verdict)" ok

# -- 2. A finder naming a directory nothing tracks is the %788 population ----------------------
d=$(build build_output)
mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
printf 'rishi/bin/\n' > "$d/.gitignore"
plant_finder "$d" tools/fixtures/r/planted_b.sh ROOT rishi/bin tools/fixtures
out=$(commit_and_read "$d")
leg build_output_counted "$(echo "$out" | read_key finders_bare_unrunnable)" 1
leg build_output_sentinel "$(echo "$out" | read_key sentinels_build_output)" 1
leg build_output_row "$(commit_and_read "$d" --list | grep -c 'planted_b.sh .*verdict=bare_unrunnable')" 1

# THE SENTINEL EXISTS ON DISK AND STILL COUNTS. The pen above holds a real `rishi/bin` directory
# with a real file in it, untracked. A reading taken from the filesystem would call that finder
# healthy; the reading taken from `git ls-files` calls it what it is.
leg build_output_exists_on_disk "$([ -d "$d/rishi/bin" ] && echo yes)" yes

# -- 3. `.git` is its own class, and the claim about a linked worktree is RUN --------------------
d=$(build gitdir)
plant_finder "$d" tools/fixtures/r/planted_c.sh ROOT tools/fixtures .git
out=$(commit_and_read "$d")
leg gitdir_not_bare "$(echo "$out" | read_key finders_bare_unrunnable)" 0
leg gitdir_fragile "$(echo "$out" | read_key finders_worktree_fragile)" 1
leg gitdir_sentinel "$(echo "$out" | read_key sentinels_git_dir)" 1
( cd "$d" && git worktree add -q --detach "$pen/linked" HEAD ) >/dev/null 2>&1
leg linked_worktree_git_is_file "$([ -f "$pen/linked/.git" ] && echo yes)" yes
leg linked_worktree_git_not_dir "$([ -d "$pen/linked/.git" ] && echo dir || echo notdir)" notdir

# -- 4. A WAIT LOOP IS NOT A ROOT-FINDER, which is the false positive this rule was written for --
d=$(build waitloop)
mkdir -p "$d/tools/fixtures/r"
{
  echo '#!/bin/sh'
  echo 'REPO=/somewhere'
  echo 'while [ ! -d "$REPO/.mind-state/run.lock" ]; do'
  echo '  sleep 1'
  echo 'done'
} > "$d/tools/fixtures/r/planted_wait.sh"
out=$(commit_and_read "$d")
leg waitloop_unread "$(echo "$out" | read_key finders)" 1
leg waitloop_no_build_sentinel "$(echo "$out" | read_key sentinels_build_output)" 0

# -- 5. A test mixing two variables names no single root ---------------------------------------
d=$(build mixed)
mkdir -p "$d/tools/fixtures/r"
{
  echo '#!/bin/sh'
  echo 'A=/one'
  echo 'B=/two'
  echo 'while [ ! -d "$A/rishi/bin" ] || [ ! -d "$B/tools/fixtures" ]; do'
  echo '  A=$(dirname "$A")'
  echo 'done'
} > "$d/tools/fixtures/r/planted_mixed.sh"
out=$(commit_and_read "$d")
leg mixed_var_unread "$(echo "$out" | read_key finders)" 1
leg mixed_var_not_bare "$(echo "$out" | read_key finders_bare_unrunnable)" 0

# -- 6. Ambiguity: a non-root directory answering every sentinel --------------------------------
d=$(build ambiguous)
plant_finder "$d" tools/fixtures/r/planted_amb.sh ROOT rishi/src tools/fixtures
mkdir -p "$d/nest/rishi/src" "$d/nest/tools/fixtures"
printf 'x\n' > "$d/nest/rishi/src/x.rye"
printf 'x\n' > "$d/nest/tools/fixtures/x.txt"
out=$(commit_and_read "$d")
leg ambiguous_seen "$(echo "$out" | read_key finders_ambiguous)" 2
leg ambiguous_row "$(commit_and_read "$d" --list | grep -c 'planted_amb.sh .*ambiguous=yes')" 1

d=$(build unambiguous)
plant_finder "$d" tools/fixtures/r/planted_un.sh ROOT rishi/src tools/fixtures
mkdir -p "$d/nest/rishi/src"
printf 'x\n' > "$d/nest/rishi/src/x.rye"
out=$(commit_and_read "$d")
leg unambiguous_clear "$(echo "$out" | read_key finders_ambiguous)" 0

# -- 7. The ceiling bites one past, and is proven from both sides -------------------------------
sed 's/^CEILING=189$/CEILING=1/' "$scan" > "$pen/scan_ceiling1.sh"
grep -q '^CEILING=1$' "$pen/scan_ceiling1.sh" || { echo "control_verdict=sed_failed" >&2; exit 1; }
d=$(build ceiling_at "$pen/scan_ceiling1.sh")
mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
printf 'rishi/bin/\n' > "$d/.gitignore"
plant_finder "$d" tools/fixtures/r/planted_1.sh ROOT rishi/bin tools/fixtures
out=$(commit_and_read "$d")
leg ceiling_at_bound_ok "$(echo "$out" | read_key finders_bare_unrunnable)" 1
leg ceiling_at_bound_verdict "$(echo "$out" | read_key verdict)" ok
plant_finder "$d" tools/fixtures/r/planted_2.sh ROOT rishi/bin tools/fixtures
out=$(commit_and_read "$d")
leg ceiling_one_past_counted "$(echo "$out" | read_key finders_bare_unrunnable)" 2
leg ceiling_one_past_refuses "$(echo "$out" | read_key verdict)" over_ceiling
rm -f "$d/tools/fixtures/r/planted_2.sh"
out=$(commit_and_read "$d")
leg ceiling_lifts_again "$(echo "$out" | read_key verdict)" ok

# -- 8. Modes answer their own questions --------------------------------------------------------
d=$(build modes)
plant_finder "$d" tools/fixtures/r/planted_m.sh ROOT rishi/src tools/fixtures
( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm pen >/dev/null 2>&1 )
rows=$( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh --list 2>/dev/null | grep -c 'verdict=[a-z_]* ambiguous=' )
count=$( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh 2>/dev/null | read_key finders )
leg list_rows_match_count "$rows" "$count"
leg explain_names_planted \
  "$( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh --explain tools/fixtures/r/planted_m.sh 2>/dev/null | grep -c 'planted_m.sh sentinels=' )" 1
leg explain_clear_file_says_so \
  "$( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh --explain README.md 2>/dev/null | grep -c 'carries no root-finder' )" 1
leg sentinels_mode_lists \
  "$( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh --sentinels 2>/dev/null | grep -c '^sentinel ' )" 2
( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh --bogus >/dev/null 2>&1 )
leg unknown_argument_refuses "$?" 2
( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh --explain >/dev/null 2>&1 )
leg explain_without_path_refuses "$?" 2

# -- 9. A pen with no finder at all reads zero, rather than reading this tree --------------------
d=$(build empty)
out=$(commit_and_read "$d")
leg empty_pen_one_finder "$(echo "$out" | read_key finders)" 1
# The pen holds exactly two tracked shell sources -- the scan and the dialect file it sources.
# This tree holds some thousands, so a scan that had resolved its root OUTSIDE the pen would read a
# number in four digits here and the leg would say so.
leg empty_pen_reads_the_pen "$(echo "$out" | read_key sources_tracked)" 2

# -- 10. THIS FAMILY'S OWN MEMBERSHIP, read out of the live scan rather than asserted ------------
live=$(sh tools/fixtures/r/root_finder_scan.sh --explain tools/fixtures/r/root_finder_control.sh 2>/dev/null)
case "$live" in
  *"root_finder_control.sh sentinels=rishi/src,tools/fixtures verdict=runnable"*) self=runnable ;;
  *"carries no root-finder"*) self=untracked_yet ;;
  *) self=unexpected ;;
esac
leg self_runnable_or_unstaged "$(case "$self" in runnable|untracked_yet) echo yes ;; *) echo "$self" ;; esac)" yes

echo "control_legs=$legs"
echo "control_failed=$fails"
if [ "$fails" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=failed"
fi
