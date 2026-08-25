#!/bin/sh
# Census control scan -- thin POSIX entry (e126 climb - start rung sh->rish).
#
# Prefer Rishi orchestration when the binary is present; otherwise drive the
# same seams from shell so Cloud benches without zig/rye stay green.
#
#   sh tools/fixtures/census_control_scan.sh
#   sh tools/fixtures/census_control_scan.sh prove-red
#
# Law: POSIX seams -- keep .sh entry points, orchestration in .rish.
# Law: one duty, one implementation -- duty bodies live in the seams.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

if test -x "$ROOT/rishi/bin/rishi"; then
  exec "$ROOT/rishi/bin/rishi" run tools/fixtures/census_control_scan.rish "$@"
fi

exec sh tools/fixtures/census_control_scan_drive.sh "$@"
