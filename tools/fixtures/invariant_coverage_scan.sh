#!/bin/sh
# tools/fixtures/invariant_coverage_scan.sh -- a seated law, measured for the first time.
#
# WHY THIS EXISTS. TAME asks that every assert carry a `// invariant:` line above it naming the
# reason -- *say why*, the single highest-value habit in the guidance. The law has been seated for
# months and nothing in this tree has ever counted it. The comment-dial measurement of
# 20260824.170904 counted it in passing and read 59.6%, which is a large enough gap to be worth a
# proper reading rather than a footnote.
#
# WHAT IT READS. Every authored `.rye` file outside vendor, gratitude, and old. For each assert
# standing in CODE -- a comment quoting an assert is prose -- it walks up over blank lines and over
# a run of neighbouring asserts, then through the contiguous comment block above, and asks whether
# any line of that block says `invariant:`. A run of asserts under one invariant block is covered
# by it, which is how the law is actually written and how this tree actually spells it.
#
# WHY A RATIO OF TWO LINE COUNTS WOULD ANSWER A DIFFERENT QUESTION. One invariant line can head a
# block of six asserts, and one assert can carry three comment lines. Dividing the counts reads
# neither case correctly, so each assert is asked about individually.
#
# THE BINS, and why they are these. Not every assert is a contract:
#
#   witness   an assert inside a `*_witness.rye` file is proving a claim about the tree, and its
#             reason is the witness header rather than a line above the call.
#   selftest  an assert inside a function whose name carries `selftest`, or inside `main`, is a
#             proof that runs, sitting in the same file as the code it proves. So is EVERY assert
#             in a file whose own `//!` header declares it one -- `lattice/lattice.rye` opens
#             `Lattice selftest`, builds to `lattice/bin/lattice selftest`, and names its 199
#             functions `welcome_add`, `welcome_matmul`, `welcome_reshape`. Binning by function
#             NAME alone read all 199 as contracts and reported the room at 0.0% coverage, which
#             sent a sweep at a file that is entirely test (found while starting that sweep).
#   contract  everything else -- an assert inside an ordinary function, which is exactly what the
#             seated law is about.
#
# The bins are reported separately rather than merged, because a single number over all three would
# be measuring three different promises at once.
#
# WHAT IS NOT MEASURED. Whether an invariant line says anything USEFUL. A line reading
# `// invariant: n is at most 64` above `assert(n <= 64)` restates its own assertion and counts here
# exactly like a line naming the failure the bound exists to prevent. Presence is the check; a
# reason a reader can use is the standard.
#
# THIS SEATS NOTHING. No ratchet, no ceiling, no roster entry. A measurement taken to answer a
# question is finished when the question is answered.
#
# USAGE
#   sh tools/fixtures/invariant_coverage_scan.sh            # the tree reading
#   sh tools/fixtures/invariant_coverage_scan.sh modules    # one row per module, worst first
#
# Run from the repository root.

set -u

mode=${1:-tree}
root=${INVARIANT_ROOT:-.}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# A SYMLINK IS NOT A SECOND MODULE. Zig refuses an import that escapes the root file's directory,
# so a module three rooms need is symlinked into each of them -- image/photos.rye is the file and
# pond/apps/photos.rye and brushstroke/photos.rye are links to it. Counting the links would triple
# that file's 185-assert gap and read 555 where 185 stands. The first run of this scan did exactly
# that, and three identical rows in the worst-ten table are what showed it.
( cd "$root" && git ls-files '*.rye' 2>/dev/null ) | grep -vE '^(vendor|gratitude|old)/' \
  | ( cd "$root" && while IFS= read -r _f; do [ -L "$_f" ] || printf '%s\n' "$_f"; done ) > "$work/files.txt"
count=$(wc -l < "$work/files.txt" | tr -d ' ')
[ "$count" -gt 0 ] || { echo "verdict=no_modules"; exit 1; }

( cd "$root" && xargs -a "$work/files.txt" awk '
  function covered(i,   j, k) {
    # up over blanks and over a run of neighbouring asserts, then through the comment block
    j = i - 1
    while (j >= 1 && (lines[j] ~ /^[ \t]*$/ || (lines[j] ~ /assert\(/ && lines[j] !~ /^[ \t]*\/\//))) j--
    while (j >= 1 && lines[j] ~ /^[ \t]*\/\//) {
      if (lines[j] ~ /\/\/[ \t]*invariant:/) return 1
      j--
    }
    return 0
  }
  function flush(   i, fn, kind, iswit, isself) {
    if (name == "") return
    iswit = (name ~ /_witness\.rye$/)
    # A file that calls itself a selftest in its own module doc is one, whatever its functions are
    # named. Read the head only, so a mention deep in the body cannot reclassify a real module.
    isself = 0
    for (i = 1; i <= n_lines && i <= 6; i++) if (lines[i] ~ /^\/\/!/ && tolower(lines[i]) ~ /selftest/) isself = 1
    c = cc = s = sc = w = wc = 0
    fn = ""
    for (i = 1; i <= n_lines; i++) {
      if (lines[i] ~ /^[ \t]*(pub[ \t]+)?(export[ \t]+)?fn[ \t]+[A-Za-z_]/) {
        fn = lines[i]
        sub(/^[ \t]*(pub[ \t]+)?(export[ \t]+)?fn[ \t]+/, "", fn)
        sub(/[ \t(].*$/, "", fn)
      }
      if (lines[i] !~ /assert\(/) continue
      if (lines[i] ~ /^[ \t]*\/\//) continue
      k = covered(i)
      if (iswit)                                        { w++;  wc += k }
      else if (isself || fn == "main" || fn ~ /selftest/) { s++;  sc += k }
      else                                              { c++;  cc += k }
    }
    printf "%s %d %d %d %d %d %d\n", name, c, cc, s, sc, w, wc
    n_lines = 0
  }
  FNR == 1 { flush(); name = FILENAME }
  { lines[++n_lines] = $0 }
  END { flush() }
' ) > "$work/rows.txt" 2>/dev/null

if [ "$mode" = modules ]; then
  printf '%-56s %7s %7s %6s\n' module contract covered gap
  awk '$2 > 0 { printf "%-56s %7d %7d %6d\n", $1, $2, $3, $2 - $3 }' "$work/rows.txt" | sort -k4 -rn
  exit 0
fi

awk -v n="$count" '
  { c+=$2; cc+=$3; s+=$4; sc+=$5; w+=$6; wc+=$7
    if ($2 > 0) { mods++; gap = $2 - $3; if (gap == 0) clean++; else { gaps[++g] = gap; tg += gap } } }
  END {
    printf "modules=%d\n", n
    printf "contract_asserts=%d\n", c
    printf "contract_with_a_reason=%d\n", cc
    printf "contract_with_no_reason=%d\n", c - cc
    if (c > 0) printf "contract_coverage_percent=%d\n", cc * 100 / c
    printf "selftest_asserts=%d selftest_with_a_reason=%d\n", s, sc
    printf "witness_asserts=%d witness_with_a_reason=%d\n", w, wc
    printf "modules_with_a_contract_assert=%d\n", mods
    printf "modules_fully_covered=%d\n", clean
    printf "modules_with_a_gap=%d\n", mods - clean
    # how concentrated: sort the per-module gaps and read the top of the distribution
    for (i = 2; i <= g; i++) { v = gaps[i]; j = i - 1
      while (j >= 1 && gaps[j] < v) { gaps[j+1] = gaps[j]; j-- }
      gaps[j+1] = v }
    top10 = top50 = 0
    for (i = 1; i <= g && i <= 10; i++) top10 += gaps[i]
    for (i = 1; i <= g && i <= 50; i++) top50 += gaps[i]
    printf "total_gap=%d\n", tg
    if (tg > 0) {
      printf "gap_in_worst_10_modules=%d (%d%%)\n", top10, top10 * 100 / tg
      printf "gap_in_worst_50_modules=%d (%d%%)\n", top50, top50 * 100 / tg
      printf "worst_single_module_gap=%d\n", gaps[1]
      printf "median_module_gap=%d\n", gaps[int(g * 0.5) + 1]
    }
  }
' "$work/rows.txt"
echo "verdict=measured"
