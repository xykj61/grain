#!/bin/sh
# tools/fixtures/r/receipt_braid_build_scan.sh -- the build half of receipt case 8.
#
# Zig refuses an @import whose path leaves the module. A file under
# .lap/receipt-braid-build that imports ../../dimeroll/receipt_offer.rye fails
# with "import of file outside module path". A file in that same pen that
# imports only std builds. A symlink beside the importing file, pointed at
# dimeroll/receipt_offer.rye, is admitted: the source braid scan is what holds
# a tracked symlink. BRAID_BUILD, when set, replaces rye_build.sh so a
# control can plant the other two answers.
#
#   sh tools/fixtures/r/receipt_braid_build_scan.sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

pen=".lap/receipt-braid-build"
rm -rf "$pen"
mkdir -p "$pen"

cat > "$pen/outside.rye" <<'EOF'
const other = @import("../../dimeroll/receipt_offer.rye");
pub fn main() void {}
EOF

cat > "$pen/clean.rye" <<'EOF'
const std = @import("std");
pub fn main() void {
    _ = std;
}
EOF

ln -s ../../dimeroll/receipt_offer.rye "$pen/peer_offer.rye"
cat > "$pen/via_link.rye" <<'EOF'
const other = @import("peer_offer.rye");
pub fn main() void {}
EOF

build_one() {
  src=$1
  emit=$2
  if [ -n "${BRAID_BUILD:-}" ]; then
    sh "$BRAID_BUILD" "$src" "$emit" >"$pen/out.txt" 2>&1
  else
    RYE_ZIG="$root/vendor/zig-toolchain/zig" \
      sh tools/fixtures/r/rye_build.sh "$src" -femit-bin="$emit" >"$pen/out.txt" 2>&1
  fi
}

set +e
build_one "$pen/outside.rye" "$pen/outside"
outside_rc=$?
set -e
if [ "$outside_rc" -eq 0 ]; then
  outside=admitted
elif grep -q "import of file outside module path" "$pen/out.txt"; then
  outside=refused
else
  outside=other
fi

set +e
build_one "$pen/clean.rye" "$pen/clean"
clean_rc=$?
set -e
if [ "$clean_rc" -eq 0 ]; then
  clean=built
else
  clean=failed
fi

set +e
build_one "$pen/via_link.rye" "$pen/via_link"
link_rc=$?
set -e
if [ "$link_rc" -eq 0 ]; then
  link=admitted
elif grep -q "import of file outside module path" "$pen/out.txt"; then
  link=refused
else
  link=other
fi

if [ "$outside" = refused ] && [ "$clean" = built ]; then
  verdict=build_refuses
elif [ "$outside" = admitted ]; then
  verdict=admitted
else
  verdict=other_refusal
fi

echo "outside=$outside"
echo "clean=$clean"
echo "link=$link"
echo "verdict=$verdict"
rm -rf "$pen"
