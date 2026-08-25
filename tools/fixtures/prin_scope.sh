#!/usr/bin/env bash
# prin_scope.sh -- accrete shim -> tools/gen/chapter/prin_scope.rish (Generator Chapter s4)
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
exec "$ROOT/rishi/bin/rishi" run tools/gen/chapter/prin_scope.rish

