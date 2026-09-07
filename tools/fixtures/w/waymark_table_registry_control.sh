#!/bin/sh
# tools/fixtures/w/waymark_table_registry_control.sh -- prove the completeness scan in both
# directions, every refusal planted and then lifted.
#
# WHY. `waymark_table_registry_completeness.sh` compares the rule table's seated marks against the
# sealed registry's rows. Until `20260907` it read one direction only, so a mark drawn into the
# registry and never written into the readable face passed in silence. The reverse reading was
# added with this control beside it, because a refusal proven only in the passing direction cannot
# be told from a bypass.
#
# HOW. Each case builds a throwaway pen holding just the two files the scan reads, runs the scan
# with the pen as the working directory, and asserts both the verdict and the named detail. The
# load-bearing legs are the two exclusions: an `abandoned` draw and a hand-seated NAME are absent
# from the table on purpose, and gating either would refuse the tree for telling the truth.
set -u

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd) || exit 1
scan="$root/tools/fixtures/w/waymark_table_registry_completeness.sh"
[ -f "$scan" ] || { echo "control: REFUSED -- the scan under test is absent"; exit 2; }

pass=0; fail=0
check() { # check <name> <expected-substring> <actual>
  if printf '%s' "$3" | grep -q -- "$2"; then
    pass=$((pass + 1)); echo "  yes  $1"
  else
    fail=$((fail + 1)); echo "  NO   $1 -- expected '$2' in: $3"
  fi
}

# build_pen <pen> <table-marks...> ; the registry is written by write_reg afterward.
build_pen() {
  p=$1; shift
  mkdir -p "$p/.claude/rules" "$p/construction"
  {
    echo "# Waymark Ladders"
    echo "| Waymark | Input | Ladder |"
    echo "|---|---|---|"
    for m in "$@"; do echo "| **$m** | \`some-input-$m\` | a ladder |"; done
  } > "$p/.claude/rules/waymark-ladders.md"
}

write_reg() { # write_reg <pen> <MARK:status>...
  p=$1; shift
  {
    echo "format waymark-registry-v1"
    echo "# ---- sealed body ----"
    for row in "$@"; do
      m=${row%%:*}; s=${row##*:}
      echo "mark $m | input in-$m | index 1 | status $s | note planted"
    done
  } > "$p/construction/waymark-registry.bron"
}

run_in() { ( cd "$1" && sh "$scan" 2>&1 ); }

echo "waymark_table_registry_control -- both directions, planted and lifted"

# 1-2. Clean both ways.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM STOA
write_reg "$pen" HAWM:living STOA:living
out=$(run_in "$pen")
check "a table and a registry holding the same two marks read ok" "verdict=ok" "$out"
check "the reading names how many living rows it compared" "registry_living=2" "$out"
rm -rf "$pen"

# 3-4. Direction one: a table mark with no registry row.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM STOA
write_reg "$pen" HAWM:living
out=$(run_in "$pen")
check "a table mark absent from the registry refuses" "verdict=incomplete" "$out"
check "and the refusal names the mark" "absent_from_registry=STOA" "$out"
rm -rf "$pen"

# 5-7. Direction two: a living registry mark with no table row -- the reading that was missing.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM
write_reg "$pen" HAWM:living STOA:living
out=$(run_in "$pen")
check "a living registry mark absent from the table refuses" "verdict=face_short" "$out"
check "and the refusal names the mark" "absent_from_table=STOA" "$out"
check "and says the face is shorter than the authority" "readable face" "$out"
rm -rf "$pen"

# 8. Lift it: write the mark into the table and the same pair reads ok.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM STOA
write_reg "$pen" HAWM:living STOA:living
out=$(run_in "$pen")
check "writing the missing mark into the table lifts the refusal" "verdict=ok" "$out"
rm -rf "$pen"

# 9-10. Load-bearing: an abandoned draw is absent from the table ON PURPOSE.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM
write_reg "$pen" HAWM:living COIF:abandoned
out=$(run_in "$pen")
check "an abandoned draw absent from the table does not refuse" "verdict=ok" "$out"
check "and it is not counted among the living" "registry_living=1" "$out"
rm -rf "$pen"

# 11-12. Load-bearing: a hand-seated NAME is absent from the table on purpose, and is reported.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM
write_reg "$pen" HAWM:living SEVA:hand-seated
out=$(run_in "$pen")
check "a hand-seated name absent from the table does not refuse" "verdict=ok" "$out"
check "and it is reported by name rather than gated" "hand_seated_absent_from_table=SEVA" "$out"
rm -rf "$pen"

# 13. A hand-seated LADDER that IS in the table leaves the report empty.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM SETU
write_reg "$pen" HAWM:living SETU:hand-seated
out=$(run_in "$pen")
check "a hand-seated ladder written into the table clears the report" "hand_seated_absent_from_table=$" "$out"
rm -rf "$pen"

# 14-15. Both faults at once: direction one is named first, and only one verdict is printed.
pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM ZETA
write_reg "$pen" HAWM:living STOA:living
out=$(run_in "$pen")
check "with both directions broken the registry-side absence is named" "verdict=incomplete" "$out"
check "and the table-side absence is still printed for the reader" "absent_from_table=STOA" "$out"
rm -rf "$pen"

# 16-17. A missing instrument refuses by name rather than passing.
pen=$(mktemp -d) || exit 2
mkdir -p "$pen/construction"
write_reg "$pen" HAWM:living
out=$(run_in "$pen")
check "an absent rule table refuses by name" "verdict=rule_absent" "$out"
rm -rf "$pen"

pen=$(mktemp -d) || exit 2
build_pen "$pen" HAWM
out=$(run_in "$pen")
check "an absent registry refuses by name" "verdict=registry_absent" "$out"
rm -rf "$pen"

echo "pass=$pass"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=control_failed"; exit 1; fi
