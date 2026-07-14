#!/bin/sh
# Deprecated — delegates to native Rishi. Prefer:
#   rishi/bin/rishi run tools/fixtures/tame_style_long_fn.rish
exec "$(dirname "$0")/../../rishi/bin/rishi" run tools/fixtures/tame_style_long_fn.rish "$@"
