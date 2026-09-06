#!/bin/sh
# tools/fixtures/c/copy_lag_scan.sh -- a copy standing where its siblings link, measured.
#
# WHY THIS READING EXISTS. Zig admits an import only from the root file's own directory, so one
# implementation reaches two rooms here by SYMLINK -- `linengrow/capabilities.rye` is mode 120000
# onto `caravan/capabilities.rye`, and fourteen rooms link `tally/copy.rye` the same way. Where a
# room keeps a regular file under a basename its siblings link, that file is the one path that can
# fall behind the implementation in silence, and nothing reads it: `copy_sameness_scan.sh` guards
# exactly one basename, `tally_copy.rye`, with its canon spelled in the script.
#
# WHAT IT MEASURES. Every tracked `.rye` basename held BOTH ways -- at least one index mode 120000
# and at least one regular file. For each such basename the canon is what the symlinks resolve to,
# and every OTHER regular file under that name is a copy. Each copy is compared to the canon by
# bytes, and where the bytes differ, by published surface:
#
#   behind   the copy publishes nothing its canon lacks, and the bytes differ -- a lag
#   sibling  the copy publishes something its canon lacks -- a different module sharing a word
#
# `behind` is the gated ratchet and only ever falls. `sibling` is reported, because
# `lotus/fold.rye` folds a waveform where `mycelium/fold.rye` folds a ledger, and that is two
# modules rather than one drifting.
#
# WHY THE CANON IS EXCLUDED FROM THE COPY COUNT, which is the correction that built this script.
# The audit at active-designing/20260906-003146 published *108 byte-identical, 5 differing* over
# 113 regular files. All 113 stand, and 108 of them ARE the canon -- each compared with itself. The
# population of real second copies is 5, and every one of them differs from the file its siblings
# link. There is no agreeing duplicate in this tree; a reading that counts originals as copies
# reports 96% agreement over a set with none.
#
# BOUNDS. max_basenames 4096, max_copies 512 -- both far above the measured 108 and 5, and both
# refuse rather than truncate, since a silently short reading is the fault this file exists to name.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# USAGE
#   sh tools/fixtures/c/copy_lag_scan.sh
# Driven by tools/co/copy_lag_witness.rish. Run from the repository root.

set -u

# The ratchet, named here so the control can ask the law rather than spell a snapshot of it.
# Measured 20260906.070000: mand/capabilities.rye (four published items behind caravan's) and
# caravan/parse_int.rye (identical code, two comment lines behind tally's). It only falls.
behind_ceiling=2

max_basenames=4096
max_copies=512
# A symlink here may name another symlink -- `granary/parse_int.rye` reaches `tally/parse_int.rye`
# through `linengrow/`, and `pond/apps/granary/` reaches it through both. Resolving ONE hop read
# four different canons under that one basename and called the tree split; resolution before
# accusation, and the bound is what keeps a cycle from spinning (REDS %463, one room over).
max_link_hops=16

pen=$(mktemp -d) || { echo "verdict=no_pen"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

# THIS READING OBEYS ITS OWN HEADER. The bounds above refuse rather than truncate because a
# silently short reading is the fault this file exists to name -- and the first draft of these two
# lines committed exactly that fault, piping `git ls-files` into `awk` and closing with `|| true`,
# so a refused index and a tree with no Rye in it arrived at one answer. `instrument_refusal` gates
# that shape at zero and refused this scan the hour it was written (REDS %473). Each step names its
# own failure now, and the empty corpus exits non-zero as its sibling `rye_compile_reach_scan.sh`
# already did, since answering "nothing is wrong" over nothing is the same silence wearing a
# verdict.
git ls-files -s -- '*.rye' > "$pen/staged" 2>/dev/null || {
  echo "detail: git ls-files refused -- this is not a checkout"
  echo "verdict=no_checkout"
  exit 2; }
awk '{print $1, $4}' "$pen/staged" > "$pen/modes" || {
  echo "detail: awk refused while reading the index listing"
  echo "verdict=instrument_failed"
  exit 2; }
if [ ! -s "$pen/modes" ]; then
  echo "paths=0"
  echo "basenames_both_ways=0"
  echo "copies=0"
  echo "detail: no tracked .rye files under this root"
  echo "verdict=no_rye"
  exit 2
fi

paths=$(wc -l < "$pen/modes" | tr -d ' ')

# One pass groups every path under its basename and records which kinds that basename is held as.
awk '{
  n = split($2, p, "/"); b = p[n]
  if ($1 == "120000") link[b] = link[b] + 1; else reg[b] = reg[b] + 1
}
END { for (b in link) if (b in reg) print b }' "$pen/modes" | sort > "$pen/bothways"

basenames=$(wc -l < "$pen/bothways" | tr -d ' ')
if [ "$basenames" -gt "$max_basenames" ]; then
  echo "basenames_both_ways=$basenames"
  echo "detail: basenames past max_basenames $max_basenames"
  echo "verdict=basenames_over_bound"
  exit 2
fi

copies=0
identical=0
differ=0
behind=0
sibling=0
split_canon=0
unresolved=0

published() { grep -oE 'pub (fn|const) [A-Za-z_][A-Za-z0-9_]*' "$1" 2>/dev/null | awk '{print $3}' | sort -u; }

while IFS= read -r base; do
  [ -n "$base" ] || continue

  # Every symlink under this basename, resolved. A basename whose links point at two different
  # files has no single canon, and picking one silently is the shape this guard exists to refuse.
  : > "$pen/canons"
  awk -v b="$base" '{ n = split($2, p, "/"); if (p[n] == b && $1 == "120000") print $2 }' "$pen/modes" \
  | sort > "$pen/links"
  while IFS= read -r link; do
    [ -n "$link" ] || continue
    cur=$link
    hops=0
    while [ -L "$cur" ] && [ "$hops" -lt "$max_link_hops" ]; do
      tgt=$(readlink "$cur" 2>/dev/null) || tgt=""
      [ -n "$tgt" ] || break
      d=${cur%/*}
      [ "$d" = "$cur" ] && d=.
      abs=$(cd "$d" 2>/dev/null && cd "$(dirname "$tgt")" 2>/dev/null && printf '%s/%s' "$(pwd -P)" "$(basename "$tgt")") || abs=""
      [ -n "$abs" ] || break
      cur=${abs#"$(pwd -P)/"}
      hops=$((hops + 1))
    done
    if [ "$hops" -ge "$max_link_hops" ]; then
      echo "detail: hop_bound $link -- past max_link_hops $max_link_hops, so the chain is not walked"
      continue
    fi
    [ "$cur" = "$link" ] && continue
    printf '%s\n' "$cur" >> "$pen/canons"
  done < "$pen/links"

  distinct=$(sort -u "$pen/canons" 2>/dev/null | grep -c . || true)
  if [ "${distinct:-0}" -eq 0 ]; then
    echo "detail: unresolved $base -- no symlink under this name resolves to a file in the tree"
    unresolved=$((unresolved + 1))
    continue
  fi
  if [ "$distinct" -gt 1 ]; then
    echo "detail: split $base -- its symlinks name $distinct different files, so it has no one canon"
    split_canon=$((split_canon + 1))
    continue
  fi
  canon=$(sort -u "$pen/canons" | head -1)
  [ -f "$canon" ] || { echo "detail: unresolved $base -- canon $canon is not a file here"; unresolved=$((unresolved + 1)); continue; }

  awk -v b="$base" '{ n = split($2, p, "/"); if (p[n] == b && $1 != "120000") print $2 }' "$pen/modes" \
  | sort > "$pen/regulars"

  while IFS= read -r f; do
    [ -n "$f" ] || continue
    [ "$f" = "$canon" ] && continue
    [ -f "$f" ] || continue
    copies=$((copies + 1))
    if [ "$copies" -gt "$max_copies" ]; then
      echo "detail: copies past max_copies $max_copies"
      echo "verdict=copies_over_bound"
      exit 2
    fi
    if cmp -s "$f" "$canon"; then
      identical=$((identical + 1))
      continue
    fi
    differ=$((differ + 1))
    published "$f" > "$pen/pf"
    published "$canon" > "$pen/pc"
    own=$(comm -23 "$pen/pf" "$pen/pc" | grep -c . || true)
    lacks=$(comm -13 "$pen/pf" "$pen/pc" | grep -c . || true)
    if [ "${own:-0}" -eq 0 ]; then
      behind=$((behind + 1))
      echo "detail: behind $f -- trails $canon, publishing nothing of its own and lacking ${lacks:-0}"
    else
      sibling=$((sibling + 1))
      echo "detail: sibling $f -- publishes ${own:-0} its namesake lacks, so it is its own module"
    fi
  done < "$pen/regulars"
done < "$pen/bothways"

echo "paths=$paths"
echo "basenames_both_ways=$basenames"
echo "copies=$copies"
echo "identical=$identical"
echo "differ=$differ"
echo "behind=$behind"
echo "sibling=$sibling"
echo "split_canon=$split_canon"
echo "unresolved=$unresolved"
echo "behind_ceiling=$behind_ceiling"

if [ "$behind" -gt "$behind_ceiling" ]; then
  echo "verdict=behind_over_ceiling"
  exit 1
fi
if [ "$split_canon" -gt 0 ]; then
  echo "verdict=canon_split"
  exit 1
fi
echo "verdict=ok"
