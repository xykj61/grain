#!/usr/bin/env bash
# prin_scope.sh — accrete shim → tools/prin_scope.rish (Generator Season s1)
# Living pin content lives in the .rish; this wrapper keeps old bash call sites green.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
exec "$ROOT/rishi/bin/rishi" run tools/prin_scope.rish
