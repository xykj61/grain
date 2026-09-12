#!/bin/sh
# tools/fixtures/s/standing_equipment_scope_rank_control.sh -- the ranking, proven in a real repo.
#
# WHY A CONTROL. Two of this scan's readings are gates, and a gate proven only in the passing
# direction cannot be told from a gate that has started saying yes. Both are planted here and then
# lifted. The rest of the file is a READING, and a reading has its own failure mode, which this
# control exists mainly to catch: a number that is quietly always zero. The first draft of the
# touch pass used one awk name as both an array and a scalar, awk refused the row it reached AFTER
# the summary lines had printed, and every touch rate read 0.000 against a table that looked
# perfectly healthy. So the load-bearing leg here is a NONZERO rate on planted history, shown
# beside a copy with the reach pass stripped out, which reads every rate as zero and every saving
# as full cost.
#
# THE MATCHER IS PROVEN SEPARATELY, because it is the piece two programs share -- this scan and
# `standing_equipment_run.sh --scoped`. If the matcher drifts, the price is for a skip that never
# happens, and the two would drift in silence.
#
# EXPECTED: every behavior satisfied, faults=0, exit 0.
#
# Driven by tools/s/standing_equipment_scope_rank_witness.rish. Run from anywhere.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/scope_match.sh"
. "$_fd_root/tools/fixtures/p/plant.sh"

behaviors=0
faults=0
note() {
  _label=$1; _got=$2; _want=$3
  behaviors=$((behaviors + 1))
  if [ "$_got" = "$_want" ]; then echo "OK   $_label ($_got)"
  else echo "FAULT $_label -- got '$_got', owed '$_want'"; faults=$((faults + 1)); fi
}
yn() { if "$@" >/dev/null 2>&1; then echo yes; else echo no; fi; }

echo "== 1. the matcher, which two programs share =="
note "room_word_reaches_its_room" "$(yn scope_match_word 'caravan/' 'caravan/unhand.rye')" "yes"
note "room_word_stops_at_the_room" "$(yn scope_match_word 'caravan/' 'caravanserai/x.rye')" "no"
note "room_word_is_not_the_room_itself" "$(yn scope_match_word 'caravan/' 'caravan')" "no"
note "exact_path_reaches_itself" "$(yn scope_match_word 'tally/copy.rye' 'tally/copy.rye')" "yes"
note "exact_path_is_not_a_prefix" "$(yn scope_match_word 'tally/copy.rye' 'tally/copy.rye.bak')" "no"
note "glob_word_reaches" "$(yn scope_match_word 'tools/*/ales_*_witness.rish' 'tools/al/ales_roster_witness.rish')" "yes"
# A shell glob's `*` crosses a slash, which is the semantics `case` gives and therefore the
# semantics the map has always had. Stated here rather than left for a reader to discover, because
# a map row is written as though `*` were one segment.
note "glob_star_crosses_a_slash" "$(yn scope_match_word 'tools/*/x.rish' 'tools/a/b/x.rish')" "yes"
note "row_takes_the_second_word" "$(yn scope_match_row 'glow/ caravan/' 'caravan/unhand.rye')" "yes"
note "row_reaches_nothing_when_empty" "$(yn scope_match_row '' 'caravan/unhand.rye')" "no"
note "row_refuses_an_unreached_path" "$(yn scope_match_row 'glow/ comlink/' 'caravan/unhand.rye')" "no"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
printf 'caravan/unhand.rye\nglow/rune.glow\n' > "$pen/list"
note "any_finds_a_hit_in_a_list" "$(yn scope_match_any 'glow/' "$pen/list")" "yes"
note "any_refuses_a_list_it_cannot_reach" "$(yn scope_match_any 'tally/' "$pen/list")" "no"
: > "$pen/empty"
note "any_refuses_an_empty_list" "$(yn scope_match_any 'glow/' "$pen/empty")" "no"
note "any_refuses_an_absent_list" "$(yn scope_match_any 'glow/' "$pen/nothing-here")" "no"

echo
echo "== 2. the scan, over a real repository the control builds =="
mkdir -p "$pen/repo/tools/fixtures/s" "$pen/repo/rishi/bin" "$pen/repo/caravan" "$pen/repo/glow"
cp "$_fd_root/tools/fixtures/s/scope_match.sh" "$pen/repo/tools/fixtures/s/"
cp "$_fd_root/tools/fixtures/s/standing_equipment_scope_rank.sh" "$pen/repo/tools/fixtures/s/"

roster() {                     # roster <name:tier>...
  : > "$pen/repo/roster.kyri"
  for r in "$@"; do
    n=${r%%:*}; t=${r##*:}
    { echo "guard $n"; echo "path tools/x.rish"; echo "tier $t"; echo; } >> "$pen/repo/roster.kyri"
  done
}
mapfile() {                    # mapfile <maprow-line>...
  { echo '#!/bin/sh'; echo 'cat <<MAP'
    for l in "$@"; do printf '%s\n' "$l"; done
    echo 'MAP'; } > "$pen/repo/map.sh"
}
cardfile() {                   # cardfile <name:seconds>...
  { echo 'format standing-equipment-runs-v1'
    for c in "$@"; do
      n=${c%%:*}; s=${c##*:}
      echo "ran $n 20260907.000000 green lap $s"
    done; } > "$pen/repo/card.kyri"
}
rank() {
  ( cd "$pen/repo" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri STANDING_SCOPE_MAP=map.sh \
      sh tools/fixtures/s/standing_equipment_scope_rank.sh "$@" 2>&1 )
}
val() { echo "$1" | sed -n "s/^$2=\(.*\)/\1/p" | head -1; }

( cd "$pen/repo" \
  && git init -q . \
  && git config user.email pen@example.invalid \
  && git config user.name Pen \
  && git config commit.gpgsign false \
  && printf 'a\n' > caravan/unhand.rye && git add -A && git commit -qm 'pen: caravan moves' \
  && printf 'b\n' > glow/rune.glow && git add -A && git commit -qm 'pen: glow moves' \
  && printf 'c\n' > glow/other.glow && git add -A && git commit -qm 'pen: glow moves again' \
  && printf 'd\n' > README.md && git add -A && git commit -qm 'pen: the door moves' ) >/dev/null 2>&1

# `slow` watches caravan/, touched by 1 of 4 commits. `noisy` watches glow/, touched by 2 of 4.
# `quiet` watches a room nothing touched. `bare` has no map row at all.
roster slow:lap noisy:lap quiet:lap bare:lap
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/'
cardfile slow:100 noisy:100 quiet:100 bare:70
o=$(rank --window 10 --top 8)
note "scan_verdict_ok" "$(val "$o" verdict)" "ok"
note "commits_read" "$(val "$o" commits_read)" "4"
note "static_counted" "$(val "$o" static)" "3"
note "unmapped_counted" "$(val "$o" unmapped_absent)" "1"

# THE LOAD-BEARING READING: a rate that is actually nonzero. The first draft printed 0.000 for
# every guard because awk refused a row after the summary had printed.
note "touch_rate_nonzero" \
  "$(echo "$o" | sed -n 's/^rank_static [0-9]* noisy .*touch=\([0-9.]*\).*/\1/p')" "0.500"
note "touch_rate_of_a_quieter_guard" \
  "$(echo "$o" | sed -n 's/^rank_static [0-9]* slow .*touch=\([0-9.]*\).*/\1/p')" "0.250"
note "touch_rate_zero_when_unreached" \
  "$(echo "$o" | sed -n 's/^rank_static [0-9]* quiet .*touch=\([0-9.]*\).*/\1/p')" "0.000"
# cost x (1 - rate): 100 x 0.5 = 50, 100 x 0.75 = 75, 100 x 1 = 100.
note "saving_is_cost_times_one_minus_rate" \
  "$(echo "$o" | sed -n 's/^rank_static [0-9]* noisy .*saving=\([0-9]*\)s.*/\1/p')" "50"
note "saving_of_the_quieter_guard" \
  "$(echo "$o" | sed -n 's/^rank_static [0-9]* slow .*saving=\([0-9]*\)s.*/\1/p')" "75"
note "quiet_row_saves_its_whole_cost" \
  "$(echo "$o" | sed -n 's/^rank_static [0-9]* quiet .*saving=\([0-9]*\)s.*/\1/p')" "100"
note "ranked_by_saving_descending" \
  "$(echo "$o" | sed -n 's/^rank_static 1 \([a-z]*\) .*/\1/p')" "quiet"
note "static_saving_summed" "$(val "$o" static_saving_s)" "225"

# An unmapped guard runs every pass, so it is ranked by cost alone and never by a saving.
note "unmapped_ranked_by_cost" \
  "$(echo "$o" | sed -n 's/^rank_unmapped 1 \([a-z]*\) .*/\1/p')" "bare"
note "unmapped_cost_summed" "$(val "$o" unmapped_cost_s)" "70"
note "mapped_guard_absent_from_unmapped" \
  "$(echo "$o" | grep -c '^rank_unmapped .* noisy ' || true)" "0"

echo
echo "== 3. a cost nobody measured is unknown, never zero =="
cardfile slow:100 noisy:100 quiet:100
o=$(rank --window 10)
note "cost_unknown_counted" "$(val "$o" cost_unknown)" "1"
note "cost_known_counted" "$(val "$o" cost_known)" "3"
note "unknown_cost_left_out_of_the_sum" "$(val "$o" unmapped_cost_s)" "0"
note "unknown_cost_absent_from_the_ranking" \
  "$(echo "$o" | grep -c '^rank_unmapped .* bare ' || true)" "0"
cardfile slow:100 noisy:100 quiet:100 bare:70

echo
echo "== 4. the two gates, each planted and then lifted =="
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/' 'ghost tools/'
o=$(rank --window 10)
note "orphan_row_bitten" "$(val "$o" verdict)" "map_disagrees_with_roster"
note "orphan_row_counted" "$(val "$o" orphan_map_rows)" "1"
note "orphan_row_named" "$(val "$o" orphan_names)" "ghost"
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/'
o=$(rank --window 10)
note "orphan_row_lifted" "$(val "$o" verdict)" "ok"

mapfile 'slow caravan/' 'noisy glow/' 'noisy comlink/' 'quiet tally/'
o=$(rank --window 10)
note "duplicate_row_bitten" "$(val "$o" verdict)" "map_disagrees_with_roster"
note "duplicate_row_counted" "$(val "$o" duplicate_map_rows)" "1"
note "duplicate_row_named" "$(val "$o" duplicate_names)" "noisy"
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/'
o=$(rank --window 10)
note "duplicate_row_lifted" "$(val "$o" verdict)" "ok"

echo
echo "== 5. the bounds and the print =="
o=$(rank --window 10 --top 1)
note "top_bounds_the_print" "$(echo "$o" | grep -c '^rank_static [0-9]' || true)" "1"
note "top_names_the_remainder" "$(val "$o" rank_static_unshown)" "2"
o=$(rank --window 10 --list)
note "list_prints_them_all" "$(echo "$o" | grep -c '^rank_static [0-9]' || true)" "3"
note "window_zero_refused" "$(rank --window 0 >/dev/null 2>&1 && echo ran || echo refused)" "refused"
note "window_past_the_bound_refused" "$(rank --window 99999 >/dev/null 2>&1 && echo ran || echo refused)" "refused"
note "window_not_a_number_refused" "$(rank --window twelve >/dev/null 2>&1 && echo ran || echo refused)" "refused"
note "unknown_argument_refused" "$(rank --sideways >/dev/null 2>&1 && echo ran || echo refused)" "refused"

echo
echo "== 6. the reach pass is what earns the rates =="
# A copy with the reach pass stripped must read every rate as zero and every saving as full cost --
# which is exactly what a healthy-looking table said the day the awk name collided.
cp "$_fd_root/tools/fixtures/s/standing_equipment_scope_rank.sh" "$pen/repo/tools/fixtures/s/blind.sh"
plant_apply "$pen/repo/tools/fixtures/s/blind.sh" \
  's|^      printf .%s\\t%s\\n. "$p" "$gname" >> "$pen/reach"$|      :|' blind_reach \
  || echo "FAULT blind reach plant matched nothing"
o=$( cd "$pen/repo" && STANDING_ROSTER=roster.kyri STANDING_CARD=card.kyri STANDING_SCOPE_MAP=map.sh \
       sh tools/fixtures/s/blind.sh --window 10 2>&1 )
note "blind_copy_reads_every_rate_zero" \
  "$(echo "$o" | sed -n 's/^rank_static [0-9]* noisy .*touch=\([0-9.]*\).*/\1/p')" "0.000"
note "blind_copy_saves_the_whole_cost" "$(val "$o" static_saving_s)" "300"

echo
echo "== 7. a row must reach its guard's own control =="
# The map's rule is that a row follows its guard's GATED readings, and a witness asserts on its own
# control between 2 and 42 times -- so a row blind to its control names LESS than its guard gates,
# which is the one direction that skips real work. Planted here and then lifted.
( cd "$pen/repo" \
  && mkdir -p tools/fixtures/x \
  && printf '#!/bin/sh\necho control_verdict=ok\n' > tools/fixtures/x/slow_control.sh \
  && git add -A && git commit -qm 'pen: slow grows a control' ) >/dev/null 2>&1
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/'
o=$(rank --window 10)
note "unreached_control_bitten" "$(val "$o" verdict)" "map_disagrees_with_roster"
note "unreached_control_counted" "$(val "$o" rows_missing_control)" "1"
note "unreached_control_named" \
  "$(echo "$o" | sed -n 's/^missing_control: \([a-z]*\) .*/\1/p')" "slow"
mapfile 'slow caravan/ tools/fixtures/x/' 'noisy glow/' 'quiet tally/'
o=$(rank --window 10)
note "reached_control_lifted" "$(val "$o" verdict)" "ok"
note "reached_control_counted_zero" "$(val "$o" rows_missing_control)" "0"
# A guard with no control at that name is counted apart and gated on nothing, since a naming
# convention is not a law.
note "guards_without_a_control_counted_apart" "$(val "$o" rows_without_control)" "2"

echo
echo "== 8. DISCOVERY is a class of its own, and its seconds are not a prize =="
# THE SILENCE THIS PROVES SHUT. The map's header has named a DISCOVERY vocabulary since it was
# written, the runner has run such a row since the fusion landed, and until 20260908 no row in the
# tree spelled the word -- so `discovery=0` stood beside 194 unmapped guards, and every leg below
# tested a class with no input. A guard that reads the whole tree BY DESIGN and a guard nobody has
# mapped YET are opposite facts: the first can never be mapped, the second is exactly what a hand
# reading `rank_unmapped` is shopping for. Summed into one number they read as one queue.
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/' 'bare DISCOVERY'
o=$(rank --window 10 --top 8)
note "discovery_row_counted" "$(val "$o" discovery)" "1"
note "discovery_is_not_static" "$(val "$o" static)" "3"
note "discovery_leaves_the_absent_count" "$(val "$o" unmapped_absent)" "0"
# It still RUNS, so it is unmapped cost -- and it is the unclaimable half of it.
note "discovery_cost_is_unmapped_cost" "$(val "$o" unmapped_cost_s)" "70"
note "discovery_cost_named_apart" "$(val "$o" discovery_cost_s)" "70"
note "discovery_leaves_nothing_claimable" "$(val "$o" absent_cost_s)" "0"
# A DISCOVERY guard is never ranked among the static rows, since it has no watch-set to price.
note "discovery_absent_from_rank_static" \
  "$(echo "$o" | grep -c '^rank_static .* bare ' || true)" "0"
note "discovery_named_in_rank_unmapped" \
  "$(echo "$o" | sed -n 's/^rank_unmapped 1 bare .*class=\([a-z]*\).*/\1/p')" "discovery"

# LIFTED: the same guard with no row at all is ABSENT, and its seconds become claimable again --
# the two readings differ in exactly the place the split was built for.
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/'
o=$(rank --window 10 --top 8)
note "absent_counted_when_the_row_is_lifted" "$(val "$o" unmapped_absent)" "1"
note "absent_cost_claimable_again" "$(val "$o" absent_cost_s)" "70"
note "discovery_cost_back_to_zero" "$(val "$o" discovery_cost_s)" "0"
note "unmapped_total_unchanged_either_way" "$(val "$o" unmapped_cost_s)" "70"
note "discovery_count_back_to_zero" "$(val "$o" discovery)" "0"

# AND THE TWO HALVES SUM TO THE WHOLE, at a reading where both are nonzero -- so neither can be
# quietly dropped or double-counted.
roster slow:lap noisy:lap quiet:lap bare:lap census:lap
cardfile slow:100 noisy:100 quiet:100 bare:70 census:30
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/' 'census DISCOVERY'
o=$(rank --window 10 --top 8)
note "split_sums_to_the_whole" \
  "$(( $(val "$o" discovery_cost_s) + $(val "$o" absent_cost_s) ))" "$(val "$o" unmapped_cost_s)"
note "split_both_halves_nonzero_discovery" "$(val "$o" discovery_cost_s)" "30"
note "split_both_halves_nonzero_absent" "$(val "$o" absent_cost_s)" "70"
# The claimable share is the honest ceiling, and it is lower than the unmapped one whenever any
# guard is declared -- which is the whole reason for printing it.
note "claimable_share_below_unmapped_share" \
  "$(yn awk -v a="$(val "$o" absent_cost_share)" -v u="$(val "$o" unmapped_cost_share)" \
      'BEGIN { exit !(a < u) }')" "yes"
roster slow:lap noisy:lap quiet:lap bare:lap
cardfile slow:100 noisy:100 quiet:100 bare:70

echo
echo "== 9. --kin: which seated guards already watch these files =="
# WHY THESE LEGS. The verb exists to answer a question a lap asks BEFORE it writes anything, so its
# dangerous failure is the encouraging one: an empty answer that means "nobody does this". Three
# shapes produce an empty answer wrongly -- a path that is not there, an orphan row, and a guard
# the map never mapped -- and each is planted here and then lifted.
roster slow:lap noisy:lap quiet:lap bare:lap
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/'
cardfile slow:100 noisy:100 quiet:100 bare:70
o=$(rank --kin caravan/unhand.rye)
note "kin_names_the_watching_guard" \
  "$(echo "$o" | sed -n 's|^kin caravan/unhand.rye \([a-z]*\) .*|\1|p')" "slow"
note "kin_names_the_tier_it_runs_on" \
  "$(echo "$o" | sed -n 's|^kin caravan/unhand.rye slow \([a-z]*\)|\1|p')" "lap"
note "kin_counts_what_it_named" \
  "$(echo "$o" | sed -n 's|^kin_count caravan/unhand.rye \([0-9]*\)|\1|p')" "1"
note "kin_leaves_out_a_row_that_does_not_reach" \
  "$(echo "$o" | grep -c '^kin caravan/unhand.rye noisy ' || true)" "0"
note "kin_verdict_ok" "$(val "$o" verdict)" "ok"
# THE LIMIT, printed beside the answer because it is usually larger than the answer.
note "kin_names_the_mapped_it_can_speak_for" "$(val "$o" mapped)" "3"
note "kin_names_the_unmapped_it_cannot" "$(val "$o" unmapped)" "1"
# The window is the expensive half of this scan and a kin reading needs none of it.
note "kin_never_walks_the_window" "$(echo "$o" | grep -c '^commits_read=' || true)" "0"

# A path no row reaches reads zero -- honestly, and beside the unmapped count that bounds it.
o=$(rank --kin README.md)
note "kin_zero_when_no_row_reaches" \
  "$(echo "$o" | sed -n 's|^kin_count README.md \([0-9]*\)|\1|p')" "0"

# PLANTED: a path that is not there. It would read zero kin, which is the answer that sends a lap
# off to build, so it refuses instead.
note "kin_refuses_a_path_that_is_not_there" "$(yn rank --kin caravan/nothing-here.rye)" "no"
note "kin_without_a_path_refused" "$(yn rank --kin)" "no"

# PLANTED: a DISCOVERY guard reads the whole tree, so it has no watch-set to match and can never be
# printed as kin -- yet it does read this path, so it is counted apart rather than lost.
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/' 'bare DISCOVERY'
o=$(rank --kin caravan/unhand.rye)
note "kin_counts_a_discovery_guard_apart" \
  "$(echo "$o" | sed -n 's|^kin_discovery caravan/unhand.rye \([0-9]*\)|\1|p')" "1"
note "kin_never_prints_a_discovery_row_as_kin" \
  "$(echo "$o" | grep -c '^kin caravan/unhand.rye bare ' || true)" "0"

# PLANTED: an orphan row names no seated guard, so it is dead text. Printing one as kin would send
# a lap to read an instrument that does not run.
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/' 'ghost caravan/'
o=$(rank --kin caravan/unhand.rye)
note "kin_never_names_an_orphan_row" \
  "$(echo "$o" | grep -c '^kin caravan/unhand.rye ghost ' || true)" "0"
note "kin_reports_the_orphan_count_beside_the_answer" "$(val "$o" orphan_map_rows)" "1"

# LIFTED: the orphan gone, two paths read together, each finding its own guard.
mapfile 'slow caravan/' 'noisy glow/' 'quiet tally/'
o=$(rank --kin caravan/unhand.rye --kin glow/rune.glow)
note "kin_reads_two_paths_together" "$(echo "$o" | grep -c '^kin_count ' || true)" "2"
note "kin_second_path_finds_its_own_guard" \
  "$(echo "$o" | sed -n 's|^kin glow/rune.glow \([a-z]*\) .*|\1|p')" "noisy"

# The bound, proven from both sides: a reading is guard-rows times paths, so the paths are bounded
# at the edge like the window is.
kinargs=""; kinn=0
while [ "$kinn" -lt 32 ]; do kinargs="$kinargs --kin README.md"; kinn=$((kinn + 1)); done
# shellcheck disable=SC2086
note "kin_at_the_bound_runs" "$(yn rank $kinargs)" "yes"
kinargs="$kinargs --kin README.md"
# shellcheck disable=SC2086
note "kin_past_the_bound_refused" "$(yn rank $kinargs)" "no"

echo
# THE LEGS ARE COUNTED OUT LOUD, so the witness can hear a leg that stopped running.
# `faults=0` is what an empty pen prints too, and a leg that quietly stops reaching the
# scan reads exactly like a leg that passed. Raise this in the same commit that adds one.
echo "legs_expected=92"
echo "behaviors=$behaviors"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=faults"
exit 1
