#!/bin/sh
# tools/fixtures/t/torus_fold_control.sh -- proves tools/fixtures/t/torus_fold_scan.sh reads.
#
# WHAT A CONTROL IS FOR HERE. The scan's live reading says the fold is even and carries no
# relation. A reading that can only ever say that is not a reading -- so every branch is planted
# and then lifted: a population that DOES cluster, a related population that DOES sit near, and
# the even case beside them, each produced deliberately and each recognised by name.
#
# THE PLANTS ARE DIGESTS RATHER THAN FILES, through the scan's --digests door. Mining real files
# whose SHA3-512 digests cluster would be hours of hashing to prove a property of the arithmetic,
# and the arithmetic is what is under test.
#
# It also checks two closed forms the scan rests on, since a closed form quoted from memory is a
# constant nobody measured: the toroidal mean of 128, and the Wilson-Hilferty critical value
# against published chi-squared tables at two degrees of freedom.
#
# THREE MUTATIONS are applied to a copy of the scan and asserted to change its answer, because a
# check that passes on a broken instrument is a check that proves nothing.
#
# USAGE  sh tools/fixtures/t/torus_fold_control.sh
# Prints one "leg <name> <yes|no>" line per behavior, then legs_expected and control_verdict.

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ]; then echo "$0: no tree root" >&2; exit 2; fi
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/t/torus_fold_scan.sh"
. "$ROOT/tools/fixtures/s/shell_portable.sh"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

LEGS=0
FAIL=0
leg() { LEGS=$((LEGS + 1)); printf 'leg %s %s\n' "$1" "$2"; [ "$2" = yes ] || FAIL=$((FAIL + 1)); }

# --- the plants -------------------------------------------------------------------------------
# A digest here is 128 hex characters; only the bytes a fold reads carry meaning, so the rest are
# filled with a fixed pattern. Byte 0 and byte 1 are the off=0 fold; bytes 30 and 31 the off=30.
# A digest here is 128 hex characters; only the bytes a fold reads carry meaning, so the rest are
# filled with zeros. Byte 0 and byte 1 are the off=0 fold; bytes 30 and 31 the off=30. Built in one
# awk pass per fixture rather than a shell loop, because 64 printf calls per name over four
# fixtures is minutes of process spawning to produce a few kilobytes.
plant() {
  awk -v kind="$1" '
    function name(x0, y0, x30, y30, dir,   s, i) {
      s = sprintf("%02x%02x", x0, y0)
      for (i = 2; i < 30; i++) s = s "00"
      s = s sprintf("%02x%02x", x30, y30)
      for (i = 32; i < 64; i++) s = s "00"
      return s (dir == "" ? "" : " " dir)
    }
    # A deterministic linear congruential generator rather than awk rand(), whose seeding differs
    # between implementations -- the pen must plant the same population on every host.
    function rnd(   ) { seed = (seed * 1103515245 + 12345) % 2147483648; return int(seed / 65536) % 256 }
    BEGIN {
      seed = 20260912
      if (kind == "even") {
        # 512 names drawn pseudorandomly over the whole square on both folds.
        # PSEUDORANDOM RATHER THAN A LATTICE, and the difference is the whole leg: a perfect
        # lattice is even by chi-squared AND has every pair at an identical distance, so its
        # standard error is zero and every population reads as an effect. An even fold means
        # scattered, not regular, and the plant has to mean the same thing the claim does.
        for (i = 0; i < 512; i++)
          print name(rnd(), rnd(), rnd(), rnd(), "d" int(i / 2))
      } else if (kind == "clustered") {
        # the same count drawn pseudorandomly inside a 16-wide corner, on both folds
        for (i = 0; i < 512; i++) {
          x = rnd() % 16; y = rnd() % 16
          print name(x, y, x, y, "d" int(i / 2))
        }
      } else if (kind == "related") {
        # an even spread whose same-directory partner sits one cell away -- the shape a name
        # carrying relation would give, which a cryptographic digest cannot
        for (i = 0; i < 256; i++) {
          x = rnd(); y = rnd(); u = rnd(); v = rnd()
          print name(x, y, u, v, "d" i)
          print name((x + 1) % 256, (y + 1) % 256, (u + 1) % 256, (v + 1) % 256, "d" i)
        }
      } else if (kind == "onebit_near") {
        # pairs whose two digests sit adjacent -- a NON-avalanching name
        for (i = 0; i < 96; i++) {
          x = rnd(); y = rnd(); u = rnd(); v = rnd()
          printf "%s %s\n", name(x, y, u, v, ""), \
            name((x + 1) % 256, (y + 1) % 256, (u + 1) % 256, (v + 1) % 256, "")
        }
      }
    }'
}

plant even        > "$PEN/even"
plant clustered   > "$PEN/clustered"
plant related     > "$PEN/related"
plant onebit_near > "$PEN/onebit_near"

# --- reading the plants -----------------------------------------------------------------------
run() { sh "$SCAN" --digests "$1" ${2:+--dir-digests "$2"} ${3:+--onebit-digests "$3"} 2>&1; }

run "$PEN/even" > "$PEN/out_even"
grep -q 'verdict=even_and_uninformative' "$PEN/out_even" && leg even_reads_uninformative yes || leg even_reads_uninformative no
grep -q 'clusters_folds=0 of=2' "$PEN/out_even" && leg even_clusters_zero yes || leg even_clusters_zero no
grep -q 'related_distinguishable=0' "$PEN/out_even" && leg even_no_related_effect yes || leg even_no_related_effect no

run "$PEN/clustered" > "$PEN/out_clustered"
grep -q 'verdict=clusters' "$PEN/out_clustered" && leg clustered_fires_falsifier yes || leg clustered_fires_falsifier no
grep -q 'clusters_folds=2 of=2' "$PEN/out_clustered" && leg clustered_both_folds yes || leg clustered_both_folds no
grep -q 'fold_verdict off=0 clusters=yes' "$PEN/out_clustered" && leg clustered_names_fold_zero yes || leg clustered_names_fold_zero no
grep -q 'fold_verdict off=30 clusters=yes' "$PEN/out_clustered" && leg clustered_names_fold_thirty yes || leg clustered_names_fold_thirty no

run "$PEN/even" "$PEN/related" > "$PEN/out_related"
grep -q 'verdict=adjacency_informative' "$PEN/out_related" && leg related_reads_informative yes || leg related_reads_informative no
grep -qE '^pop samedir off=0 .*verdict=distinguishable' "$PEN/out_related" && leg related_samedir_distinguishable yes || leg related_samedir_distinguishable no
grep -qE '^pop random off=0 .*verdict=indistinguishable' "$PEN/out_related" && leg related_random_still_even yes || leg related_random_still_even no

run "$PEN/even" "" "$PEN/onebit_near" > "$PEN/out_onebit"
grep -q 'verdict=adjacency_informative' "$PEN/out_onebit" && leg onebit_near_reads_informative yes || leg onebit_near_reads_informative no
grep -qE '^pop onebit off=0 .*verdict=distinguishable' "$PEN/out_onebit" && leg onebit_near_distinguishable yes || leg onebit_near_distinguishable no

# The three verdicts are distinct words, so a reader can tell them apart.
a=$(grep '^verdict=' "$PEN/out_even"); b=$(grep '^verdict=' "$PEN/out_clustered"); c=$(grep '^verdict=' "$PEN/out_related")
[ "$a" != "$b" ] && [ "$b" != "$c" ] && [ "$a" != "$c" ] && leg three_verdicts_distinct yes || leg three_verdicts_distinct no

# Clustering is reported ahead of adjacency: a population that both clusters and adjoins is named
# by its falsifier, since a fired falsifier settles the row whatever else is true.
run "$PEN/clustered" "$PEN/related" > "$PEN/out_both"
grep -q 'verdict=clusters' "$PEN/out_both" && leg falsifier_outranks_adjacency yes || leg falsifier_outranks_adjacency no

# An absent population is UNREAD rather than clean.
grep -q 'unread_populations=2' "$PEN/out_even" && leg unread_named yes || leg unread_named no

# --- the closed forms -------------------------------------------------------------------------
# The toroidal per-axis mean is exactly 64 over a full residue class, so a pair mean is 128.
tm=$(awk 'BEGIN{s=0; for(d=0;d<256;d++){v=d; if(v>128)v=256-v; s+=v} printf "%.6f", s/256}')
[ "$tm" = "64.000000" ] && leg toroidal_axis_mean_is_64 yes || leg toroidal_axis_mean_is_64 no

# Wrap: 0 and 255 are one apart, not 255 apart. The whole point of a torus.
wrapd=$(awk 'BEGIN{d=0-255; if(d<0)d=-d; if(d>128)d=256-d; print d}')
[ "$wrapd" = "1" ] && leg wrap_makes_0_and_255_adjacent yes || leg wrap_makes_0_and_255_adjacent no

# Wilson-Hilferty against published chi-squared p=0.001 upper critical values.
# df=15 -> 37.697, df=63 -> 103.442, df=255 -> 330.520. Within one percent is the standard held.
chk() {
  got=$(awk -v df="$1" 'BEGIN{z=3.0902;a=2.0/(9.0*df);b=1.0-a+z*sqrt(a);printf "%.4f", df*b*b*b}')
  ok=$(awk -v g="$got" -v w="$2" 'BEGIN{d=g-w; if(d<0)d=-d; print (d/w < 0.01) ? "yes" : "no"}')
  leg "chi_critical_df$1" "$ok"
}
chk 15 37.697
chk 63 103.442
chk 255 330.520

# The grid adapts, and its expected count never falls under five.
gline=$(grep -m1 '^fold off=0 ' "$PEN/out_even")
echo "$gline" | grep -q 'grid=8x8 df=63' && leg grid_adapts_to_512_names yes || leg grid_adapts_to_512_names no
epc=$(echo "$gline" | sed -n 's/.*expected_per_cell=\([0-9.]*\).*/\1/p')
awk -v e="$epc" 'BEGIN{exit (e >= 5) ? 0 : 1}' && leg expected_per_cell_at_least_5 yes || leg expected_per_cell_at_least_5 no

# --- the mutations ------------------------------------------------------------------------------
# Each edits a copy of the scan and asserts the answer MOVES. A mutation that changes nothing means
# the line it touched was carrying nothing.
# A mutated copy runs from a STUB TREE inside the pen rather than from the pen root, because the
# scan resolves its own root by walking up for rishi/bin and tools/fixtures and refuses when it
# finds neither. Giving the pen that shape both lets the mutation run and proves the walk works
# outside a repository, which is the case the shim's own header says it was written for.
mkdir -p "$PEN/stub/rishi/bin" "$PEN/stub/tools/fixtures/t"
mutate() { # name sed-script fixture expect-grep
  cp "$SCAN" "$PEN/stub/tools/fixtures/t/mut.sh"
  sed_inplace "$2" "$PEN/stub/tools/fixtures/t/mut.sh"
  if cmp -s "$SCAN" "$PEN/stub/tools/fixtures/t/mut.sh"; then
    # A mutation that changed no byte proves nothing, and reads exactly like one that changed
    # nothing that mattered. Named apart so the two are never confused.
    leg "mutation_$1_applied" no
    return
  fi
  leg "mutation_$1_applied" yes
  out=$(sh "$PEN/stub/tools/fixtures/t/mut.sh" --digests "$3" 2>&1 || true)
  if printf '%s' "$out" | grep -q "$4"; then leg "mutation_$1" yes; else leg "mutation_$1" no; fi
}

# 1. Drop the wrap: distance becomes linear, so an EVEN population's own baseline drifts off 128
#    and the scan calls a perfectly even fold distinguishable.
mutate no_wrap 's|if (d > 128) d = 256 - d; return d|return d|' "$PEN/even" 'pop random off=0 .*verdict=distinguishable'

# 2. Reuse every point in every pair: the standard error collapses by a factor of the sample size,
#    so a benign fluctuation is called an effect. This is why the pairs are disjoint.
mutate all_pairs 's|se = sqrt(v / c)|se = sqrt(v / (c * c))|' "$PEN/even" 'verdict=adjacency_informative'

# 3. Raise the critical value out of reach: a genuinely clustered population walks free.
mutate blind_critical 's|return df \* b \* b \* b|return 1000000|' "$PEN/clustered" 'clusters_folds=0'

echo "legs_expected=$LEGS"
echo "fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
