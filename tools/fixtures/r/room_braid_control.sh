#!/bin/sh
# tools/fixtures/r/room_braid_control.sh -- the braid census, asked its questions on a corpus
# whose answer is known by construction.
#
# WHY A CONTROL. The tree holds a nine-room braid today, so a scan of the tree proves the census
# can find A braid and nothing more. It cannot show the census would go GREEN on a clean tree, and
# a refusal proven only in the failing direction cannot be told from an instrument that always
# refuses. Every leg below is planted, read, then lifted and read again.
#
# WHAT IT PROVES, on real git repositories in a throwaway pen.
#   ACYCLIC LEG   -- three rooms in a chain, a -> b -> c, every link imported. No cycle, so the
#                    census reads braid_max=0 and passes under any ceiling.
#   BRAID LEG     -- one link added closing c -> a. The same three rooms now form a component of
#                    three, and the census refuses by NAME above a ceiling of two.
#   LIFT LEG      -- that one link removed returns the reading to acyclic, so the refusal tracks
#                    the tree rather than the pen's age.
#   DEAD-LINK LEG -- a cross-room symlink nobody imports counts as `edges_dead` and NOT as an edge.
#                    Counting it would publish a dependency that does not exist; the tree carries
#                    20 such links today, and one of them would close a false cycle.
#   FOLLOW LEG    -- a link imported only by ANOTHER link is LIVE. Reading the importers without
#                    `grep -R` called 70 of the tree's 226 links dead where 20 are, so this leg is
#                    the one that keeps the correction from silently regressing.
#   SAME-ROOM LEG -- a symlink inside one room is filing, never a dependency, and never an edge.
#   EMPTY LEG     -- a tree with no cross-room symlink refuses `empty_corpus` rather than reporting
#                    a clean zero, since an instrument measuring nothing must say so (REDS %170).

set -eu
scan=$(cd "$(dirname "$0")/../../.." && pwd)/tools/fixtures/r/room_braid_census_scan.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
pass=0; fail=0

check() { # check <label> <expected-substring> <output>
  if printf '%s' "$3" | grep -qF "$2"; then pass=$((pass + 1)); echo "  ok   $1"
  else fail=$((fail + 1)); echo "  FAIL $1 -- wanted '$2'"; printf '%s\n' "$3" | sed 's/^/       /'; fi
}

build() { # build a pen tree; leaves $pen/t as a git repo
  rm -rf "$pen/t"; mkdir -p "$pen/t"
  ( cd "$pen/t" && git init -q . && git config user.email a@b && git config user.name a )
}
add() { ( cd "$pen/t" && git add -A && git commit -q -m x >/dev/null 2>&1 || true ); }
run() { ( cd "$pen/t" && ROOM_BRAID_MAX=${1:-2} sh "$scan" 2>&1 || true ); }

echo "room-braid control -- the census on a corpus whose answer is known"

# --- ACYCLIC: a -> b -> c, nothing closing it.
build
mkdir -p "$pen/t/a" "$pen/t/b" "$pen/t/c"
echo 'const std = @import("std");' > "$pen/t/b/bee.rye"
echo 'const std = @import("std");' > "$pen/t/c/cee.rye"
( cd "$pen/t/a" && ln -s ../b/bee.rye bee.rye )
( cd "$pen/t/b" && ln -s ../c/cee.rye cee.rye )
echo 'const bee = @import("bee.rye");' > "$pen/t/a/main.rye"
echo 'const cee = @import("cee.rye");' >> "$pen/t/b/bee_user.rye"
add
out=$(run 2)
check "acyclic reads no braid" "braid_max=0" "$out"
check "acyclic passes" "verdict=under_ceiling" "$out"
check "acyclic counts both live edges" "edges_live=2" "$out"

# --- BRAID: close c -> a and the three rooms become one component.
echo 'const std = @import("std");' > "$pen/t/a/ay.rye"
( cd "$pen/t/c" && ln -s ../a/ay.rye ay.rye )
echo 'const ay = @import("ay.rye");' > "$pen/t/c/cee_user.rye"
add
out=$(run 2)
check "the closed cycle is found" "component size=3" "$out"
check "braid_max rises to three" "braid_max=3" "$out"
check "it refuses by name above the ceiling" "verdict=braid_over_ceiling" "$out"
check "the refusal names the rooms" "pull any one and the rest come with it" "$out"
out=$(run 3)
check "a ceiling of three welcomes the same tree" "verdict=under_ceiling" "$out"

# --- LIFT: remove the closing link and the refusal goes.
rm -f "$pen/t/c/ay.rye" "$pen/t/c/cee_user.rye"
add
out=$(run 2)
check "lifting the link returns it to acyclic" "braid_max=0" "$out"

# --- DEAD LINK: a cross-room symlink nobody imports is no edge, and closes no cycle.
( cd "$pen/t/c" && ln -s ../a/ay.rye ay.rye )
add
out=$(run 2)
check "an unimported link is counted dead" "edges_dead=1" "$out"
check "and closes no cycle" "braid_max=0" "$out"

# --- FOLLOW: the importer is itself a symlink, so the edge is live.
echo 'const ay = @import("ay.rye");' > "$pen/t/a/uses_ay.rye"
( cd "$pen/t/c" && ln -s ../a/uses_ay.rye uses_ay.rye )
add
out=$(run 2)
# The helper link `c/uses_ay.rye` is itself imported by nobody, so it stays dead and correctly so.
# What this leg proves is that `c/ay.rye` -- named in an `@import` only inside a SYMLINKED file --
# crossed from dead to live: edges_live rises two -> three and the cycle it closes appears.
check "a link imported only by a link is live" "edges_live=3" "$out"
check "so the cycle it closes is found" "braid_max=3" "$out"
check "the unimported helper stays dead" "edges_dead=1" "$out"

# --- SAME ROOM: a link inside one room is filing, never an edge.
build
mkdir -p "$pen/t/a/sub" "$pen/t/b"
echo 'const std = @import("std");' > "$pen/t/a/one.rye"
echo 'const std = @import("std");' > "$pen/t/b/two.rye"
( cd "$pen/t/a/sub" && ln -s ../one.rye one.rye )
echo 'const one = @import("one.rye");' > "$pen/t/a/sub/user.rye"
( cd "$pen/t/a" && ln -s ../b/two.rye two.rye )
echo 'const two = @import("two.rye");' > "$pen/t/a/user.rye"
add
out=$(run 2)
check "a same-room link is no cross edge" "cross=1" "$out"

# --- EMPTY: no cross-room symlink at all refuses rather than reading clean.
build
mkdir -p "$pen/t/a"
echo 'const std = @import("std");' > "$pen/t/a/only.rye"
add
out=$(run 2)
check "an empty corpus refuses" "verdict=empty_corpus" "$out"

echo "room-braid control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
