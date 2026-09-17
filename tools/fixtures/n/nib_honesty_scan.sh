#!/bin/sh
# Nib-honesty guard -- every hash the living operator card advertises resolves,
# and the reachability of each is named rather than assumed.
#
# The card advertises hashes in more than one voice. One is the Git nib, the
# landed edge of the send; the others are CHECKPOINTS -- walk-back nibs recorded
# before a debride, whose whole promise (.claude/rules/checkpoint.md) is that the
# departing card stays one git-show away. Those two voices obey different laws:
#
#   THE NIB     is HEAD, HEAD's pre-amend sibling, or HEAD's parent. That law
#               belongs to tools/r/remember_git_nib_witness.rish, the loom booked
#               after REDS %103 fired twice, and is NOT re-implemented here.
#   A CHECKPOINT is OFF main by construction after a deep debride -- the rewrite
#               is what makes the walk-back worth recording. Demanding that a
#               checkpoint be an ancestor of HEAD is demanding it not be a checkpoint.
#
# So the one law this guard owns, over EVERY advertised hash alike:
#
#   HARD  -- every advertised hash RESOLVES to a real commit. A hash that
#            resolves nowhere is a promise already broken, in any voice.
#   SOFT  -- reachability is NAMED per hash: on-main, on-remote, or local-only.
#            A local-only checkpoint is reported, never failed, because the repair is
#            pushing a pre-debride branch -- a custody call that is Keaton's word,
#            not a guard's. Naming it is the guard's whole job here.
#
#   sh tools/fixtures/n/nib_honesty_scan.sh
#   sh tools/fixtures/n/nib_honesty_scan.sh prove-red
#   sh tools/fixtures/n/nib_honesty_scan.sh prove-double
#
# Read-only: no network, no key, no funds, no writes to the card.
set -eu

MODE=${1:-}
CARD=${CARD:-construction/ITINERARY.md}
CONTROL=tools/fixtures/nib_honesty_control/floating_nib_control.md
DOUBLE_CONTROL=tools/fixtures/nib_honesty_control/double_nib_control.md
SINGLE_CONTROL=tools/fixtures/nib_honesty_control/single_nib_control.md

# Ten hex digits is the tree's own short-nib width (git rev-parse --short=10),
# and hexadecimal admits the decimals -- so the run alone cannot say whether a
# ten-character token is a commit or a number. A grep for the character class
# read Diffuser's account of an awk generator, `seed * 1103515245 % 2147483648`,
# as two advertised commits and refused a healthy tree (REDS %782).
#
# Three readings decide it, in order, and each covers what the one before cannot:
#
#   POSITION   -- a key standing immediately before the token, separated only by
#                 punctuation and space: `Git nib`, `checkpoint`, `walk-back nib`.
#                 Position outranks shape, so an all-decimal nib is still gated.
#                 Measured on this history, 52 of 5,138 commits carry a short hash
#                 of ten decimal digits -- one in 99 -- so shape alone would drop
#                 a real hash silently, which is the direction an honesty guard
#                 can least afford.
#   SHAPE      -- where no key names it, a run carrying at least one of a-f is a
#                 hash claim and answers to the hard law below.
#   RESOLUTION -- an all-decimal run standing in bare prose is a NUMERAL unless
#                 the object store resolves it, and a numeral is reported rather
#                 than refused. Measurement decides the one case shape cannot.
#
# The residue, named rather than hidden: an all-decimal prose hash that a rewrite
# has floated reads as a numeral and leaves the population -- one prose hash in 99
# by the measurement above. The bytes carry no more than that, which is why the
# reading stops here rather than guessing.
classify_tokens() {
  awk '
    function keyed(p) { return tolower(p) ~ /(git nib|walk-back nib|checkpoint)[^a-z0-9]*$/ }
    BEGIN {
      # Spelled out rather than written [0-9a-f]{10}: an interval expression is
      # the one piece of ERE an awk on a stranger machine may decline.
      hex = "[0-9a-f]"
      pat = hex hex hex hex hex hex hex hex hex hex
      rank["numeral"] = 1; rank["prose_hex"] = 2; rank["keyed"] = 3
    }
    {
      line = $0; rest = line; off = 0
      while (match(rest, pat)) {
        s = RSTART; l = RLENGTH; tok = substr(rest, s, l)
        before = (off + s > 1) ? substr(line, off + s - 1, 1) : ""
        after  = substr(line, off + s + l, 1)
        # A longer run is no token at all: the neighbours decide the boundary.
        if (before !~ /[0-9A-Za-z]/ && after !~ /[0-9A-Za-z]/) {
          prefix = substr(line, 1, off + s - 1)
          if (keyed(prefix))        c = "keyed"
          else if (tok ~ /[a-f]/)   c = "prose_hex"
          else                      c = "numeral"
          # One token may stand in two voices; the strongest reading wins, so a
          # hash named by a key once is never downgraded by a bare mention later.
          if (!(tok in cls) || rank[c] > rank[cls[tok]]) cls[tok] = c
        }
        off += s + l - 1
        rest = substr(rest, s + l)
      }
    }
    END { for (t in cls) print t "\t" cls[t] }
  ' "$1" 2>/dev/null | sort || true
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
  keyed=0; prose_hex=0; numeral_resolved=0; numeral_read=0
  set -f
  # shellcheck disable=SC2046
  set -- $(classify_tokens "$card")
  set +f
  while test $# -ge 2; do
    h=$1; c=$2; shift 2
    if git cat-file -e "$h" 2>/dev/null; then
      r=$(reach_of "$h")
      case $r in
        on-main)    on_main=$((on_main + 1)) ;;
        on-remote)  on_remote=$((on_remote + 1)) ;;
        local-only) local_only=$((local_only + 1)) ;;
      esac
      total=$((total + 1))
      case $c in
        keyed)     keyed=$((keyed + 1)) ;;
        prose_hex) prose_hex=$((prose_hex + 1)) ;;
        numeral)   numeral_resolved=$((numeral_resolved + 1)) ;;
      esac
      echo "hash $h class=$c resolves=yes reach=$r"
    elif test "$c" = "numeral"; then
      # The one reading shape could not take: ten decimal digits in bare prose,
      # answering to no key and resolving nowhere. It is a number, so it is read
      # rather than refused, and it is printed so the refusal stays inspectable.
      numeral_read=$((numeral_read + 1))
      echo "numeral $h class=numeral resolves=NO read=number"
    else
      gone=$((gone + 1))
      total=$((total + 1))
      case $c in
        keyed)     keyed=$((keyed + 1)) ;;
        prose_hex) prose_hex=$((prose_hex + 1)) ;;
      esac
      echo "hash $h class=$c resolves=NO reach=none"
    fi
  done
  echo "advertised=$total"
  echo "gone=$gone"
  echo "on_main=$on_main"
  echo "on_remote=$on_remote"
  echo "local_only=$local_only"
  echo "keyed=$keyed"
  echo "prose_hex=$prose_hex"
  echo "numeral_resolved=$numeral_resolved"
  echo "numeral_read=$numeral_read"
}

# The nib field, enumerated. Named as a function rather than spelled twice, so the live
# gate below and the prove-double path read one pattern -- a pen that spells its own copy
# can pass while the gate it proves reads something else.
nib_fields_of() {
  grep -oE '^\*\*Git nib:\*\* .[0-9a-f]{10}' "$1" | grep -oE '[0-9a-f]{10}' || true
}

if test "$MODE" = "prove-double"; then
  # The nib-count RED path, shown from both sides on two planted cards rather than in
  # prose. DOUBLE carries two Git nib fields whose hashes BOTH resolve, so `gone` stays 0
  # and the ONLY thing that can refuse it is the count -- a refusal proven through the old
  # floating-hash law would prove nothing about this one. SINGLE carries one, and walks.
  test -f "$DOUBLE_CONTROL" || { echo "control_verdict=missing_double"; exit 1; }
  test -f "$SINGLE_CONTROL" || { echo "control_verdict=missing_single"; exit 1; }

  dbl=$(printf '%s' "$(nib_fields_of "$DOUBLE_CONTROL")" | grep -c . || true)
  sgl=$(printf '%s' "$(nib_fields_of "$SINGLE_CONTROL")" | grep -c . || true)
  echo "control_double_lines=$dbl"
  echo "control_single_lines=$sgl"

  # Both controls must be clean under the ELDER law, or this pen is reading that refusal
  # rather than its own. Proven rather than assumed, and printed so it stays inspectable.
  dgone=$(sweep "$DOUBLE_CONTROL" | sed -n 's/^gone=//p')
  sgone=$(sweep "$SINGLE_CONTROL" | sed -n 's/^gone=//p')
  echo "control_double_gone=$dgone"
  echo "control_single_gone=$sgone"

  if test "$dgone" -ne 0 || test "$sgone" -ne 0; then
    echo "control_verdict=CONFOUNDED"
    exit 1
  fi
  if test "$sgl" -ne 1; then
    echo "control_verdict=SINGLE_NOT_FREE"
    exit 1
  fi
  if test "$dbl" -ge 2; then
    echo "RED_nib_named_twice_caught=$dbl"
    exit 1
  fi
  echo "control_verdict=MISSED"
  exit 1
fi

if test "$MODE" = "prove-red"; then
  # The control card MUST advertise hashes that resolve nowhere, and the guard MUST
  # REFUSE when swept over it -- shown by exiting non-zero, not merely reported. A
  # guard whose RED path is described rather than demonstrated is a habit, not a check.
  test -f "$CONTROL" || { echo "control_verdict=missing"; exit 1; }
  out=$(sweep "$CONTROL")
  echo "$out" | sed 's/^/control_/'
  cg=$(echo "$out" | sed -n 's/^gone=//p')
  cn=$(echo "$out" | sed -n 's/^numeral_read=//p')
  echo "RED_numeral_read_free=$cn"
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
# fault this guard was rewritten to fix. Condensing the card moved a checkpoint row above
# the nib line, so a first-match read had been grading a checkpoint against the nib's law.
#
# AND THE FIELD IS COUNTED BEFORE IT IS READ. The extractor took `head -1` and never asked
# whether a SECOND field stood, so a card naming the nib twice had its first line graded
# and its second left unread -- and which of the two the law judged was decided by nothing
# but position. REDS %793: two ships wrote that card in one day, an hour apart, each
# replacing INNER LOOP item 7 with a nib line while updating the real one, leaving
# `git_nib_lines=2` both times. Both duplicates happened to carry the same hash, so the
# wrong reading was harmless by luck rather than by design. The card's own third mention
# says the nib is "named once above ... one fact in one place"; until here, nothing held
# that sentence.
#
# ONE ENUMERATION, READ TWICE. The count and the extraction come off the same list, so a
# card can never be one thing to the gate and another to the reader -- the fault a sibling
# meter booked when three readers each spelled their own roster.
nib_fields=$(nib_fields_of "$CARD")
nib_lines=$(printf '%s' "$nib_fields" | grep -c . || true)
nib=$(printf '%s\n' "$nib_fields" | head -1)
echo "git_nib_lines=$nib_lines"
if test "$nib_lines" -eq 0; then
  echo "git_nib=absent"
  echo "verdict=NO_NIB_FIELD"
  exit 1
fi
if test "$nib_lines" -gt 1; then
  echo "git_nib=$nib"
  echo "advice=a second Git nib field is a positional write that ate the line it landed on -- restore that line and remove the duplicate; the card names the nib once"
  echo "verdict=NIB_NAMED_TWICE"
  exit 1
fi
echo "git_nib=$nib"
echo "git_nib_reach=$(reach_of "$nib")"
echo "git_nib_state_law=tools/r/remember_git_nib_witness.rish"

# Split the nib's own local-only from the checkpoints'. The pre-amend sibling hash is
# unreachable by construction -- the seated pin-then-amend ritual pins the hash and
# then the amend replaces it -- and remember_git_nib_witness names that convention
# flaw in its own text. Counting it beside the checkpoints would report a known, accepted
# convention as if it were a broken walk-back.
sweep_out=$(sweep "$CARD")
gone=$(echo "$sweep_out" | sed -n 's/^gone=//p')
local_only=$(echo "$sweep_out" | sed -n 's/^local_only=//p')
nib_reach=$(reach_of "$nib")
if test "$nib_reach" = "local-only"; then
  echo "local_only_checkpoints=$((local_only - 1))"
  echo "nib_local_only=yes_expected_pre_amend_sibling"
else
  echo "local_only_checkpoints=$local_only"
  echo "nib_local_only=no"
fi

if test "$gone" -eq 0; then
  echo "verdict=ok"
else
  # The repair, printed where the fault is met. A hash reaching this branch is one of
  # three things and each has its own answer: a commit still only local, which is
  # pushed; a commit a rebase rewrote, whose new hash is read and re-pinned; or a
  # WITHDRAWN commit -- tagged locally so nothing was lost, never pushed by design --
  # whose TAG NAME and tree are what a reader elsewhere can act on, since the tag is
  # the half of a walk-back that travels and the hash is the half that does not.
  # The elder guard reported gone=1 and stopped, so a reader met an exact number with
  # no way to act on it -- REDS %528's lesson, one room over.
  echo "advice=gone means pushable, rewritten, or withdrawn -- push it, re-pin it, or name its tag and tree"
  echo "verdict=FLOATING_CLAIM"
  exit 1
fi
