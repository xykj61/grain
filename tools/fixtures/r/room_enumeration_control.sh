#!/bin/sh
# tools/fixtures/r/room_enumeration_control.sh -- proves tools/fixtures/r/room_enumeration_scan.sh
# on real directory trees in a throwaway pen.
#
# WHY A CONTROL. A guard proven only in the passing direction cannot be told from a bypass. Every
# refusal below is planted and then lifted, so each reading is shown from both sides, and the scan
# itself is mutated three ways to prove the legs bite something rather than merely running.
#
# Run: sh tools/fixtures/r/room_enumeration_control.sh
set -u

# The scan stands beside this control, so it resolves in the pen and in the tree alike.
SCAN=$(cd "$(dirname "$0")" && pwd)/room_enumeration_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=scan_absent"; exit 2; }

# ONE SHELL DIALECT, on both piers. GNU `sed -i` takes no argument and BSD `sed -i` requires a
# backup suffix, so the two spellings have no overlap and the tree writes neither.
_fd_root=$(cd "$(dirname "$0")/../../.." && pwd)
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

pass=0
fail=0

leg() { # leg <name> <expected> <actual>
    if [ "$2" = "$3" ]; then
        pass=$((pass + 1))
        echo "leg $1 ok ($2)"
    else
        fail=$((fail + 1))
        echo "leg $1 FAIL expected=$2 actual=$3"
    fi
}

PEN=$(mktemp -d) || exit 2
trap 'rm -rf "$PEN"' EXIT

# A miniature shelf: a parent room with four rooms and one door that enumerates its neighbors.
build_pen() { # build_pen <list-line-body>
    rm -rf "$PEN/shelf"
    mkdir -p "$PEN/shelf/api" "$PEN/shelf/blog" "$PEN/shelf/demos" "$PEN/shelf/etc"
    for r in api blog demos; do echo "# $r" > "$PEN/shelf/$r/README.md"; done
    {
        echo "# Etc -- the waiting room"
        echo ""
        echo "**Neighbors:** the rooms beside this one under [\`../\`](../) -- $1"
        echo ""
        echo "Body prose."
    } > "$PEN/shelf/etc/README.md"
    ( cd "$PEN" && git init -q . && git add -A && git -c user.email=p@p -c user.name=p commit -qm pen )
}

read_scan() { # read_scan <key>
    ( cd "$PEN" && sh "$SCAN" 2>/dev/null ) | sed -n "s/^$1=//p"
}

# --- The healthy shelf: every neighbor named, nothing extra.
build_pen '`api`, `blog`, `demos`'
leg healthy_verdict ok "$(read_scan verdict)"
leg healthy_missing 0 "$(read_scan missing)"
leg healthy_phantom 0 "$(read_scan phantom)"
leg healthy_pages 1 "$(read_scan pages_declaring)"
leg healthy_no_target 0 "$(read_scan no_target)"
leg healthy_absent 0 "$(read_scan absent)"
leg healthy_unreadable 0 "$(read_scan unreadable)"
( cd "$PEN" && sh "$SCAN" >/dev/null 2>&1 )
leg healthy_exit 0 "$?"

# --- A room lands and the list never hears: the fault this guard exists for.
build_pen '`api`, `blog`'
leg missing_bites 1 "$(read_scan missing)"
leg missing_verdict enumeration_drift "$(read_scan verdict)"
( cd "$PEN" && sh "$SCAN" >/dev/null 2>&1 )
leg missing_exit 1 "$?"
leg missing_phantom_clean 0 "$(read_scan phantom)"
# lifted
build_pen '`api`, `blog`, `demos`'
leg missing_lifted 0 "$(read_scan missing)"

# --- A name with no room behind it.
build_pen '`api`, `blog`, `demos`, `wiki`'
leg phantom_bites 1 "$(read_scan phantom)"
leg phantom_verdict enumeration_drift "$(read_scan verdict)"
leg phantom_missing_clean 0 "$(read_scan missing)"
# lifted
build_pen '`api`, `blog`, `demos`'
leg phantom_lifted 0 "$(read_scan phantom)"

# --- The page's own room is read past, so naming it is a phantom rather than a free pass.
build_pen '`api`, `blog`, `demos`, `etc`'
leg self_named_is_phantom 1 "$(read_scan phantom)"

# --- A key carrying no link at all.
build_pen '`api`, `blog`, `demos`'
sed_inplace 's/\[`\.\.\/`\](\.\.\/)/the parent/' "$PEN/shelf/etc/README.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm notarget )
leg no_target_bites 1 "$(read_scan no_target)"
leg no_target_verdict enumeration_drift "$(read_scan verdict)"

# --- A link naming a directory that is not there.
build_pen '`api`, `blog`, `demos`'
sed_inplace 's|\](\.\./)|](../gone/)|' "$PEN/shelf/etc/README.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm absent )
leg absent_bites 1 "$(read_scan absent)"
leg absent_verdict enumeration_drift "$(read_scan verdict)"

# --- The closed stacks under the parent are read past rather than demanded.
build_pen '`api`, `blog`, `demos`'
mkdir -p "$PEN/shelf/date" "$PEN/shelf/archive" "$PEN/shelf/yonder"
echo x > "$PEN/shelf/date/k.md"; echo x > "$PEN/shelf/archive/k.md"; echo x > "$PEN/shelf/yonder/k.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm shelves )
leg shelves_read_past 0 "$(read_scan missing)"
leg shelves_verdict ok "$(read_scan verdict)"

# --- A page inside a closed stack declares and is read past entirely.
build_pen '`api`, `blog`, `demos`'
mkdir -p "$PEN/shelf/archive/old"
cp "$PEN/shelf/etc/README.md" "$PEN/shelf/archive/old/README.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm archived )
leg archived_page_unread 1 "$(read_scan pages_declaring)"

# --- An untracked page is outside the population, since the scan reads the tracked listing.
build_pen '`api`, `blog`, `demos`'
mkdir -p "$PEN/shelf/loose"
cp "$PEN/shelf/etc/README.md" "$PEN/shelf/loose/README.md"
leg untracked_unread 1 "$(read_scan pages_declaring)"

# --- No declaring page anywhere: an empty population reads ok and says its size.
rm -rf "$PEN/shelf"
mkdir -p "$PEN/shelf"
echo "# plain" > "$PEN/shelf/README.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm empty )
leg empty_population_pages 0 "$(read_scan pages_declaring)"
leg empty_population_refuses no_enumerations "$(read_scan verdict)"
( cd "$PEN" && sh "$SCAN" >/dev/null 2>&1 )
leg empty_population_exit 1 "$?"

# --- Outside a repository the scan refuses rather than reading the disk.
OUT=$(cd /tmp && sh "$SCAN" 2>/dev/null | sed -n 's/^verdict=//p')
leg no_repository_refuses no_repository "$OUT"

# --- A room name this reading cannot compare is NAMED rather than split into false neighbors.
build_pen '`api`, `blog`, `demos`'
mkdir -p "$PEN/shelf/odd name"
echo x > "$PEN/shelf/odd name/k.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm odd )
leg unreadable_named 1 "$(read_scan unreadable)"
leg unreadable_not_split 0 "$(read_scan missing)"
leg unreadable_verdict enumeration_drift "$(read_scan verdict)"
# lifted
build_pen '`api`, `blog`, `demos`'
leg unreadable_lifted 0 "$(read_scan unreadable)"

# --- A declaring page whose own path carries a space is read whole rather than split into two.
build_pen '`api`, `blog`, `demos`'
mkdir -p "$PEN/shelf/two/deep dir"
cp "$PEN/shelf/etc/README.md" "$PEN/shelf/two/deep dir/README.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm spaced )
leg spaced_path_counted 2 "$(read_scan pages_declaring)"

# --- MUTATION: the legs must bite the scan rather than merely run beside it.
mutate() { # mutate <sed-expr> -> prints missing reading of the healthy shelf
    cp "$SCAN" "$PEN/mutant.sh"
    sed_inplace "$1" "$PEN/mutant.sh"
    build_pen '`api`, `blog`, `demos`'
    ( cd "$PEN" && sh "$PEN/mutant.sh" 2>/dev/null ) | sed -n 's/^missing=//p'
}
# Dropping the self exclusion makes the page's own room read as a missing neighbor.
leg mutation_self_exclusion 1 "$(mutate 's/"\$self|date/"date/')"
# Dropping the shelf exclusion makes a closed stack under the parent read as a missing room.
cp "$SCAN" "$PEN/m3.sh"
sed_inplace 's/|date|archive|yonder//' "$PEN/m3.sh"
build_pen '`api`, `blog`, `demos`'
mkdir -p "$PEN/shelf/date"; echo x > "$PEN/shelf/date/k.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm m3 )
leg mutation_shelf_exclusion 1 "$( ( cd "$PEN" && sh "$PEN/m3.sh" 2>/dev/null ) | sed -n 's/^missing=//p')"
# Dropping the name rule lets the link's own backticked text into the claimed set.
cp "$SCAN" "$PEN/m2.sh"
sed_inplace "s/\`\[a-z\]\[a-z0-9-\]\*\`/\`[^\`]*\`/" "$PEN/m2.sh"
build_pen '`api`, `blog`, `demos`'
leg mutation_name_rule 1 "$( ( cd "$PEN" && sh "$PEN/m2.sh" 2>/dev/null ) | sed -n 's/^phantom=//p')"
# Dropping the actual-side name rule splits a spaced directory into two false missing rooms -- the
# pre-repair reading, run over the same pen and shown calling a healthy shelf drifted.
cp "$SCAN" "$PEN/m4.sh"
sed_inplace "s/| grep -xE '\[a-z\]\[a-z0-9-\]\*' | grep -vxE/| grep -vxE/" "$PEN/m4.sh"
build_pen '`api`, `blog`, `demos`'
mkdir -p "$PEN/shelf/odd name"; echo x > "$PEN/shelf/odd name/k.md"
( cd "$PEN" && git add -A && git -c user.email=p@p -c user.name=p commit -qm m4 )
leg mutation_actual_name_rule 2 "$( ( cd "$PEN" && sh "$PEN/m4.sh" 2>/dev/null ) | sed -n 's/^missing=//p')"

echo "pass=$pass fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
