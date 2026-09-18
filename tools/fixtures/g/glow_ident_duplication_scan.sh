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
#   15  `20260917.140000`  `glow/lower_face.rye` became a stub, and it was the LAST file at
#                          its own body md5 `e4cec7a4` -- one local name apart from the seven
#                          above, `c` against `ch`, measured rather than taken from the line
#                          that named it. Its 29 call sites each take the hyphenated name of
#                          the thing they lower, so a refusal record says which face refused.
#                          The fifteen that remain fall into cohorts, measured this lap by
#                          body md5 and declared ceiling: THREE `max_arm_len` siblings at
#                          `97c14eb8` -- `lower_conditional`, `lower_null`, `lower_switch` --
#                          carrying 31 call sites EACH, which is the largest cohort left and
#                          the largest single lap; a `rm.max_name_len` PAIR at `4484b371`,
#                          `lower_shape` at 14 sites and `lower_named_cast` at 15, which is
#                          the cheaper next fall; and nine singletons, three of which name
#                          their own ceiling (`rb.max_face_len`, `rbt.max_ident_len`,
#                          `rk.max_name_len`) and one of which, `lower_alias`, takes a bare
#                          `[]u8` and maps the dot -- the one copy whose body is genuinely a
#                          different rule, and the one wanting `Dot.to_underscore`.
#   13  `20260917.175500`  the `rm.max_name_len` PAIR the line above named as the cheaper fall --
#                          `lower_shape` at 14 call sites and `lower_named_cast` at 15 -- became
#                          stubs, and both already answered the `u32` TAME asks, so the lap was
#                          the delegation alone with no width repair beside it. The thirteen that
#                          remain, read this lap by body md5 (the declared ceiling normalized out,
#                          so a cohort is a cohort whatever budget it names) and by call sites:
#                          the `max_arm_len` THREE -- `lower_conditional`, `lower_null`,
#                          `lower_switch`, 31 call sites EACH, 93 together -- fell `20260917`,
#                          the largest lap this room has offered; the `max_name_len` PAIR at
#                          `658a5b6f`, `lower_multi` and `lower_multi_typed`, fell the same day --
#                          one site each, the cheapest fall this room offered before it -- and
#                          eight singletons remain (`lower_shop_gate` 12, `lower_core` 4,
#                          `lower_call3` 4, `lower_call2` 3, `lower_alias` 2, `lower_face_lit` 2,
#                          `lower_shop_nest` 2, `lower_trap` 1). `lower_alias` stays the one body
#                          that is genuinely a different rule -- a bare `[]u8` that maps the dot
#                          -- and the one wanting `Dot.to_underscore`.
#    8  `20260917.213500`  the largest singleton fell: `glow/lower_shop_gate.rye`, 12 call sites,
#                          became a stub. Its body was the one `zig_ident.rye`'s own header names
#                          as genuinely different -- it answered a LENGTH ceiling with
#                          `error.MissingFace` where 28 peers answered `error.BadIdent`, and it
#                          mapped no dot at all. The wrapper keeps both: it calls
#                          `zig_ident.safe_ident` with `.refuse` (the dot was already refused by
#                          falling through the character check) and catches `error.BadIdent`,
#                          answering `error.MissingFace` in its place -- so `rb.ParseError` and
#                          the witness leg that switches on it (`lower_shop_gate_witness.rye:901`)
#                          stay unmoved, and `LowerError` gains no new member. Seven singletons
#                          remain (`lower_core` 4, `lower_call3` 4, `lower_call2` 3, `lower_alias`
#                          2, `lower_face_lit` 2, `lower_shop_nest` 2, `lower_trap` 1).
#    7  `20260917.220500`  `glow/lower_alias.rye` became a stub -- the one body the ladder above
#                          named as genuinely a different rule, since it maps `.` to `_` as well
#                          as `-`, for a wing like `i.records.cur` rather than a bare face. It
#                          calls `zig_ident.safe_ident` with `.to_underscore` rather than the
#                          room's usual `.refuse`, and both call sites' return type moved
#                          `usize` to `u32` in the same lap -- the last of the 23 counted at
#                          seating still returning it. `LowerError` and its `error.BadIdent`
#                          member are unmoved. Six singletons remain (`lower_core` 4,
#                          `lower_call3` 4, `lower_call2` 3, `lower_face_lit` 2,
#                          `lower_shop_nest` 2, `lower_trap` 1).
#    5  `20260917.222500`  the cheapest singleton fell: `glow/lower_trap.rye`, one call site.
#                          Its body was the plain 28-body rule with no dot-mapping and no
#                          length-ceiling divergence, and its return type moved `usize` to
#                          `u32` in the same lap. `LowerError` and its `error.BadIdent` member
#                          are unmoved. Five singletons remain (`lower_core` 4, `lower_call3`
#                          4, `lower_call2` 3, `lower_face_lit` 2, `lower_shop_nest` 2).
#    4  `20260917.224500`  `glow/lower_shop_nest.rye` became a stub -- its two call sites (the
#                          welcome and the argv path) both reached `zig_ident.safe_ident`
#                          with `.refuse`. Its body was the same genuinely-different rule the
#                          ladder named at seating: the elder answered a LENGTH ceiling AND a
#                          bad character with the one name `error.MissingFace`, where every
#                          other copy answered `error.BadIdent`. `LowerError` gains the
#                          `error.BadIdent` member the module never carried before; its return
#                          type was already `u32` (width-check corpus unmoved at 1,129). Four
#                          singletons remain (`lower_core` 4, `lower_call3` 4, `lower_call2`
#                          3, `lower_face_lit` 2).
#    3  `20260917.224809`  `glow/lower_face_lit.rye` became a stub -- its two call sites (the
#                          emit-body and the return-tuple binder) both reached
#                          `zig_ident.safe_ident` with `.refuse`. Its body was the plain 28-body
#                          rule with no dot-mapping and no length-ceiling divergence; its return
#                          type was already `u32` (width-check corpus unmoved at 1,129).
#                          `LowerError` and its `error.BadIdent` member are unmoved. Three
#                          singletons remain (`lower_core` 4, `lower_call3` 4, `lower_call2` 3).
#    2  `20260917.230329`  `glow/lower_call2.rye` became a stub -- its three call sites (gate,
#                          a, b) all reached `zig_ident.safe_ident` with `.refuse`, each naming
#                          its own field. Its body was the plain 28-body rule with no
#                          dot-mapping and no length-ceiling divergence; its return type moved
#                          `usize` to `u32` in the same lap, the last of the room's own copies
#                          still returning it. `LowerError` and its `error.BadIdent` member are
#                          unmoved. Two singletons remain (`lower_core` 4, `lower_call3` 4).
#    1  `20260917`         `glow/lower_call3.rye` became a stub -- its four call sites (gate, a,
#                          b, c) all reached `zig_ident.safe_ident` with `.refuse`, each naming
#                          its own field. Its body was the plain 28-body rule with no
#                          dot-mapping and no length-ceiling divergence; its return type moved
#                          `usize` to `u32` in the same lap. `LowerError` and its `error.BadIdent`
#                          member are unmoved. One singleton remains (`lower_core` 4).
CEILING=1

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
