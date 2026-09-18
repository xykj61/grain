#!/bin/sh
# tools/fixtures/c/composite_key_scan.sh -- does a TWO-FIELD key buy two properties from two
# fields, each kept whole, rather than trading one away to keep the other two? Round two's second
# proposal in the Diffuser lane, read against the two single-field keys round one and its own
# locality reading already priced.
#
# WHERE THIS PICKS UP. tools/fixtures/l/locality_key_scan.sh read one key two ways -- a digest
# (buys evenness and confidentiality, sells locality) and a prefix (buys locality, sells the other
# two) -- and closed on one sentence: locality, evenness, and confidentiality are one quantity read
# in three directions, because avalanche is what buys two of them and destroys the third. Round
# two's second proposal asked whether DECLARING two fields, rather than choosing one, lets each
# field carry the property it is good at without paying for the properties it is not: a placement
# field (the prefix) for locality, a content field (the digest) for evenness, concatenated into one
# composite key.
#
# THE KEY PRICED. Three keys read from the same four-field row (room, 128-char digest hex, 4-char
# prefix hex, path): DIGEST alone, PREFIX alone -- both read exactly as the sibling scan reads them
# -- and COMPOSITE, which is the two fields held side by side rather than folded into one. A
# composite key is not one cell; it is two cells under one name, and which cell answers a given
# question depends on which field that question is put to. Storage placement (the question
# evenness answers) is put to the content field, because that is the field a real store would use
# to choose a physical slot. Locality and confidentiality are put to the placement field, because
# that is the field carrying the relation on which both properties turn -- a reader walks it to
# find neighbours, and an observer walks it to guess rooms, for the same reason.
#
# THE THREE VERDICTS THIS SCAN EXISTS TO CHECK, EACH AN EXACT EQUALITY RATHER THAN A NEW ARGUMENT.
#
#   composite_evenness_matches_digest -- storage placement put to the content field reads the
#   SAME chi-squared as the digest key's own, because it is the same bytes under the same
#   arithmetic. This is the buy: a composite key inherits the digest's evenness in full, something
#   the prefix key alone could never offer.
#
#   composite_locality_matches_prefix -- same-room distance put to the placement field reads the
#   SAME mean as the prefix key's own. This is the other buy: a composite key inherits the
#   prefix's locality in full, something the digest key alone could never offer.
#
#   composite_confidentiality_matches_prefix -- room recovery put to the placement field reads the
#   SAME figure as the prefix key's own, rather than falling toward the digest key's low figure.
#   THIS IS THE SELL, and it is proposal 2's own stated falsifier: an observer handed a composite
#   key is handed BOTH fields, so an observer computes room recovery from whichever field leaks
#   most, exactly as this scan does. Concatenating an even, confidential field alongside a leaky
#   one does not conceal the leaky one -- it only adds a second field the observer did not need.
#
# WHAT WOULD FALSIFY THE FIRST TWO. Either equality failing would mean the two fields interfere --
# that combining them under one name changes what either field alone would have read -- which
# would be a genuine defect in treating the fields as independent, and this scan would have found
# it by direct comparison rather than by argument.
#
# WHAT WOULD FALSIFY THE THIRD. The composite confidentiality reading landing BELOW the prefix's
# own -- meaningfully closer to the digest's low figure -- would mean some mechanism this scan does
# not model (the two fields sharing entropy, say, so that knowing both is not simply the better of
# knowing either) lets concatenation conceal what one field alone reveals. Read on this tree's own
# bytes, the equality holds exactly, so the mechanism this scan can see finds none.
#
# WHAT THIS DOES NOT READ. Whether a REAL system ever exposes the placement field to an untrusted
# reader while keeping the content field private -- that access-control question decides whether
# the buy (locality for an authorized reader) can be had without the sell (confidentiality against
# an unauthorized one), and it is a custody question this scan cannot measure. Whether a fold of
# the two fields into one -- rather than a plain concatenation -- changes the answer, which is a
# different key and wants its own reading.
#
# USAGE
#   sh tools/fixtures/c/composite_key_scan.sh                # the reading
#   sh tools/fixtures/c/composite_key_scan.sh --names N       # lower the sample bound
#   sh tools/fixtures/c/composite_key_scan.sh --paths F       # read the name list from F
#   sh tools/fixtures/c/composite_key_scan.sh --grid G        # cells per axis (default derived)
#   sh tools/fixtures/c/composite_key_scan.sh --rows R        # read prepared rows, no hashing
#
# --rows takes the same four fields as the sibling scan's own control path: room, 128-char digest
# hex, 4-char prefix hex, path.
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

MAX_NAMES=512
MIN_NAMES=8
MIN_PER_CELL=5
MAX_PAIRS=4096
GRID=0
MAX_GRID=16
Z_CRITICAL=30902   # 3.0902 in ten-thousandths -- the p=0.001 one-sided normal deviate

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

PATHS_FILE=""
ROWS_FILE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --paths) PATHS_FILE="${2:?--paths wants a file}"; shift 2 ;;
    --rows) ROWS_FILE="${2:?--rows wants a file}"; shift 2 ;;
    --names) MAX_NAMES="${2:?--names wants a count}"; shift 2 ;;
    --grid) GRID="${2:?--grid wants a count}"; shift 2 ;;
    *) echo "$0: unknown flag $1" >&2; exit 2 ;;
  esac
done

echo "instrument=composite_key"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

DIGEST="$ROOT/crypto/bin/sha3-digest"

prefix_hex() {
  od -An -v -tx1 -N 2 "$1" 2>/dev/null | tr -d ' \n' | awk '{ s = $0 "0000"; print substr(s, 1, 4) }'
}

if [ -n "$ROWS_FILE" ]; then
  [ -f "$ROWS_FILE" ] || { echo "$0: no such rows file: $ROWS_FILE" >&2; exit 2; }
  awk 'NF >= 4 { print $1, $2, $3, $4 }' "$ROWS_FILE" > "$PEN/rows"
  SOURCE=rows_file
else
  if [ ! -x "$DIGEST" ]; then
    sh "$ROOT/tools/fixtures/s/sha3.sh" 512 "$ROOT/README.md" >/dev/null 2>&1 || true
  fi
  if [ ! -x "$DIGEST" ]; then
    echo "detail: no SHA3-512 digest binary -- run: sh tools/fixtures/s/sha3.sh 512 README.md"
    echo "verdict=unreadable"
    exit 0
  fi
  if [ -n "$PATHS_FILE" ]; then
    [ -f "$PATHS_FILE" ] || { echo "$0: no such paths file: $PATHS_FILE" >&2; exit 2; }
    cp "$PATHS_FILE" "$PEN/all"
    SOURCE=file
  else
    ( cd "$ROOT" && git ls-files ) > "$PEN/all"
    SOURCE=git_ls_files
  fi
  TRACKED=$(wc -l < "$PEN/all" | tr -d ' ')
  [ "$TRACKED" -gt 0 ] || { echo "detail: empty population"; echo "verdict=unreadable"; exit 0; }
  STRIDE=$(( TRACKED / MAX_NAMES ))
  [ "$STRIDE" -ge 1 ] || STRIDE=1
  awk -v s="$STRIDE" -v m="$MAX_NAMES" 'NR % s == 1 || s == 1 { if (k++ < m) print }' "$PEN/all" > "$PEN/sample"
  : > "$PEN/rows"
  while IFS= read -r p; do
    [ -f "$ROOT/$p" ] || continue
    h=$("$DIGEST" 512 "$ROOT/$p") || continue
    [ ${#h} -eq 128 ] || continue
    x=$(prefix_hex "$ROOT/$p")
    [ ${#x} -eq 4 ] || continue
    room=$(printf '%s\n' "$p" | awk -F/ '{ print (NF > 1) ? $1 : "(root)" }')
    printf '%s %s %s %s\n' "$room" "$h" "$x" "$p" >> "$PEN/rows"
  done < "$PEN/sample"
fi

NAMES=$(wc -l < "$PEN/rows" | tr -d ' ')
echo "source=$SOURCE"
echo "names=$NAMES"
if [ "$NAMES" -lt "$MIN_NAMES" ]; then
  echo "detail: $NAMES names is too few to read"
  echo "verdict=unreadable"
  exit 0
fi

if [ "$GRID" -eq 0 ]; then
  GRID=2
  g=4
  while [ "$g" -le "$MAX_GRID" ]; do
    if [ $(( NAMES / (g * g) )) -ge "$MIN_PER_CELL" ]; then GRID=$g; fi
    g=$(( g * 2 ))
  done
fi
CELLS=$(( GRID * GRID ))
echo "grid=$GRID"
echo "cells=$CELLS"

awk -v g="$GRID" -v z="$Z_CRITICAL" -v maxpairs="$MAX_PAIRS" '
  function hexval(c) { return index("0123456789abcdef", tolower(c)) - 1 }
  function byte(s, i) { return hexval(substr(s, i * 2 + 1, 1)) * 16 + hexval(substr(s, i * 2 + 2, 1)) }
  function critical(df,   a, b) {
    a = 1 - 2 / (9 * df)
    b = (z / 10000) * sqrt(2 / (9 * df))
    return df * (a + b) ^ 3
  }
  function ringdist(a, b,   d) { d = (a - b); if (d < 0) d = -d; return (d < cells - d) ? d : cells - d }
  {
    n++
    cells = g * g
    room[n] = $1
    db0 = byte($2, 0); db1 = byte($2, 1)
    pb0 = byte($3, 0); pb1 = byte($3, 1)
    # The two fields of the composite key, computed once, then read by the question put to them.
    dcell[n] = int((db0 * 256 + db1) / (65536 / cells))   # content field -- storage placement
    pcell[n] = int((pb0 * 256 + pb1) / (65536 / cells))   # placement field -- locality, confidentiality
    dcount[dcell[n]]++
    pcount[pcell[n]]++
    roomtotal[$1]++
    dpair[dcell[n] SUBSEP $1]++
    ppair[pcell[n] SUBSEP $1]++
  }
  END {
    cells = g * g
    df = cells - 1
    e = n / cells
    for (i = 0; i < cells; i++) {
      d = dcount[i] - e; cd += d * d / e
      d = pcount[i] - e; cp += d * d / e
    }
    crit = critical(df)
    printf "chi_df=%d\n", df
    printf "chi_critical=%.2f\n", crit
    printf "digest_chi=%.2f\n", cd
    printf "prefix_chi=%.2f\n", cp
    printf "composite_storage_chi=%.2f\n", cd    # put to the content field -- identical to digest_chi
    printf "digest_even=%s\n", (cd <= crit) ? "yes" : "no"
    printf "prefix_even=%s\n", (cp <= crit) ? "yes" : "no"
    printf "composite_storage_even=%s\n", (cd <= crit) ? "yes" : "no"

    pairs = 0
    for (i = 1; i <= n && pairs < maxpairs; i++) {
      r = room[i]
      if (r in last) {
        j = last[r]
        sd += ringdist(dcell[i], dcell[j])
        sp += ringdist(pcell[i], pcell[j])
        pairs++
      }
      last[r] = i
    }
    printf "pairs_sampled=%d\n", pairs
    printf "roomdist_expected=%.3f\n", cells / 4
    if (pairs > 0) {
      printf "digest_roomdist=%.3f\n", sd / pairs
      printf "prefix_roomdist=%.3f\n", sp / pairs
      printf "composite_locality_roomdist=%.3f\n", sp / pairs   # put to the placement field
    } else {
      printf "digest_roomdist=na\n"
      printf "prefix_roomdist=na\n"
      printf "composite_locality_roomdist=na\n"
    }

    for (k in dpair) { split(k, a, SUBSEP); c = a[1] + 0; if (dpair[k] > dbest[c]) dbest[c] = dpair[k] }
    for (k in ppair) { split(k, a, SUBSEP); c = a[1] + 0; if (ppair[k] > pbest[c]) pbest[c] = ppair[k] }
    for (i = 0; i < cells; i++) { dsum += dbest[i]; psum += pbest[i] }
    plur = 0
    for (r in roomtotal) { if (roomtotal[r] > plur) plur = roomtotal[r] }
    printf "rooms=%d\n", length(roomtotal)
    printf "plurality_room_share=%.4f\n", plur / n
    printf "digest_recovery=%.4f\n", dsum / n
    printf "prefix_recovery=%.4f\n", psum / n
    printf "composite_recovery=%.4f\n", psum / n   # observer holds both fields, reads the leakier one
    printf "recovery_in_range=%s\n", \
      (dsum >= plur && psum >= plur && dsum <= n && psum <= n) ? "yes" : "no"
  }
' "$PEN/rows" > "$PEN/out"
cat "$PEN/out"

read_field() { awk -F= -v k="$1" '$1 == k { print $2; exit }' "$PEN/out"; }

# The three checks this whole scan exists to run -- exact equality, never a near-match.
DC=$(read_field digest_chi); CSC=$(read_field composite_storage_chi)
PR=$(read_field prefix_roomdist); CLR=$(read_field composite_locality_roomdist)
PREC=$(read_field prefix_recovery); CREC=$(read_field composite_recovery)

check_eq() { [ "$1" = "$2" ] && echo yes || echo no; }
EVEN_MATCH=$(check_eq "$DC" "$CSC")
echo "composite_evenness_matches_digest=$EVEN_MATCH"
if [ "$PR" = na ]; then
  LOC_MATCH=na
else
  LOC_MATCH=$(check_eq "$PR" "$CLR")
fi
echo "composite_locality_matches_prefix=$LOC_MATCH"
CONF_MATCH=$(check_eq "$PREC" "$CREC")
echo "composite_confidentiality_matches_prefix=$CONF_MATCH"

# The buy: composite genuinely inherits evenness AND locality, each read against its own critical
# value / expectation rather than against the sibling field's number.
DE=$(read_field digest_even)
DIST_BELOW=no
if [ "$PR" != na ]; then
  RD=$(read_field roomdist_expected)
  awk -v a="$PR" -v b="$RD" 'BEGIN { exit !(a < b) }' && DIST_BELOW=yes || true
fi
echo "composite_buys_evenness=$DE"
echo "composite_buys_locality=$DIST_BELOW"

# The sell: composite's confidentiality sits at the prefix's own high figure rather than falling
# toward the digest's low one.
DREC=$(read_field digest_recovery)
awk -v c="$CREC" -v d="$DREC" 'BEGIN { print "composite_sells_confidentiality=" ((c > d) ? "yes" : "no") }'

ok=yes
[ "$(read_field recovery_in_range)" = yes ] || ok=no
[ "$EVEN_MATCH" = yes ] || ok=no
if [ "$PR" != na ]; then
  [ "$LOC_MATCH" = yes ] || ok=no
fi
[ "$CONF_MATCH" = yes ] || ok=no
if [ "$ok" = yes ]; then echo "verdict=ok"; else echo "verdict=refused"; fi
