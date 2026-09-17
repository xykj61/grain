#!/bin/sh
# tools/fixtures/a/alloc_bound_reach_control.sh -- the pen for
# tools/fixtures/a/alloc_bound_reach_scan.sh.
#
# Every refusal is planted and then lifted, so a leg that passes in one direction alone
# cannot be told from a bypass. Real git repositories in a throwaway pen, because the
# scan draws its boundary with `git ls-files`: a pen whose sources merely sat on disk
# would read as an empty tree and every leg would pass for the wrong reason.
#
# THE MUTATIONS, each asserted to bite, and each preceded in the same pen by the
# unmutated reading it replaces -- a mutation is evidence only where the truth it
# displaces differs from it:
#
#   m1  split the count on EVERY comma rather than on a top-level one. This is the
#       first draft's own fault: `@as(usize, @intCast(total))` read as the count
#       expression `@as(usize`, and 146 sites classified on a fragment.
#   m2  drop the string walk, so a comma inside a string literal separates arguments.
#   m3  read a `.dupe(` as an allocation site, folding a derived-by-construction copy
#       into the population rule 1 is asked about.
#   m4  drop the `comm` against the declarations, so a count naming a bound that does
#       not exist anywhere passes as `named`.
#
# Run from the repository root:  sh tools/fixtures/a/alloc_bound_reach_control.sh
set -u

ROOT=$(pwd)
# `sed -i` is GNU-only; the portable helper writes through the original inode.
. "$ROOT/tools/fixtures/s/shell_portable.sh"
SCAN="$ROOT/tools/fixtures/a/alloc_bound_reach_scan.sh"

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

legs=0
failed=0

# leg <got> <want> <name> -- got first, because the printout says "wanted W, read G".
leg() {
  legs=$((legs + 1))
  if [ "$1" = "$2" ]; then
    printf 'leg %s ok (%s)\n' "$3" "$1"
  else
    failed=$((failed + 1))
    printf 'leg %s FAILED -- wanted %s, read %s\n' "$3" "$2" "$1"
  fi
}

new_pen() {
  rm -rf "$pen/tree"
  mkdir -p "$pen/tree/tally" "$pen/tree/tools/fixtures/a"
  cd "$pen/tree" || exit 1
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  cp "$SCAN" tools/fixtures/a/alloc_bound_reach_scan.sh
  # One declared bound, so the scan's own `no_bounds_found` refusal stays lifted.
  printf 'const max_pen_bytes: u32 = 64;\n' > tally/bounds.rye
}

seal() { git add -A >/dev/null 2>&1; git commit -qm pen >/dev/null 2>&1; }

read_key() { sh tools/fixtures/a/alloc_bound_reach_scan.sh 2>/dev/null | grep "^$1=" | cut -d= -f2; }

# ---------------------------------------------------------------- the four classes
new_pen
cat > tally/sites.rye <<'RYE'
fn a() void {
    const x = garden.alloc(u8, max_pen_bytes);
    const y = garden.alloc(u8, 32);
    const z = garden.alloc(u8, src.len);
    const w = garden.alloc(u8, cap);
}
RYE
seal
leg "$(read_key named)"   1 named_counted
leg "$(read_key literal)" 1 literal_counted
leg "$(read_key derived)" 1 derived_counted
leg "$(read_key opaque)"  1 opaque_counted
leg "$(read_key alloc_sites)" 4 sites_total
leg "$(read_key verdict)" ok four_classes_ok

# A literal arithmetic product is still a literal -- bounded, naming no reason.
new_pen
printf 'fn a() void { const x = garden.alloc(u8, 4 * 8); }\n' > tally/sites.rye
seal
leg "$(read_key literal)" 1 literal_arithmetic

# ------------------------------------------------- the depth walk, and its mutation
new_pen
printf 'fn a() void { const x = garden.alloc(u8, @as(usize, @intCast(total))); }\n' > tally/sites.rye
seal
leg "$(read_key alloc_sites)" 1 nested_is_one_site
leg "$(read_key opaque)"      1 nested_is_opaque
leg "$(read_key named)"       0 nested_not_named
# THE MUTATION NEEDS THE BOUND INSIDE THE NESTED CALL. Splitting on every comma leaves
# the fragment `@as(usize`, which classifies `opaque` exactly as the whole expression
# does -- so the first draft of this leg read a mutated scan and a sound one alike. The
# plant puts the bound where the split would drop it.
new_pen
printf 'fn a() void { const x = garden.alloc(u8, @as(usize, max_pen_bytes)); }\n' > tally/sites.rye
seal
leg "$(read_key named)" 1 nested_bound_is_named
# m1 -- split on every comma, so the count becomes the fragment `@as(usize`.
sed_inplace 's/else if (ch == "," && depth == 1)/else if (ch == ",")/' tools/fixtures/a/alloc_bound_reach_scan.sh
m1=$(read_key named)
leg "$([ "$m1" = 1 ] && echo unbitten || echo bitten)" bitten m1_depth_walk_bites

# --------------------------------------------- the string walk, and its mutation
new_pen
# THE QUOTED COMMA MUST SIT AT DEPTH 1. Written `label("a,b").len` it sits inside the
# call's own parens, where the depth test already declines it -- so the first draft of
# this plant exercised the depth walk a second time and left the string walk unread.
printf 'fn a() void { const x = garden.alloc(u8, "a,b".len); }\n' > tally/sites.rye
seal
leg "$(read_key derived)"     1 string_comma_not_a_split
leg "$(read_key alloc_sites)" 1 string_comma_one_site
# m2 -- never enter string mode, so the quoted comma separates arguments. The switch is
# the flag rather than the quote literal, which would have to survive two shells and an
# awk program to be matched at all.
sed_inplace 's/instr = 1;/instr = 0;/' tools/fixtures/a/alloc_bound_reach_scan.sh
m2=$(read_key derived)
leg "$([ "$m2" = 1 ] && echo unbitten || echo bitten)" bitten m2_string_walk_bites

# ------------------------------------------ dupe stands apart, and its mutation
new_pen
cat > tally/sites.rye <<'RYE'
fn a() void {
    const x = garden.alloc(u8, 16);
    const y = garden.dupe(u8, src);
}
RYE
seal
leg "$(read_key alloc_sites)" 1 dupe_outside_sites
leg "$(read_key dupe_sites)"  1 dupe_counted_apart
# m3 -- read a dupe as an allocation site.
sed_inplace 's/if (kind == "dupe") print "dupe\\t"/if (0) print "dupe\\t"/' tools/fixtures/a/alloc_bound_reach_scan.sh
m3=$(read_key alloc_sites)
leg "$([ "$m3" = 1 ] && echo unbitten || echo bitten)" bitten m3_dupe_split_bites

# ------------------------------- the one wall: a bound named at a site and nowhere declared
new_pen
printf 'fn a() void { const x = garden.alloc(u8, max_nowhere); }\n' > tally/sites.rye
seal
leg "$(read_key unresolved)" 1 unresolved_counted
leg "$(read_key verdict)" unresolved_bound unresolved_refuses
sh tools/fixtures/a/alloc_bound_reach_scan.sh >/dev/null 2>&1
leg "$?" 1 unresolved_exit_one
# LIFTED: declare it, and the same tree walks free.
printf 'const max_nowhere: u32 = 8;\n' >> tally/bounds.rye
seal
leg "$(read_key unresolved)" 0 unresolved_lifts
leg "$(read_key verdict)" ok unresolved_lifted_ok
# m4 -- drop the comparison against the declarations.
printf 'fn a() void { const x = garden.alloc(u8, max_gone); }\n' > tally/sites.rye
seal
leg "$(read_key verdict)" unresolved_bound m4_premutation_refuses
sed_inplace 's/^unresolved=\$(comm -23 .*$/unresolved=0/' tools/fixtures/a/alloc_bound_reach_scan.sh
m4=$(read_key verdict)
leg "$([ "$m4" = unresolved_bound ] && echo unbitten || echo bitten)" bitten m4_declaration_compare_bites

# A QUALIFIED NAME RESOLVES BY ITS BARE FORM. `boot.max_cap_word_len` is how this tree
# spells a bound imported from a sibling, and a reading keyed on the whole expression
# would call every one of them unresolved.
new_pen
printf 'fn a() void { const x = garden.alloc(u8, boot.max_pen_bytes); }\n' > tally/sites.rye
seal
leg "$(read_key named)" 1 qualified_is_named
leg "$(read_key unresolved)" 0 qualified_resolves

# --------------------------------------------------------- what the scan declines
new_pen
printf 'fn a() void {\n    // const x = garden.alloc(u8, 1);\n    const y = garden.alloc(u8, 2);\n}\n' > tally/sites.rye
seal
leg "$(read_key alloc_sites)" 1 comment_line_declined

new_pen
printf 'fn a() void { const x = garden.alloc(\n        u8, 4); }\n' > tally/sites.rye
seal
leg "$(read_key spans_lines)" 1 spanning_call_counted
leg "$(read_key alloc_sites)" 0 spanning_call_not_classified

# An untracked source is outside the boundary the scan draws.
new_pen
printf 'fn a() void { const x = garden.alloc(u8, 9); }\n' > tally/sites.rye
seal
leg "$(read_key alloc_sites)" 1 tracked_source_read
printf 'fn b() void { const x = garden.alloc(u8, 9); }\n' > tally/loose.rye
leg "$(read_key alloc_sites)" 1 untracked_source_declined

# ------------------------------------------------------ the function-scope reading
new_pen
cat > tally/fns.rye <<'RYE'
fn both() void {
    assert(n <= max_pen_bytes);
    const x = garden.alloc(u8, n);
}
fn assert_only() void {
    assert(n <= 9);
    const x = garden.alloc(u8, n);
}
fn max_only() void {
    const lim = max_pen_bytes;
    const x = garden.alloc(u8, lim);
}
fn neither() void {
    const x = garden.alloc(u8, n);
}
RYE
seal
leg "$(read_key fn_allocating)"  4 fn_population
leg "$(read_key fn_both)"        1 fn_both_counted
leg "$(read_key fn_assert_only)" 1 fn_assert_only_counted
leg "$(read_key fn_max_only)"    1 fn_max_only_counted
leg "$(read_key fn_neither)"     1 fn_neither_counted

# A function holding no allocation stays outside the population entirely.
printf 'fn quiet() void {\n    const n = 1;\n}\n' >> tally/fns.rye
seal
leg "$(read_key fn_allocating)" 4 fn_non_allocating_declined

# ------------------------------------------------- the instrument's own refusals
new_pen
printf 'fn a() void { const x = garden.alloc(u8, 4); }\n' > tally/sites.rye
rm tally/bounds.rye
seal
leg "$(read_key verdict)" no_bounds_found refuses_without_declarations

new_pen
seal
leg "$(read_key verdict)" no_sites_found refuses_without_sites

new_pen
printf 'fn a() void { const x = garden.alloc(u8, 4); }\n' > tally/sites.rye
seal
rm -rf .git
leg "$(read_key verdict)" not_a_repo refuses_outside_a_repo

# ------------------------------------------------------------------ the list face
new_pen
printf 'fn a() void { const x = garden.alloc(u8, max_pen_bytes); }\n' > tally/sites.rye
seal
leg "$(sh tools/fixtures/a/alloc_bound_reach_scan.sh --list 2>/dev/null | grep -c 'class=named')" 1 list_names_the_site
leg "$(sh tools/fixtures/a/alloc_bound_reach_scan.sh 2>/dev/null | grep -c 'detail:')" 0 bare_run_prints_no_detail
leg "$(read_key bound_names_at_sites)" 1 distinct_names_at_sites

cd "$ROOT" || exit 1
echo "legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=red"
