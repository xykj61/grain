#!/bin/sh
# tools/fixtures/r/receipt_chain_scan.sh -- is this pier's scoped-receipt chain alive?
#
# WHAT IT READS. `tools/fixtures/s/standing_equipment_run.sh --scoped` proves the DELTA since the
# last fully green FULL close, and it finds that close in `construction/standing-equipment-receipt.kyri`
# -- a file `.gitignore` line 387 denies, so every checkout holds its own and no ship reads another's.
# This scan reads all eight at once and answers one question: would sharing a basis across the pier
# buy anything, and is there a live basis to share?
#
# WHY THE QUESTION NEEDED AN INSTRUMENT. Bakery's lane crux names one shared build cache and one
# shared cold-run cache across the eight checkouts, and that crux assumes the receipt chain is
# advancing and merely private. Measured by hand on `20261001`, the eight receipts stamp
# `20260912.024655` through `20260915.195315` -- the NEWEST is 16 days old, and this tree's own
# basis diffs 10,844 of 20,663 tracked files to reach HEAD. Sharing the freshest receipt on the
# pier would have narrowed that to 10,820: twenty-four files, two tenths of one percent. A cache
# nobody can refresh is a cache not worth sharing, and the reading that says so belongs in a tool
# rather than in one lap's memory.
#
# WHAT IT CANNOT DECIDE, said plainly. A receipt records `digest`, `head`, `scope`, `tier`,
# `guards`, `gated`, `gated_at` and `stamp`. It does NOT record whether the tree was CLEAN at that
# close. A green proven on a clean tree is a property of the commit `head`, which every checkout
# holds and any ship may chain from; a green proven over working-tree bytes is a property of one
# checkout nobody else can reproduce. The `digest` encodes the difference and encodes it opaquely,
# so portability is UNDECIDABLE from the record as it stands. This scan reports
# `portable_undecidable` rather than guessing, because a basis wrongly called portable skips
# guards nobody ran -- the one road from evidence to rumor the receipt design exists to close.
#
# REPORTED, GATED ON NOTHING. A stalled chain is not a fault in any lap: a receipt is withheld by
# a red, by a custody gate, or by `tree_moved`, and on a pier where eight ships push all day the
# third is ordinary. A gate reading `stalled` would red on every ship for a state no lap can
# repair, which is the shape `.claude/rules/derived-spine.md` names as a gate somebody turns off.
#
# USAGE
#   sh tools/fixtures/r/receipt_chain_scan.sh            # the pier reading
#   sh tools/fixtures/r/receipt_chain_scan.sh --seats     # one line per seat, then the totals
#
# HOW A CONTROL DRIVES IT. No environment override at all: the scan resolves its own tree from the
# script's path and the pier from that tree's parent, so a control builds a pen shaped exactly like
# this pier -- a root directory holding seat trees, one of them carrying a copy of this scan and the
# roster reader beside it -- and the real resolution path is the one under test. An override would
# be a second path no pen ever exercised.
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd) || exit 1
# The roster reader is resolved beside THIS script rather than under the root override, so a
# control pointing the reading at a pen still reads seats with the shipped parser. The pen supplies
# the roster FILE through `FLEET_ROSTER`, which is that parser's own documented override -- one
# parse serves every caller, which is the whole reason the roster scan exists.
roster="$(CDPATH= cd -- "$(dirname -- "$0")/../f" && pwd)/fleet_roster_scan.sh"
# ONE SHELL DIALECT. A stamp reaches epoch seconds through `date -d` on GNU and `date -j -f` on
# BSD, and macOS ships the second: left to one spelling the age reads EMPTY on the other pier,
# which is the shape `tools/fixtures/s/shell_portable.sh` exists to close -- an unplanted zero
# reads exactly like a healthy tree. Resolved from `$here`, the tree root this scan already
# computes, rather than beside the script: the letter-room fold means this scan's own room need
# not match the helper's `s`, where the roster above may stay a sibling lookup because `f` is
# always one directory over from wherever this script's own room sits.
portable="$here/tools/fixtures/s/shell_portable.sh"
pier=$(dirname "$here")

want_seats=no
for a in "$@"; do
  case "$a" in
    --seats) want_seats=yes ;;
    *) echo "receipt_chain: REFUSED -- unknown argument $a" >&2; exit 2 ;;
  esac
done

if [ ! -f "$portable" ]; then
  echo "receipt_chain: REFUSED -- the portable shell helper is absent at $portable" >&2
  exit 2
fi
# shellcheck source=/dev/null
. "$portable"

if [ ! -f "$roster" ]; then
  echo "receipt_chain: REFUSED -- the roster scan is absent at $roster" >&2
  exit 2
fi
seats=$(sh "$roster" --live 2>/dev/null) || {
  echo "receipt_chain: REFUSED -- the roster scan would not list live seats" >&2
  exit 2
}
[ -n "$seats" ] || { echo "receipt_chain: REFUSED -- the roster listed no live seat" >&2; exit 2; }

# THE SCOPING BOUND, named with its reason rather than tuned. A scoped pass selects every guard
# whose derived watch-set intersects the changed set, and a guard's watch-set usually spans a whole
# room. So a changed set past a tenth of the tree intersects nearly every room and the scoped pass
# re-proves nearly the whole roster -- which is the cost scoping exists to avoid. One tenth is a
# judgment this reading makes out loud, rather than a measured threshold; move it on a measurement
# of watch-set breadth, never on a feeling about a number.
delta_share_max_pct=10
# A basis older than this has been overtaken by most of a day's work. The pier ran 130 laps on
# `20260907` and more since, so a day is already hundreds of commits; naming the bound in hours
# keeps it readable beside the one-clock stamp the receipt carries.
basis_age_max_hours=24

tracked=$(git -C "$here" ls-files 2>/dev/null | grep -c . || true)
own_head=$(git -C "$here" rev-parse HEAD 2>/dev/null || echo no_head)

now_epoch=$(date -u +%s)

seats_total=0
with_receipt=0
held=0
opens_total=0
match_total=0
miss_total=0
none_total=0
newest_stamp=""
newest_seat=""
best_delta=-1
best_seat=""
own_delta=-1
absent_trees=""
seat_lines=""

# A receipt's stamp is one-clock local (`America/New_York` on this pier), so its age is read by
# handing the stamp back to the portable `stamp_epoch` in that same zone rather than by subtracting
# digits -- a ship stamped at the other door would otherwise read hours off. The helper owns the
# dialect; this scan owns the zone, which is the division its own header documents.

for seat in $seats; do
  name=$(sh "$roster" --tree "$seat" 2>/dev/null) || continue
  [ -n "$name" ] || continue
  seats_total=$((seats_total + 1))
  tree="$pier/$name"
  if [ ! -d "$tree" ]; then
    absent_trees="$absent_trees $seat"
    seat_lines="$seat_lines
seat $seat tree_absent"
    continue
  fi

  rfile="$tree/construction/standing-equipment-receipt.kyri"
  if [ ! -f "$rfile" ]; then
    seat_lines="$seat_lines
seat $seat receipt=absent"
  else
    with_receipt=$((with_receipt + 1))
    r_head=$(sed -n 's/^head //p' "$rfile" | head -1)
    r_stamp=$(sed -n 's/^stamp //p' "$rfile" | head -1)
    r_scope=$(sed -n 's/^scope //p' "$rfile" | head -1)
    r_guards=$(sed -n 's/^guards //p' "$rfile" | head -1)
    r_gated=$(sed -n 's/^gated //p' "$rfile" | head -1)
    [ -n "$r_gated" ] || r_gated=unstated

    # A basis must be diffable HERE, whatever the peer's own tree holds. An unfetched head is the
    # ordinary case on a pier that pulls at lap start, and it is a `behind` reading rather than a
    # fault -- the same distinction `tools/fixtures/p/path_absence_scan.sh` draws one room over.
    d=-1
    if [ "$r_scope" = full ] && git -C "$here" rev-parse --verify --quiet "$r_head^{commit}" >/dev/null 2>&1; then
      held=$((held + 1))
      d=$(git -C "$here" diff --name-only "$r_head" "$own_head" 2>/dev/null | grep -c . || true)
      if [ "$best_delta" -lt 0 ] || [ "$d" -lt "$best_delta" ]; then
        best_delta=$d
        best_seat=$seat
      fi
    fi
    if [ "$name" = "$(basename "$here")" ]; then own_delta=$d; fi

    if [ -n "$r_stamp" ]; then
      if [ -z "$newest_stamp" ] || [ "$r_stamp" \> "$newest_stamp" ]; then
        newest_stamp=$r_stamp
        newest_seat=$seat
      fi
    fi
    seat_lines="$seat_lines
seat $seat stamp=$r_stamp head=$(echo "$r_head" | cut -c1-10) scope=$r_scope guards=$r_guards gated=$r_gated delta=$d"
  fi

  hfile="$tree/construction/standing-equipment-hitrate.kyri"
  if [ -f "$hfile" ]; then
    o=$(grep -c . "$hfile" || true)
    m=$(grep -c 'receipt match' "$hfile" || true)
    s=$(grep -c 'receipt miss' "$hfile" || true)
    n=$(grep -c 'receipt none' "$hfile" || true)
    opens_total=$((opens_total + o))
    match_total=$((match_total + m))
    miss_total=$((miss_total + s))
    none_total=$((none_total + n))
    seat_lines="$seat_lines
seat $seat opens=$o match=$m miss=$s none=$n"
  fi
done

if [ "$want_seats" = yes ]; then
  echo "$seat_lines" | sed '/^$/d'
fi

echo "pier=$pier"
echo "tracked_files=$tracked"
echo "seats_live=$seats_total"
echo "seats_with_receipt=$with_receipt"
echo "seats_basis_held_here=$held"
[ -n "$absent_trees" ] && echo "trees_absent=${absent_trees# }"
echo "newest_stamp=${newest_stamp:-none}"
echo "newest_seat=${newest_seat:-none}"

age_hours=-1
if [ -n "$newest_stamp" ]; then
  e=""
  if ! e=$(TZ=America/New_York stamp_epoch "$newest_stamp" 2>/dev/null); then e=""; fi
  if [ -n "$e" ]; then age_hours=$(( (now_epoch - e) / 3600 )); fi
fi
echo "newest_age_hours=$age_hours"

echo "own_delta=$own_delta"
echo "best_delta=$best_delta"
echo "best_seat=${best_seat:-none}"
saved=-1
if [ "$own_delta" -ge 0 ] && [ "$best_delta" -ge 0 ]; then saved=$((own_delta - best_delta)); fi
echo "delta_saved_by_sharing=$saved"

share_pct=-1
if [ "$best_delta" -ge 0 ] && [ "$tracked" -gt 0 ]; then share_pct=$((best_delta * 100 / tracked)); fi
echo "best_delta_share_pct=$share_pct"
echo "delta_share_max_pct=$delta_share_max_pct"
echo "basis_age_max_hours=$basis_age_max_hours"

echo "opens_total=$opens_total"
echo "match_total=$match_total"
echo "miss_total=$miss_total"
echo "none_total=$none_total"
hit_pct=-1
if [ "$opens_total" -gt 0 ]; then hit_pct=$((match_total * 100 / opens_total)); fi
echo "hit_rate_pct=$hit_pct"

# PORTABILITY IS UNDECIDABLE FROM THE RECORD, and the count says so rather than guessing. Every
# receipt carrying a full scope and a head this tree holds is a CANDIDATE basis; not one of them
# states whether its green was proven on a clean tree, so not one can be CALLED portable. The
# remedy is a field in the receipt rather than a cleverer reading here.
echo "portable_candidates=$held"
echo "portable_proven=0"
echo "portable_undecidable=$held"
echo "portable_blocker=the receipt records no clean-tree field, so a peer cannot tell a commit-property green from a working-tree-property green"

verdict=stalled
if [ "$with_receipt" -eq 0 ] || [ "$held" -eq 0 ]; then
  verdict=no_basis
elif [ "$age_hours" -ge 0 ] && [ "$age_hours" -le "$basis_age_max_hours" ] \
  && [ "$share_pct" -ge 0 ] && [ "$share_pct" -le "$delta_share_max_pct" ]; then
  verdict=alive
fi
echo "verdict=$verdict"

# TWO SELF-READINGS, so a caller asserts one key rather than re-running this walk three times. Each
# pass over the pier runs a `git diff --name-only` across more than ten thousand files per seat, so a
# witness that re-ran the scan once per assert would pay that cost again for every question.
#
# `saving_arithmetic` closes the subtraction the lane's crux rests on: a saving that does not equal
# `own_delta` minus `best_delta` is a figure nobody should plan against. Both deltas absent is the
# lawful case where the saving is absent too.
arith=bad
if [ "$own_delta" -lt 0 ] || [ "$best_delta" -lt 0 ]; then
  [ "$saved" -eq -1 ] && arith=ok
else
  [ "$saved" -eq $((own_delta - best_delta)) ] && arith=ok
fi
echo "saving_arithmetic=$arith"

# `verdict_lawful` checks the word above against the three this scan documents. A fourth word is a
# reading no caller has a response for, which is worse than a refusal -- and it is exactly what a
# later hand adding a verdict without telling its readers would produce.
case "$verdict" in
  alive|stalled|no_basis) echo "verdict_lawful=yes" ;;
  *) echo "verdict_lawful=no" ;;
esac
