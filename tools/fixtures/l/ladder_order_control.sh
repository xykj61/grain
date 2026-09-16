#!/bin/sh
# tools/fixtures/l/ladder_order_control.sh -- proves the behaviors of
# tools/fixtures/l/ladder_order_scan.sh in a throwaway pen, every reading shown from both sides.
#
# WHAT IS PLANTED AND WHAT IS MUTATED. Every reading of this scan has a population -- a page --
# so all of them are proven by PLANTING pages whose right answer is known by construction, then
# changing one thing and watching the reading move. A refusal proven only in the passing
# direction cannot be told from a bypass, so each refusal is planted and then lifted.
#
# The two readings worth the most care are the ones the real page turned on. A COLLISION is what
# decides `permutation`, and a page can reach it three ways -- two recommendations naming one
# seat, a recommendation landing on a seat the standing table already holds, and "last" resolving
# onto the final seat -- so all three are planted apart. And the CLASS partition must stay
# disjoint: a row falling into two classes, or none, breaks the one property that makes the
# weaker statement true, so its total is gated against the roster rather than assumed.
#
#   sh tools/fixtures/l/ladder_order_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  [ "$_steps" -gt 8 ] && { echo "$0: no tree root" >&2; exit 2; }
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/l/ladder_order_scan.sh"

# One shell dialect on both piers: `sed -i` takes no argument on GNU and REQUIRES a backup suffix
# on BSD, so the flag is gated at zero tree-wide and `sed_inplace` is the portable form.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
legs=0
LEGS_EXPECTED=54

ok() { legs=$((legs + 1)); pass=$((pass + 1)); echo "ok   $legs $1"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "FAIL $legs $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else no "$1 -- wanted [$3], read [$2]"; fi; }
field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$2" | tail -1; }

mkdir -p "$PEN/pages" "$PEN/.lap"
cd "$PEN"

# plant_page DEST N_ROWS -- a page of N rows, ranked 1..N in order, with no errata at all.
plant_page() {
  _dest="$1"; _n="$2"
  {
    echo "# A planted ladder"
    echo ""
    echo "## The twelve, single-stranded"
    echo ""
    _i=1
    while [ "$_i" -le "$_n" ]; do
      echo "### $_i. A planted row"
      echo "**Claim.** This row claims one plain thing."
      echo ""
      _i=$((_i + 1))
    done
    echo "## The ranking"
    echo ""
    echo "| Rank | Row | Why here |"
    echo "|---|---|---|"
    _i=1
    while [ "$_i" -le "$_n" ]; do
      echo "| $_i | $_i. A planted row | because it was planted |"
      _i=$((_i + 1))
    done
  } > "$_dest"
}

# erratum DEST ROW STAMP SENTENCE -- prepend one erratum clause, as the real page carries them.
erratum() {
  _dest="$1"; _row="$2"; _stamp="$3"; _sentence="$4"
  printf '**Row %s erratum:** `%s` -- a planted reading. %s\n' "$_row" "$_stamp" "$_sentence" \
    > "$_dest.new"
  cat "$_dest" >> "$_dest.new"
  mv "$_dest.new" "$_dest"
}

run() { LADDER_PAGE="$1" sh "$SCAN" > out.txt 2>&1; }

echo "--- reading 1: the roster is counted, never assumed ---"

plant_page pages/plain.md 12
run pages/plain.md
check "a twelve-row page reads twelve rows"      "$(field rows out.txt)"            "12"
check "twelve ranked seats are read"             "$(field standing_ranked out.txt)" "12"
check "a page with no errata carries no clause"  "$(field errata_clauses out.txt)"  "0"
check "no erratum leaves every row unread"       "$(field class_unread out.txt)"    "12"
check "no erratum recommends no position"        "$(field positions_recommended out.txt)" "0"
check "the standing table seats all twelve"      "$(field positions_inherited out.txt)"   "12"
check "a clean standing table collides nowhere"  "$(field collisions out.txt)"      "0"
check "the classes still partition the roster"   "$(field classes_partition out.txt)" "yes"

plant_page pages/thirteen.md 13
run pages/thirteen.md
check "a thirteenth row is SEEN, never hard-coded" "$(field rows out.txt)"          "13"
check "a thirteenth seat is read too"            "$(field standing_ranked out.txt)" "13"
check "thirteen rows partition into thirteen"    "$(field class_total out.txt)"     "13"

echo "--- reading 3: the disposition classes, each planted apart ---"

plant_page pages/kinds.md 6
erratum pages/kinds.md 1 20260101.000001 "Recommended re-rank: last of the six."
erratum pages/kinds.md 2 20260101.000002 "Recommended **re-aim rather than re-rank, and a rank of fourth**: keep it."
erratum pages/kinds.md 3 20260101.000003 "Recommended **re-aim**: keep the row and drop one sentence."
erratum pages/kinds.md 4 20260101.000004 "Recommended disposition: **breach** -- superseded here."
erratum pages/kinds.md 5 20260101.000005 "The reading stands elsewhere, and recommends nothing at all."
run pages/kinds.md
check "five clauses on five rows are all parsed"  "$(field errata_clauses out.txt)"  "5"
check "five rows carry an erratum"                "$(field rows_with_erratum out.txt)" "5"
check "a page's clauses are all read"             "$(field parse_failures out.txt)"  "0"
check "the sixth row stays unread"                "$(field class_unread out.txt)"    "1"
check "'last' is a demotion, never a seat"        "$(field class_demoted out.txt)"   "1"
check "a named ordinal is a seat"                 "$(field class_seated out.txt)"    "1"
check "a re-aim naming no seat is a re-aim"       "$(field class_reaimed out.txt)"   "1"
check "a breach supersedes"                       "$(field class_superseded out.txt)" "1"
check "an erratum recommending nothing reports"   "$(field class_reported out.txt)"  "1"
check "six rows, six classes, one each"           "$(field class_total out.txt)"     "6"
check "the classes partition the roster"          "$(field classes_partition out.txt)" "yes"
check "four of five clauses recommend"            "$(field rows_recommending out.txt)" "4"

echo "--- the disposition order: a sentence may carry two words, and the stronger speaks ---"

plant_page pages/both.md 4
erratum pages/both.md 1 20260101.000001 "Recommended **re-aim rather than re-rank, and a rank of third**: keep it."
run pages/both.md
check "re-aim naming a seat is seated, not re-aimed" "$(field class_seated out.txt)" "1"
check "and it is not counted as a re-aim"            "$(field class_reaimed out.txt)" "0"

plant_page pages/breachseat.md 4
erratum pages/breachseat.md 1 20260101.000001 "Recommended disposition: **breach**, and a rank of second."
run pages/breachseat.md
check "a breach speaks over a seat in one sentence" "$(field class_superseded out.txt)" "1"
check "and the superseded row claims no seat"       "$(field class_seated out.txt)"     "0"

echo "--- the latest erratum per row is the one that speaks ---"

plant_page pages/two.md 4
erratum pages/two.md 1 20260101.000001 "Recommended **re-aim**: keep the row."
erratum pages/two.md 1 20260202.000002 "Recommended disposition: **breach** -- superseded."
run pages/two.md
check "two clauses on one row are both parsed"    "$(field errata_clauses out.txt)"  "2"
check "yet one row carries an erratum"            "$(field rows_with_erratum out.txt)" "1"
check "the LATER stamp speaks"                    "$(field class_superseded out.txt)" "1"
check "and the earlier one is silent"             "$(field class_reaimed out.txt)"   "0"

echo "--- reading 2 and the collision: three roads to one refusal ---"

# A recommendation landing on a seat the standing table already holds.
plant_page pages/onto.md 4
erratum pages/onto.md 3 20260101.000001 "Recommended re-rank: a rank of second."
run pages/onto.md
check "a seat the table already holds collides"   "$(field collisions out.txt)"      "1"
check "and no permutation stands"                 "$(field permutation out.txt)"     "no"
check "the partition survives the collision"      "$(field classes_partition out.txt)" "yes"
check "a collided page is partition_only"         "$(field verdict out.txt)"         "partition_only"

# Two recommendations naming ONE seat.
plant_page pages/same.md 4
erratum pages/same.md 1 20260101.000001 "Recommended re-rank: a rank of fourth."
erratum pages/same.md 2 20260101.000002 "Recommended re-rank: a rank of fourth."
run pages/same.md
check "two recommendations on one seat collide"   "$(field collisions out.txt)"      "1"

# "last" resolving onto the final seat, which the standing table's own last row holds.
plant_page pages/last.md 4
erratum pages/last.md 1 20260101.000001 "Recommended re-rank: last of the four."
run pages/last.md
check "'last' lands on the final seat and collides" "$(field collisions out.txt)"    "1"

# And the lift: the same page with the recommendation removed reads clean again.
plant_page pages/lifted.md 4
run pages/lifted.md
check "lifting the plant returns a clean reading" "$(field collisions out.txt)"      "0"

echo "--- a permutation is reachable, so 'no' means something ---"

# Every row recommended, each onto a distinct seat: the reading the real page could not reach.
plant_page pages/perm.md 4
erratum pages/perm.md 1 20260101.000001 "Recommended re-rank: a rank of fourth."
erratum pages/perm.md 2 20260101.000002 "Recommended re-rank: a rank of third."
erratum pages/perm.md 3 20260101.000003 "Recommended re-rank: a rank of second."
erratum pages/perm.md 4 20260101.000004 "Recommended re-rank: a rank of first."
run pages/perm.md
check "four distinct seats collide nowhere"       "$(field collisions out.txt)"      "0"
check "every position spoken for by a reading"    "$(field positions_recommended out.txt)" "4"
check "none inherited from the standing table"    "$(field positions_inherited out.txt)"   "0"
check "a full reversal IS a permutation"          "$(field permutation out.txt)"     "yes"
check "and its verdict is an order"               "$(field verdict out.txt)"         "order"

echo "--- an absent page refuses rather than reading zero ---"

run pages/absent.md
check "an absent page says so"                    "$(field page_readable out.txt)"   "no"
check "and refuses rather than reading zero rows" "$(field verdict out.txt)"         "unreadable"

# A page carrying a word that merely contains "last" must not be demoted.
plant_page pages/lastword.md 4
erratum pages/lastword.md 1 20260101.000001 "Recommended **re-aim**: the ballast stays where it is."
run pages/lastword.md
check "a word containing 'last' demotes nothing"  "$(field class_demoted out.txt)"   "0"
check "and the row reads as the re-aim it is"     "$(field class_reaimed out.txt)"   "1"

echo "--- the mutations: each asserted to bite ---"

mutate() {
  _why="$1"; _edit="$2"; _key="$3"; _want="$4"; _page="$5"
  cp "$SCAN" mutant.sh
  sed "$_edit" mutant.sh > mutant.new && mv mutant.new mutant.sh
  if cmp -s "$SCAN" mutant.sh; then
    no "$_why -- the mutation no longer applies, so it proves nothing"
    return
  fi
  LADDER_PAGE="$_page" sh mutant.sh > mut.txt 2>&1 || true
  _read=$(field "$_key" mut.txt)
  if [ "$_read" = "$_want" ]; then
    no "$_why -- the mutant reads [$_read] exactly as the scan does"
  else
    ok "$_why (mutant read [$_read], scan reads [$_want])"
  fi
}

# Reading the position before the disposition word is what lets "re-aim ... and a rank of fourth"
# be heard as a seat. Move the breach test ahead of it and the seat is lost.
mutate "reading the disposition before the position loses a named seat" \
  's|else if (target != 0) kind = "rank"|else if (low ~ /re-aim/) kind = "aim"; else if (target != 0) kind = "rank"|' \
  class_seated 1 "$PEN/pages/both.md"

# The bare-word guard on "last": without it, any sentence carrying the letters demotes the row.
mutate "an unbounded 'last' match demotes on a passing word" \
  's|low ~ /(\^\| )last\[ ,.\]/|low ~ /last/|' \
  class_demoted 0 "$PEN/pages/lastword.md"

# The roster count: hard-code it and a thirteen-row page reads twelve.
mutate "a hard-coded roster cannot see a thirteenth row" \
  's|^rows=$(grep -cE .*$|rows=12|' \
  rows 13 "$PEN/pages/thirteen.md"

# The latest-per-row tiebreak: drop it and both errata of one row speak.
mutate "losing the latest-stamp tiebreak lets a retired erratum speak" \
  's|sort -k2,2n -k3,3 "$WORK"/ladder_errata.txt|sort -k2,2nr -k3,3r "$WORK"/ladder_errata.txt|' \
  class_superseded 1 "$PEN/pages/two.md"

echo "--- the scan releases the pen it makes (REDS %745, read on this instrument) ---"

_before=$(find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'ladder_order.*' -type d 2>/dev/null | wc -l | tr -d ' ')
run pages/plain.md
_after=$(find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'ladder_order.*' -type d 2>/dev/null | wc -l | tr -d ' ')
check "a finished run leaves no pen behind"       "$_after"                          "$_before"
run pages/absent.md
_refused=$(find "${TMPDIR:-/tmp}" -maxdepth 1 -name 'ladder_order.*' -type d 2>/dev/null | wc -l | tr -d ' ')
check "and a REFUSING run leaves none either"     "$_refused"                        "$_before"

check "every mutation applied and bit" "$fail" "0"

echo "control_legs=$legs"
echo "control_expected=$LEGS_EXPECTED"
echo "control_passed=$pass"
echo "control_failed=$fail"
if [ "$legs" -ne "$LEGS_EXPECTED" ]; then
  echo "detail: leg count moved -- a leg added or lost is a leg nobody heard"
  echo "control_verdict=leg_count_moved"
  exit 0
fi
if [ "$fail" -ne 0 ]; then
  echo "control_verdict=failed"
  exit 0
fi
echo "control_verdict=ok"
