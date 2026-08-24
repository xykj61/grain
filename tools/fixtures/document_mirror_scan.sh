#!/bin/sh
# tools/fixtures/document_mirror_scan.sh -- a document declared to live in several homes holds the
# same bytes in every one of them.
#
# WHY. Moving a document breaks its inbound references; copying it lets the copies drift in the
# dark. Declaring the homes in context/document-mirrors.brix and proving them identical keeps both
# doors open, and turns drift into a red on the lap it enters.
#
# WHAT IS GATED, hard, at zero. Every `at` path in the descriptor differing from its `canonical`,
# every declared path absent from the tracked tree, and -- added by REDS %176 -- every relative link
# inside a mirrored document that fails to resolve from ANY of its homes.
#
# WHY THAT THIRD READING EXISTS, since it was learned rather than designed. A mirror is byte-identical
# and a relative link is depth-dependent, so the two fight the moment the homes sit at different
# depths. `context/KYRI.md` gained `../foundations/x.md`, which resolves from `context/` and lands on
# `ember/foundations/x.md` from `ember/voices/`: eight links broke at once, and the mirror was green
# throughout, because the bytes matched perfectly. Bare sibling links break the same way at any depth.
# The technique that works is to write every link as `../<room>/<file>` -- correct from every home --
# and this reading is what proves it stayed that way.
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

sets=0; mirrors=0; drifted=0; absent=0; unresolved=0
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
      # Every relative link must resolve from EVERY home, canonical included. A byte-identical copy
      # at another path is only correct when its links are too (REDS %176).
      for home in "$canonical" "$val"; do
        dir=$(dirname "$home")
        for link in $(sed -n 's/.*](\([^)# ]*\)[)#].*/\1/p' "$home"); do
          case "$link" in http*|mailto:*|'') continue ;; esac
          if [ ! -e "$dir/$link" ]; then
            echo "detail: link fails from a home -> $home reads $link"
            unresolved=$((unresolved + 1))
          fi
        done
      done
      ;;
  esac
done < "$desc"

echo "mirror_sets=$sets"
echo "mirrors_declared=$mirrors"
echo "mirrors_drifted=$drifted"
echo "paths_absent=$absent"
echo "links_unresolved_from_a_home=$unresolved"

if [ "$mode" = "write" ]; then echo "verdict=written"; exit 0; fi
if [ "$drifted" -eq 0 ] && [ "$absent" -eq 0 ] && [ "$unresolved" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
[ "$unresolved" -gt 0 ] && [ "$drifted" -eq 0 ] && [ "$absent" -eq 0 ] && { echo "verdict=link_unresolved_from_a_home"; exit 4; }
[ "$drifted" -gt 0 ] && { echo "verdict=mirror_drift"; exit 2; }
echo "verdict=path_absent"
exit 3
