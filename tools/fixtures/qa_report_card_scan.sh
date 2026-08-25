#!/bin/sh
# tools/fixtures/qa_report_card_scan.sh -- the front doors, read as report cards.
#
# WHY. tools/fixtures/prose_register_scan.sh gates one of the four readings a report card carries,
# and gates it well. This scan runs the whole card over the same documents, so the two readings the
# register meter never took -- can the reader follow it, and does every path it cites still land --
# are counted rather than assumed.
#
# THE ROSTER IS CITED, NEVER COPIED. The door roster is read out of prose_register_scan.sh itself,
# so one list governs both meters. A roster spelled twice is a roster that can quietly disagree with
# itself, which this tree has now booked five times (REDS %187, %190, %192, %199, %201).
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. Door documents whose COUNTED
# readings put them below a B even with a perfect Service score -- that is, pages with a countable
# problem rather than a judged one. Repair is a rewrite per document, so these fall on touch.
#
# WHAT IS NOT GATED, and why. A grade is not a gate. The register share already has its wall at
# tools/p/prose_register_witness.rish, and stacking a second hard ceiling on the same documents
# would red the tree on readings it has never agreed to hold. The card exists to aim a writer, and
# a ratchet aims without refusing.
#
# WHAT IS NOT PROVEN. That an A page is a good page. Four honest proxies, two of them counted here,
# and the second thing to read is always the artifact itself.
#
# USAGE
#   sh tools/fixtures/qa_report_card_scan.sh
#
# Driven by tools/q/qa_report_card_witness.rish. Run from the repository root.

set -u

root=${QA_CARD_ROOT:-.}
card="$root/tools/fixtures/qa_report_card.sh"
reg="$root/tools/fixtures/prose_register_scan.sh"
[ -f "$card" ] || { echo "verdict=card_missing"; exit 1; }
[ -f "$reg" ] || { echo "verdict=register_missing"; exit 1; }

DOOR=$(sed -n 's/^DOOR="\(.*\)"$/\1/p' "$reg" | head -1)
[ -n "$DOOR" ] || { echo "verdict=roster_unreadable"; exit 1; }

total=0
below=0
for f in $DOOR; do
  total=$((total + 1))
  if [ ! -f "$root/$f" ]; then
    below=$((below + 1))
    echo "card: $f absent from the roster it is named on"
    continue
  fi
  # Service at 100 on purpose: this reading asks what the COUNTED half alone can settle, so a
  # document below B here has a problem a reader could have measured rather than had to judge.
  out=$(QA_CARD_ROOT="$root" sh "$card" "$f" --setting door --service 100 2>&1) || {
    below=$((below + 1)); echo "card: $f could not be read"; continue; }
  comp=$(echo "$out" | sed -n 's/^composite=\([0-9]*\).*/\1/p' | head -1)
  lett=$(echo "$out" | sed -n 's/^letter=\(.*\)/\1/p' | head -1)
  regv=$(echo "$out" | sed -n 's/^register=\([0-9]*\).*/\1/p' | head -1)
  rchv=$(echo "$out" | sed -n 's/^reach=\([0-9]*\).*/\1/p' | head -1)
  trtv=$(echo "$out" | sed -n 's/^truth_counted=\([0-9]*\).*/\1/p' | head -1)
  printf 'card: %s %s (%s) register %s reach %s truth %s\n' "$f" "$lett" "$comp" "$regv" "$rchv" "$trtv"
  [ "$comp" -ge 80 ] || { below=$((below + 1)); printf 'under: %s reads %s on its counted half alone\n' "$f" "$lett"; }
done

# The ceiling only ever falls, and this one fell to ZERO by measurement rather than by edit.
#
# Measured 20260824.161948 over the twelve-document door roster: one document below B on its counted
# half, `docs/README.md`, two sentences of prose carrying eleven links. That reading was reported
# rather than exempted, because a reader deciding it is worth more than a rule guessing it -- and
# the reader's verdict, on 20260825, was that the METER was wrong. A cross-reference budget of one
# per hundred words is written for prose; on an index the links are the content, and the card was
# instructing a writer to pad an index until its denominator carried its own rate. Padding the page
# would have raised the number and damaged the artifact, which is the signature of a meter to fix.
#
# So `qa_report_card.sh` now reads a page's own declaration under two conditions -- declared in the
# header AND under 100 words of prose -- and reports an index's density rather than scoring it.
# `docs/README.md` reads A+ on its counted half with no word of it rewritten, and the ceiling is 0.
# It only ever falls from here.
ceiling=0

echo "card_documents=$total"
echo "card_below_b=$below"
echo "card_ceiling=$ceiling"

if [ "$below" -le "$ceiling" ]; then
  echo "verdict=ok"
else
  echo "verdict=ratchet_rose"
  exit 1
fi
