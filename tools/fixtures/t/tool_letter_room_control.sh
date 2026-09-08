#!/bin/sh
# tools/fixtures/t/tool_letter_room_control.sh -- prove the letter-room scan can red, in a pen.
#
# WHY A CONTROL. A guard proven only in the passing direction cannot be told from a bypass. Every
# refusal below is PLANTED into a throwaway git repository, seen to bite, and then LIFTED and seen
# to come back green -- so a reading is never mistaken for a wall that was never there.
#
# WHY A REAL GIT REPOSITORY rather than a bare directory. The scan reads `git ls-files`, so a pen
# that is not a repository would answer nothing and every leg would pass for the wrong reason.
#
# USAGE
#   sh tools/fixtures/t/tool_letter_room_control.sh
#
# Read by tools/t/tool_letter_room_witness.rish. Run from anywhere.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
real="$root/tools/fixtures/t/tool_letter_room_scan.sh"
[ -f "$real" ] || { echo "control: the scan is missing at $real"; exit 1; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/tool-letter-room-pen-XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

mkdir -p "$pen/tools/fixtures/t"
cp "$real" "$pen/tools/fixtures/t/tool_letter_room_scan.sh"

( cd "$pen" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )

caught=0
behaviors=0

# Every leg runs the scan from inside the pen, against the pen's own index.
ask() { ( cd "$pen" && git add -A >/dev/null 2>&1; sh tools/fixtures/t/tool_letter_room_scan.sh 2>&1 || true ); }
says() { ask | grep -q "$1"; }

check() {
  behaviors=$((behaviors + 1))
  if says "$1"; then
    caught=$((caught + 1))
  else
    echo "control: MISSED -- expected [$1]"
    echo "$(ask)"
    exit 1
  fi
}

# ---- a clean pen ---------------------------------------------------------
mkdir -p "$pen/tools/c" "$pen/tools/ca" "$pen/tools/fixtures/c"
: > "$pen/tools/c/copal_seat_prompt.txt"
: > "$pen/tools/ca/caravan_suite_witness.rish"
: > "$pen/tools/fixtures/c/copal_scan.sh"
check '^verdict=ok'
check '^misfiled=0'
# BOTH ROOM SHAPES PASS, and the scan counts itself. A one-letter room and the two-letter room one deeper are equally lawful,
# because the resolver TRIES both rather than looking up which letters split.
check '^matched=4'
check '^letter_rooms=4'

# ---- a misfiled file under tools/ ---------------------------------------
: > "$pen/tools/c/unshared_citation_witness.rish"
check '^verdict=misfiled'
check 'misfiled: tools/c/unshared_citation_witness.rish'
check '^ceiling_held=no'
rm -f "$pen/tools/c/unshared_citation_witness.rish"
check '^verdict=ok'

# ---- a misfiled file under tools/fixtures/ ------------------------------
# The elder sweep found eight of these and no scan was reading the room at all.
: > "$pen/tools/fixtures/c/retired_word_scan.sh"
check '^verdict=misfiled'
check 'misfiled: tools/fixtures/c/retired_word_scan.sh'
rm -f "$pen/tools/fixtures/c/retired_word_scan.sh"
check '^verdict=ok'

# ---- a named room is judged by nothing ----------------------------------
# `bin`, `gen`, `hooks`, `rye` and the fixture corpus rooms are three characters or more, so the
# letter rule never reaches them and a file inside one can carry any name at all.
mkdir -p "$pen/tools/hooks" "$pen/tools/fixtures/caravan_ladder_corpus"
: > "$pen/tools/hooks/commit-msg"
: > "$pen/tools/fixtures/caravan_ladder_corpus/top.rye"
check '^verdict=ok'
check '^named_rooms=2'

# ---- a directory under a letter room follows its OWN name ---------------
# `tools/m/mind-bin/git` is lawful: the room follows the directory `mind-bin`, and the shim keeps
# the name `git` because a PATH directory finds a program by its name. A census reading LEAF
# basenames reports this as a mismatch it can never stop reporting; this one reads the entry
# directly under the room, so it passes honestly and needs no exemption.
mkdir -p "$pen/tools/m/mind-bin"
: > "$pen/tools/m/mind-bin/git"
check '^verdict=ok'
# And the directory itself is still judged: a directory in the wrong room reds like a file.
mkdir -p "$pen/tools/c/mind-shell"
: > "$pen/tools/c/mind-shell/.zshenv"
check '^verdict=misfiled'
check 'misfiled: tools/c/mind-shell'
rm -rf "$pen/tools/c/mind-shell"
check '^verdict=ok'

# ---- an untracked file is not judged ------------------------------------
# A guard that reds on a lap's own scratch is a guard somebody turns off. The scan reads the index,
# so this file is invisible until somebody stages it -- and visible on the lap they do.
: > "$pen/tools/c/unshared_scratch.txt"
out=$( cd "$pen" && sh tools/fixtures/t/tool_letter_room_scan.sh 2>&1 || true )
behaviors=$((behaviors + 1))
case "$out" in
  *"verdict=ok"*) caught=$((caught + 1)) ;;
  *) echo "control: MISSED -- an untracked file was judged"; echo "$out"; exit 1 ;;
esac
check '^verdict=misfiled'
( cd "$pen" && git rm -q --cached tools/c/unshared_scratch.txt >/dev/null 2>&1 || true )
rm -f "$pen/tools/c/unshared_scratch.txt"
check '^verdict=ok'

# ---- the ceiling, proven from both sides --------------------------------
# One plant against a ceiling of one walks free; a second against the same ceiling refuses. A
# ceiling proven in one direction only cannot be told from an override nobody reads.
: > "$pen/tools/c/unshared_one.rish"
behaviors=$((behaviors + 1))
out=$( cd "$pen" && git add -A >/dev/null 2>&1; MISFILED_CEILING=1 sh tools/fixtures/t/tool_letter_room_scan.sh 2>&1 || true )
case "$out" in
  *"verdict=ok"*) caught=$((caught + 1)) ;;
  *) echo "control: MISSED -- one plant under a ceiling of one should walk free"; echo "$out"; exit 1 ;;
esac
: > "$pen/tools/c/unshared_two.rish"
behaviors=$((behaviors + 1))
out=$( cd "$pen" && git add -A >/dev/null 2>&1; MISFILED_CEILING=1 sh tools/fixtures/t/tool_letter_room_scan.sh 2>&1 || true )
case "$out" in
  *"verdict=misfiled"*) caught=$((caught + 1)) ;;
  *) echo "control: MISSED -- two plants over a ceiling of one should refuse"; echo "$out"; exit 1 ;;
esac
( cd "$pen" && git rm -q --cached tools/c/unshared_one.rish tools/c/unshared_two.rish >/dev/null 2>&1 || true )
rm -f "$pen/tools/c/unshared_one.rish" "$pen/tools/c/unshared_two.rish"
check '^verdict=ok'

# ---- the arithmetic is asked, not assumed -------------------------------
check '^entries=5'

# ---- a tree with no letter room at all ----------------------------------
# The scan says it has no subject rather than answering zero, because a reading of nothing and a
# clean tree read alike from the outside (REDS %576, one room over).
pen2=$(mktemp -d "${TMPDIR:-/tmp}/tool-letter-room-empty-XXXXXX")
# The copy is placed in a NAMED room here, since the scan's own home `tools/fixtures/t/` is itself
# a letter room -- so a pen holding the scan at its usual path can never have zero letter rooms,
# and the leg would pass for the wrong reason.
mkdir -p "$pen2/tools/gen" "$pen2/tools/hooks"
cp "$real" "$pen2/tools/gen/tool_letter_room_scan.sh"
: > "$pen2/tools/hooks/commit-msg"
( cd "$pen2" && git init -q . && git config user.email pen@example.invalid && git config user.name pen && git add -A >/dev/null 2>&1 )
behaviors=$((behaviors + 1))
out=$( cd "$pen2" && sh tools/gen/tool_letter_room_scan.sh 2>&1 || true )
case "$out" in
  *"verdict=no_rooms"*) caught=$((caught + 1)) ;;
  *) echo "control: MISSED -- a tree with no letter room should say so"; echo "$out"; exit 1 ;;
esac
rm -rf "$pen2"

echo "control_behaviors=$behaviors"
echo "control_caught=$caught"
[ "$behaviors" -eq "$caught" ] || { echo "control_verdict=short"; exit 1; }
echo "control_verdict=ok"
