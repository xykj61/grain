#!/bin/sh
# tools/fixtures/reds_row_present_control.sh -- prove the spine reading on a pen, both directions.
#
# WHY A CONTROL. A refusal proven only in the passing direction cannot be told from a bypass. This
# builds a throwaway ledger in a temporary pen -- a shelf holding elder table rows and a pin holding
# living prose rows -- and asks the two spine readings twelve questions whose answers are known
# before it runs. Seven are behaviours a caller depends on; five are misuses that must exit 2 rather
# than 1, since a caller reading "absent" from a typo would repair a ledger that was never wrong.
#
# BOTH READINGS, because both were the same fault. tools/fixtures/reds_row_present.sh answers for a
# ROW NUMBER and tools/fixtures/reds_spine_grep.sh answers for a LESSON'S TEXT, and the season scans
# asked the living pin for each of them on adjacent lines.
#
#   sh tools/fixtures/reds_row_present_control.sh
#
# Exit 0 when all thirteen hold, 1 naming the first that did not. Touches nothing in the tree.
set -eu

SCAN=tools/fixtures/reds_row_present.sh
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

# The shelf wears the elder table shape; the pin wears the living prose shape. Both are real
# spellings this ledger has used, and the reading has to span them.
cat > "$pen/REDS-pen-season-rows-1-3.md" <<'EOF'
# a pen shelf
| # | What went wrong | What caught it | What it taught |
|---|---|---|---|
| 1 | the first | a compiler | measure before claiming |
| 2 | the second | a stopwatch | scope before shipping |
| 3 | the third | a guard | fixture rather than remember |
EOF
cat > "$pen/REDS.md" <<'EOF'
# a pen pin
**REDS %4 (`20260101.000000`) -- the fourth.** *What went wrong:* a thing. CLOSED.
**REDS #5 (`20260101.000001`) -- the fifth, wearing the elder sigil.** *What caught it:* a hand. CLOSED.
EOF

GLOB="$pen/REDS-pen-*rows-*.md $pen/REDS.md"
fails=0
check() { # name expected_exit args...
  name=$1; want=$2; shift 2
  set +e
  REDS_SPINE_GLOB="$GLOB" sh "$SCAN" "$@" >/dev/null 2>&1
  got=$?
  set -e
  if [ "$got" -ne "$want" ]; then
    echo "CONTROL_FAIL case=${name} want_exit=${want} got_exit=${got}"
    fails=$((fails + 1))
  else
    echo "ok ${name} exit=${got}"
  fi
}

check shelf_first_row     0 1     # the elder table shape, found on the shelf
check shelf_last_row      0 3     # and the last row of the shelf
check pin_percent_row     0 4     # the living prose shape, percent sigil
check pin_hash_row        0 5     # the elder prose sigil the ledger also wrote
check absent_past_end     1 6     # one past the end refuses -- the refusal side
check misuse_no_argument  2       # no row number at all
check misuse_not_a_number 2 forty # a word where a number belongs
check misuse_below_one    2 0     # row zero, which no ledger has

# The text reading, over the same pen. `grep_check` differs from `check` only in which script it
# asks, so the two readings are proven against one ledger rather than two.
grep_check() {
  name=$1; want=$2; shift 2
  set +e
  REDS_SPINE_GLOB="$GLOB" sh tools/fixtures/reds_spine_grep.sh "$@" >/dev/null 2>&1
  got=$?
  set -e
  if [ "$got" -ne "$want" ]; then
    echo "CONTROL_FAIL case=${name} want_exit=${want} got_exit=${got}"
    fails=$((fails + 1))
  else
    echo "ok ${name} exit=${got}"
  fi
}

grep_check text_on_shelf   0 'measure before claiming'   # a lesson that folded onto the shelf
grep_check text_on_pin     0 'the fourth'                # and one still on the living pin
grep_check text_insensitive 0 -i 'THE FIFTH'             # case folded on request
grep_check text_absent     1 'a lesson no ledger wrote'  # the refusal side
grep_check text_misuse     2                             # no pattern at all

if [ "$fails" -ne 0 ]; then
  echo "CONTROL_FAIL cases_failed=${fails}"
  exit 1
fi
echo "CONTROL_OK cases=13 refusals=6 welcomes=7"
