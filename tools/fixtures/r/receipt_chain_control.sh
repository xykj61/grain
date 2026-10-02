#!/bin/sh
# tools/fixtures/r/receipt_chain_control.sh -- proves tools/fixtures/r/receipt_chain_scan.sh.
#
#   sh tools/fixtures/r/receipt_chain_control.sh
#
# Builds a real pen pier in a throwaway directory: a root holding seat trees, one of them a real git
# repository carrying a copy of the scan and the roster reader at their shipped paths, so the scan's
# OWN path resolution is the thing under test rather than an override written for the pen.
#
# Every refusal is planted and then LIFTED, and every welcome is asserted as hard as every refusal --
# a refusal proven only in the passing direction cannot be told from a bypass. Both bounds are shown
# from both sides, because a threshold proven on one side is a threshold that may be ignored.
set -eu

pass=0
fail=0
ok() { pass=$((pass + 1)); echo "ok   $1"; }
no() { fail=$((fail + 1)); echo "FAIL $1 -- $2"; }
leg() {
  _name=$1; _want=$2; _got=$3
  case "$_got" in
    *"$_want"*) ok "$_name" ;;
    *) no "$_name" "wanted $_want" ;;
  esac
}
legn() {
  _name=$1; _want=$2; _got=$3
  case "$_got" in
    *"$_want"*) no "$_name" "did not want $_want" ;;
    *) ok "$_name" ;;
  esac
}

src=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# ---- the pen pier ----------------------------------------------------------------------------
# `pier/field` is the ship running the scan; `pier/peer-one` and `pier/peer-two` are its peers.
pier="$pen/pier"
field="$pier/field"
mkdir -p "$field/tools/fixtures/r" "$field/tools/fixtures/s" "$field/tools/fixtures/f" "$field/construction"
cp "$src/tools/fixtures/r/receipt_chain_scan.sh" "$field/tools/fixtures/r/"
cp "$src/tools/fixtures/s/shell_portable.sh" "$field/tools/fixtures/s/"
cp "$src/tools/fixtures/f/fleet_roster_scan.sh" "$field/tools/fixtures/f/"
scan="$field/tools/fixtures/r/receipt_chain_scan.sh"

cat > "$field/construction/fleet-roster.kyri" <<'ROSTER'
format fleet-roster-v1

seat field
tree field
engine claude
lane pen
status live

seat peerone
tree peer-one
engine claude
lane pen
status live

seat peertwo
tree peer-two
engine claude
lane pen
status live

seat gone
tree peer-gone
engine claude
lane pen
status live
ROSTER

git -C "$field" init -q 2>/dev/null
git -C "$field" config user.email pen@example.invalid
git -C "$field" config user.name Pen
git -C "$field" config commit.gpgsign false
git -C "$field" add -A
git -C "$field" commit -q -m "pen: base"
base=$(git -C "$field" rev-parse HEAD)

# A second commit, so a basis at `base` carries a real delta of exactly one file.
mkdir -p "$field/room"
echo moved > "$field/room/one.txt"
git -C "$field" add -A
git -C "$field" commit -q -m "pen: one file moved"
tip=$(git -C "$field" rev-parse HEAD)

mkdir -p "$pier/peer-one/construction" "$pier/peer-two/construction"

now=$(TZ=America/New_York date +%Y%m%d.%H%M%S)
old=20260101.000000

write_receipt() {
  # write_receipt <tree> <head> <scope> <stamp>
  cat > "$pier/$1/construction/standing-equipment-receipt.kyri" <<EOF
format standing-equipment-receipt-v2
digest deadbeefcafe
head $2
scope $3
tier lap
guards 288
gated 0
stamp $4
EOF
}

# ---- refusals, planted then lifted -----------------------------------------------------------
set +e
out=$(sh "$scan" --nonsense 2>&1); rc=$?
set -e
leg "unknown_argument_refuses" "REFUSED" "$out"
[ "$rc" -ne 0 ] && ok "unknown_argument_exit_nonzero" || no "unknown_argument_exit_nonzero" "exit was 0"

# The portable dialect helper is sourced before the roster is even read, so its absence is the
# FIRST refusal and it is shown from both sides. A scan that sourced a missing helper under `set -u`
# would answer with a shell error rather than a named refusal, and a caller cannot act on that.
mv "$field/tools/fixtures/s/shell_portable.sh" "$pen/parked_portable.sh"
set +e
out=$(sh "$scan" 2>&1); rc=$?
set -e
leg "absent_portable_refuses" "REFUSED -- the portable shell helper is absent" "$out"
[ "$rc" -ne 0 ] && ok "absent_portable_exit_nonzero" || no "absent_portable_exit_nonzero" "exit was 0"
mv "$pen/parked_portable.sh" "$field/tools/fixtures/s/shell_portable.sh"
out=$(sh "$scan" 2>&1)
legn "portable_restored_welcomes" "REFUSED" "$out"

mv "$field/tools/fixtures/f/fleet_roster_scan.sh" "$pen/parked_roster.sh"
set +e
out=$(sh "$scan" 2>&1); rc=$?
set -e
leg "absent_roster_refuses" "REFUSED" "$out"
[ "$rc" -ne 0 ] && ok "absent_roster_exit_nonzero" || no "absent_roster_exit_nonzero" "exit was 0"
mv "$pen/parked_roster.sh" "$field/tools/fixtures/f/fleet_roster_scan.sh"
out=$(sh "$scan" 2>&1)
legn "roster_restored_welcomes" "REFUSED" "$out"

cat > "$pen/empty-roster.kyri" <<'EOF'
format fleet-roster-v1
EOF
set +e
out=$(FLEET_ROSTER="$pen/empty-roster.kyri" sh "$scan" 2>&1); rc=$?
set -e
leg "roster_with_no_live_seat_refuses" "REFUSED" "$out"
[ "$rc" -ne 0 ] && ok "empty_roster_exit_nonzero" || no "empty_roster_exit_nonzero" "exit was 0"

# ---- no receipt anywhere ---------------------------------------------------------------------
out=$(sh "$scan")
leg "no_receipt_seats_zero" "seats_with_receipt=0" "$out"
leg "no_receipt_verdict_no_basis" "verdict=no_basis" "$out"
leg "no_receipt_own_delta_absent" "own_delta=-1" "$out"
leg "absent_tree_named" "trees_absent=" "$out"
leg "absent_tree_counted_live" "seats_live=4" "$out"

# ---- a receipt whose head this tree does not hold --------------------------------------------
write_receipt peer-one 0000000000000000000000000000000000000000 full "$now"
out=$(sh "$scan")
leg "unheld_head_not_a_candidate" "seats_basis_held_here=0" "$out"
leg "unheld_head_still_counted_present" "seats_with_receipt=1" "$out"
leg "unheld_head_verdict_no_basis" "verdict=no_basis" "$out"

# ---- a fresh full receipt at the tip: nothing to re-prove ------------------------------------
write_receipt peer-one "$tip" full "$now"
out=$(sh "$scan")
leg "tip_basis_held" "seats_basis_held_here=1" "$out"
leg "tip_basis_zero_delta" "best_delta=0" "$out"
leg "tip_basis_zero_share" "best_delta_share_pct=0" "$out"
leg "tip_basis_fresh_is_alive" "verdict=alive" "$out"
leg "tip_basis_names_its_seat" "best_seat=peerone" "$out"

# ---- the age bound, from both sides ----------------------------------------------------------
write_receipt peer-one "$tip" full "$old"
out=$(sh "$scan")
leg "stale_basis_stalls" "verdict=stalled" "$out"
leg "stale_basis_age_over_bound" "basis_age_max_hours=24" "$out"
write_receipt peer-one "$tip" full "$now"
out=$(sh "$scan")
leg "age_bound_lifted_returns_alive" "verdict=alive" "$out"

# ---- the delta-share bound, from both sides --------------------------------------------------
# The pen tree holds few files, so one changed file is already a large share of it. A basis at
# `base` therefore crosses the one-tenth bound while its age stays inside the other, which proves
# the two bounds independently rather than together.
write_receipt peer-one "$base" full "$now"
out=$(sh "$scan")
leg "wide_delta_stalls" "verdict=stalled" "$out"
leg "wide_delta_counted" "best_delta=1" "$out"
write_receipt peer-one "$tip" full "$now"
out=$(sh "$scan")
leg "delta_bound_lifted_returns_alive" "verdict=alive" "$out"

# ---- a scoped receipt is no basis ------------------------------------------------------------
write_receipt peer-one "$tip" scoped "$now"
out=$(sh "$scan")
leg "scoped_receipt_not_a_candidate" "seats_basis_held_here=0" "$out"
leg "scoped_receipt_verdict_no_basis" "verdict=no_basis" "$out"
write_receipt peer-one "$tip" full "$now"

# ---- two peers, the newest basis chosen -----------------------------------------------------
write_receipt peer-two "$base" full "$now"
out=$(sh "$scan")
leg "two_candidates_held" "seats_basis_held_here=2" "$out"
leg "narrowest_delta_wins" "best_delta=0" "$out"
leg "newest_stamp_reported" "newest_stamp=$now" "$out"

# ---- portability stays undecidable, and says so ---------------------------------------------
leg "portable_proven_is_zero" "portable_proven=0" "$out"
leg "portable_undecidable_equals_candidates" "portable_undecidable=2" "$out"
leg "portable_blocker_named" "portable_blocker=the receipt records no clean-tree field" "$out"

# ---- the hit ledger -------------------------------------------------------------------------
cat > "$pier/peer-one/construction/standing-equipment-hitrate.kyri" <<'EOF'
open 20260101.000001 digest aaaaaaaaaaaa receipt match
open 20260101.000002 digest bbbbbbbbbbbb receipt miss
open 20260101.000003 digest cccccccccccc receipt miss
open 20260101.000004 digest dddddddddddd receipt none
EOF
out=$(sh "$scan")
leg "hit_opens_counted" "opens_total=4" "$out"
leg "hit_match_counted" "match_total=1" "$out"
leg "hit_miss_counted" "miss_total=2" "$out"
leg "hit_none_counted" "none_total=1" "$out"
leg "hit_rate_computed" "hit_rate_pct=25" "$out"

o=$(echo "$out" | sed -n 's/^opens_total=//p')
m=$(echo "$out" | sed -n 's/^match_total=//p')
s=$(echo "$out" | sed -n 's/^miss_total=//p')
n=$(echo "$out" | sed -n 's/^none_total=//p')
if [ "$o" -eq $((m + s + n)) ]; then ok "hit_arithmetic_closes"; else no "hit_arithmetic_closes" "$o != $m+$s+$n"; fi

# ---- the per-seat face ----------------------------------------------------------------------
out=$(sh "$scan" --seats)
leg "seats_mode_names_a_seat" "seat peerone stamp=" "$out"
leg "seats_mode_names_an_absent_tree" "seat gone tree_absent" "$out"
leg "seats_mode_keeps_the_totals" "verdict=" "$out"

# ---- mutations, each asserted to bite -------------------------------------------------------
mutate() {
  # mutate <label> <python-replacement-pairs-file>
  cp "$scan" "$pen/keep.sh"
  python3 - "$scan" "$2" "$3" <<'PY'
import sys
p, a, b = sys.argv[1], sys.argv[2], sys.argv[3]
s = open(p).read()
if a not in s:
    sys.stderr.write("PLANT-MISS\n"); sys.exit(3)
open(p, "w").write(s.replace(a, b, 1))
PY
}
restore() { cp "$pen/keep.sh" "$scan"; }

# Dropping the full-scope test admits a scoped receipt as a basis, which would let one skip become
# the basis of the next skip.
# Peer two's receipt is lifted first, so this leg reads ONE seat rather than two -- a mutation
# proven against a count another seat also contributes to is a mutation whose bite cannot be told
# from that seat's own reading.
rm -f "$pier/peer-two/construction/standing-equipment-receipt.kyri"
write_receipt peer-one "$tip" scoped "$now"
mutate scope_test 'if [ "$r_scope" = full ] && git -C "$here" rev-parse' 'if true && git -C "$here" rev-parse'
out=$(sh "$scan" 2>&1 || true)
leg "mutation_scope_test_bites" "seats_basis_held_here=1" "$out"
restore
out=$(sh "$scan")
leg "mutation_scope_test_restored" "seats_basis_held_here=0" "$out"
write_receipt peer-one "$tip" full "$now"

# Dropping the head-held test lets a delta be read against a commit this tree does not hold, which
# answers a question about a history nobody here has.
write_receipt peer-two 0000000000000000000000000000000000000000 full "$now"
out=$(sh "$scan")
leg "unheld_peer_excluded_before_mutation" "seats_basis_held_here=1" "$out"
mutate head_test 'git -C "$here" rev-parse --verify --quiet "$r_head^{commit}" >/dev/null 2>&1' 'true'
out=$(sh "$scan" 2>&1 || true)
leg "mutation_head_test_bites" "seats_basis_held_here=2" "$out"
restore
out=$(sh "$scan")
leg "mutation_head_test_restored" "seats_basis_held_here=1" "$out"

# ---- the two self-readings, each shown from both sides ---------------------------------------
# THE STATE IS BUILT DELIBERATELY FOR EACH, and the reason is the first draft's own failure: both
# mutations were planted against a pen where the reading could not move. The saving check needs the
# field's OWN receipt present, or `own_delta` reads -1 and the subtraction is never reached; and the
# verdict check needs a STALLED chain, or the branch below the initializer overwrites the plant. A
# mutation planted into a state that cannot express it reads exactly like a mutation that does not
# bite.
write_receipt field "$base" full "$now"
write_receipt peer-one "$tip" full "$now"
out=$(sh "$scan")
leg "own_delta_read_when_field_carries_a_receipt" "own_delta=1" "$out"
leg "arithmetic_closes_when_both_deltas_read" "saving_arithmetic=ok" "$out"
leg "saving_is_the_difference" "delta_saved_by_sharing=1" "$out"

mutate saving 'saved=$((own_delta - best_delta))' 'saved=$((own_delta - best_delta + 1))'
out=$(sh "$scan" 2>&1 || true)
leg "mutation_saving_bites" "saving_arithmetic=bad" "$out"
restore
out=$(sh "$scan")
leg "mutation_saving_restored" "saving_arithmetic=ok" "$out"

# A verdict word outside the documented three is what a later hand adding a fourth would produce,
# and the scan is proven to say so rather than to pass it through in silence.
write_receipt field "$base" full "$old"
write_receipt peer-one "$base" full "$old"
out=$(sh "$scan")
leg "stalled_state_for_the_verdict_plant" "verdict=stalled" "$out"
leg "verdict_lawful_when_word_is_documented" "verdict_lawful=yes" "$out"
mutate verdict 'verdict=stalled' 'verdict=undecided'
out=$(sh "$scan" 2>&1 || true)
leg "mutation_verdict_word_bites" "verdict_lawful=no" "$out"
restore
out=$(sh "$scan")
leg "mutation_verdict_word_restored" "verdict_lawful=yes" "$out"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
