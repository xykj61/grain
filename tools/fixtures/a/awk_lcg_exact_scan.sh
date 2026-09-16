#!/bin/sh
# tools/fixtures/a/awk_lcg_exact_scan.sh -- an awk pseudorandom generator whose arithmetic
# leaves the range a double holds exactly is a rounded shadow of the generator its comment names.
#
#   sh tools/fixtures/a/awk_lcg_exact_scan.sh [--list]
#
# WHY. awk carries every number as an IEEE-754 double, which holds integers exactly up to 2^53 --
# 9,007,199,254,740,992 -- and rounds above it. A linear congruential generator is one multiply,
# one add, and one modulus, so its largest intermediate is `multiplier * (modulus - 1)`. Past 2^53
# that product rounds, the low bits fall off, and the sequence that comes out is a different
# sequence from the one the line spells.
#
# MEASURED ON METAL `20260916`, on `tools/fixtures/t/torus_fold_control.sh`, which spelled
# `seed = (seed * 1103515245 + 12345) % 2147483648`. Its largest intermediate is 2.37e18, 263
# times past the exact range:
#
#   the exact generator has period 2^31 = 2,147,483,648
#   the rounded map has a tail of 3,253 draws and then a cycle of 10,466 -- 13,719 states in all
#   the byte the pen consumes, `int(seed / 65536) % 256`, differs from the exact stream in
#     4,079 of 4,096 draws
#
# So the generator is not weakened at the margin; it is a different and far smaller object. That
# pen draws 2,048 values and so stood inside the tail, which is why nothing had ever reddened.
# A leg drawing past 13,719 would have planted a population that literally repeats.
#
# DETERMINISM WAS NEVER THE FAULT, and naming that keeps the reading honest. IEEE-754 multiply,
# add, and `fmod` are each exactly specified, so the rounded stream is reproducible on any awk
# carrying doubles -- the comment beside that line, *the pen must plant the same population on
# every host*, was true. What failed is a quieter promise: that the population is as varied as the
# arithmetic says. A generator can be perfectly deterministic and still degenerate.
#
# WHAT IS COUNTED, in three classes, because they answer three different questions.
#
#   overflowing -- a FED-BACK site, where the variable assigned is the variable multiplied, whose
#     `multiplier * (modulus - 1)` reaches 2^53. This is the gated class, held at ZERO. A fed-back
#     state is bounded by its own modulus, so the largest intermediate is computable from the line
#     alone and no judgment enters.
#
#   exact -- a fed-back site whose product stays inside the range. Printed so a reader sees the
#     denominator the zero above is a zero of.
#
#   unread -- a multiply-then-mod site that is NOT fed back: `h = (i * 2654435761) % 4294967296`,
#     where `i` is an index rather than the state. Its largest intermediate depends on the range
#     of the input, which a scanner cannot know, so it is REPORTED with its size and gated by
#     nothing. Naming the blind spot's size is the point -- a reader there can otherwise not tell
#     an empty blind spot from a large one.
#
# THE BORDERLINE BAND, and why it fails toward refusal. The scan compares `multiplier` against
# `2^53 / (modulus - 1)`, a division whose operands are both exact and which therefore rounds
# once. A site within a tenth of a percent of that ratio is a site whose verdict a single rounding
# could decide, so it counts as overflowing and says `borderline` beside itself. Safety outranks a
# tighter reading; no site in this tree lands in the band. The nearest is not near: the two
# `key_trade_control.sh` sites spell `s * 1664525 % 4294967296`, whose product is 7.149e15 against
# the range's 9.007e15 -- 1.260x of headroom, 79 percent of the multiplier that modulus allows.
# The other five stand at 87x or better. Naming the tightest keeps the zero from reading as slack.
#
# A COMMENT LINE IS READ PAST. This header spells three generators to teach the rule, and a
# reading that counted its own prose would count itself -- the fault `pen_entry` booked by first
# residency. A line whose first non-blank character is `#` is skipped.
#
# THE POPULATION is every tracked `.sh` and `.rish` source outside `vendor/`, `gratitude/` and
# `seed/`, because awk is reached for from both languages and a vendored source is not ours to
# move.
#
# THREE MUTATION SWITCHES. `FEEDBACK`, `COMMENT` and `MARGIN` each turn one predicate off, so
# tools/fixtures/a/awk_lcg_exact_control.sh flips a single literal and requires the reading to
# change. A predicate no mutation bites is a predicate no leg proves.

set -e

FEEDBACK=on
COMMENT=on
MARGIN=on

CEILING=0            # overflowing sites. A wall rather than a ratchet: the class was TWO sites
                     # wide at seating -- the torus pen and the workload spin loop -- and both were
                     # repaired on the same lap, so there is nothing to grandfather and a wall
                     # costs no lane a red it cannot close.
MAX_SITES=4096       # bound: a tree this size holds a dozen; a runaway match can never fill memory.

LIST=no
for a in "$@"; do
  case "$a" in
    --list) LIST=yes ;;
    *) echo "usage: sh $0 [--list]" >&2; exit 2 ;;
  esac
done

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "verdict=unreadable"; exit 1; }
cd "$ROOT"

files=$(git ls-files '*.sh' '*.rish' | grep -v '^vendor/\|^gratitude/\|^seed/' || true)
[ -n "$files" ] || { echo "verdict=unreadable"; exit 1; }

# shellcheck disable=SC2086
printf '%s\n' $files | awk \
  -v feedback="$FEEDBACK" -v comment="$COMMENT" -v margin="$MARGIN" \
  -v ceiling="$CEILING" -v max_sites="$MAX_SITES" -v list="$LIST" '
  BEGIN {
    exact_max = 9007199254740992      # 2^53, the last integer a double holds with its successor
    band      = 0.999                 # a tenth of a percent short of the ratio still refuses
    sites = 0
  }
  {
    path = $0
    if (path == "") next
    line_no = 0
    while ((getline ln < path) > 0) {
      line_no++
      if (comment == "on") { probe = ln; sub(/^[ \t]+/, "", probe); if (probe ~ /^#/) continue }
      rest = ln
      while (match(rest, /[A-Za-z_][A-Za-z_0-9]*[ \t]*\*[ \t]*[0-9]+([ \t]*\+[ \t]*[0-9]+)?[ \t]*\)?[ \t]*%[ \t]*[0-9]+/)) {
        hit  = substr(rest, RSTART, RLENGTH)
        head = substr(rest, 1, RSTART - 1)
        rest = substr(rest, RSTART + RLENGTH)

        mulvar = hit; sub(/[ \t]*\*.*$/, "", mulvar)
        mult   = hit; sub(/^[^*]*\*[ \t]*/, "", mult); sub(/[^0-9].*$/, "", mult)
        mod    = hit; sub(/^.*%[ \t]*/, "", mod); sub(/[^0-9].*$/, "", mod)
        if (mult + 0 < 2 || mod + 0 < 2) continue

        # The assignment, when there is one, is the token left of the nearest `=` that is not a
        # comparison. `x=(x*M+A)%N` and `x = ( x * M ) % N` are the same site written two ways.
        lhs = ""
        h = head
        sub(/[ \t]*\(?[ \t]*$/, "", h)
        if (h ~ /=[ \t]*$/ && h !~ /[=!<>]=[ \t]*$/) {
          sub(/[ \t]*=[ \t]*$/, "", h)
          if (h ~ /[A-Za-z_][A-Za-z_0-9]*$/) { lhs = h; sub(/^.*[^A-Za-z_0-9]/, "", lhs) }
        }

        fed = (lhs != "" && lhs == mulvar)
        if (feedback == "off") fed = 1      # MUTATION: every site reads as fed back

        sites++
        if (sites > max_sites) { print "verdict=unbounded"; exit 1 }

        if (!fed) {
          unread++
          if (list == "yes") printf "unread %s:%d %s * %s %% %s\n", path, line_no, mulvar, mult, mod
          continue
        }

        limit = exact_max / (mod + 0 - 1)
        cut = (margin == "on") ? limit * band : limit
        if (mult + 0 >= cut) {
          over++
          why = (mult + 0 >= limit) ? "past" : "borderline"
          printf "overflowing %s:%d %s = (%s * %s ...) %% %s  product_over_exact_range=%s\n", \
            path, line_no, lhs, mulvar, mult, mod, why
        } else {
          ok++
          if (list == "yes") printf "exact %s:%d %s * %s %% %s\n", path, line_no, mulvar, mult, mod
        }
      }
    }
    close(path)
  }
  END {
    printf "sites_read=%d\n", sites
    printf "fedback=%d\n", ok + over
    printf "exact=%d\n", ok
    printf "unread=%d\n", unread + 0
    printf "overflowing=%d\n", over + 0
    printf "exact_range=%d\n", exact_max
    printf "ceiling=%d\n", ceiling
    if (over + 0 <= ceiling) { print "ceiling_ok=yes"; print "verdict=exact"; exit 0 }
    print "ceiling_ok=no"
    print "verdict=rounded"
    exit 1
  }
'
