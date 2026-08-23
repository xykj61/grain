#!/bin/sh
# tools/fixtures/document_mirror_scan.sh -- a document declared to live in several homes holds the
# same bytes in every one of them.
#
# WHY. Moving a document breaks its inbound references; copying it lets the copies drift in the
# dark. Declaring the homes in context/document-mirrors.brix and proving them identical keeps both
# doors open, and turns drift into a red on the lap it enters.
#
# WHAT IS GATED, hard, at zero. Every `at` path in the descriptor differing from its `canonical`,
# and every declared path absent from the tracked tree.
#
# WHAT PASSES FREE. Nothing. A mirror set is small and deliberate, so a ratchet would be a way of
# saying the declaration is aspirational, and an aspirational mirror is worse than no mirror.
#
# USAGE
#   sh tools/fixtures/document_mirror_scan.sh              # report
#   sh tools/fixtures/document_mirror_scan.sh write        # copy canonical over every mirror
#   sh tools/fixtures/document_mirror_scan.sh report <descriptor>   # a pen's own descriptor
#
# Driven by tools/d/document_mirror_witness.rish. Run from the repository root.

set -u

mode=${1:-report}
desc=${2:-context/document-mirrors.brix}

if [ ! -f "$desc" ]; then
  echo "verdict=no_descriptor"
  echo "refused: $desc is the declaration this scan reads, and it is absent" >&2
  exit 1
fi

sets=0; mirrors=0; drifted=0; absent=0
canonical=""

# The descriptor is Brix: one field per line, `#` comments, no quotes and no braces. Read it the
# way Bron is read -- a first word naming the field, the rest its value.
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in ''|'#'*) continue ;; esac
  key=${line%% *}
  val=${line#* }
  [ "$key" = "$val" ] && val=""
  case "$key" in
    mirror)    sets=$((sets + 1)); canonical="" ;;
    canonical)
      canonical=$val
      if [ ! -f "$canonical" ]; then
        echo "detail: canonical absent -> $canonical"
        absent=$((absent + 1)); canonical=""
      fi
      ;;
    at)
      mirrors=$((mirrors + 1))
      if [ -z "$canonical" ]; then
        echo "detail: mirror declared with no readable canonical -> $val"
        absent=$((absent + 1)); continue
      fi
      if [ "$mode" = "write" ]; then
        mkdir -p "$(dirname "$val")"
        # An in-place write through the original inode, so a tracked mode survives the copy
        # (.claude/rules/exec-bit.md -- `mv` carries the temporary's mode instead).
        if [ -f "$val" ]; then cat "$canonical" > "$val"; else cp "$canonical" "$val"; fi
        echo "detail: wrote $val from $canonical"
        continue
      fi
      if [ ! -f "$val" ]; then
        echo "detail: mirror absent -> $val"
        absent=$((absent + 1)); continue
      fi
      if ! cmp -s "$canonical" "$val"; then
        echo "detail: mirror drifted -> $val differs from $canonical"
        drifted=$((drifted + 1))
      fi
      ;;
  esac
done < "$desc"

echo "mirror_sets=$sets"
echo "mirrors_declared=$mirrors"
echo "mirrors_drifted=$drifted"
echo "paths_absent=$absent"

if [ "$mode" = "write" ]; then echo "verdict=written"; exit 0; fi
if [ "$drifted" -eq 0 ] && [ "$absent" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
[ "$drifted" -gt 0 ] && { echo "verdict=mirror_drift"; exit 2; }
echo "verdict=path_absent"
exit 3
