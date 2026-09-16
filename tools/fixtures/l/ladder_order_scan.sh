#!/bin/sh
# tools/fixtures/l/ladder_order_scan.sh -- CAN THE ERRATA STATE AN ORDER? The twelve rows of
# active-designing/20260910-060204_the-bounded-torus-moonshots.md were ranked once, on the day
# they were written, by what a lane could start on this pier. Ten of the twelve now carry an
# erratum reporting a landed measurement, and several of those errata recommend a re-rank or a
# re-aim in their own words. The ranking table still reads as first written -- correctly, since
# dated testimony keeps every word -- so no page states the order the measurements support.
#
# This scan asks whether such an order can be DERIVED rather than composed by hand. It reads the
# page's own three structures and compares them:
#
#   READING 1 -- THE ROSTER. Every `### N. Title` heading under "## The twelve" is one row. The
#   count is a gate rather than a constant: a page growing a thirteenth row must be met by a
#   reader that sees thirteen, and a hard-coded twelve would pass in silence.
#
#   READING 2 -- THE STANDING RANK. The ranking table gives each row the position it was first
#   assigned. This is the order a reader of the page takes away today.
#
#   READING 3 -- THE RECOMMENDATIONS. Each `**Row N erratum:**` clause is read for a
#   recommendation sentence and classified by what it asks for:
#     rank   -- it names a target position in words ("a rank of fourth", "last of the twelve")
#     aim    -- it asks the row be re-aimed and names no position
#     breach -- it asks the row be superseded
#     none   -- the erratum reports a reading and recommends nothing
#   A row may carry more than one erratum; the LATEST by stamp is the one that speaks, since an
#   erratum written later read the earlier one.
#
# THE DERIVATION. A target position is taken from a `rank` recommendation where one exists, and
# from the standing table otherwise. Two rows landing on one position is a COLLISION, and a
# collision is what decides whether the errata can state an order at all: a permutation admits
# none. The count of collisions, the count of rows whose position is spoken for by a
# measurement, and the count left standing on the original judgment are each reported apart,
# because they answer different questions.
#
# WHAT WOULD FALSIFY THE READING. Zero collisions with every row's position spoken for by a
# recommendation would say the errata compose into an order and the page need only transcribe
# it. A parse failure on a clause the page carries would say the reader is measuring its own
# blind spot rather than the page.
#
# Style: Gauge at Meter. Every figure below is derived from the page on each run; the page is
# dated testimony and its words do not move, so a reading changes only when an erratum lands.
set -u

PAGE="${LADDER_PAGE:-active-designing/20260910-060204_the-bounded-torus-moonshots.md}"
MODE="${1:-}"

# A pen of this scan's own making, released on every exit path. The elder draft wrote its four
# scratch files into `.lap/` and made no room for them, so in a tree lacking that directory every
# write failed and the scan still printed `verdict=order` -- an answer about a page it had not
# read. A scan that cannot reach its own scratch refuses. The `trap` is the shape REDS %745 is
# open about: a pen released on refusal as well as on success.
WORK=$(mktemp -d "${TMPDIR:-/tmp}/ladder_order.XXXXXX") || {
  echo "scratch_writable=no"
  echo "detail: no pen could be made -- a reading with nowhere to stand is no reading at all"
  echo "verdict=unscratchable"
  exit 0
}
trap 'rm -rf "$WORK"' EXIT INT TERM

if [ ! -f "$PAGE" ]; then
  echo "page_readable=no"
  echo "detail: $PAGE is absent -- a reading of a page this tree lacks is no reading at all"
  echo "verdict=unreadable"
  exit 0
fi
echo "page=$PAGE"
echo "page_readable=yes"

# READING 1 -- the roster of rows.
rows=$(grep -cE '^### [0-9]+\. ' "$PAGE")
echo "rows=$rows"

# READING 2 -- the standing rank table. A table row reads: | 3 | 6. Joules ... | why |
awk -F'|' '/^\| *[0-9]+ *\| *[0-9]+\. / {
  gsub(/ /, "", $2); split($3, p, "."); gsub(/ /, "", p[1]);
  printf "standing %s %s\n", p[1], $2
}' "$PAGE" > "$WORK"/ladder_standing.txt 2>/dev/null || true
standing=$(grep -c '^standing ' "$WORK"/ladder_standing.txt 2>/dev/null || true)
echo "standing_ranked=$standing"

# READING 3 -- the errata and their recommendations.
awk '
function ordinal(w) {
  if (w ~ /first/)    return 1;  if (w ~ /second/)  return 2;
  if (w ~ /third/)    return 3;  if (w ~ /fourth/)  return 4;
  if (w ~ /fifth/)    return 5;  if (w ~ /sixth/)   return 6;
  if (w ~ /seventh/)  return 7;  if (w ~ /eighth/)  return 8;
  if (w ~ /ninth/)    return 9;  if (w ~ /tenth/)   return 10;
  if (w ~ /eleventh/) return 11; if (w ~ /twelfth/) return 12;
  return 0
}
/^\*\*Row [0-9]+ (second |third )?erratum:\*\*/ {
  line = $0
  match(line, /Row [0-9]+/); row = substr(line, RSTART + 4, RLENGTH - 4) + 0
  stamp = ""
  if (match(line, /`[0-9]{8}\.[0-9]{6}`/))
    stamp = substr(line, RSTART + 1, RLENGTH - 2)
  # The recommendation sentence: from "Recommended" to the sentence end.
  kind = "none"; target = 0; rec = ""
  if (match(line, /Recommend(ed|s)[^.]*\./)) {
    rec = substr(line, RSTART, RLENGTH)
    low = tolower(rec)
    # A named position, read BEFORE the disposition word, because a sentence may carry both
    # and the position is the stronger statement: "re-aim rather than re-rank, and a rank of
    # fourth" asks for a seat as plainly as "re-rank: last of the twelve" does.
    if (low ~ /(^| )last[ ,.]/) target = -1
    else if (match(low, /rank of [a-z]+/))
      target = ordinal(substr(low, RSTART + 8, RLENGTH - 8))
    # A breach supersedes the row, so it speaks over any seat the same sentence names.
    if (low ~ /breach/) { kind = "breach"; target = 0 }
    else if (target != 0) kind = "rank"
    else if (low ~ /re-aim/) kind = "aim"
    else if (low ~ /re-rank/) kind = "rank"
    else kind = "other"
  }
  gsub(/\n/, " ", rec)
  printf "erratum %d %s %s %d\n", row, (stamp == "" ? "nostamp" : stamp), kind, target
}
' "$PAGE" > "$WORK"/ladder_errata.txt

errata=$(grep -c '^erratum ' "$WORK"/ladder_errata.txt || true)
echo "errata_clauses=$errata"
nostamp=$(awk '$3 == "nostamp"' "$WORK"/ladder_errata.txt | wc -l | tr -d ' ')
echo "errata_unstamped=$nostamp"

# The latest erratum per row is the one that speaks.
sort -k2,2n -k3,3 "$WORK"/ladder_errata.txt | awk '
  { if ($2 > 0) last[$2] = $0 }
  END { for (r in last) print last[r] }
' | sort -k2,2n > "$WORK"/ladder_latest.txt
rows_with_erratum=$(wc -l < "$WORK"/ladder_latest.txt | tr -d ' ')
echo "rows_with_erratum=$rows_with_erratum"

for k in rank aim breach none other; do
  n=$(awk -v k="$k" '$4 == k' "$WORK"/ladder_latest.txt | wc -l | tr -d ' ')
  echo "recommend_$k=$n"
done
recommends=$(awk '$4 != "none"' "$WORK"/ladder_latest.txt | wc -l | tr -d ' ')
echo "rows_recommending=$recommends"

# THE DERIVATION. Target position per row: a recommendation's named seat where one stands,
# the standing table's seat otherwise.
awk -v rows="$rows" '
  FILENAME ~ /standing/ { stand[$2 + 0] = $3 + 0; next }
  { latest[$2 + 0] = $5 + 0; kind[$2 + 0] = $4 }
  END {
    determined = 0; inherited = 0
    for (r = 1; r <= rows; r++) {
      t = 0; src = "standing"
      if (r in latest && latest[r] != 0) {
        t = latest[r]; if (t == -1) t = rows
        src = "recommended"; determined++
      } else if (r in stand) {
        t = stand[r]; inherited++
      }
      if (t > 0) { seat[t] = seat[t] " " r; count[t]++ }
      printf "target row=%d seat=%d source=%s kind=%s\n", r, t, src, (r in kind ? kind[r] : "-")
    }
    collisions = 0; empty = 0
    for (s = 1; s <= rows; s++) {
      if (count[s] > 1) { collisions++; printf "collision seat=%d rows=%s\n", s, seat[s] }
      if (!(s in count)) empty++
    }
    printf "positions_recommended=%d\n", determined
    printf "positions_inherited=%d\n", inherited
    printf "collisions=%d\n", collisions
    printf "seats_empty=%d\n", empty
  }
' "$WORK"/ladder_standing.txt "$WORK"/ladder_latest.txt > "$WORK"/ladder_targets.txt

grep '^target ' "$WORK"/ladder_targets.txt
grep '^collision ' "$WORK"/ladder_targets.txt || true
grep -E '^(positions_|collisions=|seats_empty=)' "$WORK"/ladder_targets.txt

# READING 4 -- THE CLASSES. A permutation is one way to state an order and a PARTITION is
# another, weaker and available: each row falls into exactly one disposition class, read from
# its latest erratum. This reading exists because the two collisions above are not accidents of
# wording -- both come from an erratum speaking in a CLASS ("last") where the table speaks in a
# POSITION, and a class cannot be transcribed into a table without inventing a tiebreak nobody
# measured. The classes are disjoint by construction and their sum is gated against the roster.
awk -v rows="$rows" '
  { kind[$2 + 0] = $4; target[$2 + 0] = $5 + 0 }
  END {
    for (r = 1; r <= rows; r++) {
      if (!(r in kind))                       c = "unread"
      else if (kind[r] == "breach")           c = "superseded"
      else if (kind[r] == "rank" && target[r] == -1) c = "demoted"
      else if (kind[r] == "rank")             c = "seated"
      else if (kind[r] == "aim")              c = "reaimed"
      else                                    c = "reported"
      printf "class row=%d class=%s\n", r, c
      n[c]++
    }
    total = 0
    split("unread reported reaimed seated demoted superseded", order, " ")
    for (i = 1; i <= 6; i++) { k = order[i]; printf "class_%s=%d\n", k, n[k] + 0; total += n[k] + 0 }
    printf "class_total=%d\n", total
  }
' "$WORK"/ladder_latest.txt > "$WORK"/ladder_classes.txt

grep '^class ' "$WORK"/ladder_classes.txt
grep '^class_' "$WORK"/ladder_classes.txt
class_total=$(awk -F= '/^class_total=/ {print $2}' "$WORK"/ladder_classes.txt)
if [ "$class_total" -eq "$rows" ]; then
  echo "classes_partition=yes"
else
  echo "classes_partition=no"
fi

collisions=$(awk -F= '/^collisions=/ {print $2}' "$WORK"/ladder_targets.txt)
recommended=$(awk -F= '/^positions_recommended=/ {print $2}' "$WORK"/ladder_targets.txt)

# The gates. A permutation admits no collision and leaves no seat empty.
if [ "$collisions" -eq 0 ] && [ "$recommended" -eq "$rows" ]; then
  echo "permutation=yes"
else
  echo "permutation=no"
fi

# A parse failure: an erratum clause the page carries that this reader did not read.
page_clauses=$(grep -cE '^\*\*Row [0-9]+ (second |third )?erratum:\*\*' "$PAGE")
echo "page_clauses=$page_clauses"
if [ "$page_clauses" -eq "$errata" ] && [ "$nostamp" -eq 0 ]; then
  parse_failures=0
else
  parse_failures=$(( page_clauses - errata + nostamp ))
fi
echo "parse_failures=$parse_failures"

if [ "$MODE" = "--explain" ]; then
  echo "--- latest erratum per row ---"
  cat "$WORK"/ladder_latest.txt
fi

if [ "$parse_failures" -ne 0 ]; then
  echo "verdict=unparsed"
elif [ "$class_total" -ne "$rows" ]; then
  echo "verdict=no_partition"
elif [ "$collisions" -gt 0 ]; then
  echo "verdict=partition_only"
else
  echo "verdict=order"
fi
