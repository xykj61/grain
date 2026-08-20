#!/bin/sh
# caravan_ladder_reach_scan.sh -- every rung of the Caravan ladder folds into the
# rung directly below it, and no rung reaches past its neighbor.
#
# A rung whose check is byte-for-byte the one beneath it runs it there rather
# than carrying a copy (the 20260820.131713 design call, option A). That fold has
# two written forms, and the alias in each names which rung the body actually runs
# in: the elder `return <alias>_rung.check_<name>();`, and the harness form
# `return ladder_checks.check_<name>(<alias>_rung);`, which is what a rung writes
# once the rung below publishes no stub of its own (the 20260820.182533 fold).
# Both are read here, since a guard blind to one form would pass a ladder that had
# merely moved between them -- a count that cannot see what it measures, REDS %97.
#
# The discipline the fold assumes is one step: each rung folds into the rung
# immediately beneath it, so the chain walks down one rung at a time. A rung that
# reaches two rungs down skips its neighbor -- and then both rungs hold the same
# five-line stub, byte for byte, which the copy meter counts as carried lines.
# `desist.rye` was born as a copy of `mind.rye` and inherited its delegations
# whole, so both folded into `forbear.rye` and 195 lines rode the ladder for it.
#
# Skipping is invisible to the eye and plain to a count, so this scan states it
# as a rule a machine can check: a rung folds into at most ONE rung, and no rung
# is folded into by TWO. Either failure is a rung reaching past its neighbor.
#
# CARAVAN_LADDER_DIR (default caravan): the directory of rung modules, so the
# PASS and FAIL fixtures can prove both paths without touching the tree.
set -eu

DIR=${CARAVAN_LADDER_DIR:-caravan}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

modules=0
folding=0
for f in "$DIR"/*.rye; do
  test -f "$f" || continue
  modules=$((modules + 1))
  mod=$(basename "$f" .rye)
  # A rung names the rung below it in one of two forms, and both are a fold. The
  # elder form calls the check on that rung directly; the harness form hands that
  # rung to the shared body in ladder_checks.rye, which is what a rung writes once
  # the rung below stopped publishing a stub of its own (the 20260820.182533 fold).
  # Reading only one form would leave a rung's reach unguarded the moment it moved
  # to the other -- a guard that cannot see what it measures (REDS %97).
  targets=$( { grep -oE 'return [a-z_]+_rung\.check_' "$f" 2>/dev/null \
      | sed 's/^return //; s/\.check_$//'
    grep -oE 'return ladder_checks\.check_[a-z0-9_]+\([a-z_]+_rung' "$f" 2>/dev/null \
      | sed 's/.*(//'
  } | sort -u)
  test -n "$targets" || continue
  folding=$((folding + 1))
  count=$(printf '%s\n' "$targets" | wc -l | tr -d ' ')
  if [ "$count" -ne 1 ]; then
    echo "LADDER_REACH_BAD ${mod} folds into ${count} rungs at once: $(printf '%s' "$targets" | tr '\n' ' ')"
    echo "LADDER_REACH_FAIL reason=many_targets rung=${mod} targets=${count}"
    exit 1
  fi
  printf '%s %s\n' "$targets" "$mod" >> "$work/pairs"
done

if [ "$modules" -eq 0 ]; then
  echo "LADDER_REACH_BAD no rung modules found under ${DIR}"
  echo "LADDER_REACH_FAIL reason=no_modules dir=${DIR}"
  exit 1
fi

if [ "$folding" -eq 0 ]; then
  echo "LADDER_REACH_BAD ${modules} modules hold no folds at all"
  echo "LADDER_REACH_FAIL reason=no_folds dir=${DIR} modules=${modules}"
  exit 1
fi

shared=$(cut -d' ' -f1 "$work/pairs" | sort | uniq -d)
if [ -n "$shared" ]; then
  for s in $shared; do
    who=$(awk -v t="$s" '$1 == t { printf "%s ", $2 }' "$work/pairs")
    echo "LADDER_REACH_BAD ${s} is folded into by more than one rung: ${who}"
  done
  first=$(printf '%s\n' "$shared" | head -1)
  echo "LADDER_REACH_FAIL reason=shared_target rung=${first}"
  exit 1
fi

echo "LADDER_REACH_MODULES ${modules} folding=${folding}"
echo "LADDER_REACH_OK every folding rung names one rung below, and no rung below is named twice"
