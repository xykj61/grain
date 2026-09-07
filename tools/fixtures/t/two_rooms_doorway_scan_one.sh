#!/usr/bin/env sh
# two_rooms_doorway_scan_one.sh -- per-file doorway verdict for native orchestrator.
set -eu
f="$1"
seating="$2"
base=$(basename "$f")
file_stamp=$(echo "$base" | sed -n 's/^\([0-9]\{8\}-[0-9]\{6\}\).*/\1/p')
if [ -z "$file_stamp" ]; then
  echo "OK   $f (no one-clock stamp -- grandfathered)"
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
status=$(printf '%s\n' "$door_head" | grep -o '\*\*Status:\*\*.*' | head -1 || true)
room=$(printf '%s\n' "$door_head" | grep -o '\*\*Room[^:]*:\*\*.*' | head -1 || true)
if [ -z "$status" ] && [ -z "$room" ]; then
  echo "FAIL $f missing Status line (stamp $file_stamp)"
  exit 1
fi
# THE TOKEN IS A WORD, NOT A SUBSTRING (20260907). Measured over this roster the same lap the
# second key landed: THREE post-seating pages read OK on letters inside a longer word --
# `no infrastructure provisioned` and `no VPS provisioned` and `divisional roles` each carry
# `vision`, and each names no room at all. `visionary` is kept on purpose, because
# `**Status:** Visionary room` is an honest naming of the vision room and two pages write it.
if printf '%s\n%s\n' "$status" "$room" \
  | grep -qiE '(^|[^A-Za-z])(checkable|vision(ary)?|mixed|research for understanding)([^A-Za-z]|$)'; then
  echo "OK   $f"
  exit 0
fi
if [ -n "$status" ]; then
  echo "FAIL $f Status does not name a room: $status"
else
  echo "FAIL $f Room does not name a room: $room"
fi
exit 1
