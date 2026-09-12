#!/bin/sh
# tools/fixtures/t/torus_fold_scan.sh -- does folding Tablecloth's resins onto a 2-torus buy
# adjacency? Row 5 of active-designing/20260910-060204_the-bounded-torus-moonshots.md.
#
# WHAT ROW 5 CLAIMS. "The hash space folds onto a 2-torus, so names that sit near each other in
# the fold sit near each other in storage." Its stated falsifier: "the fold clusters real names
# into a few cells."
#
# WHAT THIS READS. Both halves, on the tree's own bytes rather than on a synthetic population.
# Tablecloth names a thing by SHA3-512 over its bytes (foundations/20260823-222020_what-tablecloth-is.md),
# so the names a store on this pier would carry are the digests of the files this pier tracks.
# The fold takes two bytes of the digest as coordinates on a 256 x 256 torus.
#
#   READING 1 -- EVENNESS, the stated falsifier. Pearson chi-squared of the sample over a coarse
#   g x g grid taken from the high bits of each coordinate. A chi-squared statistic has mean equal
#   to its degrees of freedom, so a reading near df is the even case and a large one is clustered.
#   THE GRID IS CHOSEN FROM THE SAMPLE SIZE rather than fixed: Pearson's approximation needs an
#   expected count of about five per cell, and a fixed 16 x 16 grid over 512 names expects two --
#   which is how a first draft of this scan read 316 against a critical 330 and called it even on
#   arithmetic that did not hold. The largest g in {2, 4, 8, 16} keeping n/(g*g) at or above 5 is
#   taken, and the p=0.001 critical value is DERIVED for the resulting df by Wilson-Hilferty,
#   df * (1 - 2/(9 df) + z sqrt(2/(9 df)))^3 with z = 3.0902, rather than read from a table that
#   would need a row per grid.
#
#   READING 2 -- ADJACENCY, the claim's own value. Toroidal Manhattan distance between the folded
#   coordinates of a pair of names, dx + dy with each axis wrapped: min(d, 256 - d). For two
#   independent uniform coordinates the per-axis mean is exactly 64 -- the circular difference is
#   uniform on 0..255, and (0+1+...+127) + 128 + (127+...+1) = 16384, over 256 -- so the expected
#   pair distance is exactly 128. Three populations are measured against that one constant:
#
#     random    -- disjoint pairs from the sample. The baseline.
#     samedir   -- disjoint pairs of files sharing a directory. The real relation a store would
#                  most want locality on. Drawn from its OWN population rather than from the
#                  strided sample, because the stride spreads the sample across the tree on
#                  purpose and so starves the very relation this reading exists to test: it left
#                  15 pairs from 128 names, too few to say anything. This population instead takes
#                  directories holding at least four tracked files and up to eight files from
#                  each.
#     onebit    -- a file and the same file with ONE byte substituted. The sharpest relation
#                  there is: two nearly identical documents, both of which a growing store holds.
#
#   A population whose mean sits within three standard errors of 128 is indistinguishable from
#   randomly placed. Pairs are DISJOINT rather than all-pairs, so each contributes one independent
#   observation and the standard error is honest; an all-pairs mean over n points reuses every
#   point n-1 times and its naive error bar is far too tight.
#
#   READING 3 -- FOLD INDEPENDENCE. Every reading above is taken twice, once from digest bytes 0
#   and 1 and once from bytes 30 and 31, because a finding that held for one arbitrary pair of
#   bytes and not another would be a fact about the choice rather than about the fold.
#
# WHY BOTH HALVES IN ONE INSTRUMENT. They share a cause. A cryptographic hash is built to
# avalanche -- one input bit changed redistributes the output -- and that single property is what
# makes the fold even AND what makes fold-adjacency carry no relation. Measuring one without the
# other reports half of a trade-off as though it were a result.
#
# WHAT THIS DOES NOT READ. Whether a torus is a good PLACEMENT scheme, which is a different claim
# and is not touched here; whether some fold of a NON-cryptographic name would carry relation;
# and anything about the real store, which this scan never opens.
#
# USAGE
#   sh tools/fixtures/t/torus_fold_scan.sh              # the reading
#   sh tools/fixtures/t/torus_fold_scan.sh --paths F    # read the name list from F instead of git
#                                                       # (the control's door; one path per line)
#   sh tools/fixtures/t/torus_fold_scan.sh --names N    # lower the sample bound
#   sh tools/fixtures/t/torus_fold_scan.sh --digests D --onebit-digests O
#                                                       # read NAMES directly, no hashing at all
#
# THE DIGEST DOOR IS THE CONTROL PATH, and it exists because the pen cannot supply the populations
# this scan must be proven against. A clustered population of REAL names would have to be mined --
# hashing until enough digests share a cell -- and that is work in the wrong direction: the point
# is to prove the READING, and a reading takes digests. So --digests takes lines of
# "<128 lowercase hex> <directory>" and --onebit-digests lines of "<hex> <hex>", which lets the
# control plant a clustered population, a related population that genuinely sits near, and an even
# one, and see the scan tell the three apart.
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

MAX_NAMES=512      # bounded: each name costs one SHA3-512 over a whole file, ~13ms on this pier
MAX_ONEBIT=96      # bounded: each pair costs two digests
MAX_SAMEDIR=256    # bounded: names drawn for the same-directory population
DIR_MIN=4          # a directory joins that population only with this many tracked files
DIR_TAKE=8         # and contributes at most this many, so one large room cannot carry the reading
MAX_PAIRS=4096     # bounded: no population may contribute more disjoint pairs than this
SIGMA=3            # a mean this many standard errors from 128 is called distinguishable
CHI_CRITICAL=3305  # p=0.001 upper critical value for 255 df, in tenths (330.5)

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
DIGESTS_FILE=""
ONEBIT_FILE=""
DIR_DIGESTS_FILE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --paths) PATHS_FILE="${2:?--paths wants a file}"; shift 2 ;;
    --names) MAX_NAMES="${2:?--names wants a count}"; shift 2 ;;
    --onebit) MAX_ONEBIT="${2:?--onebit wants a count}"; shift 2 ;;
    --samedir) MAX_SAMEDIR="${2:?--samedir wants a count}"; shift 2 ;;
    --digests) DIGESTS_FILE="${2:?--digests wants a file}"; shift 2 ;;
    --onebit-digests) ONEBIT_FILE="${2:?--onebit-digests wants a file}"; shift 2 ;;
    --dir-digests) DIR_DIGESTS_FILE="${2:?--dir-digests wants a file}"; shift 2 ;;
    *) echo "$0: unknown flag $1" >&2; exit 2 ;;
  esac
done

PEN_EARLY=""
if [ -n "$DIGESTS_FILE" ]; then
  [ -f "$DIGESTS_FILE" ] || { echo "$0: no such digests file: $DIGESTS_FILE" >&2; exit 2; }
  PEN=$(mktemp -d)
  trap 'rm -rf "$PEN"' EXIT INT TERM
  cp "$DIGESTS_FILE" "$PEN/names"
  if [ -n "$DIR_DIGESTS_FILE" ]; then cp "$DIR_DIGESTS_FILE" "$PEN/dirnames"; else cp "$DIGESTS_FILE" "$PEN/dirnames"; fi
  if [ -n "$ONEBIT_FILE" ]; then cp "$ONEBIT_FILE" "$PEN/onebit"; else : > "$PEN/onebit"; fi
  SOURCE=digests_file
  TRACKED=$(wc -l < "$PEN/names" | tr -d ' ')
  STRIDE=1
  NAMES="$TRACKED"
  DIRNAMES=$(wc -l < "$PEN/dirnames" | tr -d ' ')
  ob=$(wc -l < "$PEN/onebit" | tr -d ' ')
  PEN_EARLY=yes
fi

DIGEST="$ROOT/crypto/bin/sha3-digest"
if [ -z "$PEN_EARLY" ] && [ ! -x "$DIGEST" ]; then
  # The shim builds it from crypto/sha3_digest.rye on first call. Reached through the shim rather
  # than rebuilt here, so one file owns the build.
  sh "$ROOT/tools/fixtures/s/sha3.sh" 512 "$ROOT/README.md" >/dev/null 2>&1 || true
fi
if [ -z "$PEN_EARLY" ] && [ ! -x "$DIGEST" ]; then
  echo "instrument=torus_fold"
  echo "detail: no SHA3-512 digest binary -- run: sh tools/fixtures/s/sha3.sh 512 README.md"
  echo "verdict=unreadable"
  exit 0
fi

if [ -z "$PEN_EARLY" ]; then
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

# --- the population -------------------------------------------------------------------------
# A deterministic stride over the tracked listing rather than a random draw, so the reading
# reproduces on the same HEAD. Regular files only; a submodule gitlink has no bytes to hash here.
if [ -n "$PATHS_FILE" ]; then
  [ -f "$PATHS_FILE" ] || { echo "$0: no such paths file: $PATHS_FILE" >&2; exit 2; }
  cp "$PATHS_FILE" "$PEN/all"
  SOURCE=file
else
  ( cd "$ROOT" && git ls-files ) > "$PEN/all"
  SOURCE=git_ls_files
fi

TRACKED=$(wc -l < "$PEN/all" | tr -d ' ')
[ "$TRACKED" -gt 0 ] || { echo "instrument=torus_fold"; echo "detail: empty population"; echo "verdict=unreadable"; exit 0; }

STRIDE=$(( TRACKED / MAX_NAMES ))
[ "$STRIDE" -ge 1 ] || STRIDE=1
awk -v s="$STRIDE" -v m="$MAX_NAMES" 'NR % s == 1 || s == 1 { if (k++ < m) print }' "$PEN/all" > "$PEN/sample"

: > "$PEN/names"
while IFS= read -r p; do
  [ -f "$ROOT/$p" ] || continue
  h=$("$DIGEST" 512 "$ROOT/$p") || continue
  [ ${#h} -eq 128 ] || continue
  d=$(printf '%s' "$p" | sed 's#/[^/]*$##')
  [ "$d" = "$p" ] && d="."
  printf '%s %s\n' "$h" "$d" >> "$PEN/names"
done < "$PEN/sample"

NAMES=$(wc -l < "$PEN/names" | tr -d ' ')
[ "$NAMES" -ge 8 ] || { echo "instrument=torus_fold"; echo "detail: $NAMES names is too few to read"; echo "verdict=unreadable"; exit 0; }

# --- the same-directory population --------------------------------------------------------------
# Its own draw, for the reason the header gives: the stride that decorrelates the random baseline
# is exactly what starves this one. Directories are taken in listing order, so the draw is
# deterministic on a given HEAD like every other reading here.
awk -v dmin="$DIR_MIN" -v dtake="$DIR_TAKE" -v cap="$MAX_SAMEDIR" '
  { d = $0; sub(/\/[^\/]*$/, "", d); if (d == $0) d = "."; n[d]++; line[d, n[d]] = $0; order[++seen] = d }
  END {
    for (i = 1; i <= seen; i++) {
      d = order[i]
      if (d in done) continue
      done[d] = 1
      if (n[d] < dmin) continue
      k = n[d]; if (k > dtake) k = dtake
      k = int(k / 2) * 2
      for (j = 1; j <= k && out < cap; j++) { print line[d, j]; out++ }
    }
  }' "$PEN/all" > "$PEN/dirsample"

: > "$PEN/dirnames"
while IFS= read -r p; do
  [ -f "$ROOT/$p" ] || continue
  h=$("$DIGEST" 512 "$ROOT/$p") || continue
  [ ${#h} -eq 128 ] || continue
  d=$(printf '%s' "$p" | sed 's#/[^/]*$##')
  [ "$d" = "$p" ] && d="."
  printf '%s %s\n' "$h" "$d" >> "$PEN/dirnames"
done < "$PEN/dirsample"
DIRNAMES=$(wc -l < "$PEN/dirnames" | tr -d ' ')

# --- the one-byte-edit population -----------------------------------------------------------
# One byte SUBSTITUTED rather than appended, so the two documents differ in content at equal
# length -- the shape a store meets when a record is corrected rather than extended.
: > "$PEN/onebit"
ob=0
while IFS= read -r p; do
  [ "$ob" -lt "$MAX_ONEBIT" ] || break
  f="$ROOT/$p"
  [ -f "$f" ] || continue
  [ -s "$f" ] || continue
  first=$(head -c 1 "$f" | tr -d '\0')
  if [ "$first" = "a" ]; then new=b; else new=a; fi
  { printf '%s' "$new"; tail -c +2 "$f"; } > "$PEN/edited"
  cmp -s "$f" "$PEN/edited" && continue
  ha=$("$DIGEST" 512 "$f") || continue
  hb=$("$DIGEST" 512 "$PEN/edited") || continue
  printf '%s %s\n' "$ha" "$hb" >> "$PEN/onebit"
  ob=$((ob + 1))
done < "$PEN/sample"
fi

echo "instrument=torus_fold"
echo "population=$SOURCE tracked=$TRACKED stride=$STRIDE names=$NAMES onebit_pairs=$ob dirnames=$DIRNAMES"
echo "bounds max_names=$MAX_NAMES max_onebit=$MAX_ONEBIT max_samedir=$MAX_SAMEDIR dir_min=$DIR_MIN dir_take=$DIR_TAKE max_pairs=$MAX_PAIRS sigma=$SIGMA"
echo "expected_pair_distance=128 chi_p=0.001 grid=adaptive_expected_at_least_5_per_cell"

# --- the arithmetic -------------------------------------------------------------------------
# One awk pass per fold offset. Everything below is integer coordinate arithmetic on the two
# bytes named by OFF, so a second offset costs one more pass and no second digest.
run_fold() {
  off="$1"
  awk -v off="$off" -v sigma="$SIGMA" -v maxpairs="$MAX_PAIRS" -v onebit="$PEN/onebit" -v dirfile="$PEN/dirnames" '
    function hexbyte(h, i,   s) { s = substr(h, i * 2 + 1, 2); return strtonum("0x" s) }
    function td(a, b,   d) { d = a - b; if (d < 0) d = -d; if (d > 128) d = 256 - d; return d }
    function pairdist(ax, ay, bx, by) { return td(ax, bx) + td(ay, by) }
    {
      n++
      x[n] = hexbyte($1, off); y[n] = hexbyte($1, off + 1); dir[n] = $2
    }
    END {
      # READING 1 -- evenness over a coarse g x g grid whose g comes from the sample size, so
      # the Pearson approximation stands on an expected count of five or more per cell.
      g = 2
      for (t = 16; t >= 2; t = int(t / 2)) if (n / (t * t) >= 5) { g = t; break }
      side = int(256 / g)
      for (i = 1; i <= n; i++) { k = int(x[i] / side) * g + int(y[i] / side); cnt[k]++ }
      cells = g * g; df = cells - 1
      e = n / cells; chi = 0
      for (k = 0; k < cells; k++) { o = (k in cnt) ? cnt[k] : 0; chi += (o - e) * (o - e) / e }
      crit = chi_crit(df)
      # distinct fine cells, the coarse readings companion
      for (i = 1; i <= n; i++) fine[x[i] * 256 + y[i]] = 1
      dc = 0; for (k in fine) dc++

      # READING 2 -- three populations of DISJOINT pairs against the closed form 128.
      # random: consecutive members of the sample, which the stride already decorrelated.
      rs = 0; rss = 0; rc = 0
      for (i = 1; i + 1 <= n && rc < maxpairs; i += 2) {
        D = pairdist(x[i], y[i], x[i+1], y[i+1]); rs += D; rss += D * D; rc++
      }
      # samedir: read from its own draw, each directory contributing disjoint pairs of its members.
      ds = 0; dss = 0; dcp = 0
      while ((getline line < dirfile) > 0) {
        split(line, f, " ")
        d = f[2]
        cx = hexbyte(f[1], off); cy = hexbyte(f[1], off + 1)
        if (d in heldx) {
          D = pairdist(heldx[d], heldy[d], cx, cy); ds += D; dss += D * D; dcp++
          delete heldx[d]; delete heldy[d]
        } else { heldx[d] = cx; heldy[d] = cy }
        if (dcp >= maxpairs) break
      }
      close(dirfile)
      # onebit: read from the second file, one line per pair, two digests.
      os = 0; oss = 0; oc = 0
      while ((getline line < onebit) > 0) {
        split(line, f, " ")
        ax = hexbyte(f[1], off); ay = hexbyte(f[1], off + 1)
        bx = hexbyte(f[2], off); by = hexbyte(f[2], off + 1)
        D = pairdist(ax, ay, bx, by); os += D; oss += D * D; oc++
        if (oc >= maxpairs) break
      }
      close(onebit)

      printf "fold off=%d grid=%dx%d df=%d expected_per_cell=%.2f chi_squared=%.2f critical=%.2f distinct_fine_cells=%d of_names=%d\n", \
        off, g, g, df, e, chi, crit, dc, n
      report("random", off, rc, rs, rss, sigma)
      report("samedir", off, dcp, ds, dss, sigma)
      report("onebit", off, oc, os, oss, sigma)
      printf "fold_verdict off=%d clusters=%s\n", off, (chi > crit ? "yes" : "no")
    }
    # Wilson-Hilferty: the p=0.001 upper critical value of chi-squared at df degrees of freedom,
    # derived rather than tabled so the adaptive grid needs no table row of its own. Checked
    # against the published values at df=63 (103.44) and df=255 (330.52) by the control.
    function chi_crit(df,   z, a, b) {
      z = 3.0902
      a = 2.0 / (9.0 * df)
      b = 1.0 - a + z * sqrt(a)
      return df * b * b * b
    }
    function report(name, off, c, s, ss, sigma,   m, v, se, dev, verdict) {
      if (c < 4) { printf "pop %s off=%d pairs=%d detail=too_few\n", name, off, c; return }
      m = s / c
      v = (ss / c) - m * m
      if (v < 0) v = 0
      se = sqrt(v / c)
      dev = m - 128; if (dev < 0) dev = -dev
      # NO se > 0 GUARD HERE, and the omission is deliberate. A first draft carried one, to keep a
      # degenerate divisor out of the comparison, and it silenced the loudest signal the scan can
      # receive: a population every one of whose pairs sits at the SAME distance has standard
      # error exactly zero, so `se > 0` was false and a mean 126 away from the expectation read
      # "indistinguishable". The pen caught it on a planted population whose partners all sat one
      # cell apart. With the guard gone the comparison is right in both directions: at se = 0 any
      # real deviation exceeds it, and a deviation of zero does not.
      verdict = (dev > sigma * se) ? "distinguishable" : "indistinguishable"
      # The resolution is what the reading can actually see. A mean sitting inside the threshold
      # says the effect is smaller than the threshold, never that it is zero -- so the threshold
      # is printed as a share of the 128 the population is being compared against, and a reader
      # who wants a finer answer raises the pair count rather than trusting the word.
      printf "pop %s off=%d pairs=%d mean=%.3f sd=%.3f se=%.3f deviation=%.3f threshold=%.3f resolution_pct=%.1f verdict=%s\n", \
        name, off, c, m, sqrt(v), se, dev, sigma * se, 100 * sigma * se / 128, verdict
    }
  ' "$PEN/names"
}

run_fold 0  > "$PEN/f0"
run_fold 30 > "$PEN/f30"
cat "$PEN/f0" "$PEN/f30"

# --- the verdict ------------------------------------------------------------------------------
# Three questions, answered from the two folds together.
#   clusters       -- did the stated falsifier fire?
#   adjacency      -- does ANY related population sit measurably nearer than random?
#   folds_agree    -- do the two byte offsets answer alike?
CLUSTERS=$(cat "$PEN/f0" "$PEN/f30" | grep -c 'clusters=yes' || true)
DISTINGUISHABLE=$(cat "$PEN/f0" "$PEN/f30" | grep -c 'verdict=distinguishable' || true)
RELATED_DIST=$(cat "$PEN/f0" "$PEN/f30" | grep -E '^pop (samedir|onebit) ' | grep -c 'verdict=distinguishable' || true)
POPS=$(cat "$PEN/f0" "$PEN/f30" | grep -cE '^pop ' || true)
TOO_FEW=$(cat "$PEN/f0" "$PEN/f30" | grep -cE '^pop .*too_few' || true)

# A population with too few pairs is UNREAD rather than clean, and the verdict below speaks only
# for the populations that answered. Naming the count is what keeps an absent reading from being
# read as a passing one.
echo "clusters_folds=$CLUSTERS of=2"
echo "unread_populations=$TOO_FEW"
echo "populations=$POPS distinguishable=$DISTINGUISHABLE related_distinguishable=$RELATED_DIST too_few=$TOO_FEW"

if [ "$CLUSTERS" -gt 0 ]; then
  echo "detail: the stated falsifier FIRED -- the fold clusters, so row 5 dies on its own terms"
  echo "verdict=clusters"
elif [ "$RELATED_DIST" -gt 0 ]; then
  echo "detail: a related population sits measurably nearer than random -- the fold carries relation"
  echo "verdict=adjacency_informative"
else
  echo "detail: the fold is even and no related population sits nearer than random -- the falsifier"
  echo "detail: fails, and the same uniformity that clears it leaves adjacency carrying no relation"
  echo "verdict=even_and_uninformative"
fi
