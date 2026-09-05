#!/bin/sh
# tools/fixtures/g/geode_libraries_control.sh -- prove the module count by doing, on real repositories.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and a counting rule proven only in the
# passing direction cannot be told from a rule that counts everything. This control builds git
# repositories in a temporary pen, plants one condition in each, runs the REAL
# tools/fixtures/g/geode_libraries_scan.sh inside them, and reads the `lib=` line back. The scan is
# run rather than copied, so the control and the rule can never drift apart -- a shared body shared
# by copying is shared only until somebody improves one of them (REDS %215).
#
# WHAT IS PROVEN, ten readings, both directions.
#   1. A module git ignores stays out of the count. This is the repair: the `glow` room keeps a `.cache` of 108
#      generated modules and the `glow` row published 238 where the tree keeps 130 (REDS %216).
#   2. The SAME files count when nothing ignores them, so the rule reads the ignore list rather
#      than the word `cache` or a depth.
#   3. A module that is untracked and unignored counts, because a module written this minute is
#      real and belongs in the index before it is committed.
#   4. A room holding only ignored modules leaves the index entirely, rather than appearing at zero.
#   5. A witness whose only mention of a room is the interpreter it RUNS UNDER counts zero for that
#      room. This is REDS %423's repair: the page published 1,770 witnesses for `rishi` -- 98 percent
#      of every witness in the tree, against a room holding two modules -- because each one opens
#      `rishi/bin/rishi`.
#   6. The same room counts 1 when a witness really names a path inside it, so a rule that merely
#      dropped `rishi` from the index would read 0 in both and reading 5 would have proven nothing.
#   7, 8. The compiler, the same way, both directions: `rye/bin/rye` is not a reference and
#      `rye/README.md` is.
#   9. An ordinary room still counts its witness, so the strip reaches the two entry paths rather
#      than every path holding a slash.
#  10. A hyphen before the room name still opens a reference. The elder rule counted a room when the
#      character before it was not a letter, digit, or underscore, and the matching mechanism changed
#      underneath -- a boundary nobody re-checks is a boundary that quietly moves.
#
# WHAT IS NOT PROVEN. Whether a witness that names a room proves anything ABOUT it. This counts
# references honestly; it does not read them.
#
# USAGE
#   sh tools/fixtures/g/geode_libraries_control.sh
#
# Driven by tools/g/geode_libraries_witness.rish. Run from the repository root.

set -u

# The scan under test defaults to the living one; naming another lets this control be pointed at a
# deliberately broken copy, which is how the control itself is proven to bite.
scan=${1:-$(pwd)/tools/fixtures/g/geode_libraries_scan.sh}
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# A repository holding one room with a door, one tracked module, and two generated ones under
# `.cache/`. `ignore` decides whether the repository ignores that cache; `extra` optionally plants
# one further module and leaves it uncommitted.
build() {
    name=$1
    ignore=$2
    tracked=$3
    extra=$4
    d=$pen/$name
    mkdir -p "$d/tools" "$d/roomA/.cache"
    (
        cd "$d" || exit 1
        git init -q .
        git config user.email pen@example.invalid
        git config user.name Pen
        printf '# a pen witness that names roomA/ so the roster is never empty\nsay "roomA/ is the room this proves"\n' > tools/pen_witness.rish
        printf '# Room A\n' > roomA/README.md
        if [ "$tracked" = yes ]; then
            printf 'const std = @import("std");\n' > roomA/mod_one.rye
        fi
        printf 'const std = @import("std");\n' > roomA/.cache/gen_one.rye
        printf 'const std = @import("std");\n' > roomA/.cache/gen_two.rye
        if [ "$ignore" = yes ]; then
            printf '/roomA/.cache/\n' > .gitignore
        fi
        git add -A
        git commit -qm 'pen: one room, one door, one cache'
        if [ -n "$extra" ]; then
            printf 'const std = @import("std");\n' > "roomA/$extra"
        fi
    ) >/dev/null 2>&1
    echo "$d"
}

# Read the room's module count out of the scan's own census line, so the control reads exactly what
# the page is written from.
modules_of() {
    ( cd "$1" && sh "$scan" 2>/dev/null ) | sed -n 's/^lib=roomA modules=\([0-9][0-9]*\) .*/\1/p'
}

# The room's presence in the index at all, which is a separate reading from its count.
listed_in() {
    ( cd "$1" && sh "$scan" 2>/dev/null ) | grep -c '^lib=roomA ' || true
}

pass=0
fail=0
check() {
    label=$1
    got=$2
    want=$3
    if [ "$got" = "$want" ]; then
        pass=$((pass + 1))
        echo "ok: $label -- read $got"
    else
        fail=$((fail + 1))
        echo "REFUSED: $label -- read '$got', wanted '$want'"
    fi
}

# 1. THE REPAIR. Two generated modules sit under an ignored `.cache/`; only the tracked one counts.
d=$(build ignored yes yes "")
check "an ignored cache module stays out of the count" "$(modules_of "$d")" "1"

# 2. THE SAME FILES, UNIGNORED. Nothing about the path changed, so a rule keyed on the word `cache`
#    or on depth would read 1 here too and the first reading would have proven nothing.
d=$(build unignored no yes "")
check "the same three modules count when nothing ignores them" "$(modules_of "$d")" "3"

# 3. WRITTEN THIS MINUTE. A module that is untracked and unignored is real and counts, so the rule
#    reads the ignore list rather than the index.
d=$(build fresh yes yes mod_two.rye)
check "an untracked, unignored module counts" "$(modules_of "$d")" "2"

# 4. ONLY IGNORED MODULES. The room has a door and no module the tree keeps, so it leaves the index
#    rather than standing in it at zero.
d=$(build allignored yes no "")
check "a room holding only ignored modules leaves the index" "$(listed_in "$d")" "0"


# A repository holding one room, one door, one module, and one witness carrying exactly the line
# under test. The room is named by the caller, so a pen can be built where the room IS the
# toolchain -- which is the only way to prove the entry-path rule rather than describe it.
build_ref() {
    name=$1
    room=$2
    body=$3
    d=$pen/$name
    mkdir -p "$d/tools" "$d/$room"
    (
        cd "$d" || exit 1
        git init -q .
        git config user.email pen@example.invalid
        git config user.name Pen
        printf '# Room\n' > "$room/README.md"
        printf 'const std = @import("std");\n' > "$room/mod_one.rye"
        printf '%s\n' "$body" > tools/pen_witness.rish
        git add -A
        git commit -qm 'pen: one room, one door, one witness'
    ) >/dev/null 2>&1
    echo "$d"
}

# Read the room's witness count out of the scan's own census line, so the control reads exactly the
# number the page publishes.
witnesses_of() {
    ( cd "$1" && sh "$scan" 2>/dev/null ) \
        | sed -n "s/^lib=$2 modules=[0-9][0-9]* witnesses=\([0-9][0-9]*\)$/\1/p"
}

# 5. THE ENTRY PATH IS NOT A REFERENCE. A witness whose only mention of `rishi` is the interpreter
#    it runs under proves nothing about the `rishi` room. This is the repair: the published page
#    read 1,770 here -- 98 percent of every witness in the tree, against a room of two modules.
d=$(build_ref toolchain_rishi rishi 'rishi/bin/rishi run tools/pen_witness.rish')
check "a witness that only invokes the interpreter does not count for its room" "$(witnesses_of "$d" rishi)" "0"

# 6. AND THE SAME WITNESS COUNTS WHEN IT REALLY NAMES THE ROOM. Nothing about the room changed, so
#    a rule that simply dropped `rishi` from the index would read 0 here too and reading 5 would
#    have proven nothing.
d=$(build_ref reference_rishi rishi 'let src = run ["sh" "-c" "cat rishi/parse.rye"]')
check "a witness that names a path inside the room counts" "$(witnesses_of "$d" rishi)" "1"

# 7. THE COMPILER, THE SAME WAY. `rye/bin/rye` is how every Rye witness builds, and the published
#    page read 1,313 for a room whose proofs mostly never mention it.
d=$(build_ref toolchain_rye rye 'let build = run ["sh" "-c" "rye/bin/rye build mod_one.rye"]')
check "a witness that only invokes the compiler does not count for its room" "$(witnesses_of "$d" rye)" "0"

d=$(build_ref reference_rye rye 'assert out contains "rye/README.md" else "the door must be there"')
check "a witness naming a path inside the compiler room counts" "$(witnesses_of "$d" rye)" "1"

# 8. THE CUT IS NARROW. Every other room counts exactly as it did, so the strip reaches the two
#    entry paths rather than every path that happens to hold a slash.
d=$(build_ref plain_room roomA 'say "roomA/mod_one.rye is what this proves"')
check "an ordinary room still counts its witness" "$(witnesses_of "$d" roomA)" "1"

# 9. THE WORD BOUNDARY SURVIVED THE REWRITE. The elder rule counted a room when the character before
#    its name was not a letter, digit, or underscore -- so a hyphen still opens a reference. This is
#    proven because the matching mechanism changed underneath, and a boundary nobody re-checks is a
#    boundary that quietly moves.
d=$(build_ref hyphen_room roomA 'say "glow-roomA/mod_one.rye is still a reference"')
check "a hyphen before the room name still opens a reference" "$(witnesses_of "$d" roomA)" "1"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
    echo "control_verdict=ok"
else
    echo "control_verdict=refused"
    exit 1
fi
