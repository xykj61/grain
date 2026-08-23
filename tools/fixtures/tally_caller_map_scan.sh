#!/bin/sh
# Closed sample of the living Tally caller map — paths must exist.
set -eu
cd "$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"

missing=0
for p in \
  caravan/tally_copy.rye \
  caravan/parse_int.rye \
  mantra/tally_copy.rye \
  mantra/parse_int.rye \
  comlink/tally_copy.rye \
  comlink/parse_int.rye \
  amphora/tally_copy.rye \
  amphora/kumara.rye \
  granary/tally_copy.rye \
  granary/parse_int.rye \
  linengrow/tally_copy.rye \
  linengrow/parse_int.rye \
  linengrow/kumara.rye \
  glow/tally_copy.rye \
  brushstroke/tally_copy.rye \
  rishi/src/tally_copy.rye \
  rishi/src/parse_int.rye \
  mandi/tally_copy.rye \
  tools/rye/kumara.rye
do
  if [ ! -e "$p" ]; then
    echo "$p"
    missing=1
  fi
done

exit "$missing"
