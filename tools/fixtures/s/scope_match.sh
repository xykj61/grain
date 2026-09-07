# tools/fixtures/s/scope_match.sh -- does this watch-set reach this changed path?
#
# WHAT THIS IS FOR. tools/fixtures/s/standing_equipment_scope_map.sh names, per guard, the files
# that guard watches, written as shell patterns. Two programs ask the same question of that map.
# `standing_equipment_run.sh --scoped` asks it to SKIP a guard no changed path reaches, and
# `standing_equipment_scope_rank.sh` asks it to COUNT how often a guard is reached, so a hand can
# see what each map row saves and which row to write next. A skip and a price computed by two
# matchers is one rule written twice, and on the day they disagree the price is for a skip that
# never happens. So the matcher is written once, here, and both callers source it:
#
#   . "$_fd_root/tools/fixtures/s/scope_match.sh"
#
#   scope_match_word 'caravan/' caravan/unhand.rye     # one pattern against one path
#   scope_match_row  "$watchset" "$path"               # a whole row against one path
#   scope_match_any  "$watchset" "$pathlistfile"       # a whole row against a file of paths
#
# Each answers 0 when the watch reaches, and 1 when it does not.
#
# THE TWO RULES, SPELLED ONCE. A word ending in `/` watches its whole room, so it grows a trailing
# `*` before it is compared -- `caravan/` reaches `caravan/ladder_checks.rye`. Every other word is
# a shell glob read by `case`, which is where the semantics come from rather than from anything
# invented here: `tools/*/ales_*_witness.rish` is a pattern the shell already knows how to read.
#
# WHY `case` AND NOT A REGULAR EXPRESSION. Translating a glob into an ERE would be a second
# matcher wearing a third syntax, which is the fault this file exists to remove. `case` is POSIX in
# every shell this tree runs on, spawns nothing, and reads the map's patterns in the language they
# were written in. The dialect questions this tree does pay are named once in
# tools/fixtures/s/shell_portable.sh; this is not one of them.
#
# WHAT IT DOES NOT DO. It never reads the map, never reads git, and never judges whether a row is
# the RIGHT row for its guard -- that judgment is a hand's, and the map's own header says so. This
# answers one question about one string, so that both callers can be wrong about the same thing in
# exactly one place.
#
# A NOTE ON NAMES. POSIX sh has no locals, so every variable here wears the `_sm_` prefix and no
# two functions in the chain share one -- `scope_match_any` calls `scope_match_row` calls
# `scope_match_word`, and a shared name would have the inner call eat the outer loop's cursor.

# scope_match_word WORD PATH -- one watch word against one changed path.
scope_match_word() {
  _sm_word=$1
  _sm_path=$2
  case "$_sm_word" in */) _sm_word="$_sm_word*" ;; esac
  # shellcheck disable=SC2254
  case "$_sm_path" in $_sm_word) return 0 ;; esac
  return 1
}

# scope_match_row ROW PATH -- a whole watch-set, space-separated, against one changed path.
# An empty row reaches nothing, which is the honest reading: a guard with no watch words has no
# claim on any change. The map's ABSENCE rule (a guard with no row at all runs anyway) lives in
# the caller, because it is a decision about the roster rather than about a string.
scope_match_row() {
  _sm_row=$1
  _sm_rpath=$2
  for _sm_w in $_sm_row; do
    if scope_match_word "$_sm_w" "$_sm_rpath"; then
      return 0
    fi
  done
  return 1
}

# scope_match_any ROW LISTFILE -- a whole watch-set against a newline-delimited file of paths.
# Answers 0 on the FIRST path that the row reaches, so a large changed set costs no more than the
# first hit. An empty or absent list reaches nothing.
scope_match_any() {
  _sm_arow=$1
  _sm_list=$2
  [ -s "$_sm_list" ] || return 1
  while IFS= read -r _sm_cf; do
    [ -n "$_sm_cf" ] || continue
    if scope_match_row "$_sm_arow" "$_sm_cf"; then
      return 0
    fi
  done < "$_sm_list"
  return 1
}
