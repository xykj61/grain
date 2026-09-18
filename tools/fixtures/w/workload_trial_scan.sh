#!/bin/sh
# tools/fixtures/w/workload_trial_scan.sh -- can ROW 12 run at all? Row 12 of
# active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md is the last row of the twelve
# whose subject is the other eleven, and it proposes a method rather than a mechanism:
#
#   "Among the eleven above, the smallest trial that touches metal goes first, and its result
#    funds the ordering of everything after it."
#
# Its falsifier: "The trial's number sits inside the run-to-run spread of the baseline, which
# would leave the ordering exactly where it started."
#
# A falsifier comparing a trial's number against a baseline spread needs THREE things before it
# can fire: a number the trial produces, a number to compare it against, and a spread narrow
# enough that the difference between them is visible. This scan reads all three, and each is a
# separate reading because they fail separately.
#
#   READING 1 -- WHAT ACTUALLY FUNDED THE ORDERING. Row 12 claims the ordering is funded by one
#   trial that TOUCHES METAL, run after the first green. Ten rows now carry landed errata, and
#   each names the instrument that produced its reading. Every `tools/` path named inside an
#   erratum line is classified by what it opens: `host` reads a facility outside the tree
#   (/sys, /proc), `metal` executes or compiles a built binary, `bytes` reads tracked sources,
#   and `arithmetic` opens nothing at all. The classification is by grep over the instrument's
#   own source, in that order, since a scan doing two of these is named by the heaviest.
#
#   A `tools/` path is the instrument and a path elsewhere is the SUBJECT -- row 2's erratum
#   names `caravan/capabilities.rye`, which is the code it read rather than the thing that read
#   it. That rule is checkable and is why the reading is drawn this way.
#
#   READING 2 -- THE OPERAND THE FALSIFIER NEEDS. A trial's number is compared against something,
#   and the something is an effect size some row proposed: a percentage, a multiplier, a factor.
#   Each of the twelve row bodies is read for a numeric effect claim. A count of zero means row
#   12's falsifier has no operand -- there is no proposed number for a measured one to sit inside
#   or outside of -- which is a structural refusal rather than a hard trial.
#
#   READING 3 -- THE FLOOR THIS PIER PUTS UNDER ANY SINGLE TRIAL. A fixed, deterministic,
#   CPU-bound workload is run BASELINE_RUNS times and its wall milliseconds are read; then
#   TRIAL_RUNS further runs of the SAME workload are taken as "trials". Every trial is measuring
#   a change of exactly zero, so any trial landing outside the baseline band is the pier's noise
#   wearing a result's clothes. The share landing INSIDE is reported, and so is the relative
#   spread, which is the smallest effect a single trial could distinguish here.
#
# WHAT WOULD FALSIFY THE READING. A funding classification finding metal trials behind the
# landed re-ranks would say row 12's mechanism did fire. A row naming an effect size would give
# the falsifier its operand. A relative spread near zero would say a single trial resolves fine
# differences on this pier, and row 12 could be run as written.
#
# WHAT THIS DOES NOT READ. Whether any of the twelve ideas is TRUE -- that is each row's own
# erratum's job. Whether a longer or repeated trial would resolve what a single one cannot; it
# plainly would, and that is a different method from the one row 12 wrote down. Energy, which
# `energy_instrument_scan.sh` already answered `joule_source=none` for on this pier. And the
# pier's load at any other moment: reading 3 is FREE and moves with whatever the other seven
# ships are doing.
#
# USAGE
#   sh tools/fixtures/w/workload_trial_scan.sh                    # the reading
#   sh tools/fixtures/w/workload_trial_scan.sh --page PATH        # read another page
#   sh tools/fixtures/w/workload_trial_scan.sh --runs 8 --trials 4
#   sh tools/fixtures/w/workload_trial_scan.sh --no-timing        # readings 1 and 2 only
#
# Readings 1 and 2 open one page and the instruments it names. Reading 3 opens no file at all.

set -eu

PAGE="active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md"
BASELINE_RUNS=15        # bounded: 15 x ~0.5s keeps reading 3 under ten seconds on this pier
TRIAL_RUNS=10           # bounded: enough to read a share to the nearest ten percent
MAX_RUNS=60             # bounded: refuse a request past this, where the reading costs a minute
WORK_ITERS=3000000      # bounded: calibrated to ~0.5s of awk arithmetic on this pier
SHORT_RUNS=4            # bounded: the small-baseline comparison; four is a plausible hurried read
DO_TIMING=yes

while [ $# -gt 0 ]; do
  case "$1" in
    --page) PAGE="${2:?--page wants a path}"; shift 2 ;;
    --runs) BASELINE_RUNS="${2:?--runs wants a count}"; shift 2 ;;
    --trials) TRIAL_RUNS="${2:?--trials wants a count}"; shift 2 ;;
    --no-timing) DO_TIMING=no; shift ;;
    *) echo "$0: unknown flag $1" >&2; exit 2 ;;
  esac
done

for n in "$BASELINE_RUNS" "$TRIAL_RUNS"; do
  case "$n" in
    ''|*[!0-9]*) echo "$0: run count not a count: $n" >&2; exit 2 ;;
  esac
  if [ "$n" -lt 2 ] || [ "$n" -gt "$MAX_RUNS" ]; then
    echo "detail: run count $n outside [2, $MAX_RUNS]"
    echo "verdict=unreadable"
    exit 0
  fi
done

# WEIGHT ORDER: arithmetic < bytes < metal < host. Row 12's question is whether the ordering was
# funded by something that TOUCHES THE MACHINE, so the two readings that do -- executing a built
# binary, and reading a host facility -- sit above the two that open only this tree's own bytes.
weight_of() {
  case "$1" in
    host) echo 4 ;;
    metal) echo 3 ;;
    bytes) echo 2 ;;
    *) echo 1 ;;
  esac
}

heavier() {
  if [ "$(weight_of "$1")" -ge "$(weight_of "$2")" ]; then echo "$1"; else echo "$2"; fi
}

classify_one() {
  _f="$1"
  case "$_f" in
    *.rye) echo metal; return ;;
  esac
  _body=$(sed 's/^[[:space:]]*#.*$//' "$_f")
  if printf '%s\n' "$_body" | grep -qE '/sys/|/proc/|powercap|rapl'; then
    echo host
  elif printf '%s\n' "$_body" | grep -qE '(^|[^a-zA-Z_/])(rye|glow_run|zig)[[:space:]]+(run|build)|/bin/(rye|rishi|glow[a-z_]*)|-femit-bin|rye_build\.sh|\$ZIG|[a-z]+/bin/[a-zA-Z0-9_-]+'; then
    echo metal
  elif printf '%s\n' "$_body" | grep -qE 'git (ls-files|log|grep|show)|(^|[^a-zA-Z_])find[[:space:]]|sha3|[a-z_]+/[a-zA-Z0-9_.-]+\.(kyri|md|bron|rye|rish)'; then
    echo bytes
  else
    echo arithmetic
  fi
}

# A DELEGATE IS A PATH THIS INSTRUMENT INVOKES, never a path it merely names. The difference is
# load-bearing: `capability_lattice_scan.sh` NAMES `caravan/capabilities.rye` because that source
# is the population it reads, and reading a file's text is `bytes` however the file is written.
# So the match wants an interpreter word immediately ahead of the path -- `sh <path>`, the Rishi
# `run ["sh" "<path>"]` form, or `rye run <path>` -- and a bare mention is read past.
delegates_of() {
  sed 's/^[[:space:]]*#.*$//' "$1" \
    | grep -oE '(sh|bash|run)[]"'"'"'[:space:]]+["'"'"']?(tools|glow|rye|mantra|caravan|tally)/[a-zA-Z0-9_/.-]+\.(sh|rish|rye)' \
    | grep -oE '(tools|glow|rye|mantra|caravan|tally)/[a-zA-Z0-9_/.-]+\.(sh|rish|rye)' \
    | sort -u
}

echo "instrument=workload_trial"
echo "page=$PAGE"

if [ ! -f "$PAGE" ]; then
  echo "detail: page absent -- $PAGE"
  echo "verdict=unreadable"
  exit 0
fi

# -- reading 1 -- what funded the landed re-ranks ------------------------------------------------
# An erratum line opens with "**Row N erratum:**" or "**Row N second erratum:**". Instruments are
# the `tools/` paths inside such a line; a path elsewhere in the line is the subject it read.

errata_found=0
instruments=""
for line_no in $(grep -n '^\*\*Row [0-9][0-9]* \(second \)\?erratum:\*\*' "$PAGE" | cut -d: -f1); do
  errata_found=$(( errata_found + 1 ))
  line=$(sed -n "${line_no}p" "$PAGE")
  found=$(printf '%s\n' "$line" | grep -oE '`tools/[a-zA-Z0-9_/.-]+\.(sh|rish|rye)`' | tr -d '`' || true)
  [ -n "$found" ] && instruments="$instruments $found"
done

instruments=$(printf '%s\n' $instruments | sort -u)

funded_host=0
funded_metal=0
funded_bytes=0
funded_arithmetic=0
funded_absent=0
instruments_named=0

SELF="tools/fixtures/w/workload_trial_scan.sh"

for ins in $instruments; do
  # AN INSTRUMENT CANNOT CLASSIFY ITSELF. This scan's own classifier holds every marker it looks
  # for -- the host pattern, the compile pattern, the tracked-read pattern -- as grep arguments,
  # so reading its own body counts its questions as its answers. It read `host` on the lap its own
  # erratum landed, which is the fault named rather than hidden: the page names it, and it reads
  # past itself by name.
  if [ "$ins" = "$SELF" ]; then
    echo "detail: $ins read past -- an instrument cannot classify itself"
    continue
  fi
  instruments_named=$(( instruments_named + 1 ))
  # A STALE TOOL PATH IS RESOLVED RATHER THAN READ AS ABSENT. The page carries a one-clock stamp in
  # its own basename, so it is testimony and keeps every path it wrote (stamp-and-name); `tools/`
  # folds by FIRST SPRIG LETTER, and that fold is a pure function of the basename, so a moved
  # instrument is recomputed here rather than looked up in a table. `bearing_quorum_scan.sh` moved
  # from the `m` room to the `b` its own name computes on `20260915`, and the erratum naming the
  # elder path is correct testimony. The two-letter room is tried second, exactly as
  # tools/t/tool_path_resolve.rish does, since a letter standing over bound splits one deeper.
  if [ ! -f "$ins" ]; then
    _base=${ins##*/}
    _dir=${ins%/*}
    _dir=${_dir%/*}
    _l1=$(printf '%s' "$_base" | cut -c1)
    _l2=$(printf '%s' "$_base" | cut -c1-2)
    if [ -f "$_dir/$_l1/$_base" ]; then
      echo "detail: instrument resolved -- $ins now stands at $_dir/$_l1/$_base"
      ins="$_dir/$_l1/$_base"
    elif [ -f "$_dir/$_l2/$_base" ]; then
      echo "detail: instrument resolved -- $ins now stands at $_dir/$_l2/$_base"
      ins="$_dir/$_l2/$_base"
    fi
  fi
  if [ ! -f "$ins" ]; then
    funded_absent=$(( funded_absent + 1 ))
    echo "detail: instrument named and absent -- $ins"
    continue
  fi
  # Classify from EXECUTABLE lines only. A header comment naming the page an instrument was
  # written for would otherwise read as a file the instrument opens, which is the one false
  # positive this family is prone to: these scans all cite each other in prose.
  kind=$(classify_one "$ins")
  # FOLLOW ONE DELEGATION HOP, and exactly one. Every witness in this family delegates its real
  # work to a control, and a witness read alone reads arithmetic while the control beneath it
  # drives a compiler. One hop is bounded, terminates, and is what the naming convention here
  # actually supports; a deeper walk would want a cycle guard and buys nothing measured.
  for dele in $(delegates_of "$ins"); do
    [ -f "$dele" ] || continue
    dkind=$(classify_one "$dele")
    kind=$(heavier "$kind" "$dkind")
  done
  case "$kind" in
    host) funded_host=$(( funded_host + 1 )) ;;
    metal) funded_metal=$(( funded_metal + 1 )) ;;
    bytes) funded_bytes=$(( funded_bytes + 1 )) ;;
    arithmetic) funded_arithmetic=$(( funded_arithmetic + 1 )) ;;
  esac
  echo "detail: $ins funded=$kind"
done

reranks=$(grep -cE 'Recommended (\*\*)?(re-rank|re-aim|disposition)' "$PAGE" || true)

echo "errata_found=$errata_found"
echo "instruments_named=$instruments_named"
echo "funded_host=$funded_host"
echo "funded_metal=$funded_metal"
echo "funded_bytes=$funded_bytes"
echo "funded_arithmetic=$funded_arithmetic"
echo "funded_absent=$funded_absent"
if [ "$funded_absent" -eq 0 ]; then
  echo "instruments_all_present=yes"
else
  echo "instruments_all_present=no"
fi
echo "reranks_recommended=$reranks"

# -- reading 2 -- the operand the falsifier needs -------------------------------------------------
# A numeric effect claim is a percentage, a multiplier, or a factor: the shape a trial's number is
# compared against. Row bodies run from the first "### <n>." heading to the ranking table.

body_start=$(grep -n '^### 1\.' "$PAGE" | head -1 | cut -d: -f1 || true)
body_end=$(grep -n '^## The ranking' "$PAGE" | head -1 | cut -d: -f1 || true)

if [ -z "$body_start" ] || [ -z "$body_end" ]; then
  echo "detail: row bodies unlocatable -- no '### 1.' heading or no '## The ranking'"
  rows_with_effect_size=unreadable
  echo "rows_read=0"
  echo "rows_with_effect_size=unreadable"
else
  rows_read=$(sed -n "${body_start},${body_end}p" "$PAGE" | grep -c '^### [0-9]' || true)
  rows_with_effect_size=$(sed -n "${body_start},${body_end}p" "$PAGE" \
    | grep -cE '[0-9]+(\.[0-9]+)? ?(percent|pct|%)|[0-9]+(\.[0-9]+)?x |[0-9]+(\.[0-9]+)? times (faster|cheaper|fewer|less)|factor of [0-9]' || true)
  echo "rows_read=$rows_read"
  echo "rows_with_effect_size=$rows_with_effect_size"
fi

# -- reading 3 -- the floor this pier puts under any single trial ----------------------------------

if [ "$DO_TIMING" = no ]; then
  echo "timing=skipped"
  echo "verdict=partial"
  exit 0
fi

# THE SPIN LOOP'S ARITHMETIC IS EXACT, and that matters less here than anywhere else in the tree,
# which is exactly why it is written down. This loop's value is discarded -- it exists to cost
# time -- so the rounded multiplier it carried until `20260916` cost nothing. It moved to MINSTD
# so `tools/a/awk_lcg_exact_witness.rish` reads one rule with no exemption beside it, and the
# floor was measured across the change: medians 62 against 60 milliseconds on one reading and 51
# against 55 on the next, the two orderings disagreeing, so the difference sits inside this pier's
# own spread rather than beside it.
work() {
  awk -v n="$WORK_ITERS" 'BEGIN{x=1;for(i=0;i<n;i++)x=(x*48271+12345)%2147483647;exit(x==0)}' >/dev/null 2>&1 || true
}

take() {
  _n="$1"; _out=""; _i=0
  while [ "$_i" -lt "$_n" ]; do
    _s=$(date +%s%N); work; _e=$(date +%s%N)
    _out="$_out $(( (_e - _s) / 1000000 ))"
    _i=$(( _i + 1 ))
  done
  echo "$_out"
}

# THE SHORT BASELINE IS READ FIRST AND ON PURPOSE. A band is the range of what was SEEN, so a
# baseline of four runs sees less of the pier's spread than a baseline of fifteen and reports a
# NARROWER floor -- which reads as precision and is the opposite. Row 12 proposes one trial
# against a baseline whose size it never names, so the two are read side by side and the
# direction between them is the finding.
short_samples=$(take "$SHORT_RUNS")
short_stats=$(printf '%s\n' $short_samples | awk '
  { v[NR]=$1 }
  END{
    n=NR
    for (a=1; a<=n; a++) for (b=a+1; b<=n; b++) if (v[b] < v[a]) { t=v[a]; v[a]=v[b]; v[b]=t }
    med = (n % 2) ? v[(n+1)/2] : (v[n/2] + v[n/2+1]) / 2
    if (med <= 0) { print "0.0"; exit }
    printf "%.1f", 100 * (v[n] - v[1]) / med
  }')

samples=$(take "$BASELINE_RUNS")

stats=$(printf '%s\n' $samples | awk '
  { v[NR]=$1; sum+=$1 }
  END{
    n=NR
    if (n < 2) { print "0 0 0 0 0"; exit }
    for (a=1; a<=n; a++) for (b=a+1; b<=n; b++) if (v[b] < v[a]) { t=v[a]; v[a]=v[b]; v[b]=t }
    mean = sum / n
    med = (n % 2) ? v[(n+1)/2] : (v[n/2] + v[n/2+1]) / 2
    for (a=1; a<=n; a++) ss += (v[a]-mean)*(v[a]-mean)
    sd = sqrt(ss / (n-1))
    printf "%d %d %.1f %.1f %.2f", v[1], v[n], med, mean, sd
  }')

wall_min=$(echo "$stats" | cut -d' ' -f1)
wall_max=$(echo "$stats" | cut -d' ' -f2)
wall_med=$(echo "$stats" | cut -d' ' -f3)
wall_mean=$(echo "$stats" | cut -d' ' -f4)
wall_sd=$(echo "$stats" | cut -d' ' -f5)

spread_pct=$(awk -v lo="$wall_min" -v hi="$wall_max" -v m="$wall_med" \
  'BEGIN{ if (m <= 0) { print "0.0"; exit } printf "%.1f", 100 * (hi - lo) / m }')
cv_pct=$(awk -v sd="$wall_sd" -v mu="$wall_mean" \
  'BEGIN{ if (mu <= 0) { print "0.0"; exit } printf "%.1f", 100 * sd / mu }')

inside=0
t=0
while [ "$t" -lt "$TRIAL_RUNS" ]; do
  s=$(date +%s%N); work; e=$(date +%s%N)
  ms=$(( (e - s) / 1000000 ))
  if [ "$ms" -ge "$wall_min" ] && [ "$ms" -le "$wall_max" ]; then
    inside=$(( inside + 1 ))
  fi
  t=$(( t + 1 ))
done

inside_pct=$(awk -v i="$inside" -v n="$TRIAL_RUNS" 'BEGIN{printf "%.0f", 100 * i / n}')

echo "short_runs=$SHORT_RUNS"
echo "short_spread_pct=$short_stats"
echo "baseline_runs=$BASELINE_RUNS"
echo "trial_runs=$TRIAL_RUNS"
echo "wall_min_ms=$wall_min"
echo "wall_med_ms=$wall_med"
echo "wall_max_ms=$wall_max"
echo "wall_sd_ms=$wall_sd"
echo "spread_pct=$spread_pct"
echo "cv_pct=$cv_pct"
echo "trials_inside_baseline=$inside"
echo "trials_inside_pct=$inside_pct"
echo "resolvable_floor_pct=$spread_pct"
if awk -v a="$short_stats" -v b="$spread_pct" 'BEGIN{ exit !(a < b) }'; then
  echo "floor_rises_with_baseline=yes"
else
  echo "floor_rises_with_baseline=no"
fi

# EVERY TIMING FIGURE ABOVE IS FREE -- it moves with whatever the other seven ships are doing, so
# nothing holding it still can be gated. What CAN be gated is whether the arithmetic agrees with
# itself: a maximum at or above its minimum, a floor that IS the spread, and an inside count that
# fits inside the trials taken. A witness asserts this key and leaves the numbers to the reader.
consistent=yes
[ "$wall_max" -ge "$wall_min" ] || consistent=no
[ "$inside" -le "$TRIAL_RUNS" ] || consistent=no
[ "$spread_pct" = "$spread_pct" ] || consistent=no
echo "timing_self_consistent=$consistent"

# -- the verdict ----------------------------------------------------------------------------------
# Row 12 can be RUN as written when three things hold: the falsifier has an operand, a trial's
# number can be distinguished from noise, and the ordering is actually funded by metal trials.

if [ "${rows_with_effect_size:-0}" = "unreadable" ]; then
  echo "operand_present=unreadable"
elif [ "${rows_with_effect_size:-0}" -gt 0 ]; then
  echo "operand_present=yes"
else
  echo "operand_present=no"
fi

if [ "$funded_metal" -gt 0 ]; then
  echo "ordering_funded_by_metal=yes"
else
  echo "ordering_funded_by_metal=no"
fi

if [ "${rows_with_effect_size:-0}" != "unreadable" ] && [ "${rows_with_effect_size:-0}" -eq 0 ]; then
  echo "detail: row 12's falsifier has no operand -- no row names an effect size for a trial's number to sit inside or outside of"
  echo "verdict=falsifier_without_operand"
elif [ "$funded_metal" -eq 0 ] && [ "$errata_found" -gt 0 ]; then
  echo "verdict=funded_without_metal"
else
  echo "verdict=runnable"
fi
