#!/bin/sh
# tools/fixtures/t/key_trade_scan.sh -- is the locality-for-evenness trade a law of keys, or a
# property of the keys measured so far? The named next step of
# active-designing/20260915-181000_the-key-that-carries-locality.md.
#
# WHAT IS OPEN. That page priced the crudest locality-bearing key there is -- a file's leading two
# bytes -- against SHA3-512, and found locality, evenness and confidentiality moving as one
# quantity read three ways, each sentence following the last "by the definition of the key rather
# than by any fact about this tree." Its own last section names what it did not reach: "whether a
# similarity-preserving sketch lands better on the same trade. It will land better in magnitude.
# Whether it CHANGES A SIGN is a different key, a different reading, and the honest next step for
# anyone who wants one."
#
# WHAT THIS READS. Three keys over ONE population, with the SAME readings taken from each, so the
# trade is visible in one printout rather than inferred across two papers. Every key is a 16-bit
# value; its high byte is the x coordinate and its low byte the y, so no key gets a fold of its own.
#
#   KEY sha3    -- bytes 0 and 1 of SHA3-512 over the file's bytes. The name a Tablecloth on this
#                  pier would actually carry (foundations/20260823-222020_what-tablecloth-is.md).
#                  Built to avalanche: one input bit changed redistributes the output.
#   KEY path    -- FNV-1a over the DIRECTORY in the high byte, FNV-1a over the BASENAME in the low.
#                  Locality on the room relation, by construction: two files sharing a directory
#                  share their x coordinate exactly, so their torus distance is the y term alone.
#                  Named here as the cheapest locality key anyone would reach for.
#   KEY simhash -- a 16-bit SimHash over the file's word tokens. For each token, FNV-1a; for each
#                  of the 16 bit positions, add one when the token's hash has that bit set and
#                  subtract one when it does not; the sign of each accumulator is the output bit.
#                  Locality on the CONTENT relation: two documents sharing most of their tokens
#                  agree on most accumulator signs, so the keys sit close in Hamming distance.
#
# THREE POPULATIONS, the sibling's, so the two papers can be read against each other:
#
#   random  -- disjoint pairs from a strided sample of the tracked listing. The baseline.
#   samedir -- disjoint pairs of files sharing a directory, drawn from their own population
#              because the stride that decorrelates the baseline starves this one.
#   onebit  -- a file and the same file with its FIRST byte substituted. Equal length, one byte
#              different: the shape a store meets when a record is corrected rather than extended.
#
# THREE METRICS, because a key must be read in its own metric before it is read in the torus's,
# or a finding about the FOLD is reported as a finding about the KEY. Each has a closed form for
# uniform 16-bit keys, derived rather than tabled:
#
#   torus   -- toroidal Manhattan on (x, y), each axis wrapped: min(d, 256 - d). The reading row 5
#              proposed. Per-axis mean is exactly 64 for uniform coordinates, since the circular
#              difference is uniform on 0..255 and (0+1+...+127) + 128 + (127+...+1) = 16384 over
#              256 = 64. So the expected pair distance is exactly 128.
#   ring    -- circular distance on the whole 16-bit key read as ONE coordinate:
#              min(d, 65536 - d). Expected 16384 by the same derivation one size up. This is the
#              lane's standing question -- does the second axis pay? -- asked of each key.
# EACH RELATED POPULATION IS READ TWICE: once against the metric's closed form, which asks whether
# the key is uniform, and once against the KEY'S OWN random baseline, which asks whether the key
# carries the relation. The second is what the adjacency verdict takes, and the path key is why:
# its random pairs read a torus mean near 95 where a uniform key reads 128, so a same-directory
# mean under 128 would count that key's global concentration as though it were locality.
#
#   hamming -- bits differing between the two 16-bit keys. Expected 8 for uniform keys, since each
#              of 16 bit positions differs with probability one half. This is SimHash's OWN
#              metric, and a key that carries locality carries it here first.
#
# THE FALSIFIER THIS EXISTS TO FIRE. The trade claimed by both elder papers is that evenness and
# adjacency cannot be had by one key: avalanche buys the first and destroys the second. A key that
# reads EVEN (chi-squared under its critical value) and ALSO reads a related population measurably
# nearer than random refutes that trade. The scan prints `both_available` by name when it happens,
# so the finding can fire in either direction rather than only confirming.
#
# WHAT THIS DOES NOT READ. Whether Tablecloth SHOULD change its key, which is a custody-weight
# decision about a content-addressed store and is not touched here. Whether a locality key is safe
# -- a key that leaks similarity leaks content, and that reading wants its own lap. And anything
# about a real store, which this scan never opens.
#
# gawk is required and named: the readings use xor, and, rshift, lshift and strtonum, which are
# GNU extensions. A POSIX awk is refused by name rather than read wrongly.
#
# USAGE
#   sh tools/fixtures/t/key_trade_scan.sh                 # the reading
#   sh tools/fixtures/t/key_trade_scan.sh --paths F       # read the path list from F
#   sh tools/fixtures/t/key_trade_scan.sh --names N       # lower the sample bound
#   sh tools/fixtures/t/key_trade_scan.sh --keys K --onebit-keys O --dir-keys D
#                                                            # read KEYS directly, no hashing
#
# THE KEYS DOOR IS THE CONTROL PATH, for the reason the sibling's digest door exists: the pen
# cannot supply the populations this scan must be proven against. A key that is both even and
# adjacent would have to be invented, and inventing it is the reading's own subject. So --keys
# takes lines of "<4 hex> <4 hex> <4 hex> <directory>" -- sha3, path, simhash -- and --onebit-keys
# lines of "<4 hex> <4 hex> <4 hex> <4 hex> <4 hex> <4 hex>", the three keys of each side.
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

# Byte semantics, named rather than inherited. The keys hash BYTES, and under a UTF-8 locale gawk
# reads a character rather than a byte: a tracked path or a token carrying a high byte then walks
# out of the 256-entry ORD table and the FNV step is handed a negative argument. Measured on this
# tree at the 110th sampled file, which is how this line came to be written.
LC_ALL=C
export LC_ALL

MAX_NAMES=512      # bounded: each name costs one SHA3-512 over a whole file, ~13ms on this pier
MAX_ONEBIT=96      # bounded: each pair costs two digests and two SimHashes
MAX_SAMEDIR=256    # bounded: names drawn for the same-directory population
DIR_MIN=4          # a directory joins that population only with this many tracked files
DIR_TAKE=8         # and contributes at most this many, so one large room cannot carry the reading
MAX_PAIRS=4096     # bounded: no population may contribute more disjoint pairs than this
MAX_TOKENS=512     # bounded: a 16-bit SimHash saturates long before this, since 16 accumulators
                   # over several hundred features are already dominated by their first hundreds;
                   # the bound is what keeps one large file from costing more than a small one
SIGMA=3            # a mean this many standard errors from its closed form is called distinguishable

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
KEYS_FILE=""
ONEBIT_KEYS_FILE=""
DIR_KEYS_FILE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --paths) PATHS_FILE="${2:?--paths wants a file}"; shift 2 ;;
    --names) MAX_NAMES="${2:?--names wants a count}"; shift 2 ;;
    --onebit) MAX_ONEBIT="${2:?--onebit wants a count}"; shift 2 ;;
    --samedir) MAX_SAMEDIR="${2:?--samedir wants a count}"; shift 2 ;;
    --tokens) MAX_TOKENS="${2:?--tokens wants a count}"; shift 2 ;;
    --keys) KEYS_FILE="${2:?--keys wants a file}"; shift 2 ;;
    --onebit-keys) ONEBIT_KEYS_FILE="${2:?--onebit-keys wants a file}"; shift 2 ;;
    --dir-keys) DIR_KEYS_FILE="${2:?--dir-keys wants a file}"; shift 2 ;;
    *) echo "$0: unknown flag $1" >&2; exit 2 ;;
  esac
done

# gawk is checked BEFORE any reading, and refused by name. A POSIX awk silently returns 0 from
# xor() as an unknown-function call in some implementations and aborts in others, and either way
# a reading taken through it would be wrong rather than absent.
if ! awk 'BEGIN { exit (xor(5, 3) == 6 && strtonum("0x10") == 16) ? 0 : 1 }' 2>/dev/null; then
  echo "instrument=key_trade"
  echo "detail: awk lacks the GNU bit functions this reading needs -- install gawk"
  echo "verdict=unreadable"
  exit 0
fi

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

if [ -n "$KEYS_FILE" ]; then
  [ -f "$KEYS_FILE" ] || { echo "$0: no such keys file: $KEYS_FILE" >&2; exit 2; }
  cp "$KEYS_FILE" "$PEN/keys"
  if [ -n "$DIR_KEYS_FILE" ]; then cp "$DIR_KEYS_FILE" "$PEN/dirkeys"; else cp "$KEYS_FILE" "$PEN/dirkeys"; fi
  if [ -n "$ONEBIT_KEYS_FILE" ]; then cp "$ONEBIT_KEYS_FILE" "$PEN/onebitkeys"; else : > "$PEN/onebitkeys"; fi
  SOURCE=keys_file
  TRACKED=$(wc -l < "$PEN/keys" | tr -d ' ')
  STRIDE=1
  NAMES="$TRACKED"
  DIRNAMES=$(wc -l < "$PEN/dirkeys" | tr -d ' ')
  OB=$(wc -l < "$PEN/onebitkeys" | tr -d ' ')
else
  DIGEST="$ROOT/crypto/bin/sha3-digest"
  if [ ! -x "$DIGEST" ]; then
    # The shim builds it from crypto/sha3_digest.rye on first call. Reached through the shim
    # rather than rebuilt here, so one file owns the build.
    sh "$ROOT/tools/fixtures/s/sha3.sh" 512 "$ROOT/README.md" >/dev/null 2>&1 || true
  fi
  if [ ! -x "$DIGEST" ]; then
    echo "instrument=key_trade"
    echo "detail: no SHA3-512 digest binary -- run: sh tools/fixtures/s/sha3.sh 512 README.md"
    echo "verdict=unreadable"
    exit 0
  fi

  # --- the population ---------------------------------------------------------------------------
  # A deterministic stride over the tracked listing rather than a random draw, so the reading
  # reproduces on the same HEAD. The sibling's draw, deliberately, so the two papers read one
  # population and their figures may be set beside each other.
  if [ -n "$PATHS_FILE" ]; then
    [ -f "$PATHS_FILE" ] || { echo "$0: no such paths file: $PATHS_FILE" >&2; exit 2; }
    cp "$PATHS_FILE" "$PEN/all"
    SOURCE=file
  else
    ( cd "$ROOT" && git ls-files ) > "$PEN/all"
    SOURCE=git_ls_files
  fi

  TRACKED=$(wc -l < "$PEN/all" | tr -d ' ')
  [ "$TRACKED" -gt 0 ] || { echo "instrument=key_trade"; echo "detail: empty population"; echo "verdict=unreadable"; exit 0; }

  STRIDE=$(( TRACKED / MAX_NAMES ))
  [ "$STRIDE" -ge 1 ] || STRIDE=1
  awk -v s="$STRIDE" -v m="$MAX_NAMES" 'NR % s == 1 || s == 1 { if (k++ < m) print }' "$PEN/all" > "$PEN/sample"

  # --- the same-directory draw ------------------------------------------------------------------
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

  # --- the one-byte-edit draw -------------------------------------------------------------------
  # The edited copy is written into the pen so both keys read the same two files: the digest needs
  # the bytes and the SimHash needs the tokens, and building the edit twice would let them drift.
  : > "$PEN/onebitpaths"
  OB=0
  mkdir -p "$PEN/edits"
  while IFS= read -r p; do
    [ "$OB" -lt "$MAX_ONEBIT" ] || break
    f="$ROOT/$p"
    [ -f "$f" ] || continue
    [ -s "$f" ] || continue
    first=$(head -c 1 "$f" | tr -d '\0')
    if [ "$first" = "a" ]; then new=b; else new=a; fi
    e="$PEN/edits/e$OB"
    { printf '%s' "$new"; tail -c +2 "$f"; } > "$e"
    cmp -s "$f" "$e" && { rm -f "$e"; continue; }
    printf '%s\t%s\n' "$f" "$e" >> "$PEN/onebitpaths"
    OB=$((OB + 1))
  done < "$PEN/sample"

  # --- the keys ---------------------------------------------------------------------------------
  # One digest call per file, then ONE awk pass computing the path key and the SimHash for every
  # file in the list. The digest is a separate loop because it is a separate program; everything
  # else is arithmetic and costs one process for the whole population.
  digest_list() {   # $1 = list of tree-relative paths, writes "<path>\t<128 hex>"
    while IFS= read -r p; do
      [ -f "$ROOT/$p" ] || continue
      h=$("$DIGEST" 512 "$ROOT/$p") || continue
      [ ${#h} -eq 128 ] || continue
      printf '%s\t%s\n' "$p" "$h"
    done < "$1"
  }
  digest_list "$PEN/sample"    > "$PEN/sample.d"
  digest_list "$PEN/dirsample" > "$PEN/dirsample.d"

  : > "$PEN/onebitpaths.d"
  while IFS="$(printf '\t')" read -r a b; do
    ha=$("$DIGEST" 512 "$a") || continue
    hb=$("$DIGEST" 512 "$b") || continue
    printf '%s\t%s\t%s\t%s\n' "$a" "$ha" "$b" "$hb" >> "$PEN/onebitpaths.d"
  done < "$PEN/onebitpaths"

  # keyfold.awk turns a "<path>\t<sha3 hex>" line into "<sha3> <path> <simhash> <dir>", each key
  # four hex digits. It reads each file itself, so no second process per file is spawned.
  cat > "$PEN/keyfold.awk" <<'AWK_EOF'
# FNV-1a, 32 bits, exact under awk's doubles. A direct h * 16777619 reaches 2^57 and loses the low
# bits silently, so the multiply is split into 16-bit halves and recombined mod 2^32.
function fnv_step(h, c,   hi, lo) {
  h = xor(h, c)
  hi = int(h / 65536); lo = h % 65536
  return ((hi * 16777619 % 65536) * 65536 + lo * 16777619) % 4294967296
}
function fnv(s,   h, i, n, c) {
  h = 2166136261
  n = length(s)
  for (i = 1; i <= n; i++) {
    # index() answers 0 for a character ORD does not hold, and 0 - 1 hands xor a negative. The
    # clamp keeps the function total; LC_ALL=C above is what keeps it from being reached.
    c = index(ORD, substr(s, i, 1)) - 1
    if (c < 0) c = 0
    h = fnv_step(h, c)
  }
  return h
}
function simhash(path, tokens,   line, i, j, nf, f, hh, acc, v, taken, parts) {
  for (j = 0; j < 16; j++) acc[j] = 0
  taken = 0
  while (taken < tokens && (getline line < path) > 0) {
    gsub(/[^A-Za-z0-9]+/, " ", line)
    nf = split(line, parts, " ")
    for (i = 1; i <= nf && taken < tokens; i++) {
      hh = fnv(parts[i])
      for (j = 0; j < 16; j++) {
        if (and(int(hh / (2 ^ j)), 1)) acc[j]++; else acc[j]--
      }
      taken++
    }
  }
  close(path)
  v = 0
  for (j = 0; j < 16; j++) if (acc[j] > 0) v += 2 ^ j
  return v
}
BEGIN {
  FS = "\t"
  # ORD indexes a character to its byte value. Built once; index() over it is the only way a
  # POSIX-shaped awk turns a character into a number, and gawk's own ord() does not exist.
  ORD = ""
  for (i = 0; i < 256; i++) ORD = ORD sprintf("%c", i)
}
{
  path = $1; hex = $2
  full = (path ~ /^\//) ? path : root "/" path
  d = path; sub(/\/[^\/]*$/, "", d); if (d == path) d = "."
  b = path; sub(/^.*\//, "", b)
  sha = substr(hex, 1, 4)
  pk = sprintf("%04x", (fnv(d) % 256) * 256 + (fnv(b) % 256))
  sk = sprintf("%04x", simhash(full, tokens))
  printf "%s %s %s %s\n", sha, pk, sk, d
}
AWK_EOF

  awk -v root="$ROOT" -v tokens="$MAX_TOKENS" -f "$PEN/keyfold.awk" "$PEN/sample.d"    > "$PEN/keys"
  awk -v root="$ROOT" -v tokens="$MAX_TOKENS" -f "$PEN/keyfold.awk" "$PEN/dirsample.d" > "$PEN/dirkeys"

  # The one-bit pairs run through the same function, both sides, so nothing about the pair is
  # computed a second way.
  : > "$PEN/onebitkeys"
  awk -v tokens="$MAX_TOKENS" '
    function fnv_step(h, c,   hi, lo) {
      h = xor(h, c); hi = int(h / 65536); lo = h % 65536
      return ((hi * 16777619 % 65536) * 65536 + lo * 16777619) % 4294967296
    }
    function fnv(s,   h, i, n, c) { h = 2166136261; n = length(s)
      for (i = 1; i <= n; i++) { c = index(ORD, substr(s, i, 1)) - 1; if (c < 0) c = 0
        h = fnv_step(h, c) }
      return h }
    function simhash(path, tokens,   line, i, j, nf, hh, acc, v, taken, parts) {
      for (j = 0; j < 16; j++) acc[j] = 0
      taken = 0
      while (taken < tokens && (getline line < path) > 0) {
        gsub(/[^A-Za-z0-9]+/, " ", line); nf = split(line, parts, " ")
        for (i = 1; i <= nf && taken < tokens; i++) {
          hh = fnv(parts[i])
          for (j = 0; j < 16; j++) { if (and(int(hh / (2 ^ j)), 1)) acc[j]++; else acc[j]-- }
          taken++
        }
      }
      close(path); v = 0
      for (j = 0; j < 16; j++) if (acc[j] > 0) v += 2 ^ j
      return v
    }
    BEGIN { FS = "\t"; ORD = ""; for (i = 0; i < 256; i++) ORD = ORD sprintf("%c", i) }
    {
      pa = $1; ha = $2; pb = $3; hb = $4
      da = pa; sub(/\/[^\/]*$/, "", da); ba = pa; sub(/^.*\//, "", ba)
      # The EDITED copy keeps the original path key on purpose: it stands for the same record
      # corrected in place, which a store would file under the same name in the same room. Giving
      # it the pen path key would measure the pen rather than the edit.
      printf "%s %04x %04x %s %04x %04x\n", substr(ha, 1, 4), (fnv(da) % 256) * 256 + (fnv(ba) % 256), \
        simhash(pa, tokens), substr(hb, 1, 4), (fnv(da) % 256) * 256 + (fnv(ba) % 256), simhash(pb, tokens)
    }' "$PEN/onebitpaths.d" > "$PEN/onebitkeys"

  NAMES=$(wc -l < "$PEN/keys" | tr -d ' ')
  DIRNAMES=$(wc -l < "$PEN/dirkeys" | tr -d ' ')
  OB=$(wc -l < "$PEN/onebitkeys" | tr -d ' ')
fi

# The floor is checked for both doors. It stood inside the hashing branch alone, so a two-line
# planted keys file read as a finding rather than as unreadable -- caught by the control.
[ "$NAMES" -ge 8 ] || { echo "instrument=key_trade"; echo "detail: $NAMES names is too few to read"; echo "verdict=unreadable"; exit 0; }

# The shape of the path key is the shape of the directory population, so the reading names it.
# One FNV byte spread over many rooms is what would cluster the key, and a reader judging a
# chi-squared near its critical value needs to know how many rooms carried it and whether one
# room carried most of them.
DIRS=$(awk '{ print $4 }' "$PEN/keys" | sort | uniq -c | sort -rn > "$PEN/dircount"; wc -l < "$PEN/dircount" | tr -d ' ')
BIGDIR=$(head -1 "$PEN/dircount" | awk '{ print $1 }')
BIGSHARE=$(awk -v b="${BIGDIR:-0}" -v n="$NAMES" 'BEGIN { printf "%.4f", (n > 0) ? b / n : 0 }')

echo "instrument=key_trade"
echo "population=$SOURCE tracked=$TRACKED stride=$STRIDE names=$NAMES dirnames=$DIRNAMES onebit_pairs=$OB"
echo "rooms distinct_directories=$DIRS largest=${BIGDIR:-0} largest_share=$BIGSHARE"
echo "bounds max_names=$MAX_NAMES max_onebit=$MAX_ONEBIT max_samedir=$MAX_SAMEDIR dir_min=$DIR_MIN dir_take=$DIR_TAKE max_pairs=$MAX_PAIRS max_tokens=$MAX_TOKENS sigma=$SIGMA"
echo "keys=sha3,path,simhash metrics=torus,ring,hamming expected torus=128 ring=16384 hamming=8 chi_p=0.001 grid=adaptive_expected_at_least_5_per_cell"

# --- the arithmetic -----------------------------------------------------------------------------
# One awk pass per key. Everything below is integer arithmetic on 16-bit keys already in hand, so
# a third key costs one more pass and no second hash.
run_key() {
  col="$1"; name="$2"
  awk -v col="$col" -v kname="$name" -v sigma="$SIGMA" -v maxpairs="$MAX_PAIRS" \
      -v onebit="$PEN/onebitkeys" -v dirfile="$PEN/dirkeys" '
    function hx(s) { return strtonum("0x" s) }
    function td(a, b,   d) { d = a - b; if (d < 0) d = -d; if (d > 128) d = 256 - d; return d }
    function torus(a, b) { return td(int(a / 256), int(b / 256)) + td(a % 256, b % 256) }
    function ring(a, b,   d) { d = a - b; if (d < 0) d = -d; if (d > 32768) d = 65536 - d; return d }
    function hamming(a, b,   x, c) { x = xor(a, b); c = 0
      while (x > 0) { c += x % 2; x = int(x / 2) }; return c }
    function chi_crit(df,   z, a, b) {
      # Wilson-Hilferty: the p=0.001 upper critical value at df degrees of freedom, derived rather
      # than tabled so the adaptive grid needs no table row of its own.
      z = 3.0902; a = 2.0 / (9.0 * df); b = 1.0 - a + z * sqrt(a); return df * b * b * b
    }
    function report(pop, metric, c, s, ss, expect,   m, v, se, dev, verdict, near) {
      if (c < 4) { printf "pop %s %s %s pairs=%d detail=too_few\n", kname, pop, metric, c
        few[pop SUBSEP metric] = 1; return }
      m = s / c
      v = (ss / c) - m * m; if (v < 0) v = 0
      se = sqrt(v / c)
      dev = m - expect; if (dev < 0) dev = -dev
      # No se > 0 guard, deliberately and for the reason its sibling gives: a population every one of whose
      # pairs sits at the SAME distance has standard error exactly zero, and a guard there reads
      # the loudest signal this scan can receive as "indistinguishable". At se = 0 any real
      # deviation exceeds it, and a deviation of zero does not.
      verdict = (dev > sigma * se) ? "distinguishable" : "indistinguishable"
      near = (m < expect) ? "nearer" : "farther"
      MEAN[pop SUBSEP metric] = m; SE[pop SUBSEP metric] = se; NP[pop SUBSEP metric] = c
      printf "pop %s %s %s pairs=%d mean=%.3f expected=%.3f sd=%.3f se=%.3f deviation=%.3f threshold=%.3f side=%s verdict=%s\n", \
        kname, pop, metric, c, m, expect, sqrt(v), se, dev, sigma * se, near, verdict
    }
    # A related population is read against the OWN random baseline of the key as well as the
    # closed form, and THIS is the reading the adjacency verdict takes. The reason is visible in
    # the numbers of the path key itself: its random pairs read a torus mean of 95 where a uniform key
    # reads 128, so its whole population is concentrated and a same-directory mean under 128 would
    # be partly that concentration rather than the room relation. The closed form answers "is this
    # key uniform"; the own baseline answers "does this key carry the relation", and only the
    # second is what locality means.
    function contrast(pop, metric,   mr, sr, mp, sp, diff, sed, side, verdict) {
      if ((pop SUBSEP metric) in few || ("random" SUBSEP metric) in few) {
        printf "contrast %s %s %s detail=too_few\n", kname, pop, metric; return }
      mr = MEAN["random" SUBSEP metric]; sr = SE["random" SUBSEP metric]
      mp = MEAN[pop SUBSEP metric];      sp = SE[pop SUBSEP metric]
      diff = mr - mp
      sed = sqrt(sr * sr + sp * sp)
      side = (diff > 0) ? "nearer" : "farther"
      if (diff < 0) diff = -diff
      verdict = (diff > sigma * sed) ? "distinguishable" : "indistinguishable"
      printf "contrast %s %s %s pop_mean=%.3f random_mean=%.3f gap=%.3f se=%.3f threshold=%.3f side=%s verdict=%s\n", \
        kname, pop, metric, mp, mr, diff, sed, sigma * sed, side, verdict
    }
    { n++; k[n] = hx($col); dir[n] = $4 }
    END {
      # READING 1 -- evenness over a coarse g x g grid whose g comes from the sample size, so the
      # Pearson approximation stands on an expected count of five or more per cell.
      g = 2
      for (t = 16; t >= 2; t = int(t / 2)) if (n / (t * t) >= 5) { g = t; break }
      side = int(256 / g)
      for (i = 1; i <= n; i++) { cell = int(int(k[i] / 256) / side) * g + int((k[i] % 256) / side); cnt[cell]++ }
      cells = g * g; df = cells - 1; e = n / cells; chi = 0
      for (c = 0; c < cells; c++) { o = (c in cnt) ? cnt[c] : 0; chi += (o - e) * (o - e) / e }
      crit = chi_crit(df)
      for (i = 1; i <= n; i++) fine[k[i]] = 1
      dcf = 0; for (c in fine) dcf++
      printf "key %s grid=%dx%d df=%d expected_per_cell=%.2f chi_squared=%.2f critical=%.2f distinct_keys=%d of_names=%d even=%s\n", \
        kname, g, g, df, e, chi, crit, dcf, n, (chi > crit ? "no" : "yes")

      # READING 3 -- ROOM RECOVERY, carried over unchanged from the elder prefix-key reading at
      # active-designing/20260915-181000_the-key-that-carries-locality.md so the two papers may be
      # set side by side. For each coarse cell take the largest single room among the files in it,
      # sum over cells, divide by the population: the share of files an observer holding KEYS
      # ALONE places in the right room by guessing the plurality of each cell. Its honest baseline is
      # the same guess made with no key at all, which is the plurality room share over the whole
      # population. A key that groups documents tells an observer which group each is in, and this
      # is that sentence as a number.
      for (i = 1; i <= n; i++) {
        cell = int(int(k[i] / 256) / side) * g + int((k[i] % 256) / side)
        # The TOP-LEVEL room rather than the full directory, which is what the elder reading
        # grouped by: 44 rooms of this tree rather than its several hundred directories. A finer
        # grouping reads a smaller recovery for every key alike and so says less about any of them.
        room = dir[i]; sub(/\/.*$/, "", room)
        pair[cell SUBSEP room]++
        whole[room]++
      }
      for (key2 in pair) {
        split(key2, part, SUBSEP)
        if (pair[key2] > best[part[1]]) best[part[1]] = pair[key2]
      }
      rec = 0; for (c in best) rec += best[c]
      base = 0; for (d in whole) if (whole[d] > base) base = whole[d]
      nrooms = 0; for (d in whole) nrooms++
      printf "leak %s cells=%d rooms=%d recovered=%.4f no_key_baseline=%.4f lift=%.4f\n", \
        kname, cells, nrooms, rec / n, base / n, (rec - base) / n

      # READING 2 -- three populations of DISJOINT pairs, each read in all three metrics.
      for (i = 1; i + 1 <= n && rc < maxpairs; i += 2) {
        a = k[i]; b = k[i+1]
        D = torus(a, b);   rts += D; rtss += D * D
        D = ring(a, b);    rrs += D; rrss += D * D
        D = hamming(a, b); rhs += D; rhss += D * D
        rc++
      }
      while ((getline line < dirfile) > 0) {
        nf = split(line, f, " "); d = f[4]; cur = hx(f[col])
        if (d in held) {
          a = held[d]; b = cur
          D = torus(a, b);   dts += D; dtss += D * D
          D = ring(a, b);    drs += D; drss += D * D
          D = hamming(a, b); dhs += D; dhss += D * D
          dc++; delete held[d]
        } else held[d] = cur
        if (dc >= maxpairs) break
      }
      close(dirfile)
      while ((getline line < onebit) > 0) {
        split(line, f, " ")
        a = hx(f[col]); b = hx(f[col + 3])
        D = torus(a, b);   ots += D; otss += D * D
        D = ring(a, b);    ors += D; orss += D * D
        D = hamming(a, b); ohs += D; ohss += D * D
        oc++
        if (oc >= maxpairs) break
      }
      close(onebit)

      report("random",  "torus",   rc, rts, rtss, 128)
      report("random",  "ring",    rc, rrs, rrss, 16384)
      report("random",  "hamming", rc, rhs, rhss, 8)
      report("samedir", "torus",   dc, dts, dtss, 128)
      report("samedir", "ring",    dc, drs, drss, 16384)
      report("samedir", "hamming", dc, dhs, dhss, 8)
      report("onebit",  "torus",   oc, ots, otss, 128)
      report("onebit",  "ring",    oc, ors, orss, 16384)
      report("onebit",  "hamming", oc, ohs, ohss, 8)

      contrast("samedir", "torus");   contrast("samedir", "ring");   contrast("samedir", "hamming")
      contrast("onebit",  "torus");   contrast("onebit",  "ring");   contrast("onebit",  "hamming")
    }
  ' "$PEN/keys"
}

run_key 1 sha3    >  "$PEN/out"
run_key 2 path    >> "$PEN/out"
run_key 3 simhash >> "$PEN/out"
cat "$PEN/out"

# --- the verdict --------------------------------------------------------------------------------
# One question per key, then one over all three. A key is ADJACENT when a related population sits
# measurably NEARER than its closed form in at least one metric; nearer rather than merely
# distinguishable, because a related population sitting measurably FARTHER than random is a real
# reading and is the opposite of locality.
TOO_FEW=$(grep -c 'detail=too_few' "$PEN/out" || true)
EVEN_KEYS=0
ADJ_KEYS=0
BOTH=0
for kn in sha3 path simhash; do
  even=$(awk -v k="$kn" '$1 == "key" && $2 == k { print ($0 ~ /even=yes/) ? "yes" : "no" }' "$PEN/out")
  adj=$(awk -v k="$kn" '$1 == "contrast" && $2 == k \
        && /side=nearer/ && /verdict=distinguishable/ { c++ } END { print (c > 0) ? "yes" : "no" }' "$PEN/out")
  metrics=$(awk -v k="$kn" '$1 == "contrast" && $2 == k \
        && /side=nearer/ && /verdict=distinguishable/ { printf "%s:%s,", $3, $4 } END { print "" }' "$PEN/out")
  echo "key_verdict $kn even=$even adjacent=$adj nearer_in=${metrics:-none}"
  [ "$even" = yes ] && EVEN_KEYS=$((EVEN_KEYS + 1))
  [ "$adj" = yes ] && ADJ_KEYS=$((ADJ_KEYS + 1))
  [ "$even" = yes ] && [ "$adj" = yes ] && BOTH=$((BOTH + 1))
done

echo "keys_read=3 even=$EVEN_KEYS adjacent=$ADJ_KEYS both=$BOTH unread_populations=$TOO_FEW"

if [ "$BOTH" -gt 0 ]; then
  echo "detail: a key reads EVEN and carries adjacency at once -- the trade both elder papers"
  echo "detail: claimed is refuted, and a store may have locality without paying in placement"
  echo "verdict=both_available"
elif [ "$ADJ_KEYS" -eq 0 ]; then
  echo "detail: no key carries adjacency in any metric -- the open door closes with the locality"
  echo "detail: keys failing on their own ground rather than on the fold's"
  echo "verdict=no_locality"
else
  echo "detail: every key that carries adjacency pays for it in evenness, and every even key"
  echo "detail: carries none -- the trade the elder papers claimed stands on a wider population"
  echo "verdict=trade_holds"
fi
