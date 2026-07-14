#!/usr/bin/env sh
# amber_ring1_restore.sh — restore manifest + resins (legacy or Tilak entry lines).
set -eu
OUT=${1:?usage: amber_ring1_restore.sh outdir targetdir}
TARGET=${2:?usage: amber_ring1_restore.sh outdir targetdir}
MANIFEST="$OUT/manifest.bron"

test -f "$MANIFEST" || { echo "FAIL missing manifest"; exit 1; }
rm -rf "$TARGET"
mkdir -p "$TARGET"

while read -r line; do
  case "$line" in
    entry\ *)
      set -- $line
      shift
      nf=$#
      if [ "$nf" -eq 2 ]; then
        relpath=$1
        digest=$2
      elif [ "$nf" -eq 3 ]; then
        digest=$2
        relpath=$3
      else
        echo "FAIL bad entry: $line"
        exit 1
      fi
      resin="$OUT/resins/$digest"
      dest="$TARGET/$relpath"
      mkdir -p "$(dirname "$dest")"
      cp "$resin" "$dest"
      ;;
  esac
done < "$MANIFEST"

echo "RESTORE ok target=$TARGET"
