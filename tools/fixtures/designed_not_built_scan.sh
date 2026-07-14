#!/usr/bin/env sh
# Deprecated — delegates to native Rishi. Prefer:
#   rishi/bin/rishi run tools/fixtures/designed_not_built_scan.rish
exec "$(dirname "$0")/../../rishi/bin/rishi" run tools/fixtures/designed_not_built_scan.rish "$@"
