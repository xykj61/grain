#!/bin/sh
# Radiant negation ratchet -- prose states what holds, and names the exception once.
#
# Radiant Style asks for affirmative contrast: `rather than` over a heavy `not`, `yet` over `but`,
# a restated positive over a prohibition. The habit drifts, and it drifts hardest in LAW-SHAPED
# prose, because the easiest form a rule can take is a ban. Measured `20260821.211423`:
#
#   foundations/20260826-024943_follow-our-compass.md   0.4   <- the register to aim at
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
#   sh tools/fixtures/r/radiant_negation_scan.sh
#   sh tools/fixtures/r/radiant_negation_scan.sh prove-red
#
# Read-only: no network, no key, no funds, and no prose is rewritten here.
set -eu

MODE=${1:-}
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
# The baseline is a flat fixture the fold moved into its letter room; the control corpus is a
# fixtures SUBDIRECTORY, which the fold leaves in place.
BASELINE=${BASELINE:-$_fd_root/tools/fixtures/r/radiant_negation_baseline.txt}
CONTROL=$_fd_root/tools/fixtures/radiant_negation_control/prohibition_control.md

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

# A LOOKUP THAT COULD NOT RUN IS A REFUSAL, NEVER AN ADMIT. This line read
# `... 2>/dev/null || echo -` until `20260906`, which threw away awk's reason AND put back the one
# token that means *no baseline row for this file, admit it at its measured value*. Pointed at a
# mode-000 baseline the guard printed `enforce_admitted=51` of `enforce_files=51`,
# `enforce_risen=0`, `verdict=ok`, exit 0 -- green while comparing nothing, and its own stderr
# already gone. Now awk's reason reaches the caller and a failure yields NO answer, which the probe
# below catches ahead of the loop and which an empty `b` turns into a rise rather than an admit.
baseline_for() {
  awk -v p="$1" '$1 == p { print $2; found = 1 } END { if (!found) print "-" }' "$BASELINE"
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
# EXISTS AND READABLE ARE TWO QUESTIONS, and only the first had a check. A baseline that exists and
# cannot be read fails every lookup below, and each failure used to become an admission -- so the
# corpus read as 51 brand-new rules and the ratchet compared nothing. One awk read of the whole
# file answers it once, loudly, before a single file is measured.
_rn_work=$(mktemp -d)
trap 'rm -rf "$_rn_work"' EXIT INT TERM
if ! awk 'END { }' "$BASELINE" 2>"$_rn_work/err"; then
  echo "baseline_verdict=unreadable"
  sed -n '1,3p' "$_rn_work/err" | sed 's/^/detail_awk=/'
  echo "refused: the baseline exists and cannot be read, so every lookup would admit its file and the ratchet would compare nothing." >&2
  exit 1
fi

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
echo "enforce_matched=$((enforced - admitted))"
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

# A BASELINE THAT MATCHES NOTHING IS A BASELINE COMPARING NOTHING, and it reads exactly like a
# healthy tree: `risen=0`, `verdict=ok`, exit 0. This is the sibling of the swallow above and needs
# its own gate, because here awk RUNS and answers honestly -- an emptied, truncated, or path-shifted
# baseline simply has no row for any file. The guard already refuses a MISSING baseline, so a
# present one matching not a single file in the corpus is broken rather than fresh. Measured
# `20260906`: the honest tree reads 14 admitted of 51, and an empty baseline read 51 of 51.
if test "$enforced" -gt 0 && test "$admitted" -eq "$enforced"; then
  echo "verdict=BASELINE_MATCHED_NOTHING"
  echo "refused: a baseline is present and matched none of the $enforced files, so nothing was compared." >&2
  exit 1
fi

if test "$risen" -eq 0; then
  echo "verdict=ok"
else
  echo "verdict=NEGATION_ROSE"
  exit 1
fi
