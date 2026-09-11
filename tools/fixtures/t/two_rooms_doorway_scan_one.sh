#!/usr/bin/env sh
# two_rooms_doorway_scan_one.sh -- per-file doorway verdict for native orchestrator.
set -eu
f="$1"
seating="$2"
base=$(basename "$f")
file_stamp=$(echo "$base" | sed -n 's/^\([0-9]\{8\}-[0-9]\{6\}\).*/\1/p')

# A page's door is read the same way whether or not the page is gated on it, so the token test is
# stated once, here, and every branch below asks it.
#
# A KEY'S OWN LINE IS PREFERRED TO A MENTION OF IT (20260911). `grep -o '**Status:**.*' | head -1`
# takes the FIRST line of the head carrying those characters anywhere, and a page that writes the
# key inside its own prose puts that mention first. `context/TWO_ROOMS.md` -- the law this guard
# enforces -- carries "`**Status:**` or `**Room:**`" in its `Last updated` line at line 4, so the
# reading returned that sentence and called the law's own door silent, three lines above a Status
# reading `checkable-room canon`. So the door line is sought at a line START first, and the
# anywhere-in-line match stays as the fallback the shared header row needs (**Stamp:** ... -
# **Status:** ...), which reading line-starts alone had misreported for 92 pages.
#
# THE RESULT IS TESTED, NEVER THE PIPELINE (20260911). The first draft wrote
# `grep ... | head -1 && return 0`, and `&&` binds to the whole pipeline, whose status is
# `head`'s -- zero whether or not grep matched. So the preferred reading returned empty and
# succeeded, every fallback was skipped, and the census read 122 pages as having no Status line
# where 3 stand. Caught by the number, which is why a change to a reading is measured before it is
# believed.
door_line() {
  _dl=$(printf '%s\n' "$2" | grep -oE "^[[:space:]]*\\*\\*$1[^:]*:\\*\\*.*" | head -1 || true)
  if [ -z "$_dl" ]; then
    _dl=$(printf '%s\n' "$2" | grep -oE "\\*\\*$1[^:]*:\\*\\*.*" | head -1 || true)
  fi
  printf '%s\n' "$_dl"
}

names_room() {
  door_head_local=$(head -25 "$1")
  st=$(door_line Status "$door_head_local" | head -1)
  rm=$(door_line Room "$door_head_local" | head -1)
  printf '%s\n%s\n' "$st" "$rm" \
    | grep -qiE '(^|[^A-Za-z])(checkable|vision(ary)?|mixed|research for understanding)([^A-Za-z]|$)'
}

# A STAMPLESS BASENAME MEANS LIVING, NEVER ELDER (20260911). This branch read `grandfathered` and
# passed 159 pages free on the reasoning that a page with no stamp predates the seating. The mark
# law reads the same absence the other way: *a file whose own basename carries a one-clock stamp is
# testimony, and everything else is living* (`.claude/rules/stamp-and-name.md`). So the exemption
# was pointed at exactly the pages a reader meets first -- `context/LEXICON.md`, the `manual/`
# guides, the `docs-geode/` tutorials -- while the three pages it does gate are dated testimony
# accrete-never-break can never let anyone repair.
#
# The verdict here is unchanged, because raising a wall over 107 living doors in one lap would red
# eight ships for a backlog nobody chose. What changes is that the door is READ and the silence
# COUNTED, under a second ceiling that only falls. The dated ratchet keeps its own number, so a
# page moving between the two classes can never lower one reading by raising the other.
if [ -z "$file_stamp" ]; then
  if names_room "$f"; then
    echo "OK   $f (no one-clock stamp -- living page, room named)"
  else
    echo "LIVING-SILENT $f (no one-clock stamp -- living page, door names no room)"
  fi
  exit 0
fi
if [ "$file_stamp" \< "$seating" ]; then
  echo "OK   $f (before seating $seating)"
  exit 0
fi
# A Status anywhere in the head counts, not only one that begins its line: many pages carry
# it folded into a shared header row (**Stamp:** ... - **Status:** ... - **Voice:** ...), and
# reading only line-starts reported 92 of those as having no Status at all. A wrong diagnosis
# sends the reader to fix something that was never broken.
#
# THE DOOR IS THE HEAD, NOT ONE KEY (20260907). `context/TWO_ROOMS.md` asks a page to name its
# room "at the top", and nine pages under this roster answered under a key literally named
# `**Room:**` rather than `**Status:**`. Two of them spell `Mixed` -- the gloss table's own token,
# at the door, in the law's own word -- and read here as pages that named no room at all. So both
# keys are read now, and a token in either is the door speaking.
#
# THIS WIDENS NO VOCABULARY. The four tokens are unchanged, and the commonest `**Room:**` line in
# this tree answers a DIFFERENT law: `.claude/rules/design-rooms.md` calls a DIRECTORY a room and
# decides it by *would this still be worth reading if the code were deleted?* So
# `**Room:** Design essay -- worth reading with the code deleted` names no two-rooms register, is
# still counted, and is now named as a Room line rather than misreported as a missing Status --
# which is the same wrong-diagnosis cost the paragraph above was written for.
door_head=$(head -25 "$f")
status=$(door_line Status "$door_head" | head -1)
room=$(door_line Room "$door_head" | head -1)
if [ -z "$status" ] && [ -z "$room" ]; then
  echo "FAIL $f missing Status line (stamp $file_stamp)"
  exit 1
fi
# THE TOKEN IS A WORD, NOT A SUBSTRING (20260907). Measured over this roster the same lap the
# second key landed: THREE post-seating pages read OK on letters inside a longer word --
# `no infrastructure provisioned` and `no VPS provisioned` and `divisional roles` each carry
# `vision`, and each names no room at all. `visionary` is kept on purpose, because
# `**Status:** Visionary room` is an honest naming of the vision room and two pages write it.
# The test itself is `names_room` above, stated once so the gated branch and the counted one can
# never come to disagree about what a door says.
if names_room "$f"; then
  echo "OK   $f"
  exit 0
fi
if [ -n "$status" ]; then
  echo "FAIL $f Status does not name a room: $status"
else
  echo "FAIL $f Room does not name a room: $room"
fi
exit 1
