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
#   sealed             `seal <name> <hex>` lines the reader can parse
#   unsealed           a resin no seal line addresses                GATED at zero
#   seal_mismatch      a resin whose bytes differ from its seal      GATED at zero
#   orphan_seals       a seal naming a file the room lacks           GATED at zero
#   duplicate_seals    two seals for one resin                       GATED at zero
#
# The gates stay separate readings because they fail in separate directions. An uncatalogued resin
# is a silence. A line naming a departed file is a promise the room can no longer keep. Two lines
# for one resin is a catalog disagreeing with itself. Noteless entries are REPORTED instead: a bare
# name is a weak line and still a true one, and a gate that reds on an honest half-measure is one
# somebody turns off.
#
# THE SEAL, ADDED `20260910.014500`, is the field the entry line never carried. A name and a note
# say WHAT the cellar holds; only a digest says the bytes are the bytes. The same law page the
# entry line keeps -- `foundations/20260703-202312_the-marked-value.md` -- states a manifest line's
# three fields as *its type-mark, its digest at the tiers the resins law fixes, and its name*, and
# the vow beneath them as *the digest is checked twice*. The cellar carried two of the three fields
# for eighty-nine days, and a resin edited in place would have passed every reading above in
# silence -- the room's own lesson, that a catalog covering a fifth of its subject reads exactly
# like a whole one, standing one field over.
#
# `unsealed` is GATED rather than reported for that reason, and the choice is the one place this
# scan parts from its own noteless precedent: a bare name is a weak claim about a resin, while an
# absent seal is no claim at all, and a wall with a gap in it is a wall somebody walks around.
#
# SHA3-256, computed by `tools/fixtures/s/sha3.sh` over `crypto/sha3_digest.rye` -- this tree's own
# Keccak, authored clean-room from FIPS 202 -- so a reader in another decade checks a seal with the
# tree and needs no external binary. The catalog seals every resin and never itself, because a file
# cannot carry its own digest; the catalog's own bytes are held by the history each seal rides in.
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

# THE DIGEST TOOL, found by an upward walk from this script rather than by fixed depth arithmetic,
# which is the lesson `tools/fixtures/s/sha3.sh` already carries: the letter fold moved these
# scripts one directory deeper and a counted `../..` is what broke. Bounded at 8 steps, loud past
# the bound.
#
# THE CALLER'S ROOT IS THE FALLBACK, and it is here for one named case: the control copies this
# scan into a throwaway pen to prove the pen innocent, and a copy outside the tree has no ancestor
# holding the tool. Without the fallback the innocence leg answers `misread` and proves nothing,
# which is how it was found.
SHA3=""
_seal_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_seal_steps=0
while [ "$_seal_steps" -le 8 ]; do
  if [ -f "$_seal_dir/tools/fixtures/s/sha3.sh" ]; then
    SHA3="$_seal_dir/tools/fixtures/s/sha3.sh"
    break
  fi
  [ "$_seal_dir" = "/" ] && break
  _seal_dir=$(dirname "$_seal_dir")
  _seal_steps=$((_seal_steps + 1))
done
[ -n "$SHA3" ] || SHA3="$(pwd)/tools/fixtures/s/sha3.sh"

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

# A well-formed seal line reads `seal <basename> <64 lowercase hex>`. A malformed one matches
# neither pattern below, so its resin falls into `unsealed` and the gate bites. That is the safe
# direction: a seal the reader cannot parse is a seal the room does not have.
sed -n 's/^seal  *\([^ ][^ ]*\)  *[0-9a-f]\{64\} *$/\1/p' "$CATALOG" | LC_ALL=C sort > "$TMP/sealed"
sed -n 's/^seal  *\([^ ][^ ]*\)  *\([0-9a-f]\{64\}\) *$/\1 \2/p' "$CATALOG" | LC_ALL=C sort > "$TMP/seal_pairs"

LC_ALL=C sort -u "$TMP/sealed" > "$TMP/sealed_uniq"
LC_ALL=C comm -23 "$TMP/resins" "$TMP/sealed_uniq" > "$TMP/unsealed"
LC_ALL=C comm -13 "$TMP/resins" "$TMP/sealed_uniq" > "$TMP/orphan_seals"
LC_ALL=C uniq -d "$TMP/sealed" > "$TMP/duplicate_seals"

sealed=$(wc -l < "$TMP/sealed" | tr -d ' ')
unsealed=$(wc -l < "$TMP/unsealed" | tr -d ' ')
orphan_seals=$(wc -l < "$TMP/orphan_seals" | tr -d ' ')
duplicate_seals=$(wc -l < "$TMP/duplicate_seals" | tr -d ' ')

# Only what the catalog claims is recomputed, so a room of unsealed files costs no digests at all.
# The tool is probed once before any answer it gives is trusted, and a tool that cannot speak
# answers `misread` rather than `seal_mismatch`: a hash this pier could not compute and a resin
# whose bytes moved are two different facts, and only the second belongs to the cellar.
seal_mismatch=0
: > "$TMP/mismatch"
if [ -s "$TMP/seal_pairs" ]; then
  if ! probe=$(sh "$SHA3" 256 "$CATALOG" 2>/dev/null) ||
     ! printf '%s' "$probe" | grep -qE '^[0-9a-f]{64}$'; then
    echo "verdict=misread"
    echo "detail=digest_tool_unavailable"
    echo "detail_digest_tool=$SHA3"
    exit 2
  fi
  while read -r seal_name seal_dig; do
    [ -n "$seal_name" ] || continue
    # an orphan seal is already counted; there are no bytes here to disagree with
    [ -f "$ROOM/$seal_name" ] || continue
    if ! actual=$(sh "$SHA3" 256 "$ROOM/$seal_name" 2>/dev/null) ||
       ! printf '%s' "$actual" | grep -qE '^[0-9a-f]{64}$'; then
      echo "verdict=misread"
      echo "detail=digest_failed"
      echo "detail_digest_failed=$seal_name"
      exit 2
    fi
    [ "$actual" = "$seal_dig" ] || echo "$seal_name" >> "$TMP/mismatch"
  done < "$TMP/seal_pairs"
  seal_mismatch=$(wc -l < "$TMP/mismatch" | tr -d ' ')
fi

echo "sealed=$sealed"
echo "unsealed=$unsealed"
echo "orphan_seals=$orphan_seals"
echo "duplicate_seals=$duplicate_seals"
echo "seal_mismatch=$seal_mismatch"

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
name_them unsealed "$TMP/unsealed"
name_them orphan_seal "$TMP/orphan_seals"
name_them duplicate_seal "$TMP/duplicate_seals"
name_them mismatch "$TMP/mismatch"

if [ "$uncatalogued" -eq 0 ] && [ "$orphan_entries" -eq 0 ] && [ "$duplicate_entries" -eq 0 ] &&
   [ "$unsealed" -eq 0 ] && [ "$orphan_seals" -eq 0 ] && [ "$duplicate_seals" -eq 0 ] &&
   [ "$seal_mismatch" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi

echo "verdict=drifted"
exit 1
