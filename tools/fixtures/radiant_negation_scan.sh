#!/bin/sh
# Radiant negation ratchet -- prose states what holds, and names the exception once.
#
# Radiant Style asks for affirmative contrast: `rather than` over a heavy `not`, `yet` over `but`,
# a restated positive over a prohibition. The habit drifts, and it drifts hardest in LAW-SHAPED
# prose, because the easiest form a rule can take is a ban. Measured `20260821.211423`:
#
#   foundations/20260706-185112_follow-our-compass.md   0.4   <- the register to aim at
#   context/RADIANT_STYLE.md                            1.3
#   .claude/rules/design-rooms.md                       1.9   } all three written
#   .claude/rules/ascii-first.md                        2.1   } the same day, by
#   .claude/rules/stamp-and-name.md                     2.9   } the same hand
#
# Five times the register, in the rules that teach the register. A feeling made into a number.
#
# TWO ROSTERS, by tier, exactly as the ASCII guard does it:
#   ENFORCE  -- .claude/rules/*.md, unambiguously living Tier 3 prose. A file may FALL below its
#               baseline freely; rising above it fails hard. That is the ratchet.
#   ADVISORY -- foundations/ and context/ prose, REPORTED as a sweep-on-touch and never failed.
#               Dated testimony takes a recorded Radiant pass rather than a forced rewrite.
#
# A new ENFORCE file with no baseline row is reported and admitted at its measured value, so the
# guard welcomes new rules rather than blocking them; the ratchet begins on its second lap.
#
#   sh tools/fixtures/radiant_negation_scan.sh
#   sh tools/fixtures/radiant_negation_scan.sh prove-red
#
# Read-only: no network, no key, no funds, and no prose is rewritten here.
set -eu

MODE=${1:-}
HERE="$(CDPATH= cd "$(dirname "$0")" && pwd)"
BASELINE=${BASELINE:-$HERE/radiant_negation_baseline.txt}
CONTROL=$HERE/radiant_negation_control/prohibition_control.md

# The negation family counted, by WHOLE FIELD rather than by substring -- so a seated hyphenated
# term reads as vocabulary rather than as a negative construction. `accrete-never-break` is the
# name of a discipline; counting the `never` inside it would charge a rule for using the tree's
# own word. A substring meter reported stamp-and-name at 2.95 and this one reports 2.83, and the
# twelve-hundredths between them is exactly two occurrences of that compound. Word count comes
# from the same pass, so density and count agree by construction.
density_of() {
  awk '
    { w += NF
      for (i = 1; i <= NF; i++) {
        t = tolower($i)
        gsub(/[^a-z]/, "", t)
        if (t == "not" || t == "never" || t == "no" || t == "cannot" || t == "nothing" || t == "nobody") neg++
      }
    }
    END { if (w == 0) { print "0.00 0 0" } else { printf "%.2f %d %d\n", neg * 100 / w, neg, w } }
  ' "$1"
}

baseline_for() {
  awk -v p="$1" '$1 == p { print $2; found = 1 } END { if (!found) print "-" }' "$BASELINE" 2>/dev/null || echo -
}

if test "$MODE" = "prove-red"; then
  # The control MUST read far above any honest register, and the enforce rule MUST catch it.
  test -f "$CONTROL" || { echo "control_verdict=missing"; exit 1; }
  set -- $(density_of "$CONTROL")
  echo "control_density=$1"
  # A baseline of 1.00 stands in for any real rule; the control sits far above it on purpose.
  over=$(awk -v d="$1" 'BEGIN { print (d > 1.00) ? "yes" : "no" }')
  if test "$over" = yes; then
    echo "RED_negation_rise_caught=$1"
    exit 1
  fi
  echo "control_verdict=MISSED"
  exit 1
fi

test -f "$BASELINE" || { echo "baseline_verdict=missing"; exit 1; }

risen=0; admitted=0; enforced=0
for f in .claude/rules/*.md; do
  [ -f "$f" ] || continue
  enforced=$((enforced + 1))
  set -- $(density_of "$f")
  d=$1
  b=$(baseline_for "$f")
  if test "$b" = "-"; then
    echo "admit $f density=$d"
    admitted=$((admitted + 1))
    continue
  fi
  worse=$(awk -v d="$d" -v b="$b" 'BEGIN { print (d > b + 0.001) ? "yes" : "no" }')
  if test "$worse" = yes; then
    echo "RISEN $f density=$d baseline=$b"
    risen=$((risen + 1))
  fi
done
echo "enforce_files=$enforced"
echo "enforce_admitted=$admitted"
echo "enforce_risen=$risen"

# The advisory ratchet: reported so a sweep has a target, and failing nothing.
adv=0; advsum=0
for f in foundations/*.md context/RADIANT_STYLE.md context/TWILIGHT_STYLE.md context/KYRI.md; do
  [ -f "$f" ] || continue
  set -- $(density_of "$f")
  adv=$((adv + 1))
  advsum=$(awk -v s="$advsum" -v d="$1" 'BEGIN { printf "%.4f", s + d }')
done
echo "advisory_files=$adv"
echo "advisory_mean=$(awk -v s="$advsum" -v n="$adv" 'BEGIN { if (n == 0) print "0.00"; else printf "%.2f", s / n }')"
echo "register_target=0.40"
echo "advisory=ratchet_report"

if test "$risen" -eq 0; then
  echo "verdict=ok"
else
  echo "verdict=NEGATION_ROSE"
  exit 1
fi
