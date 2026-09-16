#!/bin/sh
# tools/fixtures/r/reds_shelf_resolve_control.sh -- the pen behind tools/r/reds_shelf_resolve.sh
# and its census. Every verdict is proven from BOTH sides: planted so it fires, then lifted so
# the same pen reads clean again. A refusal proven only in the passing direction cannot be told
# from a bypass.
#
#   sh tools/fixtures/r/reds_shelf_resolve_control.sh
#
# Exit 0 all legs pass - 1 a leg failed - 2 misuse or an unbuildable pen.
set -eu

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
RESOLVER="$ROOT/tools/r/reds_shelf_resolve.sh"
SCAN="$ROOT/tools/fixtures/r/reds_shelf_resolve_scan.sh"
[ -x "$RESOLVER" ] || { echo "control: resolver unreadable" >&2; exit 2; }
[ -x "$SCAN" ] || { echo "control: scan unreadable" >&2; exit 2; }

pen=$(mktemp -d) || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0
leg() {
  name=$1; want=$2; got=$3
  legs=$((legs + 1))
  if [ "$want" = "$got" ]; then
    echo "leg=$name ok"
  else
    echo "leg=$name FAILED want=$want got=$got"
    failed=$((failed + 1))
  fi
}

# A pen of real shelves, written to be read exactly as the tree's own are: a row headline is
# `**REDS %N (stamp) -- title.**` at the head of a line.
mkdir -p "$pen/archive"
row() { printf '**REDS %%%s (`2026%s`) -- planted row.** *What went wrong:* planted.\n' "$1" "$2"; }

{ echo "# shelf one"; row 100 0101.010101; row 101 0101.010102; } > "$pen/archive/REDS-first-rows-100-101.md"
{ echo "# shelf two"; row 200 0102.010101; } > "$pen/archive/REDS-second-rows-200.md"
{ echo "# the pin"; row 900 0103.010101; } > "$pen/pin.md"

run() { REDS_SHELF_GLOB="$pen/archive/REDS-*.md" REDS_PIN="$pen/pin.md" sh "$RESOLVER" "$@" 2>/dev/null || true; }
verdict() { run "$1" | sed -n 's/^verdict=//p'; }
# `set -e` would terminate this function the moment the resolver refuses, which is exactly the
# case every exit-code leg below exists to read -- so the flag comes off for the one call.
code() {
  set +e
  REDS_SHELF_GLOB="$pen/archive/REDS-*.md" REDS_PIN="$pen/pin.md" sh "$RESOLVER" "$1" >/dev/null 2>&1
  c=$?
  set -e
  echo "$c"
}

# -- the six verdicts ------------------------------------------------------------------------
leg home_named_shelf_stands          home              "$(verdict REDS-first-rows-100-101.md)"
leg home_exits_zero                  0                 "$(code REDS-first-rows-100-101.md)"

# The founding case: a citation naming a basename that no longer exists, whose row still stands.
leg recovered_renamed_shelf          recovered-by-rows "$(verdict REDS-an-elder-title-rows-100.md)"
leg recovered_exits_zero             0                 "$(code REDS-an-elder-title-rows-100.md)"
leg recovered_names_the_holder       "$pen/archive/REDS-first-rows-100-101.md" \
    "$(run REDS-an-elder-title-rows-100.md | sed -n 's/^holder=//p')"

leg living_pin_row                   living-pin        "$(verdict %900)"
leg living_pin_exits_zero            0                 "$(code %900)"

# A range whose two ends now sit in different shelves.
leg split_across_two_shelves         split             "$(verdict REDS-wide-rows-100-200.md)"
leg split_exits_zero                 0                 "$(code REDS-wide-rows-100-200.md)"

leg missing_unknown_row              missing           "$(verdict %777)"
leg missing_exits_one                1                 "$(code %777)"

# -- ambiguity: a published double, planted then lifted ----------------------------------------
leg ambiguous_absent_before_plant    recovered-by-rows "$(verdict REDS-elder-rows-200.md)"
row 200 0104.010101 >> "$pen/archive/REDS-first-rows-100-101.md"
leg ambiguous_fires_when_planted     ambiguous         "$(verdict REDS-elder-rows-200.md)"
leg ambiguous_exits_one              1                 "$(code REDS-elder-rows-200.md)"
leg ambiguous_bare_row_too           ambiguous         "$(verdict %200)"
# lifted -- the same pen must read clean again, or the plant proved nothing
grep -v '%200 ' "$pen/archive/REDS-first-rows-100-101.md" > "$pen/t" && mv "$pen/t" "$pen/archive/REDS-first-rows-100-101.md"
leg ambiguous_clears_when_lifted     recovered-by-rows "$(verdict REDS-elder-rows-200.md)"

# -- the boundary: %20 may never be read out of %200 -------------------------------------------
# The same lesson stamp-and-name.md records for dated references, where a stamp inside a longer
# filename read as a reference. The digits are taken as a whole run or not at all.
leg boundary_short_row_is_missing    missing           "$(verdict %20)"
leg boundary_long_row_is_missing     missing           "$(verdict %2000)"

# -- misuse exits differently from a refusal ---------------------------------------------------
set +e; REDS_SHELF_GLOB="$pen/archive/REDS-*.md" sh "$RESOLVER" >/dev/null 2>&1; m=$?; set -e
leg misuse_no_argument_exits_two     2                 "$m"
set +e; REDS_SHELF_GLOB="$pen/archive/REDS-*.md" sh "$RESOLVER" "REDS-x-rows-zz.md" >/dev/null 2>&1; m=$?; set -e
leg misuse_bad_row_digits_exits_two  2                 "$m"
set +e; REDS_SHELF_GLOB="$pen/archive/REDS-*.md" sh "$RESOLVER" a b >/dev/null 2>&1; m=$?; set -e
leg misuse_two_arguments_exits_two   2                 "$m"

# -- the map is one builder, and reuse agrees with a fresh build -------------------------------
REDS_SHELF_GLOB="$pen/archive/REDS-*.md" REDS_PIN="$pen/pin.md" sh "$RESOLVER" --map > "$pen/map"
leg map_carries_shelf_count          "shelves_read 2"  "$(grep '^shelves_read' "$pen/map")"
reused=$(REDS_SHELF_MAP="$pen/map" REDS_SHELF_GLOB="$pen/archive/REDS-*.md" REDS_PIN="$pen/pin.md" \
  sh "$RESOLVER" %100 2>/dev/null | sed -n 's/^verdict=//p')
leg map_reuse_agrees_with_build      recovered-by-rows "$reused"
set +e; REDS_SHELF_MAP="$pen/nosuch" sh "$RESOLVER" %100 >/dev/null 2>&1; m=$?; set -e
leg map_unreadable_exits_two         2                 "$m"

# -- the census, and its ceiling proven from both sides -----------------------------------------
# A census run reads all 489 shelves and resolves every absent citation, so it is read ONCE at
# a ceiling nothing can breach and every reading taken from that one transcript. The two ceiling
# legs need their own runs, since the ceiling is what they vary.
cens() { REDS_SHELF_UNRECOVERABLE_CEILING="$1" sh "$SCAN" 2>/dev/null; }
cens 9999 > "$pen/census" || true
field() { sed -n "s/^$1=//p" "$pen/census"; }
leg census_reads_its_own_tree        ok                "$(field verdict)"
u=$(field unrecoverable)
a=$(field unrecoverable_ambiguous)
mm=$(field unrecoverable_missing)
leg census_causes_sum_to_total       "$u"              "$((a + mm))"
set +e
cens $((u - 1)) > "$pen/under" 2>/dev/null
m=$?
set -e
leg census_over_ceiling_refuses      over-ceiling      "$(sed -n 's/^verdict=//p' "$pen/under")"
leg census_over_ceiling_exits_one    1                 "$m"
leg census_at_ceiling_walks_free     ok                "$(cens "$u" | sed -n 's/^verdict=//p')"
set +e; REDS_SHELF_UNRECOVERABLE_CEILING=9999 sh "$SCAN" --list --list >/dev/null 2>&1; m=$?; set -e
leg census_misuse_exits_two          2                 "$m"
set +e; REDS_SHELF_RESOLVER=/nonexistent sh "$SCAN" >/dev/null 2>&1; m=$?; set -e
leg census_unreadable_resolver_two   2                 "$m"

# -- a mutation that must bite: dropping the line anchor from the headline pattern --------------
# Without `^`, a shelf QUOTING another row's headline mid-sentence claims to hold it, and every
# quoted cross-reference in these 489 shelves becomes a false holder. The plant writes exactly
# that shape and the anchored reader must refuse it.
printf 'A sentence that quotes **REDS %%900 (`x`) -- elsewhere.** mid-line.\n' \
  >> "$pen/archive/REDS-second-rows-200.md"
leg anchor_refuses_a_quoted_headline living-pin        "$(verdict %900)"

echo "legs=$legs"
echo "failed=$failed"
[ "$failed" -eq 0 ] || { echo "control_verdict=failed"; exit 1; }
echo "control_verdict=ok"
