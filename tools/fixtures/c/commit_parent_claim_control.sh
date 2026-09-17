#!/bin/sh
# commit_parent_claim_control.sh -- prove the parent-hash claim reading on real
# git repositories in a throwaway pen.
#
# WHY A PEN OF REAL REPOSITORIES. The whole reading is a relation between a
# sentence and an object graph -- which commit is a parent, which hash resolves,
# which resolves and is no ancestor of the claiming commit. A pen of text files
# would prove the regular expressions and could not prove one of the three
# genres that decide the gate.
#
# EVERY LEG STARTS FROM ONE SPINE. The first draft of this control asserted
# absolute counts while earlier legs' commits stood in the log, so five legs read
# a neighbour's segment and called it their own. Each leg resets to the spine.
#
# EVERY REFUSAL IS SHOWN FROM BOTH SIDES: each plant is made, counted, lifted,
# and shown to return the reading to zero.
#
#   sh tools/fixtures/c/commit_parent_claim_control.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
SCAN=${SCAN:-$ROOT/tools/fixtures/c/commit_parent_claim_scan.sh}

# One shell dialect on both piers: `sed -i` is GNU-only and BSD sed wants an
# argument after it, so the in-place edits below call the portable helper. The
# root walk is the depth-proof block every fixtures guard carries -- git-free, so
# a pen copy outside a repository still resolves -- bounded at 8 steps.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"
checks=0
failures=0
# The pattern takes a trailing wildcard on purpose: a verdict of `no (want ...)`
# is a failure, and a `*=no` pattern without it read every explained failure as a
# pass. This control's own first run stood at five silent reds under a green
# verdict, which is the fault tools/fixtures/a/ascii_document_control.sh booked
# one room over -- a control speaking to a tally that cannot hear it.
say() { checks=$((checks + 1)); printf '%s\n' "$1"; case "$1" in *=no|*"=no "*) failures=$((failures + 1)) ;; esac; }
want() { if [ "$2" = "$3" ]; then say "$1=yes"; else say "$1=no (want [$2] got [$3])"; fi; }
read_key() { printf '%s\n' "$1" | awk -F= -v k="$2" '$1==k{print $2}'; }

pen=$(mktemp -d 2>/dev/null || mktemp -d -t cpclaim)
trap 'rm -rf "$pen"' EXIT INT TERM
tree=$pen/tree
mkdir -p "$tree"
cd "$tree"
git init -q .
git config user.email pen@example.invalid
git config user.name Pen
git config commit.gpgsign false

commit() { printf '%s\n' "$2" > "$1"; git add -A; git commit -q -m "pen: $1" -m "$2"; }
run() { sh "$SCAN" --window 200 "$@"; }
spine() { git checkout -q main 2>/dev/null || git checkout -q master 2>/dev/null || true; git reset -q --hard "$SPINE"; }

for i in 1 2 3 4 5; do commit "f$i" "pen body $i"; done
SPINE=$(git rev-parse HEAD)
ELDER=$(git rev-parse --short=10 HEAD~3)
PARENT=$(git rev-parse --short=10 HEAD)

# an abandoned branch, so a sideways hash has somewhere real to live
git checkout -q -b aside
commit aside_file "pen aside"
ASIDE=$(git rev-parse --short=10 HEAD)
git checkout -q -
git branch -D aside >/dev/null 2>&1 || true

out=$(run)
want spine_has_no_segment 0 "$(read_key "$out" segments)"
want spine_has_no_claim 0 "$(read_key "$out" false)"

# --- a TRUE self-parent claim is counted true and is no claim ----------------
commit t_true "The nib moves to $PARENT, this commit's own parent, so the card lands right."
out=$(run)
want true_counted 1 "$(read_key "$out" self_true)"
want true_not_false 0 "$(read_key "$out" false)"
want true_not_unresolved 0 "$(read_key "$out" unresolved)"
spine; out=$(run); want true_lifted 0 "$(read_key "$out" self)"

# --- a FALSE claim naming a live ancestor is bitten --------------------------
commit t_false "The nib moves to $ELDER, this commit's own parent, so the card lands right."
out=$(run)
want false_bitten 1 "$(read_key "$out" false)"
want false_is_undecided 1 "$(read_key "$out" self_undecided)"
spine; out=$(run); want false_lifted 0 "$(read_key "$out" false)"

# --- a hash resolving nowhere here reads unresolved, never false -------------
commit t_ghost "The nib moves to deadbe0f12, this commit's own parent, so the card lands right."
out=$(run)
want ghost_unresolved 1 "$(read_key "$out" unresolved)"
want ghost_not_false 0 "$(read_key "$out" false)"
spine; out=$(run); want ghost_lifted 0 "$(read_key "$out" unresolved)"

# --- a hash left on an abandoned branch reads sideways, never false ----------
commit t_sideways "The nib moves to $ASIDE, this commit's own parent, so the card lands right."
out=$(run)
want sideways_named 1 "$(read_key "$out" sideways)"
want sideways_not_false 0 "$(read_key "$out" false)"
spine; out=$(run); want sideways_lifted 0 "$(read_key "$out" sideways)"

# --- an erratum QUOTING another commit's faulty hash walks free --------------
commit t_quoted "The commit $ELDER carries a body naming it as its own parent while another commit holds that place."
out=$(run)
want quoted_free 1 "$(read_key "$out" self_quoted)"
want quoted_not_a_claim 0 "$(read_key "$out" false)"
spine

# --- the card's own move idiom names its origin, never a claim ---------------
commit t_origin "The Git nib moves from $ELDER to HEAD's parent, so the guard passes."
out=$(run)
want origin_free 1 "$(read_key "$out" self_origin)"
want origin_not_a_claim 0 "$(read_key "$out" false)"
spine

# --- an all-decimal run beside parent is no token (REDS %782) ----------------
commit t_decimal "The seed 1103515245 is the parent of every draw this generator makes."
out=$(run)
want decimal_run_ignored 0 "$(read_key "$out" segments)"
spine

# --- ed25519 IS a hex run, and the relation filter is what holds it ----------
# Seven characters, all of them hexadecimal, standing beside the word parent in
# every hardened-derivation body this tree has written. The token rule cannot
# tell a curve name from a commit; the SELF filter reads it loose and the gate
# never sees it.
commit t_ed "ed25519 admits only hardened derivation, so a subkey cannot come from the parent's public key alone."
out=$(run)
want ed25519_is_a_token 1 "$(read_key "$out" segments)"
want ed25519_stays_loose 1 "$(read_key "$out" loose)"
want ed25519_never_a_claim 0 "$(read_key "$out" self)"
spine

# --- a sentence about a PEER's parent is loose, never gated ------------------
commit t_loose "Each was proven by checking out its parent $ELDER and re-running the scan there."
out=$(run)
want loose_counted 1 "$(read_key "$out" loose)"
want loose_not_self 0 "$(read_key "$out" self)"
spine

# --- the word parent with no hash raises no segment --------------------------
commit t_nohash "The card names this commit's own parent and the guard reads it."
out=$(run)
want no_hash_no_segment 0 "$(read_key "$out" segments)"
spine

# --- the anchor counts forward only -----------------------------------------
commit t_before "The nib moves to $ELDER, this commit's own parent, so the card lands right."
ANCHOR=$(git rev-parse --short=10 HEAD)
commit t_after_ok "pen ordinary body"
out=$(run --anchor "$ANCHOR")
want anchor_excludes_history 0 "$(read_key "$out" false_after_anchor)"
want anchor_still_reports_history 1 "$(read_key "$out" false)"
commit t_after_bad "The nib moves to $ELDER, this commit's own parent, so the card lands right."
out=$(run --anchor "$ANCHOR")
want anchor_bites_after 1 "$(read_key "$out" false_after_anchor)"
want anchor_claims_total 1 "$(read_key "$out" claims_after_anchor)"
git reset -q --hard HEAD~1
out=$(run --anchor "$ANCHOR")
want anchor_lifted 0 "$(read_key "$out" claims_after_anchor)"
commit t_after_ghost "The nib moves to deadbe0f12, this commit's own parent, so the card lands right."
out=$(run --anchor "$ANCHOR")
want anchor_counts_ghost 1 "$(read_key "$out" unresolved_after_anchor)"
want anchor_ghost_in_claims 1 "$(read_key "$out" claims_after_anchor)"
spine

# --- refusals at the door ----------------------------------------------------
if sh "$SCAN" --anchor cafebabecafe >/dev/null 2>&1; then say bad_anchor_refuses=no; else say bad_anchor_refuses=yes; fi
if sh "$SCAN" --window twelve  >/dev/null 2>&1; then say bad_window_refuses=no;  else say bad_window_refuses=yes; fi
if sh "$SCAN" --window 99999999 >/dev/null 2>&1; then say over_max_window_refuses=no; else say over_max_window_refuses=yes; fi
if sh "$SCAN" --wat >/dev/null 2>&1; then say unknown_flag_refuses=no; else say unknown_flag_refuses=yes; fi

# --- mutations: each cut must bite, measured against the same tree -----------
mut=$pen/mut.sh
bite() { cp "$SCAN" "$mut"; sed_inplace "$1" "$mut"; sh "$mut" --window 200 2>/dev/null || true; }

commit m_decimal "The seed 1103515245 is the parent of every draw this generator makes."
m=$(bite 's/if (tok !~ \/\[a-f\]\/) continue;//')
want mutation_letter_clause_bites 1 "$(read_key "$m" segments)"
spine

commit m_quoted "The commit $ELDER carries a body naming it as its own parent while another commit holds that place."
m=$(bite 's/(quoted ? "quoted" : /(0 ? "quoted" : /')
want mutation_quoted_bites 1 "$(read_key "$m" false)"
spine

commit m_origin "The Git nib moves from $ELDER to HEAD's parent, so the guard passes."
m=$(bite 's/(origin ? "origin" : /(0 ? "origin" : /')
want mutation_origin_bites 1 "$(read_key "$m" false)"
spine

commit m_loose "Each was proven by checking out its parent $ELDER and re-running the scan there."
m=$(bite 's/g = self ?/g = 1 ?/')
want mutation_self_filter_bites 1 "$(read_key "$m" false)"
spine

commit m_sideways "The nib moves to $ASIDE, this commit's own parent, so the card lands right."
m=$(bite 's/then v=false; else v=sideways; fi/then v=false; else v=false; fi/')
want mutation_ancestor_bites 1 "$(read_key "$m" false)"
spine

commit m_anchor "The nib moves to $ELDER, this commit's own parent, so the card lands right."
ANCHOR2=$(git rev-parse --short=10 HEAD~1)
cp "$SCAN" "$mut"; sed_inplace 's/^  AFTER=" \$(git rev-list/  AFTER=" " #/' "$mut"
m=$(sh "$mut" --window 200 --anchor "$ANCHOR2" 2>/dev/null || true)
want mutation_anchor_window_bites 0 "$(read_key "$m" false_after_anchor)"
spine

say "checks=$checks"
say "failures=$failures"
if [ "$failures" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; exit 1; fi
