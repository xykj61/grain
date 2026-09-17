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
#   refused        a condition naming the constant, with a named-error return inside the block it opens
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
# lap made it read 22 refused, 4 structural, 2 asserted-only and 1 unread. Measured 20260917 when
# glow adopted: 59 declared there -- 51 refused, 5 structural, 3 asserted-only, 0 unread; under the
# elder window the same room read 47 refused, 7 structural and 5 asserted-only. Every figure here is
# WALLED by this scan's own gate and ratchet rather than free, so it moves only when a lap moves
# it on purpose -- and the way to read today's is to run the scan.
#
# THE ROOMS ARE ARGUMENTS, defaulting to the lane a hand has walked. `sh
# tools/fixtures/c/ceiling_teeth_scan.sh mantra tally` is the first seated reading and `sh
# tools/fixtures/c/ceiling_teeth_scan.sh glow` the second, adopted 20260917 -- each with its OWN
# assert-only ratchet, held in the `case` below rather than merged, so a repair in one room can
# never pay for a regression in another. Another lane adopts by naming itself here, reading what it
# inherits, and seating that number beside the others.
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

      # refused: a condition naming the constant, with a named-error return inside the block that
      # condition opens. THE BLOCK RATHER THAN A LINE COUNT (REDS `20260917.040203`). This read three lines
      # forward until 20260917, and a line count standing in for a block failed in both directions
      # at once. It MISSED this tree's own growing idiom -- a refusal record filled between the
      # condition and the return -- so `glow/tokens.rye` refuses four ceilings with `error.BadToken`
      # eleven lines below the test and every one read `asserted_only`, which is the ratchet: the
      # repair that made those refusals diagnosable RAISED the meter. And it ADMITTED a refusal on
      # PROSE, since the condition test matches `and ` and a comment is a line -- `crypto/vault_seal.rye`
      # names `max_frame_bytes` in an invariant comment three lines above an unrelated
      # `return error.PayloadTooLong`. Twelve missed and two admitted, tree-wide, one root.
      #
      # Strings are blanked before comments, so a `//` inside a literal never ends a line early and
      # a brace inside one never counts. Then the header is read by PAREN depth, which closes a
      # multi-line condition without guessing how many lines it takes, and the body by BRACE depth.
      # The braceless `if (c) return error.X;` and its two-line form keep their place.
      #
      # BOUNDED APPROXIMATION, named: a brace inside a nested literal spelling its own quote escape
      # is read as a brace. No such site stands in this tree today; when one does it reads as a
      # MISSED refusal and falls to the ratchet, which is the safe direction for a wrong answer.
      if awk -v c="$c" '
        function bare(s) {
          gsub(/\\[\\\\"]/, "", s)
          gsub(/"[^"]*"/, "", s)
          gsub(/'"'"'[^'"'"']*'"'"'/, "", s)
          sub(/\/\/.*$/, "", s)
          return s
        }
        { line[NR] = $0; strip[NR] = bare($0) }
        END {
          for (i = 1; i <= NR; i++) {
            if (!(strip[i] ~ ("(^|[^a-zA-Z0-9_])" c "([^a-zA-Z0-9_]|$)"))) continue
            if (!(strip[i] ~ /if \(|or |and /)) continue

            # The header: walk paren depth from this line until it returns to zero or below, so a
            # condition spanning several lines closes where its parentheses do.
            p = 0; h = 0
            for (j = i; j <= NR && j <= i + 16; j++) {
              s = strip[j]
              p += gsub(/\(/, "(", s) - gsub(/\)/, ")", s)
              if (strip[j] ~ /return [A-Za-z]*[Ee]rror\./) { exit 0 }
              if (p <= 0) { h = j; break }
            }
            if (h == 0) continue

            # The brace may close the header line or open on the next, which this tree writes both
            # ways; a blank line between them changes nothing.
            b = h
            if (!(strip[h] ~ /\{/)) {
              for (k = h + 1; k <= NR && k <= h + 2; k++) {
                if (strip[k] ~ /^[ \t]*$/) continue
                b = k
                break
              }
            }

            if (strip[b] ~ /\{/) {
              h = b
              # The body: brace depth from the header close to its matching brace.
              d = 0
              for (j = h; j <= NR; j++) {
                s = strip[j]
                d += gsub(/\{/, "{", s) - gsub(/\}/, "}", s)
                if (j > h && strip[j] ~ /return [A-Za-z]*[Ee]rror\./) { exit 0 }
                if (d <= 0) break
              }
            } else if (h + 1 <= NR && strip[h + 1] ~ /return [A-Za-z]*[Ee]rror\./) {
              exit 0
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
# The assert-only ratchet is PER ROOM SET and held here rather than in the caller, so a hand
# running the scan bare reads the same verdict the witness reads. A single merged total across
# every adopting room would let a repair in one room pay for a regression in another.
case "$rooms" in
  glow) asserted_default=3 ;;
  *)    asserted_default=1 ;;
esac
asserted_ceiling="${CEILING_TEETH_ASSERTED_CEILING:-$asserted_default}"
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
