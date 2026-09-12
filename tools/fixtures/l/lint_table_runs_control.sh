#!/bin/sh
# tools/fixtures/l/lint_table_runs_control.sh -- the pen that proves lint_table_runs_scan.sh.
#
# WHY A PEN. The scan reads two living files and answers a question about a third thing -- what an
# unattended lap will actually run. Every refusal it can make is proven here on files this script
# writes, planted and then lifted, so a refusal shown only in the passing direction can never be
# mistaken for a bypass. The tree's own figures are never asserted here; a pen that pinned them
# would red on ordinary work.
#
#   sh tools/fixtures/l/lint_table_runs_control.sh
#
# Seated `20260912` beside the scan.

set -eu

SCAN="$(cd "$(dirname "$0")/../.." >/dev/null 2>&1 && pwd)/fixtures/l/lint_table_runs_scan.sh"
[ -f "$SCAN" ] || SCAN="${LINT_TABLE_SCAN:-tools/fixtures/l/lint_table_runs_scan.sh}"

PEN=$(mktemp -d "${PWD}/.lap/lint-table-pen.XXXXXX") || { echo "pen_refused"; exit 1; }
trap 'rm -rf "$PEN"' EXIT INT TERM

legs=0
failed=0

leg() { # leg <name> <expected> <actual>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    printf 'leg %-34s ok\n' "$1"
  else
    printf 'leg %-34s FAILED want=%s got=%s\n' "$1" "$2" "$3"
    failed=$((failed + 1))
  fi
}

# ---- the pen's own page and roster -------------------------------------------------------------

write_roster() { # write_roster <file>
  cat > "$1" <<'ROSTER'
# a pen roster, one record per guard.

guard alpha
path tools/a/alpha_witness.rish
tier lap

guard beta
path tools/b/beta_witness.rish
tier cadence

guard gamma
path tools/g/gamma_witness.rish
ROSTER
}

write_page() { # write_page <file> <rows...>  -- rows arrive on stdin
  {
    echo '# a pen page'
    echo
    echo 'Some prose above the section, naming tools/a/alpha_witness.rish so a reader can see'
    echo 'that a path outside the table is never counted.'
    echo
    echo '| Rule | Check | Runs |'
    echo '|------|-------|------|'
    echo '| **A decoy table before the section** | `tools/a/alpha_witness.rish` | by hand |'
    echo
    echo '## What We Check, and When'
    echo
    echo '**Some heading sentence.**'
    echo
    echo '| Rule | Check | Runs |'
    echo '|------|-------|------|'
    cat
    echo
    echo 'Prose after the table.'
    echo
    echo '| Ratchet | Law on touch |'
    echo '|---------|--------------|'
    echo '| **A second table** | never read by this scan |'
  } > "$1"
}

read_key() { # read_key <key> <output>
  printf '%s\n' "$2" | awk -F= -v K="$1" '$1 == K { print $2; exit }'
}

run_scan() { # run_scan <page> <roster> [mode]
  LINT_TABLE_PAGE="$1" LINT_TABLE_ROSTER="$2" sh "$SCAN" "${3:-measure}" 2>&1 || true
}

ROSTER="$PEN/roster.kyri"
write_roster "$ROSTER"

# ---- 1. a clean table, every word kept ----------------------------------------------------------

CLEAN="$PEN/clean.md"
write_page "$CLEAN" <<'ROWS'
| **A rostered lap guard** | `tools/a/alpha_witness.rish` | every lap |
| **A cadence guard** | `tools/b/beta_witness.rish` | on cadence |
| **A guard no roster carries** | `tools/z/zeta_witness.rish` | by hand |
| **A record with no tier line** | `tools/g/gamma_witness.rish` | every lap |
ROWS

out=$(run_scan "$CLEAN" "$ROSTER")
leg clean_verdict ok "$(read_key verdict "$out")"
leg clean_rows 4 "$(read_key rows "$out")"
leg clean_every_lap 2 "$(read_key runs_every_lap "$out")"
leg clean_on_cadence 1 "$(read_key runs_on_cadence "$out")"
leg clean_by_hand 1 "$(read_key runs_by_hand "$out")"
leg clean_disagree 0 "$(read_key disagree "$out")"
leg clean_undeclared 0 "$(read_key undeclared "$out")"
leg clean_unnamed 0 "$(read_key unnamed "$out")"

# The decoy table above the section and the ratchet table below it are both left unread; four rows
# is the whole reading, which `clean_rows` above already proves from both sides.

# ---- 2. a row understating what runs it ---------------------------------------------------------

UNDER="$PEN/understate.md"
write_page "$UNDER" <<'ROWS'
| **A rostered lap guard called a hand tool** | `tools/a/alpha_witness.rish` | by hand |
ROWS
out=$(run_scan "$UNDER" "$ROSTER")
leg understate_verdict red "$(read_key verdict "$out")"
leg understate_disagree 1 "$(read_key disagree "$out")"

# ---- 3. a row overstating what runs it ----------------------------------------------------------

OVER="$PEN/overstate.md"
write_page "$OVER" <<'ROWS'
| **An unrostered guard called a lap wall** | `tools/z/zeta_witness.rish` | every lap |
ROWS
out=$(run_scan "$OVER" "$ROSTER")
leg overstate_verdict red "$(read_key verdict "$out")"
leg overstate_disagree 1 "$(read_key disagree "$out")"

# The same bytes with the word repaired walk free -- the refusal proven from both sides.
sed 's/| every lap |/| by hand |/' "$OVER" > "$OVER.fixed"
out=$(run_scan "$OVER.fixed" "$ROSTER")
leg overstate_lifted ok "$(read_key verdict "$out")"

# ---- 4. a cadence guard may not claim every lap -------------------------------------------------

CAD="$PEN/cadence.md"
write_page "$CAD" <<'ROWS'
| **A cadence guard claiming every lap** | `tools/b/beta_witness.rish` | every lap |
ROWS
out=$(run_scan "$CAD" "$ROSTER")
leg cadence_verdict red "$(read_key verdict "$out")"
leg cadence_disagree 1 "$(read_key disagree "$out")"

# ---- 5. a row carrying no word at all -----------------------------------------------------------

BARE="$PEN/bare.md"
write_page "$BARE" <<'ROWS'
| **A row with two cells only** | `tools/a/alpha_witness.rish` |
ROWS
out=$(run_scan "$BARE" "$ROSTER")
leg bare_verdict red "$(read_key verdict "$out")"
leg bare_undeclared 1 "$(read_key undeclared "$out")"

# ---- 6. a row naming no instrument --------------------------------------------------------------

NONAME="$PEN/noname.md"
write_page "$NONAME" <<'ROWS'
| **A rule held by nothing** | held by nobody yet | every lap |
ROWS
out=$(run_scan "$NONAME" "$ROSTER")
leg unnamed_verdict red "$(read_key verdict "$out")"
leg unnamed_count 1 "$(read_key unnamed "$out")"

# ---- 7. the strongest word among several named tools wins ---------------------------------------

MANY="$PEN/many.md"
write_page "$MANY" <<'ROWS'
| **A scan and the rostered check that drives it** | `tools/z/zeta_witness.rish` driven by `tools/a/alpha_witness.rish` | every lap |
| **A cadence guard beside an unrostered one** | `tools/z/zeta_witness.rish` and `tools/b/beta_witness.rish` | on cadence |
ROWS
out=$(run_scan "$MANY" "$ROSTER")
leg many_verdict ok "$(read_key verdict "$out")"
leg many_every_lap 1 "$(read_key runs_every_lap "$out")"
leg many_on_cadence 1 "$(read_key runs_on_cadence "$out")"

# ---- 8. a row without bold is still counted -----------------------------------------------------

PLAIN="$PEN/plain.md"
write_page "$PLAIN" <<'ROWS'
| A row nobody bolded | `tools/a/alpha_witness.rish` | every lap |
ROWS
out=$(run_scan "$PLAIN" "$ROSTER")
leg plain_rows 1 "$(read_key rows "$out")"
leg plain_verdict ok "$(read_key verdict "$out")"

# ---- 9. refusals: a missing file, and a section with no table -----------------------------------

out=$(run_scan "$PEN/absent.md" "$ROSTER")
leg missing_page_verdict refused "$(read_key verdict "$out")"

out=$(run_scan "$CLEAN" "$PEN/absent-roster.kyri")
leg missing_roster_verdict refused "$(read_key verdict "$out")"

NOTABLE="$PEN/notable.md"
{
  echo '# a pen page'
  echo
  echo '## What We Check, and When'
  echo
  echo 'Prose and no table at all.'
} > "$NOTABLE"
out=$(run_scan "$NOTABLE" "$ROSTER")
leg no_table_verdict refused "$(read_key verdict "$out")"
leg no_table_rows 0 "$(read_key rows "$out")"

# ---- 10. list mode names every row --------------------------------------------------------------

out=$(run_scan "$CLEAN" "$ROSTER" list)
leg list_names_rows 4 "$(printf '%s\n' "$out" | grep -c '^agree	')"
out=$(run_scan "$OVER" "$ROSTER" list)
leg list_names_disagree 1 "$(printf '%s\n' "$out" | grep -c '^disagree	')"

# ---- 11. mutations, each proven to bite ---------------------------------------------------------
#
# A pen that only ever runs the true scan proves the scan passes its own plants. These two run a
# BROKEN copy and assert the pen catches it, so a leg that would go quiet if the rule were deleted
# is shown to be load-bearing.

MUT="$PEN/mutant.sh"

# The tier default: a roster record with no `tier` line is `lap`. Break it to `cadence` and the
# clean table's fourth row stops agreeing.
sed 's/(t == "" ? "lap" : t)/(t == "" ? "cadence" : t)/g' "$SCAN" > "$MUT"
out=$(LINT_TABLE_PAGE="$CLEAN" LINT_TABLE_ROSTER="$ROSTER" sh "$MUT" 2>&1 || true)
leg mutation_tier_default_bites red "$(read_key verdict "$out")"

# The section anchor: drop it and the decoy table above the section is read as the lint surface.
sed 's/index($0, section) == 1 { seen = 1; next }/{ seen = 1 }/' "$SCAN" > "$MUT"
out=$(LINT_TABLE_PAGE="$CLEAN" LINT_TABLE_ROSTER="$ROSTER" sh "$MUT" 2>&1 || true)
leg mutation_section_anchor_bites 1 "$(read_key rows "$out")"

# ---- the tally --------------------------------------------------------------------------------

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
  exit 1
fi
