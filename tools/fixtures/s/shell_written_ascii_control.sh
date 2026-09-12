#!/bin/sh
# shell_written_ascii_control.sh -- prove tools/fixtures/s/shell_written_ascii_scan.sh on planted shell.
#
# Every refusal is shown from BOTH sides: planted, counted, then lifted and counted again. A
# reading proven only in the passing direction cannot be told from a bypass. Three MUTATIONS run
# the scan with one line broken and assert the leg that must bite actually bites -- a control whose
# legs all pass against a broken instrument is a control proving nothing.
#
# The pen is a REAL git repository, because the scan's roster is `git ls-files`.
#
# USAGE
#   sh tools/fixtures/s/shell_written_ascii_control.sh
#
# Run from the repository root.

set -u

ROOT=$(pwd)
SCAN=$ROOT/tools/fixtures/s/shell_written_ascii_scan.sh
pen=$(mktemp -d 2>/dev/null || mktemp -d -t shwr) || exit 1
trap 'rm -rf "$pen"' EXIT

legs=0
failed=0

# Every leg prints BOTH a human line and a `<name>=yes|no` the witness asserts on, so a leg written
# tomorrow is heard the day it lands rather than hiding under a verdict that only says the control
# reached its last line.
ok() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "$1=yes"
    echo "# leg $1 ok ($2)"
  else
    echo "$1=no"
    echo "# leg $1 FAILED want=$2 got=$3"
    failed=$((failed + 1))
  fi
}

# The planted characters are real bytes, so this control's own source stays ASCII. A control
# planting the NAME of a character proves nothing about bytes.
EM=$(printf '\342\200\224')
MID=$(printf '\302\267')
# A form the rule's table leaves to a reader's judgment -- counted in `written`, never in `named`.
SECT=$(printf '\302\247')

mk() { mkdir -p "$pen/$(dirname "$1")"; cat > "$pen/$1"; }

read_key() { LC_ALL=C awk -F= -v k="$2" '$1 == k { print $2 }' "$1"; }

run() {
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$SCAN" > "$pen/out.txt" 2>"$pen/err.txt" )
}

cd "$pen" || exit 1
git init -q . >/dev/null 2>&1
git config user.email pen@example.invalid
git config user.name pen
cd "$ROOT" || exit 1

# --- the clean floor -------------------------------------------------------
mk clean.sh <<EOF
#!/bin/sh
echo "plain ascii only"
EOF
run
ok clean_written 0 "$(read_key "$pen/out.txt" written)"
ok clean_verdict ok "$(read_key "$pen/out.txt" verdict)"
ok clean_instrument ok "$(read_key "$pen/out.txt" instrument)"
ok clean_files_read 1 "$(read_key "$pen/out.txt" files_read)"

# --- a heredoc body is the subject -----------------------------------------
mk pour.sh <<EOF
#!/bin/sh
cat >> page.md <<'BODY'
entry one $EM two
BODY
EOF
run
ok heredoc_counts 1 "$(read_key "$pen/out.txt" written)"
ok heredoc_named 1 "$(read_key "$pen/out.txt" written_named)"
ok heredoc_files 1 "$(read_key "$pen/out.txt" files_with_written)"
rm -f "$pen/pour.sh"
run
ok heredoc_lifts 0 "$(read_key "$pen/out.txt" written)"

# --- a .rish source is read too, one law and two extensions ----------------
mk tool.rish <<EOF
run ["sh" "-c" "true"]
cat > out.md <<'BODY'
a $MID b
BODY
EOF
run
ok rish_counts 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/tool.rish"

# --- the named tail is reported apart from the notation tail ---------------
mk mixed.sh <<EOF
cat > out.md <<'BODY'
named $EM here and judged $SECT here
BODY
EOF
run
ok mixed_written 2 "$(read_key "$pen/out.txt" written)"
ok mixed_named 1 "$(read_key "$pen/out.txt" written_named)"
rm -f "$pen/mixed.sh"

# --- the two sibling rooms, each left whole --------------------------------
# A `#` comment outside a heredoc belongs to shell_comment_ascii_scan.sh.
mk comment.sh <<EOF
#!/bin/sh
# a header note $EM here
echo hi
EOF
run
ok comment_not_counted 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/comment.sh"

# A spoken line outside a heredoc belongs to rish_spoken_ascii_scan.sh.
mk spoken.rish <<EOF
say "the guard says $EM this"
EOF
run
ok spoken_not_counted 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/spoken.rish"

# A `#` line INSIDE a heredoc is content rather than prose, and counts here.
mk hashbody.sh <<EOF
cat > out.md <<'BODY'
# a heading $EM inside the body
BODY
EOF
run
ok hash_inside_heredoc_counts 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/hashbody.sh"

# --- the shell's own delimiter rules, kept exactly --------------------------
# `<<-WORD` closes on an INDENTED delimiter.
mk dash.sh <<EOF
cat > out.md <<-BODY
	inside $EM one
	BODY
echo "outside $EM two"
EOF
run
ok dash_closes_indented 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/dash.sh"

# Plain `<<WORD` does NOT close on an indented delimiter, so the body runs on.
mk plain.sh <<EOF
cat > out.md <<BODY
inside $EM one
	BODY
still inside $EM two
BODY
EOF
run
ok plain_ignores_indented_delim 2 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/plain.sh"

# Both quoted delimiter spellings open.
mk quoted.sh <<EOF
cat > a.md <<'ONE'
single $EM quoted
ONE
cat > b.md <<"TWO"
double $EM quoted
TWO
EOF
run
ok quoted_delims_open 2 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/quoted.sh"

# --- three shapes that are NOT heredoc openers ------------------------------
mk shift.sh <<EOF
n=\$((1 << 3))
echo "after the shift $EM here"
EOF
run
ok arith_shift_not_opener 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/shift.sh"

mk herestring.sh <<EOF
read -r x <<< "word"
echo "after the here-string $EM here"
EOF
run
ok here_string_not_opener 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/herestring.sh"

# An opener quoted inside a `#` comment must not swallow the rest of the file.
mk commented_opener.sh <<EOF
#!/bin/sh
# the shape is <<WORD through its delimiter
echo "after the note $EM here"
EOF
run
ok commented_opener_not_read 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/commented_opener.sh"

# --- the classification: code the heredoc IS, against data it FEEDS ---------
# A bare interpreter consumes the heredoc AS CODE.
mk prog.sh <<EOF
python3 <<'PY'
print("a $EM b")
PY
EOF
run
ok program_counted_in_written 1 "$(read_key "$pen/out.txt" written)"
ok program_classified 1 "$(read_key "$pen/out.txt" program)"
ok program_not_sweepable 0 "$(read_key "$pen/out.txt" sweepable)"
rm -f "$pen/prog.sh"

# The same interpreter with a SCRIPT PATH hands the heredoc that script's stdin, which is data.
mk data.sh <<EOF
sh tools/x/engine.sh <<'DATA'
entry $EM one
DATA
EOF
run
ok data_not_program 0 "$(read_key "$pen/out.txt" program)"
ok data_sweepable 1 "$(read_key "$pen/out.txt" sweepable)"
rm -f "$pen/data.sh"

# `exec` is read past, so the almanac's own shape classifies as data.
mk execdata.sh <<EOF
exec sh "\$(dirname "\$0")/engine.sh" <<'DATA'
entry $EM one
DATA
EOF
run
ok exec_read_past 0 "$(read_key "$pen/out.txt" program)"
rm -f "$pen/execdata.sh"

# `-c` makes the heredoc code again even with words after it.
mk dashc.sh <<EOF
sh -c 'cat' <<'EOF2'
body $EM here
EOF2
EOF
run
ok dash_c_is_program 1 "$(read_key "$pen/out.txt" program)"
rm -f "$pen/dashc.sh"

# A pipeline's command is the one after the last separator.
mk pipe.sh <<EOF
cat list | python3 <<'PY'
print("x $EM y")
PY
EOF
run
ok pipeline_command_read 1 "$(read_key "$pen/out.txt" program)"
rm -f "$pen/pipe.sh"

# --- the rooms this scan reads past ----------------------------------------
mk vendor/thing.sh <<EOF
cat > out.md <<'BODY'
vendored $EM text
BODY
EOF
run
ok vendor_read_past 0 "$(read_key "$pen/out.txt" written)"
rm -rf "$pen/vendor"

# --- the ceiling, proven from both sides -----------------------------------
ceil=$(LC_ALL=C awk -F= '$1 == "ceiling" { print $2 }' "$pen/out.txt")
ok ceiling_present yes "$([ -n "$ceil" ] && echo yes || echo no)"
mk at.sh <<EOF
cat > out.md <<'BODY'
one $EM here
BODY
EOF
mutate_ceiling() {
  mfile=$pen/mutant.sh
  sed "s/^ceiling=.*/ceiling=$1/" "$SCAN" > "$mfile"
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$mfile" > "$pen/mout.txt" 2>/dev/null )
  read_key "$pen/mout.txt" "$2"
}
ok ceiling_at_bound yes "$(mutate_ceiling 1 under_ceiling)"
ok ceiling_one_over no "$(mutate_ceiling 0 under_ceiling)"
rm -f "$pen/at.sh"

# --- a meter that cannot read must say so ----------------------------------
# A tracked path git lists and the filesystem lacks is the shape REDS %513 booked: an empty answer
# from a refused read is byte-identical to an empty answer from a clean tree.
mk gone.sh <<EOF
echo ok
EOF
( cd "$pen" && git add -A >/dev/null 2>&1 )
rm -f "$pen/gone.sh"
( cd "$pen" && sh "$SCAN" > "$pen/out.txt" 2>/dev/null )
ok absent_not_counted_clean 0 "$(read_key "$pen/out.txt" files_unreadable)"
( cd "$pen" && git rm -q --cached gone.sh >/dev/null 2>&1 )

# --- mutations: each must bite ---------------------------------------------
mutate() {
  mfile=$pen/mutant.sh
  sed "$1" "$SCAN" > "$mfile"
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$mfile" > "$pen/mout.txt" 2>/dev/null )
  read_key "$pen/mout.txt" "$2"
}

# Mutation one: the local that shadows the named-form counter. This fired for real on the lap this
# meter was seated -- `written` read 1,419 and `written_named` read 0, which is exactly what a tree
# carrying only judgment-call notation prints. A counter clobbered by a local is invisible from its
# own output.
mk shadow.sh <<EOF
cat > out.md <<'BODY'
one $EM here
BODY
EOF
run
ok mutation_shadow_applied 1 "$(read_key "$pen/out.txt" written_named)"
ok mutation_shadow_bites 0 "$(mutate 's/trimmed = s$/t = s/' written_named)"
rm -f "$pen/shadow.sh"

# Mutation two: drop the script-path operand check, so every interpreter word reads as code and the
# whole almanac population would vanish from `sweepable`.
mk operand.sh <<EOF
sh tools/x/engine.sh <<'DATA'
entry $EM one
DATA
EOF
run
ok mutation_operand_applied 0 "$(read_key "$pen/out.txt" program)"
ok mutation_operand_bites 1 "$(mutate 's|^        return 0$|        return 1|' program)"
rm -f "$pen/operand.sh"

# Mutation three: drop the `<<-` distinction, so a plain heredoc closes early on an indented
# delimiter and assembled text after it goes unread.
mk early.sh <<EOF
cat > out.md <<BODY
inside $EM one
	BODY
still inside $EM two
BODY
EOF
run
ok mutation_dash_applied 2 "$(read_key "$pen/out.txt" written)"
ok mutation_dash_bites 1 "$(mutate 's/(dash \&\& trimmed == delim)/(1 \&\& trimmed == delim)/' written)"
rm -f "$pen/early.sh"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
fi
