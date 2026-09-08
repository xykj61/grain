#!/bin/sh
# tools/fixtures/s/store_shape_census.sh -- what shape is the data this tree already keeps.
#
# WHY. `construction/ITINERARY.md` books a grant: research table stores, name the most TAME-aligned
# scheme, and say plainly whether a key-value store serves this tree better. Every such comparison
# usually starts from the candidates -- PostgreSQL, SQLite, an LSM tree -- and argues down toward
# the data. This one starts from the data, because the tree already keeps 4,000-odd records and
# their shape is a fact rather than a preference. A store is fitted to a shape; measure the shape
# first and the candidate list shortens itself.
#
# THE ONE QUESTION IT ANSWERS. A relational table wants rows that agree: the same columns, each
# holding one value. A key-value or document store wants the opposite freedom: any record may carry
# any field, and a field may repeat. Those two wants are measurable in any record set, by three
# readings -- how many fields exist, how few records carry most of them, and how often a field
# repeats inside one record. This census prints those three for each population the tree keeps.
#
# THE TWO POPULATIONS, AND WHY THE UNIT DIFFERS. Kyri notation (`.kyri`, and its elder `.bron`)
# stores both, and NOTHING IN THE NOTATION SAYS WHICH A FILE IS -- a reader infers it. That is
# itself a finding and it is why this script takes the unit as an argument rather than guessing:
#
#   journal   -- one record per file. Every session log is one record; the population is the room.
#   registry  -- one table per file. Rows are delimited by a repeating lead key (`guard `, `seat `),
#                so the population is the file and the record is the block.
#
# WHAT IT PRINTS, in three legs:
#
#   journal   -- records, distinct field names, the dense core (a field at or above 90% of records),
#                the sparse tail (under 1%), singletons (exactly one record), how many records carry
#                a repeated field, and the largest multiplicity seen.
#   registry  -- per named registry: rows, columns, dense columns, optional columns, and rows
#                carrying a repeated field.
#   shape     -- the verdict: whether the two populations read as one shape or two.
#
# BLIND SPOT, PRINTED RATHER THAN LEFT IN PROSE. This reads FIELD NAMES at line start and nothing
# else. It cannot see whether two fields mean the same thing under different names, whether a field
# holds a list crammed into one line, or whether two records of the same kind disagree about what a
# field's value means. So a population reading table-shaped here may still resist a schema for a
# reason no line-start grep reaches, and `unread_lines` counts every line this census passed over.
#
# WHAT IT IS NOT. It measures the DATA, never the queries. Whether the tree's tools ask point
# lookups, range scans, or field predicates is a different census over a different room, and the
# paper that cites this one says so at the point where it matters.

set -eu

root=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$root"

# BOUND. A census that walks the tree names its ceiling, and refuses rather than truncating -- a
# silent truncation reads exactly like a small tree. 8,192 is a power of two above the 4,494 record
# files tracked on `20260907` and well under any plausible near-term count; raise it deliberately.
max_records=${STORE_SHAPE_MAX:-8192}

want=all
case "${1:-}" in
  "") ;;
  journal|registry|shape) want=$1 ;;
  *) echo "refused: unknown leg ${1} -- journal, registry, shape, or nothing for all" >&2; exit 1 ;;
esac

work=$(mktemp -d 2>/dev/null || { d=/tmp/store_shape.$$; mkdir -p "$d"; echo "$d"; })
trap 'rm -rf "$work"' EXIT INT TERM

# A PEN, so the readings can be proven on data rather than only on the scan's own text. With
# `STORE_SHAPE_PEN` set, both populations are read from that directory instead of from the tree:
# `journal/` holds one record per file and `registry/` holds the named tables. The control builds
# a handful of records there, plants a repeated field into a registry row and strips one from a
# journal record, and watches the verdict move -- which is a claim about the READING rather than
# about the tree, and the only way to show `two_shapes` from both sides.
if [ -n "${STORE_SHAPE_PEN:-}" ]; then
  [ -d "$STORE_SHAPE_PEN" ] || { echo "refused: STORE_SHAPE_PEN names no directory" >&2; exit 1; }
  find "$STORE_SHAPE_PEN/journal" -type f -name '*.kyri' 2>/dev/null | sort > "$work/journal.txt" || :
  registries=$(find "$STORE_SHAPE_PEN/registry" -type f -name '*.kyri' 2>/dev/null | sort | sed 's/$/:row/')
else
  git ls-files 'session-logs/*.kyri' 'session-logs/*.bron' > "$work/journal.txt" 2>/dev/null || :
fi
journal_n=$(wc -l < "$work/journal.txt" | tr -d ' ')

if [ "$journal_n" -gt "$max_records" ]; then
  echo "refused: journal holds $journal_n records above the named ceiling of $max_records" >&2
  exit 1
fi

# --- leg one: the journal, one record per file ------------------------------------------------
#
# Two passes over each file, both anchored at line start. `fields.txt` gets one line per DISTINCT
# field per record, so counting it by name gives how many records carry that field. `reps.txt` gets
# one line per field that appears more than once inside one record, carrying its multiplicity.

if [ "$want" = all ] || [ "$want" = journal ]; then
  : > "$work/fields.txt"
  : > "$work/reps.txt"
  unread=0
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    grep -oE '^[a-z_][a-z0-9_]*' "$f" 2>/dev/null | sort | uniq -c > "$work/one.txt" || :
    awk '{ print $2 }' "$work/one.txt" >> "$work/fields.txt"
    awk '$1 > 1 { print $2, $1 }' "$work/one.txt" >> "$work/reps.txt"
    total=$(wc -l < "$f" | tr -d ' ')
    named=$(awk '{ s += $1 } END { print s+0 }' "$work/one.txt")
    unread=$(( unread + total - named ))
  done < "$work/journal.txt"

  sort "$work/fields.txt" | uniq -c | sort -rn > "$work/freq.txt"
  distinct=$(wc -l < "$work/freq.txt" | tr -d ' ')
  dense=$(awk -v n="$journal_n" '$1 >= 0.9 * n' "$work/freq.txt" | wc -l | tr -d ' ')
  sparse=$(awk -v n="$journal_n" '$1 < 0.01 * n' "$work/freq.txt" | wc -l | tr -d ' ')
  singleton=$(awk '$1 == 1' "$work/freq.txt" | wc -l | tr -d ' ')
  rep_records=$(awk '{ print }' "$work/reps.txt" | wc -l | tr -d ' ')
  rep_files=$(sort -u "$work/reps.txt" | awk '{ print }' | wc -l | tr -d ' ')
  rep_max=$(awk 'BEGIN { m = 0 } { if ($2 > m) m = $2 } END { print m+0 }' "$work/reps.txt")
  rep_field_max=$(awk 'BEGIN { m = 0 } { if ($2 > m) { m = $2; k = $1 } } END { print (k == "" ? "none" : k) }' "$work/reps.txt")
  # A record counts once however many of its fields repeat -- the question is how many records a
  # single-valued schema would refuse, not how many refusals each would raise.
  carriers=0
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    if grep -oE '^[a-z_][a-z0-9_]*' "$f" 2>/dev/null | sort | uniq -d | grep -q .; then
      carriers=$(( carriers + 1 ))
    fi
  done < "$work/journal.txt"

  echo "journal_records=$journal_n"
  echo "journal_fields=$distinct"
  echo "journal_dense_core=$dense"
  echo "journal_sparse_tail=$sparse"
  echo "journal_singleton_fields=$singleton"
  echo "journal_multivalued_records=$carriers"
  echo "journal_max_multiplicity=$rep_max"
  echo "journal_widest_field=$rep_field_max"
  echo "journal_unread_lines=$unread"
  echo "$carriers" > "$work/carriers"
  echo "$journal_n" > "$work/jn"
fi

# --- leg two: the registries, one table per file -----------------------------------------------
#
# Each registry names its own lead key, since that is what delimits a row. Comment lines are
# dropped before the split: a `#` line inside a block is prose about the row, never a column, and
# counting it made every second row read as multi-valued on the first draft of this census.

if [ -z "${registries:-}" ]; then
registries="construction/standing-equipment.kyri:guard
construction/fleet-roster.kyri:seat
construction/domain-registry.bron:domain
construction/waymark-registry.bron:mark"
fi

if [ "$want" = all ] || [ "$want" = registry ]; then
  reg_rows_total=0
  reg_multivalued_total=0
  for entry in $registries; do
    file=${entry%%:*}
    lead=${entry##*:}
    [ -f "$file" ] || { echo "registry_absent=$file"; continue; }
    # NO COMMENT STRIP, and the absence is deliberate rather than an oversight. A `#` line never
    # matches the anchored field pattern below, so a strip ahead of it removes nothing -- which is
    # exactly what `store_shape_control.sh` proved when its plant of a strip changed no number.
    # The anchored pattern is the load-bearing line, and that is where the plant now lands.
    cp "$file" "$work/clean.txt"
    rows=$(grep -cE "^$lead " "$work/clean.txt" || :)
    awk -v lead="$lead" '
      $0 ~ "^" lead " " { if (n) print buf; buf = ""; n++ }
      n && /^[a-z_][a-z0-9_]* / { buf = buf " " $1 }
      END { if (n) print buf }
    ' "$work/clean.txt" > "$work/rows.txt"
    cols=$(tr ' ' '\n' < "$work/rows.txt" | grep -v '^$' | sort -u | wc -l | tr -d ' ')
    dense=$(tr ' ' '\n' < "$work/rows.txt" | grep -v '^$' | sort | uniq -c | awk -v r="$rows" '$1 >= 0.9 * r' | wc -l | tr -d ' ')
    multi=$(awk '{ delete c; d = 0; for (i = 1; i <= NF; i++) c[$i]++; for (k in c) if (c[k] > 1) d = 1; if (d) r++ } END { print r+0 }' "$work/rows.txt")
    echo "registry=$file lead=$lead rows=$rows columns=$cols dense_columns=$dense optional_columns=$(( cols - dense )) multivalued_rows=$multi"
    reg_rows_total=$(( reg_rows_total + rows ))
    reg_multivalued_total=$(( reg_multivalued_total + multi ))
  done
  echo "registry_rows=$reg_rows_total"
  echo "registry_multivalued_rows=$reg_multivalued_total"
  echo "$reg_multivalued_total" > "$work/regmulti"
  echo "$reg_rows_total" > "$work/regrows"
fi

# --- leg three: the verdict --------------------------------------------------------------------
#
# TWO SHAPES is the reading the tree gives today, and the invariant worth holding is not any one
# number -- every number here grows daily -- but the SEPARATION: the journal's records mostly carry
# a repeated field, and the registries' rows carry none. That separation is what makes one store
# scheme wrong for one of the two populations, and it is what a witness can hold while the counts
# move underneath it.

if [ "$want" = all ] || [ "$want" = shape ]; then
  if [ ! -f "$work/carriers" ] || [ ! -f "$work/regmulti" ]; then
    echo "verdict=partial -- the shape leg reads both populations; run it without a leg argument"
    exit 0
  fi
  carriers=$(cat "$work/carriers")
  jn=$(cat "$work/jn")
  regmulti=$(cat "$work/regmulti")
  regrows=$(cat "$work/regrows")
  share=$(( carriers * 100 / jn ))
  echo "journal_multivalued_share_pct=$share"
  echo "registry_multivalued_share_pct=$(( regmulti * 100 / regrows ))"
  if [ "$share" -ge 50 ] && [ "$regmulti" -eq 0 ]; then
    echo "verdict=two_shapes"
  else
    echo "verdict=one_shape"
  fi
fi
