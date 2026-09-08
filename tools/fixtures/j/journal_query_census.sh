#!/bin/sh
# tools/fixtures/j/journal_query_census.sh -- what does this tree actually ASK of its journal.
#
# WHY. `external-research/20260907-191657_two-shapes-one-notation.md` measured the DATA the tree
# keeps and recommended an index over content-addressed records. It named its own second falsifier
# in plain words: count the queries the tree's own tools ask of the journal, and if nearly every
# tool asks the newest N records while nearly none asks a field predicate, then a sorted room is
# worth more than an index and the plan shrinks to that. This census is that count. A store is
# fitted to a shape AND to a workload, and the prior lap measured only the first half.
#
# THE UNIT, and why it is a LINE rather than a tool. A tool may touch the journal five times for
# five different reasons -- skip it in one sweep, enumerate it in another, open one named log in a
# third. Counting tools would bin all five under whichever reason the reader noticed first. So the
# unit is a QUERY SITE: one non-comment line in a tracked, executable tool source that names the
# journal room and does something with it.
#
# TWO FAMILIES, AND THAT SPLIT IS THE FIRST FINDING. Most lines naming the journal never read a
# record at all -- they skip the room in a sweep, build a pen directory under it, quote its name in
# a refusal message, or list it beside its sibling rooms. Counting those as queries would inflate
# the workload fourfold. So each site lands in a NON-QUERY class or a QUERY class, first match wins,
# in the order below, because a line can honestly wear two hats and the earlier reading is the
# stronger claim about what the line is FOR:
#
#   NON-QUERY
#   exclude    -- the room is named only to be skipped: `grep -v`, `! -path`, `:(exclude`.
#   construct  -- a pen or path is BUILT under the room: `mkdir`, a path join, a create redirect.
#   message    -- the room's name sits inside a human sentence: an echo, a `say`, a refusal, an
#                 assertion's expected text.
#   roster     -- the room appears as one member of a list of sibling rooms.
#
#   QUERY
#   field      -- the line matches a FIELD NAME anchored at line start inside a record body. This
#                 is the only class an index would speed up, and it is the class the prior paper's
#                 recommendation rests on.
#   recency    -- newest-first: `sort -r`, `head -`, `tail -`, `ls -t`. A sorted room answers this.
#   by_path    -- a literal record path carrying a one-clock stamp. A filesystem answers this.
#   index      -- the room's README or a day shelf rather than any record. Already an index, and a
#                 hand-written one.
#   enumerate  -- `find`, `git ls-files`, `ls -1`, or a `for` over the room, bodies unopened.
#   exists     -- a `[ -d ]` or `[ -f ]` test. The cheapest query there is.
#
#   other      -- everything else, PRINTED with its file and line rather than binned, so a class
#                 this census did not anticipate stays visible instead of absorbed.
#
# THE BLIND SPOT IS THE WHOLE DIFFICULTY, AND IT IS BRACKETED RATHER THAN DENIED. A line-level
# reading cannot see a query assembled across several lines, and the journal's one known field
# query is exactly that shape: `tools/fixtures/r/rota_declared_scan.sh` enumerates a day shelf at
# line 77 and matches `^rota ` at line 104, twenty-seven lines apart with a loop between them. So
# `class_field` is a LOWER bound and reads zero, while `field_capable_files` -- files that name the
# room anywhere and contain a line-start field anchor anywhere -- is an UPPER bound. The true count
# lies between them, and a reader closes the gap by opening the named files, of which there are few
# enough to read. A bracket a reader can close beats a single number a reader must trust.
#
# WHAT IT IS NOT. It reads `tools/` alone. A query asked from a Rye module, from a git hook, or by
# a hand at a prompt sits outside this reading, and the paper that cites it says so.

set -eu

root=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$root"

# BOUND. A census that walks a room names its ceiling and refuses rather than truncating, since a
# silent truncation reads exactly like a small room. 4,096 is a power of two well above the tool
# sources tracked on `20260907`; raise it deliberately.
max_sources=${JOURNAL_QUERY_MAX:-4096}
window=${JOURNAL_QUERY_WINDOW:-5}
room=${JOURNAL_QUERY_ROOM:-session-logs}

work=$(mktemp -d 2>/dev/null || { d=/tmp/journal_query.$$; mkdir -p "$d"; echo "$d"; })
trap 'rm -rf "$work"' EXIT INT TERM

# A PEN, so every class can be shown from both sides on data rather than only on this script's own
# text. With JOURNAL_QUERY_PEN set, the sources are read from that directory instead of from
# `tools/`, which is how the control plants one line of each class and watches the reading move.
if [ -n "${JOURNAL_QUERY_PEN:-}" ]; then
  [ -d "$JOURNAL_QUERY_PEN" ] || { echo "refused: JOURNAL_QUERY_PEN names no directory" >&2; exit 1; }
  find "$JOURNAL_QUERY_PEN" -type f \( -name '*.sh' -o -name '*.rish' -o -name '*.rye' -o -name '*.awk' \) \
    2>/dev/null | sort > "$work/sources.txt"
else
  git ls-files 'tools/*.sh' 'tools/*.rish' 'tools/*.rye' 'tools/*.awk' | sort > "$work/sources.txt"
fi

# THE INSTRUMENT STEPS OUT OF ITS OWN FRAME, once, here -- before any line is read, so one
# exclusion governs every reading below rather than each reading carrying its own.
#
# WHY. This census and its control both name the room, and both carry a line-start field anchor:
# the census because that anchor IS its reading, the control because it plants a field query into a
# pen to prove the class visible from both sides. Left in, the pair count themselves as two
# field-capable files and the control's planted literal counts as the tree's one field site. The
# verdict's threshold is a tenth of the querying sites -- 7 on `20260907.204600` -- so the
# instrument would spend two of seven and the guard would eventually red because it exists rather
# than because the workload turned. That is the self-planting shape this tree booked twice on one
# day: a pen asked to sit under the ceiling it plants above, and a scan whose own explanation of a
# path counted as a use of it.
#
# BY EXACT PATH, never by a pattern. `%578` taught that a grep for a path reads every mention of
# it, including the sentences saying the opposite, and that the cure is to read the ACT rather than
# the mention. Two literal equalities are that act. A third file joining this family must be listed
# here on the lap it is written, or it silently spends the budget again -- which is why the count is
# PRINTED rather than quietly applied.
self_census="tools/fixtures/j/journal_query_census.sh"
self_control="tools/fixtures/j/journal_query_control.sh"
if [ "${JOURNAL_QUERY_ROOM:-session-logs}" = "session-logs" ]; then
  self_excluded=0
  : > "$work/sources.kept"
  while IFS= read -r f; do
    if [ "$f" = "$self_census" ] || [ "$f" = "$self_control" ]; then
      self_excluded=$(( self_excluded + 1 ))
      continue
    fi
    echo "$f" >> "$work/sources.kept"
  done < "$work/sources.txt"
  mv "$work/sources.kept" "$work/sources.txt"
else
  self_excluded=0
fi
echo "self_excluded_sources=$self_excluded"

n_sources=$(wc -l < "$work/sources.txt" | tr -d ' ')
if [ "$n_sources" -gt "$max_sources" ]; then
  echo "refused: $n_sources tool sources above the named ceiling of $max_sources" >&2
  exit 1
fi

# Every non-comment line naming the room. The comment strip reads the LEAD MARK only -- `#`, `//`,
# `///`, `//!`, `::` at the start of the line -- because a trailing comment on a real command line
# is still a real command, and stripping at any `#` would delete half of every awk program.
: > "$work/sites.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -n "$room" "$f" 2>/dev/null \
    | grep -vE '^[0-9]+:[[:space:]]*(#|//|///|//!|::)' \
    | sed "s|^|$f:|" >> "$work/sites.txt" || :
done < "$work/sources.txt"

sites=$(wc -l < "$work/sites.txt" | tr -d ' ')

# THE FIELD VOCABULARY. The session-logs law names the fields a record carries, so a predicate over
# the journal is a match against one of them anchored at line start. Spelled here rather than
# discovered, because a vocabulary discovered from the data would grow to include every word and
# then match everything.
fields='format|stamp|editor|provider|product|role|modality|model|model_status|voice|host|title|prompt|think|obs|loom|rota|file|recommend|scope|status'

classify() {
  _line=$1
  # The LAW is not the room. Four sites read `.claude/rules/session-logs.md` to check that a rule
  # still says what a witness assumes; none of them opens a record. Classing those as queries would
  # credit the journal with a workload that belongs to the rules directory.
  if printf '%s' "$_line" | grep -qE 'rules/session-logs\.(md|mdc)'; then echo rule; return; fi
  if printf '%s' "$_line" | grep -qE 'grep -[a-zA-Z]*v|! -path|:\(exclude|--exclude|continue ;;|skip *= *1|-o -path'; then
    echo exclude; return
  fi
  if printf '%s' "$_line" | grep -qE 'mkdir |path\.join|rm -rf|touch |: > |> *"[^"]*'"$room"; then
    echo construct; return
  fi
  if printf '%s' "$_line" | grep -qE 'echo |say |assert |else "|refused:|printf .%s'; then
    echo message; return
  fi
  # A roster names the room beside its siblings. Three or more sibling room names on one line is
  # the reading, since a list is what makes it a roster rather than a reference.
  if printf '%s' "$_line" | grep -qE 'for (room|d|r) in |ENFORCE=|PINS=|DECLARING=|ROOMS='; then
    echo roster; return
  fi
  if [ "$(printf '%s' "$_line" | grep -oE 'counsel|waymarks|foundations|active-designing|external-research|expanding-prompts|construction|gratitude|archive|yonder|bron-resins' | sort -u | wc -l)" -ge 3 ]; then
    echo roster; return
  fi
  if printf '%s' "$_line" | grep -qE "\\^($fields)[ '\"/\\\\]"; then echo field; return; fi
  if printf '%s' "$_line" | grep -qE 'sort -r|head -|tail -|ls -t|\| *head|\| *tail'; then
    echo recency; return
  fi
  if printf '%s' "$_line" | grep -qE '[0-9]{8}-[0-9]{6}'; then echo by_path; return; fi
  if printf '%s' "$_line" | grep -q 'README'; then echo index; return; fi
  if printf '%s' "$_line" | grep -qE 'find |ls-files|ls -1|for f in|list-dir'; then
    echo enumerate; return
  fi
  if printf '%s' "$_line" | grep -qE '\[ -[dfe] '; then echo exists; return; fi
  # An assignment naming the room and nothing more specific builds a variable, never a reading.
  # It sits LAST among the constructs on purpose: the SHAPE of a path is a stronger signal than the
  # syntax of the line holding it, so `let ref = "session-logs/YYYYMMDD-HHMMSS_sprig.kyri"` reads as the
  # record path it names rather than as the assignment it happens to be written as.
  if printf '%s' "$_line" | grep -qE '^[[:space:]]*(let )?_?[A-Za-z_]+ *='; then
    echo construct; return
  fi
  echo other
}

: > "$work/classed.txt"
while IFS= read -r site; do
  where=$(printf '%s' "$site" | cut -d: -f1,2)
  body=$(printf '%s' "$site" | cut -d: -f3-)
  printf '%s\t%s\t%s\n' "$(classify "$body")" "$where" "$body" >> "$work/classed.txt"
done < "$work/sites.txt"

count_class() { awk -F'\t' -v c="$1" '$1==c{n++} END{print n+0}' "$work/classed.txt"; }

echo "sources_read=$n_sources"
echo "query_sites=$sites"
for c in rule exclude construct message roster field recency by_path index enumerate exists other; do
  echo "class_${c}=$(count_class "$c")"
done

# The `other` bin is printed whole. A census that bins the unexpected silently is a census that
# stops finding anything it was not already looking for.
grep "^other	" "$work/classed.txt" 2>/dev/null | cut -f2 | sed 's/^/other_site=/' || :

# Every field site is printed too, because there are few enough to read and they are the whole
# question -- a reader checks the verdict by eye rather than by trust.
grep "^field	" "$work/classed.txt" 2>/dev/null | cut -f2 | sed 's/^/field_site=/' || :

# THE UPPER BOUND, read at FILE level rather than in a line window. An earlier draft used a
# five-line window and answered zero -- the same zero the line reading gives -- which would have
# been a false all-clear, since the one real field query spans twenty-seven lines. A bound that
# agrees with the reading it is meant to check is not a bound. So this counts every source that
# names the room ANYWHERE and carries a line-start field anchor ANYWHERE, names each one, and
# leaves the reader to close the bracket by opening them.
#
# THE INSTRUMENT IS NOT THE WORKLOAD, and naming that is a repair rather than a convenience. This
# census and its control both name the room and both carry a line-start field anchor -- the census
# because the anchor pattern IS its reading, the control because it plants a field query into a pen
# to prove the class visible. So the pair count themselves as two of the field-capable files, and
# the threshold below is a tenth of the querying sites: on `20260907.204600` that is 7, and the two
# self-counts spend two of it. A guard would then red because the instrument exists, which is the
# self-planting shape booked twice in this tree on one day -- a pen asked to sit under the ceiling
# it plants above, and a scan whose own explanation of a path counted as a use of it.
#
# THE EXCLUSION IS BY EXACT PATH, never by a pattern. `%578` taught that a grep for a path reads
# every mention of it, including the sentences saying the opposite; the cure there was to read the
# ACT rather than the mention. Two literal paths are the act: these are this instrument's own two
# files, listed here, and a third file added to this family must be listed here on the lap it is
# written or it silently spends the budget again. Nothing else is excluded, and the count of what
# was excluded is PRINTED, so a reader sees the instrument step out of its own frame.
: > "$work/capable.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -q "$room" "$f" 2>/dev/null || continue
  grep -qE "\\^($fields)[ '\"/\\\\]" "$f" 2>/dev/null || continue
  echo "$f" >> "$work/capable.txt"
done < "$work/sources.txt"
echo "field_capable_files=$(wc -l < "$work/capable.txt" | tr -d ' ')"
sed 's/^/field_capable=/' "$work/capable.txt"

# THE VERDICT, and it is a SEPARATION rather than a count -- every number above moves as the tree
# grows. The question the prior paper left open is whether the journal is asked field predicates at
# all. `sorted_room` says the workload is recency, enumeration and named paths, which a directory
# and a sort already answer; `indexed_room` says field predicates are a real share of the work and
# an index earns its keep. The threshold is ONE TENTH of the querying sites -- deliberately low,
# because an index is a real cost and a workload that is nine parts walk-and-sort does not need one.
nonquery=$(( $(count_class rule) + $(count_class exclude) + $(count_class construct) + $(count_class message) + $(count_class roster) ))
fld=$(count_class field)
cap=$(wc -l < "$work/capable.txt" | tr -d ' ')
querying=$(( sites - nonquery - $(count_class other) ))
echo "nonquery_sites=$nonquery"
echo "querying_sites=$querying"
# The verdict takes the UPPER bound, so a wrong answer errs toward building the index rather than
# toward skipping it -- the cheaper mistake to discover.
if [ "$querying" -le 0 ]; then
  echo "verdict=no_queries"
elif [ "$cap" -ge $(( (querying + 9) / 10 )) ]; then
  echo "verdict=indexed_room"
else
  echo "verdict=sorted_room"
fi
