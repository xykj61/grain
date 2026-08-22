#!/bin/sh
# ladder_reach_visibility_scan.sh -- what a fold would have to widen, measured
# rather than described.
#
# Every lift of the Caravan ladder arc asks the same two questions about the
# family in front of it: how many rungs write one identical body, and how many
# declarations the lift would have to widen, since a body moving into
# caravan/ladder_checks.rye reaches every helper through the rung handed in and
# a private helper is a compile error there.
#
# The first number has been measured since the arc opened --
# tools/fixtures/caravan_ladder_carry_scan.sh hashes every body and prints the
# family sizes. The second was written by a hand reading a diff, and on
# 20260822 it was wrong: the fold queue's own prose said `confirm` would widen
# exactly one declaration because `read_count` stood private in one of the
# forty-six rungs. `read_count` is absent from that rung entirely -- it is
# `entrust.rye`, whose `confirm` waits on a different note through a different
# reader, so it was never a fold candidate and never a widening cost. The fold
# widened nothing (REDS %130).
#
# So this scan reads the answer off disk. For a named family it hashes every
# body, takes the largest identical set, drops the rungs standing BELOW the fold
# line (the ones caravan/ladder_checks.rye itself imports -- folding those would
# have the harness reach back through a rung it reaches for), and then, for every
# top-level name each remaining rung declares, reports whether the shared body
# reaches it and whether that rung publishes it.
#
# WIDENS is the count of (rung, symbol) pairs a lift would have to make public.
# Zero means the fold is free of widening, which nine of the last ten lifts were.
#
# Two refusals, both by name, because a scan that finds nothing must never
# answer ok about its own blindness (REDS %97):
#   verdict=no_family   -- no rung declares a function by that name
#   verdict=no_identical -- no two rungs write the same body, so nothing folds
#
# LADDER_DIR (default caravan): the directory of rung modules, so the PASS and
# FAIL fixtures prove both paths without touching the tree.
# LADDER_HARNESS (default ladder_checks.rye): the harness whose imports name the
# fold line.
set -eu

# One collation for every sort and every join. A join whose inputs were ordered
# by a different rule reads them as unsorted and answers with garbage, which is
# how this scan's first cut reported a symbol private in forty-four rungs that
# its body never names.
LC_ALL=C
export LC_ALL

DIR=${LADDER_DIR:-caravan}
HARNESS=${LADDER_HARNESS:-ladder_checks.rye}
FAMILY=${1:-}

# prove-red: two generated controls, so both refusal paths are proven on metal
# without ever reading the living ladder for them.
if [ "$FAMILY" = "prove-red" ]; then
    fails=0
    ctl=$(mktemp -d)
    trap 'rm -rf "$ctl"' EXIT

    printf 'pub fn only_here() void {\n    return;\n}\n' > "$ctl/one.rye"
    out=$(LADDER_DIR="$ctl" sh "$0" nobody_writes_this 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-absent: /'
    case "$out" in
        *verdict=no_family*) echo "RED_no_family_refused_rather_than_ok" ;;
        *) echo "verdict=prove_red_failed_to_refuse_absent_family"; fails=1 ;;
    esac

    printf 'pub fn lone(a: u32) u32 {\n    return a;\n}\n' > "$ctl/two.rye"
    printf 'pub fn lone(a: u32) u32 {\n    return a + 1;\n}\n' > "$ctl/three.rye"
    rm -f "$ctl/one.rye"
    out=$(LADDER_DIR="$ctl" sh "$0" lone 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-differs: /'
    case "$out" in
        *verdict=no_identical*) echo "RED_no_identical_refused_rather_than_ok" ;;
        *) echo "verdict=prove_red_failed_to_refuse_differing_bodies"; fails=1 ;;
    esac

    [ "$fails" -eq 0 ] || exit 2
    exit 1
fi

if [ -z "$FAMILY" ]; then
    echo "REACH_REFUSED verdict=no_family family= reason=no_family_named"
    exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# The fold line: every rung the harness imports stands below it.
if [ -f "$DIR/$HARNESS" ]; then
    grep -oE '@import\("[a-z_]+\.rye"\)' "$DIR/$HARNESS" |
        sed 's/@import("//; s/")//' | sort -u > "$work/below"
else
    : > "$work/below"
fi

# Every body written under this name, hashed, so the identical set is measured.
: > "$work/bodies"
for f in "$DIR"/*.rye; do
    [ -f "$f" ] || continue
    base=$(basename "$f")
    [ "$base" = "$HARNESS" ] && continue
    awk -v fam="$FAMILY" '
        $0 ~ "^(pub )?fn " fam "\\(" { p = 1 }
        p { print }
        p && /^}$/ { exit }
    ' "$f" > "$work/body"
    [ -s "$work/body" ] || continue
    h=$(md5sum < "$work/body" | cut -c1-12)
    n=$(wc -l < "$work/body")
    printf '%s %s %s\n' "$h" "$n" "$base" >> "$work/bodies"
    cp "$work/body" "$work/body.$h"
done

if [ ! -s "$work/bodies" ]; then
    echo "REACH_REFUSED verdict=no_family family=$FAMILY reason=no_rung_declares_it"
    exit 1
fi

declared=$(wc -l < "$work/bodies" | tr -d ' ')
top=$(cut -d' ' -f1 "$work/bodies" | sort | uniq -c | sort -rn | head -1)
copies=$(echo "$top" | awk '{print $1}')
hash=$(echo "$top" | awk '{print $2}')
lines=$(awk -v h="$hash" '$1 == h {print $2; exit}' "$work/bodies")

if [ "$copies" -lt 2 ]; then
    echo "REACH_FAMILY family=$FAMILY declared=$declared identical=$copies lines=$lines"
    echo "REACH_REFUSED verdict=no_identical family=$FAMILY reason=every_body_differs"
    exit 1
fi

# The rungs that would fold: the identical set, less any standing below the line.
awk -v h="$hash" '$1 == h {print $3}' "$work/bodies" | sort > "$work/identical"
comm -12 "$work/below" "$work/identical" > "$work/held_below"
comm -23 "$work/identical" "$work/below" > "$work/folding"

folding=$(wc -l < "$work/folding" | tr -d ' ')
held=$(wc -l < "$work/held_below" | tr -d ' ')

echo "REACH_FAMILY family=$FAMILY declared=$declared identical=$copies lines=$lines"
echo "REACH_FOLD folding=$folding below_the_line=$held"

# The identifiers the shared body reaches UNQUALIFIED -- a name after a dot is
# reached through something else and says nothing about this rung's own
# visibility. Read once off the body rather than once per declaration, since the
# inner loop otherwise runs tens of thousands of greps for one answer.
# Comments come off first. An invariant line reading "a confirmation always
# waits on reach actually taken back" holds the word `waits`, and a rung
# declaring a private `waits` would otherwise be reported as a widening cost the
# body never asks for.
sed 's|//.*$||; s/"[^"]*"//g; s/\.[a-zA-Z_][a-zA-Z0-9_]*//g' "$work/body.$hash" |
    grep -oE '[a-z_][a-zA-Z0-9_]*' | sort -u > "$work/reached_words"

# For each folding rung, which of its own top-level names the shared body reaches,
# and whether that rung publishes each one.
widens=0
widens_fn=0
widens_import=0
widens_const=0
: > "$work/private"
: > "$work/reached_all"
while read -r base; do
    [ -n "$base" ] || continue
    # Each top-level declaration read with its VISIBILITY and its KIND, because
    # a widening of an import binding and a widening of a function are two
    # unlike costs and a column that sums them says neither. Read from the whole
    # line rather than from a name, since only the line shows the import.
    awk -v fam="$FAMILY" '
        /^(pub )?(fn|const) [a-z_]/ {
            vis = ($0 ~ /^pub /) ? "PUB" : "PRIV"
            n = $0
            sub(/^pub /, "", n)
            kind = (n ~ /^fn /) ? "fn" : (($0 ~ /@import\(/) ? "import" : "const")
            sub(/^(fn|const) /, "", n)
            sub(/[^a-zA-Z0-9_].*$/, "", n)
            if (n == fam) next
            # The opening triad every hosted .rye file declares for itself. A
            # lifted body reaches std and assert through the harness'"'"'s own,
            # so they are never a rung API symbol and never a widening cost.
            if (n == "std" || n == "assert" || n == "print") next
            print n, vis, kind
        }
    ' "$DIR/$base" | sort -u > "$work/decls"
    join "$work/reached_words" "$work/decls" > "$work/hit" || true
    while read -r name vis kind; do
        [ -n "$name" ] || continue
        echo "$name" >> "$work/reached_all"
        if [ "$vis" = "PRIV" ]; then
            widens=$((widens + 1))
            case "$kind" in
                fn) widens_fn=$((widens_fn + 1)) ;;
                import) widens_import=$((widens_import + 1)) ;;
                *) widens_const=$((widens_const + 1)) ;;
            esac
            printf '%s %s %s\n' "$name" "$kind" "$base" >> "$work/private"
        fi
    done < "$work/hit"
done < "$work/folding"

reached=$(sort -u "$work/reached_all" | wc -l | tr -d ' ')
echo "REACH_SYMBOLS reached=$reached across=$folding rungs"

if [ "$widens" -gt 0 ]; then
    sort "$work/private" | uniq -c | sort -rn | while read -r n name kind rung; do
        echo "REACH_PRIVATE symbol=$name kind=$kind rungs=$n first=$rung"
    done
fi

# The stub a fold leaves behind is the signature plus two lines -- the return
# statement and the closing brace -- so a family written over a six-line
# signature pays eight lines back in every rung rather than three.
sig=$(awk '/\{[ ]*$/ { print NR; exit }' "$work/body.$hash")
[ -n "$sig" ] || sig=1
stub=$((sig + 2))

# The realized fall counts the family's carry before against the stub family's
# carry after, and those are two different populations whenever a rung stands
# below the fold line: it keeps its whole body and leaves the family, so the
# carry it was contributing goes entirely rather than shrinking to a stub.
fall=$(( (copies - 1) * lines - (folding - 1) * stub ))
echo "REACH_OK family=$FAMILY folding=$folding widens=$widens widens_fn=$widens_fn widens_import=$widens_import widens_const=$widens_const stub=$stub fall=$fall"
