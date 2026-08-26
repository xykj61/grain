#!/bin/sh
# tools/fixtures/loop_prompt_parse_control.sh -- prove the printed-command guard from both sides.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every case below
# plants a real printout in a temporary pen and reads what the scan says about it.
#
#   sh tools/fixtures/loop_prompt_parse_control.sh
#
# Driven by tools/l/loop_prompt_parse_witness.rish. Run from the repository root.

set -u

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

scan="sh tools/fixtures/loop_prompt_parse_scan.sh report"
ok=0
bad=0

report() {
  if [ "$2" = ok ]; then
    echo "case=$1 ok"
    ok=$((ok + 1))
  else
    echo "case=$1 RED"
    bad=$((bad + 1))
  fi
}

# A clean printout: narration, then one runnable line whose apostrophe is correctly doubled.
cat > "$pen/clean.txt" <<'PEN'
4) Most durable -- one lap, driven by the repo's own memory:

   ./tools/ag/agent-jail.sh --dangerously-skip-permissions claude -p 'read the card (the live one) and don''t be too smart about it'
PEN
out=$($scan "$pen/clean.txt" 2>&1); rc=$?
case "$out" in *"verdict=every_printed_line_parses"*) [ $rc -eq 0 ] && report clean_free ok || report clean_free red ;; *) report clean_free red ;; esac
case "$out" in *"runnable_lines=1"*) report narration_unmeasured ok ;; *) report narration_unmeasured red ;; esac

# The real fault, planted: one apostrophe left single, so a later parenthesis falls out of quoting.
sed "s/don''t/don't/" "$pen/clean.txt" > "$pen/lone.txt"
out=$($scan "$pen/lone.txt" 2>&1); rc=$?
case "$out" in *"verdict=printed_line_does_not_parse"*) [ $rc -eq 4 ] && report lone_apostrophe_bitten ok || report lone_apostrophe_bitten red ;; *) report lone_apostrophe_bitten red ;; esac
case "$out" in *"printed line 3 does not parse"*) report offender_named ok ;; *) report offender_named red ;; esac

# Prose apostrophes outside any runnable line stay correct English and are never a defect.
cat > "$pen/prose.txt" <<'PEN'
   the linker's own search path is what to ask, rather than a guess.
   Copy the repo's card; don't retype it.

   ./tools/ag/agent-jail.sh --dangerously-skip-permissions claude -p 'plain'
PEN
out=$($scan "$pen/prose.txt" 2>&1)
case "$out" in *"verdict=every_printed_line_parses"*) report prose_apostrophe_free ok ;; *) report prose_apostrophe_free red ;; esac

# The outer loop's own opening assignment is measured too, not only the jail elder. The plant is
# a byte-faithful copy of what tools/l/launch-claude-chapter.rish actually prints, so it moves
# when the recipe moves -- a fixture that has drifted from its subject measures a line nobody
# runs. The unbalanced `do echo (` at the end is the deliberate break this case asks about.
cat > "$pen/loop.txt" <<'PEN'
   D=$(TZ=America/New_York date -d 'tomorrow 15:00' +%s 2>/dev/null || TZ=America/New_York date -v+1d -v15H -v0M -v0S +%s); while [ $(date +%s) -lt $D ]; do echo (
PEN
out=$($scan "$pen/loop.txt" 2>&1); rc=$?
case "$out" in *"verdict=printed_line_does_not_parse"*) [ $rc -eq 4 ] && report outer_loop_measured ok || report outer_loop_measured red ;; *) report outer_loop_measured red ;; esac

# A printout carrying no runnable command has stopped being a recipe, and says so distinctly.
printf 'just prose, nothing to run.\n' > "$pen/empty.txt"
out=$($scan "$pen/empty.txt" 2>&1); rc=$?
case "$out" in *"verdict=no_runnable_lines"*) [ $rc -eq 3 ] && report empty_told_apart ok || report empty_told_apart red ;; *) report empty_told_apart red ;; esac

# An absent printout is refused apart from a failing one.
out=$($scan "$pen/nowhere.txt" 2>&1); rc=$?
case "$out" in *"verdict=no_printout"*) [ $rc -eq 1 ] && report absent_told_apart ok || report absent_told_apart red ;; *) report absent_told_apart red ;; esac

echo "cases_ok=$ok cases_red=$bad"
if [ "$bad" -eq 0 ]; then echo "control=ok"; else echo "control=RED"; exit 1; fi
