#!/usr/bin/env sh
# Deprecated — delegates to native Rishi. Prefer:
#   rishi/bin/rishi run tools/fixtures/opening_lines_scan.rish
exec "$(dirname "$0")/../../rishi/bin/rishi" run tools/fixtures/opening_lines_scan.rish "$@"
