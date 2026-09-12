#!/bin/sh
# tools/fixtures/t/tier_cost_drift_census.sh -- does a roster row's stated cost still hold?
#
# WHY THIS EXISTS. Every `tier` field in construction/standing-equipment.kyri is a cost
# decision: `lap` pays on every roster run, `cadence` pays every fifth round. The roster's
# own header says COST DECIDES THE TIER, and dozens of rows justify their tier with a
# measured figure written into a comment -- "measured 3s", "105s measured here 20260829",
# "runs 111 rungs in 8m31s". Those figures are FREE in the Gauge sense: no guard holds
# them still, so each is true on the day it was typed and unchecked every day after.
#
# One row already carries the comparison by hand -- comlink_topology reads "12s FROM
# 20260906.093000 ... The elder 2s above is kept as what the row cost when it was seated".
# A lantern that fires twice becomes a loom, so this census reads every row that way.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# WHAT IT COMPARES. Stated figures come from the comment text of a guard's record -- the
# preamble block above `guard NAME` and any inline comment inside it. Measured seconds come
# from this pier's own run card, construction/standing-equipment-runs.kyri, whose lines read
# `ran <name> <stamp> <verdict> <tier> <seconds>`; that card is untracked and per pier on
# purpose, so a fresh clone honestly reads nothing measured rather than another machine's
# memory. Pass a standing_equipment_run transcript as the one argument to read `<guard>
# <verdict> <N>s` lines instead.
#
# THE ACCRETION RULE, stated before the numbers: a row KEEPS its elder figures on purpose,
# so a row often states more than one. A row therefore AGREES when today's measurement falls
# inside the closed range of everything it states, drifts OVER above that range, and UNDER
# below it. Reading only the newest figure would call every honest accretion a drift.
#
# THE DECLARED LIMIT: this reads a NUMBER NEXT TO A UNIT inside a row's comment, and it
# cannot tell whose cost that number is. The standing counterexample is `sow_allow_reach`,
# whose preamble names "778s" for a whole cold endurance run rather than for itself. So every drifted
# row prints as a detail line with both numbers, and a hand confirms before anything moves.
#
# THE CARD COUNTS WHOLE SECONDS, so a row stating 0.6s and measured at 1 has drifted by
# rounding rather than by cost. A row whose stated high sits under two seconds is counted as
# `below_resolution` and compared against nothing, since calling that a drift would spend the
# word on the instrument's own grain.
#
# ACCRETION BUYS HONESTY AND SPENDS THE CHECK. A row keeping four elder figures states a
# range so wide that almost any measurement falls inside it, and `rows_range_wide` counts the
# rows whose stated high is four times their stated low or more. Those rows are honest and
# unfalsifiable at once, which is worth seeing rather than averaging away.
#
# WHAT IT DOES NOT ATTRIBUTE. The roster header states figures for the choirs -- one line
# naming two guards and two costs -- and this census reads a guard's OWN record alone. Giving
# both figures to both names would buy coverage with a wrong number, so the header is read past
# and `caravan_suite` reads as stating nothing.
#
# THE UNMEASURED ARE THE POINT, NOT THE REMAINDER. A cold endurance run runs the lap tier alone, so a
# `cadence` row's stated cost goes unchecked by every cold transcript -- and the cadence rows
# are where the largest figures live. That count is reported as its own value.
set -eu

[ -d .git ] || { echo "verdict=not_a_repo"; exit 2; }

roster=construction/standing-equipment.kyri
transcript=${1:-construction/standing-equipment-runs.kyri}

[ -f "$roster" ] || { echo "verdict=no_roster"; exit 2; }
[ -f "$transcript" ] || { echo "verdict=no_transcript"; exit 2; }

awk -v transcript="$transcript" '
function secs_of(num, unit,   v) {
  v = num + 0
  if (unit == "ms") return v / 1000
  if (unit == "m")  return v * 60
  return v
}
# harvest every "number + time unit" from one line of comment text
function harvest(line, name,   s, n, num, unit, mins, rest) {
  s = line
  # NmMMs -- a minutes-and-seconds pair, taken whole before the bare forms
  while (match(s, /[0-9]+m[0-9]+s/)) {
    n = substr(s, RSTART, RLENGTH)
    split(n, p, "m"); sub(/s$/, "", p[2])
    record(name, p[1] * 60 + p[2])
    s = substr(s, RSTART + RLENGTH)
  }
  s = line
  while (match(s, /[0-9]+(\.[0-9]+)?[ ]?(ms|s|seconds)([^a-z0-9]|$)/)) {
    n = substr(s, RSTART, RLENGTH)
    rest = s
    s = substr(s, RSTART + RLENGTH)
    if (match(n, /^[0-9]+(\.[0-9]+)?/)) num = substr(n, RSTART, RLENGTH); else continue
    unit = "s"
    if (n ~ /ms/) unit = "ms"
    # a bare stamp such as 20260825 never reaches here: it carries no adjacent unit
    record(name, secs_of(num, unit))
  }
}
function record(name, v) {
  if (!(name in lo) || v < lo[name]) lo[name] = v
  if (!(name in hi) || v > hi[name]) hi[name] = v
  figs[name] = figs[name] + 1
}
BEGIN { buf = "" }
# roster pass
FNR == NR {
  if ($0 ~ /^#/) { buf = buf " " $0; next }
  if ($0 ~ /^guard /) {
    cur = $2
    guards[cur] = 1
    order[++nguards] = cur
    tier[cur] = "lap"          # a record naming no tier runs every roster run
    harvest(buf, cur)
    buf = ""
    next
  }
  if ($0 ~ /^tier /) { split($0, t, "#"); split(t[1], w, " "); tier[cur] = w[2]
                       if (t[2] != "") harvest(t[2], cur); next }
  if ($0 ~ /^[a-z_]+ /) { next }
  if ($0 ~ /^[[:space:]]*$/) { buf = ""; cur = "" }
  next
}
END {
  while ((getline line < transcript) > 0) {
    if (line ~ /^ran [a-z_][a-z_0-9]* [0-9.]+ [a-z]+ [a-z]+ [0-9]+( [0-9-]+)?$/) {
      split(line, f, " ")
      meas[f[2]] = f[6] + 0
      total_measured += f[6] + 0
      measured_rows++
    } else if (line ~ /^[a-z_][a-z_0-9]* [a-z]+ [0-9]+s( [0-9-]+ms)?$/) {
      split(line, f, " ")
      m = f[3]; sub(/s$/, "", m)
      meas[f[1]] = m + 0
      total_measured += m + 0
      measured_rows++
    }
  }
  for (i = 1; i <= nguards; i++) {
    g = order[i]
    has_fig = (g in figs)
    has_meas = (g in meas)
    if (has_fig) rows_with_figures++
    if (has_fig && has_meas && hi[g] < 2) {
      below_resolution++
    } else if (has_fig && has_meas) {
      compared++
      if (meas[g] > hi[g]) { over++;  printf "detail: over %s stated %.3g-%.3gs measured %ds tier %s\n", g, lo[g], hi[g], meas[g], tier[g] }
      else if (meas[g] < lo[g]) { under++; printf "detail: under %s stated %.3g-%.3gs measured %ds tier %s\n", g, lo[g], hi[g], meas[g], tier[g] }
      else agrees++
    } else if (has_fig && !has_meas) {
      unmeasured++
      if (tier[g] == "cadence") unmeasured_cadence++
      stated_unmeasured += hi[g]
      printf "detail: unmeasured %s stated %.3g-%.3gs tier %s\n", g, lo[g], hi[g], tier[g]
    } else if (!has_fig) {
      no_figure++
    }
    if (has_fig && lo[g] > 0 && hi[g] / lo[g] >= 4) range_wide++
    if (tier[g] == "cadence") { rows_cadence++; if (has_fig) figures_cadence++ }
    else                      { rows_lap++;     if (has_fig) figures_lap++ }
  }
  printf "guards=%d\n", nguards
  printf "rows_with_figures=%d\n", rows_with_figures + 0
  printf "rows_no_figure=%d\n", no_figure + 0
  printf "compared=%d\n", compared + 0
  printf "below_resolution=%d\n", below_resolution + 0
  printf "agrees=%d\n", agrees + 0
  printf "over=%d\n", over + 0
  printf "under=%d\n", under + 0
  printf "unmeasured=%d\n", unmeasured + 0
  printf "unmeasured_cadence=%d\n", unmeasured_cadence + 0
  printf "rows_lap=%d\n", rows_lap + 0
  printf "rows_cadence=%d\n", rows_cadence + 0
  printf "figures_lap=%d\n", figures_lap + 0
  printf "figures_cadence=%d\n", figures_cadence + 0
  printf "rows_range_wide=%d\n", range_wide + 0
  printf "measured_rows=%d\n", measured_rows + 0
  printf "measured_seconds=%d\n", total_measured + 0
  printf "stated_seconds_unmeasured=%d\n", stated_unmeasured + 0
  print "verdict=ok"
}
' "$roster" /dev/null
