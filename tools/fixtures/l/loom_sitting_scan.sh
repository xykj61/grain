#!/bin/sh
# tools/fixtures/l/loom_sitting_scan.sh -- can this key PROVE a change, and how small a one?
#
#   sh tools/fixtures/l/loom_sitting_scan.sh <key>
#   sh tools/fixtures/l/loom_sitting_scan.sh <key> --explain      # one row per sitting
#   LOOM_FAMILY=roster sh tools/fixtures/l/loom_sitting_scan.sh seconds
#
# WHY THIS EXISTS. `tools/l/loom_trend.sh` reads a loom key back across the journal and ends on
# `direction=rising|falling|level`. That one word is doing two jobs: it reports that the last value
# differs from the first, and a reader takes it as evidence the WORK changed. On a pier eight ships
# share, those are different facts. `active-designing/date/20260917/20260917-054941_the-unit-that-survives-the-pier.md`
# measured the gap on this metal: a wall-clock median of identical work moved 306 parts per thousand
# across six sittings while its CPU median moved 7, so a wall key's slope is mostly the pier.
#
# The live journal shows the same thing in one line. `LOOM_FAMILY=roster sh tools/l/loom_trend.sh
# seconds --summary` reads 171 values from 5 to 9,882 and answers `direction=rising`. Three orders
# of magnitude is not a trend; it is several workloads sharing one key.
#
# THE READING. A SITTING is one day shelf -- the `session-logs/date/YYYYMMDD/` directory the log was
# born on. For each sitting this takes its own MEDIAN and its own SPREAD, then prints two numbers
# side by side, both in parts per thousand (ppt) of a median:
#
#   within_ppt   the median sitting's own spread -- how far this key wanders when nothing changed
#   across_ppt   how far the sitting medians themselves range -- everything that did change, plus
#                whatever the pier contributed between sittings
#
# `within_ppt` is the RESOLUTION FLOOR. A claimed improvement smaller than it cannot be told from
# the noise of the sitting it was measured in, whatever the trend line says.
#
# THE DAY IS A PROXY AND ITS ERROR HAS A DIRECTION. A day holds many hours, and the pier's load
# moves inside one, so grouping by day makes within_ppt larger than true repeat-to-repeat noise.
# That inflates the floor, so this reading refuses to call a small change readable more often than
# a finer grouping would -- the safe direction, and the reason a coarse proxy is acceptable here.
#
# THE SINGLE-VALUE SITTING IS THE TRAP, AND IT IS NAMED RATHER THAN AVERAGED. A sitting holding one
# value has a spread of zero, and that zero means UNMEASURED rather than noise-free. Averaging it
# into `within_ppt` would drag the floor toward zero and make every key look sharper than it is.
# So singleton sittings are counted apart, excluded from `within_ppt`, and kept for `across_ppt`
# where a single median is a legitimate point. A key with no multi-value sitting prints
# `within_ppt=na` and refuses rather than printing a confident zero. That fault -- one value
# standing for two conditions -- is this seat's own red from `20260917.054941`, caught here before
# it was written.
#
# WHAT THE VERDICT DOES AND DOES NOT SAY.
#   `noise_dominates`      across_ppt <= within_ppt. Movement between sittings is no larger than the
#                          wander inside one, so NO claim of movement in this key is readable here.
#   `across_exceeds_noise` across_ppt > within_ppt. Something ranges further than the noise.
#
# THE VERDICT IS A COMPARISON RATHER THAN A BLESSING, and the word is chosen so it cannot be read
# as one. `across_exceeds_noise` says the sitting medians range wider than a sitting wanders; it
# does NOT say an improvement happened, and this reading cannot tell a real improvement from a key
# merging workloads that were never one population. `spread_class` is the honest hint and stands as
# its own field for exactly that reason -- `suspect_mixed` once the sitting medians range wider than
# their own median (across_ppt > 1000), since one workload that both doubles and halves about its
# own center is already at that edge. Two facts, two fields; braiding them into one word is the
# fault this whole instrument exists to repair.
#
# THE SCALE IS ITS OWN FIELD, and the journal taught this on the first real run. `red` -- the count
# of red guards in a roster pass, running 0 to 3 -- read `within_ppt=3000`, the noisiest figure in
# the journal, for a purely arithmetic reason: one whole unit of a median of 1 is 1,000 ppt. So
# `scale` prints the median of the sitting medians and `scale_class` reads `coarse_integer` below
# ten, where a ppt figure is measuring the counting step rather than the measurement. Spread and
# scale are two facts and they get two fields.
#
# IT REPORTS AND GATES NOTHING. Whether a key is comparable is a fact about this pier and the
# habits of eight ships, never a fault of any lane. `tools/l/loom_sitting_witness.rish` proves the
# instrument answers correctly; it holds no ceiling over the journal.
#
# WHAT THIS DOES NOT READ. Whether a key's values mean what their writer thought. Any grouping but
# the day -- an hour grouping is a real question and wants its own run. Non-numeric values, which
# are carried in the count and skipped by every statistic, since a median of a witness name is not
# a fact. And the pier at any other moment: every figure is FREE and moves with the journal.
#
# BOUNDS: LOOM_MAX_LOGS logs (default 4,000); LOOM_MAX_SITTINGS sittings (default 1,000).
#
# No network, no key, no funds, no device. Reads tracked session logs and writes nothing outside a
# temporary directory it removes.

set -eu

# THE SIBLING IS SOURCED FROM THIS FILE'S OWN DIRECTORY, never from the corpus root. A pen sets
# LOOM_ROOT to a throwaway repository holding session logs and no tools, so a root-relative source
# would make the instrument unprovable in exactly the place it must be proven.
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=${LOOM_ROOT:-$(CDPATH= cd -- "$here/../../.." && pwd)}
cd "$root"

. "$here/loom_values.sh"

KEY=${1:-}
MODE=${2:-summary}
[ -n "$KEY" ] || { echo "usage: loom_sitting_scan.sh <key> [--explain]" >&2; exit 2; }

MAX_SITTINGS=${LOOM_MAX_SITTINGS:-1000}
# invariant: the mixed-population hint fires once the sitting medians range wider than their own
# median, because a single workload that both doubles and halves about its center is already there.
MIXED_PPT=1000
# invariant: a median under ten makes one whole unit worth 100 ppt or more, so the ratio below is
# reading the counting step rather than the measurement.
COARSE_SCALE=10

work=$(mktemp -d "${TMPDIR:-/tmp}/loom-sitting.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

loom_values "$KEY" "$work/values.txt" || exit 2

total=$(grep -c . "$work/values.txt" 2>/dev/null || true)
[ -n "$total" ] || total=0
if [ "$total" -eq 0 ]; then
  echo "key=$KEY"
  echo "family=${LOOM_FAMILY:-none}"
  echo "values=0"
  echo "within_ppt=na"
  echo "across_ppt=na"
  echo "verdict=key_never_written"
  exit 0
fi

# The sitting is the day directory in the log's own path, which is the shelf it was born on.
awk -F'\t' '{ d=$3; sub(/\/[^\/]*$/, "", d); sub(/^.*\//, "", d); print d "\t" $2 }' \
  "$work/values.txt" | sort > "$work/bysitting.txt"

awk -F'\t' -v key="$KEY" -v fam="${LOOM_FAMILY:-none}" -v mode="$MODE" \
    -v maxsit="$MAX_SITTINGS" -v mixed="$MIXED_PPT" -v coarse="$COARSE_SCALE" '
  function median(arr, n,   m) {
    # invariant: an even count takes the mean of the two middle values, so one outlying sample
    # cannot decide the center by itself.
    if (n % 2) return arr[(n + 1) / 2]
    m = n / 2
    return (arr[m] + arr[m + 1]) / 2
  }
  function ppt(spread, mid) {
    # invariant: a median of zero has no scale to be a fraction of, so the reading refuses rather
    # than dividing -- a spread of "infinity ppt" would read as a very noisy key instead of an
    # unusable one.
    if (mid <= 0) return -1
    return spread * 1000.0 / mid
  }
  {
    day = $1; v = $2
    values++
    if (v !~ /^-?[0-9]+(\.[0-9]+)?$/) { nonnumeric++; next }
    if (!(day in seen)) { seen[day] = 1; days[++nd] = day }
    cnt[day]++
    vals[day, cnt[day]] = v + 0
  }
  END {
    printf "key=%s\n", key
    printf "family=%s\n", fam
    printf "values=%d\n", values + 0
    printf "numeric=%d\n", values - nonnumeric
    printf "non_numeric=%d\n", nonnumeric + 0

    if (nd > maxsit) {
      printf "sittings=%d\nverdict=refused_over_bound -- %d sittings exceeds LOOM_MAX_SITTINGS=%d\n", nd, nd, maxsit
      exit 2
    }

    nmed = 0; nwithin = 0; singles = 0
    for (i = 1; i <= nd; i++) {
      day = days[i]; n = cnt[day]
      for (j = 1; j <= n; j++) one[j] = vals[day, j]
      # insertion sort: a sitting is small, and this keeps the reading free of a sort dependency.
      for (j = 2; j <= n; j++) { t = one[j]; k = j - 1
        while (k >= 1 && one[k] > t) { one[k + 1] = one[k]; k-- }
        one[k + 1] = t }
      mid = median(one, n)
      spread = one[n] - one[1]
      meds[++nmed] = mid
      if (n >= 2) {
        p = ppt(spread, mid)
        if (p >= 0) withins[++nwithin] = p
        else scaleless++
      } else singles++
      if (mode == "--explain")
        printf "sitting\t%s\tn=%d\tmedian=%s\tspread=%s\tppt=%s\n", day, n, mid, spread, (n >= 2 ? sprintf("%.1f", ppt(spread, mid)) : "na")
    }

    printf "sittings=%d\n", nd + 0
    printf "sittings_multi=%d\n", nwithin + scaleless
    printf "sittings_singleton=%d\n", singles + 0

    if (nd < 2) {
      printf "within_ppt=na\nacross_ppt=na\nresolution_ppt=na\nspread_class=na\n"
      printf "verdict=insufficient_sittings -- a cross-sitting reading needs two sittings and this key has %d\n", nd
      exit 0
    }

    for (j = 2; j <= nmed; j++) { t = meds[j]; k = j - 1
      while (k >= 1 && meds[k] > t) { meds[k + 1] = meds[k]; k-- }
      meds[k + 1] = t }
    amid = median(meds, nmed)
    aspread = meds[nmed] - meds[1]
    across = ppt(aspread, amid)
    if (across < 0) {
      printf "within_ppt=na\nacross_ppt=na\nresolution_ppt=na\nspread_class=na\n"
      printf "verdict=refused_no_scale -- the median of the sitting medians is %s, which no spread can be a fraction of\n", amid
      exit 0
    }
    printf "across_ppt=%.1f\n", across
    printf "scale=%g\n", amid
    # invariant: below a median of 10 the counting step itself is already 100 ppt or more, so a
    # parts-per-thousand reading there measures quantization rather than variation. Naming the scale
    # is a separate fact from naming the spread, and merging them would make a key like `red` -- a
    # count running 0 to 3 -- read as the noisiest thing in the journal.
    printf "scale_class=%s\n", (amid < coarse ? "coarse_integer" : "fine")

    if (nwithin == 0) {
      printf "within_ppt=na\nresolution_ppt=na\n"
      printf "spread_class=%s\n", (across > mixed ? "suspect_mixed" : "one_population")
      printf "verdict=insufficient_within -- %d sitting(s) hold one value each and none holds two, so the noise floor is UNMEASURED rather than zero\n", singles
      exit 0
    }
    for (j = 2; j <= nwithin; j++) { t = withins[j]; k = j - 1
      while (k >= 1 && withins[k] > t) { withins[k + 1] = withins[k]; k-- }
      withins[k + 1] = t }
    within = median(withins, nwithin)
    printf "within_ppt=%.1f\n", within
    printf "resolution_ppt=%.1f\n", within
    printf "ratio=%.2f\n", (within > 0 ? across / within : 0)
    printf "spread_class=%s\n", (across > mixed ? "suspect_mixed" : "one_population")
    printf "verdict=%s\n", (across > within ? "across_exceeds_noise" : "noise_dominates")
  }
' "$work/bysitting.txt"
