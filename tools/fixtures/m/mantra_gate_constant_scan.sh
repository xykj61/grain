#!/bin/sh
# tools/fixtures/m/mantra_gate_constant_scan.sh -- does an equality desk decide the number its
# own subject carries?
#
# WHAT THIS READS. A Mantra equality desk under src/gate/ decides one field count exactly:
# `?:  (eq sample N)  1  0`. That N is a claim about a struct in the Rye -- Line, Weave, Diff,
# Store -- and until 20260907 nothing compared the two. Line grew `site` when identity became a
# pair, and Diff grew `site` on 20260906.212206; both desks went on deciding the elder count,
# answering 0 for the number their subject actually carries, green under their witness, its
# control, and the cadence roster pass, because every instrument compared the desk against a
# number spelled beside it rather than against the module.
#
# WHY IT IS ONE FILE. The guard asks this question and the control plants a disagreement and
# watches it refuse, so the predicate is written once and both read it. A control carrying its
# own copy of the comparison proves that copy rather than the guard.
#
#   sh tools/fixtures/m/mantra_gate_constant_scan.sh <desk.glow> <module.rye> <StructName>
#
# Prints desk, struct, decided, counted and a verdict word, and exits 0 whatever it finds --
# reporting is this file's job and gating is the witness's. The verdicts are words rather than
# numbers so no reading of this output can be mistaken for an exit code.
#
# Read by tools/m/mantra_a1_equality_witness.rish; planted against by
# tools/fixtures/m/mantra_a1_equality_control.sh. Run from the repository root.

set -eu

desk="${1:?desk path}"
module="${2:?module path}"
struct="${3:?struct name}"

echo "desk=$desk"
echo "struct=$struct"

if [ ! -f "$desk" ]; then
  echo "decided="
  echo "counted="
  echo "verdict=desk_absent"
  exit 0
fi

# The decided constant, off the one line that decides. Anchored at the line start so a mention
# inside a placard comment can never answer for the rune.
decided="$(grep -E '^\?:  \(eq sample [0-9]+\)' "$desk" | sed -E 's/.*eq sample ([0-9]+).*/\1/' | head -n 1)"
echo "decided=${decided}"

if [ -z "$decided" ]; then
  echo "counted="
  echo "verdict=desk_decides_nothing"
  exit 0
fi

counted=""
if [ -f "$module" ]; then
  counted="$(sh tools/fixtures/r/rye_struct_fields_scan.sh --count "$module" "$struct" 2>/dev/null || true)"
fi
counted="$(printf '%s' "$counted" | tr -d '[:space:]')"
echo "counted=${counted}"

if [ -z "$counted" ]; then
  echo "verdict=struct_unreadable"
  exit 0
fi

if [ "$decided" = "$counted" ]; then
  echo "verdict=ok"
else
  echo "verdict=constant_disagrees"
fi
exit 0
