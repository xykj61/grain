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

    # The queue must refuse a ladder where no two rungs write one body, rather
    # than print an empty list and answer ok about its own blindness (REDS %97).
    printf 'pub fn alone(a: u32) u32 {\n    return a;\n}\n' > "$ctl/solo_a.rye"
    printf 'pub fn alone(a: u32) u32 {\n    return a + 9;\n}\n' > "$ctl/solo_b.rye"
    out=$(LADDER_DIR="$ctl" sh "$0" queue 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-queue-empty: /'
    case "$out" in
        *verdict=no_foldable*) echo "RED_queue_blindness_refused_rather_than_empty" ;;
        *) echo "verdict=prove_red_queue_answered_where_nothing_folds"; fails=1 ;;
    esac
    rm -f "$ctl/solo_a.rye" "$ctl/solo_b.rye"

    # And the queue must rank by FALL rather than by carry, which is the whole
    # reason it exists. The two controls are built so the orderings disagree:
    # `broad` is twenty rungs of four lines -- carry 76, much the larger -- yet
    # returns only (20 - 1) * (4 - 3) = 19, because a four-line body barely
    # outgrows the three-line stub replacing it. `deep` is three rungs of
    # twenty-one lines -- carry 42 -- and returns (3 - 1) * (21 - 3) = 36. A
    # meter ordering by carry names broad first; this one must name deep,
    # because a hand reading a carry list is exactly how the living queue came
    # to miss three deep families for thirty laps (REDS %145).
    i=1
    while [ "$i" -le 20 ]; do
        printf 'pub fn broad(a: u32) u32 {\n    _ = a;\n    return 1;\n}\n' > "$ctl/wide_$i.rye"
        i=$((i + 1))
    done
    i=1
    while [ "$i" -le 3 ]; do
        {
            printf 'pub fn deep(a: u32) u32 {\n'
            j=1
            while [ "$j" -le 18 ]; do printf '    _ = a;\n'; j=$((j + 1)); done
            printf '    return a;\n}\n'
        } > "$ctl/tall_$i.rye"
        i=$((i + 1))
    done
    out=$(LADDER_DIR="$ctl" QUEUE_DEPTH=2 sh "$0" queue 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-queue-rank: /'
    case "$out" in
        *"QUEUE_ROW family=deep fall=36 folding=3 lines=21 stub=3 widens=0 widens_fn=0 widens_const=0 carry=42"*)
            case "$out" in
                *"QUEUE_ROW family=broad fall=19 folding=20 lines=4 stub=3 widens=0 widens_fn=0 widens_const=0 carry=76"*)
                    case "$out" in
                        *"QUEUE_OK head=deep fall=36"*)
                            echo "RED_queue_ranked_by_fall_where_carry_ordered_the_other_way" ;;
                        *) echo "verdict=prove_red_queue_named_the_wrong_head"; fails=1 ;;
                    esac ;;
                *) echo "verdict=prove_red_queue_lost_the_broad_family"; fails=1 ;;
            esac ;;
        *) echo "verdict=prove_red_queue_mispriced_the_deep_family"; fails=1 ;;
    esac
    i=1
    while [ "$i" -le 20 ]; do rm -f "$ctl/wide_$i.rye"; i=$((i + 1)); done
    i=1
    while [ "$i" -le 3 ]; do rm -f "$ctl/tall_$i.rye"; i=$((i + 1)); done

    # And the queue must name a FREE head beside the best one, because the two
    # answer different questions. Ranking by return alone says what would fall
    # the furthest; a reader choosing the next lift asks what would fall the
    # furthest for nothing. The two controls are built so those answers differ:
    # `costly` is three rungs of twenty-one lines returning 36, and each rung
    # keeps the `helper` its body reaches private, so folding it publishes three
    # functions three rungs chose to keep. `frugal` is three rungs of eighteen
    # lines returning 30 and reaching nothing private. A meter printing one head
    # names costly and stops; this one must name costly AND frugal, since the
    # living queue's own head stood priced at sixty-eight openings for two laps
    # while a hand quietly took the free row beneath it (REDS %146).
    i=1
    while [ "$i" -le 3 ]; do
        {
            printf 'fn helper(a: u32) u32 {\n    return a;\n}\n\n'
            printf 'pub fn costly(a: u32) u32 {\n'
            printf '    _ = helper(a);\n'
            j=1
            while [ "$j" -le 17 ]; do printf '    _ = a;\n'; j=$((j + 1)); done
            printf '    return a;\n}\n'
        } > "$ctl/priced_$i.rye"
        {
            printf 'pub fn frugal(a: u32) u32 {\n'
            j=1
            while [ "$j" -le 15 ]; do printf '    _ = a;\n'; j=$((j + 1)); done
            printf '    return a;\n}\n'
        } > "$ctl/plain_$i.rye"
        i=$((i + 1))
    done
    out=$(LADDER_DIR="$ctl" QUEUE_DEPTH=2 sh "$0" queue 2>&1) || true
    printf '%s\n' "$out" | sed 's/^/control-queue-price: /'
    case "$out" in
        *"QUEUE_ROW family=costly fall=36 folding=3 lines=21 stub=3 widens=3 widens_fn=3 widens_const=0 carry=42"*)
            case "$out" in
                *"QUEUE_OK head=costly fall=36 free_head=frugal free_fall=30"*)
                    echo "RED_queue_named_the_free_head_beside_the_best_one" ;;
                *) echo "verdict=prove_red_queue_priced_no_head"; fails=1 ;;
            esac ;;
        *) echo "verdict=prove_red_queue_lost_the_priced_family"; fails=1 ;;
    esac
    i=1
    while [ "$i" -le 3 ]; do rm -f "$ctl/priced_$i.rye" "$ctl/plain_$i.rye"; i=$((i + 1)); done

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

# QUEUE mode -- which family returns the most, ranked rather than remembered.
#
# For thirty-odd laps this arc chose its next family from a shortlist a hand
# kept in a witness, and the GREEN line said "the fall queue leads with" a name
# off that list. A shortlist answers about the rows on it and stays silent
# about every row nobody thought to add, so the claim was an impression wearing
# a measurement's clothes -- the same shape REDS %130 booked for a single row's
# cost, reappearing one level up at the ORDERING (REDS %145). `suits_path`
# returns three hundred and fifty and had never once been asked.
#
# The rank is exact rather than sampled, because carry bounds fall from above.
# A family of `rungs` rungs each holding `lines` lines returns
# (folding - 1) * (lines - stub), and folding <= rungs while lines - stub <=
# lines, so fall <= (rungs - 1) * lines = carry, always. Rank every family by carry,
# measure fall down that order, and stop the moment the next carry falls to or
# below the best fall already seen: nothing further down can beat it. So this
# reads the whole field while opening only the handful of rows that could win.
#
# `carry` here is the carry scan's own number -- (rungs - 1) * lines, the lines
# a lift would stop repeating -- so the two meters speak one arithmetic.
#
# QUEUE_DEPTH (default 12): how many ranked rows to print once the search ends.
if [ "$FAMILY" = "queue" ]; then
    depth=${QUEUE_DEPTH:-12}
    work=$(mktemp -d)
    trap 'rm -rf "$work"' EXIT

    # Every top-level body in the ladder, keyed by name plus flattened text, so
    # identical bodies group. Visibility leaves the key (REDS %144).
    : > "$work/all"
    for f in "$DIR"/*.rye; do
        [ -f "$f" ] || continue
        base=$(basename "$f")
        [ "$base" = "$HARNESS" ] && continue
        awk '
            /^(pub )?fn [a-z_0-9]+\(/ && !p { p = 1; n = 0; body = ""; name = ($1 == "pub") ? $3 : $2; sub(/\(.*/, "", name) }
            p { n = n + 1; keyed = $0; sub(/^pub /, "", keyed); body = body "\001" keyed }
            p && /^}$/ { printf "%s\t%d\t%s\n", name, n, body; p = 0 }
        ' "$f" >> "$work/all"
    done

    if [ ! -s "$work/all" ]; then
        echo "QUEUE_REFUSED verdict=no_bodies dir=$DIR reason=no_rung_declares_a_function"
        exit 1
    fi

    # One row per family of two or more identical bodies: name, rungs, lines,
    # carry. Sorted by carry descending, which is the bound the search walks.
    sort -t"$(printf '\t')" -k1,1 -k3,3 "$work/all" |
        awk -F"\t" '
            { key = $1 "\t" $3
              if (key != prev) { flush(); prev = key; count = 0; nm = $1; ln = $2 }
              count = count + 1 }
            function flush() { if (count >= 2) printf "%s %d %d %d\n", nm, count, ln, (count - 1) * ln }
            END { flush() }
        ' | sort -k4,4nr -k1,1 > "$work/bycarry"

    if [ ! -s "$work/bycarry" ]; then
        echo "QUEUE_REFUSED verdict=no_foldable dir=$DIR reason=no_two_rungs_write_one_body"
        exit 1
    fi

    # The threshold is the DEPTH-th best fall measured so far, not the best.
    # Stopping at the best fall names the head correctly and truncates the tail
    # wrongly: on the lap this mode was written, `bound_the_relay` returned 312
    # and went unseen while `term_written` at 270 printed above it, because the
    # search had already closed on a head of 350. A top-of-K list is complete
    # only when nothing unexamined could displace its Kth row.
    floor=0
    examined=0
    : > "$work/ranked"
    while read -r name rungs lines carry; do
        # The bound closes the search: carry bounds fall from above, so once a
        # family's carry falls to the Kth-best fall, nothing below it can enter
        # the printed list.
        [ "$carry" -le "$floor" ] && break
        row=$(sh "$0" "$name" 2>/dev/null | grep '^REACH_OK ' || true)
        examined=$((examined + 1))
        [ -n "$row" ] || continue
        fall=$(printf '%s\n' "$row" | sed 's/.* fall=//')
        widens=$(printf '%s\n' "$row" | sed 's/.* widens=\([0-9]*\) .*/\1/')
        widens_fn=$(printf '%s\n' "$row" | sed 's/.* widens_fn=\([0-9]*\) .*/\1/')
        widens_import=$(printf '%s\n' "$row" | sed 's/.* widens_import=\([0-9]*\) .*/\1/')
        widens_const=$(printf '%s\n' "$row" | sed 's/.* widens_const=\([0-9]*\) .*/\1/')
        folding=$(printf '%s\n' "$row" | sed 's/.* folding=\([0-9]*\) .*/\1/')
        stub=$(printf '%s\n' "$row" | sed 's/.* stub=\([0-9]*\) .*/\1/')
        printf '%s %s %s %s %s %s %s %s %s\n' "$fall" "$name" "$folding" "$lines" "$stub" "$widens" "$carry" "$widens_fn" "$widens_const" >> "$work/ranked"
        floor=$(sort -k1,1nr "$work/ranked" | awk -v d="$depth" 'NR == d { print $1; found = 1 } END { if (!found) print 0 }')
    done < "$work/bycarry"

    if [ ! -s "$work/ranked" ]; then
        echo "QUEUE_REFUSED verdict=no_fall dir=$DIR reason=no_family_returns_anything"
        exit 1
    fi

    sort -k1,1nr -k2,2 "$work/ranked" | head -n "$depth" |
        while read -r fall name folding lines stub widens carry wfn wconst; do
            echo "QUEUE_ROW family=$name fall=$fall folding=$folding lines=$lines stub=$stub widens=$widens widens_fn=$wfn widens_const=$wconst carry=$carry"
        done

    head=$(sort -k1,1nr -k2,2 "$work/ranked" | head -1)
    hname=$(printf '%s\n' "$head" | awk '{print $2}')
    hfall=$(printf '%s\n' "$head" | awk '{print $1}')
    families=$(wc -l < "$work/bycarry" | tr -d ' ')

    # The free head: the best fall among families that publish no function and
    # no constant a rung chose to keep private. An import binding re-exported is
    # the widening this arc has always accepted; a private function or record
    # type forced public is the price it has always declined. Ranking by return
    # alone named a head the discipline stepped past by hand for two laps
    # running, which is REDS %145's shape one level deeper -- an ordering that
    # answers "what returns the most" where the reader asked "what should I take
    # next" (REDS %146). Both numbers print, so the trade stays visible rather
    # than decided here.
    free=$(awk '$8 == 0 && $9 == 0' "$work/ranked" | sort -k1,1nr -k2,2 | head -1)
    if [ -n "$free" ]; then
        fname=$(printf '%s\n' "$free" | awk '{print $2}')
        ffall=$(printf '%s\n' "$free" | awk '{print $1}')
    else
        fname=none
        ffall=0
    fi

    echo "QUEUE_OK head=$hname fall=$hfall free_head=$fname free_fall=$ffall examined=$examined families=$families dir=$DIR"
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
