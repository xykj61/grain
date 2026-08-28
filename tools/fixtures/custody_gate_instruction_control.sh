#!/bin/sh
# tools/fixtures/custody_gate_instruction_control.sh -- prove the custody-gate instruction guard
# from both sides.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every case below
# plants a real instruction file in a temporary pen and reads what the scan says about it. The first
# case is not invented: it is the sentence tools/l/launch-claude-chapter.rish actually printed into
# every pasted Claude loop until 20260828, two days after the card cut that cadence.
#
#   sh tools/fixtures/custody_gate_instruction_control.sh
#
# Driven by tools/cu/custody_gate_instruction_witness.rish. Run from the repository root.

set -u

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

scan="sh tools/fixtures/custody_gate_instruction_scan.sh report"
ok=0
bad=0

report() {
  if [ "$2" = ok ]; then
    echo "case=$1 ok"
    ok=$((ok + 1))
  else
    echo "case=$1 RED -- $3"
    bad=$((bad + 1))
  fi
}

# THE REAL FAULT, verbatim. What the elder launcher printed, on one line, as a seat prompt does.
cat > "$pen/bare.txt" <<'PEN'
say "   ./tools/ag/agent-jail.sh claude -p 'take the next agent-doable lap; only after xy accepts, mirror to debrided, never mirror-first; every fifth round, the lap the rota closes its cycle, also project and force-push the public seed with  bash ~/grain/publish-seed.sh  -- its four gates hold and reds still come first; STOP at the custody gates in ITINERARY. ty every1 baton prin recur'"
PEN
out=$($scan "$pen/bare.txt" 2>&1); rc=$?
case "$out" in *"verdict=bare_gate_instruction"*) [ $rc -eq 4 ] && report bare_bitten ok || report bare_bitten red "exit $rc" ;; *) report bare_bitten red "$out" ;; esac
case "$out" in *"instructs publish-seed.sh with no refusal"*) report offender_named ok ;; *) report offender_named red "detail missing" ;; esac
case "$out" in *"bare_instructions=1"*) report bare_counted ok ;; *) report bare_counted red "count wrong" ;; esac

# THE REPAIR, verbatim. The same line as it stands today.
sed 's#every fifth round, the lap the rota closes its cycle, also project and force-push the public seed with  bash ~/grain/publish-seed.sh  -- its four gates hold and reds still come first#the public seed stays a manual gate -- never run publish-seed.sh from a loop, since custody gate %1 holds every refresh at Keatons own hand#' "$pen/bare.txt" > "$pen/free.txt"
out=$($scan "$pen/free.txt" 2>&1); rc=$?
case "$out" in *"verdict=every_gated_command_is_refused"*) [ $rc -eq 0 ] && report refusal_free ok || report refusal_free red "exit $rc" ;; *) report refusal_free red "$out" ;; esac
case "$out" in *"refusal_framed=1"*) report free_counted ok ;; *) report free_counted red "count wrong" ;; esac

# THE PRECISION CASE. A refusal word standing in a DIFFERENT clause must not free a bare one --
# otherwise any prompt saying "never" anywhere would launder every instruction in the file.
cat > "$pen/scoped.txt" <<'PEN'
never mirror-first, and never force; run bash ~/grain/publish-seed.sh on the fifth lap; a red you cannot close is surfaced.
PEN
out=$($scan "$pen/scoped.txt" 2>&1); rc=$?
case "$out" in *"bare_instructions=1"*) [ $rc -eq 4 ] && report clause_scoped ok || report clause_scoped red "exit $rc" ;; *) report clause_scoped red "a far-off refusal freed a bare instruction" ;; esac

# THE OTHER TWO TOKENS, each planted bare.
echo 'when upstream diverges, run git push --force xy main and carry on' > "$pen/force.txt"
out=$($scan "$pen/force.txt" 2>&1); rc=$?
case "$out" in *"instructs git push --force"*) [ $rc -eq 4 ] && report force_push_bitten ok || report force_push_bitten red "exit $rc" ;; *) report force_push_bitten red "$out" ;; esac

echo 'clean the history with git filter-repo --replace-text and push the result' > "$pen/filter.txt"
out=$($scan "$pen/filter.txt" 2>&1); rc=$?
case "$out" in *"instructs git filter-repo"*) [ $rc -eq 4 ] && report filter_repo_bitten ok || report filter_repo_bitten red "exit $rc" ;; *) report filter_repo_bitten red "$out" ;; esac

# PROSE ABOUT THE ACT IS FREE. A token is a command; an English phrase is not, and a guard that
# could not tell them apart would refuse every honest sentence explaining why the gate exists.
cat > "$pen/prose.txt" <<'PEN'
The maintainer force-pushes the depersonalized seed by hand, and a history rewrite is his word alone.
PEN
out=$($scan "$pen/prose.txt" 2>&1); rc=$?
case "$out" in *"gated_mentions=0"*) [ $rc -eq 0 ] && report prose_free ok || report prose_free red "exit $rc" ;; *) report prose_free red "$out" ;; esac

# AN ORDINARY PROMPT, naming no gated command at all, reads clean rather than empty.
echo 'read the card, take the next lap, grade what you touch, and write the log on its day shelf.' > "$pen/plain.txt"
out=$($scan "$pen/plain.txt" 2>&1); rc=$?
case "$out" in *"verdict=every_gated_command_is_refused"*) [ $rc -eq 0 ] && report plain_clean ok || report plain_clean red "exit $rc" ;; *) report plain_clean red "$out" ;; esac

# AN ABSENT FILE READS DISTINCTLY, rather than as a pass.
out=$($scan "$pen/nowhere.txt" 2>&1); rc=$?
case "$out" in *"verdict=no_such_file"*) [ $rc -eq 1 ] && report absent_told_apart ok || report absent_told_apart red "exit $rc" ;; *) report absent_told_apart red "$out" ;; esac

echo "cases_ok=$ok"
echo "cases_red=$bad"
if [ "$bad" -ne 0 ]; then
  echo "control=RED"
  exit 5
fi
echo "control=ok"
exit 0
