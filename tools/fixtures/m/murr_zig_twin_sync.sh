#!/usr/bin/env bash
# murr_zig_twin_sync.sh -- MUR module-wave step 7 probe (rye/zig twin discipline).
# Invoke with bash (not dash): rishi run uses bash path below.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

fail() { echo "REFUSE: $*" >&2; exit 1; }

test -f linengrow/murr_core.rye || fail "murr_core.rye absent"
rg -q 'pub fn fold_murr_log' linengrow/murr_core.rye || fail "fold_murr_log absent from murr_core.rye"

tracked_zig="$(git ls-files 'linengrow/*.zig' || true)"
test -z "$tracked_zig" || fail "tracked linengrow/*.zig must stay ABSENT — got: $tracked_zig"

tracked_core="$(git ls-files linengrow/murr_core.zig linengrow/mala_core.zig || true)"
test -z "$tracked_core" || fail "standalone core zig must stay untracked — got: $tracked_core"

rye_debt="$(rg -n '@import\("mala_core|fold_mala_log' --glob '*.rye' \
  linengrow mandi granary pond/apps comlink tools 2>/dev/null | head -20 || true)"
test -z "$rye_debt" || fail "living rye mala twin debt — $rye_debt"

# Portable: only probe when at least one orphan zig exists (emit leftovers).
local_debt=""
if ls linengrow/*.zig linengrow/*.rye.zig >/dev/null 2>&1; then
  local_debt="$(rg -n 'mala_core\.zig|fold_mala_log|@import\("mala_core' \
    linengrow/*.zig linengrow/*.rye.zig 2>/dev/null | head -20 || true)"
fi
test -z "$local_debt" || fail "local zig mala twin debt — $local_debt"

echo "witness:murr-zig-twin GREEN — rye source · tracked zig ABSENT · no mala twin debt"
echo "GREEN: murr-zig-twin — emit bridge discipline; orphans (if any) name murr_core.zig only"
