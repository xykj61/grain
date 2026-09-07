#!/bin/sh
# tools/fixtures/r/reds_shelf_name_control.sh -- the pen where a shelf is shown to read both ways.
#
# Each plant names a shelf one number and its title another. The scan bites. The plant lifts, the
# same shelf reads clean, and the pair together is what proves a gate rather than a habit.
#
# THE PEN CARRIES THE CASES THE FIELD LACKS. All three gates read zero across the tree's 291
# shelves, so the field alone shows a green and nothing else. Here the cases stand in real git
# repositories, planted and lifted, so a refusal proven in one direction is proven in both.
#
# THE WELCOMES ARE ASSERTED AS HARD AS THE REFUSALS, and they are why the reading is shaped this
# way. Three honest shapes stand in this tree's archive today. A title may name a row as its
# SUBJECT mid-sentence -- *the %364 collision*. A `**Rows:**` header may recite a renumber history
# after its declaration -- `%545` and `%551` both do. A filename span may run WIDER than the rows
# held, since a range is not a set and the endpoints folded elsewhere -- `rows-80-87` holds 82
# upward. A looser reading calls all three wrong, so each is planted here and each must pass.
#
# See reds_shelf_name_scan.sh for what the three gates read, and
# tools/r/reds_shelf_name_witness.rish for the guard that runs both.
#
# Run from the repository root. It takes no lock and touches nothing outside its own pen:
#   sh tools/fixtures/r/reds_shelf_name_control.sh
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

scan="$ROOT/tools/fixtures/r/reds_shelf_name_scan.sh"
[ -f "$scan" ] || { echo "control: no scan at $scan" >&2; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

cases=0
fails=0
repos=0

new_repo() {
  repos=$((repos + 1))
  R="$pen/r$repos"
  mkdir -p "$R/construction/archive"
  ( cd "$R" && git init -q . && git config user.email pen@example.invalid && git config user.name pen ) >/dev/null 2>&1
}
commit_all() { ( cd "$R" && git add -A && git commit -qm pen --no-gpg-sign ) >/dev/null 2>&1; }
read_key() { ROOT_DIR="$R" sh "$scan" 2>/dev/null | sed -n "s/^$1=//p"; }
read_verdict() { ROOT_DIR="$R" sh "$scan" 2>/dev/null | sed -n 's/^verdict=//p'; }

want() {
  cases=$((cases + 1))
  name=$1; got=$2; expect=$3
  if [ "$got" = "$expect" ]; then
    echo "  ok   $name ($got)"
  else
    echo "  FAIL $name -- read '$got', wanted '$expect'"
    fails=$((fails + 1))
  fi
}

# One shelf, written whole, so a case changes exactly the line it is about.
# $1 shelf number-part for the filename, $2 H1 line, $3 Rows line (empty for none), $4 headline row
shelf() {
  p="$R/construction/archive/REDS-a-pen-shelf-rows-$1.md"
  printf '%s\n\n' "$2" > "$p"
  [ -z "$3" ] || printf '%s\n\n' "$3" >> "$p"
  [ -z "$4" ] || printf '**REDS %%%s (`20260907.000000`) -- a pen row.** *What went wrong:* nothing. **CLOSED.**\n' "$4" >> "$p"
}

echo "reds-shelf-name control: four spellings of one number, from both sides."

# 1 -- a clean shelf: filename, title and headline all agree.
new_repo
shelf 100 '# REDS shelf -- a pen row, row %100' '**Rows:** `%100` -- folded from the pin' 100
commit_all
want clean_shelf_welcomed "$(read_verdict)" ok
want clean_shelf_counted "$(read_key shelves_read)" 1
want clean_title_counted "$(read_key title_declaring)" 1
want clean_rows_counted "$(read_key rows_declaring)" 1

# 2 -- the title declares a different row: the renumber that reached three spellings of four.
shelf 100 '# REDS shelf -- a pen row, row %96' '**Rows:** `%100` -- folded from the pin' 100
commit_all
want title_disagree_bitten "$(read_verdict)" title_disagrees
want title_disagree_counted "$(read_key title_disagrees)" 1
want title_disagree_named \
  "$(ROOT_DIR="$R" sh "$scan" list 2>/dev/null | sed -n 's/^title .*declares \(.*\)$/\1/p')" 96-96

# 3 -- the plant lifted. Same file, the title corrected, reads ok.
shelf 100 '# REDS shelf -- a pen row, row %100' '**Rows:** `%100` -- folded from the pin' 100
commit_all
want title_disagree_lifted "$(read_verdict)" ok

# 4 -- a title naming a number as its SUBJECT rather than as a trailing declaration.
#      `REDS-one-number-two-rows-364-371.md` reads exactly this way and is honest.
new_repo
shelf 100 '# REDS shelf -- one number, two rows: the %96 collision and its census' '' 100
commit_all
want title_subject_welcomed "$(read_verdict)" ok
want title_subject_not_declaring "$(read_key title_declaring)" 0

# 5 -- the `**Rows:**` header declares a different row.
new_repo
shelf 100 '# REDS shelf -- a pen row' '**Rows:** `%96` -- folded from the pin' 100
commit_all
want rows_disagree_bitten "$(read_verdict)" rows_header_disagrees
want rows_disagree_counted "$(read_key rows_header_disagrees)" 1

# 6 -- lifted.
shelf 100 '# REDS shelf -- a pen row' '**Rows:** `%100` -- folded from the pin' 100
commit_all
want rows_disagree_lifted "$(read_verdict)" ok

# 7 -- a `**Rows:**` header whose narration recites the renumber history after its declaration.
#      `rows-545` and `rows-551` both read this way on this tree, and both are honest.
new_repo
shelf 100 '# REDS shelf -- a pen row' '**Rows:** `%100` -- booked, the number moved `%94` -> `%96` -> `%100`' 100
commit_all
want rows_narration_welcomed "$(read_verdict)" ok
want rows_narration_counted "$(read_key rows_declaring)" 1

# 8 -- a headline row outside the span the filename declares: a citation to that row's number
#      would open this shelf and find nothing, or open nothing at all.
new_repo
shelf 100 '# REDS shelf -- a pen row' '' 101
commit_all
want outside_span_bitten "$(read_verdict)" held_outside_span
want outside_span_counted "$(read_key held_outside_span)" 1

# 9 -- lifted.
shelf 100 '# REDS shelf -- a pen row' '' 100
commit_all
want outside_span_lifted "$(read_verdict)" ok

# 10 -- a filename span WIDER than the rows held. `REDS-microkernel-arc-rows-80-87.md` names 80
#       and holds 82 upward, because the endpoints folded elsewhere; a range is not a set.
new_repo
shelf 100-110 '# REDS shelf -- a pen span, rows %100-%110' '' 105
commit_all
want wide_span_welcomed "$(read_verdict)" ok
want wide_span_title_counted "$(read_key title_declaring)" 1

# 11 -- a bare mention of another row in prose, carrying no stamp, is not a row held here.
new_repo
shelf 100 '# REDS shelf -- a pen row' '' 100
printf '\n**REDS %%499**, which found the same breach standing in the machinery.\n' \
  >> "$R/construction/archive/REDS-a-pen-shelf-rows-100.md"
commit_all
want prose_mention_welcomed "$(read_verdict)" ok

# 12 -- a shelf holding no stamped headline at all: the elder index and recital files. Silence
#       makes no claim, so it is counted and gated by nothing.
new_repo
shelf 100 '# REDS fold index' '' ''
commit_all
want unread_shelf_welcomed "$(read_verdict)" ok
want unread_shelf_counted "$(read_key unread_shelves)" 1

# 13 -- an untracked shelf is not read. A file a clone does not carry makes this tree no promise.
new_repo
shelf 100 '# REDS shelf -- a pen row, row %100' '' 100
commit_all
shelf 200 '# REDS shelf -- an untracked row, row %96' '' 200
want untracked_not_read "$(read_key shelves_read)" 1
want untracked_not_bitten "$(read_verdict)" ok

# 14 -- misuse exits differently from a refusal, so a broken invocation is never read as a clean
#       archive.
new_repo
commit_all
ROOT_DIR="$R" sh "$scan" nonsense >/dev/null 2>&1
want misuse_exits_two "$?" 2

echo "cases=$cases fails=$fails repos=$repos"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=a_case_read_wrong"
exit 1
