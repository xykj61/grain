#!/bin/sh
# tools/fixtures/comment_dial_scan.sh -- read the dial that runs through the code.
#
# WHY THIS EXISTS, and why it gates nothing. The style guide names two settings for a code
# comment: DOOR at the head of a module, where someone arriving cold deserves a plain sentence
# about what the thing is for, and METER beside a bound, where the comment says why the number is
# that number. The dial has had taste and no meter since it was written.
#
# Two pieces argued on 20260824 that it should have one, and both named the same falsifier:
#
#   if the distribution of comment settings across the modules is roughly uniform,
#   the reading distinguishes nothing and the design is closed.
#
# This scan takes that measurement and stops. It seats no law, joins no roster, and holds no
# ceiling. A measurement taken to answer a question is finished when the question is answered.
# Round note: active-development/20260824-165130_measure-the-comment-histogram-first.md
#
# WHAT IT READS. The language draws part of the line for us, which the scoping note did not know
# and the measuring found. Zig, and Rye after it, has three comment forms:
#
#   //!   a module-level doc comment. The compiler accepts it only at the top of a file, so it is
#         the DOOR setting written into the grammar.
#   ///   a doc comment attached to the declaration below it.
#   //    an ordinary comment.
#
# So the bins are read as: DOOR (`//!`), DECL (`///`), METER (a `//` block whose next line of code
# is a const or var declaration or carries an assert), and LOOSE (every other `//`, including one
# trailing code on the same line, which is counted separately as well).
#
# The seated `// invariant:` convention gets its own reading beside them: how many asserts stand,
# how many invariant lines stand, and how many modules carry asserts with no invariant line at all.
#
# WHAT IT DOES NOT READ. Whether a comment is any good. A Door sentence that welcomes nobody and a
# Meter line restating its own identifier both count here exactly like the real thing.
#
# USAGE
#   sh tools/fixtures/comment_dial_scan.sh            # the tree reading
#   sh tools/fixtures/comment_dial_scan.sh modules    # one row per module
#
# Run from the repository root.

set -u

# One dialect for both piers: xargs_lines / xargs_lines_batched run a command over a
# newline-delimited path list in a spelling GNU and BSD userland both accept.
. "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"

mode=${1:-tree}
root=${COMMENT_DIAL_ROOT:-.}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# Authored Rye only. Vendored and read-only libraries are somebody else's dial.
( cd "$root" && git ls-files '*.rye' 2>/dev/null ) \
  | grep -vE '^(vendor|gratitude|old)/' > "$work/files.txt"

count=$(wc -l < "$work/files.txt" | tr -d ' ')
[ "$count" -gt 0 ] || { echo "verdict=no_modules"; exit 1; }

# One awk over every file. Lines are held per file and classified when the file closes, because
# a comment's setting is decided by the line of CODE that follows it.
( cd "$root" && xargs_lines "$work/files.txt" awk '
  function flush(   i, j, nxt, kind, n) {
    if (name == "") return
    door = 0; decl = 0; meter = 0; loose = 0; trail = 0
    asserts = 0; invariants = 0; asserts_covered = 0
    for (i = 1; i <= n_lines; i++) {
      line = lines[i]
      if (line ~ /\/\/[ \t]*invariant:/) invariants++

      # An assert, counted only where it is CODE. A comment quoting an assert is prose.
      if (line ~ /assert\(/ && line !~ /^[ \t]*\/\//) {
        asserts++
        # Walk up over blank lines, then through the contiguous comment block directly above.
        # The seated law asks for `// invariant:` on the block, so the block is what is read --
        # a ratio of two line counts would answer a different question, since one invariant line
        # can head a block of several asserts and one assert can carry several comment lines.
        j = i - 1
        while (j >= 1 && lines[j] ~ /^[ \t]*$/) j--
        covered = 0
        while (j >= 1 && lines[j] ~ /^[ \t]*\/\//) {
          if (lines[j] ~ /\/\/[ \t]*invariant:/) { covered = 1; break }
          j--
        }
        # A run of asserts under one invariant block is covered by it, which is how the law is
        # actually written and how every module in this tree actually spells it.
        if (!covered) {
          j = i - 1
          while (j >= 1 && (lines[j] ~ /^[ \t]*$/ || lines[j] ~ /assert\(/)) j--
          while (j >= 1 && lines[j] ~ /^[ \t]*\/\//) {
            if (lines[j] ~ /\/\/[ \t]*invariant:/) { covered = 1; break }
            j--
          }
        }
        if (covered) asserts_covered++
      }

      # A comment trailing code on the same line: code before the first // that is not in a string.
      if (line ~ /^[ \t]*\/\/!/) { door++; continue }
      if (line ~ /^[ \t]*\/\/\//) { decl++; continue }
      if (line ~ /^[ \t]*\/\//) {
        # Walk forward to the next line that is neither blank nor a comment.
        nxt = ""
        for (j = i + 1; j <= n_lines; j++) {
          if (lines[j] ~ /^[ \t]*$/) continue
          if (lines[j] ~ /^[ \t]*\/\//) continue
          nxt = lines[j]; break
        }
        if (nxt ~ /^[ \t]*(pub[ \t]+)?(const|var)[ \t]/ || nxt ~ /assert\(/) meter++
        else loose++
        continue
      }
      if (line ~ /\/\//) trail++
    }
    total = door + decl + meter + loose + trail
    printf "%s %d %d %d %d %d %d %d %d %d\n", name, n_lines, door, decl, meter, loose, trail, asserts, invariants, asserts_covered
    n_lines = 0
  }
  FNR == 1 { flush(); name = FILENAME }
  { lines[++n_lines] = $0 }
  END { flush() }
' ) > "$work/rows.txt" 2>/dev/null

if [ "$mode" = "modules" ]; then
  printf '%-58s %6s %5s %5s %5s %5s %5s %5s %5s %5s\n' module lines door decl meter loose trail asrt inv covd
  awk '{ printf "%-58s %6d %5d %5d %5d %5d %5d %5d %5d %5d\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10 }' "$work/rows.txt"
  exit 0
fi

awk -v n="$count" '
  {
    lines += $2; door += $3; decl += $4; meter += $5; loose += $6; trail += $7
    asrt += $8; inv += $9; covd += $10
    cm = $3 + $4 + $5 + $6 + $7
    if (cm > 0) {
      commented++
      share = int($5 * 100 / cm)          # the METER share of ALL this module s comments
      shares[commented] = share
      # The fairer denominator, and the reason it exists: `///` declaration docs are half of every
      # comment in this tree, and a doc comment is neither Door nor Meter. Reading Meter against
      # ordinary `//` comments alone asks the question the dial actually poses.
      ord = $5 + $6 + $7
      if (ord > 0) { ordinary++; oshares[ordinary] = int($5 * 100 / ord) }
      if ($3 > 0) with_door++
    } else {
      silent++
    }
    if ($8 > 0 && $9 == 0) assert_no_inv++
    if ($8 > 0) with_assert++
  }
  END {
    cm_total = door + decl + meter + loose + trail
    printf "modules=%d\n", n
    printf "module_lines=%d\n", lines
    printf "comment_lines=%d\n", cm_total
    printf "door_module_docs=%d\n", door
    printf "decl_docs=%d\n", decl
    printf "meter_comments=%d\n", meter
    printf "loose_comments=%d\n", loose
    printf "trailing_comments=%d\n", trail
    printf "modules_with_any_comment=%d\n", commented
    printf "modules_with_no_comment=%d\n", silent
    printf "modules_with_a_door_doc=%d\n", with_door
    printf "modules_with_an_assert=%d\n", with_assert
    printf "asserts=%d\n", asrt
    printf "invariant_lines=%d\n", inv
    printf "asserts_under_an_invariant_block=%d\n", covd
    printf "asserts_with_no_reason=%d\n", asrt - covd
    printf "modules_asserting_with_no_invariant_line=%d\n", assert_no_inv

    # The reading the round exists to take: how the METER share is spread across modules.
    m = asorti_stub = 0
    # insertion sort, small enough and dependency-free
    k = commented
    for (i = 2; i <= k; i++) { v = shares[i]; j = i - 1
      while (j >= 1 && shares[j] > v) { shares[j+1] = shares[j]; j-- }
      shares[j+1] = v }
    if (k > 0) {
      printf "meter_share_min=%d\n", shares[1]
      printf "meter_share_p25=%d\n", shares[int(k * 0.25) + 1]
      printf "meter_share_median=%d\n", shares[int(k * 0.5) + 1]
      printf "meter_share_p75=%d\n", shares[int(k * 0.75) + 1]
      printf "meter_share_max=%d\n", shares[k]
      b0 = b1 = b2 = b3 = b4 = 0
      for (i = 1; i <= k; i++) {
        s = shares[i]
        if (s == 0) b0++
        else if (s < 25) b1++
        else if (s < 50) b2++
        else if (s < 75) b3++
        else b4++
      }
      printf "band_zero=%d band_1_24=%d band_25_49=%d band_50_74=%d band_75_100=%d\n", b0, b1, b2, b3, b4
    }
    if (ordinary > 0) {
      k2 = ordinary
      for (i = 2; i <= k2; i++) { v = oshares[i]; j = i - 1
        while (j >= 1 && oshares[j] > v) { oshares[j+1] = oshares[j]; j-- }
        oshares[j+1] = v }
      printf "ordinary_meter_share_min=%d\n", oshares[1]
      printf "ordinary_meter_share_p25=%d\n", oshares[int(k2 * 0.25) + 1]
      printf "ordinary_meter_share_median=%d\n", oshares[int(k2 * 0.5) + 1]
      printf "ordinary_meter_share_p75=%d\n", oshares[int(k2 * 0.75) + 1]
      printf "ordinary_meter_share_max=%d\n", oshares[k2]
      c0 = c1 = c2 = c3 = c4 = 0
      for (i = 1; i <= k2; i++) {
        s = oshares[i]
        if (s == 0) c0++
        else if (s < 25) c1++
        else if (s < 50) c2++
        else if (s < 75) c3++
        else c4++
      }
      printf "ordinary_band_zero=%d ordinary_band_1_24=%d ordinary_band_25_49=%d ordinary_band_50_74=%d ordinary_band_75_100=%d\n", c0, c1, c2, c3, c4
    }
  }
' "$work/rows.txt"
echo "verdict=measured"
