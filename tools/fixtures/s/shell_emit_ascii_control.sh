#!/bin/sh
# shell_emit_ascii_control.sh -- prove tools/fixtures/s/shell_emit_ascii_scan.sh on planted shell.
#
# Every refusal is shown from BOTH sides: planted, counted, then lifted and counted again. A
# reading proven only in the passing direction cannot be told from a bypass. Four MUTATIONS run the
# scan with one line broken and assert the leg that must bite actually bites -- a control whose legs
# all pass against a broken instrument is a control proving nothing.
#
# The pen is a REAL git repository, because the scan's roster is `git ls-files`.
#
# USAGE
#   sh tools/fixtures/s/shell_emit_ascii_control.sh
#
# Run from the repository root.

set -u

ROOT=$(pwd)
SCAN=$ROOT/tools/fixtures/s/shell_emit_ascii_scan.sh
pen=$(mktemp -d 2>/dev/null || mktemp -d -t shem) || exit 1
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
# A form the rule's table leaves to a reader's judgment -- counted in `emit`, never in `emit_named`.
SECT=$(printf '\302\247')
# A box-drawing character: the population a converter must never touch, since a terminal frame is
# the rule's own named exception.
BOX=$(printf '\342\224\200')

mk() { mkdir -p "$pen/$(dirname "$1")"; cat > "$pen/$1"; }

read_key() { LC_ALL=C awk -F= -v k="$2" '$1 == k { print $2 }' "$1"; }

run() {
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$SCAN" > "$pen/out.txt" 2>"$pen/err.txt" )
}

mutate() {
  mfile=$pen/mutant.sh
  sed "$1" "$SCAN" > "$mfile"
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$mfile" > "$pen/mout.txt" 2>/dev/null )
  read_key "$pen/mout.txt" "$2"
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
ok clean_emit 0 "$(read_key "$pen/out.txt" emit)"
ok clean_verdict ok "$(read_key "$pen/out.txt" verdict)"
ok clean_instrument ok "$(read_key "$pen/out.txt" instrument)"
ok clean_files_read 1 "$(read_key "$pen/out.txt" files_read)"

# --- the subject: an emit operand ------------------------------------------
mk speak.sh <<EOF
#!/bin/sh
echo "a spoken line $EM here"
EOF
run
ok echo_counts 1 "$(read_key "$pen/out.txt" spoken)"
ok echo_named 1 "$(read_key "$pen/out.txt" emit_named)"
ok echo_files 1 "$(read_key "$pen/out.txt" files_with_emit)"
rm -f "$pen/speak.sh"
run
ok echo_lifts 0 "$(read_key "$pen/out.txt" emit)"

# The family named `printf` and the population was `echo`; both are read.
mk fmt.sh <<EOF
printf '%s\n' "a formatted line $MID here"
EOF
run
ok printf_counts 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/fmt.sh"

# --- spoken and written, decided by the line's own redirect ----------------
mk redir.sh <<EOF
echo "this becomes a file $EM here" > out.md
EOF
run
ok redirect_is_written 1 "$(read_key "$pen/out.txt" written)"
ok redirect_not_spoken 0 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/redir.sh"

# A redirect TARGET is a path rather than prose, and no meter charges a filename.
mk target.sh <<EOF
echo "plain ascii" > "name$EM.txt"
EOF
run
ok redirect_target_free 0 "$(read_key "$pen/out.txt" emit)"
rm -f "$pen/target.sh"

# --- the sibling rooms, each left whole ------------------------------------
# A `#` comment belongs to shell_comment_ascii_scan.sh.
mk comment.sh <<EOF
#!/bin/sh
# a header note $EM here
echo hi
EOF
run
ok comment_not_counted 0 "$(read_key "$pen/out.txt" emit)"
rm -f "$pen/comment.sh"

# A trailing comment on an emit line is the same room, and the operand beside it is this one.
mk trailing.sh <<EOF
echo "operand $EM here" # and a note $EM there
EOF
run
ok trailing_comment_split 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/trailing.sh"

# A heredoc body belongs to shell_written_ascii_scan.sh, whose opener rule is kept exactly.
mk pour.sh <<EOF
cat >> page.md <<'BODY'
entry one $EM two
BODY
echo "after the body $EM here"
EOF
run
ok heredoc_body_not_counted 1 "$(read_key "$pen/out.txt" emit)"
rm -f "$pen/pour.sh"

# A `say` line belongs to rish_spoken_ascii_scan.sh; it is no emit verb, so it needs no exclusion.
mk spoken.rish <<EOF
say "the guard says $EM this"
EOF
run
ok say_not_counted 0 "$(read_key "$pen/out.txt" emit)"
rm -f "$pen/spoken.rish"

# --- the quote walk, which is the whole reason this meter could not exist ---
# A `#` inside a quoted argument does not begin a comment.
mk hashq.sh <<EOF
echo "a hash # inside a quote $EM still prose"
EOF
run
ok hash_in_quote_counts 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/hashq.sh"

# A `>` inside a quoted argument is prose rather than a redirect.
mk gtq.sh <<EOF
echo "an arrow > inside a quote $EM spoken"
EOF
run
ok gt_in_quote_is_spoken 1 "$(read_key "$pen/out.txt" spoken)"
ok gt_in_quote_not_written 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/gtq.sh"

# An escaped quote inside a double quote does not end the string.
mk esc.sh <<EOF
echo "an escaped \\" quote $EM here"
EOF
run
ok escaped_quote_counts 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/esc.sh"

# A single quote holds a double quote whole.
mk single.sh <<EOF
echo 'a " inside a single quote $EM here'
EOF
run
ok single_holds_double 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/single.sh"

# --- where a command actually begins ---------------------------------------
# After a pipe.
mk pipe.sh <<EOF
true | echo "after a pipe $EM here"
EOF
run
ok emit_after_pipe 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/pipe.sh"

# Inside a command substitution.
mk subst.sh <<EOF
v=\$(echo "inside a substitution $EM here")
EOF
run
ok emit_in_substitution 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/subst.sh"

# After a keyword. `then echo ...` runs echo, and leaving this step out lost 21 characters.
mk kw.sh <<EOF
if true; then echo "in a branch $EM here"; fi
EOF
run
ok emit_after_keyword 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/kw.sh"

# An assignment is not an emit, however much prose it carries.
mk assign.sh <<EOF
LABEL="an assigned string $EM here"
EOF
run
ok assignment_not_counted 0 "$(read_key "$pen/out.txt" emit)"
rm -f "$pen/assign.sh"

# An assignment standing BEFORE a command does not hide it.
mk prefix.sh <<EOF
LC_ALL=C echo "after an assignment prefix $EM here"
EOF
run
ok assignment_prefix_counts 1 "$(read_key "$pen/out.txt" spoken)"
rm -f "$pen/prefix.sh"

# --- the named half, and the half a reader must judge ----------------------
mk mixed.sh <<EOF
echo "named $EM here, judged $SECT there, drawn $BOX beside"
EOF
run
ok mixed_emit 3 "$(read_key "$pen/out.txt" emit)"
ok mixed_named 1 "$(read_key "$pen/out.txt" emit_named)"
rm -f "$pen/mixed.sh"

# --- the ceiling, proven from both sides -----------------------------------
mk ceil.sh <<EOF
echo "one $EM two $EM three $EM"
EOF
run
ok ceiling_default_under yes "$(read_key "$pen/out.txt" under_ceiling)"
( cd "$pen" && git add -A >/dev/null 2>&1; SHELL_EMIT_ASCII_CEILING=3 sh "$SCAN" > "$pen/out.txt" 2>/dev/null )
ok ceiling_at_bound_passes yes "$(read_key "$pen/out.txt" under_ceiling)"
( cd "$pen" && git add -A >/dev/null 2>&1; SHELL_EMIT_ASCII_CEILING=2 sh "$SCAN" > "$pen/out.txt" 2>/dev/null )
ok ceiling_one_past_refuses no "$(read_key "$pen/out.txt" under_ceiling)"
rm -f "$pen/ceil.sh"

# --- an instrument that cannot read says so --------------------------------
mk gone.sh <<EOF
echo "present for now"
EOF
( cd "$pen" && git add -A >/dev/null 2>&1 )
chmod 000 "$pen/gone.sh" 2>/dev/null
( cd "$pen" && sh "$SCAN" > "$pen/out.txt" 2>/dev/null )
unreadable=$(read_key "$pen/out.txt" files_unreadable)
if [ "${unreadable:-0}" -gt 0 ]; then
  ok unreadable_refuses refused "$(read_key "$pen/out.txt" verdict)"
  ok unreadable_ceiling_no no "$(read_key "$pen/out.txt" under_ceiling)"
else
  # Running as a user who reads every mode, the plant cannot be made. Say so rather than
  # claiming a proof this host could not take.
  ok unreadable_skipped_here yes yes
  ok unreadable_ceiling_skipped yes yes
fi
chmod 644 "$pen/gone.sh" 2>/dev/null
rm -f "$pen/gone.sh"

# --- mutations: each must bite ---------------------------------------------
# Mutation one: drop the keyword step, so `then echo ...` stops reading as an emit.
mk mut_kw.sh <<EOF
if true; then echo "in a branch $EM here"; fi
EOF
run
ok mutation_keyword_applied 1 "$(read_key "$pen/out.txt" spoken)"
ok mutation_keyword_bites 0 "$(mutate 's|^        if (c ~ /\^(then|XXNEVERXX (c ~ /^(then|' spoken)"
rm -f "$pen/mut_kw.sh"

# Mutation two: stop the double quote from opening a quoted region, which is the quote walk
# itself. The `#` standing inside the string then ends the line and every character after it is
# lost -- the exact reading the family named as the reason this meter could not be written.
mk mut_hash.sh <<EOF
echo "a hash # inside a quote $EM still prose"
EOF
run
ok mutation_quote_applied 1 "$(read_key "$pen/out.txt" spoken)"
ok mutation_quote_bites 0 "$(mutate 's|"\\"";   seg = seg|"";   seg = seg|' spoken)"
rm -f "$pen/mut_hash.sh"

# Mutation three: stop skipping the heredoc body, so the sibling's room is billed twice.
mk mut_here.sh <<EOF
cat >> page.md <<'BODY'
echo "entry $EM one"
BODY
EOF
run
ok mutation_heredoc_applied 0 "$(read_key "$pen/out.txt" emit)"
ok mutation_heredoc_bites 1 "$(mutate 's|^        inhere = 1$|        inhere = 0|' emit)"
rm -f "$pen/mut_here.sh"

# Mutation four: the local that shadows the named-form counter, the shape that fired for real one
# meter over -- `emit` reads its full count and `emit_named` reads zero, which is exactly what a
# tree carrying only judgment-call notation prints.
mk mut_named.sh <<EOF
echo "named $EM here"
EOF
run
ok mutation_named_applied 1 "$(read_key "$pen/out.txt" emit_named)"
ok mutation_named_bites 0 "$(mutate 's|function tally(str, kind,   stop, at, seq, k, ch)|function tally(str, kind,   stop, at, seq, k, ch, t)|' emit_named)"
rm -f "$pen/mut_named.sh"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
fi
