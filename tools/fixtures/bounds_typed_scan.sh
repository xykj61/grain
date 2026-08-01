#!/bin/sh
# tools/fixtures/bounds_typed_scan.sh — declared bounds carry their type.
# Orchestrated by tools/gen/season/bounds_typed_witness.rish.
#
# Rule (TAME root 2, and "Named constants" in the supplement): a declared bound
# is written `const max_depth: u32 = 1024;` -- name, type, value, and a comment
# saying why the bound exists. The type is what this scan checks, because it is
# the part a text scan can judge exactly.
#
# Scope, deliberately narrow: only `const max_* = <digit>` -- a declared bound
# with a literal value and no type annotation. Derived bindings (`const
# max_hops = subject.queue_depth`) infer their type from already-bounded
# operands and are correct as written. Local variables that merely begin with
# `max_` are not bounds at all; an earlier, looser pattern flagged five of them
# and one fixture path, which is why this one is scoped to a literal.
#
# Mode: advisory ratchet. It prints the count every run and never fails, per the
# tree's own law for a new rule with a small standing population.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value · detail: prefixed · verdict= its own key · status agrees.
set -eu
roster="mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke
        rye/src glow lattice dimeroll scribble lantern cellar amphora mand
        mandi granary"
n=0
for d in $roster; do
  [ -d "$d" ] || continue
  hits=$(grep -rnE '^[[:space:]]*(pub )?const max_[a-z_]+[[:space:]]*=[[:space:]]*[0-9]' \
         "$d" --include=*.rye 2>/dev/null || true)
  if [ -n "$hits" ]; then
    # grep -rn already prints the path; adding $d again doubled it (caught
    # 20260729.211500 -- same class as v1's leaked quotes: a reported path that
    # does not exist sends a reader to the wrong file).
    printf '%s\n' "$hits" | sed 's|^|detail: untyped-bound |' 
    n=$((n + $(printf '%s\n' "$hits" | wc -l)))
  fi
done
echo "untyped_declared_bounds=$n"
# The ratchet reached zero at 20260729.211500, so it turns one way only:
# a nonzero population is now a bad verdict rather than an advisory count.
if [ "$n" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=untyped_bounds"; exit 1; fi
