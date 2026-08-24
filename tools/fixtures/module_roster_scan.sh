#!/bin/sh
# tools/fixtures/module_roster_scan.sh -- the module roster names every module beside it.
#
# ONE SCAN, ANY DIRECTORY. This reads `<DIR>/MODULES.md` against the `.rye` files in `<DIR>`, and
# the directory is an argument rather than a name baked into the file. It was called
# image_module_roster_scan.sh until 20260824.091754, when lotus/ became the second directory to
# want it; the rule is written once here rather than copied per directory, since a rule written
# twice is a rule two files may quietly come to disagree about. Directories held today:
#
#   image  -- 227 modules, driven by tools/i/image_module_roster_witness.rish
#   lotus  -- 240 modules, driven by tools/l/lotus_module_roster_witness.rish
#
# WHY. image/README.md stood at 400,042 bytes on 20260824 -- the largest page in the tree -- and a
# reader entering the module used it as the roster of what is here. It named 112 of the 227 .rye
# modules in the directory, and two of those 112 name files that live in pond/apps/. So 117 modules
# had landed with nobody adding a line, and the page read exactly like a full account (REDS %188,
# the same shape as %184 one directory over). The page split three ways in that round, and the
# roster moved to image/MODULES.md where a program can hold it.
#
# WHAT IT READS. Two sets, and the claim is that they are the same set.
#
#   modules  -- every image/*.rye on disk, symlinks included, since a seam symlink is a module a
#               reader finds in this directory and expects the page to explain
#   rows     -- every table row in image/MODULES.md whose Module column links a module by name,
#               matched as `| [`<name>.rye`](<name>.rye) | <what it does> |`
#
# Matching the Module column rather than any `.rye` link is the load-bearing choice, learned from
# caravan_ladder_roster_scan.sh: the prose beside a roster cites its own modules constantly, and a
# reading that counted those would call a short table complete.
#
#   unrostered  -- a module on disk with no row. HELD AT ZERO.
#   phantom     -- a row naming a module that is absent. HELD AT ZERO.
#   duplicate   -- one module wearing two rows. HELD AT ZERO, since two rows may disagree.
#   mismatched  -- a row whose display text and link target name different modules. HELD AT ZERO,
#                  because such a row is trusted for neither.
#
# WHAT IT DOES NOT REACH, said plainly. Whether a row's sentence is TRUE. Each was written from its
# module's own `//!` head comment, and no grep reads whether that comment still describes the code.
# This guard proves the roster is whole and stops there; the module's own witness proves the module.
#
# USAGE
#   sh tools/fixtures/module_roster_scan.sh                 # census over image/ -- key=value lines
#   sh tools/fixtures/module_roster_scan.sh list            # every fault in image/, one per line
#   sh tools/fixtures/module_roster_scan.sh census lotus    # census over lotus/
#   sh tools/fixtures/module_roster_scan.sh list lotus      # every fault in lotus/
#
# Driven by tools/i/image_module_roster_witness.rish. Proven both ways by
# image_module_roster_control.sh, which builds real directories in a throwaway pen.
# Run from the repository root.
set -eu

MODE="${1:-census}"
DIR="${2:-image}"
PAGE="$DIR/MODULES.md"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT INT TERM

# The modules on disk. `ls` over a glob that matches nothing would print the glob itself, so the
# list is built with find, which prints nothing when there is nothing. A seam symlink is a module
# here, so the type test welcomes both a regular file and a link.
find "$DIR" -maxdepth 1 -name '*.rye' \( -type f -o -type l \) 2>/dev/null \
  | sed 's|.*/||; s|\.rye$||' | sort > "$TMP/modules"

# The rows. Names in this directory carry digits (font5x7_currency), so the class is [a-z0-9_].
if [ -f "$PAGE" ]; then
  grep -E '^\| \[`[a-z0-9_]+\.rye`\]\([a-z0-9_]+\.rye\) \|' "$PAGE" \
    | sed -E 's/^\| \[`([a-z0-9_]+)\.rye`\]\(([a-z0-9_]+)\.rye\) \|.*/\1 \2/' > "$TMP/pairs"
else
  : > "$TMP/pairs"
fi

awk '$1 != $2 { print $1 " " $2 }' "$TMP/pairs" > "$TMP/mismatched"
awk '$1 == $2 { print $1 }' "$TMP/pairs" | sort > "$TMP/rows_all"
sort -u "$TMP/rows_all" > "$TMP/rows"

comm -23 "$TMP/modules" "$TMP/rows" > "$TMP/unrostered"
comm -13 "$TMP/modules" "$TMP/rows" > "$TMP/phantom"
uniq -d "$TMP/rows_all" > "$TMP/duplicate"

n_modules=$(wc -l < "$TMP/modules" | tr -d ' ')
n_rows=$(wc -l < "$TMP/rows" | tr -d ' ')
n_unrostered=$(wc -l < "$TMP/unrostered" | tr -d ' ')
n_phantom=$(wc -l < "$TMP/phantom" | tr -d ' ')
n_duplicate=$(wc -l < "$TMP/duplicate" | tr -d ' ')
n_mismatched=$(wc -l < "$TMP/mismatched" | tr -d ' ')

if [ "$MODE" = list ]; then
  while IFS= read -r m; do [ -n "$m" ] && echo "unrostered: $DIR/$m.rye stands on disk with no row in $PAGE"; done < "$TMP/unrostered"
  while IFS= read -r m; do [ -n "$m" ] && echo "phantom: $PAGE carries a row for $m.rye, which is absent from $DIR/"; done < "$TMP/phantom"
  while IFS= read -r m; do [ -n "$m" ] && echo "duplicate: $m.rye wears more than one row in $PAGE"; done < "$TMP/duplicate"
  while IFS= read -r m; do [ -n "$m" ] && echo "mismatched: a row shows $m"; done < "$TMP/mismatched"
fi

echo "page=$PAGE"
echo "modules_on_disk=$n_modules"
echo "rows_in_table=$n_rows"
echo "unrostered=$n_unrostered"
echo "phantom=$n_phantom"
echo "duplicate_rows=$n_duplicate"
echo "mismatched_rows=$n_mismatched"

# A reading over an empty directory finds no fault and would report clean while measuring nothing,
# so the corpus size is published beside the verdict and an empty corpus refuses (REDS %170).
if [ "$n_modules" -eq 0 ]; then
  echo "bijection=no"
  echo "verdict=empty_corpus"
  exit 1
fi

if [ "$n_unrostered" -eq 0 ] && [ "$n_phantom" -eq 0 ] && [ "$n_duplicate" -eq 0 ] && [ "$n_mismatched" -eq 0 ]; then
  echo "bijection=yes"
  echo "verdict=ok"
  exit 0
fi
echo "bijection=no"
echo "verdict=roster_incomplete"
exit 1
