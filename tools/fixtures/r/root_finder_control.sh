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
  # An EMPTY baseline roster, so a pen's planted finder reads as growth unless that pen's own leg
  # rosters it. The file must exist: the scan refuses without one, which is proven on its own below.
  printf '# pen baseline -- empty unless a leg writes into it\n' > "$d/tools/fixtures/r/root_finder_baseline.txt"
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

# roster <pen> <path> ... -- put paths on that pen's baseline, so their finders read legacy.
roster() {
  d=$1; shift
  for r in "$@"; do echo "$r" >> "$d/tools/fixtures/r/root_finder_baseline.txt"; done
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
sed 's/^LEGACY_CEILING=191$/LEGACY_CEILING=1/' "$scan" > "$pen/scan_ceiling1.sh"
grep -q '^LEGACY_CEILING=1$' "$pen/scan_ceiling1.sh" || { echo "control_verdict=sed_failed" >&2; exit 1; }
d=$(build ceiling_at "$pen/scan_ceiling1.sh")
mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
printf 'rishi/bin/\n' > "$d/.gitignore"
plant_finder "$d" tools/fixtures/r/planted_1.sh ROOT rishi/bin tools/fixtures
roster "$d" tools/fixtures/r/planted_1.sh tools/fixtures/r/planted_2.sh
out=$(commit_and_read "$d")
leg ceiling_at_bound_ok "$(echo "$out" | read_key finders_bare_unrunnable)" 1
leg ceiling_at_bound_legacy "$(echo "$out" | read_key finders_bare_legacy)" 1
leg ceiling_at_bound_verdict "$(echo "$out" | read_key verdict)" ok
plant_finder "$d" tools/fixtures/r/planted_2.sh ROOT rishi/bin tools/fixtures
out=$(commit_and_read "$d")
leg ceiling_one_past_counted "$(echo "$out" | read_key finders_bare_unrunnable)" 2
leg ceiling_one_past_refuses "$(echo "$out" | read_key verdict)" over_ceiling
rm -f "$d/tools/fixtures/r/planted_2.sh"
out=$(commit_and_read "$d")
leg ceiling_lifts_again "$(echo "$out" | read_key verdict)" ok

# -- 7b. The growth gate: a bare finder in a file the roster does not carry ----------------------
#
# THE WHOLE POINT OF THE SPLIT. The elder reading refused this tree on a rise it could not
# attribute; this one refuses the FILE and names it, at zero, with no slack -- and the same finder
# rostered walks free, which is the legacy half saying yes.
d=$(build growth)
mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
printf 'rishi/bin/\n' > "$d/.gitignore"
plant_finder "$d" tools/fixtures/r/planted_g.sh ROOT rishi/bin tools/fixtures
out=$(commit_and_read "$d")
leg growth_new_counted "$(echo "$out" | read_key finders_bare_new)" 1
leg growth_not_legacy "$(echo "$out" | read_key finders_bare_legacy)" 0
leg growth_refuses "$(echo "$out" | read_key verdict)" new_finder
leg growth_row_named "$(commit_and_read "$d" --list | grep -c 'planted_g.sh .*growth=new')" 1
leg growth_total_unmoved "$(echo "$out" | read_key finders_bare_unrunnable)" 1

# The same bytes, rostered: the file is legacy and the tree walks free. A refusal proven only in
# the refusing direction cannot be told from a gate that refuses everything.
roster "$d" tools/fixtures/r/planted_g.sh
out=$(commit_and_read "$d")
leg rostered_is_legacy "$(echo "$out" | read_key finders_bare_legacy)" 1
leg rostered_not_new "$(echo "$out" | read_key finders_bare_new)" 0
leg rostered_walks_free "$(echo "$out" | read_key verdict)" ok
leg rostered_row_named "$(commit_and_read "$d" --list | grep -c 'planted_g.sh .*growth=legacy')" 1
leg baseline_paths_counted "$(echo "$out" | read_key baseline_paths)" 1

# A SECOND FINDER WRITTEN INTO A ROSTER FILE is legacy by path and still reds, because the legacy
# ceiling counts SITES. This is the hole the path-keyed roster would leave if the ceiling counted
# files, and it is proven rather than reasoned about.
sed 's/^LEGACY_CEILING=191$/LEGACY_CEILING=1/' "$scan" > "$pen/scan_legacy1.sh"
grep -q '^LEGACY_CEILING=1$' "$pen/scan_legacy1.sh" || { echo "control_verdict=sed_failed_legacy" >&2; exit 1; }
cp "$pen/scan_legacy1.sh" "$d/tools/fixtures/r/root_finder_scan.sh"
out=$(commit_and_read "$d")
leg second_site_base_ok "$(echo "$out" | read_key verdict)" ok
# The second finder is BUILT by plant_finder and appended, never written as a heredoc body. A
# heredoc is tracked bytes, and this scanner reads lines rather than shell structure -- so a
# literal `while [ ! -d ... ]` here would enter the LIVE population and move the very number the
# gate weighs. It did, on this leg's first run, and the new gate is what caught it (%785's hazard
# one room over). Every line plant_finder writes sits inside an `echo` argument, so no line of
# this file ever opens with the shape the extractor looks for.
plant_finder "$d" tools/fixtures/r/planted_g2.sh ROOT2 rishi/bin tools/fixtures
cat "$d/tools/fixtures/r/planted_g2.sh" >> "$d/tools/fixtures/r/planted_g.sh"
rm -f "$d/tools/fixtures/r/planted_g2.sh"
out=$(commit_and_read "$d")
leg second_site_counted "$(echo "$out" | read_key finders_bare_legacy)" 2
leg second_site_still_not_new "$(echo "$out" | read_key finders_bare_new)" 0
leg second_site_refuses "$(echo "$out" | read_key verdict)" over_ceiling

# -- 7c. The one false red this shape can make, measured rather than claimed --------------------
#
# A LAWFUL RENAME of a roster file leaves the roster behind and reads as growth. The repair is one
# roster row. Naming the cost as a leg is what keeps it from being discovered by a peer at 3am.
d=$(build rename)
mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
printf 'rishi/bin/\n' > "$d/.gitignore"
plant_finder "$d" tools/fixtures/r/planted_r.sh ROOT rishi/bin tools/fixtures
roster "$d" tools/fixtures/r/planted_r.sh
out=$(commit_and_read "$d")
leg rename_before_is_legacy "$(echo "$out" | read_key verdict)" ok
( cd "$d" && git mv tools/fixtures/r/planted_r.sh tools/fixtures/r/planted_r2.sh >/dev/null 2>&1 )
out=$(commit_and_read "$d")
leg rename_reads_as_new "$(echo "$out" | read_key finders_bare_new)" 1
leg rename_refuses "$(echo "$out" | read_key verdict)" new_finder
roster "$d" tools/fixtures/r/planted_r2.sh
out=$(commit_and_read "$d")
leg rename_one_roster_row_repairs "$(echo "$out" | read_key verdict)" ok

# -- 7d. The roster is load-bearing: its absence refuses rather than passing everything ---------
d=$(build no_roster)
plant_finder "$d" tools/fixtures/r/planted_n.sh ROOT rishi/src tools/fixtures
rm -f "$d/tools/fixtures/r/root_finder_baseline.txt"
( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm pen >/dev/null 2>&1 )
rc=0
( cd "$d" && sh tools/fixtures/r/root_finder_scan.sh >/dev/null 2>&1 ) || rc=$?
leg absent_roster_refuses "$rc" 2

# -- 7e. Mutation: drop the roster membership test and the growth gate stops seeing ------------
#
# The lookup is what turns a bare finder into `new`. With the `case` inverted to match everything,
# a pen whose roster is EMPTY must still read zero growth -- which is the gate gone silent.
sed 's|\*"\$NL\$path\$NL"\*)|*)|' "$scan" > "$pen/scan_noroster.sh"
grep -q '^      \*) growth=legacy' "$pen/scan_noroster.sh" \
  || { echo "control_verdict=sed_failed_noroster" >&2; exit 1; }
d=$(build mutation_noroster)
mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
printf 'rishi/bin/\n' > "$d/.gitignore"
plant_finder "$d" tools/fixtures/r/planted_mu.sh ROOT rishi/bin tools/fixtures
# THE UNMUTATED READING IN THIS SAME PEN, first. A mutation is only evidence where the truth it
# replaces differs from it; asserting 0 after the swap proves nothing unless 1 stood before it.
out=$(commit_and_read "$d")
leg mutation_control_reads_one "$(echo "$out" | read_key finders_bare_new)" 1
cp "$pen/scan_noroster.sh" "$d/tools/fixtures/r/root_finder_scan.sh"
out=$(commit_and_read "$d")
leg mutation_dropping_roster_test_bites "$(echo "$out" | read_key finders_bare_new)" 0
leg mutation_dropping_roster_test_moves_verdict "$(echo "$out" | read_key verdict)" ok

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

# -- 10. THE DOORS READING, over a pen whose every population is known by construction ---------
# Four files decide the sweep's cost here: one finder naming the build-output sentinel, one pen
# layout creating that directory inside a repository, and two creating it outside any repository.
# So `finder_files` reads 1, `pen_files` 3, the union 4, and `pen_files_no_repo` 2 -- four
# different counts over the same four files, which is what makes a merged number unable to stand
# in for any of them.
# doors_pen <name> [<scan source>] -- the one layout every doors leg reads, built once and reused
# by each mutation so a mutated reading is compared against the SAME three files.
doors_pen() {
  d=$(build "$1" ${2:+"$2"})
  mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
  printf 'rishi/bin/\n' > "$d/.gitignore"
  plant_finder "$d" tools/fixtures/r/planted_door.sh ROOT rishi/bin tools/fixtures
  mkdir -p "$d/tools/fixtures/p"
  printf '#!/bin/sh\npen=$(mktemp -d)\nmkdir -p "$pen/rishi/bin"\n( cd "$pen" && git init -q . )\n' \
    > "$d/tools/fixtures/p/pen_with_repo.sh"
  printf '#!/bin/sh\npen=$(mktemp -d)\nmkdir -p "$pen/rishi/bin"\n' \
    > "$d/tools/fixtures/p/pen_without_repo.sh"
  # A SECOND repo-less layout, so the git door's count differs from the count a mutation
  # inverting its filter would produce. One of each would make those two numbers agree.
  printf '#!/bin/sh\npen=$(mktemp -d)\nmkdir -p "$pen/rishi/bin/x"\n' \
    > "$d/tools/fixtures/p/pen_without_repo_b.sh"
  echo "$d"
}
door_key() { awk -v r="$1" '$2 == r' | tr ' ' '\n' | read_key "$2"; }

d=$(doors_pen doors)
doors=$(commit_and_read "$d" --doors)
leg doors_three_rows "$(echo "$doors" | grep -c '^door ')" 3
leg doors_sweep_finder_files \
  "$(echo "$doors" | door_key sweep finder_files)" 1
leg doors_sweep_counts_pens \
  "$(echo "$doors" | door_key sweep pen_files)" 3
leg doors_sweep_union \
  "$(echo "$doors" | door_key sweep files)" 4
leg doors_git_door_prices_no_repo \
  "$(echo "$doors" | door_key git_root pen_files_no_repo)" 2
leg doors_track_reads_nothing_tracked \
  "$(echo "$doors" | door_key track tracked_today)" 0
leg doors_track_names_the_rule \
  "$(echo "$doors" | door_key track ignore_rule | grep -c gitignore)" 1
# The replacement's two properties, measured in a pen where `rishi/src` is tracked and stands at
# the root alone -- the same two readings the live tree answers.
leg doors_replacement_tracked \
  "$(echo "$doors" | door_key sweep replacement_tracked)" yes
leg doors_replacement_not_below_root \
  "$(echo "$doors" | door_key sweep replacement_below_root)" 0

# A REPLACEMENT OCCURRING BELOW THE ROOT IS CAUGHT. One tracked file under `sub/rishi/src/` makes
# the proposed sentinel answer somewhere below the root, where a swept walk would stop early.
mkdir -p "$d/sub/rishi/src" && printf 'x\n' > "$d/sub/rishi/src/f.rye"
leg doors_replacement_below_root_seen \
  "$(commit_and_read "$d" --doors | door_key sweep replacement_below_root)" 1

# -- 11. A TREE WITH NO BUILD-OUTPUT SENTINEL PRINTS NO DOOR AT ALL -----------------------------
# The comfortable failure here is a reading that always emits its three rows; a door named for a
# sentinel that does not exist is an invitation to sweep nothing.
d=$(build doors_clean)
plant_finder "$d" tools/fixtures/r/planted_clean.sh ROOT rishi/src tools/fixtures
leg doors_clean_tree_no_rows "$(commit_and_read "$d" --doors | grep -c '^door ')" 0

# -- 12. BOTH REPAIRS PROVEN ON METAL, in a real checkout of tracked bytes ----------------------
# `git clone` carries tracked content and nothing else, which is exactly the checkout %788 names.
# The elder finder must refuse there, and each door must resolve -- run rather than argued.
d=$(build doors_metal)
mkdir -p "$d/rishi/bin" && printf 'binary\n' > "$d/rishi/bin/rishi"
printf 'rishi/bin/\n' > "$d/.gitignore"
plant_finder "$d" tools/fixtures/r/elder.sh ROOT rishi/bin tools/fixtures
plant_finder "$d" tools/fixtures/r/swept.sh ROOT rishi/src tools/fixtures
( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm 'pen: two finders' >/dev/null 2>&1 )
git clone -q "$d" "$pen/bare_checkout" 2>/dev/null
( cd "$pen/bare_checkout" && sh tools/fixtures/r/elder.sh >/dev/null 2>&1 )
leg metal_elder_refuses_in_tracked_bytes "$?" 2
leg metal_swept_resolves_in_tracked_bytes \
  "$( cd "$pen/bare_checkout" && sh tools/fixtures/r/swept.sh 2>/dev/null )" planted

# THE TRACK DOOR, with one tracked file under the build-output name and NO finder changed.
printf '/rishi/bin/\n!/rishi/bin/.keep\n' > "$d/.gitignore"
printf 'This directory holds the built rishi binary.\n' > "$d/rishi/bin/.keep"
( cd "$d" && git add -A -f >/dev/null 2>&1 && git commit -qm 'pen: track the sentinel' >/dev/null 2>&1 )
git clone -q "$d" "$pen/tracked_checkout" 2>/dev/null
leg metal_track_door_carries_sentinel \
  "$( [ -d "$pen/tracked_checkout/rishi/bin" ] && echo yes || echo no )" yes
leg metal_elder_resolves_after_track_door \
  "$( cd "$pen/tracked_checkout" && sh tools/fixtures/r/elder.sh 2>/dev/null )" planted

# -- 13. THE DOORS READING'S OWN MUTATIONS, RUN rather than recorded ----------------------------
# A paper's account of its own mutations is a claim. Each mutation below rewrites a pen copy of
# the scan by LINE NUMBER, reads the same three-file layout through it, and asserts the number
# moves. Each planted value is checked to differ from the truth, since a plant landing on the
# value already standing tests the unmutated file.
mutate() {
  sed "$2" "$scan" > "$pen/scan_$1.sh"
  cmp -s "$scan" "$pen/scan_$1.sh" && { echo "control_verdict=mutation_$1_changed_nothing" >&2; exit 1; }
  d=$(doors_pen "mut_$1" "$pen/scan_$1.sh")
  commit_and_read "$d" --doors
}
pen_line() { grep -n "$1" "$scan" | head -1 | cut -d: -f1; }

# 1. The pen-layout population is the half nobody had counted. Emptied, the sweep's cost falls
#    back to the finder count the row already knew -- 2 pen files become 0 and the union 3 become 1.
out=$(mutate nopens "$(pen_line 'grep -lE "mkdir')s|mkdir|zzznomatch|")
leg mutation_dropping_pen_count_bites "$(echo "$out" | door_key sweep pen_files)" 0
leg mutation_dropping_pen_count_moves_union "$(echo "$out" | door_key sweep files)" 1

# 2. The git door is priced by the pens building NO repository. Inverting that one flag counts the
#    pens that DO build one -- 1 against the truth's 2, which is why the layout carries two.
out=$(mutate norepofilter "$(pen_line "grep -LE 'git")s|grep -LE|grep -lE|")
leg mutation_inverting_repo_filter_bites "$(echo "$out" | door_key git_root pen_files_no_repo)" 1

# 3. A door named for a sentinel standing in every checkout invites a sweep repairing nothing.
#    Removing the class filter emits a row per sentinel rather than per build output.
out=$(mutate allclasses "$(pen_line '\[ "\$cls" = build_output \]')s|.*|    :|")
leg mutation_dropping_class_filter_bites \
  "$( [ "$(echo "$out" | grep -c '^door ')" -gt 3 ] && echo more || echo three )" more

# 4. THE BELOW-ROOT GUARD, mutated against a pen that HAS a below-root occurrence -- the only
#    layout where the guard can be seen working. Narrowing the pattern to the root's own path
#    reads 0 where the truth is 1, which is a false all-clear about where a swept walk stops.
sed "$(pen_line 'git ls-files -- "\*/\$SWEEP_TO/\*"')s|\*/\$SWEEP_TO/\*|\$SWEEP_TO/*|" \
  "$scan" > "$pen/scan_belowroot.sh"
cmp -s "$scan" "$pen/scan_belowroot.sh" && { echo "control_verdict=mutation_belowroot_changed_nothing" >&2; exit 1; }
d=$(doors_pen mut_belowroot "$pen/scan_belowroot.sh")
mkdir -p "$d/sub/rishi/src" && printf 'x\n' > "$d/sub/rishi/src/f.rye"
leg mutation_narrowing_below_root_bites \
  "$(commit_and_read "$d" --doors | door_key sweep replacement_below_root)" 0

# -- 13. THIS FAMILY'S OWN MEMBERSHIP, read out of the live scan rather than asserted ------------
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
