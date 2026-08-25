#!/usr/bin/env bash
# prin_scope.sh -- accrete shim -> tools/gen/season/prin_scope.rish (Generator Season s4)
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
exec "$ROOT/rishi/bin/rishi" run tools/gen/season/prin_scope.rish

