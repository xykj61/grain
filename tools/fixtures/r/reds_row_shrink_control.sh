#!/bin/sh
# tools/fixtures/r/reds_row_shrink_control.sh -- prove the ledger-row shrink reading on real git
# repositories in a throwaway pen, the losses it must see and the lawful edits it must not.
#
# WHY BOTH DIRECTIONS. A reading proven only where it reports something cannot be told from one
# that reports everything, and a reading proven only where it stays quiet cannot be told from one
# that is asleep. So every behaviour here is shown from BOTH sides -- planted and then lifted --
# and the quiet cases are asserted as hard as the loud ones.
#
# WHAT IS PROVEN BEYOND THE COUNTS. Four MUTATIONS: each removes one load-bearing line of the scan
# and asserts the pen's answer CHANGES. A check that survives its own removal is a check the
# reading never depended on, and three of the four here guard distinctions this instrument paid
# for by reporting losses that were never losses.
#
#   sh tools/fixtures/r/reds_row_shrink_control.sh
#
# Exit 0 when every case behaves, 1 when one does not. No network, no key, no funds, no device.
set -eu

SCAN="$(cd "$(dirname "$0")" && pwd)/reds_row_shrink_scan.sh"
pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

check_field() { # name field expected actual_output
  _n="$1"; _f="$2"; _want="$3"; _got="$4"
  _have=$(printf '%s\n' "$_got" | sed -n "s/^$_f=//p")
  if [ "$_have" = "$_want" ]; then
    echo "PASS: $_n ($_f=$_want)"
    pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted $_f=$_want, got $_f=$_have"
    fail=$((fail + 1))
  fi
}

check_says() { # name needle actual_output
  _n="$1"; _needle="$2"; _got="$3"
  if printf '%s\n' "$_got" | grep -q -- "$_needle"; then
    echo "PASS: $_n"
    pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted a line matching [$_needle], got:"
    printf '%s\n' "$_got" | sed 's/^/       /'
    fail=$((fail + 1))
  fi
}

check_rc() { # name expected_rc actual_rc
  if [ "$3" -eq "$2" ]; then
    echo "PASS: $1 (exit $2)"
    pass=$((pass + 1))
  else
    echo "FAIL: $1 -- wanted exit $2, got exit $3"
    fail=$((fail + 1))
  fi
}

# A LONG row and a SHORT one, so a word delta is unmistakable. The shape matches the ledger's own:
#   **REDS %N (`YYYYMMDD.HHMMSS`) -- headline.** *What went wrong:* ... **STATUS.**
long_row() { # number stamp
  printf '**REDS %%%s (`%s`) -- the long form of this row.** *What went wrong:* ' "$1" "$2"
  i=0; while [ "$i" -lt 60 ]; do printf 'one more sentence of the account that this row carried. '; i=$((i + 1)); done
  printf '**OPEN.**\n\n'
}
short_row() { # number stamp
  printf '**REDS %%%s (`%s`) -- the long form of this row.** *What went wrong:* one more sentence of the account that this row carried. **OPEN.**\n\n' "$1" "$2"
}
closure_note() { # number stamp -- the shape that broke two earlier keys: same number, same stamp
  printf '**REDS %%%s CLOSED (`%s`) -- the closure note, which is short on purpose.**\n\n' "$1" "$2"
}

commit() { git add -A; git commit -q -m "$1"; }

newpen() {
  rm -rf "$pen/r"; mkdir -p "$pen/r"
  cd "$pen/r" || { echo "refused: pen absent -- $0 did not enter its pen; fixtures would land in the live tree" >&2; exit 1; }
  git init -q -b main .
  git config user.email pen@example.invalid
  git config user.name Pen
  git config commit.gpgsign false
  { long_row 1 20260101.000001; long_row 2 20260101.000002; } > REDS.md
  commit "pen: two long rows"
}

export REDS_SPINE_GLOB=REDS.md

echo "== 1. a spine nobody has shortened reports nothing, loudly =="
newpen
out=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "an intact spine is reported" verdict reported "$out"
check_field "no event on an intact spine" shrink_events 0 "$out"
check_field "no row stands short" standing_short 0 "$out"
check_field "and it says what it read, so a silent zero is told from a clean spine" records_seen 2 "$out"

echo
echo "== 2. THE FAULT -- a commit about something else rewrites a row to its narrower form =="
{ long_row 1 20260101.000001; short_row 2 20260101.000002; } > REDS.md
commit "pen: book an unrelated number"
out=$(sh "$SCAN" --remote main --list 2>&1 || true)
check_field "the shortening is caught" shrink_events 1 "$out"
check_field "and the row stands short today" standing_short 1 "$out"
check_says "the event names the row and the commit" '^event commit=[0-9a-f]\{10\} row=%2 ' "$out"
check_says "the standing row names what it lost" '^short row=%2 .*words_lost=' "$out"

echo
echo "== 3. the same tree with the row restored -- the standing reading clears, the event stays =="
{ long_row 1 20260101.000001; long_row 2 20260101.000002; } > REDS.md
commit "pen: restore the row by hand"
out=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "no row stands short once restored" standing_short 0 "$out"
check_field "yet the history keeps the event, because it happened" shrink_events 1 "$out"

echo
echo "== 4. A LAWFUL WIDENING is never an event =="
newpen
{ long_row 1 20260101.000001; long_row 2 20260101.000002; long_row 3 20260101.000003; } > REDS.md
commit "pen: book a third row"
out=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "growth reports no event" shrink_events 0 "$out"
check_field "and no row stands short" standing_short 0 "$out"

echo
echo "== 5. AN ASCII SWEEP changes bytes and no word, so it is not a loss =="
newpen
printf '**REDS %%9 (`20260101.000009`) -- an em dash \342\200\224 stands here.** *What went wrong:* a sweep. **OPEN.**\n\n' >> REDS.md
commit "pen: a row carrying an em dash"
sed 's/\xe2\x80\x94/--/' REDS.md > REDS.tmp && cat REDS.tmp > REDS.md && rm -f REDS.tmp
commit "pen: sweep the em dash to two hyphens (ascii-first)"
out=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "a character sweep is not a shrink" shrink_events 0 "$out"
check_field "and leaves no row standing short" standing_short 0 "$out"

echo
echo "== 6. A FOLD moves a row to a shelf and loses nothing =="
newpen
export REDS_SPINE_GLOB="REDS-*.md REDS.md"
long_row 3 20260101.000003 >> REDS.md
commit "pen: a third row on the pin"
{ echo "# shelf"; echo; long_row 3 20260101.000003; } > REDS-shelf-rows-3.md
{ long_row 1 20260101.000001; long_row 2 20260101.000002; } > REDS.md
commit "pen: fold row three onto its shelf"
out=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "a fold is not a shrink" shrink_events 0 "$out"
check_field "and the folded row does not stand short" standing_short 0 "$out"
export REDS_SPINE_GLOB=REDS.md

echo
echo "== 7. A REBINDING is recognised and set aside, never counted as a loss =="
newpen
{ long_row 1 20260101.000001; short_row 2 20260101.999999; } > REDS.md
commit "pen: renumber an unshared row onto its derived seat"
out=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "a stamp moving under a number is not a shrink" shrink_events 0 "$out"
check_field "it is named as the other guard's subject" rebindings_seen 1 "$out"

echo
echo "== 8. A CLOSURE NOTE wears its row's number AND its stamp, and is its own record =="
newpen
closure_note 2 20260101.000002 >> REDS.md
commit "pen: close row two with a note carrying its own stamp"
out=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "the short note is not the long row shrinking" shrink_events 0 "$out"
check_field "nor does the row stand short beneath it" standing_short 0 "$out"
check_field "both records are counted, because both exist" records_seen 3 "$out"

echo
echo "== 9. REFUSALS exit 2, apart from a clean read, so a broken call is never an intact ledger =="
newpen
set +e
out=$(sh "$SCAN" --remote main --nonesuch 2>&1); rc=$?
set -e
check_rc "an unknown option exits 2" 2 "$rc"
check_says "and names itself" 'verdict=misuse_unknown_arg' "$out"
set +e
out=$(sh "$SCAN" --remote 2>&1); rc=$?
set -e
check_rc "an option missing its value exits 2" 2 "$rc"
set +e
out=$(sh "$SCAN" --remote no-such-ref-here 2>&1); rc=$?
set -e
check_rc "a ref that does not resolve exits 2" 2 "$rc"
check_says "rather than reporting a spine of no rows" 'verdict=unreadable_spine' "$out"
set +e
out=$(REDS_SPINE_GLOB='NOTHING-*.md' sh "$SCAN" --remote main 2>&1); rc=$?
set -e
check_rc "a glob naming nothing exits 2" 2 "$rc"
check_says "and says its own blindness" 'verdict=unreadable_spine' "$out"

echo
echo "== 10. MUTATIONS -- each removes one line and the pen's answer must change =="
# THE PEN IS BUILT FOR THE MUTATIONS RATHER THAN REUSED. A collision between a row and its closure
# note only shows when the two arrive in DIFFERENT commits: added together, a weaker key simply
# overwrites one with the other and both the current and the peak reading come from the same line,
# so the fault hides. That is exactly how it stood on the real ledger -- row first, closure note
# some days later -- and a pen that adds both at once would pass every mutation while proving none.
newpen
closure_note 2 20260101.000002 >> REDS.md
commit "pen: the closure note arrives in its own later commit"
{ long_row 1 20260101.000001; long_row 2 20260101.000002; } > REDS.md
short_row 1 20260101.000001 > REDS.md
long_row 2 20260101.000002 >> REDS.md
closure_note 2 20260101.000002 >> REDS.md
commit "pen: an unrelated commit shortens row one"
base=$(sh "$SCAN" --remote main 2>&1 || true)
check_field "the honest reading sees the one real loss" shrink_events 1 "$base"
check_field "and one row standing short -- the note is its own record" standing_short 1 "$base"

mkdir -p "$pen/bin"

mutate() { # name sed_expression field honest_value how
  _name="$1"; _sed="$2"; _field="$3"; _honest="$4"; _how="$5"
  sed "$_sed" "$SCAN" > "$pen/bin/mut.sh"
  if cmp -s "$SCAN" "$pen/bin/mut.sh"; then
    echo "FAIL: $_name planted nothing -- the line it aims at has moved, so this mutation proves nothing"
    fail=$((fail + 1))
    return
  fi
  _got=$(eval "$_how" 2>&1 || true)
  # Loose on purpose: a refusal names its fields INLINE beside the verdict, and a mutation whose
  # whole effect is to change WHICH refusal fires is one a line-start reading could never see.
  _have=$(printf '%s\n' "$_got" | sed -n "s/.*$_field=\\([^ ]*\\).*/\\1/p" | head -1)
  if [ "$_have" = "$_honest" ]; then
    echo "FAIL: $_name changed nothing -- $_field still reads $_honest, so the line is not load-bearing"
    fail=$((fail + 1))
  else
    echo "PASS: $_name changes the reading ($_field $_honest -> ${_have:-refused})"
    pass=$((pass + 1))
  fi
}

# M1: the key falls back to the NUMBER alone -- the first draft, which read a closure note as its
# own row shrinking. Nine rows of the real ledger reported that way.
mutate "M1 the record head as key" \
  's|  mk = substr(line, 1, RSTART + RLENGTH - 1)|  mk = k|' \
  standing_short 1 'sh "$pen/bin/mut.sh" --remote main'

# M2: the key falls back to (NUMBER, STAMP) -- the second draft. A closure note reuses the stamp of
# the row it closes, so this collides too.
mutate "M2 the marker word inside the key" \
  's|  mk = substr(line, 1, RSTART + RLENGTH - 1)|  mk = k SUBSEP st|' \
  standing_short 1 'sh "$pen/bin/mut.sh" --remote main'

# M3: measure BYTES rather than words. Read in the C locale so `length` counts bytes, which is what
# a byte measure means; the em-dash pen must then report a sweep as a loss. Eighteen byte events
# stand against seven word events on the real ledger, and eleven of the difference are sweeps.
newpen
printf '**REDS %%9 (`20260101.000009`) -- an em dash \342\200\224 stands here.** *What went wrong:* a sweep. **OPEN.**\n\n' >> REDS.md
commit "pen: a row carrying an em dash"
sed 's/\xe2\x80\x94/--/' REDS.md > REDS.tmp && cat REDS.tmp > REDS.md && rm -f REDS.tmp
commit "pen: sweep it to two hyphens"
mutate "M3 the word measure" \
  's|function words(s,   a) { return split(s, a, /\[ \\t\]+/) }|function words(s,   a) { return length(s) }|' \
  shrink_events 0 'LC_ALL=C sh "$pen/bin/mut.sh" --remote main'

# M4: drop the ref check. An unresolvable ref then reads as a spine of no rows rather than refusing
# -- a reading reporting its own blindness as a clean ledger, which is %97's shape.
# Both forms refuse, which is the point: what the check buys is a diagnosis naming the INPUT
# (`ref_absent`) where the tool otherwise names itself (`log_refused`), and a reader acts on the
# first. So the mutation is measured on the detail rather than on the verdict.
mutate "M4 the ref check" \
  's|^if ! git rev-parse --verify --quiet|if false \&\& ! git rev-parse --verify --quiet|' \
  detail ref_absent 'sh "$pen/bin/mut.sh" --remote no-such-ref-here'

echo
echo "cases_ok=$pass cases_red=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=red"; exit 1; fi
echo "control_verdict=ok"
