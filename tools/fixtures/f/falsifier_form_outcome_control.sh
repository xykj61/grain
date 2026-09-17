#!/bin/sh
# tools/fixtures/f/falsifier_form_outcome_control.sh -- proves
# tools/fixtures/f/falsifier_form_outcome_scan.sh from both sides on planted pages in
# REAL git repositories, then bites five mutations.
#
# A pen repository is needed rather than a bare directory, and the reason is the
# subject's own shape: the scan composes two borrowed instruments, and both resolve
# the repository root and read `git ls-files` before they answer. So the pen carries
# a real `.git`, a real `active-designing/` room, real copies of both borrowed scans,
# and the roster the reach scan refuses without -- and the legs then prove the
# COMPOSITION rather than a stub of it.
#
# A SHAM leg runs an unmutated copy of the subject from the same pen, so a pen that
# breaks every copy is visible rather than silent.
#
# Exit 0 always. Prints leg=<name> pass|fail lines, a leg tally, and control_verdict.
set -u

MAX_LEGS=128
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
SUBJ="$ROOT/tools/fixtures/f/falsifier_form_outcome_scan.sh"
REACH="$ROOT/tools/fixtures/f/falsifier_reach_scan.sh"
RANK="$ROOT/tools/fixtures/r/rank_outcome_scan.sh"
PEN="$ROOT/.lap/pen-ffo-$$"
legs=0; failed=0

cleanup() { rm -rf "$PEN"; }
trap cleanup EXIT HUP INT TERM

for f in "$SUBJ" "$REACH" "$RANK"; do
  [ -f "$f" ] || { echo "control_verdict=missing_input"; echo "detail: $f"; exit 0; }
done
mkdir -p "$PEN" || { echo "control_verdict=no_pen"; exit 0; }

leg() { # leg <name> <expected> <actual>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "leg=$1 pass"
  else echo "leg=$1 fail expected=$2 actual=$3"; failed=$((failed + 1)); fi
}
key() { grep -m1 "^$2=" "$1" | sed "s/^$2=//"; }

# ---- pen builder --------------------------------------------------------------
# newpen <name> -- a fresh git repository carrying both borrowed scans, the roster
# the reach scan refuses without, and an empty active-designing room.
newpen() {
  d="$PEN/$1"; rm -rf "$d"; mkdir -p "$d/tools/fixtures/f" "$d/tools/fixtures/r" "$d/active-designing"
  cp "$REACH" "$d/tools/fixtures/f/falsifier_reach_scan.sh"
  cp "$RANK"  "$d/tools/fixtures/r/rank_outcome_scan.sh"
  cp "$SUBJ"  "$d/tools/fixtures/f/falsifier_form_outcome_scan.sh"
  : > "$d/tools/fixtures/f/falsifier_field_baseline.txt"
  ( cd "$d" && git init -q . ) || return 1
  echo "$d"
}
pencommit() { ( cd "$1" && git add -A && git -c user.email=p@p -c user.name=p commit -qm pen ); }

# page <file> <rows...> -- each row is `num:falsifier-text:erratum-text`, where an
# empty erratum plants a row nobody has read and the literal word NONE plants a row
# carrying no falsifier at all. The ranking table is written from the same list, since
# the borrowed rank scan emits a verdict only for a row it can rank.
page() {
  f=$1; shift
  {
    echo "# A planted ranked page"
    echo
    for spec in "$@"; do
      n=${spec%%:*}; rest=${spec#*:}; er=${rest#*:}
      [ -n "$er" ] && { echo "**Row $n erratum:** \`20260102.00000$n\` -- $er"; echo; }
    done
    echo "## The rows"
    echo
    for spec in "$@"; do
      n=${spec%%:*}; rest=${spec#*:}; fals=${rest%%:*}
      echo "### $n. Planted row $n"
      echo
      echo "**Claim.** A planted claim for row $n."
      echo
      if [ "$fals" != "NONE" ]; then echo "**Falsifier.** $fals"; echo; fi
    done
    echo "## The ranking"
    echo
    echo "| Rank | Row | Why here |"
    echo "|---|---|---|"
    r=0
    for spec in "$@"; do
      n=${spec%%:*}; r=$((r + 1))
      echo "| $r | $n. Planted row $n | planted |"
    done
    # A CLOSING SECTION carrying its own falsifier, as both real ranked pages do. It
    # sits below every row, so a walk that lets a row run past the next top-level
    # heading hands it to the last row -- which is what the section_end mutation shows.
    echo
    echo "## What would make this page wrong"
    echo
    echo "**Falsifier.** Run \`tools/fixtures/f/pagewide.sh\` and read its verdict."
  } > "$f"
}

run() { # run <pendir> [args...] -> writes $PEN/out
  d=$1; shift
  ( cd "$d" && sh tools/fixtures/f/falsifier_form_outcome_scan.sh "$@" ) > "$PEN/out" 2>&1 || true
  echo "$PEN/out"
}

# ---- 1. the base reading, every class and outcome present ----------------------
d=$(newpen base) || { echo "control_verdict=no_git"; exit 0; }
page "$d/active-designing/20260101-000000_a.md" \
  "1:A condition stated in prose with nothing at all to weigh.:its falsifier cannot fire at all" \
  "2:The count exceeds three widgets in a season.:the falsifier is answered by the lap tag rather than by a race" \
  "3:Run \`tools/fixtures/f/probe.sh\` and read its verdict.:" \
  "4:A plain narrative condition with nothing countable.:"
pencommit "$d"
o=$(run "$d")
leg pages_discovered            1 "$(key "$o" pages_found)"
leg rows_read                   4 "$(key "$o" rows_read)"
leg form_runnable_seen          1 "$(key "$o" form_runnable)"
leg form_quantified_seen        1 "$(key "$o" form_quantified)"
leg form_narrative_seen         2 "$(key "$o" form_narrative)"
leg form_none_zero              0 "$(key "$o" form_none)"
leg wall_clear                  0 "$(key "$o" rows_no_falsifier)"

# ---- 2. the crossing verdict turns on the runnable cell, proven from both sides -
# A runnable row that is GRADED is what lets the crossing speak; the base pen's
# runnable row is unread, so the same tree reads underdetermined until it is read.
leg underdetermined_while_unread underdetermined "$(key "$o" verdict)"
leg runnable_row_present         1 "$(key "$o" rows_runnable)"
leg runnable_cell_still_empty    0 "$(key "$o" rows_runnable_graded)"
d=$(newpen graded)
page "$d/active-designing/20260101-000000_a.md" \
  "1:Run \`tools/fixtures/f/probe.sh\` and read its verdict.:its falsifier cannot fire at all" \
  "2:A plain narrative condition with nothing countable.:the falsifier is answered by the lap tag"
pencommit "$d"
o=$(run "$d")
leg crossed_once_runnable_graded crossed "$(key "$o" verdict)"
leg runnable_cell_filled         1 "$(key "$o" cross_runnable_incapable)"
leg rate_runnable_printed        1.0000 "$(key "$o" rate_runnable)"
leg cells_empty_falls            1 "$(key "$o" form_cells_empty)"

# ---- 3. the wall: a ranked row carrying no falsifier ---------------------------
d=$(newpen nofals)
page "$d/active-designing/20260101-000000_a.md" \
  "1:A plain narrative condition with nothing countable.:" \
  "2:NONE:"
pencommit "$d"
o=$(run "$d")
leg wall_counts_row             1 "$(key "$o" rows_no_falsifier)"
leg wall_refuses                row_without_falsifier "$(key "$o" verdict)"
leg wall_names_form_none        1 "$(key "$o" form_none)"
# ...and lifting the plant returns the same tree to a clear reading.
page "$d/active-designing/20260101-000000_a.md" \
  "1:A plain narrative condition with nothing countable.:" \
  "2:A second plain narrative condition.:"
pencommit "$d"
o=$(run "$d")
leg wall_lifts                  0 "$(key "$o" rows_no_falsifier)"
leg wall_lifts_verdict          underdetermined "$(key "$o" verdict)"

# ---- 4. silent and unread are told apart --------------------------------------
# A row whose erratum says nothing about the falsifier looks identical to an unread
# row from the borrowed rank scan, which emits a line only for a fault it can name.
d=$(newpen silent)
page "$d/active-designing/20260101-000000_a.md" \
  "1:A plain narrative condition with nothing countable.:the row was read and this sentence mentions no verdict word" \
  "2:A second plain narrative condition.:"
pencommit "$d"
o=$(run "$d")
leg silent_counted              1 "$(key "$o" outcome_silent)"
leg unread_counted              1 "$(key "$o" rows_unread)"
leg silent_is_graded            1 "$(key "$o" rows_graded)"

# ---- 5. discovery is by text, never by a list ---------------------------------
d=$(newpen discover)
page "$d/active-designing/20260101-000000_a.md" "1:A plain narrative condition.:"
pencommit "$d"
o=$(run "$d")
leg discovers_one               1 "$(key "$o" pages_found)"
# a second page carrying rows and NO ranking heading stays outside the population
sed '/## The ranking/,$d' "$d/active-designing/20260101-000000_a.md" > "$d/active-designing/20260101-000001_b.md"
pencommit "$d"
o=$(run "$d")
leg unranked_page_read_past     1 "$(key "$o" pages_found)"
# and a shelved page is read past even when it ranks
mkdir -p "$d/active-designing/archive"
cp "$d/active-designing/20260101-000000_a.md" "$d/active-designing/archive/20260101-000002_c.md"
pencommit "$d"
o=$(run "$d")
leg shelved_page_read_past      1 "$(key "$o" pages_found)"

# ---- 6. a borrowed instrument that is absent REFUSES ---------------------------
d=$(newpen noreach)
page "$d/active-designing/20260101-000000_a.md" "1:A plain narrative condition.:"
pencommit "$d"
rm -f "$d/tools/fixtures/f/falsifier_reach_scan.sh"
o=$(run "$d")
leg absent_reach_refuses        no_reach_scan "$(key "$o" verdict)"
d=$(newpen norank)
page "$d/active-designing/20260101-000000_a.md" "1:A plain narrative condition.:"
pencommit "$d"
rm -f "$d/tools/fixtures/r/rank_outcome_scan.sh"
o=$(run "$d")
leg absent_rank_refuses         no_rank_scan "$(key "$o" verdict)"

# ---- 7. the sham, and five mutations ------------------------------------------
mutate() { # mutate <name> <sed-expr> <key> <expected-under-mutation>
  d=$(newpen "mut-$1")
  page "$d/active-designing/20260101-000000_a.md" \
    "1:Run \`tools/fixtures/f/probe.sh\` and read its verdict.:its falsifier cannot fire" \
    "2:A plain narrative condition with nothing countable.:the row was read and this line names no verdict word" \
    "3:NONE:"
  pencommit "$d"
  sed "$2" "$SUBJ" > "$d/tools/fixtures/f/falsifier_form_outcome_scan.sh"
  o=$(run "$d")
  got=$(key "$o" "$3")
  leg "mut_$1" "$4" "$got"
}

# the sham: an unmutated copy in the same pen reads the honest values
d=$(newpen sham)
page "$d/active-designing/20260101-000000_a.md" \
  "1:Run \`tools/fixtures/f/probe.sh\` and read its verdict.:its falsifier cannot fire" \
  "2:A plain narrative condition with nothing countable.:the row was read and this line names no verdict word" \
  "3:NONE:"
pencommit "$d"
o=$(run "$d")
leg sham_form_none              1 "$(key "$o" form_none)"
leg sham_silent                 1 "$(key "$o" outcome_silent)"
leg sham_runnable               1 "$(key "$o" form_runnable)"
leg sham_verdict                row_without_falsifier "$(key "$o" verdict)"

# MUTATION 1 -- drop the erratum table. A silent row then reads unread, which is the
# exact conflation this scan was widened to remove.
mutate erratum_table 's|FILENAME == ARGV\[3\] { erratum.*|FILENAME == ARGV[3] { next }|' outcome_silent 0
# MUTATION 2 -- let a row section run past the next top-level heading. The ranking
# table below the rows is then inside the last row, and its `tools/` free text is not
# the point: the row count itself collapses.
mutate section_end 's|/\^## / { if (num != "")|/^ZZNEVERZZ/ { if (num != "")|' form_none 0
# MUTATION 3 -- drop the row-range test so any region on the page matches any row.
mutate range_test 's|if (a\[1\] == path \&\& a\[2\]+0 >= s+0 \&\& a\[2\]+0 <= e+0)|if (a[1] == path)|' form_none 0
# MUTATION 4 -- print a rate over an empty denominator rather than `none`.
mutate empty_rate 's|if (g == 0) { empty++; printf "rate_%s=none\\n", c }|if (g == 0) { empty++; printf "rate_%s=%.4f\\n", c, 0 }|' rate_quantified 0.0000
# MUTATION 5 -- drop the wall, so a row with no falsifier ships silently.
mutate wall 's|^if \[ "\$rows_no_falsifier" -ne 0 \]; then|if false; then|' verdict crossed

echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$legs" -le "$MAX_LEGS" ] || { echo "control_verdict=over_leg_bound"; exit 0; }
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=legs_failed"; fi
