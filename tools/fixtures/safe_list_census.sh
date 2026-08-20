#!/bin/sh
# Census SAFE.md + oldness-cycle companion. Empty list (0 rows) is welcome.
# Prints shape; never shreds. Bound 64 with why.
set -eu
SAFE=SAFE.md
SPEC=context/specs/oldness-cycle.md
if ! test -f "$SAFE"; then
  echo "SAFE=ABSENT"
  echo "verdict=absent"
  exit 1
fi
if ! test -f "$SPEC"; then
  echo "SPEC=ABSENT"
  echo "verdict=absent"
  exit 1
fi
SEATED=no
rg -q '^\*\*Seated:\*\*' "$SAFE" && SEATED=yes
BOUND_NAMED=no
rg -q 'sixty-four rows|0 of 64|of 64' "$SAFE" && BOUND_NAMED=yes
SPEC_OK=no
if rg -q 'safe list|SAFE\.md|oldness census' "$SPEC" && rg -q 'sixty-four' "$SPEC"; then
  SPEC_OK=yes
fi
# Rows: N of 64
ROWS=$(rg -o 'Rows:\*\*[[:space:]]*[0-9]+ of 64' "$SAFE" | rg -o '[0-9]+' | head -1)
ROWS=${ROWS:-missing}
CYCLE=$(rg -o 'Cycle:\*\*[[:space:]]*[0-9]+' "$SAFE" | rg -o '[0-9]+' | head -1)
CYCLE=${CYCLE:-missing}
EMPTY_OK=no
if rg -q 'none yet' "$SAFE" || test "$ROWS" = "0"; then
  EMPTY_OK=yes
fi
# living shred refuse still holds (measure only — fascia refuse line).
# fascia_metric_v0 now phrases the held refuse as "no live shred"; the older
# "no shred" / "shred refuse" / "refuse: shred" phrasings are kept so a bench
# on either wording still reads the signal (REDS %67 — a witness must follow
# the wording of what it reads, or it rots stale the day that wording moves).
SHRED_RED=no
if rishi/bin/rishi run tools/gen/season/fascia_metric_v0.rish 2>/dev/null | rg -q 'refuse: shred|no live shred|no shred|shred refuse'; then
  SHRED_RED=yes
fi
echo "SAFE=present"
echo "SPEC=present"
echo "SEATED=${SEATED}"
echo "BOUND_NAMED=${BOUND_NAMED}"
echo "SPEC_OK=${SPEC_OK}"
echo "cycle=${CYCLE}"
echo "rows=${ROWS}"
echo "bound=64"
echo "EMPTY_OK=${EMPTY_OK}"
echo "SHRED_RED=${SHRED_RED}"
if test "$SEATED" = yes \
  && test "$BOUND_NAMED" = yes \
  && test "$SPEC_OK" = yes \
  && test "$CYCLE" != missing \
  && test "$ROWS" != missing \
  && test "$ROWS" -le 64 \
  && test "$EMPTY_OK" = yes \
  && test "$SHRED_RED" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
