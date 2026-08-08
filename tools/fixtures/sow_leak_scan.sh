#!/bin/sh
# sow_leak_scan.sh — the negative that matters most: no maintainer identity
# string survives into the projected seed. Prints IDENT_CLEAN or IDENT_LEAK.
# The withheld log naturally names paths, so it is excluded from the scan.
set -eu
IDENT='Keaton|Kaeden|Livermore|Reyklah|xykj61|autoproject96|bandun|pacpet-solreb'
hits=$(grep -rIlE "$IDENT" seed 2>/dev/null | grep -vE '\.sow-(withheld|scrubbed)\.log' || true)
if [ -z "$hits" ]; then
  echo IDENT_CLEAN
else
  echo IDENT_LEAK
  echo "$hits"
fi
