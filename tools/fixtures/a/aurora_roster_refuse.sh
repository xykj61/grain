#!/bin/sh
# The good roster exits 0 and names a pair. The broken roster exits non-zero
# and speaks no sentence. The six living stages stay at six.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"

good=$(rishi/bin/rishi run tools/au/aurora_run.rish roster) || {
  echo "roster-refuse good wake failed"
  printf '%s\n' "$good"
  exit 1
}
printf '%s\n' "$good" | grep -q "pair serial_driver serial_virt" || {
  echo "roster-refuse good wake spoke no pair"
  exit 1
}
printf '%s\n' "$good" | grep -q "qemu exited with status 0" || {
  echo "roster-refuse good wake did not exit 0"
  exit 1
}

set +e
bad=$(rishi/bin/rishi run tools/au/aurora_run.rish roster_refuse)
bad_status=$?
set -e
if [ "$bad_status" -eq 0 ]; then
  echo "roster-refuse broken wake exited 0"
  printf '%s\n' "$bad"
  exit 1
fi
if printf '%s\n' "$bad" | grep -q "Aurora roster:"; then
  echo "roster-refuse broken wake spoke a sentence"
  printf '%s\n' "$bad"
  exit 1
fi
if printf '%s\n' "$bad" | grep -q "pair "; then
  echo "roster-refuse broken wake spoke a pair"
  printf '%s\n' "$bad"
  exit 1
fi
printf '%s\n' "$bad" | grep -q "qemu exited with status 1" || {
  echo "roster-refuse broken wake status was not 1"
  printf '%s\n' "$bad"
  exit 1
}

echo "roster-refuse good=0 broken=1 sentences=none"
echo "GREEN"
