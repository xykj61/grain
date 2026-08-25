#!/bin/sh
# rish_brace_advisory -- print-only ratchet (never fails), born of the e194 red:
# rishi's interpolator owns the dollar-brace shape, so shell parameter
# expansions like ${var##x} or ${var%y} inside .rish strings become
# UndefinedName at run time. This advisory names every such line.
count=0
for f in $(git ls-files '*.rish'); do
  hits=$(grep -nE '\$\{[A-Za-z_][A-Za-z0-9_]*(##|#|%%|%)' "$f" 2>/dev/null)
  if [ -n "$hits" ]; then
    echo "$f:"
    echo "$hits" | sed 's/^/  /'
    n=$(echo "$hits" | wc -l)
    count=$((count+n))
  fi
done
echo "rish_brace_advisory: $count shell-expansion shapes inside rishi strings (advisory only)"
# Second check (e206, born of the e205 red): backslash escapes nothing in
# rishi, so a \" inside a run-string reaches sh as a literal backslash-quote.
# Worse than failing, a guard like: test -n \"$x\" passes VACUOUSLY -- the
# literal quote makes the string non-empty whatever $x holds. Name every site.
bs=0
for f in $(git ls-files '*.rish'); do
  hits=$(grep -nF '\"' "$f" 2>/dev/null)
  if [ -n "$hits" ]; then
    echo "$f:"
    echo "$hits" | sed 's/^/  /'
    n=$(echo "$hits" | wc -l)
    bs=$((bs+n))
  fi
done
echo "rish_backslash_advisory: $bs backslash-quote shapes inside rishi strings (advisory only)"
if [ -f tools/fixtures/rish_backslash_ledger.md ]; then
  echo "ledger=tools/fixtures/rish_backslash_ledger.md (every site classed with a reason)"
fi
exit 0
