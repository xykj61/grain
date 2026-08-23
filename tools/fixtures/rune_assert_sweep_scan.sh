#!/bin/sh
# tools/fixtures/rune_assert_sweep_scan.sh — audit assert coverage across authored Rye.
# Orchestrated by tools/r/rune_assert_sweep.rish.
#
# For each .rye path given, count its functions, its bare `assert(` calls, and its
# `// invariant:` comment lines, and emit per-file counts plus a verdict. The floor
# (verdict=drift when broken): a function-bearing file must carry at least one assert
# — no zero-assert module. Density (asserts per function) is reported as advisory.
# A first argument of "advise" runs the wider ratchet sweep: zero-assert files are
# reported (migrate on touch) rather than failed, matching TAME's gate-vs-ratchet
# split. Without it, the gate mode fails RED on any zero-assert function-bearing file.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu
advise=0
if [ "${1:-}" = "advise" ]; then advise=1; shift; fi
fail=0
for f in "$@"; do
  if [ ! -f "$f" ]; then
    echo "detail: absent ($f)"
    fail=$((fail + 1))
    continue
  fi
  fns=$(grep -cE '^[[:space:]]*(pub )?fn ' "$f" || true)
  asserts=$(grep -cE '\bassert\(' "$f" || true)
  invs=$(grep -cE '// invariant:' "$f" || true)
  echo "file=$f fns=$fns asserts=$asserts invariants=$invs"
  if [ "$fns" -gt 0 ] && [ "$asserts" -eq 0 ]; then
    if [ "$advise" -eq 1 ]; then
      echo "detail: advisory ($f) has $fns functions and zero asserts — migrate on touch"
    else
      echo "detail: drifted ($f) has $fns functions and zero asserts"
      fail=$((fail + 1))
    fi
  fi
  if [ "$fns" -gt 0 ] && [ "$asserts" -gt 0 ] && [ "$invs" -eq 0 ]; then
    echo "detail: advisory ($f) carries asserts but names no // invariant:"
  fi
done
echo "drift=$fail"
if [ "$advise" -eq 1 ]; then echo "verdict=advise"; exit 0; fi
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=drift"; exit 1; fi
