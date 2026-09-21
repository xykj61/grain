#!/usr/bin/env sh
# amphora_carry.sh -- copy a poured Amphora bundle to a far dock (fixture crossing).
#
# Usage: amphora_carry.sh sourcedir fardir
set -eu
SRC=${1:?usage: amphora_carry.sh sourcedir fardir}
FAR=${2:?usage: amphora_carry.sh sourcedir fardir}

test -f "$SRC/vessel.kyri" || { echo "FAIL missing vessel at source"; exit 1; }
test -f "$SRC/manifest.kyri" || { echo "FAIL missing manifest at source"; exit 1; }
test -d "$SRC/resins" || { echo "FAIL missing resins at source"; exit 1; }

rm -rf "$FAR"
mkdir -p "$FAR"
cp -a "$SRC/vessel.kyri" "$SRC/manifest.kyri" "$FAR/"
cp -a "$SRC/resins" "$FAR/resins"

diff -q "$SRC/vessel.kyri" "$FAR/vessel.kyri" >/dev/null
diff -q "$SRC/manifest.kyri" "$FAR/manifest.kyri" >/dev/null
diff -r "$SRC/resins" "$FAR/resins" >/dev/null

echo "CARRY ok far=$FAR"
