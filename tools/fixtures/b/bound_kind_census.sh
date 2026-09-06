#!/bin/sh
# tools/fixtures/b/bound_kind_census.sh -- what dimension does each named bound constrain?
#
# TAME root rule 1 says bound everything: every allocation, collection, loop, and
# pipeline names a max. It does not say what QUANTITY the max must name, and this
# census reads that gap. A bound on bytes and a bound on repetitions-per-second are
# both lawful under rule 1 and they buy entirely different safety.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# THE UNIT IS THE DISTINCT NAME, and the reason is Caravan. One bound
# (`max_patience_looks`) is re-exported through 46 rungs, each rung deriving it from
# the rung below. Counting sites would measure the ladder's length; counting distinct
# names measures how many separate decisions the tree has actually made. Both numbers
# are reported so a reader can see the ratio.
#
# THE DECLARED LIMIT, stated before the numbers: this classifies by NAME, never by
# reading the code a bound guards. The standing counterexample is `max_period_stamp`
# in pond/apps/entity_books_period.rye, whose value is 32 and which bounds a stamp
# STRING -- a time-flavored name over an extent bound. So every class small enough to
# read is enumerated as a detail line rather than merely counted, and a hand confirms.
#
# THE CLASSES, in the order a name is tested against them (first match wins, which is
# what makes the classes a partition rather than overlapping tags):
#   energy   -- joules, watts, mAh, a power or battery budget
#   rate     -- a quantity with a TIME DENOMINATOR: per second, an interval, a
#               period, a duty cycle, a frequency
#   duration -- an elapsed span: a timeout, a linger, a deadline, _ms/_secs
#   work     -- repetitions of an operation: looks, turns, runs, passes, retries,
#               restarts, attempts, steps, ticks, rounds, tries, iterations
#   extent   -- everything spatial or countable: bytes, len, capacity, entries,
#               depth, width, count, and the long tail of named sizes
# `extent` is the residual on purpose. A bound this census cannot place in one of the
# four narrow classes is a bound on how much rather than how often, and calling that
# `other` would hide the finding inside a shrug.
set -eu

[ -d .git ] || { echo "verdict=not_a_repo"; exit 2; }

names_file=$(mktemp 2>/dev/null || echo "./.bound_kind_names.$$")
sites_file=$(mktemp 2>/dev/null || echo "./.bound_kind_sites.$$")
trap 'rm -f "$names_file" "$sites_file"' EXIT INT TERM

# Bound declarations in tracked Rye. `git ls-files` IS the boundary: vendored and
# submodule sources are not tracked here, so no exclusion roster can drift.
git ls-files '*.rye' -z 2>/dev/null \
  | xargs -0 grep -hoE '^[[:space:]]*(pub )?const (max|min)_[a-z0-9_]+' 2>/dev/null \
  | sed -E 's/^[[:space:]]*(pub )?const //' > "$sites_file"

# THIS CENSUS OBEYS THE INSTRUMENT-REFUSAL LAW, and it learned it the hard way: the first draft
# closed both extraction pipelines with `|| true`, and `instrument_refusal` reds a discarded
# failure on an output-producing pass for exactly the reason this census is about -- a broken
# instrument and a clean tree report the same number. Dropping the swallow is only half the
# repair, since a pipeline ending in `sed` exits zero over empty input however badly `git
# ls-files` failed upstream. So each extraction CHECKS ITS OWN RESULT and refuses by name.
sites=$(wc -l < "$sites_file" | tr -d ' ')
[ "$sites" -gt 0 ] || { echo "verdict=no_bounds_found"; exit 2; }

sort -u "$sites_file" > "$names_file"
names=$(wc -l < "$names_file" | tr -d ' ')

# THE PATTERNS ARE TIGHTENED BY THEIR OWN MISFIRES, each named here so a later hand
# does not loosen one back. A first draft read `_wall` as wall-clock and matched
# `max_wall_cols`, `max_wall_rows`, and `max_walls_bytes` -- Skate's surface walls, all
# three spatial. It read `_freq` and matched `max_frequency_penalty`, a sampling
# parameter with no time in it at all. Both words are gone.
energy_re='joule|watt|_mah$|_mw$|_uw$|energy|power|battery|charge'
rate_re='rate|_hz$|per_sec|per_second|per_ms|_interval|_period|duty|_cadence'
duration_re='_ms$|_us$|_ns$|_sec$|_secs$|_seconds$|_millis$|timeout|deadline|linger|_delay|backoff|_elapsed'
work_re='_looks$|_turns$|_runs$|_passes$|_retries$|_restarts$|_attempts$|_steps$|_ticks$|_rounds$|_tries$|_iterations$|_polls$|_spins$|_probes$|_sweeps$|_visits$|_hops$|_reads$|_writes$|_calls$'

classify() {
  case "$1" in *) : ;; esac
  if   printf '%s' "$1" | grep -qE "$energy_re";   then echo energy
  elif printf '%s' "$1" | grep -qE "$rate_re";     then echo rate
  elif printf '%s' "$1" | grep -qE "$duration_re"; then echo duration
  elif printf '%s' "$1" | grep -qE "$work_re";     then echo work
  else echo extent
  fi
}

n_energy=0; n_rate=0; n_duration=0; n_work=0; n_extent=0
while IFS= read -r nm; do
  [ -n "$nm" ] || continue
  k=$(classify "$nm")
  # A narrow class is small enough to read, so each member carries the file that
  # declares it first -- the hand check the declared limit above asks for is then one
  # `sed -n` away rather than a fresh grep of the tree.
  case "$k" in
    energy|rate|duration|work)
      where=$(git ls-files '*.rye' -z | xargs -0 grep -lE "^[[:space:]]*(pub )?const $nm[: ]" 2>/dev/null | head -1)
      [ -n "$where" ] || where='(derived)'
      ;;
    *) where='' ;;
  esac
  case "$k" in
    energy)   n_energy=$((n_energy + 1));   echo "detail: energy $nm $where" ;;
    rate)     n_rate=$((n_rate + 1));       echo "detail: rate $nm $where" ;;
    duration) n_duration=$((n_duration + 1)); echo "detail: duration $nm $where" ;;
    work)     n_work=$((n_work + 1));       echo "detail: work $nm $where" ;;
    *)        n_extent=$((n_extent + 1)) ;;
  esac
done < "$names_file"

echo "bound_names=$names"
echo "bound_sites=$sites"
echo "energy_names=$n_energy"
echo "rate_names=$n_rate"
echo "duration_names=$n_duration"
echo "work_names=$n_work"
echo "extent_names=$n_extent"

# The partition invariant. Every distinct name lands in exactly one class, so the five
# class counts sum to the total. A regex edited into overlapping or missing coverage
# breaks this sum, and the census refuses rather than reporting a number that has
# quietly stopped adding up.
total=$((n_energy + n_rate + n_duration + n_work + n_extent))
if [ "$total" -ne "$names" ]; then
  echo "detail: partition sum=$total names=$names"
  echo "verdict=partition_broken"
  exit 1
fi

# ---- the second reading: is a time number ever checked the way an extent number is? ----
#
# The classes above read constants written in TAME's declared bound form, `max_*` or
# `min_*`. A poll interval is rarely written that way -- it is a plain constant like
# `poll_rest_ms` -- so the first reading cannot see it at all. This leg finds every
# tracked Rye constant carrying a time unit outside the bound form, then asks the same
# question of both populations: does the name ever appear on a line that asserts or
# returns a named error?
#
# THE PROXY, named before its numbers: this is a text test. A name on an `assert(` line
# may be the subject of the assert or merely mentioned beside it, and the scan cannot
# tell them apart. What makes the reading worth taking is that the SAME proxy runs over
# both populations, so the two rates are comparable even where either absolute number
# is loose.
#
# THE SAMPLE BOUND, declared before the walk per the seam convention: the extent control
# takes the first `extent_sample_bound` names in sort order from the `*_bytes`, `*_len`,
# and `*_size` families, so the control is the same size as the time population and the
# comparison is not a large set against a small one.
extent_sample_bound=44

time_file=$(mktemp 2>/dev/null || echo "./.bound_kind_time.$$")
ctl_file=$(mktemp 2>/dev/null || echo "./.bound_kind_ctl.$$")
guard_file=$(mktemp 2>/dev/null || echo "./.bound_kind_guard.$$")
trap 'rm -f "$names_file" "$sites_file" "$time_file" "$ctl_file" "$guard_file"' EXIT INT TERM

git ls-files '*.rye' -z 2>/dev/null | xargs -0 grep -hoE '^[[:space:]]*(pub )?const [a-z0-9_]+' 2>/dev/null \
  | sed -E 's/^[[:space:]]*(pub )?const //' | sort -u \
  | grep -E '_(ms|us|ns|sec|secs|seconds|millis)$|interval|_period$|cadence|_hz$|duty|_rest$|_delay$|_sleep' \
  | grep -vE '^(max|min)_' > "$time_file" || true

git ls-files '*.rye' -z 2>/dev/null | xargs -0 grep -hoE '^[[:space:]]*(pub )?const max_[a-z0-9_]*(bytes|len|size)' 2>/dev/null \
  | sed -E 's/^[[:space:]]*(pub )?const //' | sort -u | head -"$extent_sample_bound" > "$ctl_file"

# One pass over the tree collects every asserting or erroring line, so the two
# populations are then tested against one cached corpus rather than re-walking 1,939
# files per name -- which is what made a first draft of this leg take minutes.
git ls-files '*.rye' -z 2>/dev/null | xargs -0 grep -hE '(assert\(|return error\.)' 2>/dev/null > "$guard_file" || true

count_guarded() {
  g=0
  while IFS= read -r c; do
    [ -n "$c" ] || continue
    if grep -qE "[^a-z0-9_]${c}[^a-z0-9_]|[^a-z0-9_]${c}\$" "$guard_file" 2>/dev/null; then g=$((g + 1)); fi
  done < "$1"
  echo "$g"
}

time_total=$(wc -l < "$time_file" | tr -d ' ')
ctl_total=$(wc -l < "$ctl_file" | tr -d ' ')

# An empty control makes the comparison meaningless, and an empty assert corpus means the grep
# that gathers it found nothing in 1,939 files -- which is a broken instrument rather than a tree
# without asserts. Both refuse by name. An empty TIME list is tolerated, because a tree with no
# time constants is a real answer and refusing it would be the opposite mistake.
[ "$ctl_total" -gt 0 ] || { echo "verdict=no_extent_control"; exit 2; }
[ -s "$guard_file" ] || { echo "verdict=no_assert_corpus"; exit 2; }
time_guarded=$(count_guarded "$time_file")
ctl_guarded=$(count_guarded "$ctl_file")

echo "time_consts=$time_total"
echo "time_consts_guarded=$time_guarded"
echo "extent_control=$ctl_total"
echo "extent_control_guarded=$ctl_guarded"
echo "extent_sample_bound=$extent_sample_bound"

echo "verdict=ok"
exit 0
