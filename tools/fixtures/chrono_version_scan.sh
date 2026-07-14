#!/usr/bin/env sh
# Deprecated — delegates to native Rishi. Prefer:
#   rishi/bin/rishi run tools/fixtures/chrono_version_scan.rish
# Roster glob: tools/fixtures/chrono_version_roster.sh
exec "$(dirname "$0")/../../rishi/bin/rishi" run tools/fixtures/chrono_version_scan.rish "$@"
