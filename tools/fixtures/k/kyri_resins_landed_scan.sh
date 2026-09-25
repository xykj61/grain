#!/bin/sh
# tools/fixtures/k/kyri_resins_landed_scan.sh -- a resin's bytes are the bytes that landed.
#
# WHAT THIS READS. `kyri-resins/` is the resin cellar, a room of chat printouts written once on
# `20260712` and kept as testimony. `kyri-resins/manifest.kyri` is its catalog, and the paragraph
# it carries under WHAT THE SEVENTEEN DIGESTS ARE states the room's law outright: *every resin in
# this room has exactly one commit in the tree's whole history, and its blob at that commit is
# byte-identical to its blob at HEAD -- checked one file at a time, all seventeen equal.* That
# sentence was true when a hand typed it on `20260910` and nothing has read it since.
#
# WHY IT IS A SEPARATE READING FROM THE SEAL. `kyri_resins_catalog_scan.sh` recomputes each resin's
# SHA3-256 and compares it to the `seal` line beside it, which proves the bytes answer the RECORDED
# digest. A hand that edits a resin and updates its seal in the same commit satisfies that reading
# exactly, and every gate in this room stays green. The seal is a wall against drift; it is not a
# wall against a rewrite, because both halves of the comparison live in the working tree. Git's
# history is the only copy an edit cannot reach, so the landed reading asks it.
#
# THE READINGS:
#   resins          files in the room, the catalog itself aside
#   landed          resins whose adding commit resolved
#   uncommitted        a resin git has never carried -- written and not yet committed   reported
#   moved           a landed resin whose bytes differ from its adding commit's blob  GATED at zero
#   commits_multi   a resin whose path more than one commit touched                 reported
#   readded         a resin added by more than one commit -- deleted and restored    reported
#
# `moved` IS THE GATE and the other three report, each for its own reason. A resin written this
# minute has no history to disagree with, so `uncommitted` is the ordinary state of honest work and a
# gate there would red on the lap that adds a resin. A second commit touching the path changes no
# byte on its own -- a mode change, a rename carrying the room into a fold -- and the room's fold
# law says exactly that a move is lawful, so `commits_multi` is a diagnostic rather than a wall. A
# re-add is rarer still and the bytes reading already answers for it. What no lawful act produces
# is a resin whose bytes part from the bytes that landed, so that is the one reading with teeth.
#
# THE CATALOG IS EXCLUDED BY NAME, and it is the living file this room holds: it gains an entry and
# a seal whenever a resin lands, so its own bytes move by design. Measured `20260916`: three
# commits and moved bytes, against one commit and unmoved bytes for all seventeen resins.
#
# IT ASKS GIT'S OWN QUESTION. `git cat-file --batch-check` names the blob each adding commit
# recorded, and `git hash-object` names the blob this file would land as if it were committed right
# now. Comparing those two is exactly the question *would a commit of this file today reproduce the
# object its own commit put there* -- so the reading agrees with `git status` by construction,
# rather than by a second implementation of the hash standing beside git's. Both sides honor
# whatever clean filter a clone configures, so a filter can never make a differing file read equal.
#
#   sh tools/fixtures/k/kyri_resins_landed_scan.sh [<room>] [--list]
#
# Default room `kyri-resins`. Exit 0 when every resin stands as it landed, 1 when one has moved,
# and 2 when the scan cannot read what it was pointed at. An absent room answers `misread`, since
# zero is the reading a healthy cellar gives.
set -eu

ROOM=kyri-resins
LIST=no
for a in "$@"; do
  case "$a" in
    --list) LIST=yes ;;
    --*) echo "verdict=misread"; echo "detail=unknown_flag"; echo "detail_flag=$a"; exit 2 ;;
    *) ROOM=$a ;;
  esac
done

# Bound: the listing stops here and SAYS SO on its own line. A cap that drops rows in silence reads
# as a whole listing to whoever asked for one (REDS %797).
MAX_DETAIL=64

if ! test -d "$ROOM"; then
  echo "verdict=misread"
  echo "detail=room_absent"
  echo "detail_room=$ROOM"
  exit 2
fi

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "verdict=misread"
  echo "detail=not_a_repository"
  echo "detail_room=$ROOM"
  exit 2
fi

echo "room=$ROOM"
echo "catalog=$ROOM/manifest.kyri"

TMP=$(mktemp -d "${TMPDIR:-/tmp}/kyri_resins_landed.XXXXXX") || exit 2
trap 'rm -rf "$TMP"' EXIT

# The room's own resins: every regular file directly in it, the living catalog aside.
find "$ROOM" -maxdepth 1 -type f ! -name manifest.kyri | LC_ALL=C sort > "$TMP/files"

# TWO HISTORY WALKS, rather than two per resin. Asking git once per file walks the whole history
# once per file, which read 4.5 seconds over seventeen resins and would have priced this guard off
# the lap clock. `--no-renames` is deliberate: a rename then lands as a delete of the old path and
# an ADD of the new one, so a resin carried into a fold has an adding commit at its new name whose
# blob is the blob it always had, and the reading answers `same` rather than losing the file.
# Each walk is read into a file FIRST, so git's own exit status is the thing checked. Piped
# straight into awk, the pipeline reports awk's status and a git that could not run reads as a
# room with no history -- which is exactly the shape of a clean answer. An instrument that
# cannot run refuses.
git log --format='%H' --diff-filter=A --name-only --no-renames -- "$ROOM" > "$TMP/adds.raw" \
  || { echo "kyri-resins-landed: git log refused while reading the room's adding commits" >&2; exit 2; }
awk '/^[0-9a-f]{40,64}$/ { c = $0; next } NF { print $0 "\t" c }' "$TMP/adds.raw" > "$TMP/adds"
git log --format='%H' --name-only --no-renames -- "$ROOM" > "$TMP/touches.raw" \
  || { echo "kyri-resins-landed: git log refused while reading the room's touching commits" >&2; exit 2; }
awk '/^[0-9a-f]{40,64}$/ { next } NF { print $0 }' "$TMP/touches.raw" > "$TMP/touches"

# The EARLIEST adding commit per resin. `git log` prints newest first, so the last line naming a
# path is the commit that first put those bytes in the tree -- which is the commit the room's law
# speaks about, and the one an unfaithful re-add would hide behind.
awk -F'\t' 'NR==FNR { first[$1] = $2; adds[$1]++; next }
            { if ($0 in first) print $0 "\t" first[$0] }' "$TMP/adds" "$TMP/files" > "$TMP/first"
awk -F'\t' '{ print $2 ":" $1 }' "$TMP/first" > "$TMP/specs"

# TWO BATCHED OBJECT READINGS, rather than two processes per resin. `git cat-file --batch-check`
# names the blob each adding commit recorded; `git hash-object` names the blob this file would
# land as if it were committed right now. Comparing those two asks git's own question -- would a
# commit of this file today reproduce the object its own commit put there -- so the reading agrees
# with `git status` by construction rather than by a second implementation of the hash. Both honor
# whatever clean filter a clone configures, on both sides, so a filter can never make a differing
# file read equal.
if [ -s "$TMP/specs" ]; then
  git cat-file --batch-check='%(objectname)' < "$TMP/specs" 2>/dev/null > "$TMP/recorded" || true
else
  : > "$TMP/recorded"
fi
if [ -s "$TMP/files" ]; then
  git hash-object --stdin-paths < "$TMP/files" 2>/dev/null > "$TMP/working" || true
else
  : > "$TMP/working"
fi

# One pass joins the five readings, so no per-resin process runs at all.
awk -F'\t' -v list="$LIST" -v cap="$MAX_DETAIL" '
  FILENAME == ARGV[1] { adds[$1]++; next }
  FILENAME == ARGV[2] { touches[$0]++; next }
  FILENAME == ARGV[3] { order[++nf] = $0; next }
  FILENAME == ARGV[4] { recorded[++nr] = $0; next }
  FILENAME == ARGV[5] { working[++nw] = $0; next }
  FILENAME == ARGV[6] { firstc[$1] = $2; seq[$1] = ++ns; next }
  END {
    for (i = 1; i <= nf; i++) {
      path = order[i]
      resins++
      if (!(path in firstc)) {
        uncommitted++
        state = "uncommitted"
      } else {
        landed++
        if (adds[path] > 1) readded++
        if (recorded[seq[path]] == working[i] && working[i] != "") state = "same"
        else { moved++; state = "MOVED" }
      }
      if (touches[path] > 1) commits_multi++
      if (list == "yes" || state == "MOVED") {
        if (shown < cap) { shown++; detail[shown] = "detail_resin " state " commits=" touches[path] + 0 " " path }
        else dropped++
      }
    }
    print "resins=" resins + 0
    print "landed=" landed + 0
    print "uncommitted=" uncommitted + 0
    print "moved=" moved + 0
    print "commits_multi=" commits_multi + 0
    print "readded=" readded + 0
    for (i = 1; i <= shown; i++) print detail[i]
    if (shown > 0 || dropped > 0) {
      print "detail_shown=" shown + 0
      print "detail_dropped=" dropped + 0
      print "detail_cap=" cap + 0
    }
    print "moved_count=" moved + 0
  }
' "$TMP/adds" "$TMP/touches" "$TMP/files" "$TMP/recorded" "$TMP/working" "$TMP/first" > "$TMP/report"

moved=$(grep '^moved_count=' "$TMP/report" | cut -d= -f2)
grep -v '^moved_count=' "$TMP/report"

if [ "$moved" -gt 0 ]; then
  echo "verdict=moved"
  exit 1
fi

echo "verdict=ok"
exit 0
