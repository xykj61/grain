#!/bin/sh
# tools/fixtures/g/glow_ident_duplication_scan.sh -- copies of the Zig-identifier rule that
# stand in the Glow lowering room instead of reaching the one published rule.
#
# WHY. A Glow face becomes a Zig identifier on the way down -- hyphen to underscore, then
# Zig's own rule for identifier bytes. `fn zig_safe_ident` implemented that rule in 29
# separate `glow/lower_*.rye` modules, and the character test itself was byte-for-byte
# identical in all 29. What differed is what a rule written 29 times comes to disagree
# about, measured `20260917` before the first conversion:
#
#   - 23 returned `usize`, where TAME asks `u32` for an in-memory length
#   - 5 carried the `// invariant:` assert the other 24 omitted
#   - `glow/lower_shop_nest.rye` answered a LENGTH ceiling with `error.MissingFace`,
#     where 28 peers answered `error.BadIdent`
#   - `glow/lower_alias.rye` mapped the dot as well as the hyphen
#
# `glow/zig_ident.rye` is the one rule now, taking the ceiling as a parameter because the
# five budgets the room declares -- `max_name_len`, `max_arm_len`, `max_ident_len`,
# `max_stem_len`, `max_subject_len` -- are five numbers naming one rule.
#
# WHAT A COPY IS, AND WHAT A STUB IS. A file declaring `fn zig_safe_ident` whose body does
# NOT reach `zig_ident.safe_ident` is a copy. A file whose declaration delegates is a stub,
# and a stub is the landed state: it keeps its own signature and its own error name, so
# every caller in the file is unmoved, and the rule lives in one place.
#
# THE BLIND SPOT THIS METER EXISTS TO COVER, NAMED PLAINLY. Its sibling
# `glow_ceiling_refusal_scan.sh` reads a ceiling site as a comparison against a named `max_`
# constant. Moving a ceiling into a PARAMETER therefore takes the site off that meter
# whether or not a refusal record was ever written -- `uncovered` fell 40 to 34 on the six
# conversions of `20260917` while `recorded` held at 8, because the record moved into
# `zig_ident.rye` where the sibling cannot see it. So that number can be lowered by
# parameterizing a ceiling and writing nothing. This meter is the other half: it counts
# whether the rule is in one place, and `glow/refusal_witness.rye` is what proves the
# record behind it.
#
# READ PAST. A doc comment naming the function is prose rather than a declaration, and
# `glow/zig_ident.rye`'s own header names it four times. Only a line beginning `fn
# zig_safe_ident` at column one is read as a declaration.
#
# USAGE
#   sh tools/fixtures/g/glow_ident_duplication_scan.sh          # count
#   sh tools/fixtures/g/glow_ident_duplication_scan.sh --list   # name each copy
#
# Run from the repository root, or from a pen holding its own `glow/` room.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap converts a copy into a stub.
#   16  `20260917.130000`  the reading after the second cohort. The line below named the
#                          next fall as the FOUR `lower_compose_core*` siblings; measured
#                          rather than taken on its word, the cohort is SEVEN -- every file
#                          declaring `out` as `*[rf.max_name_len]u8`, and all seven bodies
#                          byte-identical at md5 `049cce282d2bf7d1b5543165776869c5`:
#                          `lower_compose`, `lower_compose2`, `lower_compose_core`,
#                          `lower_compose_core_add`, `lower_compose_core_payload`,
#                          `lower_compose_jam_cue`, `lower_compose_lib`. All seven became
#                          stubs with their own seven guards GREEN, 23 to 16.
#                          The named next fall is `glow/lower_face.rye`, which shares the
#                          same `rf.max_name_len` ceiling and differs from the seven by ONE
#                          local name, `c` against `ch`. It waits for its own lap because it
#                          carries 29 call sites against the seven's 22 together.
#   23  `20260917.002500`  the reading after the first cohort. 29 copies stood at the open;
#                          `lower_call`, `lower_calln`, `lower_cell`, `lower_list`,
#                          `lower_triple` and `lower_quad` became stubs with their own six
#                          guards GREEN, leaving 23. The named next fall is the four
#                          `lower_compose_core*` siblings, which share one ceiling.
CEILING=16

room="glow"
[ -d "$room" ] || { echo "instrument=no_glow_room"; exit 1; }

copies=0
stubs=0
list=""

for f in "$room"/*.rye; do
    [ -f "$f" ] || continue
    # A declaration is `fn zig_safe_ident` at column one. Prose naming it is read past.
    grep -q '^fn zig_safe_ident' "$f" || continue
    if grep -q 'zig_ident\.safe_ident' "$f"; then
        stubs=$((stubs + 1))
    else
        copies=$((copies + 1))
        list="$list$f
"
    fi
done

if [ "$mode" = "--list" ]; then
    printf '%s' "$list" | sed '/^$/d' | sort
fi

published=no
[ -f "$room/zig_ident.rye" ] && grep -q '^pub fn safe_ident' "$room/zig_ident.rye" && published=yes

under=yes
[ "$copies" -gt "$CEILING" ] && under=no

echo "instrument=ok"
echo "GLOW_IDENT_DUPLICATION copies=$copies stubs=$stubs published=$published ceiling=$CEILING under_ceiling=$under"
