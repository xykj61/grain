#!/usr/bin/env sh
# cellar_ring1_verify.sh -- verify resins; legacy and Tilak entry lines; optional golden digest.
set -eu
OUT=${1:?usage: cellar_ring1_verify.sh outdir [golden_manifest_digest]}
GOLDEN=${2:-}
MANIFEST="$OUT/manifest.bron"
# The digest tool lives at a path relative to this tree, not to wherever OUT points.
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)

test -f "$MANIFEST" || { echo "FAIL missing manifest"; exit 1; }

is_known_mark() {
  case "$1" in
    plain-bytes|manifest|plain-text|bead-index) return 0 ;;
    *) return 1 ;;
  esac
}

while read -r line; do
  case "$line" in
    entry\ *)
      set -- $line
      shift
      nf=$#
      if [ "$nf" -eq 2 ]; then
        relpath=$1
        expect=$2
      elif [ "$nf" -eq 3 ]; then
        mark=$1
        expect=$2
        relpath=$3
        if ! is_known_mark "$mark"; then
          echo "FAIL unknown mark $mark for $relpath"
          exit 1
        fi
      else
        echo "FAIL bad entry field count: $line"
        exit 1
      fi
      resin="$OUT/resins/$expect"
      test -f "$resin" || { echo "FAIL missing resin $expect for $relpath"; exit 1; }
      got=$(sh "$ROOT/tools/fixtures/sha3_256.sh" "$resin")
      test "$got" = "$expect" || { echo "FAIL digest mismatch $relpath"; exit 1; }
      ;;
  esac
done < "$MANIFEST"

digest=$(sh "$ROOT/tools/fixtures/sha3_256.sh" "$MANIFEST")
echo "MANIFEST_DIGEST $digest"

if [ -n "$GOLDEN" ]; then
  test "$digest" = "$GOLDEN" || { echo "FAIL golden mismatch want=$GOLDEN got=$digest"; exit 1; }
  echo "GOLDEN ok"
fi

echo "VERIFY ok"
