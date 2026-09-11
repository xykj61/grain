#!/bin/sh
# ratchet_slack_scan.sh -- how much room every ratchet ceiling in this tree has left.
#
#   sh tools/fixtures/r/ratchet_slack_scan.sh            # the static census, seconds
#   sh tools/fixtures/r/ratchet_slack_scan.sh --live     # runs each scan for its reading, minutes
#   sh tools/fixtures/r/ratchet_slack_scan.sh --names    # one line per ceiling, no summary
#
# WHY THIS CENSUS EXISTS. This tree holds a family of ratchets: a guard counts a population it
# wants smaller, declares a ceiling, and refuses when the count rises above it. The rule every one
# of them writes in its own header is `the ceiling only falls` -- lower it when a repair lands,
# never raise it. Followed exactly, that rule leaves a ceiling sitting at whatever the reading was
# on the day somebody last lowered it, which is to say at ZERO SLACK: the next arrival reds.
#
# That is correct where the population grows only by defects, since there the next arrival IS a
# defect and the red is the point. It is a trap where the population grows by ordinary lawful work,
# because then the guard reds on a lap that did nothing wrong -- and a guard that reds on ordinary
# work is a guard somebody turns off. `construction/REDS.md` `%626` is that trap sprung once:
# `dated_path` gates `refs_lost` against a ceiling lowered to the exact count then standing, over a
# population that grows every time a ship writes a session log naming a path and falls for nobody,
# because accrete-never-break forbids repairing a dated citer. Nothing in the tree could say
# whether that was one instance or a class, because nobody had read the slack of the family.
#
# WHAT IS COUNTED. Every ceiling constant declared in a `tools/fixtures/` scan -- discovered by
# reading the sources rather than listed here, so a ceiling written tomorrow is counted the day it
# lands. For each, the static half asks whether the constant is actually COMPARED in its own scan,
# since a ceiling that is declared, printed, and never compared is a gate that can never refuse.
#
# WHAT --live ADDS, and what it costs. The reading beside the ceiling, and therefore the slack.
# Getting it means running each scan, which is minutes rather than seconds -- this census is
# hand-run for that reason and prints no `verdict=` line in `--live`, so it can never be read as a
# gate. The pairing of a ceiling key to its reading key is the one hand-kept table below, because
# each scan names its own reading and no rule derives them all: `absent` beside `absent_ceiling`,
# `plain_shebang_ratchet` beside `plain_shebang_ceiling`, `chars` beside a bare `ceiling`. A
# ceiling with no table row prints `reading=unread` and is COUNTED as unread rather than dropped,
# and a table row naming a ceiling this tree no longer declares is counted as stale -- the two
# failures a second copy of a name can have.
#
# MEASURED `20260910.172957`, the first reading anybody has taken of the family as a family,
# `--live`: **81 ceilings across 55 scans**, every one of them compared inside its own scan. Of the
# 72 read -- four scans build binaries and are declined, five did not answer inside the per-scan
# bound -- **35 stand at ZERO SLACK**, where whatever arrives next reds; **21 are walls already at
# zero** over an empty population; **13 carry slack**; and **3 stand OVER**, one of which
# (`mantra_weave_model`) its own witness explains by passing a higher ceiling. Every figure here is
# FREE: run the census rather than reading this line.
#
# THE TWO GENUINELY OVER ARE ONE SHAPE, WHICH IS WHY THIS WAS WORTH COUNTING. `dated_path` reads
# 105 against 85 and is `tier cadence`, so no lap-tier pass hears it -- REDS `%626`. And
# `say_compose_bound` read 538 per mille against 537, `tier lap`, red on this ship's cold and hot
# passes both, over a population that grows whenever anybody writes a witness whose `else` clause
# explains itself. Neither number rose because something broke. `%626` fired once and was called an
# instance; it has fired twice now, which is what turns a lantern into a loom.
#
# THE SECOND ONE WAS REPAIRED WHILE THIS CENSUS WAS BEING WRITTEN, which is worth recording rather
# than quietly deleting. A peer lap of `20260910.160342` swept the composing sites and lowered the
# ceiling, and the same scan reads `480` against `489` after this lap's rebase -- nine of slack,
# the first the family has been given deliberately. The instance closed; the shape did not, since
# the population still grows by ordinary work and the ceiling still falls toward the reading.
#
# WHAT THE SHAPE SAYS. Zero slack is the family's resting state rather than an accident, because
# `lower it when a repair lands` puts it there on purpose. So the question a reader carries to each
# row is not whether the slack is small -- it will be -- but WHO grows the population and WHO may
# lower the ceiling. Where both answers are the lane holding the guard, zero slack is the ratchet
# working. Where the population grows by a hand that cannot lower the ceiling, it is `%626`.
#
# WHAT THIS DOES NOT REACH. Whether a zero-slack ceiling is a trap or a wall doing its job, which
# is a judgment about who grows the population and who may lower it. The census hands a reader the
# slack and the scan's own header; the reading of them stays a person's. The three answers that
# judgment has, each with a named instance, are written up at
# `foundations/20260910-193534_a-ratchet-belongs-over-a-population-a-hand-may-shrink.md`, together
# with the law proposed on them and waiting on Keaton's word.

set -u
ROOT=${RATCHET_SLACK_ROOT:-$(cd "$(dirname "$0")/../../.." && pwd)}
cd "$ROOT" || exit 2

MODE=static
NAMES=no
# EACH SCAN IS BOUNDED, and a scan that does not answer inside the bound is named rather than read
# as unpaired. `glow_desk_run` takes 455s on this pier and `equinox_choir_census` runs a family, so
# an unbounded census would run for hours and a silently dropped row would read exactly like a
# ceiling nobody paired. 120s answers 50 of 55 scans here; raise it for a slower reading.
RUN_TIMEOUT=${RATCHET_SLACK_TIMEOUT:-120}
for a in "$@"; do
  case "$a" in
    --live) MODE=live ;;
    --names) NAMES=yes ;;
    *) echo "refused: unknown argument $a" >&2; exit 2 ;;
  esac
done

# The pairing table lives in its own file, `ratchet_slack_pairs.txt` beside this scan: one row per
# ceiling, `<scan basename>|<ceiling key>|<reading key>`. It is data rather than a here-document so
# a control can hand this census a pen's own table, which is what lets the stale-row reading be
# proven on a real tree rather than argued for in a comment.
PAIRS_FILE="$ROOT/tools/fixtures/r/ratchet_slack_pairs.txt"
[ -f "$PAIRS_FILE" ] || { echo "refused: the pairing table is absent at $PAIRS_FILE" >&2; echo "verdict=table_missing"; exit 2; }
PAIRS=$(grep -vE '^ *(#|$)' "$PAIRS_FILE")

# Scans this census declines to run in --live, each for its own named reason: they build binaries,
# so running them beside a roster pass writes into fixed tree paths a peer may be reading.
BUILDERS='instrument_absence rye_compile_reach rye_harness_roster witness_own_build'

stale_note=$(mktemp) || { echo "refused: no temporary file" >&2; exit 2; }
trap 'rm -f "$stale_note"' EXIT INT TERM

overridable=0
unanswered=0
over_with_callers=0
ceilings=0; compared=0; uncompared=0; unread=0; stale=0
zero_slack=0; wall_zero=0; with_slack=0; over=0; builder_skipped=0

read_pair() {  # scan base, ceiling key -> reading key or empty
  printf '%s\n' "$PAIRS" | while IFS='|' read -r b c r; do
    [ "$b" = "$1" ] && [ "$c" = "$2" ] && echo "$r"
  done
}

# WHAT IS READ, AND WHAT IS HELD OUT. Only a `_scan.sh`, and never this census's own file. Its own
# counters are named `ceilings=` and `zero_slack=`, which its discovery pattern matches; and a
# control's plants are literal lines of the thing it breaks (REDS %519), so this census's own
# control declares `CEILING=3` inside a here-document and was counted as a tree ceiling on its
# first live run. A meter reading its own bookkeeping or its own test material as its subject is
# the self-matching fault `tools/fixtures/s/self_matching_assert_scan.sh` holds at zero one room
# over; both exclusions are proven by the control rather than trusted.
#
# TWO DECLARATION FORMS, and the second was invisible for this census's first hour. A ceiling is
# written either as a plain constant, `ceiling=57`, or with an environment default,
# `DEFERRED_PER_MILLE_CEILING=${SAY_COMPOSE_DEFERRED_CEILING:-537}`. Reading only the first missed
# 23 scans, `say_compose_bound` among them -- which stood one per mille OVER its ceiling at the
# moment this census called the family fully read. A measurement that finds its subject by name
# reports the naming convention it was handed.
DECL='^[A-Za-z_]*(CEILING|ceiling)[A-Za-z_]*=(\$\{[A-Za-z_]+:-)?[0-9]+\}?'
scan_list=$(find tools/fixtures -type f -name '*_scan.sh' 2>/dev/null \
  | grep -v '/ratchet_slack_scan\.sh$' | sort \
  | while read -r f; do grep -qE "$DECL" "$f" && echo "$f"; done)

for p in $scan_list; do
  base=$(basename "$p" _scan.sh)
  out=''
  if [ "$MODE" = live ]; then
    case " $BUILDERS " in
      *" $base "*) out='' ;;
      *) out=$(timeout "$RUN_TIMEOUT" sh "$p" 2>/dev/null || true) ;;
    esac
  fi
  for decl in $(grep -hoE "$DECL" "$p"); do
    key=${decl%%=*}
    val=${decl##*=}
    ceilings=$((ceilings + 1))
    override=none
    callers=none
    case "$decl" in
      *'${'*) override=${decl#*\$\{}; override=${override%%:-*}; val=${decl##*:-}; val=${val%\}} ;;
    esac
    # AN OVERRIDABLE CEILING HAS MORE THAN ONE VALUE, and the census declines to choose. The file
    # default is what a pen meets; a witness may pass another. Only some of those passes are the
    # LIVING reading -- `tame_reach_witness` runs its scan `TAME_REACH_DEBT_ROOM_CEILING=0
    # TAME_REACH_BAN_CEILING=99999` to show the gate refusing, and `glow_decimal_law_witness` passes
    # 1 for the same purpose, so a census taking the single passed value called two green guards
    # over their ceilings. So the SLACK is computed against the file default, every value a tracked
    # runner passes is LISTED beside it, and a negative slack on a row carrying callers is counted
    # apart: the census hands a reader the two numbers rather than picking between them.
    if [ "$override" != none ]; then
      overridable=$((overridable + 1))
      # A CONTROL IS NOT A CALLER. Its plants are literal lines of the thing it breaks (REDS %519,
      # the same lesson twice in one lap), so `say_compose_bound`'s control passing 0, 999 and 1000
      # in its pens read as three callers disagreeing about one ceiling.
      callers=$(grep -rlE "(^|[^A-Za-z_])$override=[0-9]+" --include='*.rish' --include='*.sh' tools 2>/dev/null \
        | grep -v '_control\.sh$' | grep -v '/ratchet_slack_' \
        | xargs -r grep -hoE "(^|[^A-Za-z_])$override=[0-9]+" 2>/dev/null \
        | sed 's/.*=//' | sort -un | tr '\n' ',' | sed 's/,$//')
      [ -n "$callers" ] || callers=none
    fi
    # A ceiling is compared by the shell -- `[ "$n" -gt "$ceiling" ]` -- or inside an awk program
    # the scan hands it to with `-v ceiling="$ceiling"`, where the comparison reads `maxc > ceiling`.
    # Reading only the shell form called `room_braid_census` a decoration.
    if grep -qE -- "-(gt|ge|lt|le|eq|ne) *\"?\\$\{?$key|\\$\{?$key\}?\"? *-(gt|ge|lt|le|eq|ne)|[<>]=? *$key([^A-Za-z_]|$)|(^|[^A-Za-z_])$key *[<>]=?" "$p"; then
      compared=$((compared + 1)); cmp=yes
    else
      uncompared=$((uncompared + 1)); cmp=no
    fi
    rkey=$(read_pair "$base" "$key" | head -1)
    reading=unread
    if [ "$MODE" = live ]; then
      case " $BUILDERS " in
        *" $base "*) reading=builder ;;
        *)
          if [ -n "$rkey" ]; then
            # A reading key may carry a line anchor, `ANCHOR@key`, for the scans that print two
            # ceilings on two lines under one key name: `rye_comment_ascii` says `chars=` twice,
            # once for own-line comments and once for trailing ones, and a bare key would hand the
            # second ceiling the first line's number.
            case "$rkey" in
              *@*) line=$(printf '%s\n' "$out" | grep -F "${rkey%@*}" | head -1)
                   bare=${rkey##*@} ;;
              *)   line=$out; bare=$rkey ;;
            esac
            if [ "$out" = __unanswered__ ]; then
              reading=unanswered
            else
              reading=$(printf '%s\n' "$line" | grep -oE "(^| )$bare=[0-9]+" | head -1 | sed 's/.*=//')
              [ -n "$reading" ] || reading=unanswered
            fi
          fi
          ;;
      esac
    fi
    [ -n "$rkey" ] || rkey=unpaired
    slack=unread
    case "$reading" in
      builder) builder_skipped=$((builder_skipped + 1)) ;;
      unanswered) [ "$MODE" = live ] && unanswered=$((unanswered + 1)) ;;
      unread) [ "$MODE" = live ] && unread=$((unread + 1)) ;;
      *)
        slack=$((val - reading))
        if [ "$slack" -lt 0 ]; then
          over=$((over + 1))
          [ "$callers" = none ] || over_with_callers=$((over_with_callers + 1))
        elif [ "$slack" -eq 0 ] && [ "$val" -eq 0 ]; then wall_zero=$((wall_zero + 1))
        elif [ "$slack" -eq 0 ]; then zero_slack=$((zero_slack + 1))
        else with_slack=$((with_slack + 1))
        fi
        ;;
    esac
    printf 'ratchet %s %s ceiling=%s reading=%s slack=%s compared=%s reads=%s override=%s callers=%s\n' \
      "$base" "$key" "$val" "$reading" "$slack" "$cmp" "$rkey" "$override" "$callers"
  done
done

# A table row naming a ceiling this tree no longer declares is the second copy going stale.
printf '%s\n' "$PAIRS" | while IFS='|' read -r b c r; do
  [ -n "${b:-}" ] || continue
  found=no
  for p in $scan_list; do
    [ "$(basename "$p" _scan.sh)" = "$b" ] || continue
    grep -qE "^$c=(\\$\{[A-Za-z_]+:-)?[0-9]+" "$p" && found=yes
  done
  [ "$found" = yes ] || echo "stale_pair $b $c -- the table names a ceiling this tree no longer declares"
done > "$stale_note"
stale=$(grep -c . "$stale_note" 2>/dev/null)
[ -n "$stale" ] || stale=0
cat "$stale_note"
rm -f "$stale_note"

[ "$NAMES" = yes ] && exit 0

echo "scans=$(echo "$scan_list" | grep -c .)"
echo "ceilings=$ceilings"
echo "ceilings_compared=$compared"
echo "ceilings_uncompared=$uncompared"
echo "ceilings_overridable=$overridable"
echo "stale_pairs=$stale"
if [ "$MODE" = live ]; then
  echo "read=$((zero_slack + wall_zero + with_slack + over))"
  echo "unread=$unread"
  echo "unanswered=$unanswered"
  echo "builder_skipped=$builder_skipped"
  echo "wall_at_zero=$wall_zero"
  echo "zero_slack=$zero_slack"
  echo "with_slack=$with_slack"
  echo "over_ceiling=$over"
  echo "over_ceiling_with_callers=$over_with_callers"
  echo "detail: a live reading is a census rather than a gate, so no verdict line is printed here"
  exit 0
fi
if [ "$uncompared" -eq 0 ] && [ "$stale" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=ceiling_unheld"
exit 1
