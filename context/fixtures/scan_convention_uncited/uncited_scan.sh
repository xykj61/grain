#!/bin/sh
# Intentional-violation fixture. Standing exempt: it exists to HOLD the
# violation scan_convention_scan must catch -- a scan that restates the
# convention instead of citing its single home. It must stay wrong.
#
# Restated on purpose, with the phrase the guard looks for:
#   values -- key=value, one per line, nothing else on the line
set -eu
echo "verdict=ok"
