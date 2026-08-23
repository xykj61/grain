#!/bin/sh
# tools/fixtures/readme_metrics_scan.sh -- the numbers the front door is allowed to show.
#
# WHY ONLY THESE FOUR. A README is the most Lindy-exposed document a project owns: its whole
# promise is that a reader arriving three years on still finds it true. So a number typed there by
# hand is a claim that rots, and a number that moves every commit is a claim nobody will keep
# current. These four move only when something real changes, and each says something a reader
# actually wants to know:
#
#   fascia          the connective-tissue grade, 0-100 -- can a reader follow any thread home
#   witnesses       proofs that run on metal
#   modules         Rye modules those proofs stand over -- the RATIO is the interesting part
#   rooms_over      rooms grown past what a browser can list; enforced at zero
#
# Deliberately absent: the commit count and the tracked-file count. Both move constantly, neither
# says anything about whether the software is well, and a block that goes stale every commit is a
# block that stops being regenerated within a week.
#
# THE DISCIPLINE THIS CARRIES, and the wall that now runs it. Add a witness or a module and this
# block goes stale, so it is regenerated in the same commit -- the same habit the REMEMBER git nib
# already keeps. One command: `rishi/bin/rishi run tools/readme_metrics.rish write`. That sentence
# stood here as a comment for a while and no program ran it, so the block went stale inside the very
# commit that made it stale, twice in two days (REDS %151, %152). `tools/hooks/pre-commit` is the
# same sentence made executable: a commit that adds or removes a witness or a Rye module renders the
# block and stages it alongside. The fascia grade and the rooms-over count can still drift from a
# commit that moves neither, and the rostered readme_metrics guard is what catches those.
#
# USAGE
#   sh tools/fixtures/readme_metrics_scan.sh
#
# Driven by tools/readme_metrics.rish; proven by tools/readme_metrics_witness.rish.
# Run from the repository root.

set -eu

# stdin is closed for the fascia call on purpose: it blocks when it inherits one, and a
# metrics scan that hangs in a witness is a metrics scan nobody runs.
fascia=$(sh tools/fixtures/fascia_metric_v0.sh </dev/null 2>/dev/null | sed -n 's/^fascia=\([0-9][0-9]*\)$/\1/p' | head -1)
[ -n "${fascia:-}" ] || fascia=unknown

witnesses=$(git ls-files 'tools/*_witness.rish' | wc -l | tr -d ' ')
modules=$(git ls-files '*.rye' | wc -l | tr -d ' ')
rooms_over=$(sh tools/fixtures/room_bound_scan.sh </dev/null 2>/dev/null | grep -c 'verdict=over' || true)

echo "fascia=$fascia"
echo "witnesses=$witnesses"
echo "modules=$modules"
echo "rooms_over=$rooms_over"

if [ "$fascia" = unknown ]; then
  echo "verdict=unmeasured"
  exit 1
fi
echo "verdict=ok"
