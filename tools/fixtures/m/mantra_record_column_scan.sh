#!/bin/sh
# tools/fixtures/m/mantra_record_column_scan.sh -- which column is which, read off the bytes.
#
# WHAT THIS READS, and the fault it exists for. A record's columns carry meaning by POSITION
# alone: the fourth number on a row is the run because the writer put it fourth and the reader
# takes it fourth. Move both together -- which is what a hand reordering a record does -- and the
# format's meaning changes while every round trip stays perfectly clean, because the store is
# self-consistent. Every store written before that day is then misread forever, in silence.
#
# MEASURED on this tree rather than argued. Planting each of the ten pairwise column swaps in
# BOTH the writer tuple of `serialize_weave` and the reader row of `read_order_record`, then
# running the standing guard at tools/fixtures/m/mantra_cli_record_scan.sh against a
# dereferenced copy of mantra/src/: its output is BYTE-IDENTICAL on all ten. Nothing in this tree
# could see a record change its own meaning.
#
# TWO HALVES, EACH ABOUT ONE THING.
#
#   The COLUMN PROFILES read the record's bytes against what each column is known to be. This is
#   the only reading in this tree that sees a self-consistent swap of the CLI's record -- the
#   module-level guard at tools/m/mantra_weave_order_record_witness.rish reads mantra/src/weave.rye
#   and never main.rye, and every other reading compares rendered text. It also names WHICH two
#   columns moved rather than reporting that something did.
#
#   The ROUND TRIP reads the document back out through the CLI's own reader. This is what sees a
#   swap planted on ONE side, where the writer and the reader have drifted apart -- a case the
#   profiles cannot always reach, since a one-sided swap can leave the record's own shape intact.
#
# WHY THE ELDER PEN COULD SEE NEITHER. A fresh store commits once, so its record rows read
# `1 0 0 0 0 alpha`: of the five numeric columns gen, pos, site, run and ord, THREE carry a
# constant zero and the remaining two carry the same rising sequence. Four of the ten one-sided
# swaps travel free through that pen -- pos-site, pos-ord, site-run and site-ord -- on the writer
# side, and the same four on the reader side, since one data shape blinds both halves.
#
# THE CURE IS DATA RATHER THAN A NEW RULE. A second commit carrying a REPLACEMENT gives the
# columns profiles that differ:
#
#   column  field  values          distinct  nondecreasing  all zero
#   1       gen    1 2 1 1 1 1     no        no             no
#   2       pos    0 1 4 2 5 3     yes       no             no
#   3       site   0 0 0 0 0 0     no        yes            yes
#   4       run    0 0 0 0 0 0     no        yes            yes
#   5       ord    0 1 1 2 2 3     no        yes            no
#
# Three primitive readings per column, and four distinct profiles over five columns. An
# append-only second commit earns neither the second gen nor the repeated order key, so the
# replacement is the whole of what makes this pen able to see.
#
# THE ONE PAIR THIS CANNOT SEPARATE, named rather than hidden. Columns 3 and 4 share a profile,
# and no store this scan can write will part them: `site` rises only when two hands meet in a
# history and `run` only beside it, and the CLI exposes no merge -- `mantra` offers init, brix,
# add, log, status, annotate and version, and not one of them makes a second site. So a site-run
# swap is invisible here BY CONSTRUCTION, in all three families. The control plants it and this
# guard asserts the blindness as hard as it asserts the catches, because a bound a guard states
# and never checks is a bound that rots quietly. The module-level guard at
# tools/m/mantra_weave_order_record_witness.rish is where that pair is separated, and it catches
# exactly this swap as its own centrepiece.
#
# THE PROFILES ARE READ, NEVER ASSUMED. Every reading below is computed off the record's own
# bytes and printed; the witness asserts the expected profile. A lawful change to how mantra
# assigns positions or order keys moves a reading and reds this guard, which is the intent: a
# column identity check whose expectations are derived from the run it is checking would prove
# nothing at all.
#
# Run from the repository root:
#   sh tools/fixtures/m/mantra_record_column_scan.sh [<path to main.rye>]

set -eu

_sp_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_sp_steps=0
while [ ! -d "$_sp_root/rishi/src" ] || [ ! -d "$_sp_root/tools/fixtures" ]; do
  _sp_steps=$((_sp_steps + 1))
  if [ "$_sp_steps" -gt 8 ] || [ "$_sp_root" = "/" ] || [ -z "$_sp_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _sp_root=$(dirname "$_sp_root")
done
. "$_sp_root/tools/fixtures/s/shell_portable.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
main_src="${1:-$root/mantra/src/main.rye}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

bin="$work/mantra"
if env RYE_ZIG="$zig" "$rye" build "$main_src" -femit-bin="$bin" >/dev/null 2>&1; then
  echo "built=yes"
else
  echo "built=no"
  echo "verdict=red"
  exit 0
fi

verdict=ok
note_red() { verdict=red; }

# --- a store whose columns can be told apart: two commits, the second a replacement ---
#
# The replacement is what earns the second gen and the repeated order key. An append-only second
# commit raises neither: every line keeps gen 1 and every order key stays distinct, which is the
# elder pen's blindness with one more row in it.
pen="$work/store"
mkdir -p "$pen"
printf 'alpha\nbeta\ngamma\n' > "$pen/f.txt"
( cd "$pen" && "$bin" init >/dev/null 2>&1 && "$bin" add f.txt >/dev/null 2>&1 ) || note_red
printf 'alpha\nBETA\ngamma\ndelta\n' > "$pen/f.txt"
( cd "$pen" && "$bin" add f.txt >/dev/null 2>&1 ) || note_red

# THE BLOB IS CHOSEN BY ROW COUNT, never by glob order. A blob's filename is its digest, so the
# glob returns the two weave blobs in an order the content decides and nothing else -- reading
# "the first one" would read whichever commit happened to hash lower. The weave accretes, so the
# second commit's record is strictly the longer one; the scan asserts there are exactly two and
# that their lengths differ, so the choice is determined rather than lucky.
weaves=0
record=""
record_rows=0
for b in "$pen"/.mantra/blobs/*; do
  [ -f "$b" ] || continue
  case "$(head -1 "$b")" in mantra-weave-*) ;; *) continue ;; esac
  weaves=$((weaves + 1))
  n=$(sed -n '3,$p' "$b" | wc -l | tr -d ' ')
  if [ "$n" -gt "$record_rows" ]; then record_rows="$n"; record="$b"; fi
done
echo "weave_blobs=$weaves"
echo "record_rows=$record_rows"
if [ "$weaves" -ne 2 ] || [ -z "$record" ]; then
  echo "header=none"
  echo "verdict=red"
  exit 0
fi
echo "header=$(head -1 "$record")"

# --- three primitive readings per numeric column, computed off the bytes ---
#
# `distinct` -- every value in the column differs from every other.
# `nondec`   -- the column never falls as the rows are read in blob order.
# `zero`     -- every value is zero.
#
# Read in ONE awk pass per column rather than three, so a column is read from one traversal of
# one file and the three readings cannot disagree about which rows they saw.
column_profile() {
  awk -v col="$1" -F'\t' '
    NR > 2 && NF >= 6 {
      v = $col + 0
      n++
      if (seen[v]++) dup = 1
      if (n > 1 && v < prev) fell = 1
      if (v != 0) nonzero = 1
      if (v > max) max = v
      prev = v
    }
    END {
      printf "rows=%d distinct=%s nondec=%s zero=%s max=%d\n", n, \
        (dup ? "no" : "yes"), (fell ? "no" : "yes"), (nonzero ? "no" : "yes"), max
    }' "$2"
}

i=1
while [ "$i" -le 5 ]; do
  echo "col${i} $(column_profile "$i" "$record")"
  i=$((i + 1))
done

# --- the profile classes, counted ---
#
# Two columns share a class when all three readings agree. The count is what says how much of the
# record this pen can actually distinguish, and it is printed rather than assumed: today it reads
# four classes over five columns, with site and run sharing one for the structural reason the
# header gives.
classes=$(
  i=1
  while [ "$i" -le 5 ]; do
    column_profile "$i" "$record" | sed 's/rows=[0-9]* //; s/ max=[0-9]*//'
    i=$((i + 1))
  done | sort -u | wc -l
)
echo "profile_classes=$(echo "$classes" | tr -d ' ')"

# --- the roundtrip, over the same store ---
#
# A column swap planted in the READER moves no byte in the record, so the readings above cannot
# see it. What sees it is the document coming back: the order key drives the sort, so a reader
# taking the position for the order key renders the replaced line at the end of the document.
# The file on disk is untouched between the last commit and this read, so an honest reader
# reports nothing changed.
if ( cd "$pen" && "$bin" status f.txt >"$work/status.out" 2>&1 ); then
  echo "status_reads=yes"
else
  echo "status_reads=no"
  note_red
fi
echo "status=$(sed -n '1p' "$work/status.out" | sed 's/^mantra status: //')"

if ( cd "$pen" && "$bin" annotate f.txt >"$work/annotate.out" 2>&1 ); then
  echo "annotate_reads=yes"
else
  echo "annotate_reads=no"
  note_red
fi
# The live document's own text, in the order `annotate` renders it. This is the reading that
# sees a swap planted in the READER, which moves no byte in the record and so leaves every column
# profile above exactly where it stood. The tombstoned `beta` is absent on purpose: annotate
# renders the present view, and its summary line below is where the tombstone is counted.
echo "document_order=$(grep -oE '(alpha|beta|BETA|gamma|delta)$' "$work/annotate.out" | tr '\n' ',' | sed 's/,$//')"
echo "annotate=$(grep -o -- '-- .*' "$work/annotate.out" | head -1)"

# THE BOUND THIS SCAN STATES OUT LOUD. Columns 3 and 4 share a profile and no store written here
# can separate them, for the reason the header gives: the CLI exposes no merge, so site and run
# stay zero on every row it can write. Printed rather than left in a comment, so a reader meets
# the bound in the same output as the readings it limits.
echo "blind_pair=site,run"
echo "blind_reason=the CLI exposes no merge, so no store it writes carries a site or a run above zero"

echo "verdict=$verdict"
