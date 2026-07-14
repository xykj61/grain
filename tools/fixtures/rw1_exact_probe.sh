#!/usr/bin/env sh
# Deprecated — delegates to native Rishi. Prefer:
#   rishi/bin/rishi run tools/fixtures/rw1_exact_probe.rish
exec "$(dirname "$0")/../../rishi/bin/rishi" run tools/fixtures/rw1_exact_probe.rish "$@"
