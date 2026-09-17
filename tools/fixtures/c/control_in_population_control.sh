#!/bin/sh
# tools/fixtures/c/control_in_population_control.sh -- prove the control-in-population reading by
# doing.
#
# WHY. A guard that cannot red guards nothing (REDS %59). This control builds real git
# repositories in a throwaway pen, plants one scan shape in each, runs
# tools/fixtures/c/control_in_population_scan.sh inside them, and checks that each classification
# lands where it belongs. Nothing here touches the tree it is run from.
#
# THE PLANT LIVES ONLY IN THE PEN, and that is this file's whole discipline -- it is the ruling
# `%775` handed down one instrument over, and the very defect this family measures. The scan's
# population is every tracked `*_scan.sh`, so a plant written into the tracked bytes here would
# enter the live reading and move the numbers the scan reports about the tree. Every plant below
# is therefore written into a pen repository at run time by a heredoc, and no tracked file in this
# family carries a `_scan.sh` basename except the scan itself.
#
# USAGE
#   sh tools/fixtures/c/control_in_population_control.sh
#
# Driven by tools/c/control_in_population_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/c/control_in_population_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT HUP TERM

legs=0
fails=0
leg() {
  name=$1; got=$2; want=$3
  legs=$((legs + 1))
  if [ "$got" = "$want" ]; then
    echo "$name=yes"
  else
    echo "$name=no got=$got want=$want"
    fails=$((fails + 1))
  fi
}

# build <name> -- makes a pen repository carrying the scan under test at its real path, so the
# scan resolves its own ROOT to the pen rather than to this tree.
build() {
  d=$pen/$1
  mkdir -p "$d/tools/fixtures/c" "$d/tools/fixtures/p" "$d/tools/p"
  cp "$scan" "$d/tools/fixtures/c/control_in_population_scan.sh"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf '# pen\nA real document so no pen is merely empty.\n' > README.md ) >/dev/null 2>&1
  echo "$d"
}

commit_and_read() {
  ( cd "$1" && git add -A >/dev/null 2>&1 && git commit -qm 'pen: one planted scan shape' >/dev/null 2>&1
    sh tools/fixtures/c/control_in_population_scan.sh 2>/dev/null )
}
read_field() { printf '%s\n' "$1" | grep -E "^$2=" | head -1 | cut -d= -f2-; }

# ---------------------------------------------------------------------------
# 1. A bare `git ls-files` is the WHOLE tracked tree, and it must be KEPT.
#    This is the regression leg. A first draft of the scan dropped every bare invocation while
#    trying to drop prose mentions, and so discarded the broadest population a scan can read --
#    silently, into a single `unread` total that hid it.
# ---------------------------------------------------------------------------
d=$(build bare_whole_tree)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
git ls-files
PEN
cat > "$d/tools/fixtures/p/plain_control.sh" <<'PEN'
#!/bin/sh
echo pen control
PEN
out=$(commit_and_read "$d")
leg bare_ls_files_enumerates "$(read_field "$out" enumerating)" 2
leg bare_ls_files_self_reads "$(read_field "$out" self_reading)" 1
leg bare_ls_files_names_control "$(read_field "$out" self_reading_control)" 1

# ---------------------------------------------------------------------------
# 2. A narrow population that cannot reach its own family is clear, and the scan says so by
#    counting it as enumerating while leaving self_reading alone. Proving the clear direction as
#    hard as the refusal is what tells a reading apart from a bypass.
# ---------------------------------------------------------------------------
d=$(build narrow_population)
mkdir -p "$d/notes"
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
git ls-files '*.md'
PEN
cat > "$d/tools/fixtures/p/plain_control.sh" <<'PEN'
#!/bin/sh
echo pen control
PEN
printf '# a note\n' > "$d/notes/a.md"
out=$(commit_and_read "$d")
leg narrow_enumerates "$(read_field "$out" enumerating)" 2
leg narrow_self_reads_zero "$(read_field "$out" self_reading)" 0
leg narrow_control_zero "$(read_field "$out" self_reading_control)" 0

# ---------------------------------------------------------------------------
# 3. `--error-unmatch` is a PREDICATE over one path, never a population. It earns its own class
#    rather than joining the unmeasured pile, since it is structurally outside the reading rather
#    than unread.
# ---------------------------------------------------------------------------
d=$(build membership_only)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
git ls-files --error-unmatch README.md
PEN
out=$(commit_and_read "$d")
leg membership_test_counted "$(read_field "$out" membership_test)" 1
leg membership_not_enumerating "$(read_field "$out" enumerating)" 1

# ---------------------------------------------------------------------------
# 4. A glob held in a shell variable cannot be run safely, so the scan refuses it into its own
#    named class. This is the honest blind spot: unmeasured, and printed as such.
# ---------------------------------------------------------------------------
d=$(build variable_glob)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
GLOB='*.md'
git ls-files -- "$GLOB"
PEN
out=$(commit_and_read "$d")
leg variable_glob_refused "$(read_field "$out" enumeration_refused)" 1

# ---------------------------------------------------------------------------
# 5. A scan naming no `git ls-files` at all reads one module directory or runs a program, and is
#    counted apart. It is not proven clear -- a `find` rooted at the tools directory can reach a
#    control -- so the class carries its own count rather than vanishing into a zero.
# ---------------------------------------------------------------------------
d=$(build no_git_population)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
find . -name '*.md' -type f
PEN
out=$(commit_and_read "$d")
leg find_only_counted "$(read_field "$out" no_git_population)" 1
leg find_only_not_enumerating "$(read_field "$out" enumerating)" 1

# ---------------------------------------------------------------------------
# 6. A comment naming the command in prose is not an invocation. The scan strips comment text
#    before it extracts, so a header teaching the reader about `git ls-files` counts as nothing.
# ---------------------------------------------------------------------------
d=$(build prose_only)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
# This scan would use git ls-files '*.md' if it read the tracked tree, which it does not.
find . -name '*.md' -type f
PEN
out=$(commit_and_read "$d")
leg prose_is_not_invocation "$(read_field "$out" no_git_population)" 1

# ---------------------------------------------------------------------------
# 7. A family file that is NOT a control still counts as self-reading, and the control flag stays
#    no. The two readings answer different questions and must move apart.
# ---------------------------------------------------------------------------
d=$(build family_without_control)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
git ls-files
PEN
cat > "$d/tools/p/plain_witness.rish" <<'PEN'
# pen witness
PEN
out=$(commit_and_read "$d")
leg family_self_reads "$(read_field "$out" self_reading)" 1
leg family_control_flag_off "$(read_field "$out" self_reading_control)" 0

# ---------------------------------------------------------------------------
# 8. --explain names the family files a given scan holds, and --list prints one row per hit.
# ---------------------------------------------------------------------------
d=$(build explain_shape)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
git ls-files
PEN
cat > "$d/tools/fixtures/p/plain_control.sh" <<'PEN'
#!/bin/sh
echo pen control
PEN
( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm 'pen: explain shape' >/dev/null 2>&1 )
ex=$( cd "$d" && sh tools/fixtures/c/control_in_population_scan.sh --explain tools/fixtures/p/plain_scan.sh 2>/dev/null )
printf '%s' "$ex" | grep -q 'plain_control.sh' && leg explain_names_control yes yes || leg explain_names_control no yes
li=$( cd "$d" && sh tools/fixtures/c/control_in_population_scan.sh --list 2>/dev/null | grep -c 'control=yes' )
leg list_prints_one_row "$li" 1

# ---------------------------------------------------------------------------
# 9. THE PLANT IS NOT IN THE TRACKED BYTES. This family measures a defect it could commit itself:
#    the scan reads every tracked `*_scan.sh`, so a pen scan written to disk here would join the
#    live population. Assert that this tree carries exactly one tracked file of this family whose
#    basename ends `_scan.sh`, and that it is the scan under test.
# ---------------------------------------------------------------------------
own=$(git ls-files | grep -c '^tools/fixtures/c/control_in_population.*_scan\.sh$')
leg plant_not_tracked "$own" 1

# ---------------------------------------------------------------------------
# 10. The scan reports rather than gating, so its verdict never refuses a tree. Reading your own
#     family is often correct, and the repaired shape must walk free beside the unrepaired one.
# ---------------------------------------------------------------------------
d=$(build verdict_reports)
cat > "$d/tools/fixtures/p/plain_scan.sh" <<'PEN'
#!/bin/sh
git ls-files
PEN
cat > "$d/tools/fixtures/p/plain_control.sh" <<'PEN'
#!/bin/sh
echo pen control
PEN
( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm 'pen: verdict' >/dev/null 2>&1 )
( cd "$d" && sh tools/fixtures/c/control_in_population_scan.sh >/dev/null 2>&1 )
leg reports_never_refuses "$?" 0
out=$(commit_and_read "$d")
leg verdict_is_reported "$(read_field "$out" verdict)" reported

echo "control_legs=$legs"
echo "control_failed=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
