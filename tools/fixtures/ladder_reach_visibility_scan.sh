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

    # A shared body names its types as often as its helpers, and a type name is
    # capitalized. The first cut of this scan read only names opening lowercase,
    # so a private struct reached in a signature priced at zero and the meter
    # answered widens=0 where a fold would not compile (REDS %140). A control
    # whose two rungs each hold a private `Ledger` must report both.
    rm -f "$ctl/two.rye" "$ctl/three.rye"
    printf 'const Ledger = struct { n: u32 };\npub fn tally_up(x: Ledger) u32 {\n    return x.n;\n}\n' > "$ctl/left_t.rye"
    printf 'const Ledger = struct { n: u32 };\npub fn tally_up(x: Ledger) u32 {\n    return x.n;\n}\n' > "$ctl/right_t.rye"
    out=$(LADDER_DIR="$ctl" sh "$0" tally_up 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-capital-type: /'
    case "$out" in
        *"widens=2 widens_fn=0 widens_import=0 widens_const=2"*)
            echo "RED_capitalized_type_priced_rather_than_unseen" ;;
        *) echo "verdict=prove_red_missed_a_private_type_the_body_names"; fails=1 ;;
    esac
    rm -f "$ctl/left_t.rye" "$ctl/right_t.rye"

    # One rule may be written `pub fn` in one rung and `fn` in another, and the
    # difference is a single word about who may call it rather than anything
    # about what it says. Keying on the raw text put that word inside the hash,
    # so a family of fifty-one read as forty-three and eight (REDS %144). A
    # control whose two rungs hold one body under two visibilities must read a
    # family of two.
    printf 'pub fn shared_rule(a: u32) u32 {\n    return a + 1;\n}\n' > "$ctl/left_v.rye"
    printf 'fn shared_rule(a: u32) u32 {\n    return a + 1;\n}\n' > "$ctl/right_v.rye"
    out=$(LADDER_DIR="$ctl" sh "$0" shared_rule 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-visibility: /'
    case "$out" in
        *"identical=2"*) echo "RED_one_rule_read_as_one_family_across_two_visibilities" ;;
        *) echo "verdict=prove_red_split_a_family_on_the_pub_keyword"; fails=1 ;;
    esac
    rm -f "$ctl/left_v.rye" "$ctl/right_v.rye"

    printf 'pub fn lone(a: u32) u32 {\n    return a;\n}\n' > "$ctl/two.rye"
    printf 'pub fn lone(a: u32) u32 {\n    return a + 1;\n}\n' > "$ctl/three.rye"

    # The sink meter must refuse a directory holding no public function rather
    # than answer zero, since a zero and a blindness read identically (REDS %97).
    rm -f "$ctl/two.rye" "$ctl/three.rye"
    printf 'const std = @import("std");\n' > "$ctl/quiet.rye"
    out=$(LADDER_DIR="$ctl" sh "$0" sink 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-sink-empty: /'
    case "$out" in
        *verdict=no_bodies*) echo "RED_sink_blindness_refused_rather_than_zero" ;;
        *) echo "verdict=prove_red_sink_answered_where_it_saw_nothing"; fails=1 ;;
    esac

    # And it must count a rung's holding rather than its whole body: two rungs
    # writing one identical three-line body hold three lines each, while a body
    # nobody repeats holds nothing at all.
    printf 'pub fn shared(a: u32) u32 {\n    return a;\n}\npub fn mine() void {\n    return;\n}\n' > "$ctl/left.rye"
    printf 'pub fn shared(a: u32) u32 {\n    return a;\n}\n' > "$ctl/right.rye"
    rm -f "$ctl/quiet.rye"
    out=$(LADDER_DIR="$ctl" sh "$0" sink 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-sink-holding: /'
    case "$out" in
        *"SINK_OK total=6 below_fold_line=0 above_fold_line=6"*)
            echo "RED_sink_counts_the_repeated_body_and_not_the_lone_one" ;;
        *) echo "verdict=prove_red_sink_miscounted_a_hand_built_holding"; fails=1 ;;
    esac

    [ "$fails" -eq 0 ] || exit 2
    exit 1
fi

# SINK mode -- what importing a rung into the harness would forfeit.
#
# A rung the harness imports stands BELOW the fold line from that moment on, and
# a rung below the fold line can never fold a body again: a lift would have the
# harness reach back through a rung it already reaches for. So a harness-level
# import is a one-way door, and reaching for one to spare a lift its comptime
# rung parameter spends something.
#
# On 20260822 that something was described rather than measured, in a witness's
# own GREEN line, which is the exact crossing REDS %130 already booked once
# (REDS %137). This mode prices the door instead: for each rung it prints the
# body lines that rung currently holds in families of two or more identical
# bodies -- the carry a lift would foreclose by sinking it.
#
# The answer is small, and the smallness is the finding. A rung the harness
# imports tends to be a shared helper, and a shared helper writes few duplicated
# bodies, so the fold line forecloses far less than its one-way shape suggests.
if [ "$FAMILY" = "sink" ]; then
    work=$(mktemp -d)
    trap 'rm -rf "$work"' EXIT

    if [ -f "$DIR/$HARNESS" ]; then
        grep -oE '@import\("[a-z_]+\.rye"\)' "$DIR/$HARNESS" |
            sed 's/@import("//; s/")//' | sort -u > "$work/below"
    else
        : > "$work/below"
    fi

    # One record per top-level function: name, file, line count, and the body
    # itself flattened onto the same line, so identical bodies sort together.
    # The signature's `pub ` leaves the flattened body before it becomes a key,
    # and a private declaration is read beside a public one, because a body a
    # rung holds is carry whoever may call it (REDS %144).
    : > "$work/all"
    for f in "$DIR"/*.rye; do
        [ -f "$f" ] || continue
        base=$(basename "$f")
        [ "$base" = "$HARNESS" ] && continue
        awk -v file="$base" '
            /^(pub )?fn [a-z_0-9]+\(/ && !p { p = 1; n = 0; body = ""; name = ($1 == "pub") ? $3 : $2; sub(/\(.*/, "", name) }
            p { n = n + 1; keyed = $0; sub(/^pub /, "", keyed); body = body "\001" keyed }
            p && /^}$/ { printf "%s\t%s\t%d\t%s\n", name, file, n, body; p = 0 }
        ' "$f" >> "$work/all"
    done

    if [ ! -s "$work/all" ]; then
        echo "SINK_REFUSED verdict=no_bodies dir=$DIR reason=no_rung_declares_a_function"
        exit 1
    fi

    # A family is a name plus a body. Two or more members make it foldable, and
    # only a foldable family's lines are carry a sink could forfeit.
    sort -t"$(printf '\t')" -k1,1 -k4,4 "$work/all" |
        awk -F"\t" '
            { key = $1 "\t" $4
              if (key == prev) { count = count + 1 }
              else { flush(); prev = key; count = 1; delete files; delete lines; m = 0 }
              m = m + 1; files[m] = $2; lines[m] = $3 }
            function flush(   i) {
                if (count >= 2) for (i = 1; i <= m; i++) hold[files[i]] += lines[i]
            }
            END { flush(); for (f in hold) printf "%s %d\n", f, hold[f] }
        ' | sort -k2,2nr -k1,1 > "$work/hold"

    total=0
    sunk=0
    while read -r rung n; do
        total=$((total + n))
        if grep -qx "$rung" "$work/below" 2>/dev/null; then
            sunk=$((sunk + n))
            echo "SINK_BELOW rung=$rung holds=$n"
        fi
    done < "$work/hold"

    # Every rung still above the line, largest holding first, so a lift eyeing a
    # harness import reads what that import would forfeit before it reaches.
    while read -r rung n; do
        grep -qx "$rung" "$work/below" 2>/dev/null && continue
        echo "SINK_ABOVE rung=$rung holds=$n"
    done < "$work/hold"

    echo "SINK_OK total=$total below_fold_line=$sunk above_fold_line=$((total - sunk)) dir=$DIR"
    exit 0
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
    # The signature's `pub ` leaves the text before it is hashed, so a rule
    # written `pub fn` in one rung and `fn` in another reads as one family
    # rather than two (REDS %144). Visibility decides who may call a body; it
    # says nothing about what the body says, so it belongs beside the key
    # rather than inside it.
    awk -v fam="$FAMILY" '
        $0 ~ "^(pub )?fn " fam "\\(" { p = 1 }
        p { keyed = $0; sub(/^pub /, "", keyed); print keyed }
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
    grep -oE '[A-Za-z_][A-Za-z0-9_]*' | sort -u > "$work/reached_words"

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
        /^(pub )?(fn|const) [A-Za-z_]/ {
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

# The realized fall counts the family's carry before against every carry left
# standing after. Three populations remain, and the first cut of this formula saw
# only two (REDS %136). The folding rungs shrink to stubs and carry
# (folding - 1) * stub. The rungs BELOW the fold line keep their whole bodies --
# and they leave the family only when fewer than two of them remain. Two or more
# identical bodies are still a family, carrying (held - 1) * lines between
# themselves, so a fold with seven rungs below the line was overpriced by six
# bodies. The error is invisible at held of zero or one, which every fold of this
# arc had until load_one, and it is exactly (held - 1) * lines when it appears.
held_after=0
if [ "$held" -ge 2 ]; then
    held_after=$(( (held - 1) * lines ))
fi
fall=$(( (copies - 1) * lines - ((folding - 1) * stub + held_after) ))
echo "REACH_OK family=$FAMILY folding=$folding widens=$widens widens_fn=$widens_fn widens_import=$widens_import widens_const=$widens_const stub=$stub fall=$fall"
