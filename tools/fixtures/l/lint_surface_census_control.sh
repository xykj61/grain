#!/bin/sh
# tools/fixtures/l/lint_surface_census_control.sh -- prove the lint-surface census on planted tables.
#
# Every reading is shown from BOTH sides: planted and then lifted. A refusal proven only in the
# passing direction cannot be told from a bypass, and a state proven only by its presence cannot be
# told from a reader that always says yes.
#
# The pen holds two files -- a guide carrying a checkable lint table, and a roster carrying `path`
# rows -- handed in by LINT_SURFACE_GUIDE and LINT_SURFACE_ROSTER, so the scan needs no tree root.
# Disk presence of a cited tool is asked of the LIVE tree, which is why the missing-tool legs cite a
# name no tree carries rather than planting a file.
#
#   sh tools/fixtures/l/lint_surface_census_control.sh

set -u
LC_ALL=C
export LC_ALL

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_c_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/.git" ]; do
  _c_steps=$((_c_steps + 1))
  if [ "$_c_steps" -gt 8 ] || [ "$ROOT" = "/" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/l/lint_surface_census_scan.sh"

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

check() { # check <name> <expected> <actual>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $1 ok"
  else
    echo "leg $1 FAILED expected=$2 actual=$3"
    failed=$((failed + 1))
  fi
}

run() { # run -> prints scan output; cd to ROOT so the live tree answers disk presence
  ( cd "$ROOT" && LINT_SURFACE_GUIDE="$pen/guide.md" LINT_SURFACE_ROSTER="$pen/roster.kyri" \
      LINT_SURFACE_UNHELD_CEILING="${CEIL:-9}" sh "$SCAN" ) > "$pen/out.txt" 2>&1
  echo $? > "$pen/rc.txt"
}
val() { sed -n "s/^$1=//p" "$pen/out.txt"; }
rc() { cat "$pen/rc.txt"; }

# Two real tools, so a rostered row can be proven without inventing a file that does not exist.
REAL_A=tools/w/width-check.rish
REAL_B=tools/r/radiant_lint.rish

write_roster() { # write_roster <path>...
  : > "$pen/roster.kyri"
  for p in "$@"; do printf 'guard x\npath %s\n\n' "$p" >> "$pen/roster.kyri"; done
}

write_guide() { # write_guide <body-lines-file>
  {
    echo "# Guide"
    echo
    echo "**Enforced now -- textual checks in Rishi**:"
    echo
    echo "| Rule | Check |"
    echo "|------|-------|"
    cat "$1"
    echo
    echo "**What actually holds these rows.**"
  } > "$pen/guide.md"
}

# ---- 1. A rostered row reads held -------------------------------------------------------------
printf '| **Alpha** | `%s` (live) |\n' "$REAL_A" > "$pen/body.txt"
write_guide "$pen/body.txt"; write_roster "$REAL_A"; run
check rostered_rows "1" "$(val rows)"
check rostered_tools_named "1" "$(val tools_named)"
check rostered_tools_rostered "1" "$(val tools_rostered)"
check rostered_rows_held "1" "$(val rows_held)"
check rostered_rows_unheld "0" "$(val rows_unheld)"
check rostered_unreached "0" "$(val tools_unreached)"
check rostered_verdict "ok" "$(val verdict)"
check rostered_rc "0" "$(rc)"

# ---- 2. THE SAME ROW, ROSTER LIFTED, reads unreached -------------------------------------------
# The other side of leg 1: only the roster moved, so a reader that always says held is caught here.
write_roster "$REAL_B"; run
check lifted_rows_held "0" "$(val rows_held)"
check lifted_rows_unheld "1" "$(val rows_unheld)"
check lifted_unreached "1" "$(val tools_unreached)"
check lifted_unreached_named "  unreached $REAL_A" "$(grep '^  unreached' "$pen/out.txt")"
check lifted_verdict "ok" "$(val verdict)"

# ---- 3. DRIVEN -- an unrostered tool sharing a row with a rostered one --------------------------
printf '| **Beta** | `%s`, driven by `%s` |\n' "$REAL_B" "$REAL_A" > "$pen/body.txt"
write_guide "$pen/body.txt"; write_roster "$REAL_A"; run
check driven_tools_named "2" "$(val tools_named)"
check driven_tools_rostered "1" "$(val tools_rostered)"
check driven_tools_driven "1" "$(val tools_driven)"
check driven_unreached "0" "$(val tools_unreached)"
check driven_rows_held "1" "$(val rows_held)"
check driven_verdict "ok" "$(val verdict)"

# ---- 4. THE SAME PAIR IN TWO ROWS is NOT driven -------------------------------------------------
# The discrimination that makes `driven` mean anything: sharing a row is the claim, and a tool
# merely present elsewhere in the table is reached by nobody. Split leg 3's row in two and the
# same two tools, same roster, must read one unreached.
{ printf '| **Beta** | `%s` |\n' "$REAL_B"; printf '| **Gamma** | `%s` |\n' "$REAL_A"; } > "$pen/body.txt"
write_guide "$pen/body.txt"; write_roster "$REAL_A"; run
check split_rows "2" "$(val rows)"
check split_tools_driven "0" "$(val tools_driven)"
check split_unreached "1" "$(val tools_unreached)"
check split_rows_held "1" "$(val rows_held)"
check split_rows_unheld "1" "$(val rows_unheld)"

# ---- 5. tools_missing is a WALL at zero ---------------------------------------------------------
printf '| **Delta** | `tools/zz/no_such_guard_here.rish` |\n' > "$pen/body.txt"
write_guide "$pen/body.txt"; write_roster "$REAL_A"; run
check missing_count "1" "$(val tools_missing)"
check missing_verdict "tool_missing" "$(val verdict)"
check missing_rc "1" "$(rc)"
check missing_named "  missing tools/zz/no_such_guard_here.rish" "$(grep '^  missing' "$pen/out.txt")"

# ---- 6. THE SAME TABLE with a real tool passes free ---------------------------------------------
printf '| **Delta** | `%s` |\n' "$REAL_A" > "$pen/body.txt"
write_guide "$pen/body.txt"; run
check present_missing "0" "$(val tools_missing)"
check present_verdict "ok" "$(val verdict)"
check present_rc "0" "$(rc)"

# ---- 7. THE RATCHET, proven from both sides at the same ceiling ---------------------------------
{ printf '| **One** | `%s` |\n' "$REAL_B"; printf '| **Two** | `%s` |\n' "$REAL_B"; } > "$pen/body.txt"
write_guide "$pen/body.txt"; write_roster "$REAL_A"
CEIL=2 run; check ceil_at_bound_verdict "ok" "$(val verdict)"
check ceil_at_bound_rc "0" "$(rc)"
CEIL=1 run; check ceil_over_verdict "unheld_over_ceiling" "$(val verdict)"
check ceil_over_rc "1" "$(rc)"
check ceil_over_unheld "2" "$(val rows_unheld)"
unset CEIL

# ---- 8. A BROKEN READER REFUSES rather than reading clean ----------------------------------------
# Three ways the instrument can lose its subject; each must be told apart from a healthy table.
printf '| **Alpha** | `%s` |\n' "$REAL_A" > "$pen/body.txt"
write_guide "$pen/body.txt"; write_roster "$REAL_A"

mv "$pen/guide.md" "$pen/guide.away"; run
check no_guide_verdict "guide_absent" "$(val verdict)"
check no_guide_rc "1" "$(rc)"
mv "$pen/guide.away" "$pen/guide.md"

mv "$pen/roster.kyri" "$pen/roster.away"; run
check no_roster_verdict "roster_absent" "$(val verdict)"
check no_roster_rc "1" "$(rc)"
mv "$pen/roster.away" "$pen/roster.kyri"

{ echo "# Guide"; echo; echo "no table here at all"; } > "$pen/guide.md"; run
check no_table_verdict "table_unread" "$(val verdict)"
check no_table_rc "1" "$(rc)"
check no_table_rows "0" "$(val rows)"

# ---- 9. THE BLANK LINE BETWEEN HEADING AND TABLE does not end the walk ---------------------------
# The bound that took a try to get right: the heading is followed by a blank line, so a walk ending
# at the FIRST blank would read every table as empty and call the tree clean.
printf '| **Alpha** | `%s` |\n' "$REAL_A" > "$pen/body.txt"
write_guide "$pen/body.txt"; write_roster "$REAL_A"; run
check blank_line_rows "1" "$(val rows)"

# ---- 10. THE TABLE ENDS at its own blank line ----------------------------------------------------
# A second table further down the page must not be counted into the first.
{
  echo "# Guide"; echo
  echo "**Enforced now**:"; echo
  echo "| Rule | Check |"; echo "|---|---|"
  printf '| **Alpha** | `%s` |\n' "$REAL_A"
  echo
  echo "**Ratchet advisories**:"; echo
  echo "| Rule | Check |"; echo "|---|---|"
  printf '| **Later** | `%s` |\n' "$REAL_B"
} > "$pen/guide.md"
run
check second_table_rows "1" "$(val rows)"
check second_table_tools "1" "$(val tools_named)"

echo "legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; exit 1; fi
