#!/bin/sh
# tools/fixtures/r/rish_dangling_else_control.sh -- prove the dangling-else reading by doing.
#
# WHY. A guard that cannot red guards nothing (REDS %59). Two things are proven here and they are
# different in kind.
#
# THE GRAMMAR FACT IS RUN, NEVER CITED. Every sentence this reading rests on -- that an enclosing
# `if` takes the `else` first, that the assert then reports its bare condition, that a false
# condition hands a bare string to `eval_statement` -- is a claim about an interpreter, and the
# interpreter stands in this tree. So the first legs write real scripts into a throwaway pen and
# run `rishi/bin/rishi` against them. Where that binary is absent the control says
# `control_verdict=machine_fact` and stops, because a reading that cannot run its own subject has
# not proven it. That refusal is deliberate: `%806` was found precisely because a machine-fact
# state and a green state answered differently, and a control that quietly passed on a pier
# without the binary would repeat the fault it exists to read.
#
# THE SCAN'S CLASSIFICATION IS PLANTED. Real git repositories in the pen carry one shape each, the
# scan runs inside them, and each row is checked where it belongs. Nothing here touches the tree
# it is run from: every planted `.rish` line lives in the pen, so no plant ever enters the live
# population and moves the number the scan gates (`%785`).
#
# THIS CONTROL IS NOT IN THAT POPULATION, and it is proven rather than asserted -- it is a `.sh`
# file and the reading opens `.rish` alone, which the `self_invisible` leg reads out of the scan's
# own `--explain` rather than out of this sentence.
#
# THE CEILING IS PROVEN FROM BOTH SIDES WITH NO OVERRIDE IN THE SHIPPED INSTRUMENT. A pen copy of
# the scan is rewritten with `sed` to carry a ceiling of zero, so the live scan holds no
# environment variable, flag, or comment that lowers its own wall.
#
# USAGE
#   sh tools/fixtures/r/rish_dangling_else_control.sh
#
# Driven by tools/r/rish_dangling_else_witness.rish. Run from the repository root.

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

scan=$_fd_root/tools/fixtures/r/rish_dangling_else_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d) || exit 2
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

# Rishi echoes the offending source line beneath its report, so the message text appears in the
# output whether or not it reached `do_assert`. The REASON alone is what answers this question:
# the text after `assertion failed -- `, and nothing else on the page.
reason() { awk -F' -- ' '/^rishi: assertion failed -- /{ print $2; exit }'; }

# ---------------------------------------------------------------------------------------------
# PART ONE -- the grammar fact, run against the interpreter this tree ships.
# ---------------------------------------------------------------------------------------------

rishi=$_fd_root/rishi/bin/rishi
if [ ! -x "$rishi" ]; then
  echo "SKIPPED: machine fact -- rishi/bin/rishi is not built on this pier, and the grammar this"
  echo "reading rests on can only be proven by running it. Run sh rishi/bootstrap.sh to prove it here."
  echo "control_verdict=machine_fact"
  exit 0
fi

mkdir -p "$pen/g"

# run_script <name> <line> -- write one Rishi script and report its output and exit together.
run_script() {
  {
    echo 'let a = "hello"'
    echo "$2"
  } > "$pen/g/$1.rish"
  ( cd "$pen/g" && "$rishi" run "$1.rish" 2>&1 )
}

# THE HALF THE ROW FOUND. A false condition hands the else arm to `eval_statement`, and a bare
# string is no statement.
out=$(run_script false_branch 'if (a contains "nope") then assert a contains "zzz" else "MY MESSAGE"')
leg grammar_false_branch_refuses "$(echo "$out" | grep -c 'UnknownStatement')" 1

# THE HALF NOTHING HAD SEEN. The condition holds, the assert fails, and the reason reported is the
# bare condition -- the author's sentence never reached `do_assert` at all.
out=$(run_script true_branch 'if (a contains "hello") then assert a contains "zzz" else "MY MESSAGE"')
leg grammar_true_branch_asserts "$(echo "$out" | grep -c 'assertion failed')" 1
leg grammar_true_branch_swallows "$(echo "$out" | reason | grep -c 'MY MESSAGE')" 0
leg grammar_true_branch_bare_reason "$(echo "$out" | reason)" 'a contains "zzz"'

# PARENTHESES DO NOT HELP, because `find_word_op` tracks depth and the ` else ` still stands at
# top level once the condition's own parentheses have closed.
out=$(run_script parens 'if (a contains "hello") then assert (a contains "zzz") else "MY MESSAGE"')
leg grammar_parens_still_swallow "$(echo "$out" | reason | grep -c 'MY MESSAGE')" 0

# A VALID STATEMENT IN THE ELSE ARM DOES NOT HELP EITHER. The swallow happens when the arms are
# split, before either is looked at, so the false branch running correctly buys the assert nothing.
out=$(run_script say_arm 'if (a contains "hello") then assert a contains "zzz" else say "MY MESSAGE"')
leg grammar_say_arm_still_swallows "$(echo "$out" | reason | grep -c 'MY MESSAGE')" 0

# THE CONTRAST THAT NAMES THE CAUSE. The same assert with the same message, and no `if` around it,
# prints the message. So the loss is the enclosing `if`'s doing rather than the assert's.
out=$(run_script plain_assert 'assert a contains "zzz" else "MY MESSAGE"')
leg grammar_plain_assert_keeps_message "$(echo "$out" | reason)" 'MY MESSAGE'

# A NESTED `if` DOES NOT RESCUE IT: the OUTER if reaches the top-level ` else ` first.
out=$(run_script nested 'if (a contains "nope") then if (a contains "hello") then assert a contains "zzz" else "MY MESSAGE"')
leg grammar_nested_outer_takes_else "$(echo "$out" | grep -c 'UnknownStatement')" 1

# AND THE REPAIRED SHAPE WORKS, so the fault is a pairing rather than the assert message itself.
out=$(run_script repaired 'if (a contains "hello") then say "guarded"
assert a contains "zzz" else "MY MESSAGE"')
leg grammar_split_lines_keep_message "$(echo "$out" | reason)" 'MY MESSAGE'

# ---------------------------------------------------------------------------------------------
# PART TWO -- the scan's classification, planted in real repositories.
# ---------------------------------------------------------------------------------------------

# build <name> [<scan source>] -- a pen repository carrying the scan under test at its real path,
# with the tracked sentinels the scan's own root-finder needs.
build() {
  d=$pen/$1
  src=${2:-$scan}
  mkdir -p "$d/tools/fixtures/r" "$d/tools/fixtures/s" "$d/rishi/src"
  cp "$src" "$d/tools/fixtures/r/rish_dangling_else_scan.sh"
  cp "$_fd_root/tools/fixtures/s/shell_portable.sh" "$d/tools/fixtures/s/shell_portable.sh"
  printf '# pen\nA real document so no pen is merely empty.\n' > "$d/README.md"
  printf 'const std = @import("std");\n' > "$d/rishi/src/main.rye"
  ( cd "$d" && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen ) >/dev/null 2>&1
  echo "$d"
}

# plant <dir> <relative path> -- the remaining arguments become the file's lines.
plant() {
  d=$1; rel=$2; shift 2
  mkdir -p "$d/$(dirname "$rel")"
  : > "$d/$rel"
  for l in "$@"; do printf '%s\n' "$l" >> "$d/$rel"; done
}

commit_and_read() {
  ( cd "$1" && git add -A >/dev/null 2>&1 \
    && git commit -qm 'pen: one planted line' >/dev/null 2>&1
    sh tools/fixtures/r/rish_dangling_else_scan.sh ${2:-} 2>/dev/null )
}

# -- 1. A bare string else arm is the gated class ----------------------------------------------
d=$(build dangling)
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then assert a contains "y" else "the reason"'
out=$(commit_and_read "$d")
leg dangling_counted "$(echo "$out" | read_key dangling_else)" 1
leg dangling_is_a_then_assert_site "$(echo "$out" | read_key then_assert_sites)" 1
leg dangling_files_affected "$(echo "$out" | read_key files_affected)" 1

# -- 2. A statement else arm is reported apart, never gated -------------------------------------
d=$(build shadowed)
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then assert a contains "y" else say "over here"'
out=$(commit_and_read "$d")
leg shadowed_counted "$(echo "$out" | read_key assert_else_shadowed)" 1
leg shadowed_not_gated "$(echo "$out" | read_key dangling_else)" 0

# -- 3. A then-assert with no else at all is clean, and still counted as a site -----------------
d=$(build clean)
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then assert a contains "y"'
out=$(commit_and_read "$d")
leg clean_is_a_site "$(echo "$out" | read_key then_assert_sites)" 1
leg clean_not_dangling "$(echo "$out" | read_key dangling_else)" 0

# -- 4. A plain assert carrying its own message is invisible, which is the correct shape --------
d=$(build plain)
plant "$d" tools/p/planted.rish 'let a = "x"' 'assert a contains "y" else "the reason"'
out=$(commit_and_read "$d")
leg plain_assert_no_site "$(echo "$out" | read_key then_assert_sites)" 0
leg plain_assert_not_dangling "$(echo "$out" | read_key dangling_else)" 0

# -- 5. A commented line is read past ------------------------------------------------------------
d=$(build commented)
plant "$d" tools/p/planted.rish 'let a = "x"' '# if (a contains "x") then assert a contains "y" else "the reason"'
out=$(commit_and_read "$d")
leg comment_read_past "$(echo "$out" | read_key dangling_else)" 0

# -- 6. The nested shape is counted, because the outer `if` takes the else ----------------------
d=$(build nested)
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then if (a contains "y") then assert a contains "z" else "the reason"'
out=$(commit_and_read "$d")
leg nested_counted "$(echo "$out" | read_key dangling_else)" 1

# -- 7. An ` else ` standing inside a string literal is text, never structure --------------------
d=$(build in_string)
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then assert a contains " else "'
out=$(commit_and_read "$d")
leg string_else_is_not_structure "$(echo "$out" | read_key dangling_else)" 0
leg string_else_still_a_site "$(echo "$out" | read_key then_assert_sites)" 1
leg string_else_not_shadowed_either "$(echo "$out" | read_key assert_else_shadowed)" 0

# -- 8. A `for-each` body carries the same fault and is read ------------------------------------
d=$(build for_each)
plant "$d" tools/p/planted.rish 'let l = ["x"]' 'for-each l as a do if (a contains "x") then assert a contains "y" else "the reason"'
out=$(commit_and_read "$d")
leg for_each_body_counted "$(echo "$out" | read_key dangling_else)" 1

# -- 9. The population is Rishi; a shell file wearing the shape is another language --------------
d=$(build not_rish)
plant "$d" tools/p/planted.sh 'if (a contains "x") then assert a contains "y" else "the reason"'
out=$(commit_and_read "$d")
leg sh_file_not_read "$(echo "$out" | read_key then_assert_sites)" 0

# -- 10. Two sites in one file are two rows and one file ----------------------------------------
d=$(build two_in_one)
plant "$d" tools/p/planted.rish 'let a = "x"' \
  'if (a contains "x") then assert a contains "y" else "first reason"' \
  'if (a contains "x") then assert a contains "z" else "second reason"'
out=$(commit_and_read "$d")
leg two_sites_counted "$(echo "$out" | read_key dangling_else)" 2
leg two_sites_one_file "$(echo "$out" | read_key files_affected)" 1

# -- 11. A pen with nothing planted reads zero, and reads the PEN rather than this tree ----------
d=$(build empty)
out=$(commit_and_read "$d")
leg empty_pen_zero "$(echo "$out" | read_key then_assert_sites)" 0
# The pen holds exactly two tracked shell sources and no Rishi source at all. This tree holds some
# thousands of `.rish`, so a scan that had resolved its root OUTSIDE the pen would read a large
# number here -- which is what makes this leg a check on the root-finder rather than on the count.
leg empty_pen_reads_the_pen "$(echo "$out" | read_key sources_tracked)" 0

# -- 12. The ceiling refuses from both sides, with no override in the shipped scan ---------------
sed 's/^CEILING=6$/CEILING=0/' "$scan" > "$pen/scan_ceiling0.sh"
grep -q '^CEILING=0$' "$pen/scan_ceiling0.sh" || { echo "control_verdict=sed_failed" >&2; exit 1; }
d=$(build ceiling_over "$pen/scan_ceiling0.sh")
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then assert a contains "y" else "the reason"'
out=$(commit_and_read "$d")
leg ceiling_refuses_one_over "$(echo "$out" | read_key verdict)" over_ceiling
d=$(build ceiling_at "$pen/scan_ceiling0.sh")
out=$(commit_and_read "$d")
leg ceiling_walks_at_zero "$(echo "$out" | read_key verdict)" ok

# -- 13. This control is not in the population, read from the scan rather than claimed -----------
out=$(sh "$scan" --explain tools/fixtures/r/rish_dangling_else_control.sh 2>/dev/null)
leg self_invisible "$(echo "$out" | grep -c 'carries no if-then-assert site')" 1

# -- 14. The live reading answers, and its two classes sum to no more than its sites -------------
out=$(sh "$scan" 2>/dev/null)
live_d=$(echo "$out" | read_key dangling_else)
live_s=$(echo "$out" | read_key assert_else_shadowed)
live_t=$(echo "$out" | read_key then_assert_sites)
leg live_classes_within_sites "$([ "$((live_d + live_s))" -le "$live_t" ] && echo yes)" yes

# ---------------------------------------------------------------------------------------------
# PART THREE -- mutations. Each removes one load-bearing part of the scan and asserts it bites.
# ---------------------------------------------------------------------------------------------

# mutate <name> <sed expression> -- a pen copy of the scan with one part removed.
mutate() {
  sed "$2" "$scan" > "$pen/mut_$1.sh"
  cmp -s "$scan" "$pen/mut_$1.sh" && { echo "control_verdict=mutation_${1}_changed_nothing" >&2; exit 1; }
  echo "$pen/mut_$1.sh"
}

# M1. Blind the quote walk, so a ` else ` inside a string literal reads as structure.
m=$(mutate quotes 's|if (c == "\\"") { q = 1 - q; continue }|if (0) { q = 1 - q; continue }|')
d=$(build mut_quotes "$m")
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then assert a contains " else "'
# The arm a blinded walk finds here is a lone closing quote, which is no bare string literal, so
# the site lands in the reported class. Read beside `string_else_not_shadowed_either` above, that
# is the quote walk proven from both sides: zero with it, one without.
leg mutation_quotes_bites "$(commit_and_read "$d" | read_key assert_else_shadowed)" 1

# M2. Stop the arm walk after one level, so the nested shape escapes.
m=$(mutate nest 's|while (stmt ~ /\^if\[ \\t\]/) {|while (stmt ~ /^if[ \\t]/ \&\& steps == 0) {|')
d=$(build mut_nest "$m")
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then if (a contains "y") then assert a contains "z" else "the reason"'
leg mutation_nest_bites "$(commit_and_read "$d" | read_key dangling_else)" 0

# M3. Accept any arm as a bare string, so the reported class collapses into the gated one.
m=$(mutate barestring 's|if (claimed ~ /\^"\[^"\]\*"\$/) cls = "dangling_else"|if (1) cls = "dangling_else"|')
d=$(build mut_barestring "$m")
plant "$d" tools/p/planted.rish 'let a = "x"' 'if (a contains "x") then assert a contains "y" else say "over here"'
leg mutation_barestring_bites "$(commit_and_read "$d" | read_key dangling_else)" 1

# M4. Drop the comment skip, so a line teaching the fault is counted as one.
m=$(mutate comment 's|if (t ~ /\^#/ \|\| t == "") next|if (t == "") next|')
d=$(build mut_comment "$m")
plant "$d" tools/p/planted.rish 'let a = "x"' '# if (a contains "x") then assert a contains "y" else "the reason"'
leg mutation_comment_bites "$(commit_and_read "$d" | read_key dangling_else)" 1

echo "legs=$legs"
echo "fails=$fails"
if [ "$fails" -eq 0 ]; then
  echo "control_verdict=green"
else
  echo "control_verdict=red"
  exit 1
fi
