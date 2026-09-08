#!/bin/sh
# two_rooms_doorway_roster.sh -- the doorway's subject: forward-facing pages in six rooms.
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
# THE FOURTH ROOM, added 20260908. The rooms above were named by hand, and the tree holds more
# forward-facing prose rooms than the hand listed. `docs-geode/README.md` opens by naming "three
# prose rooms" of its own -- itself, `manual/`, and `docs/` -- so the tree carries two statements
# of "three rooms" that overlap in exactly one. This roster read three; five stand.
#
# `docs-geode/` joins, and today it costs nothing: 10 pages enter the population and 0 name no
# room, because only one of them carries a one-clock stamp in its basename and that one already
# reads `mixed`. The room's blog genre is the one genre here that stamps its basenames; its first
# piece landed 20260908 and the room will grow. A room brought inside while it is free stays free,
# where the same room brought inside after ten stamped pages is a repair somebody has to schedule.
#
# THE FIFTH ROOM, added 20260908, and it was bought rather than found free. `manual/` carried 7
# pages naming no room, so the elder comment left it out beside `foundations/` and `context/` and
# named the choice Keaton's: 80 repairs in one lap, or a raised ceiling a ratchet may never take.
# This lap paid one room's share of that price. Each of the seven already carried an honest
# `**Status:**` line -- `Overview -- the front door`, `Tutorial -- every command below runs today`,
# `Setup guide` -- answering the lifecycle question well and the register question not at all,
# which is exactly the split `context/TWO_ROOMS.md` tabulates. The token was added beside what each
# line already said, judged from the page rather than from its title: four read `mixed` because
# they name horizons as horizons, and three read `checkable` because nothing in them waits.
# `manual/` now reads 29 pages and 0 silent, so it joins on the same terms `docs-geode/` did.
#
# THE SIXTH ROOM, added 20260908, and bought the same way the fifth was. `foundations/` carried 83
# pages under this predicate and 35 naming no room -- the larger half of the seventy-three the
# elder comment named as Keaton's choice. This lap paid it, page by page, judging each register
# from the page rather than from its title: 23 read `mixed` and 12 read `vision`. The room reads
# 83 pages and 0 silent, so it joins on the same terms `docs-geode/` and `manual/` did.
#
# TWO OF THE 35 TOOK THE OTHER KEY, and the reason is mechanical rather than a preference. The
# per-file scan reads `**Status:**` and keeps the FIRST line, so a token appended to a Status whose
# sentence runs onto a second line lands mid-clause and breaks the prose it was added to. Both
# pages -- `20260726-020537_the-breach.md` and `20260823-034321_the-return-that-feeds-everyone.md`
# -- name their room in a `**Room:**` line beneath the Status block instead, which the same scan
# has read since 20260907. A door with two keys is what makes the repair possible without rewriting
# a paragraph to fit a grep.
#
# ONE ROOM STAYS OUT, with the number it had: `context/` 105 pages and 38 naming no room. That is
# one more lap of the same shape, and it is carried on `construction/ITINERARY.md`.
#
# THE COUNTS ABOVE ARE THIS SCRIPT'S OWN POPULATION, which is not the room's file list. Measured
# on 20260908 with `git ls-files 'manual/*.md'` alone -- READMEs, `yonder/` and `archive/` left in
# -- `manual/`, `foundations/` and `context/` read 32/7, 94/44 and 112/38: eighty-nine rather than
# eighty, and the whole difference is the exclusions above. A number measured under a neighboring predicate
# reads like a correction and is a different question.
#
# Run from the repository root:
#   sh tools/fixtures/t/two_rooms_doorway_roster.sh
set -eu

git ls-files 'external-research/*.md' 'active-designing/*.md' 'docs/*.md' 'docs-geode/*.md' 'manual/*.md' 'foundations/*.md' 2>/dev/null |
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    */README.md) continue ;;
    */yonder/*|*/archive/*) continue ;;
  esac
  [ -f "$f" ] || continue
  printf '%s\n' "$f"
done
