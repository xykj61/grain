#!/bin/sh
# tools/fixtures/r/remember_git_nib_write.sh -- write a derived nib onto the operator card, and
# refuse rather than mutate whenever the result would not read back as that nib.
#
# WHY A WRITER AT ALL. `.claude/rules/remember-git-nib.md` asks a hand to copy ten hexadecimal
# characters into `construction/ITINERARY.md` at the end of every send. A round on `20260906.010726`
# measured what that costs: the number was falsified four times in ninety minutes -- three by peers
# landing mid-package, and once by a hand typing `f1498bd7f5` where git answered `f1498bd7fc`, one
# wrong character in the last position, inside the very note arguing for this program. A hand
# copying hex under time pressure has a per-character failure rate; `git rev-parse` has none.
#
# WHY THE BYTES MOVE HERE AND THE CLAIM STAYS IN RISHI. The same division `readme_metrics_splice.sh`
# already keeps: the language that checks the fact owns the fact, and the tool that moves bytes
# moves bytes. `tools/r/remember_git_nib.rish` derives the nib, proves it names a commit, and hands
# it here; this file finds the one token to replace and refuses to guess about anything else.
#
# WHY THIS IS NOT A FLAG ON THE GUARD. `tools/r/remember_git_nib_witness.rish` says twice in its own
# header that it never edits the card, and a guard that repairs what it measures can no longer
# testify about it -- a fault in the writer would be written and then reported green by the same
# hand. Two parts that stand free: this writes, that judges, and neither knows the other
# (`foundations/20260823-204456_single-stranded.md`).
#
# THE FENCE, and why it is drawn at the backticks. The guard's extractor reads the FIRST 7-to-40
# character hexadecimal run on the FIRST `Git nib:` line, whatever that run is. English holds words
# that are entirely hexadecimal and long enough -- `defaced` is seven -- so a card whose nib line
# carries prose can present the guard a token that is not a hash at all. This writer replaces only
# a BACKTICKED run, which is the shape the card actually writes, and then reads its own result back
# with the guard's own extractor. Where the two disagree the write is refused and the card is never
# opened for writing, so a card is never left in a state the guard would still refuse.
#
# REFUSAL BEFORE MUTATION. Every check runs against a temporary. The card is touched only after the
# result has been proven to read back, and only when the bytes actually differ -- so a second run
# reports `card_changed=no` and does not even open the file.
#
# USAGE
#   sh tools/fixtures/r/remember_git_nib_write.sh <card> <nib>
#
# Prints `nib_written=<nib>` and `card_changed=yes|no`. Exit 0 when the card names the nib, 1 when
# it refuses. Driven by tools/r/remember_git_nib.rish; proven by
# tools/r/remember_git_nib_write_witness.rish over tools/fixtures/r/remember_git_nib_write_control.sh.
# No network, no key, no funds, no device.

set -eu

card="${1-}"
nib="${2-}"

[ -n "$card" ] || { echo "nib-write: refused -- name the card to write" >&2; exit 1; }
[ -f "$card" ] || { echo "nib-write: refused -- no such card: $card" >&2; exit 1; }

# invariant: a nib is lowercase hexadecimal, so the token written is the token git prints.
case "$nib" in
  "") echo "nib-write: refused -- the nib is empty" >&2; exit 1 ;;
  *[!0-9a-f]*) echo "nib-write: refused -- the nib is not lowercase hexadecimal: $nib" >&2; exit 1 ;;
esac

# invariant: 7 to 40 characters is exactly the width the guard's extractor reads, so a nib outside
# it could be written and then not seen -- the one shape a writer must never produce.
len=$(printf %s "$nib" | wc -c | tr -d ' ')
if [ "$len" -lt 7 ] || [ "$len" -gt 40 ]; then
  echo "nib-write: refused -- a nib is 7 to 40 characters, this one is $len: $nib" >&2
  exit 1
fi

grep -q 'Git nib:' "$card" || {
  echo "nib-write: refused -- $card carries no 'Git nib:' line, and this never invents one" >&2
  exit 1
}

work="$(mktemp)"
trap 'rm -f "$work"' EXIT INT TERM

# The substitution: the first backticked hexadecimal run on the first `Git nib:` line that has one,
# leaving the backticks and every other character on the line exactly where they were.
awk -v nib="$nib" '
  !done && /Git nib:/ {
    if (match($0, /`[0-9a-f]{7,40}`/)) {
      $0 = substr($0, 1, RSTART) nib substr($0, RSTART + RLENGTH - 1)
      done = 1
    }
  }
  { print }
' "$card" > "$work"

# invariant: a write never empties the file it edits.
[ -s "$work" ] || { echo "nib-write: refused -- the result was empty; $card is untouched" >&2; exit 1; }

# invariant: the result reads back, through the GUARD's extractor, as the nib we were handed.
# This is the whole safety of the program: a disagreement about which token is the nib refuses
# here, before the card has been opened for writing.
back=$(awk '/Git nib:/{ if (match($0, /[0-9a-f]{7,40}/)) { print substr($0, RSTART, RLENGTH); exit } }' "$work")
if [ "$back" != "$nib" ]; then
  echo "nib-write: refused -- the result reads back as '${back:-nothing}' rather than '$nib'; $card is untouched" >&2
  exit 1
fi

if cmp -s "$work" "$card"; then
  echo "nib_written=$nib"
  echo "card_changed=no"
  exit 0
fi

# `cat` through the original inode rather than `mv`, so the mode the repository tracks survives
# the rewrite (.claude/rules/exec-bit.md).
cat "$work" > "$card"
echo "nib_written=$nib"
echo "card_changed=yes"
