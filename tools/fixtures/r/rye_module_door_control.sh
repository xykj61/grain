#!/bin/sh
# tools/fixtures/r/rye_module_door_control.sh -- proves tools/fixtures/r/rye_module_door_scan.sh on
# real git repositories in a throwaway pen, every refusal planted and then lifted.
#
# Run from the repository root:
#   sh tools/fixtures/r/rye_module_door_control.sh
#
# A refusal proven only in the passing direction cannot be told from a bypass, so each plant is
# lifted and the reading asserted back. The two mutations at the end remove a check the scan relies
# on and assert the reading MOVES -- a check nobody has watched fail is a check nobody has proven.
#
# The legs are counted out loud and the witness asserts the count, because `control_failed=0` is
# what an empty pen prints too.
set -eu

# The scan under test is the tree's own by default. `RYE_DOOR_SCAN` names another copy, which is how
# a mutated copy is driven below and how this control can prove a scan before it is in place.
SCAN=${RYE_DOOR_SCAN:-$PWD/tools/fixtures/r/rye_module_door_scan.sh}
[ -f "$SCAN" ] || { echo "control_verdict=no_scan"; echo "detail: the scan under test was not found"; exit 2; }

PEN=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 2; }
trap 'rm -rf "$PEN"' EXIT INT TERM
fail=0
legs=0
leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "$1=yes"; else echo "$1=no"; echo "detail: $1 wanted [$3] read [$2]"; fail=$((fail + 1)); fi
}

# The pen is built with one of each exempt class already standing, because both exemptions carry a
# floor: a reading taken where they match nothing refuses, and every leg below would then read the
# same refusal for the wrong reason.
fresh() {
  rm -rf "$PEN/t"
  mkdir -p "$PEN/t/mod" "$PEN/t/tools/fixtures/z" "$PEN/t/construction"
  cd "$PEN/t"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name Pen
  git config commit.gpgsign false
  printf '%s\n' '//! mod/quiet.rye -- a module that opens at its door.' > mod/quiet.rye
  printf '%s\n' '// a planted control keeps the fault it plants' > tools/fixtures/z/pen.rye
  printf '%s\n' '// elder seed, kept for inbound references' > construction/20260703-202312_seed.rye
}
commit_all() { git add -A >/dev/null 2>&1 || true; git commit -q -m 'pen' >/dev/null 2>&1 || true; }
run_scan() { RYE_DOOR_MIN_MODULES=1 sh "$SCAN" "$@" 2>/dev/null; }
read_key() { run_scan | grep "^$1=" | cut -d= -f2 | tail -1; }

# --- a door in the grammar's own form reads clean ----------------------------------------------
fresh
commit_all
leg door_form_clean "$(read_key silent)" 0
leg door_form_ok "$(read_key verdict)" ok
leg corpus_counts_all "$(read_key modules)" 3
leg gated_excludes_exempt "$(read_key gated_modules)" 1
leg fixture_exempt_counted "$(read_key exempt_fixture)" 1
leg testimony_exempt_counted "$(read_key exempt_testimony)" 1

# --- an ordinary comment head is a door a tool cannot read -------------------------------------
printf '%s\n' '// mod/loud.rye -- real Door prose, in the form the compiler does not reserve.' > mod/loud.rye
commit_all
leg slash_head_counts "$(read_key silent)" 1
leg slash_head_refuses "$(read_key verdict)" silent_door
leg slash_head_named "$(run_scan names | grep -c 'detail: silent mod/loud.rye')" 1

# --- lifting the plant returns the reading ------------------------------------------------------
printf '%s\n' '//! mod/loud.rye -- real Door prose, in the form the compiler reserves.' > mod/loud.rye
commit_all
leg slash_head_lifted "$(read_key silent)" 0
leg slash_head_lifted_ok "$(read_key verdict)" ok

# --- a module opening with code has no door at all ----------------------------------------------
printf '%s\n' 'const std = @import("std");' > mod/bare.rye
commit_all
leg code_head_counts "$(read_key silent)" 1
rm -f mod/bare.rye
commit_all
leg code_head_lifted "$(read_key silent)" 0

# --- blank lines above the door are read past ---------------------------------------------------
printf '\n\n%s\n' '//! mod/spaced.rye -- the door after two blank lines.' > mod/spaced.rye
commit_all
leg blank_lines_read_past "$(read_key silent)" 0

# --- a doc comment below code is not a door, because position is what the compiler reserves -----
printf '%s\n%s\n' 'const std = @import("std");' '//! a late claim' > mod/late.rye
commit_all
leg late_door_counts "$(read_key silent)" 1
rm -f mod/late.rye
commit_all
leg late_door_lifted "$(read_key silent)" 0

# --- a declaration doc comment is a different setting and opens no door -------------------------
printf '%s\n' '/// a declaration doc' > mod/decl.rye
commit_all
leg decl_doc_counts "$(read_key silent)" 1
rm -f mod/decl.rye
commit_all
leg decl_doc_lifted "$(read_key silent)" 0

# --- a fixture module is exempt, and it is exempt by its PATH rather than by its head ------------
printf '%s\n' 'const std = @import("std");' > tools/fixtures/z/pen.rye
commit_all
leg fixture_exempt_holds "$(read_key silent)" 0
leg fixture_still_counted "$(read_key exempt_fixture)" 1

# --- dated testimony is exempt, and a stamp without a sprig is still a stamp ---------------------
printf '%s\n' 'const std = @import("std");' > construction/20260703-202312_seed.rye
printf '%s\n' 'const std = @import("std");' > construction/20260704-010101.rye
commit_all
leg testimony_exempt_holds "$(read_key silent)" 0
leg sprigless_stamp_exempt "$(read_key exempt_testimony)" 2
rm -f construction/20260704-010101.rye
commit_all

# --- a vendored module is outside the corpus entirely -------------------------------------------
mkdir -p vendor/lib
printf '%s\n' 'const std = @import("std");' > vendor/lib/foreign.rye
commit_all
leg vendor_outside_corpus "$(read_key modules)" 5
leg vendor_leaves_reading "$(read_key silent)" 0
rm -rf vendor
commit_all

# --- the ceiling is honored in both directions --------------------------------------------------
printf '%s\n' '// mod/loud.rye -- ordinary head again.' > mod/loud.rye
commit_all
leg ceiling_zero_refuses "$(read_key silent)" 1
leg ceiling_zero_verdict "$(read_key verdict)" silent_door
leg ceiling_one_welcomes "$(RYE_DOOR_MIN_MODULES=1 RYE_DOOR_CEILING=1 sh "$SCAN" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" ok
printf '%s\n' '//! mod/loud.rye -- door restored.' > mod/loud.rye
commit_all

# --- a corpus under the reach floor refuses rather than reporting a clean tree -------------------
leg reach_floor_refuses "$(RYE_DOOR_MIN_MODULES=99 sh "$SCAN" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" reach_short
leg reach_floor_lifted "$(read_key verdict)" ok

# --- an exemption that matches nothing refuses, because the reading below it means nothing -------
fresh
rm -f tools/fixtures/z/pen.rye
commit_all
leg exempt_unreached_refuses "$(read_key verdict)" exempt_unreached
leg exempt_unreached_names "$(run_scan | grep -c 'detail: testimony=1 fixture=0')" 1
printf '%s\n' '// a planted control keeps the fault it plants' > tools/fixtures/z/pen.rye
commit_all
leg exempt_unreached_lifted "$(read_key verdict)" ok

# --- a module holding no line at all is unread rather than clean --------------------------------
: > mod/empty.rye
commit_all
leg empty_module_refuses "$(read_key verdict)" read_refused
leg empty_module_counted "$(read_key read_refused)" 1
rm -f mod/empty.rye
commit_all
leg empty_module_lifted "$(read_key verdict)" ok

# --- a path carrying whitespace refuses by name rather than reading short ------------------------
printf '%s\n' '//! spaced name' > "mod/two words.rye"
commit_all
leg spaced_path_refuses "$(read_key verdict)" spaced_path
rm -f "mod/two words.rye"
commit_all
leg spaced_path_lifted "$(read_key verdict)" ok

# --- without git the reading declines rather than calling every module clean --------------------
rm -rf .git
leg no_git_declines "$(read_key verdict)" no_git
commit_all

# --- the portable helper says which branch ran, in both directions -------------------------------
# A copy of this scan driven from outside any tree cannot source the tree's helper, and a copy that
# exits before it reads a line looks exactly like a mutation that did not bite. Both branches are
# asserted, because a fallback nobody can see is a fallback nobody can tell from the real thing.
fresh
commit_all
leg helper_reads_tree "$(read_key helper)" tree
cp "$SCAN" "$PEN/loose.sh"
leg helper_reads_local "$(RYE_DOOR_MIN_MODULES=1 sh "$PEN/loose.sh" 2>/dev/null | grep '^helper=' | cut -d= -f2)" local
leg helper_local_still_reads "$(RYE_DOOR_MIN_MODULES=1 sh "$PEN/loose.sh" 2>/dev/null | grep '^modules=' | cut -d= -f2)" 3

# --- mutation one: read the door ANYWHERE rather than at the first non-blank line ---------------
fresh
printf '%s\n%s\n' 'const std = @import("std");' '//! a late claim' > mod/late.rye
commit_all
leg mutation_position_applied "$(read_key silent)" 1
sed 's@^    seen\[FILENAME\] { next }$@    0 { next }@' "$SCAN" > "$PEN/mut1.sh"
if cmp -s "$SCAN" "$PEN/mut1.sh"; then
  leg mutation_position_bites changed unchanged
else
  leg mutation_position_bites "$(RYE_DOOR_MIN_MODULES=1 sh "$PEN/mut1.sh" 2>/dev/null | grep '^silent=' | cut -d= -f2)" 0
fi

# --- mutation two: widen the fixture exemption to every path and the gated corpus collapses -----
fresh
commit_all
leg mutation_exempt_applied "$(read_key gated_modules)" 1
sed "s@^grep -E '(\^|/)fixtures/'@grep -E ''@" "$SCAN" > "$PEN/mut2.sh"
if cmp -s "$SCAN" "$PEN/mut2.sh"; then
  leg mutation_exempt_bites changed unchanged
else
  leg mutation_exempt_bites "$(RYE_DOOR_MIN_MODULES=1 sh "$PEN/mut2.sh" 2>/dev/null | grep '^gated_modules=' | cut -d= -f2)" 0
fi

cd /
echo "control_legs=$legs"
echo "control_failed=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=failed"; exit 1; fi
echo "control_verdict=ok"
