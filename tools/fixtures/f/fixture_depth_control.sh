#!/bin/sh
# tools/fixtures/f/fixture_depth_control.sh -- the depth-proof root walk, proven from both sides.
#
# WHY. The letter fold of `tools/fixtures/` (seated 20260828, the last room of REDS %301) moved
# every flat fixture one directory deeper -- `tools/fixtures/<name>` became
# `tools/fixtures/<letter>/<name>` -- and 61 scripts in the room computed the repository root by
# fixed depth arithmetic from their own dirname: `ROOT=$(cd "$(dirname "$0")/../.." && pwd)`.
# Depth arithmetic is a promise about where the file sits, and a fold is precisely what breaks
# that promise: two-up from `tools/fixtures/f/` is `tools/`, and every path built on it reads a
# tree that is not there. The same fold separates siblings, so the old sibling source
# `. "$(dirname "$0")/shell_portable.sh"` stops landing the moment its citer and its target sit
# in different letter rooms.
#
# THE SHAPE THIS PROVES. The depth-proof walk climbs UPWARD from the script's own directory to
# the first ancestor holding both `rishi/bin` and `tools/fixtures` -- the root's own furniture --
# bounded at 8 steps and refusing loudly past the bound. Git-free on purpose: controls copy scans
# into pens outside any repository, and a pen that plants the two marker directories is a root
# the walk finds exactly the way the real tree is.
#
# WHAT IS PROVEN, on real files in a throwaway pen, each behavior from the side that can fail:
#   1. the elder two-up arithmetic, run one directory deeper, resolves the WRONG root -- shown
#   2. the walk resolves the RIGHT root from depth 2 (the elder flat seat)
#   3. the walk resolves the RIGHT root from depth 3 (the letter room)
#   4. the elder sibling source breaks from a letter room -- shown
#   5. the new source spelling, <root>/tools/fixtures/s/shell_portable.sh via the walk, works
#      from BOTH depths
#   6. the walk REFUSES loudly, exit 2, in a pen carrying no markers within the 8-step bound
#
# USAGE
#   sh tools/fixtures/f/fixture_depth_control.sh
#
# Driven by tools/f/fixture_depth_witness.rish. Run from anywhere.
set -eu

pen=$(mktemp -d)
# mktemp on macOS answers a /var/... path whose canonical spelling is /private/var/...; the walk
# compares pwd output against pwd output, so the pen's name is canonicalized once here.
pen=$(cd "$pen" && pwd)
trap 'rm -rf "$pen"' EXIT INT TERM

behaviors=0

# The pen wears the root's furniture: both markers stand, so the walk can find it.
mkdir -p "$pen/rishi/bin" "$pen/tools/fixtures/f" "$pen/tools/fixtures/s"

# The marker sourced file at its NEW home, one letter room down.
cat > "$pen/tools/fixtures/s/shell_portable.sh" <<'HELPER'
# planted portable helper -- proves the source landed, nothing more
portable_marker() { echo portable-marker-landed; }
HELPER

# ---------------------------------------------------------------------------------------------
# BEHAVIOR ONE -- the elder arithmetic, one directory deeper, names the wrong root.
# ---------------------------------------------------------------------------------------------

cat > "$pen/elder_probe.sh" <<'ELDER'
#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
printf '%s\n' "$ROOT"
ELDER
cp "$pen/elder_probe.sh" "$pen/tools/fixtures/elder_probe.sh"
cp "$pen/elder_probe.sh" "$pen/tools/fixtures/f/elder_probe.sh"

elder_flat=$(sh "$pen/tools/fixtures/elder_probe.sh")
elder_deep=$(sh "$pen/tools/fixtures/f/elder_probe.sh")

if [ "$elder_flat" != "$pen" ]; then
  echo "refused: the elder arithmetic must still answer the root from the flat seat -- got $elder_flat" >&2
  exit 1
fi
if [ "$elder_deep" = "$pen" ]; then
  echo "refused: the elder arithmetic one directory deeper must name the WRONG root, or this control proves nothing" >&2
  exit 1
fi
if [ "$elder_deep" != "$pen/tools" ]; then
  echo "refused: the elder arithmetic from the letter room must land exactly one short, at <root>/tools -- got $elder_deep" >&2
  exit 1
fi
behaviors=$((behaviors + 1))
echo "behavior_one=elder_arithmetic_wrong_root_shown deep=$elder_deep"

# ---------------------------------------------------------------------------------------------
# BEHAVIORS TWO AND THREE -- the walk answers the right root from both depths.
# ---------------------------------------------------------------------------------------------

cat > "$pen/walk_probe.sh" <<'WALK'
#!/bin/sh
set -eu
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
printf '%s\n' "$ROOT"
WALK
cp "$pen/walk_probe.sh" "$pen/tools/fixtures/walk_probe.sh"
cp "$pen/walk_probe.sh" "$pen/tools/fixtures/f/walk_probe.sh"

walk_flat=$(sh "$pen/tools/fixtures/walk_probe.sh")
walk_deep=$(sh "$pen/tools/fixtures/f/walk_probe.sh")

if [ "$walk_flat" != "$pen" ]; then
  echo "refused: the walk from depth 2 must answer the pen root -- got $walk_flat" >&2
  exit 1
fi
behaviors=$((behaviors + 1))
echo "behavior_two=walk_right_root_from_flat_seat root=$walk_flat"

if [ "$walk_deep" != "$pen" ]; then
  echo "refused: the walk from depth 3 must answer the same pen root -- got $walk_deep" >&2
  exit 1
fi
behaviors=$((behaviors + 1))
echo "behavior_three=walk_right_root_from_letter_room root=$walk_deep"

# ---------------------------------------------------------------------------------------------
# BEHAVIOR FOUR -- the elder sibling source breaks from a letter room. The fold separates
# siblings, and a source line that spells `$(dirname "$0")/shell_portable.sh` reads a file that
# is no longer beside it.
# ---------------------------------------------------------------------------------------------

cat > "$pen/tools/fixtures/f/elder_source_probe.sh" <<'ESRC'
#!/bin/sh
set -eu
. "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"
portable_marker
ESRC

if sh "$pen/tools/fixtures/f/elder_source_probe.sh" >/dev/null 2>&1; then
  echo "refused: the elder sibling source from a letter room must break -- it landed, so this control proves nothing" >&2
  exit 1
fi
behaviors=$((behaviors + 1))
echo "behavior_four=elder_sibling_source_breaks_from_letter_room"

# ---------------------------------------------------------------------------------------------
# BEHAVIOR FIVE -- the new source spelling works from both depths: resolve the root by the same
# walk, then source <root>/tools/fixtures/s/shell_portable.sh.
# ---------------------------------------------------------------------------------------------

cat > "$pen/new_source_probe.sh" <<'NSRC'
#!/bin/sh
set -eu
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
. "$ROOT/tools/fixtures/s/shell_portable.sh"
portable_marker
NSRC
cp "$pen/new_source_probe.sh" "$pen/tools/fixtures/new_source_probe.sh"
cp "$pen/new_source_probe.sh" "$pen/tools/fixtures/f/new_source_probe.sh"

src_flat=$(sh "$pen/tools/fixtures/new_source_probe.sh")
src_deep=$(sh "$pen/tools/fixtures/f/new_source_probe.sh")

if [ "$src_flat" != "portable-marker-landed" ]; then
  echo "refused: the new source spelling from depth 2 must land the helper -- got '$src_flat'" >&2
  exit 1
fi
if [ "$src_deep" != "portable-marker-landed" ]; then
  echo "refused: the new source spelling from depth 3 must land the helper -- got '$src_deep'" >&2
  exit 1
fi
behaviors=$((behaviors + 1))
echo "behavior_five=new_source_spelling_lands_from_both_depths"

# ---------------------------------------------------------------------------------------------
# BEHAVIOR SIX -- the walk refuses loudly where no root stands within the bound. A second pen
# carries neither marker, so the walk climbs past it and must give up by the eighth step rather
# than wander to / and guess.
# ---------------------------------------------------------------------------------------------

bare=$(mktemp -d)
bare=$(cd "$bare" && pwd)
trap 'rm -rf "$pen" "$bare"' EXIT INT TERM
mkdir -p "$bare/a/b"
cp "$pen/walk_probe.sh" "$bare/a/b/walk_probe.sh"

refusal_out=$(sh "$bare/a/b/walk_probe.sh" 2>&1) && refusal_code=0 || refusal_code=$?
if [ "$refusal_code" != 2 ]; then
  echo "refused: the walk in a markerless pen must exit 2 -- got code $refusal_code, out '$refusal_out'" >&2
  exit 1
fi
case "$refusal_out" in
  *"no tree root within 8 steps"*) : ;;
  *) echo "refused: the markerless refusal must say why, naming the bound and the markers -- got '$refusal_out'" >&2; exit 1 ;;
esac
behaviors=$((behaviors + 1))
echo "behavior_six=walk_refuses_loudly_past_the_bound code=$refusal_code"

echo "behaviors_proven=$behaviors"
echo "verdict=ok"
