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
#   git add construction/fleet-claims.kyri && git commit && git push xy     # now a peer can read it
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

held_by=$(awk -v n="$name" '
  /^[ \t]*#/ { next }
  $1 == "claim" { cur = ($2 == n) ; next }
  $1 == "seat" && cur { print $2; exit }
' "$BOARD")

tmp="$BOARD.claim.$$"
trap 'rm -f "$tmp"' EXIT

if [ "$verb" = close ]; then
  [ -n "$held_by" ] || { echo "detail: no live claim named $name"; echo "verdict=no_such_claim"; exit 2; }
  [ "$held_by" = "$me" ] || { echo "detail: $name is $held_by's claim -- a seat closes its own"; echo "verdict=not_yours"; exit 2; }
  awk -v n="$name" '
    /^[ \t]*#/ { print; next }
    /^[ \t]*$/ { drop = 0; print; next }
    $1 == "claim" { drop = ($2 == n); if (drop) next }
    { if (!drop) print }
  ' "$BOARD" > "$tmp"
  cat "$tmp" > "$BOARD"
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
cat "$tmp" > "$BOARD"
echo "claim=$name"
echo "seat=$me"
echo "stamp=$stamp"
echo "detail: push it before you build -- an unpushed claim is one no peer can read"
echo "verdict=claimed"
