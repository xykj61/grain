#!/bin/sh
# tools/fixtures/l/log_file_claim_control.sh -- prove the log-file-claim reading on real
# repositories, every refusal planted and then lifted.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# WHY A PEN AND NOT THE TREE. The gate is `staged_unwritten` at zero, and proving it bites means
# staging a log that lies. Doing that here would put a false claim into this tree's own testimony,
# which is the exact fault under repair. So every leg runs in a throwaway git repository built by
# this script, and the real tree is only ever read.
#
# THE LOAD-BEARING LEG is phase 6. The gate's whole usability rests on a path that exists only in
# the INDEX passing free -- a lap stages its shelf and the log naming it in one commit, and a
# reading that refused that would refuse every honest lap. Phase 6 strips the index leg out of a
# copy of the scan and shows that same case turning into a refusal. A welcome proven only while the
# check is present cannot be told from a check that has merely started saying yes.
set -eu

export LC_ALL=C

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

# The plant law, imported rather than re-spelled: a plant is a claim about a file, and phase 6's
# whole meaning depends on its own break having landed (REDS %519).
. "$_fd_root/tools/fixtures/p/plant.sh"

scan="$_fd_root/tools/fixtures/l/log_file_claim_scan.sh"
[ -f "$scan" ] || { echo "verdict=scan_missing"; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

pass=0
fail=0
check() {
  if [ "$3" = "$2" ]; then
    pass=$((pass + 1)); printf 'OK   %s\n' "$1"
  else
    fail=$((fail + 1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2
  fi
}

# -- a pen tree that looks enough like this one for the scan to find its root -------------------
new_pen() {
  root="$pen/$1"
  rm -rf "$root"
  mkdir -p "$root/rishi/bin" "$root/tools/fixtures/l" "$root/session-logs/date/20260907" \
           "$root/construction/archive"
  : > "$root/rishi/bin/rishi"
  cp "$scan" "$root/tools/fixtures/l/log_file_claim_scan.sh"
  ( cd "$root" && git init -q . && git config user.email pen@pen && git config user.name pen \
      && git config commit.gpgsign false )
}

read_key() { ( cd "$root" && sh tools/fixtures/l/log_file_claim_scan.sh "${2:-}" 2>/dev/null | sed -n "s/^$1=//p" ) ; }
read_verdict() { ( cd "$root" && sh tools/fixtures/l/log_file_claim_scan.sh "${1:-}" >/dev/null 2>&1 && echo ok || echo refused ) ; }

log() { printf 'format session-log-v1\nstamp 20260907.120000\n%s\n' "$1" > "$2"; }

# -- 1-3: a staged log whose paths all resolve on disk ------------------------------------------
new_pen kept
echo body > "$root/construction/archive/20260907-120000_itinerary-landed-accounts.md"
log "file construction/archive/20260907-120000_itinerary-landed-accounts.md the shelf this lap wrote" \
    "$root/session-logs/date/20260907/20260907-120001_kept.kyri"
( cd "$root" && git add -A >/dev/null )
check "kept_staged_logs"        1  "$(read_key staged_logs)"
check "kept_staged_unwritten"   0  "$(read_key staged_unwritten)"
check "kept_walks_free"        ok  "$(read_verdict)"

# -- 4-6: a staged log naming a shelf nobody wrote -----------------------------------------------
new_pen unwritten
echo body > "$root/construction/archive/20260907-120000_itinerary-landed-accounts.md"
log "file construction/archive/20260907-120510_itinerary-landed-accounts.md the shelf this lap thinks it wrote" \
    "$root/session-logs/date/20260907/20260907-120510_composed.kyri"
( cd "$root" && git add -A >/dev/null )
check "unwritten_is_counted"     1  "$(read_key staged_unwritten)"
check "unwritten_refuses"  refused  "$(read_verdict)"
check "unwritten_names_its_word" staged_claim_unwritten "$(read_key verdict)"

# -- 7-8: THE LOAD-BEARING WELCOME -- the shelf exists only in the index --------------------------
# `git rm --cached` leaves the path staged as a deletion and gone from disk, so this pen builds the
# honest case the other way: the file is added to the index and then removed from the working tree,
# which is what a lap's own staged-but-unwritten-to-disk shelf looks like to a reading that trusts
# `-e` alone.
new_pen indexonly
echo body > "$root/construction/archive/20260907-121000_itinerary-landed-accounts.md"
log "file construction/archive/20260907-121000_itinerary-landed-accounts.md the shelf, staged" \
    "$root/session-logs/date/20260907/20260907-121001_indexed.kyri"
( cd "$root" && git add -A >/dev/null && rm -f construction/archive/20260907-121000_itinerary-landed-accounts.md )
check "index_only_staged_unwritten" 0 "$(read_key staged_unwritten)"
check "index_only_walks_free"      ok "$(read_verdict)"

# -- 9-11: values the path shape reads past ------------------------------------------------------
new_pen shapes
{
  printf 'format session-log-v1\n'
  printf 'file none -- nothing touched this lap\n'
  printf 'file construction/archive/absent.zzz an extension this tree does not write\n'
  printf 'file README the front door, no slash and no extension\n'
} > "$root/session-logs/date/20260907/20260907-122000_shapes.kyri"
( cd "$root" && git add -A >/dev/null )
check "unshaped_values_read_past"  0  "$(read_key staged_unwritten)"
check "unshaped_walks_free"       ok  "$(read_verdict)"
check "unshaped_fields_uncounted"  0  "$(read_key file_fields)"

# -- 12-13: trailing prose punctuation is stripped before the path is judged ---------------------
new_pen punct
echo body > "$root/construction/archive/20260907-123000_itinerary-landed-accounts.md"
log "file construction/archive/20260907-123000_itinerary-landed-accounts.md." \
    "$root/session-logs/date/20260907/20260907-123001_punct.kyri"
( cd "$root" && git add -A >/dev/null )
check "trailing_stop_stripped"  0  "$(read_key staged_unwritten)"
check "punct_walks_free"       ok  "$(read_verdict)"

# -- 14-16: an UNSTAGED lying log is reported and never gated ------------------------------------
# The population is testimony no lap may repair, so a peer's committed log must never refuse this
# lap's commit. It must still be counted, or the diagnosis says the tree is clean.
new_pen unstaged
log "file construction/archive/20260907-124000_itinerary-landed-accounts.md a shelf nobody wrote" \
    "$root/session-logs/date/20260907/20260907-124001_elder.kyri"
( cd "$root" && git add -A >/dev/null && git commit -qm "pen: an elder log" >/dev/null )
check "committed_lie_is_counted"   1  "$(read_key unwritten_total)"
check "committed_lie_not_staged"   0  "$(read_key staged_unwritten)"
check "committed_lie_walks_free"  ok  "$(read_verdict)"

# -- 17-18: a folded room keeps its basename, so it is recoverable rather than unwritten ---------
new_pen folded
mkdir -p "$root/construction/archive/date/20260907"
echo body > "$root/construction/archive/date/20260907/20260907-125000_itinerary-landed-accounts.md"
log "file construction/archive/20260907-125000_itinerary-landed-accounts.md the flat path, since folded" \
    "$root/session-logs/date/20260907/20260907-125001_folded.kyri"
( cd "$root" && git add -A >/dev/null && git commit -qm "pen: a folded room" >/dev/null )
check "folded_is_not_unwritten"  0  "$(read_key unwritten_total)"
check "folded_walks_free"       ok  "$(read_verdict)"

# -- 19: an unknown argument refuses rather than measuring something else ------------------------
new_pen args
( cd "$root" && git add -A >/dev/null 2>&1 || true )
check "unknown_argument_refuses" refused "$(read_verdict --nonsense)"

# -- 20-22: THE LOAD-BEARING LEG -- strip the index reading and phase 7's welcome becomes a refusal
new_pen stripped
echo body > "$root/construction/archive/20260907-126000_itinerary-landed-accounts.md"
log "file construction/archive/20260907-126000_itinerary-landed-accounts.md the shelf, staged" \
    "$root/session-logs/date/20260907/20260907-126001_indexed.kyri"
( cd "$root" && git add -A >/dev/null && rm -f construction/archive/20260907-126000_itinerary-landed-accounts.md )
check "strip_target_welcomes_first" ok "$(read_verdict)"
plant_apply "$root/tools/fixtures/l/log_file_claim_scan.sh" \
  's|^  grep -qxF -- "\$1" "\$work/tracked.txt" \&\& return 0$|  : index leg removed|' \
  index_leg >/dev/null 2>&1 && stripped=landed || stripped=nothing
check "strip_plant_landed"   landed  "$stripped"
check "stripped_refuses"    refused  "$(read_verdict)"

echo "pen_phases=8"
echo "checks_pass=$pass"
echo "faults=$fail"
if [ "$fail" -ne 0 ]; then
  echo "control_verdict=behavior_unproven"
  exit 1
fi
echo "control_verdict=ok"
exit 0
