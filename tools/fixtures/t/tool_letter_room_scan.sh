#!/bin/sh
# tools/fixtures/t/tool_letter_room_scan.sh -- every tool in the letter room its own name says.
#
# WHAT THIS ANSWERS. `tools/` and `tools/fixtures/` fold by FIRST SPRIG LETTER: an entry named
# `caravan_suite_witness.rish` lives in `tools/ca/` or `tools/c/`, and the new path is a pure
# function of the name (`.claude/rules/stamp-and-name.md`, the move of `20260823.144100`). This
# scan reads every entry sitting directly inside a letter room and asks one question of it -- does
# this room match this name? -- then counts the answers:
#
#   sh tools/fixtures/t/tool_letter_room_scan.sh
#   entries=2972  matched=2972  misfiled=0  misfiled_ceiling=0  ceiling_held=yes  (read `20260908.011500`)
#   verdict=ok
#
# WHY IT EXISTS, and it is the second firing rather than the first. On `20260906.182719` a hand
# swept 34 misfiled entries out of 2,030 -- 26 under `tools/` and 8 more under `tools/fixtures/`,
# found by asking the same question of both rooms. That sweep landed whole and left no guard. One
# day later, on `20260907.221559`, five entries had regrown into the wrong room: three of the
# `unshared_citation` family under `r` where `u` was its name, and two of the `retired_word` family
# under `l` where `r` was. Nobody was careless; a file is born wherever the hand that wrote it put
# it, and until something reads the rule at every lap the rule lives in whoever remembers it. A
# lantern that fires twice becomes a loom (`.claude/rules/reds-first.md`).
#
# WHAT IT COSTS TO LET IT REGROW. A misfiled entry is not lost -- `tools/t/tool_path_resolve.rish`
# still finds it by its fourth reading, the basename sweep across every tracked file. What it loses
# is the third: the LETTER RULE, the pure computation that answers with no index, no table, and no
# memory of which files moved. That reading is what makes a stale reference in dated testimony
# resolvable forever, so an entry past it is a reference this tree can only recover by searching.
#
# THE ONE CLAIM, and why it is one rather than three. The check asks only whether the room matches
# the name, and it asks it of the ENTRY DIRECTLY UNDER THE ROOM -- a file or a directory, never a
# leaf several levels down. That single reading is what lets `tools/m/mind-bin/git` pass honestly:
# the room follows the directory `mind-bin`, and the shim inside keeps the name `git` because a
# PATH directory finds a program by its name. The elder census read leaf basenames and reported
# that one as a mismatch it could not stop reporting. There is no exemption list here and none is
# wanted -- an exemption list is a second copy of the fold rule, which is the shape this tree keeps
# learning to refuse.
#
# WHAT A LETTER ROOM IS, measured rather than listed. A room whose name is one or two characters is
# a letter room; every other subdirectory of `tools/` -- `bin`, `fixtures`, `gen`, `hooks`, `rye`,
# `equinox`, the two `proven_seat_*` guests -- is a NAMED room of three characters or more, counted
# in `named_rooms` and judged by nothing. That boundary is the fold's own: `tool_path_resolve`
# computes rooms of one or two characters only, so a name of three cannot collide with one.
#
# WHY THE CEILING DEFAULTS TO ZERO. The tree stands at zero the day this lands, so a ceiling above
# it would welcome the very regrowth the scan exists to catch. The caller may raise it -- the
# control does, to prove the ceiling from both sides -- and no caller in the live tree does.
#
# VERDICTS. ok - misfiled (more misfiled entries than the ceiling welcomes) - no_rooms (the tools
# room is gone or holds no letter room, so this reading has no subject).
#
#
# WHY IT READS IN TWO PASSES OF ONE PROCESS EACH, rather than in two shell loops. The first draft
# derived each triple with `printf | cut` and lowercased each name with `printf | cut | tr`, which
# is about five forked processes per tracked path and six per unique entry: 3,625 paths and 2,972
# entries came to roughly 36,000 processes, and the scan took **78.8 seconds** measured
# `20260908.011500`. Nothing in that reading touches a disk twice or asks the index a second
# question -- it is one string comparison per name, spent almost entirely on process creation at
# about 2.2ms each. So the derivation now splits paths with shell parameter expansion, which forks
# nothing, and the counting runs in a single `awk` that has `tolower` and `substr` built in. The
# reading is unchanged in every particular -- same index, same triples, same `sort -u`, same
# ordering, same counters, same misfiled lines -- and the control proves that by asserting the same
# 25 behaviors it asserted before. It matters because this guard's own reason for existing is that
# five misfilings regrew in ONE DAY: a guard that must run every lap to keep its promise, and costs
# 82 seconds of every lap across eight ships, is a guard somebody eventually moves to `cadence` --
# and the day it moves is the day the letter rule goes back to living in whoever remembers it.
#
# Read by tools/t/tool_letter_room_witness.rish. Proven by
# tools/fixtures/t/tool_letter_room_control.sh. Run from the repository root.


set -eu

ceiling=${MISFILED_CEILING:-0}

# Two temporary files. `work` holds the derived (parent, room, entry) triples so the counting reads
# a settled set rather than a pipeline; `out` holds the counting pass's own output, because the
# shell needs five of those numbers for the arithmetic below and a pipeline would carry them into a
# subshell that exits.
work=$(mktemp)
out=$(mktemp)
trap 'rm -f "$work" "$out"' EXIT INT TERM

# The two rooms that fold by letter, read from the INDEX rather than from disk. `tools/fixtures/`
# folds by the same rule as `tools/` and had eight of the same fault on the day the elder sweep
# ran, so it is read here rather than left to a second scan that could drift from this one. The
# entries come from `git ls-files`, so an untracked scratch file a lap leaves in a letter room is
# not judged -- a guard that reds on somebody's temporary is a guard somebody turns off -- and a
# file staged this lap IS judged, on the lap it arrives.
#
# The split is parameter expansion rather than `cut`: `${rest%%/*}` takes the room and `${rest#*/}`
# drops it, both inside the shell. A path with no second slash has no entry under a room -- a file
# sitting directly in `tools/` or in `tools/fixtures/` -- and `${rest%%/*}` returning the whole
# string is exactly how that is detected, which is the same set `cut -f3` skipped by returning empty.
git ls-files 'tools/*' | while IFS= read -r path; do
  case "$path" in
    tools/fixtures/*) parent=tools/fixtures; rest=${path#tools/fixtures/} ;;
    *) parent=tools; rest=${path#tools/} ;;
  esac
  room=${rest%%/*}
  [ "$room" != "$rest" ] || continue
  erest=${rest#*/}
  entry=${erest%%/*}
  [ -n "$entry" ] || continue
  printf '%s\t%s\t%s\n' "$parent" "$room" "$entry"
done | sort -u > "$work"

# One awk pass over the settled triples. It asks the same single question of each entry -- does this
# room match this name? -- and prints the misfiled lines first and the five counters last, which is
# the order the shell loop printed them in. `tolower` reaches the name only, never the room: an
# uppercase room has never matched and does not begin to now.
awk -F'	' '
{
  parent = $1; room = $2; entry = $3
  key = parent "/" room
  # A room of three characters or more is a NAMED room, outside the letter rule entirely.
  if (length(room) > 2) {
    if (!(key in named)) { named[key] = 1; named_rooms++ }
    next
  }
  if (!(key in rooms)) { rooms[key] = 1; letter_rooms++ }
  entries++
  one = tolower(substr(entry, 1, 1))
  two = tolower(substr(entry, 1, 2))
  if (room == one || room == two) {
    matched++
  } else {
    misfiled++
    print "misfiled: " parent "/" room "/" entry " room=" room " name_says=" one " or " two
  }
}
END {
  print "letter_rooms=" letter_rooms + 0
  print "named_rooms=" named_rooms + 0
  print "entries=" entries + 0
  print "matched=" matched + 0
  print "misfiled=" misfiled + 0
}
' "$work" > "$out"

cat "$out"

letter_rooms=$(sed -n 's/^letter_rooms=//p' "$out")
entries=$(sed -n 's/^entries=//p' "$out")
matched=$(sed -n 's/^matched=//p' "$out")
misfiled=$(sed -n 's/^misfiled=//p' "$out")

echo "misfiled_ceiling=$ceiling"

if [ "$letter_rooms" -eq 0 ]; then
  echo "verdict=no_rooms"
  exit 1
fi

# The arithmetic is stated so a reader can check the reading rather than trust it. Every entry is
# counted exactly once, matched or misfiled, and a set that does not sum has measured something
# other than the entries.
if [ "$((matched + misfiled))" -ne "$entries" ]; then
  echo "verdict=unbalanced"
  exit 1
fi

ceiling_held=yes
[ "$misfiled" -le "$ceiling" ] || ceiling_held=no
echo "ceiling_held=$ceiling_held"

verdict=ok
[ "$ceiling_held" = yes ] || verdict=misfiled
echo "verdict=$verdict"
[ "$verdict" = ok ]
