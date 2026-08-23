#!/bin/sh
# Nib-honesty guard -- every hash the living operator card advertises resolves,
# and the reachability of each is named rather than assumed.
#
# The card advertises hashes in more than one voice. One is the Git nib, the
# landed edge of the send; the others are CAIRNS -- walk-back nibs recorded
# before a debride, whose whole promise (.claude/rules/cairn.md) is that the
# departing card stays one git-show away. Those two voices obey different laws:
#
#   THE NIB     is HEAD, HEAD's pre-amend sibling, or HEAD's parent. That law
#               belongs to tools/remember_git_nib_witness.rish, the loom booked
#               after REDS %103 fired twice, and is NOT re-implemented here.
#   A CAIRN     is OFF main by construction after a deep debride -- the rewrite
#               is what makes the walk-back worth recording. Demanding that a
#               cairn be an ancestor of HEAD is demanding it not be a cairn.
#
# So the one law this guard owns, over EVERY advertised hash alike:
#
#   HARD  -- every advertised hash RESOLVES to a real commit. A hash that
#            resolves nowhere is a promise already broken, in any voice.
#   SOFT  -- reachability is NAMED per hash: on-main, on-remote, or local-only.
#            A local-only cairn is reported, never failed, because the repair is
#            pushing a pre-debride branch -- a custody call that is Keaton's word,
#            not a guard's. Naming it is the guard's whole job here.
#
#   sh tools/fixtures/nib_honesty_scan.sh
#   sh tools/fixtures/nib_honesty_scan.sh prove-red
#
# Read-only: no network, no key, no funds, no writes to the card.
set -eu

MODE=${1:-}
CARD=${CARD:-construction/REMEMBER.md}
CONTROL=tools/fixtures/nib_honesty_control/floating_nib_control.md

# Ten hex digits is the tree's own short-nib width (git rev-parse --short=10).
advertised_hashes() {
  grep -oE '\b[0-9a-f]{10}\b' "$1" 2>/dev/null | sort -u || true
}

# Three honest reaches, in narrowing order. on-main implies a remote carries it;
# on-remote means a clone that fetches all branches can still walk back; local-only
# means the promise holds on this machine and nowhere else.
reach_of() {
  if git merge-base --is-ancestor "$1" HEAD 2>/dev/null; then
    echo on-main
  elif test -n "$(git branch -r --contains "$1" 2>/dev/null | head -1)"; then
    echo on-remote
  else
    echo local-only
  fi
}

sweep() {
  card=$1
  gone=0; on_main=0; on_remote=0; local_only=0; total=0
  for h in $(advertised_hashes "$card"); do
    total=$((total + 1))
    if git cat-file -e "$h" 2>/dev/null; then
      r=$(reach_of "$h")
      case $r in
        on-main)    on_main=$((on_main + 1)) ;;
        on-remote)  on_remote=$((on_remote + 1)) ;;
        local-only) local_only=$((local_only + 1)) ;;
      esac
      echo "hash $h resolves=yes reach=$r"
    else
      gone=$((gone + 1))
      echo "hash $h resolves=NO reach=none"
    fi
  done
  echo "advertised=$total"
  echo "gone=$gone"
  echo "on_main=$on_main"
  echo "on_remote=$on_remote"
  echo "local_only=$local_only"
}

if test "$MODE" = "prove-red"; then
  # The control card MUST advertise hashes that resolve nowhere, and the guard MUST
  # REFUSE when swept over it -- shown by exiting non-zero, not merely reported. A
  # guard whose RED path is described rather than demonstrated is a habit, not a check.
  test -f "$CONTROL" || { echo "control_verdict=missing"; exit 1; }
  out=$(sweep "$CONTROL")
  echo "$out" | sed 's/^/control_/'
  cg=$(echo "$out" | sed -n 's/^gone=//p')
  if test "$cg" -ge 1; then
    echo "RED_floating_nib_caught=$cg"
    exit 1
  fi
  echo "control_verdict=MISSED"
  exit 1
fi

test -f "$CARD" || { echo "card_verdict=missing"; exit 1; }
echo "card=$CARD"
sweep "$CARD"

# The Git nib field is read BY NAME, never as "the first hash in the file" -- the
# fault this guard was rewritten to fix. Condensing the card moved a cairn row above
# the nib line, so a first-match read had been grading a cairn against the nib's law.
nib=$(grep -oE '^\*\*Git nib:\*\* .[0-9a-f]{10}' "$CARD" | grep -oE '[0-9a-f]{10}' | head -1 || true)
if test -z "$nib"; then
  echo "git_nib=absent"
  echo "verdict=NO_NIB_FIELD"
  exit 1
fi
echo "git_nib=$nib"
echo "git_nib_reach=$(reach_of "$nib")"
echo "git_nib_state_law=tools/remember_git_nib_witness.rish"

# Split the nib's own local-only from the cairns'. The pre-amend sibling hash is
# unreachable by construction -- the seated pin-then-amend ritual pins the hash and
# then the amend replaces it -- and remember_git_nib_witness names that convention
# flaw in its own text. Counting it beside the cairns would report a known, accepted
# convention as if it were a broken walk-back.
sweep_out=$(sweep "$CARD")
gone=$(echo "$sweep_out" | sed -n 's/^gone=//p')
local_only=$(echo "$sweep_out" | sed -n 's/^local_only=//p')
nib_reach=$(reach_of "$nib")
if test "$nib_reach" = "local-only"; then
  echo "local_only_cairns=$((local_only - 1))"
  echo "nib_local_only=yes_expected_pre_amend_sibling"
else
  echo "local_only_cairns=$local_only"
  echo "nib_local_only=no"
fi

if test "$gone" -eq 0; then
  echo "verdict=ok"
else
  echo "verdict=FLOATING_CLAIM"
  exit 1
fi
