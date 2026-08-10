#!/bin/sh
# sow_leak_scan.sh — the negative that matters most: no maintainer identity
# string survives into the projected seed. Prints IDENT_CLEAN or IDENT_LEAK.
# The withheld log naturally names paths, so it is excluded from the scan.
set -eu
# Every maintainer identity string, prior name, family surname, club, personal
# handle, and contact identifier. Case-insensitive so a lowercase handle cannot
# slip a leak past a name meant with a capital. Expanded 20260810 (privacy).
IDENT='Keaton|Kaeden|Livermore|Reyklah|Dunsford|Mayacama|xykj61|autoproject96|bandun|pacpet-solreb|keatonsiya|xnkg30|veganreyklah|cherry996|415.?915.?6666|npub1[a-z0-9]{40}'
hits=$(grep -riIlE "$IDENT" seed 2>/dev/null | grep -vE '\.sow-(withheld|scrubbed|excluded)\.log' || true)
if [ -z "$hits" ]; then
  echo IDENT_CLEAN
else
  echo IDENT_LEAK
  echo "$hits"
fi
