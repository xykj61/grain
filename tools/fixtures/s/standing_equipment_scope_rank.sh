#!/bin/sh
# tools/fixtures/s/standing_equipment_scope_rank.sh -- what each scope-map row saves, and which row
# to write next.
#
# WHY THIS READING EXISTS. The roster pass is the largest recurring workload on this pier: 160
# guards in 1,074 seconds, measured 20260907 across eight ships, of which four fifths never skips
# (external-research/20260907-020817_what-the-fleet-spends-on-knowing-it-is-green.md). A `--scoped`
# pass skips a guard no changed path reaches, so every second it saves comes from one row of
# tools/fixtures/s/standing_equipment_scope_map.sh -- and until now nobody could say WHICH rows
# earned their keep, or which unwritten row would earn the most. That paper named the arithmetic
# and left it unbuilt: a row is worth its guard's cost multiplied by one minus its touch rate.
# Both factors already sit on disk. This reads them.
#
# WHAT IT PRINTS.
#   Per mapped guard: cost in seconds, the share of recent commits its watch-set reaches, and the
#   product -- the seconds a scoped pass expects to skip, per commit-sized change.
#   Per unmapped guard: cost alone, since an unmapped guard runs on every pass by the map's own
#   ABSENCE rule, so its saving today is exactly zero and its cost is the prize for mapping it.
#
# EXCEPT THAT HALF OF THAT PRIZE IS NOT ONE. A guard the map declares DISCOVERY reads the whole
# tree on purpose, so no watch-set could ever be right and its seconds are unclaimable forever; a
# guard merely ABSENT is one nobody has mapped yet, and its seconds are what a row would actually
# win. Until 20260908 the two shared `unmapped_cost_s`, and they shared it because no row in
# tools/fixtures/s/standing_equipment_scope_map.sh had ever spelled the word: `discovery=0` stood
# against 194 unmapped guards holding 82% of the pass. `discovery_cost_s` and `absent_cost_s` are
# printed apart now, and `absent_cost_share` is the honest ceiling on what further mapping saves.
#
# WHAT IT GATES, and why these two and nothing else. A map row naming a guard the roster does not
# seat does nothing at all, and it fails SILENTLY: the runner looks the guard up by name, finds no
# row, and runs it -- so a typo reads exactly like coverage while buying a full run every pass. The
# same holds for a second row under one name, since the runner's lookup stops at the first
# (`{ print; exit }`). Nothing in the tree read this file but the runner until today, so neither
# fault had a reader. Both are held at zero. Everything else here is a READING: no number below is
# a defect, and gating a cost or a touch rate would red the tree for having a slow guard.
#
# THE BASIS, NAMED HONESTLY. A touch rate here is per COMMIT, and a real scoped pass diffs a
# receipt head that may be several commits back, plus every uncommitted path. So this rate is a
# FLOOR on how often a guard is really reached, and a saving computed from it is a CEILING on what
# the row really saves. It is the right basis for ranking rows against each other, which is what it
# is for, and the wrong basis for promising a wall-clock number. Merges are read past
# (`--no-merges`): a merge commit's own diff is empty, so counting one would deflate every rate in
# the table by the same wrong amount.
#
# WHY THE MATCHER IS SOURCED RATHER THAN SPELLED. tools/fixtures/s/scope_match.sh answers "does
# this watch-set reach this path" for the runner too. Two spellings of that question would let this
# scan price a skip the runner never takes.
#
# Run from anywhere -- the root is found by upward walk:
#   sh tools/fixtures/s/standing_equipment_scope_rank.sh [--window N] [--top N] [--list]
#   sh tools/fixtures/s/standing_equipment_scope_rank.sh --kin PATH [--kin PATH ...]

set -eu

# Root by upward walk (seated 20260828): the letter fold moved fixtures one directory deeper, so
# fixed ../.. arithmetic breaks. The walk finds the first ancestor holding rishi/bin and
# tools/fixtures -- git-free, so a pen copy outside a repository still resolves.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/scope_match.sh"

# BOUNDS, each named and checked at the edge (TAME). The window ceiling is the one that matters:
# the reach pass is unique-paths times mapped-rows, so an unbounded window is an unbounded run.
max_window=2000
max_top=512
max_guards=1024
# A kin reading is paths times map rows, so the paths are bounded at the edge like the window.
max_kin=32

window=120
top=12
want_list=no
kin_paths=
kin_asked=0
while [ $# -gt 0 ]; do
  case "$1" in
    --window) window=${2:-}; shift 2 ;;
    --top)    top=${2:-};    shift 2 ;;
    --list)   want_list=yes; shift ;;
    --kin)
      [ $# -ge 2 ] && [ -n "${2:-}" ] \
        || { echo "refused: --kin wants a path" >&2; exit 2; }
      kin_paths="$kin_paths$2
"
      kin_asked=$((kin_asked + 1))
      shift 2 ;;
    *) echo "refused: unknown argument '$1' -- takes --window N, --top N, --list, --kin PATH" >&2; exit 2 ;;
  esac
done
case "$window" in ''|*[!0-9]*) echo "refused: --window wants a whole number of commits" >&2; exit 2 ;; esac
case "$top" in ''|*[!0-9]*) echo "refused: --top wants a whole number of rows" >&2; exit 2 ;; esac
[ "$window" -ge 1 ] && [ "$window" -le "$max_window" ] \
  || { echo "refused: --window $window outside 1..$max_window" >&2; exit 2; }
[ "$top" -ge 1 ] && [ "$top" -le "$max_top" ] \
  || { echo "refused: --top $top outside 1..$max_top" >&2; exit 2; }
[ "$kin_asked" -le "$max_kin" ] \
  || { echo "refused: --kin given $kin_asked paths, past the bound of $max_kin" >&2; exit 2; }

cd "$_fd_root"

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
card="${STANDING_CARD:-construction/standing-equipment-runs.kyri}"
scope_map="${STANDING_SCOPE_MAP:-tools/fixtures/s/standing_equipment_scope_map.sh}"

[ -f "$roster" ] || { echo "refused: no roster at $roster" >&2; exit 1; }
[ -f "$scope_map" ] || { echo "refused: no scope map at $scope_map" >&2; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

# --- the roster: one line per seated guard, with the clock it runs on ----------------------------
awk '
  function flush() { if (name != "") print name "\t" (tier == "" ? "lap" : tier); name = ""; tier = "" }
  $1 == "guard" { flush(); name = $2; next }
  $1 == "tier"  { if (name != "") tier = $2; next }
  END { flush() }
' "$roster" | sort -u > "$pen/roster"
guards=$(grep -c . "$pen/roster" || true)
[ "$guards" -le "$max_guards" ] \
  || { echo "refused: roster names $guards guards, past the bound of $max_guards" >&2; exit 1; }

# --- the map: one line per row, the guard's name and its watch-set ------------------------------
# The fixture is a program, because its rows share a spelled-once build edge, so it is RUN rather
# than read. A fixture that fails is a refusal rather than an empty map read as full coverage.
sh "$scope_map" > "$pen/mapraw" || { echo "refused: the scope map fixture failed" >&2; exit 1; }
awk '{ name = $1; $1 = ""; sub(/^ /, ""); print name "\t" $0 }' "$pen/mapraw" > "$pen/map"

# THE TWO GATES. An orphan row is dead text that reads like coverage; a duplicate row is the same
# fault wearing the runner's first-match lookup.
cut -f1 "$pen/map" | sort > "$pen/mapnames"
cut -f1 "$pen/roster" | sort > "$pen/rosternames"
comm -23 "$pen/mapnames" "$pen/rosternames" > "$pen/orphans"
orphan_map_rows=$(grep -c . "$pen/orphans" || true)
sort "$pen/mapnames" | uniq -d > "$pen/dupes"
duplicate_map_rows=$(grep -c . "$pen/dupes" || true)

# --- --kin: which seated guards ALREADY watch these files? --------------------------------------
#
# WHY THIS VERB SITS ON THIS SCAN. Everything it needs is already parsed two paragraphs up: the
# roster, the map, and one matcher. It answers the reverse of the question the ranking asks. The
# ranking takes a guard and prices its row; this takes a PATH and names the guards whose rows
# already reach it -- so a lap about to build an instrument over some files can see, in one line,
# who reads those files today.
#
# THE FIRING. On 20260912 a lap opened the dead-letter box and found a finished guard triple parked
# since 20260907 -- `standing_equipment_yield`, a scan, a control and a witness measuring what each
# scope-map row is worth. `tools/fixtures/p/path_absence_scan.sh` answered `verdict=absent` for all
# three paths, here and upstream, truthfully. The reading was useless, because
# `standing_equipment_scope_rank.sh` -- this file -- had been built meanwhile by another hand, for
# the same purpose, strictly wider, and it wears a name none of those three paths mention. Absence
# is checked by PATH; supersession happens by PURPOSE, and the two never meet.
#
# WHAT DOES MEET THEM is the watch-set. The parked scan's own map row named
# tools/fixtures/s/standing_equipment_scope_map.sh; so do the rows of `scope_rank` and
# `scope_trace`. A kin reading on that one path returns both names, which is the whole discovery
# the lap made by hand, in one command, before a line is written.
#
# THE LIMIT IS PRINTED BESIDE THE ANSWER, because it is larger than the answer. A guard with no map
# row is invisible here: ABSENCE RUNS means it reads on every pass and may well read this very
# path, and no watch-set exists to say so. `unmapped=` is that population, and on this pier it has
# been the large majority of the roster since the map was written. So `kin_count 0` means "none
# among the mapped", never "nobody" -- a distinction this file's own DISCOVERY split was built to
# keep, one reading over.
#
# A PATH THAT IS NOT THERE REFUSES, rather than reading zero. A typo returns no kin, and no kin is
# exactly the answer that sends a lap off to build. The most dangerous wrong answer this verb can
# give is the encouraging one, so the path must exist before it is asked about.
if [ "$kin_asked" -gt 0 ]; then
  printf '%s' "$kin_paths" > "$pen/kinpaths"
  while IFS= read -r kin_p; do
    [ -n "$kin_p" ] || continue
    [ -e "$kin_p" ] || { echo "refused: --kin $kin_p names no file here -- a path that is not there reads as no kin, which is the answer that sends a lap off to build" >&2; exit 2; }
  done < "$pen/kinpaths"

  echo "format standing-equipment-scope-kin-v1"
  echo "guards=$guards"
  cut -f1 "$pen/map" | sort -u > "$pen/mapseated"
  kin_mapped=$(comm -12 "$pen/mapseated" "$pen/rosternames" | grep -c . || true)
  echo "mapped=$kin_mapped"
  echo "unmapped=$((guards - kin_mapped))"
  echo "orphan_map_rows=$orphan_map_rows"
  while IFS= read -r kin_p; do
    [ -n "$kin_p" ] || continue
    kin_hits=0
    kin_disc=0
    while IFS="$(printf '\t')" read -r kin_g kin_row; do
      [ -n "$kin_g" ] || continue
      # invariant: an orphan row names no seated guard, so it is dead text and never counted as kin.
      grep -qx "$kin_g" "$pen/rosternames" || continue
      if [ "$kin_row" = DISCOVERY ]; then kin_disc=$((kin_disc + 1)); continue; fi
      if scope_match_row "$kin_row" "$kin_p"; then
        kin_tier=$(awk -F'\t' -v g="$kin_g" '$1 == g { print $2; exit }' "$pen/roster")
        echo "kin $kin_p $kin_g $kin_tier"
        kin_hits=$((kin_hits + 1))
      fi
    done < "$pen/map"
    echo "kin_count $kin_p $kin_hits"
    echo "kin_discovery $kin_p $kin_disc"
  done < "$pen/kinpaths"
  echo "verdict=ok"
  exit 0
fi

# THE THIRD GATE: a row reaches its guard's own control. The map's rule is that a row follows the
# guard's GATED readings, and every witness in this tree asserts on its `<name>_control.sh` between
# 2 and 42 times -- so a row that cannot see its own control is a row naming LESS than its guard
# gates, which is the one direction that skips real work. Thirteen rows stood that way on 20260906
# and were repaired by a hand; this is what keeps the repair rather than remembering it. A guard
# with no control at that name is counted apart and gated on nothing, since a naming convention is
# not a law.
missing_control=0
without_control=0
: > "$pen/misscontrol"
while IFS="$(printf '\t')" read -r gname grow; do
  [ -n "$gname" ] || continue
  [ "$grow" = DISCOVERY ] && continue
  ctl=$(git ls-files "tools/fixtures/*/${gname}_control.sh" 2>/dev/null | head -1)
  if [ -z "$ctl" ]; then
    without_control=$((without_control + 1))
    continue
  fi
  if scope_match_row "$grow" "$ctl"; then continue; fi
  missing_control=$((missing_control + 1))
  printf '%s -> %s\n' "$gname" "$ctl" >> "$pen/misscontrol"
done < "$pen/map"

# --- the run card: what each guard cost on THIS pier, last reading wins --------------------------
# The card is untracked by design, so a fresh clone reads no costs at all. That is an honest
# reading rather than a fault: it is counted at cost_unknown and named, never guessed at.
if [ -f "$card" ]; then
  awk '$1 == "ran" && $6 ~ /^[0-9]+$/ { c[$2] = $6 } END { for (g in c) print g "\t" c[g] }' \
    "$card" | sort > "$pen/cost"
else
  : > "$pen/cost"
fi

# --- the window: which paths each recent commit changed ------------------------------------------
# core.quotePath=false so a path outside ASCII arrives as its own bytes rather than as an escape
# nothing here would match. Tab separates, because a tracked path may hold a space and none holds
# a tab.
git -c core.quotePath=false log --no-merges -n "$window" --format='%x01%H' --name-only \
  > "$pen/log" 2>/dev/null || : > "$pen/log"
commits_read=$(awk '/^\001/ { c++ } END { print c + 0 }' "$pen/log")
awk '/^\001/ { n++; next } NF { print n "\t" $0 }' "$pen/log" | sort -u > "$pen/commitpaths"
cut -f2 "$pen/commitpaths" | sort -u > "$pen/paths"
paths_unique=$(grep -c . "$pen/paths" || true)

# --- reach: each unique path, matched once against every static row -----------------------------
# Path-first rather than commit-first on purpose. A commit-first walk asks the same question of the
# same path once per commit that touched it; asking it once per PATH and joining afterward is the
# same answer for a fraction of the work, and the window is where an unbounded run would hide.
: > "$pen/reach"
while IFS="$(printf '\t')" read -r gname grow; do
  [ -n "$gname" ] || continue
  [ "$grow" = DISCOVERY ] && continue
  grep -qx "$gname" "$pen/rosternames" || continue
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    if scope_match_row "$grow" "$p"; then
      printf '%s\t%s\n' "$p" "$gname" >> "$pen/reach"
    fi
  done < "$pen/paths"
done < "$pen/map"

# One name may not be both an array and a scalar in awk, and the first draft used `g` for the
# split array AND for the END loop's cursor -- which awk refuses at the row it reaches, AFTER the
# readings above have printed. Every touch rate read 0.000 and the table looked healthy. So the
# names are distinct here, and the control proves a nonzero rate on planted history.
awk -F'\t' '
  NR == FNR { reach[$1] = reach[$1] " " $2; next }
  {
    if (!($2 in reach)) next
    n = split(reach[$2], gs, " ")
    for (i = 1; i <= n; i++) if (gs[i] != "") seen[$1 SUBSEP gs[i]] = 1
  }
  END {
    for (k in seen) { split(k, a, SUBSEP); t[a[2]]++ }
    for (name in t) print name "\t" t[name]
  }
' "$pen/reach" "$pen/commitpaths" | sort > "$pen/touches"

# --- assemble: name, tier, class, cost, touches -------------------------------------------------
awk -F'\t' -v commits="$commits_read" '
  FILENAME == mapf     { row[$1] = $2; next }
  FILENAME == costf    { cost[$1] = $2; next }
  FILENAME == touchf   { touch[$1] = $2; next }
  {
    name = $1; tier = $2
    cls = "absent"
    if (name in row) cls = (row[name] == "DISCOVERY" ? "discovery" : "static")
    c = (name in cost) ? cost[name] : -1
    t = (name in touch) ? touch[name] : 0
    print name "\t" tier "\t" cls "\t" c "\t" t
  }
' mapf="$pen/map" costf="$pen/cost" touchf="$pen/touches" \
  "$pen/map" "$pen/cost" "$pen/touches" "$pen/roster" > "$pen/table"

# --- the readings --------------------------------------------------------------------------------
echo "format standing-equipment-scope-rank-v1"
echo "basis=per_commit"
echo "window_commits=$window"
echo "commits_read=$commits_read"
echo "paths_unique=$paths_unique"
echo "guards=$guards"

awk -F'\t' -v commits="$commits_read" '
  {
    cls[$3]++
    if ($4 < 0) { unknown++; next }
    known++
    if ($2 == "cadence") { cadence_s += $4; cadence_n++ } else { lap_s += $4; lap_n++ }
    if ($3 == "static" && commits > 0) {
      rate = $5 / commits
      save = $4 * (1 - rate)
      static_cost_s += $4
      static_save_s += save
    } else if ($3 != "static") {
      # THE UNMAPPED TAIL IS TWO POPULATIONS, and only one of them is a prize. A guard declared
      # DISCOVERY reads the whole tree by design, so no watch-set could ever be right and its
      # seconds can never be claimed; a guard merely ABSENT from the map is one nobody has got to
      # yet, and its seconds are exactly what writing a row would win. Summed together they read as
      # one number a hand plans against, which is what `unmapped_cost_s` was until 20260908.
      unmapped_cost_s += $4
      if ($3 == "discovery") { discovery_cost_s += $4 } else { absent_cost_s += $4 }
    }
  }
  END {
    printf "static=%d\n", cls["static"] + 0
    printf "discovery=%d\n", cls["discovery"] + 0
    printf "unmapped_absent=%d\n", cls["absent"] + 0
    printf "cost_known=%d\n", known + 0
    printf "cost_unknown=%d\n", unknown + 0
    printf "lap_cost_s=%d over %d guards\n", lap_s + 0, lap_n + 0
    printf "cadence_cost_s=%d over %d guards\n", cadence_s + 0, cadence_n + 0
    printf "static_cost_s=%d\n", static_cost_s + 0
    printf "static_saving_s=%d\n", static_save_s + 0
    printf "static_saving_share=%.3f\n", (static_cost_s > 0 ? static_save_s / static_cost_s : 0)
    printf "unmapped_cost_s=%d\n", unmapped_cost_s + 0
    printf "discovery_cost_s=%d\n", discovery_cost_s + 0
    printf "absent_cost_s=%d\n", absent_cost_s + 0
    total = static_cost_s + unmapped_cost_s
    printf "unmapped_cost_share=%.3f\n", (total > 0 ? unmapped_cost_s / total : 0)
    printf "absent_cost_share=%.3f\n", (total > 0 ? absent_cost_s / total : 0)
  }
' "$pen/table"

echo "orphan_map_rows=$orphan_map_rows"
echo "duplicate_map_rows=$duplicate_map_rows"
echo "rows_missing_control=$missing_control"
echo "rows_without_control=$without_control"

# The ranked rows. `--top` bounds the print rather than the computation, and the count left unsaid
# is stated, because a truncated table with no remainder line reads as a whole one.
show=$top
[ "$want_list" = yes ] && show=$max_top

echo "-- rank_static: cost x (1 - touch_rate), the seconds this row already saves"
awk -F'\t' -v commits="$commits_read" '
  $3 == "static" && $4 >= 0 {
    rate = (commits > 0 ? $5 / commits : 0)
    printf "%.4f\t%s\t%d\t%.3f\t%s\n", $4 * (1 - rate), $1, $4, rate, $2
  }
' "$pen/table" | sort -k1,1 -nr > "$pen/rank_static"
awk -v show="$show" '
  NR <= show { printf "rank_static %d %s cost=%ss touch=%s saving=%ds tier=%s\n", NR, $2, $3, $4, $1, $5 }
  END { if (NR > show) printf "rank_static_unshown=%d\n", NR - show; else printf "rank_static_unshown=0\n" }
' "$pen/rank_static"

echo "-- rank_unmapped: cost alone, since an unmapped guard runs every pass"
awk -F'\t' '$3 != "static" && $4 >= 0 { printf "%d\t%s\t%s\t%s\n", $4, $1, $3, $2 }' "$pen/table" \
  | sort -k1,1 -nr > "$pen/rank_unmapped"
awk -v show="$show" '
  NR <= show { printf "rank_unmapped %d %s cost=%ss class=%s tier=%s\n", NR, $2, $1, $3, $4 }
  END { if (NR > show) printf "rank_unmapped_unshown=%d\n", NR - show; else printf "rank_unmapped_unshown=0\n" }
' "$pen/rank_unmapped"

if [ "$orphan_map_rows" -gt 0 ]; then
  echo "orphan_names=$(tr '\n' ',' < "$pen/orphans" | sed 's/,$//')"
fi
if [ "$duplicate_map_rows" -gt 0 ]; then
  echo "duplicate_names=$(tr '\n' ',' < "$pen/dupes" | sed 's/,$//')"
fi
if [ "$missing_control" -gt 0 ]; then
  sed 's/^/missing_control: /' "$pen/misscontrol"
fi

if [ "$orphan_map_rows" -eq 0 ] && [ "$duplicate_map_rows" -eq 0 ] && [ "$missing_control" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=map_disagrees_with_roster"
exit 1
