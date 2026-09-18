#!/bin/sh
# tools/f/fleet_claim.sh -- say what you are building, before it exists.
#
#   sh tools/f/fleet_claim.sh --open <name> --paths "<path> ..." --what "<one plain sentence>"
#   sh tools/f/fleet_claim.sh --close <name>
#
# WHY. Absence is checkable and intent is not, and that gap cost two ships a build apiece on
# `20260911` -- incense withdrew `port_registry` whole against a peer's `port_band`, and bakery
# dropped a 29-leg port census into the same peer's scan. The reader is
# `tools/fixtures/f/fleet_claim_scan.sh`; this is the writer, and it exists so a claim carries a
# one-clock stamp, a UTC epoch, and the seat the roster names, rather than three things a hand
# gets subtly wrong at the head of a lap.
#
# THE ORDER, AND IT IS THE WHOLE HABIT. Check, claim, push, build:
#
#   sh tools/fixtures/f/fleet_claim_scan.sh --check tools/x/thing_scan.sh   # is anyone on this?
#   sh tools/f/fleet_claim.sh --open thing --paths "tools/x/thing_scan.sh" --what "..."
#   git add construction/fleet-claims.kyri construction/ITINERARY.md          # BOTH: see the card clause
#   git commit && git push xy                                                 # now a peer can read it
#
# A CLAIM UNPUSHED IS A CLAIM NOBODY CAN READ, which is the one way to hold this tool and gain
# nothing. The reader says `board=local` when it meets that state, out loud.
#
# IDEMPOTENT, WHICH IS THE WATER ROW'S OWN LAW. `foundations/20260823-222019_what-brix-infuse-is.md`
# asks that `infusion(world') -> world'` -- running a declaration twice moves nothing. Opening a
# claim whose name, seat, paths and sentence already stand leaves this file BYTE-IDENTICAL and says
# `claim_unchanged`. Opening one whose paths or sentence changed refreshes those two fields and
# KEEPS the original stamp and epoch, because age measures how long you have been building rather
# than when you last edited the line.
#
# IT WRITES THROUGH THE ORIGINAL INODE (`cat "$tmp" > "$f"`, never `mv`), so the board's tracked
# mode survives the rewrite -- `.claude/rules/exec-bit.md`, where a repoint pass dropped 39 files
# from 100755 in one commit and no line-reading guard could see it.
#
# IT NEVER COMMITS AND NEVER PUSHES. A tool that ships on its own is a tool that surprises, and the
# send is the hand's.
#
# IT CARRIES THE OPERATOR CARD, AND THAT IS A SECOND FILE RATHER THAN A SECOND HABIT. A claiming lap
# makes two commits this writer causes -- the lead-in `--open` before the build and the `--close`
# after it -- and while it wrote `construction/fleet-claims.kyri` alone, each of those commits
# carried the board and left the card behind. The card's `Git nib` constant then names HEAD~2, and
# `tools/r/remember_git_nib_witness.rish` reads `stale` for the whole build window. Measured over
# this tree's 204 claim-opening commits: 185 stale under the guard's own state predicate, 184 of
# them commits whose ONLY file is the board. That window is exactly where the ORDER clause puts the
# cold endurance run, so the fleet's most expensive reading carried a manufactured red on every lap
# that claimed.
#
# The arithmetic is rule 5's, unchanged: the nib is `git rev-parse --short=10 HEAD` read BEFORE the
# commit is made, since that HEAD becomes its parent. So this is a widening of a seated shape rather
# than a new one, and the bytes are moved by the seated writer,
# `tools/fixtures/r/remember_git_nib_write.sh`, which refuses before it mutates.
#
# ONLY WHEN THE BOARD CHANGED. The idempotent no-op open exits above the write, one step ahead of
# the carry, so `claim_unchanged` leaves BOTH files byte-identical -- the water row's law holds over
# the pair rather than over the board alone. That is the leg that makes this repair provable, and it
# is asserted from both sides in the control.
#
# IT DEGRADES RATHER THAN REFUSES. A pen with no card, a tree outside git, or an absent nib writer
# each leave the board written and print `card_carried=no` with a reason. A readable claim outranks
# a current card, so the board's write stands free of the card's.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
BOARD=${FLEET_CLAIM_BOARD:-construction/fleet-claims.kyri}
MAX_LIVE=${FLEET_CLAIM_MAX:-64}
scan=tools/fixtures/f/fleet_claim_scan.sh

[ -f "$BOARD" ] || { echo "detail: no claim board at $BOARD"; echo "verdict=no_board"; exit 2; }
[ -f "$scan" ]  || { echo "detail: the reader $scan is missing -- a writer with no reader helps nobody"; echo "verdict=no_reader"; exit 2; }

me=$(sh "$scan" --seat)
case "$me" in
  unknown) echo "detail: the roster names no seat for $(basename "$ROOT") -- claim from a rostered tree"; echo "verdict=no_seat"; exit 2 ;;
esac

name=""; paths=""; what=""; verb=""
while [ $# -gt 0 ]; do
  case "$1" in
    --open)  verb=open;  name=${2:-}; shift 2 ;;
    --close) verb=close; name=${2:-}; shift 2 ;;
    --paths) paths=${2:-}; shift 2 ;;
    --what)  what=${2:-};  shift 2 ;;
    *) echo "detail: unknown argument $1"; echo "verdict=bad_argument"; exit 2 ;;
  esac
done

[ -n "$verb" ] || { echo "detail: name --open or --close"; echo "verdict=no_verb"; exit 2; }
[ -n "$name" ] || { echo "detail: a claim needs a name"; echo "verdict=no_name"; exit 2; }
# A name is the record's key, so it stays one plain kebab-case word -- a space would split the
# `claim` line into a name and a stray field, which the reader would take as the name alone.
case "$name" in
  *[!a-z0-9-]*|"") echo "detail: a claim name is lowercase kebab-case: $name"; echo "verdict=bad_name"; exit 2 ;;
esac

# A FIELD VALUE CARRYING A NEWLINE BECOMES TWO LINES, and the second line's first word is read as a
# field key by every reader of this board. Proven on metal in a throwaway pen before this wall was
# built, rather than reasoned: `--what` carrying the continuation line `seat impostor` wrote that
# key straight into the record, and `tools/fixtures/f/fleet_claim_form_scan.sh` answered
# `repeated_field` twice, `corrupting=2`, `verdict=malformed` -- a claim whose `seat` line named a
# seat other than the writer's own. A CORRUPTING finding is the kind `fleet_claim_scan.sh` refuses
# on, so one stray newline in one pasted sentence reds the pre-build reading of every ship here.
#
# REFUSED BY NAME RATHER THAN FOLDED. A `what` sentence is a paragraph a hand composes, and this
# fleet's own run to 1,198 bytes; silently joining its lines would change what a peer reads without
# saying so, which is the fault this board exists to prevent wearing a tidier coat.
has_newline() { [ "$(printf '%s' "$1" | wc -l | tr -d ' ')" != 0 ]; }
if has_newline "$what"; then
  echo "detail: the sentence carries a newline -- its continuation line would be read as a field key, and a record's own seat can be overwritten that way. Write it as one line."
  echo "verdict=multiline_field"; exit 2
fi
if has_newline "$paths"; then
  echo "detail: the paths carry a newline -- space-separate them on one line, since the reader splits this field on spaces"
  echo "verdict=multiline_field"; exit 2
fi

held_by=$(awk -v n="$name" '
  /^[ \t]*#/ { next }
  $1 == "claim" { cur = ($2 == n) ; next }
  $1 == "seat" && cur { print $2; exit }
' "$BOARD")

tmp="$BOARD.claim.$$"
trap 'rm -f "$tmp"' EXIT

form_scan=tools/fixtures/f/fleet_claim_form_scan.sh

# The count of CORRUPTING findings on a board -- the kind that puts a field or a record in the
# wrong place, so some OTHER record reads false, and the kind `fleet_claim_scan.sh` refuses on.
# Answers `unread` when the form reader is absent, rather than guessing zero.
corrupting_count() {
  [ -f "$form_scan" ] || { echo unread; return 0; }
  sh "$form_scan" "$1" 2>/dev/null | awk -F= '$1=="corrupting"{print $2; f=1} END{if(!f) print "unread"}'
}

# THIS WRITER MAY NOT HAND BACK A BOARD WORSE FORMED THAN THE ONE IT INHERITED.
#
# It reads the form reader rather than restating its rules, so a shape that reader learns tomorrow
# is walled here the day it lands -- one fold, drawn out on its own.
#
# IT REFUSES AN INCREASE RATHER THAN A CORRUPTING BOARD, and that distinction is the whole design:
# a hand must still be able to declare on a board a peer damaged, since refusing there would let
# one ship's bad conflict resolution stop every other ship from claiming -- the coordination
# instrument failing shut, at the exact moment the fleet most needs it open.
#
# MEASURED OVER ALL 383 REVISIONS of the living board rather than reasoned from the one in front of
# me: 5 carry a corrupting finding. Three are `%787`'s founding damage, a hand resolving a rebase
# conflict with three newlines lost; two are a rebase keeping both sides of one claim name. NONE
# was authored by a writer run. So this gate is prevention carrying its own proof that it moves
# nothing today -- and the newline refusal above it names the one shape a writer CAN author.
form_gate() {
  before=$1
  after=$(corrupting_count "$tmp")
  case "$before$after" in
    *unread*)
      echo "form_gate=unread"
      echo "detail: $form_scan is absent, so this write goes unchecked -- a readable claim outranks an unread form"
      return 0 ;;
  esac
  if [ "$after" -gt "$before" ]; then
    echo "form_gate=refused"
    echo "detail: this write would take the board from $before corrupting finding(s) to $after -- run sh $form_scan --list to read them. A field ending in a bare claim header is the usual cause; reword it."
    echo "verdict=would_corrupt"
    exit 1
  fi
  echo "form_gate=passed"
  if [ "$before" != 0 ]; then
    echo "board_inherited_corrupting=$before"
    echo "detail: the board arrived carrying $before corrupting finding(s) this write did not add -- your claim stands, and the board wants a hand"
  fi
}

CARD=${FLEET_CLAIM_CARD:-construction/ITINERARY.md}
nib_writer=tools/fixtures/r/remember_git_nib_write.sh

# Carry the card's Git nib to HEAD, so the commit this writer's edit is about to ride in leaves the
# card naming its own parent. Called only after the board's bytes have actually moved.
carry_the_card() {
  if [ ! -f "$CARD" ]; then
    echo "card_carried=no"
    echo "detail: no operator card at $CARD -- the board is written and the card is not this writer's to invent"
    return 0
  fi
  if [ ! -f "$nib_writer" ]; then
    echo "card_carried=no"
    echo "detail: the nib writer $nib_writer is missing -- carry the card by hand before you commit"
    return 0
  fi
  head=$(git rev-parse --short=10 HEAD 2>/dev/null || true)
  case "$head" in
    "") echo "card_carried=no"; echo "detail: git names no HEAD here, so there is no parent to pin"; return 0 ;;
  esac
  if out=$(sh "$nib_writer" "$CARD" "$head" 2>&1); then
    changed=$(printf '%s\n' "$out" | awk -F= '$1=="card_changed"{print $2}')
    echo "card_carried=yes"
    echo "card_nib=$head"
    echo "card_changed=${changed:-unknown}"
  else
    echo "card_carried=no"
    echo "detail: the nib writer refused -- $(printf '%s' "$out" | tr '\n' ' ')"
  fi
}

if [ "$verb" = close ]; then
  [ -n "$held_by" ] || { echo "detail: no live claim named $name"; echo "verdict=no_such_claim"; exit 2; }
  [ "$held_by" = "$me" ] || { echo "detail: $name is $held_by's claim -- a seat closes its own"; echo "verdict=not_yours"; exit 2; }
  awk -v n="$name" '
    /^[ \t]*#/ { print; next }
    /^[ \t]*$/ { drop = 0; print; next }
    $1 == "claim" { drop = ($2 == n); if (drop) next }
    { if (!drop) print }
  ' "$BOARD" > "$tmp"
  form_gate "$(corrupting_count "$BOARD")"
  cat "$tmp" > "$BOARD"
  carry_the_card
  echo "closed=$name"
  echo "detail: the record of what landed is the commit; of what was withdrawn, the session log. This board's history is git log."
  echo "verdict=closed"
  exit 0
fi

# --- open ------------------------------------------------------------------------------------
[ -n "$paths" ] || { echo "detail: a claim names the paths it intends to create"; echo "verdict=no_paths"; exit 2; }
[ -n "$what"  ] || { echo "detail: a claim carries one plain sentence -- it is the reading that catches a peer building the same thing at another path"; echo "verdict=no_what"; exit 2; }

if [ -n "$held_by" ] && [ "$held_by" != "$me" ]; then
  echo "detail: $name is already claimed by $held_by -- read the board and pick another name, or talk to them"
  echo "verdict=name_taken"
  exit 1
fi

live=$(awk '/^[ \t]*#/ { next } $1 == "claim" { n++ } END { print n + 0 }' "$BOARD")
if [ -z "$held_by" ] && [ "$live" -ge "$MAX_LIVE" ]; then
  echo "detail: the board already holds $live live claims, at the bound of $MAX_LIVE -- close what has landed"
  echo "verdict=board_full"
  exit 1
fi

stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)
epoch=$(date -u +%s)

# An existing claim of this seat's keeps its stamp and epoch: age measures how long the build has
# been running, never when the line was last edited.
if [ -n "$held_by" ]; then
  stamp=$(awk -v n="$name" '/^[ \t]*#/{next} $1=="claim"{c=($2==n);next} $1=="stamp"&&c{print $2;exit}' "$BOARD")
  epoch=$(awk -v n="$name" '/^[ \t]*#/{next} $1=="claim"{c=($2==n);next} $1=="epoch"&&c{print $2;exit}' "$BOARD")
fi

awk -v n="$name" '
  /^[ \t]*#/ { print; next }
  /^[ \t]*$/ { drop = 0; print; next }
  $1 == "claim" { drop = ($2 == n); if (drop) next }
  { if (!drop) print }
' "$BOARD" > "$tmp"
{
  printf 'claim %s\n' "$name"
  printf 'seat %s\n'  "$me"
  printf 'stamp %s\n' "$stamp"
  printf 'epoch %s\n' "$epoch"
  printf 'paths %s\n' "$paths"
  printf 'what %s\n'  "$what"
} >> "$tmp"

if cmp -s "$tmp" "$BOARD"; then
  echo "claim=$name"
  echo "verdict=claim_unchanged"
  exit 0
fi
form_gate "$(corrupting_count "$BOARD")"
cat "$tmp" > "$BOARD"
carry_the_card
echo "claim=$name"
echo "seat=$me"
echo "stamp=$stamp"
echo "detail: stage BOTH construction/fleet-claims.kyri and $CARD, then push before you build -- an unpushed claim is one no peer can read, and a card left unstaged reds remember_git_nib for the whole window"
echo "verdict=claimed"
