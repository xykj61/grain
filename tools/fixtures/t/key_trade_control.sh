#!/bin/sh
# tools/fixtures/t/key_trade_control.sh -- proves tools/fixtures/t/key_trade_scan.sh from
# both sides on planted populations and on a real directory tree in a throwaway pen.
#
# WHY A PEN CANNOT SUPPLY THE POPULATIONS BY HASHING. The scan's subject is whether a key can be
# even AND carry adjacency at once. Planting that by choosing files would mean inventing such a
# key, which is the reading's own question. So the scan carries a --keys door taking 16-bit keys
# directly, and the control plants each shape it must tell apart: uniform and unrelated, uniform
# and related, clustered and related, and the concentrated-but-unrelated shape that the own-baseline
# contrast exists to refuse.
#
# THE KEYS FILE is "<4 hex> <4 hex> <4 hex> <directory>" -- sha3, path, simhash -- so one planted
# file carries three independent key columns and each is read on its own.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal:
# a refusal proven only in the passing direction cannot be told from a bypass.
#
# USAGE
#   sh tools/fixtures/t/key_trade_control.sh

set -eu
LC_ALL=C
export LC_ALL

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

# One shell dialect on both piers. GNU sed -i takes no argument and BSD sed -i requires a backup
# suffix, so an in-place edit spelled either way reads empty on the other pier -- and an empty
# reading is indistinguishable from a healthy one. The mutations below edit files in place, so the
# portable helper is sourced rather than the flag typed.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

SCAN="$ROOT/tools/fixtures/t/key_trade_scan.sh"
[ -f "$SCAN" ] || { echo "control: no scan at $SCAN" >&2; exit 2; }

PEN=$(mktemp -d)
trap 'rm -rf "$PEN" "$ROOT/.lap/key-trade-mut" "$ROOT/.lap/key-trade-pen"' EXIT INT TERM

LEGS=0
FAILS=0
leg() {   # leg <name> <expected> <actual>
  LEGS=$((LEGS + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $1 expected=$2 got=$3 ok"
  else
    FAILS=$((FAILS + 1))
    echo "leg $1 expected=$2 got=$3 FAILED"
  fi
}
legnum() {  # legnum <name> <lo> <hi> <actual> -- a number inside a named band
  LEGS=$((LEGS + 1))
  inside=$(awk -v lo="$2" -v hi="$3" -v v="$4" 'BEGIN { print (v >= lo && v <= hi) ? "yes" : "no" }')
  if [ "$inside" = yes ]; then
    echo "leg $1 band=[$2,$3] got=$4 ok"
  else
    FAILS=$((FAILS + 1))
    echo "leg $1 band=[$2,$3] got=$4 FAILED"
  fi
}

# --- the planted populations ---------------------------------------------------------------------
# A deterministic linear congruential generator rather than a random draw, so every leg below
# reproduces exactly. Its constants are Numerical Recipes' 32-bit pair, used here for spread alone
# and for nothing cryptographic.
plant() {   # plant <lines> <seed> <mode> > file
  awk -v n="$1" -v seed="$2" -v mode="$3" '
    function nxt() { s = (s * 1664525 + 1013904223) % 4294967296; return int(s / 65536) % 65536 }
    BEGIN {
      s = seed
      # PAIRED is the share of the population sitting in rooms of two; the rest are singletons.
      # A first draft paired EVERY line, and the related column then read UNEVEN by construction:
      # 512 observations made of 256 exact duplicates carry twice the cell-count variance, so its
      # chi-squared landed near 2 x df whatever the key did. The real strided sample rarely draws
      # two files of one room, which is the shape planted here.
      # And the two members of a room sit FAR APART in the file. The random baseline takes
      # CONSECUTIVE members, so a plant putting room-mates side by side feeds its own related
      # pairs into the baseline it is measured against -- which is how a clustered-and-related
      # population first read "no locality" here: baseline and population were the same pairs.
      paired = 128
      for (i = 1; i <= n; i++) {
        if (i <= paired) { d = "room" i; second = 0 }
        else if (i > n - paired) { d = "room" (i - (n - paired)); second = 1 }
        else { d = "solo" i; second = 0 }
        # column 1 -- uniform, and unrelated even inside a room. The avalanche shape.
        a = nxt()
        # column 2 -- uniform, and a room repeats its first member. Locality without clustering.
        if (second) b = heldb[d]; else { b = nxt(); heldb[d] = b }
        # column 3 -- confined to the low 1024 of the space, and a room repeats its first member.
        # Locality bought with clustering.
        if (second) c = heldc[d]; else { c = nxt() % 1024; heldc[d] = c }
        if (mode == "concentrated") { a = nxt() % 1024; b = nxt() % 1024; c = nxt() % 1024 }
        if (mode == "uniform_unrelated") { b = nxt(); c = nxt() }
        if (mode == "subcell") {
          # The two high bits of each coordinate are uniform and the six low bits are zero: mass
          # spread evenly across the four quadrants and piled into one corner of each. A 2 x 2
          # grid reads this as perfectly even; an 8 x 8 grid reads four occupied cells of 64.
          # This is the population that tells an adaptive grid from a fixed coarse one.
          a = (int(nxt() / 16384) % 4) * 64 * 256 + (int(nxt() / 16384) % 4) * 64
          b = a; c = a
        }
        if (mode == "clustered_related") {
          # every column confined AND every room repeating: adjacency bought with clustering,
          # which is the shape both elder papers predicted a locality key must take.
          if (second) { a = helda[d]; b = heldb[d]; c = heldc[d] }
          else { a = nxt() % 1024; b = nxt() % 1024; c = nxt() % 1024
                 helda[d] = a; heldb[d] = b; heldc[d] = c }
        }
        printf "%04x %04x %04x %s\n", a, b, c, d
      }
    }'
}

plant 512 12345 mixed             > "$PEN/mixed.keys"
plant 512 777   concentrated      > "$PEN/conc.keys"
plant 512 999   uniform_unrelated > "$PEN/flat.keys"
plant 512 2024  subcell           > "$PEN/subcell.keys"

# The one-bit door takes six keys a line, the three of each side. Its shape is planted per
# population, because a population read with an empty one-bit file reports six unread readings per
# key and a verdict that speaks for less than it appears to.
onebit() {  # onebit <lines> <seed> <mode> > file
  awk -v n="$1" -v seed="$2" -v mode="$3" '
    function nxt() { s = (s * 1664525 + 1013904223) % 4294967296; return int(s / 65536) % 65536 }
    BEGIN {
      s = seed
      for (i = 1; i <= n; i++) {
        a1 = nxt(); a2 = nxt()                 # avalanche: the two sides are unrelated
        b  = nxt()                             # same record, same room, same key
        c  = nxt() % 1024; c2 = c + 1          # one bit of drift inside the cluster
        b2 = b
        if (mode == "unrelated") { b = nxt(); b2 = nxt(); c = nxt(); c2 = nxt() }
        if (mode == "clustered") { a1 = nxt() % 1024; a2 = nxt() % 1024 }
        printf "%04x %04x %04x %04x %04x %04x\n", a1, b, c, a2, b2, c2
      }
    }'
}
onebit 96 4242 mixed     > "$PEN/mixed.onebit"
onebit 96 5151 unrelated > "$PEN/flat.onebit"
onebit 96 6262 clustered > "$PEN/lumpy.onebit"

run() { sh "$SCAN" "$@" 2>&1; }

# Every reading below is lifted by KEY rather than by field position. A first draft read $6 and
# $13, and eight legs then reported a neighbouring token -- side= where verdict= was wanted -- so
# the control was measuring its own arithmetic rather than the scan.
kv() {  # kv <file> <line selector> <key>
  awk -v sel="$2" -v key="$3" '
    $0 ~ sel {
      for (i = 1; i <= NF; i++) {
        n = index($i, "=")
        if (n > 0 && substr($i, 1, n - 1) == key) { print substr($i, n + 1); exit }
      }
      exit
    }' "$1"
}

# --- part 1: the mixed population, where each column is a different shape ------------------------
run --keys "$PEN/mixed.keys" --onebit-keys "$PEN/mixed.onebit" > "$PEN/mixed.out"

leg instrument_named "instrument=key_trade" "$(head -1 "$PEN/mixed.out")"
leg mixed_verdict "verdict=both_available" "$(grep '^verdict=' "$PEN/mixed.out")"

leg col1_even "yes" "$(kv "$PEN/mixed.out" '^key sha3 '    even)"
leg col2_even "yes" "$(kv "$PEN/mixed.out" '^key path '    even)"
leg col3_even "no"  "$(kv "$PEN/mixed.out" '^key simhash ' even)"

leg col1_adjacent "no"  "$(kv "$PEN/mixed.out" '^key_verdict sha3 '    adjacent)"
leg col2_adjacent "yes" "$(kv "$PEN/mixed.out" '^key_verdict path '    adjacent)"
leg col3_adjacent "yes" "$(kv "$PEN/mixed.out" '^key_verdict simhash ' adjacent)"
leg col3_uneven   "no"  "$(kv "$PEN/mixed.out" '^key_verdict simhash ' even)"

leg mixed_tally "keys_read=3 even=2 adjacent=2 both=1 unread_populations=0" \
  "$(grep '^keys_read=' "$PEN/mixed.out")"

# --- part 2: the three closed forms, proven on a uniform column ----------------------------------
# The scan states three expectations for uniform 16-bit keys and derives each in its own header:
# torus 128, ring 16384, hamming 8. A planted uniform population is what proves the derivations.
rtorus=$(kv "$PEN/mixed.out" '^pop sha3 random torus '   mean)
rring=$( kv "$PEN/mixed.out" '^pop sha3 random ring '    mean)
rham=$(  kv "$PEN/mixed.out" '^pop sha3 random hamming ' mean)
legnum closed_form_torus   118 138   "$rtorus"
legnum closed_form_ring  15000 17800 "$rring"
legnum closed_form_hamming  7.4 8.6  "$rham"

# The uniform column must read INDISTINGUISHABLE against each closed form, which is the other half
# of the same proof: a derivation that the reading cannot confirm is a derivation nobody checked.
leg closed_form_torus_verdict   "indistinguishable" "$(kv "$PEN/mixed.out" '^pop sha3 random torus '   verdict)"
leg closed_form_ring_verdict    "indistinguishable" "$(kv "$PEN/mixed.out" '^pop sha3 random ring '    verdict)"
leg closed_form_hamming_verdict "indistinguishable" "$(kv "$PEN/mixed.out" '^pop sha3 random hamming ' verdict)"

# --- part 3: the contrast reading, and the false positive it exists to refuse ---------------------
# The concentrated population sits far from every closed form and carries NO relation. Read against
# the closed form its related pairs look nearer; read against its own baseline they do not. Both
# readings are printed, and the control asserts they DISAGREE -- which is the whole reason the
# adjacency verdict takes the second.
run --keys "$PEN/conc.keys" > "$PEN/conc.out"

leg conc_closed_form_says_nearer "distinguishable" "$(kv "$PEN/conc.out" '^pop sha3 samedir torus ' verdict)"
leg conc_closed_form_side       "nearer"          "$(kv "$PEN/conc.out" '^pop sha3 samedir torus ' side)"
leg conc_contrast_says_no       "indistinguishable" "$(kv "$PEN/conc.out" '^contrast sha3 samedir torus ' verdict)"
leg conc_not_adjacent           "no"              "$(kv "$PEN/conc.out" '^key_verdict sha3 ' adjacent)"
leg conc_verdict "verdict=no_locality" "$(grep '^verdict=' "$PEN/conc.out")"

# --- part 4: a population with no relation in any column -----------------------------------------
run --keys "$PEN/flat.keys" --onebit-keys "$PEN/flat.onebit" > "$PEN/flat.out"
leg flat_verdict "verdict=no_locality" "$(grep '^verdict=' "$PEN/flat.out")"
leg flat_tally "keys_read=3 even=3 adjacent=0 both=0 unread_populations=0" "$(grep '^keys_read=' "$PEN/flat.out")"

# --- part 5: adjacency WITHOUT evenness reads trade_holds ----------------------------------------
# Every column clustered into the low 1024 and every room repeating its first member: related in
# all three columns, even in none. This is the shape the elder papers predicted and it must be
# told apart from both_available by name.
plant 512 31337 clustered_related > "$PEN/lumpy.keys"
run --keys "$PEN/lumpy.keys" --onebit-keys "$PEN/lumpy.onebit" > "$PEN/lumpy.out"
leg lumpy_verdict "verdict=trade_holds" "$(grep '^verdict=' "$PEN/lumpy.out")"
leg lumpy_tally "keys_read=3 even=0 adjacent=3 both=0 unread_populations=0" "$(grep '^keys_read=' "$PEN/lumpy.out")"

# --- part 6: refusals --------------------------------------------------------------------------
set +e
run --nosuchflag > "$PEN/flag.out" 2>&1; flagcode=$?
run --keys "$PEN/absent.keys" > "$PEN/absent.out" 2>&1; abscode=$?
set -e
leg unknown_flag_exit "2" "$flagcode"
leg missing_keys_exit "2" "$abscode"

printf '%s\n' "aaaa bbbb cccc room0" "dddd eeee ffff room0" > "$PEN/tiny.keys"
leg too_few_unreadable "verdict=unreadable" "$(run --keys "$PEN/tiny.keys" | grep '^verdict=')"

: > "$PEN/empty.keys"
leg empty_unreadable "verdict=unreadable" "$(run --keys "$PEN/empty.keys" | grep '^verdict=')"

# --- part 7: the real hashing path, on a pen tree -------------------------------------------------
# The --keys door proves the arithmetic. This proves the three key FUNCTIONS, which that door skips
# entirely: a control that only ever plants keys never runs the hashing it exists to check.
mkdir -p "$PEN/tree/alpha" "$PEN/tree/beta"
# Each document runs to forty lines, and the length is the point. A SimHash over ten tokens moves
# several accumulator signs when one token changes, so a short pen document reads its one-byte edit
# as FARTHER than random -- which a first draft planted and then had to explain. The bound the scan
# names is 512 tokens; a document wants enough of them that one changed token is a small vote.
i=0
while [ "$i" -lt 12 ]; do
  j=0
  : > "$PEN/tree/alpha/doc$i.txt"
  : > "$PEN/tree/beta/doc$i.txt"
  while [ "$j" -lt 40 ]; do
    printf 'alpha room document %d line %d about grain bounded rings and wrapped circumference\n' "$i" "$j" >> "$PEN/tree/alpha/doc$i.txt"
    printf 'beta room document %d line %d concerning caravan supervision tally widths and rye\n' "$i" "$j" >> "$PEN/tree/beta/doc$i.txt"
    j=$((j + 1))
  done
  i=$((i + 1))
done
( cd "$PEN/tree" && find . -type f | sed 's#^\./##' | sort ) > "$PEN/tree.paths"
leg pen_tree_files "24" "$(wc -l < "$PEN/tree.paths" | tr -d ' ')"

# The scan resolves paths against the TREE ROOT, so the pen list is given root-relative names by
# copying the pen tree into an ignored directory under the root. .lap/ is the per-lap scratch room
# the read-scope law names, gitignored and per ship.
mkdir -p "$ROOT/.lap/key-trade-pen"
rm -rf "$ROOT/.lap/key-trade-pen/tree"
cp -R "$PEN/tree" "$ROOT/.lap/key-trade-pen/tree"
sed 's#^#.lap/key-trade-pen/tree/#' "$PEN/tree.paths" > "$PEN/tree.rel"
run --paths "$PEN/tree.rel" --names 64 --onebit 8 --samedir 24 > "$PEN/tree.out"
rm -rf "$ROOT/.lap/key-trade-pen"

leg tree_read  "24" "$(kv "$PEN/tree.out" '^population=' names)"
leg tree_rooms "2"  "$(kv "$PEN/tree.out" '^rooms ' distinct_directories)"

# The path key files two documents of one room at one x coordinate, by construction, so the same
# directory population must read nearer in the torus metric against its own baseline.
leg tree_path_adjacent "yes" "$(kv "$PEN/tree.out" '^key_verdict path ' adjacent)"
# The digest avalanches over documents differing in one byte, so its one-bit population must not.
leg tree_sha3_onebit_hamming "indistinguishable" "$(kv "$PEN/tree.out" '^contrast sha3 onebit hamming ' verdict)"
# The SimHash of a document and the same document with its first byte changed must sit nearer.
leg tree_simhash_onebit_nearer "nearer" "$(kv "$PEN/tree.out" '^contrast simhash onebit hamming ' side)"
leg tree_simhash_onebit_real   "distinguishable" "$(kv "$PEN/tree.out" '^contrast simhash onebit hamming ' verdict)"

# --- part 8: mutations ---------------------------------------------------------------------------
# Each mutation is applied to a COPY of the scan inside the pen and run against the population that
# should bite it. A mutation that changes no reading is a reading nobody depends on.
# THE MUTANT LIVES UNDER THE TREE ROOT, and the placement is the whole correctness of this part.
# The scan finds its root by walking up from its own location for a directory holding rishi/bin
# and tools/fixtures, and a copy in the system temporary directory finds neither: it exits 2 with
# "no tree root within 8 steps" before it reads a single flag. A first draft copied the mutants
# there and every one of the four "bites" was that walk failing -- four legs proving the scan can
# be broken by moving it. So the mutants sit in .lap/, the gitignored per-lap scratch room, and
# a SHAM leg below runs an UNMUTATED copy from the same place: unless that copy still answers, a
# bite here says nothing.
MUTROOM="$ROOT/.lap/key-trade-mut"
mkdir -p "$MUTROOM"
cleanup_mut() { rm -rf "$MUTROOM"; }

mutate() {  # mutate <name> <sed program> <keys file> <grep pattern that must DISAPPEAR>
  cp "$SCAN" "$MUTROOM/mut.sh"
  sed_inplace "$2" "$MUTROOM/mut.sh"
  out=$(sh "$MUTROOM/mut.sh" --keys "$3" 2>&1 || true)
  LEGS=$((LEGS + 1))
  if printf '%s' "$out" | grep -q "$4"; then
    FAILS=$((FAILS + 1))
    echo "leg mutation_$1 expected=bite got=no_bite FAILED"
  elif ! printf '%s' "$out" | grep -q '^instrument=key_trade$'; then
    # The mutant did not merely answer differently -- it failed to answer at all, which is the
    # false bite this room exists to refuse.
    FAILS=$((FAILS + 1))
    echo "leg mutation_$1 expected=bite got=crash FAILED"
  else
    echo "leg mutation_$1 expected=bite got=bite ok"
  fi
}

# The sham: an unmutated copy in the mutant room must answer exactly as the scan does in place.
cp "$SCAN" "$MUTROOM/sham.sh"
leg mutant_room_carries_the_scan "verdict=both_available" \
  "$(sh "$MUTROOM/sham.sh" --keys "$PEN/mixed.keys" --onebit-keys "$PEN/mixed.onebit" 2>&1 | grep '^verdict=')"

# 1. The adjacency verdict reading the closed-form pop lines instead of the contrast lines. The
#    concentrated population is exactly what tells the two apart: it reads nearer against 128 and
#    flat against its own baseline, so this mutation turns its honest "no locality" into a claim.
mutate closed_form_adjacency 's/\$1 == "contrast" \&\& \$2 == k/$1 == "pop" \&\& $2 == k \&\& ($3 == "samedir" || $3 == "onebit")/' \
  "$PEN/conc.keys" 'verdict=no_locality'

# 2. The torus wrap dropped, so each axis measures plain difference rather than circular distance.
#    A uniform population then reads a mean near 85 rather than 128 and stops matching its own
#    closed form.
mutate torus_wrap_dropped 's/if (d > 128) d = 256 - d; return d/return d/' \
  "$PEN/flat.keys" 'pop sha3 random torus.*verdict=indistinguishable'

# 3. The evenness grid fixed at 2x2 rather than chosen from the sample size. The subcell
#    population is what tells the two apart: its mass is spread evenly across the four quadrants
#    and piled into one corner of each, so four cells see nothing and sixty-four see everything.
#    The lumpy population would NOT catch this, and a first draft aimed it there and read no bite:
#    a cluster inside 1024 of 65536 reddens a 2 x 2 grid too.
leg subcell_uneven_at_eight "no" "$(run --keys "$PEN/subcell.keys" | kv /dev/stdin '^key sha3 ' even)"
mutate fixed_coarse_grid 's/for (t = 16; t >= 2; t = int(t \/ 2)) if (n \/ (t \* t) >= 5) { g = t; break }/g = 2/' \
  "$PEN/subcell.keys" 'key sha3 .*even=no'

# 4. The FNV multiply taken whole rather than split into 16-bit halves. This one is proven on the
#    REAL path rather than through --keys, since the door skips hashing entirely -- so it runs
#    separately below.
cp "$SCAN" "$MUTROOM/mut4.sh"
sed_inplace 's/return ((hi \* 16777619 % 65536) \* 65536 + lo \* 16777619) % 4294967296/return (h * 16777619) % 4294967296/' "$MUTROOM/mut4.sh"
mkdir -p "$ROOT/.lap/key-trade-pen"
cp -R "$PEN/tree" "$ROOT/.lap/key-trade-pen/tree"
mut4=$(sh "$MUTROOM/mut4.sh" --paths "$PEN/tree.rel" --names 64 --onebit 8 --samedir 24 2>&1 || true)
rm -rf "$ROOT/.lap/key-trade-pen"
printf '%s\n' "$mut4" > "$PEN/mut4.out"
mut4keys=$(kv "$PEN/mut4.out" '^key path ' distinct_keys)
base4keys=$(kv "$PEN/tree.out" '^key path ' distinct_keys)
LEGS=$((LEGS + 1))
if [ "${mut4keys:-x}" = "${base4keys:-y}" ]; then
  FAILS=$((FAILS + 1))
  echo "leg mutation_fnv_overflow expected=bite got=no_bite baseline=$base4keys mutated=$mut4keys FAILED"
else
  echo "leg mutation_fnv_overflow expected=bite got=bite baseline=$base4keys mutated=$mut4keys ok"
fi

cleanup_mut

echo "instrument=key_trade_control"
echo "legs=$LEGS failures=$FAILS"
if [ "$FAILS" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
