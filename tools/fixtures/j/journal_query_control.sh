#!/bin/sh
# tools/fixtures/j/journal_query_control.sh -- prove the query census on planted sources.
#
# WHY A CONTROL. `journal_query_census.sh` answers one load-bearing question -- does this tree ask
# field predicates of its journal -- and it answers `class_field=0`. A zero is the easiest reading
# in the world to produce by accident: a regex that matches nothing gives the same answer as a tree
# that queries nothing. So every class is planted here and watched to appear, and the field class is
# planted TWICE -- once where the line reading catches it, once where only the file-level bound does
# -- because the gap between those two is the census's whole honesty.
#
# HOW. A pen holds shell sources this census reads instead of `tools/`, through JOURNAL_QUERY_PEN.
# Nothing here touches the tree.

set -eu

root=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$root"

census=tools/fixtures/j/journal_query_census.sh
pen=$(mktemp -d 2>/dev/null || { d=/tmp/jqc.$$; mkdir -p "$d"; echo "$d"; })
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

# `check <name> <expected-line>` runs the census over the pen and asserts one printed reading.
check() {
  _name=$1; _want=$2
  if JOURNAL_QUERY_PEN="$pen/src" sh "$census" 2>/dev/null | grep -qx "$_want"; then
    pass=$(( pass + 1 )); echo "  ok   $_name -- $_want"
  else
    fail=$(( fail + 1 )); echo "  FAIL $_name -- expected $_want"
    JOURNAL_QUERY_PEN="$pen/src" sh "$census" 2>&1 | sed 's/^/       /'
  fi
}

fresh() { rm -rf "$pen/src"; mkdir -p "$pen/src"; }
plant() { printf '%s\n' "$2" > "$pen/src/$1"; }

echo "journal_query_control -- planting each class and watching the reading move"

# --- the empty pen: a census over nothing says so, rather than inventing a verdict --------------
fresh
plant quiet.sh 'echo "this source names no room at all"'
check empty-pen-no-sites     'query_sites=0'
check empty-pen-verdict      'verdict=no_queries'

# --- one class at a time, each shown to appear where nothing was ---------------------------------
fresh; plant a.sh 'find . | grep -v session-logs/'
check exclude-seen           'class_exclude=1'
check exclude-is-not-a-query 'querying_sites=0'

fresh; plant a.sh 'mkdir -p "$pen/session-logs/date/20260101"'
check construct-seen         'class_construct=1'

fresh; plant a.sh 'echo "refused: session-logs holds nothing" >&2'
check message-seen           'class_message=1'

fresh; plant a.sh 'ENFORCE="session-logs counsel active-designing waymarks"'
check roster-seen            'class_roster=1'

fresh; plant a.sh 'sort -r session-logs/date/x | head -3'
check recency-seen           'class_recency=1'

fresh; plant a.sh 'cat session-logs/date/20260101/20260101-010101_a.kyri'
check by_path-seen           'class_by_path=1'

fresh; plant a.sh 'wc -c < session-logs/README.md'
check index-seen             'class_index=1'

fresh; plant a.sh 'git ls-files "session-logs/*.kyri" > list'
check enumerate-seen         'class_enumerate=1'

fresh; plant a.sh '[ -d session-logs/date ] || exit 1'
check exists-seen            'class_exists=1'

fresh; plant a.sh 'test "$(cat .claude/rules/session-logs.md)" != ""'
check rule-seen              'class_rule=1'
check rule-is-not-a-query    'querying_sites=0'

# --- the field class, planted where the LINE reading can see it -----------------------------------
#
# This is the reading the tree gives zero for, so it is proven from both sides: planted, the class
# is 1 and the verdict flips; removed, both fall back. A refusal proven only in the passing
# direction cannot be told from a bypass.
fresh; plant a.sh 'grep -l "^voice Kyri" session-logs/date/*/*.kyri'
check field-seen             'class_field=1'
check field-flips-verdict    'verdict=indexed_room'

fresh; plant a.sh 'git ls-files "session-logs/*.kyri" > list'
check field-absent-again     'class_field=0'
check verdict-falls-back     'verdict=sorted_room'

# --- the field class, planted where ONLY the file-level bound can see it ---------------------------
#
# The shape of the tree's one real field query: the room is named at the top, the field predicate
# runs many lines later inside a loop. The line reading must MISS this and the bound must CATCH it;
# a census where both answer the same is a census whose bound proves nothing.
fresh
cat > "$pen/src/spread.sh" <<'PEN'
git ls-files 'session-logs/date/*/*.kyri' > /tmp/logs
while read -r f; do
  : one
  : two
  : three
  : four
  : five
  : six
  if grep -q '^rota ' "$f"; then echo "$f"; fi
done < /tmp/logs
PEN
check spread-missed-by-line  'class_field=0'
check spread-caught-by-file  'field_capable_files=1'
check spread-flips-verdict   'verdict=indexed_room'

# --- the bound is proven from the other side too ---------------------------------------------------
fresh; plant a.sh 'git ls-files "session-logs/*.kyri" > list'
check bound-clear            'field_capable_files=0'

# --- the room is a parameter, so the census is not welded to one room ------------------------------
fresh; plant a.sh 'find counsel/date -type f'
if JOURNAL_QUERY_PEN="$pen/src" JOURNAL_QUERY_ROOM=counsel sh "$census" 2>/dev/null | grep -qx 'class_enumerate=1'; then
  pass=$(( pass + 1 )); echo "  ok   room-parameter -- counsel reads as its own room"
else
  fail=$(( fail + 1 )); echo "  FAIL room-parameter"
fi

# --- refusals -------------------------------------------------------------------------------------
if JOURNAL_QUERY_PEN="$pen/nowhere" sh "$census" 2>&1 | grep -q 'refused: JOURNAL_QUERY_PEN names no directory'; then
  pass=$(( pass + 1 )); echo "  ok   refuse-absent-pen"
else
  fail=$(( fail + 1 )); echo "  FAIL refuse-absent-pen"
fi

fresh; plant a.sh 'find session-logs -type f'
if JOURNAL_QUERY_PEN="$pen/src" JOURNAL_QUERY_MAX=0 sh "$census" 2>&1 | grep -q 'above the named ceiling'; then
  pass=$(( pass + 1 )); echo "  ok   refuse-over-ceiling"
else
  fail=$(( fail + 1 )); echo "  FAIL refuse-over-ceiling"
fi

# --- a comment naming the room is not a site ---------------------------------------------------------
#
# The census strips lead-mark comments. This is the plant that would have gone unnoticed: a file
# whose only mention of the room sits in its own header prose.
fresh; plant a.sh '# session-logs is discussed here and never read'
check comment-is-not-a-site  'query_sites=0'

# --- the instrument steps out of its own frame, proven from BOTH sides over the REAL tree ----------
#
# WHY OVER THE TREE RATHER THAN A PEN. The exclusion is two literal path equalities, hard-coded on
# purpose: an env-var list would be a door anybody could point anywhere, and a wall with a door
# beside it is a habit again. That means a pen cannot hold a file at either path, so the proof runs
# where those paths exist. It is still both-sided, and the first leg carries the load: it shows the
# two files WOULD have counted, so the absence below is an exclusion rather than a coincidence.

would_count=0
for f in tools/fixtures/j/journal_query_census.sh tools/fixtures/j/journal_query_control.sh; do
  if grep -q 'session-logs' "$f" && grep -qE "\\^(voice|stamp|status|scope|rota|format)[ '\"/\\\\]" "$f"; then
    would_count=$(( would_count + 1 ))
  fi
done
if [ "$would_count" -eq 2 ]; then
  pass=$(( pass + 1 )); echo "  ok   self-would-have-counted -- both name the room and carry a field anchor"
else
  fail=$(( fail + 1 )); echo "  FAIL self-would-have-counted -- expected 2, read $would_count"
fi

real=$(sh "$census" 2>/dev/null)
if printf '%s\n' "$real" | grep -qx 'self_excluded_sources=2'; then
  pass=$(( pass + 1 )); echo "  ok   self-excluded-counted -- self_excluded_sources=2"
else
  fail=$(( fail + 1 )); echo "  FAIL self-excluded-counted -- expected self_excluded_sources=2"
fi

if printf '%s\n' "$real" | grep -q '^field_capable=tools/fixtures/j/journal_query'; then
  fail=$(( fail + 1 )); echo "  FAIL self-absent-from-capable -- the instrument counted itself"
else
  pass=$(( pass + 1 )); echo "  ok   self-absent-from-capable -- neither self file is field-capable"
fi

if printf '%s\n' "$real" | grep -q '^field_site=tools/fixtures/j/journal_query'; then
  fail=$(( fail + 1 )); echo "  FAIL self-absent-from-field-sites -- the planted literal counted as a query"
else
  pass=$(( pass + 1 )); echo "  ok   self-absent-from-field-sites -- the planted literal is not a query"
fi

# The pen still prints the reading, and prints it as ZERO, so a pen never silently inherits the
# tree's exclusion count -- the same number meaning two different things is how a reading goes wrong.
fresh; plant a.sh 'find session-logs -type f'
check pen-excludes-nothing   'self_excluded_sources=0'

echo "journal_query_control: pass=$pass fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=faulted"; fi
[ "$fail" -eq 0 ]
