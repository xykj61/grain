#!/bin/sh
# two_rooms_doorway_roster.sh -- the doorway's subject: forward-facing pages in three rooms.
#
# WHY IT READS EVERY DEPTH, from 20260906. This helper was a shell glob --
# `for f in external-research/*.md active-designing/*.md docs/*.md` -- written when all three
# rooms were flat. Then `active-designing/` folded to `date/YYYYMMDD/` under the mark law, and a
# shell `*` stops at `/`. The roster kept returning files, so nothing looked wrong; it simply
# returned 216 post-seating pages where the three rooms hold 1,085. Six hundred and seven pages
# left the guard's reach on the day their room folded, and three of them name no room.
#
# A BROKEN PATH REDS; A NARROWED GLOB GOES GREEN. The fold law thought hard about references --
# `dated_path_repoint.rish` moves living ones, `dated_path_resolve.rish` recovers stale ones -- and
# a witness that greps an absent path reds loudly. A glob reads no absent path. It returns a
# smaller set and passes. Every safeguard around folding is built for the failure that announces
# itself; this is the one that does not. It has now fired three times in this tree: `index_row_bound`
# read the pin alone and passed four days over 87 unheld rows (REDS %381), `log_has_a_row` watched
# the flat room and read `flat_logs=0` for nine days (repaired 20260905), and this.
#
# `git ls-files` is the cure, and the difference is exact: a git pathspec `*` crosses `/` where a
# shell glob does not. `git ls-files 'counsel/*.md'` answers 941 -- every depth -- while
# `ls active-designing/*.md` answers 110 of 1,055. Two spellings that read alike and differ on
# precisely what a fold changes.
#
# WHAT STAYS OUT, and why each is the elder reach rather than a new judgment.
#   */README.md          a room's front door describes the room rather than speaking from a room.
#   */yonder/*           deferred-yet-alive (ORGANIZING); the shell glob never reached it either,
#                        so pulling it in would widen the subject rather than restore it. Its 262
#                        post-seating pages, 11 of which name no room, wait on Keaton's word.
#   */archive/*          finished-and-historical; same reasoning, and the sibling roster
#                        `chrono_version_roster.sh` excludes exactly this pair.
#
# A `date/` shelf is NOT excluded, because a fold files a page rather than retiring it: the mark
# law chose `date/` over `archive/` precisely so the room would claim only *when*.
#
# Run from the repository root:
#   sh tools/fixtures/t/two_rooms_doorway_roster.sh
set -eu

git ls-files 'external-research/*.md' 'active-designing/*.md' 'docs/*.md' 2>/dev/null |
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    */README.md) continue ;;
    */yonder/*|*/archive/*) continue ;;
  esac
  [ -f "$f" ] || continue
  printf '%s\n' "$f"
done
