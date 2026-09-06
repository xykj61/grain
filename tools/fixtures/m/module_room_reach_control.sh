#!/bin/sh
# tools/fixtures/m/module_room_reach_control.sh -- rooms built to hide a shelf, so the census is proven.
#
# WHY. tools/fixtures/m/module_room_reach_scan.sh publishes which rooms a flat glob lies about. A
# reading nobody has watched change is a reading nobody has tested, so this builds real git
# repositories in a throwaway pen and proves the census names a hidden shelf that is there and
# stays silent about one that is not. Every refusal is shown from both sides, because a refusal
# proven only in the passing direction cannot be told from a bypass.
#
# THE PEN IS A REAL REPOSITORY, on purpose. The scan asks `git ls-files`, since authored means
# tracked and a build output is not a module. `room_bound_control.sh` phase three learned this the
# expensive way -- its pens were plain directories, so the sweep read nothing in them and every
# line it printed went untested for the control's whole life.
#
# SIX PHASES.
#   flat      -- a room whose Rye is all at top level reads `flat_reaches_all`, hidden zero
#   shelf     -- ONE file planted one level down flips that room to `hidden_shelf`; removing it
#                returns the room to `flat_reaches_all`, which is the both-sides proof
#   inverted  -- a room holding Rye ONLY below its top level reads `flat_reads_zero`, since there
#                a flat glob does not understate the room, it reports the room as empty
#   skipped   -- a planted `vendor/` room never appears; third-party structure is not ours to count
#   vacuum    -- a repository with no tracked .rye refuses `verdict=blind` rather than reporting a
#                clean zero, because reading nothing is not the same as finding nothing
#   patterns  -- one of the scan's three counting patterns is deliberately broken in a COPY, and
#                the arithmetic gate must catch it. This is the leg that proves the gate is not
#                decorative: `hidden` was once derived as `recursive - flat`, which made the check
#                true for every input, and this phase is what a subtraction could never pass.
#
# EXPECTED: phases flat, shelf, inverted, skipped each named and silent on their off side; vacuum
# and patterns each refusing with a non-zero exit.
#
# Driven by tools/m/module_room_reach_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/m/module_room_reach_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

pen_init() {
  mkdir -p "$1"
  git -C "$1" init -q 2>/dev/null
}

# -- the main pen: one flat room, later given a shelf --------------------------------------------
pen="$work/pen"
pen_init "$pen"
mkdir -p "$pen/alpha"
: > "$pen/alpha/one.rye"
: > "$pen/alpha/two.rye"

# A room whose Rye lives ONLY below its top level -- the inverted reading.
mkdir -p "$pen/beta/src"
: > "$pen/beta/src/three.rye"

# Third-party structure, which the census must never count as ours.
mkdir -p "$pen/vendor/upstream"
: > "$pen/vendor/upstream/foreign.rye"

git -C "$pen" add -A >/dev/null 2>&1
cd "$pen"
flat_out="$(sh "$scan" list 2>&1 || true)"

# Now plant exactly one file one level down inside the flat room.
mkdir -p "$pen/alpha/src"
: > "$pen/alpha/src/hidden.rye"
git -C "$pen" add -A >/dev/null 2>&1
shelf_out="$(sh "$scan" list 2>&1 || true)"

# And take it away again, so the flip is proven in both directions rather than once.
git -C "$pen" rm -q --cached alpha/src/hidden.rye >/dev/null 2>&1
rm -f "$pen/alpha/src/hidden.rye"
removed_out="$(sh "$scan" list 2>&1 || true)"

# -- the vacuum pen: a real repository holding no tracked Rye at all ------------------------------
empty="$work/empty"
pen_init "$empty"
: > "$empty/README.md"
git -C "$empty" add -A >/dev/null 2>&1
cd "$empty"
vacuum_out="$(sh "$scan" 2>&1 || true)"
vacuum_code=0
sh "$scan" >/dev/null 2>&1 || vacuum_code=$?

# -- the pattern pen: one counting pattern broken in a COPY of the scan ---------------------------
# `hidden` is counted by its own pattern rather than derived, so breaking that pattern makes the
# three readings disagree. A scan that derived it could not fail this phase, which is why the
# phase exists.
broken="$work/broken_scan.sh"
sed 's|grep -c "\^\$room/\[\^/\]\*/"|grep -c "^$room/never-matches-anything/"|' "$scan" > "$broken"
cd "$pen"
git -C "$pen" add -A >/dev/null 2>&1
mkdir -p "$pen/alpha/src"
: > "$pen/alpha/src/hidden.rye"
git -C "$pen" add -A >/dev/null 2>&1
pattern_out="$(sh "$broken" 2>&1 || true)"
pattern_code=0
sh "$broken" >/dev/null 2>&1 || pattern_code=$?

cd "$root"

echo "phase=flat"
printf '%s\n' "$flat_out" | grep -E '^room=alpha|^hidden_rooms=' || true

echo "phase=shelf"
printf '%s\n' "$shelf_out" | grep -E '^room=alpha|^hidden_rooms=|^hidden_total=' || true

echo "phase=removed"
printf '%s\n' "$removed_out" | grep -E '^room=alpha' || true

echo "phase=inverted"
printf '%s\n' "$flat_out" | grep -E '^room=beta|^inverted=' || true

echo "phase=skipped"
if printf '%s\n' "$flat_out" | grep -q '^room=vendor'; then
  echo "vendor_counted=1"
else
  echo "vendor_counted=0"
fi

echo "phase=vacuum"
printf '%s\n' "$vacuum_out" | grep -E '^verdict=|^rooms_read=|^instrument=' || true
echo "vacuum_exit=$vacuum_code"

echo "phase=patterns"
printf '%s\n' "$pattern_out" | grep -E '^verdict=|^inconsistent=' || true
echo "pattern_exit=$pattern_code"
