#!/bin/sh
# tools/fixtures/r/reds_row_shrink_scan.sh -- did a ledger row lose text it once held?
#
# WHY THIS FILE EXISTS (REDS %811). `construction/REDS.md` has one first law: a row is never
# edited. On `20260917` commit `30edd9303` widened `%803` with a paragraph naming the contested
# send; three hours later `66f3c17a1`, whose only ledger business was booking `%804`, rewrote that
# same line to the version ITS checkout held, and the widening went with it. Eight ships edit this
# file every lap, and a rebase resolving one row's text in favour of the side that booked a
# DIFFERENT row is ordinary git behaviour -- silently lossy across every open row at once.
#
# NOTHING SAW IT. `reds_ledger_monotone` reads the spine's ORDER, and a row losing a sentence keeps
# its gaps, numbers, stamps and file count exactly. `reds_spine_derive` compares (number, stamp)
# pairs, and the stamp is the half a rebase preserves. A lap returning to that row is what caught
# it, by reading disk against memory.
#
# WHY HISTORY RATHER THAN LOCAL-AGAINST-UPSTREAM. The loss is already PUBLISHED: upstream holds the
# narrow text, this tree holds the narrow text, and the two agree perfectly. A comparison taken at
# one moment can never see it. The record of the widening lives in the spine's own history, so the
# reading walks that history -- one `git log -p` process over the pin and its fold shelves -- and
# asks, for each row, whether the newest text is shorter than the longest that row ever held.
#
# WHY WORDS RATHER THAN BYTES, which is the whole of the discrimination. `.claude/rules/ascii-first.md`
# rewrote em dashes to `--` and middots to `-` across this ledger, in sweeps whose whole purpose was
# to change a row's BYTES and not one word of its text. Measured over this tree's own spine
# `20260917`: **18 byte-shrink events against 7 word-shrink events**, and every one of the eleven
# that vanished was a character-level sweep losing 1 to 20 bytes. A meter counting bytes would have
# reported eleven faults that are the tree obeying a different law -- and the eleven would have
# buried the one that mattered. A word count is blind to a character substitution and loud about a
# lost sentence, which is exactly the shape of the defect.
#
# WHY A PAIR WHOSE STAMP MOVED IS NOT COUNTED. A row's identity is its stamp
# (`.claude/rules/derived-spine.md`). A `-%N` and `+%N` carrying DIFFERENT stamps is one number
# rebound to another row -- a renumbering, lawful while the row is unshared, and already gated by
# `reds_spine_derive`. Counting it here would report one fault twice under two names.
#
#   sh tools/fixtures/r/reds_row_shrink_scan.sh                 # read, change nothing
#   sh tools/fixtures/r/reds_row_shrink_scan.sh --list          # name every event and short row
#   sh tools/fixtures/r/reds_row_shrink_scan.sh --remote HEAD   # read this tree rather than upstream
#   REDS_SPINE_GLOB='REDS-*.md' sh ...                        # for a control's pen
#
# READINGS, and NONE of them is gated -- which is the row's own ruling:
#   shrink_events     -- commits where a row's word count fell while its stamp held.
#   shrink_words_max  -- the largest single event, in words.
#   standing_short    -- rows whose NEWEST text is shorter than the longest they ever held.
#   standing_words    -- words standing lost across those rows.
#   rebindings_seen   -- pairs whose stamp moved: named, excluded, and owed to reds_spine_derive.
#   revisions, rows_seen -- what was actually read, so a silent zero is told from a clean spine.
#
# GATING NONE OF IT IS DELIBERATE. An **OPEN** row accreted to **BOOKED** lawfully sheds its tail;
# a lap correcting its own wording the minute after writing it lawfully shortens a row; two ships
# edit this file every lap. A wall here would red on honest work, and a wall that reds on honest
# work is a wall somebody turns off. What this buys is that a rebase-shaped loss becomes VISIBLE
# on the lap it lands rather than on the lap somebody happens to re-read the row.
#
# Exit 0 having reported - 2 on misuse or an unreadable spine. A misuse exits DIFFERENTLY from a
# clean read, so a caller never takes a broken invocation for an intact ledger (%97's shape).
set -eu

# Every collection names a maximum (TAME). The ledger holds ~811 rows and its history ~611
# revisions of the pin; 8,192 is an order of magnitude above both and far below anything awk
# would struggle to hold in an associative array.
MAX_ROWS=8192

anointed="${REDS_ANOINTED:-xy/main}"
listing=no

while [ "$#" -gt 0 ]; do
  case "$1" in
    --list)   listing=yes ;;
    --remote) shift; [ "$#" -gt 0 ] || { echo "verdict=misuse_remote_needs_value" >&2; exit 2; }; anointed="$1" ;;
    --help|-h) sed -n '2,50p' "$0"; exit 0 ;;
    *) echo "verdict=misuse_unknown_arg ($1)" >&2; exit 2 ;;
  esac
  shift
done

# The ref must resolve BEFORE the walk, because `git log` over an unknown ref exits non-zero with
# a message about a bad revision, and a caller reading an empty stream would take it for a spine
# holding no rows at all -- reporting its own blindness as a clean ledger.
if ! git rev-parse --verify --quiet "${anointed}^{commit}" >/dev/null 2>&1; then
  echo "verdict=unreadable_spine detail=ref_absent ref=${anointed}" >&2
  exit 2
fi

# The spine's file set is spelled once, in reds_spine_files.sh, and asked for here rather than
# repeated (%231). Located beside this script rather than by a path from the repository root, so a
# control runs it from inside its own pen with the pen's git repository as the one git answers for.
# THE GLOB IS WHAT `git log` IS HANDED, rather than the resolved file list: a file this tree has
# folded away still holds rows in HISTORY, and a pathspec naming only what exists today would read
# past every shelf that has since been renamed.
SPINE_GLOB=${REDS_SPINE_GLOB:-"construction/archive/REDS-*rows-*.md construction/REDS.md"}

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT INT TERM

# ONE PROCESS FOR THE WHOLE WALK. The elder shape for a question like this is one `git show` per
# revision, which is 611 spawns to ask one question of one file. `git log -p` emits every revision
# as one stream in about two seconds on this pier, and `--reverse` puts it in OLDEST-FIRST order so
# a single pass over it leaves each row's CURRENT text in hand at the end.
# `set --` is safe here: the argument loop above consumed every positional parameter.
set --
for g in $SPINE_GLOB; do set -- "$@" "$g"; done
if ! git log -p --reverse --no-renames --format='@@COMMIT %H' "$anointed" -- "$@" > "$work/patch" 2>/dev/null; then
  echo "verdict=unreadable_spine detail=log_refused ref=${anointed}" >&2
  exit 2
fi
if [ ! -s "$work/patch" ]; then
  echo "verdict=unreadable_spine detail=no_revisions ref=${anointed} glob=${SPINE_GLOB}" >&2
  exit 2
fi

awk -v listing="$listing" -v maxrows="$MAX_ROWS" '
# A row headline is one line:  **REDS %N (`YYYYMMDD.HHMMSS`) -- headline.** ... **STATUS.**
# The number is the view; the stamp is the KEY, and this reading keys on the pair. Keying on the
# number alone was the first draft and it was a braid: `construction/REDS.md` carries closure notes
# in the same shape -- `**REDS %282 CLOSED (<later stamp>) -- ...` -- so one number wears two
# records, and the 16-word closure read as the 216-word row shrinking by 200. Nine rows reported
# that way before the key moved. A row carries its one-clock stamp as identity
# (`.claude/rules/derived-spine.md`), and a reading that forgets it invents losses.
function key(s,   k) { if (match(s, /REDS [%#][0-9]+/)) { k = substr(s, RSTART, RLENGTH); gsub(/[^0-9]/, "", k); return k } return "" }
function stamp(s,   t) { if (match(s, /\(`[0-9]{8}\.[0-9]{6}`\)/)) { t = substr(s, RSTART, RLENGTH); gsub(/[^0-9.]/, "", t); return t } return "" }
function words(s,   a) { return split(s, a, /[ \t]+/) }

# PAIRED AT THE COMMIT BOUNDARY rather than inline, and the reason is a fold. When a row moves from
# the pin onto a shelf, its `-` and its `+` stand in two different files of one commit, and git
# emits files in path order -- which puts `construction/REDS.md` ahead of `construction/archive/`
# today and need not tomorrow. Collecting both sides and comparing once at the boundary is blind to
# that order, so a reordering of the spine can never turn a fold into a reported loss.
function settle(   mk, num, wnow, wwas, d) {
  # A REBINDING is one number leaving with one stamp and arriving with another -- a renumbering,
  # lawful while a row is unshared, and already gated by `reds_spine_derive`. It is counted here
  # only so a reader can see it was recognised and set aside, never as a loss.
  for (mk in minus) {
    if (mk in plus) continue
    num = num_of[mk]
    if (num in plus_num && plus_num[num] != minus_num[num]) rebound++
  }
  for (mk in plus) {
    wnow = words(plus[mk])
    if (mk in minus && minus[mk] != plus[mk]) {
      wwas = words(minus[mk])
      d = wnow - wwas
      if (d < 0) {
        events++
        if (-d > worst) worst = -d
        if (listing == "yes") printf "event commit=%s row=%%%s stamp=%s words=%d\n", substr(commit, 1, 10), num_of[mk], stamp_of[mk], d
      }
    }
    if (!(mk in cur)) records++
    cur[mk] = wnow
    if (wnow > peak[mk]) { peak[mk] = wnow; peak_at[mk] = commit }
  }
  delete minus; delete plus; delete minus_num; delete plus_num
}

# THE KEY IS THE RECORD HEAD -- everything from `**REDS` through the closing paren of the stamp,
# marker word included. Two weaker keys were tried and each invented losses. The NUMBER alone reads
# a closure note as its own row shrinking (a 16-word note against a 216-word row): nine rows
# reported that way. The pair (NUMBER, STAMP) still collides, because a closure note reuses the
# stamp of the row it closes -- `**REDS %108 CLOSED (20260821.053811)` at 197 words against
# `**REDS %108 (20260821.053811)` at 418, one number and one stamp wearing two records. The head is
# what each record writes to say which record it is, so it needs no roster of marker words and a
# marker invented tomorrow keys correctly the day it lands.
function note(side, line,   k, st, mk) {
  k = key(line)
  if (k == "") { unkeyed++; return }
  if (!match(line, /\(`[0-9]{8}\.[0-9]{6}`\)/)) { unstamped++; return }   # an elder row frozen by age
  st = stamp(line)
  mk = substr(line, 1, RSTART + RLENGTH - 1)
  num_of[mk] = k; stamp_of[mk] = st
  if (side == "-") { minus[mk] = line; minus_num[k] = st } else { plus[mk] = line; plus_num[k] = st }
}

/^@@COMMIT / { settle(); commit = $2; revisions++; next }
/^-\*\*REDS / { note("-", substr($0, 2)); next }
/^\+\*\*REDS / { note("+", substr($0, 2)); next }

END {
  settle()
  # invariant: the record population stays inside its named bound, so a spine grown past what this
  # reading was sized for says so rather than reporting a number nobody checked.
  if (records > maxrows) { printf "verdict=misuse_rows_over_bound rows=%d bound=%d\n", records, maxrows > "/dev/stderr"; exit 2 }
  short = 0; lost = 0
  for (mk in cur) {
    if (cur[mk] < peak[mk]) {
      short++
      lost += peak[mk] - cur[mk]
      if (listing == "yes") printf "short row=%%%s stamp=%s now=%d peak=%d words_lost=%d peak_at=%s\n", num_of[mk], stamp_of[mk], cur[mk], peak[mk], peak[mk] - cur[mk], substr(peak_at[mk], 1, 10)
    }
  }
  printf "revisions=%d\n", revisions
  printf "records_seen=%d\n", records
  printf "unstamped_headlines=%d\n", unstamped + 0
  printf "unkeyed_headlines=%d\n", unkeyed + 0
  printf "shrink_events=%d\n", events + 0
  printf "shrink_words_max=%d\n", worst + 0
  printf "standing_short=%d\n", short
  printf "standing_words=%d\n", lost
  printf "rebindings_seen=%d\n", rebound + 0
  printf "verdict=reported\n"
}
' "$work/patch"
