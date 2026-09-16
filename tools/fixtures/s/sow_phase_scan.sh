#!/bin/sh
# sow_phase_scan.sh -- read where a seed publish actually spends its minutes.
#
# REDS %642 asks for a content-keyed scrub cache, and the design that books it
# (expanding-prompts/20260908-155715_the-scrub-that-remembers.md) names what to
# measure BEFORE building one: how much of a publish is the per-file scrub, how
# much is the witness, and how many files actually change between publishes. This
# scan is that reading, so the numbers are re-run rather than recalled.
#
# TWO READINGS, ONE CHEAP AND ONE EXPENSIVE, and only the cheap one is gated.
#
#   sh tools/fixtures/s/sow_phase_scan.sh              # structure and churn, about 2s
#   sh tools/fixtures/s/sow_phase_scan.sh --time       # the same, plus real seconds (12 min)
#
# THE STRUCTURAL READING IS `projections_per_publish`, and it is the finding that
# pays for this instrument. `publish-seed.sh` runs the projection once through
# `tools/s/sow.rish`, and `tools/s/sow_witness.rish` runs it AGAIN as its duty 2,
# so a publish projects the whole seed TWICE. The witness has a reason -- it reads
# `seed/`, an absent `seed/` reads clean, and its own header says moving duty 3
# ahead of duty 2 would turn it green over nothing. The reason is sound and the
# cost was never a number until now. A ceiling that only falls makes the cost
# visible on the lap a third projection arrives.
#
# COUNTED BY CALL SITE RATHER THAN BY RUN, because counting runs means running
# them, and one run is six minutes. A call site is a line that invokes the
# projection script outside a comment, reachable from the publisher in at most two
# hops. That is a proxy and it is named as one: a site inside a conditional still
# counts, and a projection reached through a third hop is invisible.
#
# THE CHURN HALF asks the design's second question -- how many of the projection's
# candidate files change between two publishes -- read from the field's own history
# over the manifest's `allow` paths, since the seed itself is one force-pushed root
# commit and carries no history to read. A span wider than the set's own lifetime
# counts paths that have since left it, so a percentage above 100 is honest
# arithmetic over a moving denominator rather than a fault. A span holding no
# commit at all resolves to HEAD and reads zero changed, which is a different fact
# from a busy span where no candidate moved -- `churn_quiet=yes` tells the two apart.
set -eu

MANIFEST=template-manifest.bron
PUBLISHER=publish-seed.sh
PROJECTOR=tools/fixtures/s/sow_project.sh
WITNESS=tools/s/sow_witness.rish
CEILING_PROJECTIONS=2          # publish-seed.sh once, sow_witness.rish duty 2 once
MAX_HOPS=2                     # the publisher, then the scripts it names
MAX_CLOSURE=32                 # bound: a publish closure this size is already unreadable
SPAN=${SOW_PHASE_SPAN:-1 day}
DO_TIME=no

while [ $# -gt 0 ]; do
  case "$1" in
    --time) DO_TIME=yes ;;
    --span) shift; SPAN=${1:-1 day} ;;
    *) echo "sow_phase: unknown argument: $1 (want --time, --span <git date>)" >&2; exit 2 ;;
  esac
  shift
done

[ -f "$MANIFEST" ]  || { echo "sow_phase: $MANIFEST missing -- run from the field root" >&2; exit 2; }
[ -f "$PROJECTOR" ] || { echo "sow_phase: $PROJECTOR missing" >&2; exit 2; }

# --- the publish closure, bounded at two hops ------------------------------------------------
#
# A script is IN the closure when the publisher names it, or when something the publisher names
# does. Only tracked repository paths are followed; a bare command word is not a file here.
closure_file=$(mktemp)
next_file=$(mktemp)
trap 'rm -f "$closure_file" "$next_file"' EXIT INT TERM

if [ -f "$PUBLISHER" ]; then
  printf '%s\n' "$PUBLISHER" > "$closure_file"
else
  # The publisher is reconstructed on a clone that lacks it; the witness half still reads.
  : > "$closure_file"
fi

hop=0
while [ "$hop" -lt "$MAX_HOPS" ]; do
  : > "$next_file"
  while read -r src; do
    [ -f "$src" ] || continue
    # Names of tracked scripts, taken from live lines alone.
    grep -v '^[[:space:]]*#' "$src" 2>/dev/null \
      | grep -oE '(tools/[a-z]+/[a-zA-Z0-9_.-]+\.(sh|rish))' 2>/dev/null \
      | grep -vF "$PROJECTOR" >> "$next_file" || true
  done < "$closure_file"
  before=$(awk 'END {print NR}' "$closure_file")
  sort -u "$closure_file" "$next_file" -o "$closure_file"
  after=$(awk 'END {print NR}' "$closure_file")
  [ "$after" -le "$MAX_CLOSURE" ] || { echo "sow_phase: publish closure past $MAX_CLOSURE entries" >&2; exit 2; }
  [ "$after" -gt "$before" ] || break
  hop=$((hop + 1))
done

# The witness is in the closure by its own duty even when the publisher is absent from a clone.
grep -qxF "$WITNESS" "$closure_file" 2>/dev/null || printf '%s\n' "$WITNESS" >> "$closure_file"
sort -u "$closure_file" -o "$closure_file"

sites=""
projections=0
while read -r src; do
  [ -f "$src" ] || continue
  hits=$(grep -n "$PROJECTOR" "$src" 2>/dev/null | grep -v ':[[:space:]]*#' || true)
  [ -n "$hits" ] || continue
  n=$(printf '%s\n' "$hits" | awk 'END {print NR}')
  projections=$((projections + n))
  for ln in $(printf '%s\n' "$hits" | cut -d: -f1); do
    sites="$sites $src:$ln"
  done
done < "$closure_file"

closure=$(tr '\n' ' ' < "$closure_file")

# --- the candidate set, exactly as the projector builds it ------------------------------------
PATHS=$(grep -E '^allow ' "$MANIFEST" | awk '{print $2}' | grep -vxE 'vendor' || true)
allow_paths=$(printf '%s\n' "$PATHS" | awk 'NF {n++} END {print n + 0}')
candidates=0
for p in $PATHS; do
  candidates=$((candidates + $(git ls-files -- "$p" | awk 'END {print NR}')))
done

# --- churn over the same set ------------------------------------------------------------------
ref=$(git rev-list -1 --before="$SPAN ago" HEAD 2>/dev/null || true)
head=$(git rev-parse HEAD 2>/dev/null || true)
# A span holding no commit at all resolves to HEAD itself, and the diff then reads zero -- the same
# zero a busy span prints when no candidate happened to move. Two different facts wearing one
# number, so the reading says which: `churn_quiet=yes` means nothing was COMMITTED in that span.
quiet=no
if [ -n "$ref" ] && [ "$ref" = "$head" ]; then quiet=yes; fi
if [ -n "$ref" ]; then
  changed=$(git diff --name-only "$ref" HEAD -- $PATHS 2>/dev/null | awk 'END {print NR}')
  churn_ref=$(git rev-parse --short=10 "$ref")
else
  changed=-1
  churn_ref=none
  quiet=unread
fi

echo "publisher=$PUBLISHER publisher_present=$([ -f "$PUBLISHER" ] && echo yes || echo no)"
echo "closure=$closure"
echo "projection_sites=$(echo $sites)"
echo "projections_per_publish=$projections ceiling=$CEILING_PROJECTIONS"
echo "allow_paths=$allow_paths candidates=$candidates"
if [ "$changed" -ge 0 ]; then
  awk -v s="$SPAN" -v r="$churn_ref" -v n="$changed" -v c="$candidates" \
    'BEGIN {printf "churn_span=%s churn_ref=%s churn_changed=%d churn_pct=%.2f cache_hit_pct=%.2f", s, r, n, 100*n/c, (c-n >= 0 ? 100*(c-n)/c : 0)}'
  echo " churn_quiet=$quiet"
else
  echo "churn_span=$SPAN churn_ref=none churn_changed=unread churn_pct=unread cache_hit_pct=unread churn_quiet=$quiet"
fi

if [ "$DO_TIME" = yes ]; then
  # A real projection and a real witness, on this metal, in this tree. Six minutes each.
  t0=$(date +%s%N); sh "$PROJECTOR" >/dev/null 2>&1 || true; t1=$(date +%s%N)
  t2=$(date +%s%N); rishi/bin/rishi run "$WITNESS" >/dev/null 2>&1 || true; t3=$(date +%s%N)
  awk -v a=$t0 -v b=$t1 -v c=$t2 -v d=$t3 'BEGIN {
    p=(b-a)/1e9; w=(d-c)/1e9;
    printf "time_projection_s=%.2f time_witness_s=%.2f time_publish_s=%.2f\n", p, w, p+w;
    printf "time_witness_projection_share_pct=%.2f\n", (w > 0 ? 100*p/w : 0);
  }'
fi

if [ "$projections" -le "$CEILING_PROJECTIONS" ]; then
  echo "verdict=ok"
else
  echo "detail: a publish projects the whole seed $projections times, past the ceiling of $CEILING_PROJECTIONS"
  echo "verdict=over_ceiling"
fi
