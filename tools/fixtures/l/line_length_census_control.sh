#!/bin/sh
# tools/fixtures/l/line_length_census_control.sh -- proves the census scan beside it both ways,
# on miniature sources in a throwaway pen.
#
# Every refusal is planted and then LIFTED, so a refusal stays tellable from a bypass; every
# welcome is asserted as hard as every refusal, because a counter that counts nothing reads
# exactly like a corpus with nothing to count.
#
#   sh tools/fixtures/l/line_length_census_control.sh

set -u
LC_ALL=C
export LC_ALL

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_ll_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/.git" ]; do
  _ll_steps=$((_ll_steps + 1))
  if [ "$_ll_steps" -gt 8 ] || [ "$ROOT" = "/" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN=${LINE_LENGTH_SCAN:-$ROOT/tools/fixtures/l/line_length_census_scan.sh}

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
fail=0

leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $legs $1 ok"
  else
    fail=$((fail + 1))
    echo "leg $legs $1 FAIL want=$2 got=$3"
  fi
}

read_leg() {
  printf '%s\n' "$2" | sed -n "s/^$1=//p"
}

run_scan() {
  d=$1
  shift
  LINE_LENGTH_CORPUS="$d" sh "$SCAN" "$@" 2>&1
}

long() {  # long <prefix> <columns>
  printf '%s' "$1"
  i=${#1}
  while [ "$i" -lt "$2" ]; do printf 'x'; i=$((i + 1)); done
  printf '\n'
}

# ---------------------------------------------------------------- a short, ordinary Rye source
mkdir -p "$pen/mod"
{
  echo '// a short comment'
  echo 'pub fn small() void {}'
} > "$pen/mod/short.rye"

out=$(run_scan "$pen")
leg short_one_file       1 "$(read_leg files_read "$out")"
leg short_two_lines      2 "$(read_leg lines "$out")"
leg short_counts_nothing 0 "$(read_leg over "$out")"
leg short_no_file_over   0 "$(read_leg files_over "$out")"
leg short_verdict       ok "$(read_leg verdict "$out")"

# A CORPUS HOLDING NO LONG LINE AT ALL MUST LIVE. Under `set -eu` a grep matching nothing ends the
# walk, so the tree this rule hopes for is exactly the one an unguarded reader would die on -- the
# lantern that bit a sibling scan on `20260911`. Ordered ahead of the first plant on purpose.
out=$(run_scan "$pen"); rc=$?
leg clean_corpus_lives     0 "$rc"
leg clean_corpus_verdict  ok "$(read_leg verdict "$out")"
leg clean_corpus_zero      0 "$(read_leg over "$out")"


# ------------------------------------------------------- one code line past the bound, and lifted
long 'pub fn wide(' 140 >> "$pen/mod/short.rye"
out=$(run_scan "$pen")
leg code_counted        1 "$(read_leg over "$out")"
leg code_side           1 "$(read_leg over_code "$out")"
leg code_not_comment    0 "$(read_leg over_comment "$out")"
leg code_file_counted   1 "$(read_leg files_over "$out")"

# THE BOUNDARY IS EXACT, from both sides. A line AT the bound is welcome; one past it is counted.
: > "$pen/mod/edge.rye"
long 'pub fn edge(' 100 >> "$pen/mod/edge.rye"
out=$(run_scan "$pen")
leg edge_at_bound_free  1 "$(read_leg over "$out")"
long 'pub fn edge2(' 101 >> "$pen/mod/edge.rye"
out=$(run_scan "$pen")
leg edge_past_bound_bit 2 "$(read_leg over "$out")"
rm -f "$pen/mod/edge.rye"

# ------------------------------------------------------------- the split, in all four comment marks
: > "$pen/mod/marks.rye"
long '// a long Rye comment ' 130 >> "$pen/mod/marks.rye"
long '   // an indented one ' 130 >> "$pen/mod/marks.rye"
: > "$pen/mod/marks.rish"
long '# a long Rishi comment ' 130 >> "$pen/mod/marks.rish"
: > "$pen/mod/marks.glow"
long ':: a long Glow comment ' 130 >> "$pen/mod/marks.glow"
: > "$pen/mod/marks.kyri"
long '# a long Kyri comment ' 130 >> "$pen/mod/marks.kyri"
out=$(run_scan "$pen")
leg marks_comments_split 5 "$(read_leg over_comment "$out")"
leg marks_code_unmoved   1 "$(read_leg over_code "$out")"

# A MARK BELONGING TO ANOTHER LANGUAGE IS CODE, not a comment. `#` opens no comment in Rye, and a
# scan that read the mark without the extension would call this line prose.
: > "$pen/mod/wrongmark.rye"
long '# not a Rye comment at all ' 130 >> "$pen/mod/wrongmark.rye"
out=$(run_scan "$pen")
leg wrong_mark_is_code   2 "$(read_leg over_code "$out")"
leg wrong_mark_not_prose 5 "$(read_leg over_comment "$out")"
rm -f "$pen/mod/wrongmark.rye"

# ---------------------------------------------------- the claim line, the third class, both ways
# A Rishi `say` or `assert` carries a sentence, so its width is prose in code's syntax. It is
# counted apart, and the same bytes in a Rye file stay code -- the class is the language's form
# rather than the word.
: > "$pen/mod/claims.rish"
long 'say "a witness claim that runs long ' 130 >> "$pen/mod/claims.rish"
long 'assert x.ok else "a refusal sentence that runs long ' 130 >> "$pen/mod/claims.rish"
long 'let y = run ["sh" "some/long/path.sh" ' 130 >> "$pen/mod/claims.rish"
out=$(run_scan "$pen")
leg claim_counted        2 "$(read_leg over_claim "$out")"
leg claim_leaves_run     2 "$(read_leg over_code "$out")"
: > "$pen/mod/claims.rye"
long 'say "the same words in a Rye file " ' 130 >> "$pen/mod/claims.rye"
out=$(run_scan "$pen")
leg claim_is_language_bound 2 "$(read_leg over_claim "$out")"
leg claim_rye_stays_code    3 "$(read_leg over_code "$out")"
rm -f "$pen/mod/claims.rish" "$pen/mod/claims.rye"

# ------------------------------------------------------------------------- the four read-past rooms
for room in vendor gratitude seed session-logs; do
  mkdir -p "$pen/$room"
  long '// planted long line ' 150 > "$pen/$room/planted.rye"
done
mkdir -p "$pen/tools/fixtures/z"
long '// planted long line ' 150 > "$pen/tools/fixtures/z/planted.rye"
out=$(run_scan "$pen")
leg rooms_read_past_over    6 "$(read_leg over "$out")"
leg rooms_read_past_files   5 "$(read_leg files_read "$out")"

# AND THE SAME BYTES INSIDE THE SUBJECT ARE COUNTED, so the exclusions are proven to be about the
# room rather than about the line.
mkdir -p "$pen/mod/sub"
long '// planted long line ' 150 > "$pen/mod/sub/planted.rye"
out=$(run_scan "$pen")
leg subject_counts_same_bytes 7 "$(read_leg over "$out")"
rm -rf "$pen/mod/sub"

# ---------------------------------------------------------------- an unknown extension is unread
long 'print("a long Python line") ' 150 > "$pen/mod/other.py"
out=$(run_scan "$pen")
leg family_only_five 5 "$(read_leg files_read "$out")"
rm -f "$pen/mod/other.py"

# --------------------------------------------------------------------------- --max moves the bound
out=$(run_scan "$pen" --max 200)
leg max_flag_raises 0 "$(read_leg over "$out")"
out=$(run_scan "$pen" --max 20)
leg max_flag_lowers_all 7 "$(read_leg over "$out")"

# ------------------------------------------------------------------------- --list names the members
out=$(run_scan "$pen" --list)
listed=$(printf '%s\n' "$out" | grep -c '^  over=')
leg list_names_each_file 5 "$listed"

# ------------------------------------------------------------- an empty corpus refuses, never zero
mkdir -p "$pen/empty"
out=$(run_scan "$pen/empty"); rc=$?
leg empty_refuses reach_empty "$(read_leg verdict "$out")"
leg empty_exit_nonzero 1 "$rc"

# ------------------------------------------------------ the bound, and the path a space would split
# Every collection names a maximum, and a corpus past it refuses by name rather than being
# truncated by the kernel's argument vector.
out=$(LINE_LENGTH_MAX_FILES=1 run_scan "$pen" 2>&1); rc=$?
leg bound_refuses corpus_over_bound "$(read_leg verdict "$out")"
leg bound_exit    1 "$rc"
out=$(LINE_LENGTH_MAX_FILES=9999 run_scan "$pen" 2>&1)
leg bound_lifts   ok "$(read_leg verdict "$out")"

# A PATH CARRYING A SPACE REFUSES. The file list is expanded unquoted into one awk, so a space
# would split one path into two unreadable ones -- silently, and downward, which is the direction
# a census can least afford.
cp "$pen/mod/short.rye" "$pen/mod/a name.rye"
out=$(run_scan "$pen" 2>&1); rc=$?
leg space_refuses path_unsafe "$(read_leg verdict "$out")"
leg space_exit    1 "$rc"
rm -f "$pen/mod/a name.rye"
out=$(run_scan "$pen" 2>&1)
leg space_lifts   ok "$(read_leg verdict "$out")"


# ------------------------------------------------------------- the one gate: reach, from both sides
# The floor is skipped for a pen, because a pen is deliberately tiny. Against the real tree it is
# the whole gate, so it is proven here rather than trusted -- a floor nobody has watched refuse is
# a floor that may not be wired to anything.
out=$(LINE_LENGTH_REACH_FLOOR=999999 sh "$SCAN" 2>&1); rc=$?
leg reach_floor_bites reach_short "$(read_leg verdict "$out")"
leg reach_floor_exit  1 "$rc"
out=$(LINE_LENGTH_REACH_FLOOR=1 sh "$SCAN" 2>&1)
leg reach_floor_lifts ok "$(read_leg verdict "$out")"

# ---------------------------------------------------------------------------------- two mutations
# A leg that passes over a scan and over a broken copy of it is a leg proving nothing. Each
# mutation below is a single edit to the scan's own text, and each must make a named leg fall.
mut=$pen/mutant.sh

# MUTATION ONE -- the fixtures exclusion removed. A plant read as a subject is the trap the
# seventh room of the doorway roster closed one law over.
sed 's@\*/fixtures/\*|fixtures/\*) continue ;;@*/fixtures-never/*) continue ;;@' "$SCAN" > "$mut"
leg mutation_one_applied 1 "$(grep -c 'fixtures-never' "$mut")"
out=$(LINE_LENGTH_CORPUS="$pen" sh "$mut" 2>&1)
leg mutation_fixtures_bites 6 "$(read_leg files_read "$out")"

# MUTATION TWO -- the extension dropped from the Rishi comment test, so a `#` line in a RYE file
# reads as prose. The comment-versus-code split is the whole finding of this census, and a split
# that cannot be wrong is not a measurement.
sed 's@(ext == "rish" || ext == "bron" || ext == "kyri") \&\& @@' "$SCAN" > "$mut"
leg mutation_two_applied 0 "$(grep -c 'ext == "bron"' "$mut")"
: > "$pen/mod/wrongmark.rye"
long '# not a Rye comment at all ' 130 >> "$pen/mod/wrongmark.rye"
out=$(LINE_LENGTH_CORPUS="$pen" sh "$mut" 2>&1)
leg mutation_mark_bites 6 "$(read_leg over_comment "$out")"
out=$(run_scan "$pen")
leg mutation_mark_lifts 5 "$(read_leg over_comment "$out")"
rm -f "$pen/mod/wrongmark.rye"

echo "control_legs=$legs control_fail=$fail"
[ "$fail" -eq 0 ] || exit 1
exit 0
