#!/bin/sh
# tools/fixtures/c/ceiling_teeth_scan.sh -- a declared ceiling is read where it can refuse.
#
# WHY. A module names a maximum so the thing it bounds can never grow past it. The declaration is
# half of that promise; the other half is a line that READS the constant somewhere a caller can be
# turned away. Three reds fired in one room in four days, each a ceiling whose declaration stood
# further forward than its enforcement -- `%678` (a count declared in hits, enforced in bytes),
# `%688` (a store's ceiling in bytes against a weave's in lines, the conversion nowhere), and
# `20260910.043900` (a document identified by its lines, so the byte it ends with had no home).
# A lantern that fires twice becomes a loom.
#
# WHAT THIS ASKS, per declared `pub const max_*`: what is the STRONGEST thing this file does with
# its own ceiling? Six answers, each decided by reading the file rather than by judging it:
#
#   refused        a condition naming the constant, with a named-error return within three lines
#   structural     the constant sizes an array type, `[max_x]T`, so the compiler holds the bound
#   cut            the value is clamped to the ceiling, `@min(remain, max_x)`
#   derived        a second constant is computed from it and carries the teeth
#   asserted_only  the strongest reading is an `assert`, which a release build removes
#   unread         the file declares it and nothing in any tracked `.rye` ever reads it
#
# THE ONE GATE, at zero: `unread`. A ceiling nobody reads bounds nothing at all, and it reads to a
# person exactly like a ceiling that holds -- which is the whole shape of the class. Found on the
# seating lap: `mantra/recall_subscribe_poll.rye` declared `max_mirror_pairs = 4` directly above
# the `PeerBoltPair` it was drawn for, and `poll_one_cycle` walked `pairs.len` with no ceiling
# anywhere, then cast that length to `u32` unchecked.
#
# ONE RATCHET, under a ceiling that only falls: `asserted_only`. It is where a repair lands, so a
# wall would refuse honest work in the same breath as the fault. An assert is a postcondition, and
# a postcondition is a fine thing to keep; what it cannot do is turn a caller away.
#
# WHY `unread` GATES AND THE REST REPORT. `unread` is decidable with no judgment: the constant
# appears once in its own file and nowhere else in the tree. Every other class asks what a line is
# FOR, and this scan answers that lexically, which is a proxy. Precedent one room over:
# `tools/fixtures/c/ceiling_pair_scan.sh` measured four lexical discriminators for its own class
# and every one leaked, so it stopped guessing and asked the file to declare. This scan gates only
# the reading that needs no guess.
#
# WHAT IT DOES NOT REACH. Whether a refusal's threshold is the RIGHT number -- that is the pair
# scan's subject and, past it, arithmetic. Whether a `cut` truncates something a caller needed
# whole. Every language beside Rye. And a ceiling declared `const` rather than `pub const`, since a
# private bound is the module's own business and never a promise to a caller.
#
# MEASURED ON THE SEATING LAP, 20260910, over mantra and tally: 31 declared ceilings -- 25
# refused, 3 structural, 1 cut, 1 derived, 1 asserted-only, 0 unread. Before the two repairs that
# lap made it read 22 refused, 4 structural, 2 asserted-only and 1 unread. Every figure here is
# WALLED by this scan's own gate and ratchet rather than free, so it moves only when a lap moves
# it on purpose -- and the way to read today's is to run the scan.
#
# THE ROOMS ARE ARGUMENTS, defaulting to the lane a hand has walked. `sh
# tools/fixtures/c/ceiling_teeth_scan.sh mantra tally` is the seated reading; another lane adopts
# by naming itself here and reading what it inherits.
#
# Pen: tools/fixtures/c/ceiling_teeth_control.sh. Run from the repository root.

set -f

rooms="$*"
[ -n "$rooms" ] || rooms="mantra tally"

unread=0
refused=0
structural=0
cut=0
derived=0
asserted_only=0
declaring=0

# A word boundary spelled in POSIX character classes, because `\b` is a GNU extension in grep and
# means a backspace inside a gawk regex -- a draft of this scan counted every constant as unread
# for exactly that reason.
edge='([^a-zA-Z0-9_]|$)'
lead='(^|[^a-zA-Z0-9_])'

for room in $rooms; do
  for f in $(git ls-files "$room/*.rye" 2>/dev/null); do
    case "$f" in
      *_witness.rye|*_test.rye) continue ;;
    esac
    [ -f "$f" ] || continue
    for c in $(sed -n 's/^pub const \(max_[a-z0-9_]*\).*/\1/p' "$f" | sort -u); do
      declaring=$((declaring + 1))

      uses=$(grep -cE "$lead$c$edge" "$f")
      if [ "$uses" -le 1 ]; then
        elsewhere=$(git grep -lE "$lead$c$edge" -- '*.rye' | grep -v "^$f\$" | head -1)
        if [ -z "$elsewhere" ]; then
          echo "unread: $f declares $c and nothing in any tracked .rye reads it"
          unread=$((unread + 1))
          continue
        fi
      fi

      # refused: a condition naming the constant, with a named-error return within three lines.
      # The window rather than the line, because this tree writes the refusal on its own line as
      # often as beside the test.
      if awk -v c="$c" '
        { line[NR] = $0 }
        END {
          for (i = 1; i <= NR; i++) {
            if (line[i] ~ ("(^|[^a-zA-Z0-9_])" c "([^a-zA-Z0-9_]|$)") && line[i] ~ /if \(|or |and /) {
              for (j = i; j <= i + 3 && j <= NR; j++) {
                if (line[j] ~ /return [A-Za-z]*[Ee]rror\./) { exit 0 }
              }
            }
          }
          exit 1
        }' "$f"; then
        refused=$((refused + 1))
        continue
      fi

      if grep -qE "\[$c\]" "$f"; then
        structural=$((structural + 1))
        continue
      fi

      if grep -qE "@min\([^)]*$lead$c$edge" "$f"; then
        cut=$((cut + 1))
        continue
      fi

      if sed -n "/^\(pub \)\{0,1\}const [a-zA-Z0-9_]*[ :=].*$c/p" "$f" \
        | grep -qvE "^(pub )?const $c$edge"; then
        derived=$((derived + 1))
        continue
      fi

      echo "asserted-only: $f declares $c and never reads it where a caller can be turned away"
      asserted_only=$((asserted_only + 1))
    done
  done
done

echo "rooms=$rooms"
echo "ceilings_declaring=$declaring"
echo "unread=$unread"
echo "refused=$refused"
echo "structural=$structural"
echo "cut=$cut"
echo "derived=$derived"
echo "asserted_only=$asserted_only"

unread_ceiling="${CEILING_TEETH_UNREAD_CEILING:-0}"
asserted_ceiling="${CEILING_TEETH_ASSERTED_CEILING:-1}"
echo "unread_ceiling=$unread_ceiling"
echo "asserted_only_ceiling=$asserted_ceiling"

if [ "$declaring" -eq 0 ]; then
  echo "verdict=empty_corpus"
  exit 1
fi
if [ "$unread" -gt "$unread_ceiling" ]; then
  echo "verdict=unread_ceiling"
  exit 1
fi
if [ "$asserted_only" -gt "$asserted_ceiling" ]; then
  echo "verdict=asserted_spread"
  exit 1
fi
echo "verdict=ok"
