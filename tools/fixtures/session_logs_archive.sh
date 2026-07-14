#!/bin/sh
# Deprecated — delegates to Rye implementation. Prefer:
#   rishi/bin/rishi run tools/session_logs_archive.rish
exec "$(dirname "$0")/../../rishi/bin/rishi" run tools/session_logs_archive.rish "$@"
