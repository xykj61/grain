#!/bin/sh
# tools/fixtures/g/glow_ceiling_refusal_scan.sh -- Glow ceiling refusals that share one error name
# and carry no refusal record.
#
# WHY. `construction/ITINERARY.md` asks pheromone to make Glow's refusal output stable: field,
# value, ceiling, unit and reason wherever a ceiling applies. A named error alone reports which
# KIND of refusal happened, so two different ceilings answering with one word leave a caller
# unable to tell them apart. `glow/rune_shape.rye` did exactly that -- its nine-face tuple ceiling
# and its three-face payload ceiling both returned `error.TooManyFields` -- and `glow/refusal.rye`
# landed on `20260916` to tell them apart by record rather than by renaming a published error.
#
# THAT WAS ONE INSTANCE. A lantern that fires twice becomes a loom (`.claude/rules/reds-first.md`),
# and it fired twice the next lap: `glow/tokens.rye`, the lexer every Glow parse passes through,
# answers FOUR ceilings with the one word `error.BadToken` -- a name too long, a cord literal too
# long, a hex literal with too many digits, and a source too long. So this is the meter for the
# class rather than a second repair of one file.
#
# WHAT THE RECORD FIXES, AND WHAT IT LEAVES ALONE. The error NAME stays. A published error set is a
# contract, and renaming one would break every caller that switches on it (accrete-never-break).
# What the repair adds is a `glow/refusal.rye` record filled beside the return, carrying the field,
# the value, the ceiling, the unit and the reason. So this meter counts a site as covered when a
# refusal record is filled in the same block, never by the error name alone.
#
# WHAT A CEILING SITE IS. A line comparing something against a named `max_` constant with a
# relational operator, whose block returns a named error. Three readings make that honest:
#
#   - STRING LITERALS ARE STRIPPED FIRST. `glow/lower_shop_gate.rye` emits Zig source containing
#     `"if ({s} <= gardens.max_gardens) 1 else 0"` and then `catch return error.Overflow` -- a
#     comparison inside generated TEXT beside a refusal about a print buffer. Read raw, seven such
#     lines enter as ceilings and `error.Overflow` reads as a name covering six of them. Every one
#     is a false pair, and stripping quoted spans removes all seven.
#   - AN `assert(` LINE IS READ PAST. An assert is a contract that crashes; it can never be the
#     site of a named refusal. `glow/lower_shop_core.rye:45` asserts `buf.len >= max_arm_name_len`
#     and the NEXT line returns `error.Overflow` on `name.len > buf.len` -- a real refusal whose
#     ceiling is a buffer length rather than the constant. Skipping asserts drops that false pair
#     and takes `unpaired` from 69 to 16.
#   - THE RETURN IS FOUND BY BRACE DEPTH, never by a fixed line count. `glow/rune_shape.rye` fills
#     its record across five lines before returning, so a single-line reading misses the founding
#     case entirely. The walk stops when the `if` block closes, so a return belonging to the next
#     statement is never borrowed.
#
# THE UNDERCOUNT, MEASURED RATHER THAN ASSUMED. `unpaired` counts a `max_` comparison this reading
# could not pair with a named return. Read `20260916` it stands at 16, and every one is an honest
# non-refusal: a switch arm mapping an error back to a number, a `while (len < max_name_len)` scan,
# a `return true`. A blind spot nobody can measure is the same blind spot with better manners.
#
# KIN. The record is `glow/refusal.rye`, its peer `tally/receipt_refusal.rye`, its guard
# `tools/g/glow_refusal_witness.rish`. The pen that proves this meter is
# `tools/fixtures/g/glow_ceiling_refusal_control.sh`; the gate over it is
# `tools/g/glow_ceiling_refusal_witness.rish`.
#
# USAGE
#   sh tools/fixtures/g/glow_ceiling_refusal_scan.sh          # count
#   sh tools/fixtures/g/glow_ceiling_refusal_scan.sh --list   # name each uncovered site
#
# Run from the repository root, or from a pen holding its own `glow/` room.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap gives an ambiguous ceiling its own record.
#   44  `20260916.081500`  the reading on the lap this meter was seated -- 48 sites under five
#                          shared names, four of them already recorded by `glow/rune_shape.rye`.
#                          The named next fall is `glow/tokens.rye`'s four, which takes
#                          `error.BadToken` out of the shared set and this reading to 40.
CEILING=44

list=$(git ls-files 'glow/*.rye' 2>/dev/null | grep -v '_witness\.rye$')

# AN INSTRUMENT THAT CANNOT ANSWER MUST REFUSE, never answer green. Run outside a git checkout, or
# against a tree holding no Glow at all, `git ls-files` says nothing -- and an empty reading is
# byte-identical to a tree with no ambiguous ceiling left, which is the answer everybody hopes for.
if [ -z "$list" ]; then
  echo "instrument=failed"
  echo "detail=no_glow_sources"
  echo "verdict=misread"
  exit 1
fi

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513. An empty answer from a refused
# read is byte-identical to an empty answer from a clean room, and the second is the one everyone
# hopes for. The awk runs in a function so its exit status is readable; ABSENT is counted and
# skipped, since `git ls-files` reads the INDEX and a rename staged mid-lap lists a path the
# working tree no longer holds.
read_file() {
  LC_ALL=C awk -v FILE="$1" '
    function strip(s,   o) {
      o = s
      while (match(o, /"[^"]*"/)) o = substr(o, 1, RSTART - 1) " " substr(o, RSTART + RLENGTH)
      gsub(/\047[^\047]*\047/, " ", o)
      return o
    }
    function braces(s,   n, i, c) {
      n = 0
      for (i = 1; i <= length(s); i++) { c = substr(s, i, 1); if (c == "{") n++; else if (c == "}") n-- }
      return n
    }
    { raw[FNR] = $0 }
    END {
      LOOK = 24
      for (i = 1; i <= FNR; i++) {
        t = raw[i]; sub(/^[ \t]+/, "", t)
        if (substr(t, 1, 2) == "//") continue
        if (substr(t, 1, 2) == "\\\\") continue
        if (substr(t, 1, 7) == "assert(") continue
        s = strip(raw[i])
        if (!match(s, /(>=|<=|==|>|<)[ \t]*[A-Za-z_.]*max_[A-Za-z_]+/)) continue
        c = substr(s, RSTART, RLENGTH)
        sub(/^(>=|<=|==|>|<)[ \t]*/, "", c)
        sub(/^.*\./, "", c)
        e = ""; rec = "no"
        if (match(s, /return[ \t]+([A-Za-z_]*[Ee]rror)\.[A-Za-z_]+/)) {
          e = substr(s, RSTART, RLENGTH); sub(/^return[ \t]+/, "", e)
        } else {
          depth = braces(s); scanned = 0
          for (j = i + 1; j <= FNR && scanned < LOOK; j++) {
            v = raw[j]; sub(/^[ \t]+/, "", v)
            if (v == "" || substr(v, 1, 2) == "//") continue
            scanned++
            u = strip(raw[j])
            if (u ~ /\.reason[ \t]*=[ \t]*\./) rec = "yes"
            if (match(u, /return[ \t]+([A-Za-z_]*[Ee]rror)\.[A-Za-z_]+/)) {
              e = substr(u, RSTART, RLENGTH); sub(/^return[ \t]+/, "", e); break
            }
            if (depth == 0) break
            depth += braces(u)
            if (depth <= 0) break
          }
        }
        if (e == "") { print "UNPAIRED\t-\tno\t" FILE ":" i; continue }
        print e "\t" c "\t" rec "\t" FILE ":" i
      }
    }
  ' "$1"
}

rows=""
opened=0
absent=0
for f in $list; do
  # A link and its target are two paths and one set of bytes; the target is read on its own row.
  [ -L "$f" ] && continue
  if [ ! -f "$f" ]; then
    absent=$((absent + 1))
    continue
  fi
  opened=$((opened + 1))
  out=$(read_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  rows="$rows$out
"
done

# An opened room that answered nothing is a reading, never a fault: a room may hold no ceiling at
# all. An awk that refused is caught above, by exit status rather than by an empty answer.
paired=$(printf '%s' "$rows" | grep -v '^UNPAIRED' | grep -c '.' 2>/dev/null || true)
unpaired=$(printf '%s' "$rows" | grep -c '^UNPAIRED' 2>/dev/null || true)
[ -z "$paired" ] && paired=0
[ -z "$unpaired" ] && unpaired=0

# A name is SHARED when it refuses more than one distinct ceiling constant. One constant refused at
# twenty sites is one meaning said twenty times, which is fine; two constants behind one word is
# the defect.
shared=$(printf '%s' "$rows" | grep -v '^UNPAIRED' | cut -f1,2 | sort -u |
  awk -F'\t' '{ n[$1]++ } END { for (e in n) if (n[e] > 1) print e }' | sort)
shared_names=$(printf '%s' "$shared" | grep -c '.' 2>/dev/null || true)
[ -z "$shared_names" ] && shared_names=0

names=$(printf '%s' "$rows" | grep -v '^UNPAIRED' | cut -f1 | sort -u | grep -c '.' 2>/dev/null || true)
[ -z "$names" ] && names=0

ambiguous=0
recorded=0
report=""
if [ "$shared_names" -gt 0 ]; then
  # The shared set travels in a variable rather than a temporary file: a meter that writes into the
  # tree it is measuring moves the tree, and a roster pass reads `tree_moved` while this runs.
  shared_one=$(printf '%s' "$shared" | tr '\n' ' ')
  amb=$(printf '%s' "$rows" | grep -v '^UNPAIRED' | awk -F'\t' -v SHARED=" $shared_one " '
    index(SHARED, " " $1 " ") > 0 { print }
  ')
  ambiguous=$(printf '%s' "$amb" | grep -c '.' 2>/dev/null || true)
  recorded=$(printf '%s' "$amb" | awk -F'\t' '$3 == "yes"' | grep -c '.' 2>/dev/null || true)
  [ -z "$ambiguous" ] && ambiguous=0
  [ -z "$recorded" ] && recorded=0
  report=$(printf '%s' "$amb" | awk -F'\t' '$3 == "no" { print $1 " " $2 " " $4 }' | sort)
fi

uncovered=$((ambiguous - recorded))

if [ "$mode" = "--list" ]; then
  printf '%s\n' "$report" | grep '.' | head -60
fi

if [ "$uncovered" -le "$CEILING" ]; then under=yes; else under=no; fi
echo "instrument=ok"
echo "GLOW_CEILING_REFUSAL sites=$paired names=$names shared_names=$shared_names ambiguous=$ambiguous recorded=$recorded uncovered=$uncovered unpaired=$unpaired opened=$opened absent=$absent ceiling=$CEILING under_ceiling=$under"
