#!/bin/sh
# tools/fixtures/l/locality_key_scan.sh -- what does a key that carries LOCALITY on purpose buy,
# and what does it sell? The one door left open by both torus readings in the Diffuser lane.
#
# WHERE THIS PICKS UP. tools/fixtures/t/torus_fold_scan.sh killed row 5's adjacency half and
# tools/fixtures/t/torus_place_scan.sh killed its placement remainder, and BOTH died on one
# property rather than on two: SHA3-512 avalanches, so its digest carries no relation between
# neighbouring inputs. Each scan's own close names the same remaining door in the same words --
# a key built to carry locality on purpose, which no row in that page proposed. This reads it.
#
# THE KEY BEING PRICED. The simplest locality-bearing key there is: the file's own leading bytes,
# read as a number. Two files that begin alike get keys that sit alike, by construction and with
# no hashing at all. It is deliberately the crudest member of its family -- a prefix key, beside
# the similarity-preserving sketches a real design would reach for -- because the trade this scan
# measures is a property of the FAMILY, and the crudest member shows it at full size with no
# parameter a reader has to take on trust.
#
# THE READINGS, AND WHAT EACH ONE IS FOR.
#
#   READING 1 -- WHAT THE KEY BUYS, read at its extreme rather than on an average. A file is
#   copied, ONE byte is flipped well past the prefix, and both keys are recomputed. The digest key
#   moves for every probe; the prefix key moves for none. This is the locality property stated as
#   arithmetic rather than as a correlation, so it is gated rather than reported: a digest that
#   survived an edit would be a collision, and a prefix that moved would mean the edit landed in
#   the prefix.
#
#   READING 2 -- WHAT THE KEY BUYS, read across the population. Mean cyclic cell distance between
#   two files from the SAME top-level room, against the uniform expectation C/4 that two
#   independent uniform keys give on C cells. The digest should sit at the expectation; a key
#   carrying locality should sit below it.
#
#   READING 3 -- WHAT THE KEY SELLS, first half: EVENNESS. Pearson chi-squared on cell occupancy
#   for each key against the same p=0.001 critical value the sibling scans use. Evenness is the
#   one property both torus readings found the digest hands over for free, and a locality key is
#   expected to give it back. The size of the giving-back is the finding.
#
#   READING 4 -- WHAT THE KEY SELLS, second half: CONFIDENTIALITY. This is the reading the other
#   three exist to frame, and the argument is one sentence: a key that preserves a relation on its
#   inputs hands that same relation to anyone holding only keys. Measured concretely as ROOM
#   RECOVERY -- for each cell, the largest single room among the files in it, summed over cells
#   and divided by the population. That is the share of files an observer holding keys alone would
#   place in the right room by guessing each cell's plurality. Its honest baseline is the same
#   guess made with NO key at all, the plurality room share over the whole population, which is
#   printed beside it. A key that lets a reader find neighbours lets an observer group documents;
#   locality and confidentiality are one quantity read in two directions.
#
# WHAT WOULD FALSIFY THE READING. A prefix key reading EVEN -- chi-squared under the critical
# value -- would mean locality costs no evenness on this population, and the trade named here is
# not a trade. A prefix key whose same-room distance sits at the uniform expectation would mean
# the key carries no locality on real bytes despite carrying it by construction, which would say
# this tree's files do not begin alike. A room recovery for the prefix key at or under the
# no-key plurality baseline would mean the leak is not measurable at this grid.
#
# WHAT THIS DOES NOT READ. Any real store, wire, or index -- this scan opens none. Whether a
# similarity-preserving sketch lands somewhere better on the same trade, which is a different key
# and wants its own reading. Whether the leak matters for a given corpus: room membership in a
# public tree is public, and the reading is a lower bound on what the key would give away over a
# corpus where it is not. Whether any locality key is SAFE, which is a custody question and not a
# measurement.
#
# USAGE
#   sh tools/fixtures/l/locality_key_scan.sh                # the reading
#   sh tools/fixtures/l/locality_key_scan.sh --grid G       # cells per axis (default derived)
#   sh tools/fixtures/l/locality_key_scan.sh --names N      # lower the sample bound
#   sh tools/fixtures/l/locality_key_scan.sh --paths F      # read the name list from F
#   sh tools/fixtures/l/locality_key_scan.sh --rows R       # read prepared rows, no hashing
#
# THE ROWS DOOR IS THE CONTROL PATH, as --digests is for the sibling scans: a population with a
# known answer has to be planted, and the point is to prove the READING. --rows takes one record
# per line, four fields: room, 128-char digest hex, 4-char prefix hex, path.
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

MAX_NAMES=512      # bounded: each name costs one SHA3-512 over a whole file
MIN_NAMES=8        # below this no reading is taken at all
MIN_PER_CELL=5     # Pearson wants about this many expected per cell
MAX_PAIRS=4096     # bounded: same-room pairs read for the distance mean
MAX_PROBES=8       # bounded: deep-edit probes, each costing a copy and a digest
EDIT_OFFSET=32     # well past the 2-byte prefix, so a moved prefix key means a placement error
MIN_PROBE_BYTES=64 # a probe file must be longer than the offset it is edited at
GRID=0             # 0 means derive from the sample size
MAX_GRID=16        # bounded: the largest grid this scan will choose for itself
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

echo "instrument=locality_key"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

DIGEST="$ROOT/crypto/bin/sha3-digest"

prefix_hex() {
  # The first two content bytes as four lowercase hex characters. A file shorter than two bytes
  # is padded with zeros, so a short file keeps a well-defined key rather than dropping out.
  od -An -v -tx1 -N 2 "$1" 2>/dev/null | tr -d ' \n' | awk '{ s = $0 "0000"; print substr(s, 1, 4) }'
}

if [ -n "$ROWS_FILE" ]; then
  [ -f "$ROWS_FILE" ] || { echo "$0: no such rows file: $ROWS_FILE" >&2; exit 2; }
  awk 'NF >= 4 { print $1, $2, $3, $4 }' "$ROWS_FILE" > "$PEN/rows"
  SOURCE=rows_file
else
  if [ ! -x "$DIGEST" ]; then
    # The shim builds it from crypto/sha3_digest.rye on first call; one file owns that build.
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

# The grid is chosen from the sample size rather than fixed, so Pearson's approximation holds:
# the largest power-of-two g at or under MAX_GRID keeping names/(g*g) at or above MIN_PER_CELL.
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

# READING 1 -- the deep-edit probes. Each probe copies a real file, flips one byte at EDIT_OFFSET,
# and asks each key whether it noticed. Run only when this scan did its own hashing; the rows door
# carries no files to edit, and its probe counts are reported as zero rather than faked.
PROBES=0
SURV_PREFIX=0
SURV_DIGEST=0
if [ "$SOURCE" != rows_file ]; then
  while IFS=' ' read -r room h x p; do
    [ "$PROBES" -lt "$MAX_PROBES" ] || break
    src="$ROOT/$p"
    [ -f "$src" ] || continue
    sz=$(wc -c < "$src" | tr -d ' ')
    [ "$sz" -ge "$MIN_PROBE_BYTES" ] || continue
    cp "$src" "$PEN/probe" 2>/dev/null || continue
    # Flip the byte at EDIT_OFFSET by rewriting the file with that one position changed.
    od -An -v -tu1 "$PEN/probe" | tr -s ' ' '\n' | awk 'NF' > "$PEN/probe.bytes" || continue
    awk -v off="$EDIT_OFFSET" 'NR == off + 1 { $1 = ($1 == 0) ? 1 : $1 - 1 } { print }' \
      "$PEN/probe.bytes" > "$PEN/probe.edited"
    awk '{ printf "%c", $1 }' "$PEN/probe.edited" > "$PEN/probe2" 2>/dev/null || continue
    [ -s "$PEN/probe2" ] || continue
    h2=$("$DIGEST" 512 "$PEN/probe2") || continue
    x2=$(prefix_hex "$PEN/probe2")
    PROBES=$(( PROBES + 1 ))
    [ "$x2" = "$x" ] && SURV_PREFIX=$(( SURV_PREFIX + 1 ))
    [ "$h2" = "$h" ] && SURV_DIGEST=$(( SURV_DIGEST + 1 ))
  done < "$PEN/rows"
fi
echo "edit_offset=$EDIT_OFFSET"
echo "edit_probes=$PROBES"
echo "edit_survive_prefix=$SURV_PREFIX"
echo "edit_survive_digest=$SURV_DIGEST"

awk -v g="$GRID" -v z="$Z_CRITICAL" -v maxpairs="$MAX_PAIRS" '
  function hexval(c) { return index("0123456789abcdef", tolower(c)) - 1 }
  function byte(s, i) { return hexval(substr(s, i * 2 + 1, 1)) * 16 + hexval(substr(s, i * 2 + 2, 1)) }
  # Wilson-Hilferty: the p=0.001 upper critical value of chi-squared at df degrees of freedom,
  # derived rather than read from a table, since the grid is chosen from the sample.
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
    # Both keys are read the same way -- the leading two bytes taken as one index into C cells --
    # so the only difference between the two readings is WHICH bytes, which is the whole point.
    db0 = byte($2, 0); db1 = byte($2, 1)
    pb0 = byte($3, 0); pb1 = byte($3, 1)
    dcell[n] = int((db0 * 256 + db1) / (65536 / cells))
    pcell[n] = int((pb0 * 256 + pb1) / (65536 / cells))
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
    printf "chi_digest=%.2f\n", cd
    printf "chi_prefix=%.2f\n", cp
    printf "digest_even=%s\n", (cd <= crit) ? "yes" : "no"
    printf "prefix_even=%s\n", (cp <= crit) ? "yes" : "no"

    # READING 2 -- same-room cyclic cell distance, bounded. Pairs are taken by walking the
    # population once and pairing each name with the previous name of its own room, so the pair
    # count is bounded by n and no room can dominate by being read twice.
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
      printf "roomdist_digest=%.3f\n", sd / pairs
      printf "roomdist_prefix=%.3f\n", sp / pairs
    } else {
      printf "roomdist_digest=na\n"
      printf "roomdist_prefix=na\n"
    }

    # READING 4 -- room recovery. For each cell, the largest single room inside it; summed and
    # divided by n, that is the share an observer holding keys alone places correctly by guessing
    # each cell plurality. The no-key baseline below is the same guess made without any key.
    for (k in dpair) { split(k, a, SUBSEP); c = a[1] + 0; if (dpair[k] > dbest[c]) dbest[c] = dpair[k] }
    for (k in ppair) { split(k, a, SUBSEP); c = a[1] + 0; if (ppair[k] > pbest[c]) pbest[c] = ppair[k] }
    for (i = 0; i < cells; i++) { dsum += dbest[i]; psum += pbest[i] }
    plur = 0
    for (r in roomtotal) { if (roomtotal[r] > plur) plur = roomtotal[r] }
    printf "rooms=%d\n", length(roomtotal)
    printf "plurality_room_share=%.4f\n", plur / n
    printf "room_recovery_digest=%.4f\n", dsum / n
    printf "room_recovery_prefix=%.4f\n", psum / n
    printf "recovery_in_range=%s\n", \
      (dsum >= plur && psum >= plur && dsum <= n && psum <= n) ? "yes" : "no"
  }
' "$PEN/rows" > "$PEN/out"
cat "$PEN/out"

read_field() { awk -F= -v k="$1" '$1 == k { print $2; exit }' "$PEN/out"; }

# The three trade verdicts, each stated against its own honest baseline.
chi_crit=$(read_field chi_critical)
chi_pre=$(read_field chi_prefix)
rd=$(read_field roomdist_digest)
rp=$(read_field roomdist_prefix)
rec_d=$(read_field room_recovery_digest)
rec_p=$(read_field room_recovery_prefix)

if [ "$PROBES" -gt 0 ] && [ "$SURV_PREFIX" -eq "$PROBES" ] && [ "$SURV_DIGEST" -eq 0 ]; then
  echo "locality_bought=yes"
elif [ "$PROBES" -eq 0 ]; then
  echo "locality_bought=unread"
else
  echo "locality_bought=no"
fi
awk -v a="$rp" -v b="$rd" 'BEGIN { print "roomdist_closer=" ((a != "na" && b != "na" && a < b) ? "yes" : "no") }'
awk -v a="$chi_pre" -v c="$chi_crit" 'BEGIN { print "evenness_sold=" ((a > c) ? "yes" : "no") }'
awk -v a="$rec_p" -v b="$rec_d" 'BEGIN { print "confidentiality_sold=" ((a > b) ? "yes" : "no") }'

# GATED: the exact arithmetic only. The chi-squared readings and the two population means above
# are REPORTED rather than gated, because a p=0.001 test taken twice refuses about one run in five
# hundred on a key behaving correctly, and a mean over a strided sample moves with the tree.
ok=yes
[ "$(read_field recovery_in_range)" = yes ] || ok=no
if [ "$PROBES" -gt 0 ]; then
  [ "$SURV_DIGEST" -eq 0 ] || ok=no
  [ "$SURV_PREFIX" -eq "$PROBES" ] || ok=no
fi
if [ "$ok" = yes ]; then echo "verdict=ok"; else echo "verdict=refused"; fi
