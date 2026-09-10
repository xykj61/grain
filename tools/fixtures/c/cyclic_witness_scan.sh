#!/bin/sh
# cyclic_witness_scan.sh -- does a witness RETURN to the state it started in?
#
#   sh tools/fixtures/c/cyclic_witness_scan.sh <witness-path> [--bound 300]
#
# First witness for moonshot 3 of
# `active-designing/20260910-060204_the-bounded-torus-moonshots.md`: a proof that returns to its
# start state is a loop with a declared period, and its log stays that size forever.
#
# WHAT IS ACTUALLY HASHED, and why this and not the whole tree. The tree holds tens of thousands of
# files, so hashing all of them would cost more than the witness under test. What matters for the
# cycle claim is CHANGE, and `git status --porcelain` already names exactly the paths that differ
# from the index plus every untracked file. Digesting that output captures a witness that edits a
# tracked file, adds a file, or removes one -- the three ways residue arrives -- at the price of one
# git call.
#
# WHAT THIS DELIBERATELY CANNOT SEE, named rather than left for a reader to discover:
#   - a write into a gitignored path (`session-output/`, `.lap/`, `loops/`), which is by design a
#     place laps write and therefore honest residue rather than a fault
#   - a write outside this tree, which `fleet_call.sh` is the instrument for
#   - a file written and then restored to identical bytes, which IS a cycle by this definition and
#     is the correct answer rather than a blind spot
#
# THE FALSIFIER THE DESIGN PAGE NAMED is the whole point: a witness that PASSES while its exit
# digest differs from its entry digest leaves residue, and the cycle claim would be covering the
# report rather than the state. That case prints `verdict=residue` and lists the paths.
set -eu

path=""; bound=300
while [ $# -gt 0 ]; do
  case "$1" in
    --bound) bound=$2; shift 2 ;;
    -*) echo "verdict=unknown_option ($1)"; exit 2 ;;
    *) path=$1; shift ;;
  esac
done
[ -n "$path" ] || { echo "verdict=no_path"; exit 2; }
[ -f "$path" ] || { echo "path=$path"; echo "verdict=absent"; exit 2; }

runner=${CYCLIC_RUNNER:-rishi/bin/rishi}
echo "path=$path"
echo "bound=$bound"

state() { git status --porcelain 2>/dev/null | sort; }

before_raw=$(state)
before=$(printf '%s' "$before_raw" | sha256sum | cut -d' ' -f1)
echo "entry=$before"

start=$(date +%s)
timeout "$bound" "$runner" run "$path" >/dev/null 2>&1 && code=0 || code=$?
end=$(date +%s)
echo "seconds=$((end - start))"
echo "code=$code"

after_raw=$(state)
after=$(printf '%s' "$after_raw" | sha256sum | cut -d' ' -f1)
echo "exit=$after"

# 124 is what `timeout` returns when it kills the child. A witness that never answered tells us
# nothing about cycling, so it is its own verdict rather than folded into pass or fail.
# A TIMEOUT IS A CLAIM ABOUT THE BOUND TOO (`20260910`). This printed `hung`, and
# `glow_desk_run_witness` earned that word here at 280s before measuring 455 seconds and exit 0.
# `over_bound` says what is actually known, and `bound=` and `seconds=` are printed above it.
if [ "$code" -eq 124 ]; then echo "verdict=over_bound"; exit 1; fi

if [ "$before" = "$after" ]; then
  echo "residue_paths=0"
  if [ "$code" -eq 0 ]; then echo "verdict=cycles"; exit 0; fi
  # A witness that refuses AND returns its state is still cycling. The refusal is a fact about the
  # tree; the cycle is a fact about the witness, and they are different questions.
  echo "verdict=cycles_refusing"; exit 0
fi

echo "residue:"
printf '%s\n' "$before_raw" > "${TMPDIR:-/tmp}/cyc_before.$$"
printf '%s\n' "$after_raw"  > "${TMPDIR:-/tmp}/cyc_after.$$"
diff "${TMPDIR:-/tmp}/cyc_before.$$" "${TMPDIR:-/tmp}/cyc_after.$$" | grep -E '^[<>]' | head -20 || true
n=$(diff "${TMPDIR:-/tmp}/cyc_before.$$" "${TMPDIR:-/tmp}/cyc_after.$$" | grep -cE '^[<>]' || true)
rm -f "${TMPDIR:-/tmp}/cyc_before.$$" "${TMPDIR:-/tmp}/cyc_after.$$"
echo "residue_paths=$n"
echo "verdict=residue"
exit 1
