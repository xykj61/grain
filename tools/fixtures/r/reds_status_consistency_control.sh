#!/bin/sh
# tools/fixtures/r/reds_status_consistency_control.sh -- the pen that proves
# tools/fixtures/r/reds_status_consistency_scan.sh bites what it claims and frees what it claims.
#
# WHY A PEN. A gate proven only in the passing direction cannot be told from a bypass. So every
# refusal here is planted and then removed, and every welcome is asserted as hard as every refusal
# -- an over-eager reading that refused ordinary rows would make reds-first impossible, which is a
# worse failure than the one the scan was written for.
#
# Thirty-four cases on planted markdown in a throwaway directory -- the count this file's own
# `cases_ok=` line prints, rather than a number recited beside it, which is how the elder
# twenty-nine outlived three additions. The pen is handed to the scan through
# REDS_SPINE_GLOB, which tools/fixtures/r/reds_spine_files.sh honors, so the living ledger is never
# read here and never written.
#
#   sh tools/fixtures/r/reds_status_consistency_control.sh
#
# Exit 0 when every case agrees. Purely local: it writes markdown into a temporary directory and
# removes it.
set -eu

SCAN=tools/fixtures/r/reds_status_consistency_scan.sh
PEN=$(mktemp -d "${TMPDIR:-/tmp}/reds_status_pen.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

ok=0
red=0
say() {
  # A case prints its own name, so a red names itself in the witness's output rather than a line.
  if [ "$2" = "ok" ]; then ok=$((ok + 1)); else red=$((red + 1)); fi
  echo "case=$1 $2"
}
check() {
  # check <name> <expected-substring> ; reads $OUT
  if printf '%s\n' "$OUT" | grep -q -- "$2"; then say "$1" ok; else say "$1" RED; fi
}
run_pen() {
  set +e
  OUT=$(REDS_SPINE_GLOB="$PEN/*.md" sh "$SCAN" 2>&1)
  CODE=$?
  set -e
}

fresh_pen() {
  # Every case starts from an empty pen. A file left by the case before is a second ledger the
  # scan would read, which is how this control first lied to itself about its own table-row case.
  rm -f "$PEN"/*.md
}

row() {
  # row <file> <number> <tail> -- one prose row in the ledger's own shape.
  printf '**REDS %%%s (`20260828.000000`) -- a planted row.** %s\n\n' "$2" "$3" >> "$PEN/$1"
}

# ---- the fault itself: a row marked OPEN that another row says it closed -------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'Nothing to see. **OPEN** -- the work stands.'
row a.md 42 'The repair landed. **CLOSED**, and `%41`{s open clause closes with it.'
run_pen
[ "$CODE" -eq 1 ] && say contradiction_bitten ok || say contradiction_bitten RED
check contradiction_named 'contradicted -- %41 reads \*\*OPEN\*\* while %42'
check contradiction_counted 'contradicted_rows=1'
check contradiction_verdict 'verdict=ledger_contradicts_itself'

# ---- the same pair, repaired: the closed row now reads CLOSED ------------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'The guard stands. **CLOSED** -- closed by `%42`.'
row a.md 42 'The repair landed. **CLOSED**, and `%41`{s open clause closes with it.'
run_pen
[ "$CODE" -eq 0 ] && say repair_free ok || say repair_free RED
check repair_counted 'contradicted_rows=0'
check repair_verdict 'verdict=every_status_agrees'

# ---- an open row nobody claims to close: the ordinary case, and it must stay free ----------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'The work stands. **OPEN** -- the ratchet is Sound{s.'
row a.md 42 'A different lesson entirely, naming no row.'
run_pen
[ "$CODE" -eq 0 ] && say open_alone_free ok || say open_alone_free RED
check open_counted 'open_rows=1'

# ---- a kin mention with no closing word nearby: free ---------------------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'The work stands. **OPEN** -- the ratchet is Sound{s.'
row a.md 42 'This is `%41` one layer down, the same shape at a different depth.'
run_pen
[ "$CODE" -eq 0 ] && say kin_mention_free ok || say kin_mention_free RED

# ---- a closing word beyond the window: free, which proves the window is real ----------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'The work stands. **OPEN** -- the ratchet is Sound{s.'
row a.md 42 "Naming \`%41\` here, and then a long stretch of ordinary prose that carries the reading well past the window before anything is closed: $(printf 'x%.0s' $(seq 1 90)) closed."
run_pen
[ "$CODE" -eq 0 ] && say window_scoped ok || say window_scoped RED

# ---- a row closing itself: the ordinary shape, and it must stay free ------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'Booked and closed the same day, so `%41` needs no marker at all.'
run_pen
[ "$CODE" -eq 0 ] && say self_reference_free ok || say self_reference_free RED

# ---- a closure phrase naming a row the spine does not hold ---------------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'The repair landed. **CLOSED**, and `%77`{s open clause closes with it.'
run_pen
[ "$CODE" -eq 1 ] && say phantom_bitten ok || say phantom_bitten RED
check phantom_named 'phantom_closure -- %41 names %77'
check phantom_counted 'phantom_closures=1'

# ---- a markerless pointer line must never erase a status ------------------------------------
fresh_pen
: > "$PEN/a.md"
: > "$PEN/b.md"
row a.md 41 'The repair landed. **CLOSED** -- the guard is rostered.'
row b.md 41 'A pointer to the row above, folded onto another shelf.'
run_pen
check duplicate_keeps_status 'closed_rows=1'
check duplicate_counted 'duplicate_row_lines=1'

# ---- an elder table row is not a prose row ---------------------------------------------------
fresh_pen
: > "$PEN/a.md"
printf '| 41 | an elder table row | **OPEN** |\n\n' >> "$PEN/a.md"
row a.md 42 'The repair landed. **CLOSED**, and `%41`{s open clause closes with it.'
run_pen
check table_row_not_prose 'phantom_closures=1'

# ---- the highest row is read, so the witness has an edge to bind to --------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 7 'One row.'
row a.md 312 'Another row, higher.'
run_pen
check highest_row_read 'highest_row=312'

# ---- a ledger with no markers at all reads clean ---------------------------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'A lesson, booked and repaired in one lap.'
row a.md 42 'Another lesson, the same.'
run_pen
[ "$CODE" -eq 0 ] && say unmarked_free ok || say unmarked_free RED
check unmarked_counted 'open_rows=0'

# ---- the ledger writes eight spellings of the two words, so the reading must know them ---------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'The work stands. **OPEN, gated** -- one tree per star is Keaton{s word.'
row a.md 42 'The repair landed. **CLOSED.** and `%41`{s open clause closes with it.'
run_pen
[ "$CODE" -eq 1 ] && say spelling_open_gated ok || say spelling_open_gated RED
check spelling_open_counted 'open_rows=1'
check spelling_closed_period 'closed_rows=1'

fresh_pen
: > "$PEN/a.md"
row a.md 41 'Bold across a whole sentence. **CLOSED the same round, and the diagnosis moved the fix into the module.**'
run_pen
check spelling_closed_sentence 'closed_rows=1'

# ---- a row that reopens then closes reads by its LAST marker ------------------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'It stood **OPEN** -- nothing read it. **CLOSED** -- the guard is rostered now.'
run_pen
check last_marker_wins 'closed_rows=1'
check last_marker_not_open 'open_rows=0'

# ---- fold_blocked: a MARKERLESS row carrying the word the fold tool refuses ---------------------
# Door B moved this reading in commit 344e349b2: the fold tool reads the marker first, so a MARKED
# row carrying the bare word OPEN in its prose folds fine, and only a markerless one is still
# refused at row_open. That commit edited the scan's awk block and left these cases asserting the
# elder reading, so `fold_blocked_counted` and `fold_blocked_named` stood RED from door B until
# 20260829 and the whole guard was off -- docs-implementation-sync one layer over, since a control
# is a guard's proof and a stale proof turns the guard off rather than merely dating it.
fresh_pen
: > "$PEN/a.md"
row a.md 41 'It stood OPEN for a day, and nobody marked it either way.'
run_pen
[ "$CODE" -eq 0 ] && say fold_blocked_ungated ok || say fold_blocked_ungated RED
check fold_blocked_counted 'fold_blocked_rows=1'
check fold_blocked_named 'fold_blocked %41'

# ---- and the same bare word under a MARKER folds free, which is door B itself -------------------
# The pair is the point: a refusal proven only in the biting direction cannot be told from a guard
# that refuses everything, and this is the exact row the elder cases planted while expecting a hit.
fresh_pen
: > "$PEN/a.md"
row a.md 41 'It stood OPEN for a day. **CLOSED** -- the guard is rostered now.'
run_pen
check fold_blocked_marked_free 'fold_blocked_rows=0'
check fold_blocked_marked_closed 'closed_rows=1'

# ---- and prose about an opening is not that word --------------------------------------------------
fresh_pen
: > "$PEN/a.md"
row a.md 41 'The opening line was wrong, and OPENING a second door made it worse. **CLOSED** -- repaired.'
run_pen
check fold_blocked_whole_word 'fold_blocked_rows=0'

# ---- an empty spine exits differently from a passing run --------------------------------------
set +e
OUT=$(REDS_SPINE_GLOB="$PEN/nothing-here-*.md" sh "$SCAN" 2>&1)
CODE=$?
set -e
[ "$CODE" -eq 2 ] && say empty_spine_misuse ok || say empty_spine_misuse RED

echo "cases_ok=${ok}"
echo "cases_red=${red}"
if [ "$red" -eq 0 ]; then echo "control=ok"; else echo "control=red"; exit 1; fi
