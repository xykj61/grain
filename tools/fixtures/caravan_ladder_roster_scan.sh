#!/bin/sh
# tools/fixtures/caravan_ladder_roster_scan.sh -- the ladder table names every module beside it.
#
# WHY. caravan/README.md carried a table headed "The Ladder" and a reader used it as the roster of
# rungs. On 20260824 the table held 73 rows while 110 .rye modules stood in the directory -- 33 of
# them rungs with a witness each, landed over the days the table went untouched (REDS %184). The
# suite witness proves a bijection between the witnesses on disk and its own roster, so nothing a
# rung proves could go unheard; nothing at all bound the DOCUMENT to the directory, so the page a
# newcomer enters by could fall a third short and read exactly like a full account.
#
# WHAT IT READS. Two sets, and the claim is that they are the same set.
#
#   modules  -- every caravan/*.rye on disk
#   rows     -- every table row in caravan/LADDER.md whose File column links a module by name,
#               matched as `| <ring> | [`<name>.rye`](<name>.rye) | <proves> |`
#
# Matching the File column rather than any `.rye` link is the load-bearing choice: the rung
# sections beneath the table cite their own modules in prose constantly, and a reading that
# counted those would call the table complete while it stood short.
#
#   unrostered  -- a module on disk with no row. HELD AT ZERO.
#   phantom     -- a row naming a module that is absent. HELD AT ZERO.
#   duplicate   -- one module wearing two rows. HELD AT ZERO, since two rows may disagree.
#
# WHAT IT DOES NOT REACH, said plainly. Whether a row's Proves column is TRUE -- a sentence about
# a rung is prose, and no grep reads it. This guard proves the roster is whole, and stops there;
# the rung's own witness proves the rung.
#
# USAGE
#   sh tools/fixtures/caravan_ladder_roster_scan.sh              # census -- key=value lines
#   sh tools/fixtures/caravan_ladder_roster_scan.sh list         # every fault, one per line
#   sh tools/fixtures/caravan_ladder_roster_scan.sh census DIR   # read DIR rather than caravan/
#
# Driven by tools/ca/caravan_ladder_roster_witness.rish. Proven both ways by
# caravan_ladder_roster_control.sh, which builds real directories in a throwaway pen.
# Run from the repository root.
set -eu

MODE="${1:-census}"
DIR="${2:-caravan}"
PAGE="$DIR/LADDER.md"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT INT TERM

# The modules on disk. `ls` over a glob that matches nothing would print the glob itself, so the
# list is built with find, which prints nothing when there is nothing.
# `-type f -o -type l`, because a shared body reached by symlink is still a module of this room:
# `tally_copy.rye` and `region.rye` both point into `tally/` and both carry a row in the table, and
# a reader listing the directory sees them. The carry meter beside this one globs `"$DIR"/*.rye`,
# which follows symlinks, so a bare `-type f` here made the two meters of one room disagree by two.
find "$DIR" -maxdepth 1 -name '*.rye' \( -type f -o -type l \) 2>/dev/null \
  | sed 's|.*/||; s|\.rye$||' | sort > "$TMP/modules"

# The rows. One row is one module; the ring name in the first column is free prose and is read
# past, since `ipc buffer` names `ipc_buffer.rye` and both spellings are right where they stand.
if [ -f "$PAGE" ]; then
  grep -E '^\| [^|]+ \| \[`[a-z_]+\.rye`\]\([a-z_]+\.rye\) \|' "$PAGE" \
    | sed -E 's/^\| [^|]+ \| \[`([a-z_]+)\.rye`\]\(([a-z_]+)\.rye\) \|.*/\1 \2/' > "$TMP/pairs"
else
  : > "$TMP/pairs"
fi

# A row whose display text and target disagree names two modules and is trusted for neither, so it
# is reported by name rather than counted as either module.
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
# so the corpus size is published beside the verdict (REDS %170).
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
