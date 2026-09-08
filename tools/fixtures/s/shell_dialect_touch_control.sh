#!/bin/sh
# tools/fixtures/s/shell_dialect_touch_control.sh -- the pen for shell_dialect_touch_scan.sh.
#
# WHAT THIS PROVES. Twenty-eight behaviors, each on a real git repository built in a throwaway pen.
# The scan reads a commit's staged set and asks whether any shell source it carries writes a
# GNU-only idiom. So the pen builds exactly that: a tree with the elder scan in it, a commit
# staging a portable script, a commit staging a GNU-only one, and a commit staging neither.
#
# Each refusal is shown from BOTH sides -- planted, then lifted. A refusal proven only in the
# passing direction reads the same as a bypass. Each welcome is asserted as hard as each refusal,
# because a guard that reds on ordinary work is a guard somebody turns off.
#
# THE SEAM THIS PEN EXISTS FOR is the line between the five families held at zero and the one held
# at seven. A ceiling of zero is what makes a whole-blob reading safe: no lawful site exists, so
# every hit is a rise. The moment a ceiling leaves zero the same reading would refuse an author for
# a line somebody else wrote -- so the pen moves a ceiling and proves the family goes quiet.
#
# THE WALL ITSELF IS DRIVEN, rather than the reading alone. The last four cases copy
# tools/hooks/pre-commit into the pen's own hooks directory and run real `git commit` calls through
# it: one refused, one freed by the portable spelling, one staging no shell at all.
#
# THE PLANTS ARE ASSEMBLED, NEVER SPELLED. This file sits on the elder scan's own roster, so a
# line here writing a gated flag beside its command IS a site by the elder's reading -- and the
# families this pen plants stand at ceilings of zero and seven, where one more of either is a
# refusal. So each plant is built from a flag held in a variable. The elder meets the same problem
# in prose and answers it the same way: a guard that must NAME one of these families spells it
# without the flag.
#
#   sh tools/fixtures/s/shell_dialect_touch_control.sh
#
# Run from the repository root; the pen is removed on exit whether it passes or fails.
set -u

if [ -n "${GRAIN_MIND_GIT:-}" ] && [ -f "$GRAIN_MIND_GIT" ]; then
  git() { bash "$GRAIN_MIND_GIT" "$@"; }
fi

scan=tools/fixtures/s/shell_dialect_touch_scan.sh
elder=tools/fixtures/s/shell_dialect_scan.sh
hook=tools/hooks/pre-commit
for f in "$scan" "$elder"; do
  if [ ! -f "$f" ]; then
    echo "control=refused"
    echo "refused: $f is what this pen drives, and it is absent" >&2
    exit 1
  fi
done

mkdir -p .mind-state/tmp
pen=$(mktemp -d .mind-state/tmp/dialect-touch.XXXXXX) || exit 1
trap 'rm -rf "$pen"' EXIT

fails=0
ok() { echo "case=$1 ok"; }
no() { echo "case=$1 FAILED -- $2"; fails=$((fails + 1)); }

mkdir -p "$pen/tools/fixtures/s" "$pen/tools/am"
cp "$scan"  "$pen/tools/fixtures/s/shell_dialect_touch_scan.sh"
cp "$elder" "$pen/tools/fixtures/s/shell_dialect_scan.sh"
# The helper is named by the elder as a read-past path, so the pen carries it: a scan that cannot
# find the file it excludes would count the answer as a fault.
: > "$pen/tools/fixtures/s/shell_portable.sh"

( cd "$pen" && git init -q . && git config user.email pen@example.invalid \
  && git config user.name Pen && git config commit.gpgsign false ) || {
  echo "control=refused"; echo "refused: the pen could not become a git repository" >&2; exit 1; }
( cd "$pen" && git add -A && git commit -qm "pen: the elder scan and its helper" )

run()     { ( cd "$pen" && sh tools/fixtures/s/shell_dialect_touch_scan.sh "$@" 2>/dev/null ); }
verdict() { run "$@" | grep '^verdict=' | head -1 | cut -d= -f2; }
key()     { k=$1; shift; run "$@" | grep "^$k=" | head -1 | cut -d= -f2; }

# The two flags this pen plants, held apart from the commands they belong to.
i_flag=-i
f_flag=-f

portable=tools/am/a_portable_witness.rish
gnu=tools/am/a_gnu_only_witness.rish
prose=tools/am/a_witness_that_explains.rish
plain=notes/a_plain_document.md

# -- the resting state: a commit staging nothing this scan speaks for ------------------------------
mkdir -p "$pen/notes"
printf 'A document, not a shell source.\n' > "$pen/$plain"
( cd "$pen" && git add "$plain" )
[ "$(verdict)" = ok ] && ok resting_commit_walks_free || no resting_commit_walks_free "a commit staging no shell refused"
[ "$(key files_read)" = 0 ] && ok resting_reads_no_file || no resting_reads_no_file "files_read was not zero"
( cd "$pen" && git commit -qm "pen: a document" )

# -- a portable shell source walks free -----------------------------------------------------------
printf 'let out = run ["sh" "-c" "sed \x27s|a|b|\x27 $f > $f.tmp && cat $f.tmp > $f"]\n' > "$pen/$portable"
( cd "$pen" && git add "$portable" )
[ "$(verdict)" = ok ] && ok portable_source_walks_free || no portable_source_walks_free "a portable source was refused"
[ "$(key files_read)" = 1 ] && ok portable_source_is_read || no portable_source_is_read "the portable source was not read"
( cd "$pen" && git commit -qm "pen: a portable witness" )

# -- the gated class, planted ---------------------------------------------------------------------
printf 'let out = run ["sh" "-c" "sed %s \x27s|a|b|\x27 $f"]\n' "$i_flag" > "$pen/$gnu"
( cd "$pen" && git add "$gnu" )
[ "$(verdict)" = misread ] && ok gnu_only_refuses || no gnu_only_refuses "a GNU-only idiom walked free"
[ "$(key staged_gated_sites)" = 1 ] && ok gnu_only_counted || no gnu_only_counted "the count did not read one"
run | grep -q "^detail=RED_staged_gnu_only_idiom" \
  && ok gnu_only_names_its_class || no gnu_only_names_its_class "the detail line was absent"
run | grep -q "^detail_family=sed_in_place_flag" \
  && ok gnu_only_names_its_family || no gnu_only_names_its_family "the family was not named"
run | grep -q "^detail_path=$gnu" \
  && ok gnu_only_names_the_path || no gnu_only_names_the_path "the path was not named"
run | grep -q "^detail_repair=" \
  && ok gnu_only_names_the_repair || no gnu_only_names_the_repair "the repair was not named"
run | grep -q "^detail_site=$gnu:1:" \
  && ok gnu_only_names_the_line || no gnu_only_names_the_line "the site did not carry the file's own line"
run | grep -q "$pen" && no pen_path_stays_out_of_the_report "a pen path reached the report" \
  || ok pen_path_stays_out_of_the_report

# -- and lifted -----------------------------------------------------------------------------------
printf 'let out = run ["sh" "-c" "sed \x27s|a|b|\x27 $f > $f.tmp && cat $f.tmp > $f"]\n' > "$pen/$gnu"
( cd "$pen" && git add "$gnu" )
[ "$(verdict)" = ok ] && ok repaired_source_walks_free || no repaired_source_walks_free "the repaired source stayed refused"

# -- the reading is off the INDEX, never the worktree ----------------------------------------------
# The staged blob is portable; the worktree copy is not. A reading off disk would refuse a commit
# that carries nothing wrong.
printf 'let out = run ["sh" "-c" "sed %s \x27s|a|b|\x27 $f"]\n' "$i_flag" > "$pen/$gnu"
[ "$(verdict)" = ok ] && ok reads_the_index_not_the_disk || no reads_the_index_not_the_disk "an unstaged edit was read"
( cd "$pen" && git checkout -- "$gnu" && git commit -qm "pen: a repaired witness" )

# -- a comment is prose, not a command -------------------------------------------------------------
printf '# This witness once wrote sed %s and no longer does.\nlet out = run ["sh" "true"]\n' "$i_flag" > "$pen/$prose"
( cd "$pen" && git add "$prose" )
[ "$(verdict)" = ok ] && ok a_comment_is_not_a_site || no a_comment_is_not_a_site "an explanation was counted as a site"
( cd "$pen" && git commit -qm "pen: a witness that explains itself" )

# -- head mode reads the commit just made ----------------------------------------------------------
printf 'let out = run ["sh" "-c" "sed %s \x27s|a|b|\x27 $f"]\n' "$i_flag" > "$pen/$gnu"
( cd "$pen" && git add "$gnu" && git commit -qm "pen: a GNU-only idiom committed" )
[ "$(verdict head)" = misread ] && ok head_mode_reads_the_commit || no head_mode_reads_the_commit "head mode did not see the committed idiom"

# -- a family whose ceiling has LEFT zero goes quiet -------------------------------------------------
# This is the seam the whole safety argument rests on. `readlink -f` stands at seven in the tree, so
# a staged file carrying one is reported and never gated. The pen asserts both halves.
printf 'p=$(readlink %s "$f")\n' "$f_flag" > "$pen/tools/am/a_readlink_witness.sh"
( cd "$pen" && git checkout -- "$gnu" 2>/dev/null; git add tools/am/a_readlink_witness.sh )
[ "$(verdict)" = ok ] && ok advisory_family_walks_free || no advisory_family_walks_free "an above-zero family was gated"
[ "$(key staged_advisory_readlink_sites)" = 1 ] && ok advisory_family_is_counted || no advisory_family_is_counted "the advisory site was not counted"
( cd "$pen" && git commit -qm "pen: a readlink witness" )

# -- the scan's own source and its helper are read past ----------------------------------------------
# Both spell the idioms on purpose. Counting either tells a reader to delete the answer.
( cd "$pen" && touch tools/fixtures/s/shell_dialect_scan.sh tools/fixtures/s/shell_portable.sh \
  && git add tools/fixtures/s/ 2>/dev/null; true )
printf 'sed %s "s|a|b|" "$f"\n' "$i_flag" >> "$pen/tools/fixtures/s/shell_portable.sh"
( cd "$pen" && git add tools/fixtures/s/shell_portable.sh )
[ "$(verdict)" = ok ] && ok helper_is_read_past || no helper_is_read_past "the portable helper was counted"
( cd "$pen" && git checkout -- tools/fixtures/s/shell_portable.sh 2>/dev/null; git reset -q )

# -- a scan that cannot find its patterns refuses rather than waving the family through -------------
mv "$pen/tools/fixtures/s/shell_dialect_scan.sh" "$pen/elder.aside"
[ "$(verdict)" = misread ] && ok missing_source_refuses || no missing_source_refuses "an absent elder read as clean"
run | grep -q "^detail=RED_dialect_source_absent" \
  && ok missing_source_names_itself || no missing_source_names_itself "the absent-source refusal did not name itself"
mv "$pen/elder.aside" "$pen/tools/fixtures/s/shell_dialect_scan.sh"

# -- the planted refusal, and the arguments the scan refuses ----------------------------------------
[ "$(verdict prove-red)" = misread ] && ok prove_red_refuses || no prove_red_refuses "prove-red did not refuse"
[ "$(verdict nonsense)" = misread ] && ok unknown_argument_refuses || no unknown_argument_refuses "an unknown argument walked free"

# -- the WALL itself, not merely the reading ---------------------------------------------------------
if [ -f "$hook" ]; then
  mkdir -p "$pen/.git/hooks" "$pen/rishi/bin"
  cp "$hook" "$pen/.git/hooks/pre-commit"
  chmod +x "$pen/.git/hooks/pre-commit"
  # The hook opens `[ -x rishi/bin/rishi ] || exit 0`, so a tree without the interpreter is one the
  # hook declines to speak in. The pen plants an executable stub rather than the interpreter: this
  # rule shells out to `sh`, and a hook that silently exits would prove nothing at all.
  printf '#!/bin/sh\nexit 0\n' > "$pen/rishi/bin/rishi"
  chmod +x "$pen/rishi/bin/rishi"

  hooked=tools/am/a_witness_the_wall_must_refuse.rish
  printf 'let out = run ["sh" "-c" "sed %s \x27s|a|b|\x27 $f"]\n' "$i_flag" > "$pen/$hooked"
  ( cd "$pen" && git add "$hooked" )
  if hook_said=$( cd "$pen" && git commit -qm "pen: a witness the wall must refuse" 2>&1 ); then
    no hook_refuses_gnu_only "the wall let a GNU-only idiom commit"
  else
    ok hook_refuses_gnu_only
  fi
  printf '%s' "$hook_said" | grep -q "one host's dialect" \
    && ok hook_says_why || no hook_says_why "the refusal did not say what was wrong"
  printf '%s' "$hook_said" | grep -q "detail_repair=" \
    && ok hook_names_repair || no hook_names_repair "the refusal did not name the repair"

  printf 'let out = run ["sh" "-c" "sed \x27s|a|b|\x27 $f > $f.tmp && cat $f.tmp > $f"]\n' > "$pen/$hooked"
  ( cd "$pen" && git add "$hooked" )
  if ( cd "$pen" && git commit -qm "pen: the portable spelling" >/dev/null 2>&1 ); then
    ok hook_frees_portable_source
  else
    no hook_frees_portable_source "the wall refused a portable source"
  fi

  printf 'y\n' > "$pen/notes/another.md"
  ( cd "$pen" && git add notes/another.md )
  if ( cd "$pen" && git commit -qm "pen: a commit staging no shell" >/dev/null 2>&1 ); then
    ok hook_rests_off_shell
  else
    no hook_rests_off_shell "the wall refused a commit staging no shell"
  fi
else
  no hook_present "tools/hooks/pre-commit is absent, so the wall could not be driven"
fi

echo "cases_failed=$fails"
if [ "$fails" -gt 0 ]; then
  echo "control=misread"
  exit 1
fi
echo "control=ok"
