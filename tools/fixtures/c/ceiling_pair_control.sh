#!/bin/sh
# tools/fixtures/c/ceiling_pair_control.sh -- prove the ceiling-pair meter from both sides.
#
#   sh tools/fixtures/c/ceiling_pair_control.sh
#
# WHY. A guard that cannot red guards nothing, and a refusal proven only in the passing direction
# cannot be told apart from a bypass. So this builds real Rye sources in a throwaway pen and checks
# the verdict STRING rather than only the exit code -- a scan exiting 1 for the wrong reason has
# not proven the reading anyone cared about. Every refusal below is planted and then lifted, so a
# check that had merely stopped reading would fail its own free leg.
#
# WHAT IS PROVEN, both directions:
#
#   1 free    -- a file declaring both ceilings and answering `independent` passes
#   2 free    -- `derived` passes, since that is the repair this guard rewards
#   3 bitten  -- a verdict none of the three reads as unreadable, and the refusal names the file
#   4 free    -- a file declaring only a byte ceiling is not in the population at all
#   5 free    -- a file declaring only a count ceiling is not in the population at all
#   6 bitten  -- an empty corpus reads as empty rather than clean
#   7 free    -- a DERIVED right-hand side is not a literal, so the repaired form leaves the
#                population rather than being counted forever
#   8 bitten  -- an undeclared file past the ratchet refuses
#   9 free    -- the same file passes once the ceiling admits it, so the ratchet is a ceiling
#                rather than a wall
#  10 bitten  -- a `literal` verdict past its own ceiling refuses
#  11 free    -- `literal` at exactly its ceiling passes, or it is not a ceiling
#  12 free    -- the refusal for a literal pair names the file
#  13 free    -- one honest file never masks an unreadable one in the same pen
#  14 free    -- a `ceilings:` word mid-code is not read as a declaration, since the pattern is
#                anchored to a comment at line start
#
# Run from the repository root.
set -eu

PASS=0
FAIL=0
PEN=$(mktemp -d "${TMPDIR:-/tmp}/ceiling-pair-pen.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

check() {
  if [ "$2" = "$3" ]; then PASS=$((PASS + 1)); echo "$1 -- ok"
  else FAIL=$((FAIL + 1)); echo "$1 -- FAIL (wanted $2, got $3)"; fi
}

D="$PEN/src"
mkdir -p "$D"

run_scan() {
  CEILING_PAIR_ROOT="$D" \
  CEILING_PAIR_UNDECLARED_CEILING="${1:-0}" \
  CEILING_PAIR_LITERAL_CEILING="${2:-0}" \
    sh tools/fixtures/c/ceiling_pair_scan.sh census 2>&1 || true
}
verdict() { printf '%s\n' "$1" | sed -n 's/^verdict=//p' | head -1; }
field() { printf '%s\n' "$2" | sed -n "s/^$1=//p" | head -1; }

# A source declaring a byte ceiling of $2 and a count ceiling of $3, carrying the verdict $4.
pair() {
  {
    echo "const std = @import(\"std\");"
    [ -n "${4:-}" ] && echo "// ceilings: $4 -- planted by the pen"
    echo "pub const max_wire_payload: u32 = $2;"
    echo "pub const max_wire_hits: u32 = $3;"
  } > "$1"
}

clear_pen() { rm -f "$D"/*.rye; }

# 1 -- independent passes free.
clear_pen
pair "$D/a.rye" 340 8 independent
out=$(run_scan 0 0)
check "1 free: a file answering independent passes" "ok" "$(verdict "$out")"
check "1 free: it is counted as independent" "1" "$(field pairs_independent "$out")"

# 2 -- derived passes free.
clear_pen
pair "$D/a.rye" 340 8 derived
out=$(run_scan 0 0)
check "2 free: a file answering derived passes" "ok" "$(verdict "$out")"
check "2 free: it is counted as derived" "1" "$(field pairs_derived "$out")"

# 3 -- a verdict none of the three is unreadable, gated at zero.
clear_pen
pair "$D/a.rye" 340 8 probably-fine
out=$(run_scan 9 9)
check "3 bitten: a verdict no tool can read refuses" "unreadable_verdict" "$(verdict "$out")"
check "3 bitten: the refusal names the file" "yes" \
  "$(printf '%s' "$out" | grep -q "a.rye declares a verdict no tool can read" && echo yes || echo no)"

# 4 and 5 -- one ceiling alone is not a pair. Proven by an empty corpus, which is the reading a
# file outside the population produces.
clear_pen
{ echo "pub const max_wire_payload: u32 = 340;"; } > "$D/a.rye"
out=$(run_scan 9 9)
check "4 free: a byte ceiling alone is not a pair" "empty_corpus" "$(verdict "$out")"

clear_pen
{ echo "pub const max_wire_hits: u32 = 8;"; } > "$D/a.rye"
out=$(run_scan 9 9)
check "5 free: a count ceiling alone is not a pair" "empty_corpus" "$(verdict "$out")"

# 6 -- an empty corpus says so rather than passing.
clear_pen
out=$(run_scan 9 9)
check "6 bitten: an empty corpus reads as empty rather than clean" "empty_corpus" "$(verdict "$out")"

# 7 -- a derived right-hand side is not a literal. This is the repair leaving the population, and
# it is the leg that catches a pattern ending at [0-9]+ rather than at the semicolon: the value
# below opens with the digit 8.
clear_pen
{
  echo "pub const max_wire_payload: u32 = 8 * session.max_samples;"
  echo "pub const max_wire_hits: u32 = 8;"
} > "$D/a.rye"
out=$(run_scan 9 9)
check "7 free: a derived right-hand side leaves the population" "empty_corpus" "$(verdict "$out")"

# 8 and 9 -- the undeclared ratchet, shown from both sides.
clear_pen
pair "$D/a.rye" 340 8 ""
out=$(run_scan 0 0)
check "8 bitten: an undeclared pair past the ratchet refuses" "undeclared_spread" "$(verdict "$out")"
out=$(run_scan 1 0)
check "9 free: the same pair passes once the ceiling admits it" "ok" "$(verdict "$out")"
check "9 free: it is counted as undeclared" "1" "$(field pairs_undeclared "$out")"

# 10, 11, 12 -- the literal ratchet, shown from both sides and named in its refusal.
clear_pen
pair "$D/a.rye" 340 8 literal
out=$(run_scan 0 0)
check "10 bitten: a literal pair past its ceiling refuses" "literal_pair_spread" "$(verdict "$out")"
check "12 free: the refusal names the file" "yes" \
  "$(printf '%s' "$out" | grep -q "literal: $D/a.rye carries a count ceiling" && echo yes || echo no)"
out=$(run_scan 0 1)
check "11 free: a literal pair at exactly its ceiling passes free" "ok" "$(verdict "$out")"

# 13 -- one honest file must never mask an unreadable one.
clear_pen
pair "$D/a.rye" 340 8 independent
pair "$D/b.rye" 340 8 whatever
out=$(run_scan 9 9)
check "13 free: an honest file never masks an unreadable one" "unreadable_verdict" "$(verdict "$out")"
check "13 free: the honest file is still counted" "1" "$(field pairs_independent "$out")"

# 14 -- the declaration is a comment at line start, never a word in code.
clear_pen
{
  echo "pub const max_wire_payload: u32 = 340;"
  echo "pub const max_wire_hits: u32 = 8;"
  echo "const note = \"ceilings: independent\";"
} > "$D/a.rye"
out=$(run_scan 1 0)
check "14 free: a ceilings word inside code is not a declaration" "1" "$(field pairs_undeclared "$out")"

echo "control_pass=$PASS"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=fail"; exit 1; fi
