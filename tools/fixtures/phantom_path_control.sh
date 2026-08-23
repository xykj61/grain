#!/bin/sh
# tools/fixtures/phantom_path_control.sh -- proves tools/fixtures/phantom_path_scan.sh both ways.
#
# The scan's claim is that a tool reads a path the repository carries. A control that mimicked a
# repository would prove nothing about that claim, so each case here builds a REAL git repository
# in a temporary pen, commits it, and runs the scan against it. Eight behaviors: one clean pass,
# two refusals, and five readings that must stay free -- because a guard that reds on honest
# input teaches the bench to route around it.
#
# Prints one `case=<name> <verdict>` line per case and a final `control=ok` when all agree.
#
# USAGE
#   sh tools/fixtures/phantom_path_control.sh
#
# Driven by tools/phantom_path_witness.rish. Run from the repository root.

set -eu

SCAN=$(CDPATH= cd -- "$(dirname "$0")" && pwd)/phantom_path_scan.sh
[ -f "$SCAN" ] || { echo "control=no_scan"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
faults=0

# Build a minimal repository: one real room, one tool, one descriptor.
build() {
  d="$pen/$1"
  rm -rf "$d"; mkdir -p "$d/construction" "$d/tools/fixtures" "$d/vendor"
  cd "$d"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name Pen
  git config commit.gpgsign false
  printf 'living card\n' > construction/ITINERARY.md
  printf 'name pen\n' > .brix
  printf '#!/bin/sh\nset -eu\ncat construction/ITINERARY.md\n' > tools/reader.sh
  git add -A
  git commit -qm 'pen: the room and its reader'
}

verdict_of() { sh "$SCAN" 2>/dev/null | sed -n 's/^verdict=//p'; }
count_of()   { sh "$SCAN" 2>/dev/null | sed -n 's/^phantom_paths=//p'; }

check() {
  name=$1; want=$2; got=$3
  if [ "$got" = "$want" ]; then
    echo "case=$name ok ($got)"
  else
    echo "case=$name FAULT want=$want got=$got"
    faults=$((faults + 1))
  fi
}

# 1 -- a clean tree reads only what it carries.
build clean
check clean_free ok "$(verdict_of)"

# 2 -- a tool reading through an untracked compatibility symlink is refused and counted.
build phantom
ln -s construction work-in-progress
printf '#!/bin/sh\nledger="work-in-progress/ITINERARY.md"\ncat "$ledger"\n' > tools/stale.sh
git add tools/stale.sh; git commit -qm 'pen: a tool reading the elder room'
check phantom_refused phantom_paths "$(verdict_of)"
check phantom_counted 1 "$(count_of)"

# 3 -- the same path inside a COMMENT stays free: the scan reads what a tool reads, never what
#      it says, so a guard may always explain the breach that created it.
build comment
ln -s construction work-in-progress
printf '#!/bin/sh\n# once this read work-in-progress/ITINERARY.md\ncat construction/ITINERARY.md\n' > tools/told.sh
git add tools/told.sh; git commit -qm 'pen: a tool that only mentions the elder room'
check comment_free ok "$(verdict_of)"

# 4 -- a vendor/ literal is free: that room is provisioned rather than tracked.
build vendored
mkdir -p vendor/lib; printf 'x\n' > vendor/lib/thing.rye
printf '#!/bin/sh\ncat vendor/lib/thing.rye\n' > tools/vend.sh
git add tools/vend.sh; git commit -qm 'pen: a tool reading a provisioned room'
check vendor_free ok "$(verdict_of)"

# 5 -- a dot-segment names a generated or machine-local room, and stays free.
build dotroom
mkdir -p tools/.build; printf 'x\n' > tools/.build/page.md
printf '#!/bin/sh\ncat tools/.build/page.md\n' > tools/gen.sh
git add tools/gen.sh; git commit -qm 'pen: a tool reading a generated room'
check dotroom_free ok "$(verdict_of)"

# 6 -- a literal resolving NOWHERE is a plain dangling reference and belongs to another guard.
build nowhere
printf '#!/bin/sh\ncat construction/ABSENT.md\n' > tools/gone.sh
git add tools/gone.sh; git commit -qm 'pen: a tool naming nothing at all'
check nowhere_free ok "$(verdict_of)"

# 7 -- a literal travelling through a TRACKED symlink resolves for a reader who clones.
build linked
mkdir -p pond
ln -s ../crux pond/cards
printf '#!/bin/sh\ncat pond/cards/ITINERARY.md\n' > tools/via.sh
git add -A; git commit -qm 'pen: a tracked link and a tool reading through it'
check tracked_link_free ok "$(verdict_of)"

# 8 -- the descriptor is in scope: a phantom brick is a phantom.
build descriptor
ln -s construction work-in-progress
printf 'name pen\nfile work-in-progress/ITINERARY.md\n' > .brix
git add .brix; git commit -qm 'pen: a descriptor listing the elder room'
check descriptor_refused phantom_paths "$(verdict_of)"

if [ "$faults" -eq 0 ]; then
  echo "control=ok"
  exit 0
fi
echo "control=faults faults=$faults"
exit 2
