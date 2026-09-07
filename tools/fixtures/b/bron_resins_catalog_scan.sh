#!/bin/sh
# tools/fixtures/b/bron_resins_catalog_scan.sh -- the cellar's catalog names every resin it holds.
#
# WHAT THIS READS. `bron-resins/` is the resin cellar. `bron-resins/manifest.bron` is its catalog,
# carrying one `entry <basename> <note>` line per resin, so a reader learns what the cellar holds
# without opening seventeen files. This scan compares the catalog against the room.
#
# THE LAW IT KEEPS is `foundations/20260703-202312_the-marked-value.md`, whose Amber clause reads:
# *every resin records the marks of what it seals, so a reader in another decade knows what the
# cellar held without opening it.* The catalog's own `note` line states the habit that keeps it
# current -- *commit with the resin*.
#
# WHAT WAS MEASURED (`20260907.000030`). The room held 17 resins and the catalog named 3. The habit
# held for the first three files of the first morning, `20260712`, and then lapsed. The catalog also
# had no reader: three scans name `bron-resins/` only to skip it as testimony, and no witness,
# runner, or roster row opened it. A catalog covering a fifth of its room reads exactly like a whole
# one, which is `%514`'s lesson standing in a room that had been quiet for eighty-seven days.
#
# THE READINGS:
#   resins             files in the room, the catalog itself aside
#   entries            `entry ` lines in the catalog
#   uncatalogued       a resin no entry names                        GATED at zero
#   orphan_entries     an entry naming a file the room lacks         GATED at zero
#   duplicate_entries  two entries naming one resin                  GATED at zero
#   noteless_entries   an entry carrying a name and no note          reported
#
# The three gates stay three readings because they fail in three directions. An uncatalogued resin
# is a silence. A line naming a departed file is a promise the room can no longer keep. Two lines
# for one resin is a catalog disagreeing with itself. Noteless entries are REPORTED instead: a bare
# name is a weak line and still a true one, and a gate that reds on an honest half-measure is one
# somebody turns off.
#
# IT READS THE FILESYSTEM rather than the index, for two plain reasons. `.gitignore:111` carries
# `!/bron-resins/`, so the room is allow-listed out of the root deny and a `find` read names the
# same set `git ls-files` does. And a filesystem read is what lets the control point this scan at a
# throwaway pen, which is no git repository at all.
#
#   sh tools/fixtures/b/bron_resins_catalog_scan.sh [<room>]
#
# Default room `bron-resins`. Exit 0 when catalog and room agree, 1 when they part, and 2 when the
# scan cannot read what it was pointed at. An absent room answers `misread`, since zero is the
# reading a healthy cellar gives.
set -eu

ROOM=${1:-bron-resins}
CATALOG="$ROOM/manifest.bron"

# Bound: the detail listing stops here and says so. A cellar past this is a room that wants a fold
# rather than a longer printout, and an unbounded print is an unbounded allocation (TAME).
MAX_DETAIL=64

if ! test -d "$ROOM"; then
  echo "verdict=misread"
  echo "detail=room_absent"
  echo "detail_room=$ROOM"
  exit 2
fi

if ! test -f "$CATALOG"; then
  echo "verdict=misread"
  echo "detail=catalog_absent"
  echo "detail_catalog=$CATALOG"
  exit 2
fi

echo "room=$ROOM"
echo "catalog=$CATALOG"

TMP=$(mktemp -d "${TMPDIR:-/tmp}/bron_resins_catalog.XXXXXX") || exit 2
trap 'rm -rf "$TMP"' EXIT

# The room's own resins: every regular file directly in it, minus the catalog.
find "$ROOM" -maxdepth 1 -type f ! -name manifest.bron -exec basename {} \; \
  | LC_ALL=C sort > "$TMP/resins"

# The catalog's claims, in the order it makes them, so a duplicate keeps both copies.
sed -n 's/^entry  *\([^ ][^ ]*\).*/\1/p' "$CATALOG" | LC_ALL=C sort > "$TMP/claimed"

resins=$(wc -l < "$TMP/resins" | tr -d ' ')
entries=$(wc -l < "$TMP/claimed" | tr -d ' ')
echo "resins=$resins"
echo "entries=$entries"

LC_ALL=C sort -u "$TMP/claimed" > "$TMP/claimed_uniq"
LC_ALL=C comm -23 "$TMP/resins" "$TMP/claimed_uniq" > "$TMP/uncatalogued"
LC_ALL=C comm -13 "$TMP/resins" "$TMP/claimed_uniq" > "$TMP/orphans"
LC_ALL=C uniq -d "$TMP/claimed" > "$TMP/duplicates"

# An entry line whose name is the whole line carries no note.
sed -n 's/^entry  *\([^ ][^ ]*\)[ ]*$/\1/p' "$CATALOG" | LC_ALL=C sort > "$TMP/noteless"

uncatalogued=$(wc -l < "$TMP/uncatalogued" | tr -d ' ')
orphan_entries=$(wc -l < "$TMP/orphans" | tr -d ' ')
duplicate_entries=$(wc -l < "$TMP/duplicates" | tr -d ' ')
noteless_entries=$(wc -l < "$TMP/noteless" | tr -d ' ')

echo "uncatalogued=$uncatalogued"
echo "orphan_entries=$orphan_entries"
echo "duplicate_entries=$duplicate_entries"
echo "noteless_entries=$noteless_entries"

# Name every one of them. A count nobody can act on is the dated-path census's own complaint --
# it prints no list, so nobody can name the reference it is refusing over.
name_them() { # name_them <key> <file>
  shown=0
  while IFS= read -r n; do
    if [ "$shown" -ge "$MAX_DETAIL" ]; then
      echo "${1}_truncated_at=$MAX_DETAIL"
      break
    fi
    echo "detail_${1}=$n"
    shown=$((shown + 1))
  done < "$2"
}
name_them uncatalogued "$TMP/uncatalogued"
name_them orphan "$TMP/orphans"
name_them duplicate "$TMP/duplicates"
name_them noteless "$TMP/noteless"

if [ "$uncatalogued" -eq 0 ] && [ "$orphan_entries" -eq 0 ] && [ "$duplicate_entries" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi

echo "verdict=drifted"
exit 1
