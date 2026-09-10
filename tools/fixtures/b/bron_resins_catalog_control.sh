#!/bin/sh
# tools/fixtures/b/bron_resins_catalog_control.sh -- prove bron_resins_catalog_scan.sh on planted cellars.
#
# Every refusal is shown from the failing side AND then lifted, so a reading can never be a plant
# that planted nothing (REDS `%519`). Every welcome is asserted as hard as every refusal, because a
# refusal proven only in the passing direction cannot be told from a bypass. And the pen itself is
# proven innocent: a scan patched to always answer `ok` must FAIL this control, with the patch's own
# landing proven by `cmp -s` rather than assumed from a `sed` exit code.
#
# Run from the repository root:
#   sh tools/fixtures/b/bron_resins_catalog_control.sh
set -u

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/b/bron_resins_catalog_scan.sh"
SHA3="$ROOT/tools/fixtures/s/sha3.sh"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/bron_resins_catalog_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

behaviors=0
failed=0

check() { # check <name> <expected> <actual>
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok   $1"
  else
    echo "  FAIL $1 -- wanted [$2] got [$3]"
    failed=$((failed + 1))
  fi
}

# A seal is written by the same tool the scan reads with, rather than by a constant pasted here.
# The control proves the SCAN, and a digest frozen into this file would be a second implementation
# of the hash quietly asking to be believed.
seal_into() { # seal_into <room> <basename>
  printf 'seal %s %s\n' "$2" "$(sh "$SHA3" 256 "$1/$2")" >> "$1/manifest.bron"
}

# A cellar holding two resins, both catalogued and both sealed. Every plant below starts from this.
mkcellar() { # mkcellar <name> ; echoes its room
  d="$PEN/$1"
  mkdir -p "$d"
  printf 'a\n' > "$d/20260101-000001_first.bron"
  printf 'b\n' > "$d/20260101-000002_second.bron"
  cat > "$d/manifest.bron" <<'CAT'
format bron-resins-v1
entry 20260101-000001_first.bron the first resin
entry 20260101-000002_second.bron the second resin
CAT
  seal_into "$d" 20260101-000001_first.bron
  seal_into "$d" 20260101-000002_second.bron
  printf '%s' "$d"
}

field_of() { # field_of <key> <room> [<scan>]
  sh "${3:-$SCAN}" "$2" 2>/dev/null | sed -n "s/^$1=//p" | head -1
}
exit_of() { # exit_of <room> [<scan>]
  sh "${2:-$SCAN}" "$1" >/dev/null 2>&1
  echo $?
}
detail_has() { # detail_has <key> <value> <room>
  if sh "$SCAN" "$3" 2>/dev/null | grep -qx "detail_$1=$2"; then echo yes; else echo no; fi
}

echo "bron_resins_catalog_control: planted cellars"

# -- 1. the clean baseline walks free ------------------------------------------------------------
p=$(mkcellar clean)
check "clean verdict"        "ok" "$(field_of verdict "$p")"
check "clean exit"           "0"  "$(exit_of "$p")"
check "clean resins"         "2"  "$(field_of resins "$p")"
check "clean entries"        "2"  "$(field_of entries "$p")"
check "clean sealed"         "2"  "$(field_of sealed "$p")"
check "clean unsealed"       "0"  "$(field_of unsealed "$p")"
check "clean mismatch"       "0"  "$(field_of seal_mismatch "$p")"

# The catalog is never counted as one of its own resins.
check "catalog not a resin"  "2"  "$(field_of resins "$p")"

# -- 2. an uncatalogued resin refuses, and the refusal lifts --------------------------------------
p=$(mkcellar uncatalogued)
printf 'c\n' > "$p/20260101-000003_third.bron"
check "uncatalogued verdict"  "drifted" "$(field_of verdict "$p")"
check "uncatalogued exit"     "1"       "$(exit_of "$p")"
check "uncatalogued count"    "1"       "$(field_of uncatalogued "$p")"
check "uncatalogued named"    "yes"     "$(detail_has uncatalogued 20260101-000003_third.bron "$p")"
printf 'entry 20260101-000003_third.bron the third resin\n' >> "$p/manifest.bron"
seal_into "$p" 20260101-000003_third.bron
check "uncatalogued lifted"   "ok"      "$(field_of verdict "$p")"

# -- 3. an entry naming a departed file refuses, and the refusal lifts ----------------------------
p=$(mkcellar orphan)
printf 'entry 20260101-000009_gone.bron a resin that left\n' >> "$p/manifest.bron"
check "orphan verdict"        "drifted" "$(field_of verdict "$p")"
check "orphan count"          "1"       "$(field_of orphan_entries "$p")"
check "orphan named"          "yes"     "$(detail_has orphan 20260101-000009_gone.bron "$p")"
grep -v '20260101-000009_gone.bron' "$p/manifest.bron" > "$p/m.tmp" && cat "$p/m.tmp" > "$p/manifest.bron" && rm -f "$p/m.tmp"
check "orphan lifted"         "ok"      "$(field_of verdict "$p")"

# -- 4. two lines for one resin refuse, and the refusal lifts -------------------------------------
p=$(mkcellar duplicate)
printf 'entry 20260101-000001_first.bron said twice\n' >> "$p/manifest.bron"
check "duplicate verdict"     "drifted" "$(field_of verdict "$p")"
check "duplicate count"       "1"       "$(field_of duplicate_entries "$p")"
check "duplicate named"       "yes"     "$(detail_has duplicate 20260101-000001_first.bron "$p")"
grep -v 'said twice' "$p/manifest.bron" > "$p/m.tmp" && cat "$p/m.tmp" > "$p/manifest.bron" && rm -f "$p/m.tmp"
check "duplicate lifted"      "ok"      "$(field_of verdict "$p")"

# -- 5. a noteless entry is REPORTED and never gated ----------------------------------------------
# The whole point of a reported reading: it must show up in the count and leave the verdict alone.
p=$(mkcellar noteless)
printf 'c\n' > "$p/20260101-000003_third.bron"
printf 'entry 20260101-000003_third.bron\n' >> "$p/manifest.bron"
seal_into "$p" 20260101-000003_third.bron
check "noteless counted"      "1"  "$(field_of noteless_entries "$p")"
check "noteless not gated"    "ok" "$(field_of verdict "$p")"
check "noteless exit"         "0"  "$(exit_of "$p")"

# -- 6. a file one directory down is not a resin ---------------------------------------------------
p=$(mkcellar nested)
mkdir -p "$p/deeper"
printf 'd\n' > "$p/deeper/20260101-000004_buried.bron"
check "nested not counted"    "2"  "$(field_of resins "$p")"
check "nested verdict"        "ok" "$(field_of verdict "$p")"

# -- 6b. a resin nobody sealed refuses, and the refusal lifts --------------------------------------
p=$(mkcellar unsealed)
printf 'c\n' > "$p/20260101-000003_third.bron"
printf 'entry 20260101-000003_third.bron the third resin\n' >> "$p/manifest.bron"
check "unsealed verdict"      "drifted" "$(field_of verdict "$p")"
check "unsealed exit"         "1"       "$(exit_of "$p")"
check "unsealed count"        "1"       "$(field_of unsealed "$p")"
check "unsealed named"        "yes"     "$(detail_has unsealed 20260101-000003_third.bron "$p")"
check "unsealed is not a miss" "0"      "$(field_of uncatalogued "$p")"
seal_into "$p" 20260101-000003_third.bron
check "unsealed lifted"       "ok"      "$(field_of verdict "$p")"

# -- 6c. a resin whose bytes moved under its seal refuses, and the refusal lifts -------------------
# This is the reading the catalog had no way to make for eighty-nine days: name and note both stay
# perfectly true while the bytes go somewhere else.
p=$(mkcellar mismatch)
printf 'a changed\n' > "$p/20260101-000001_first.bron"
check "mismatch verdict"      "drifted" "$(field_of verdict "$p")"
check "mismatch exit"         "1"       "$(exit_of "$p")"
check "mismatch count"        "1"       "$(field_of seal_mismatch "$p")"
check "mismatch named"        "yes"     "$(detail_has mismatch 20260101-000001_first.bron "$p")"
check "mismatch is not silence" "0"     "$(field_of unsealed "$p")"
check "the entry still reads clean" "0" "$(field_of uncatalogued "$p")"
grep -v '^seal 20260101-000001_first.bron' "$p/manifest.bron" > "$p/m.tmp" && cat "$p/m.tmp" > "$p/manifest.bron" && rm -f "$p/m.tmp"
seal_into "$p" 20260101-000001_first.bron
check "mismatch lifted"       "ok"      "$(field_of verdict "$p")"

# -- 6d. a seal naming a departed file refuses, and the refusal lifts ------------------------------
p=$(mkcellar orphan_seal)
printf 'seal 20260101-000009_gone.bron %s\n' \
  0000000000000000000000000000000000000000000000000000000000000000 >> "$p/manifest.bron"
check "orphan seal verdict"   "drifted" "$(field_of verdict "$p")"
check "orphan seal count"     "1"       "$(field_of orphan_seals "$p")"
check "orphan seal named"     "yes"     "$(detail_has orphan_seal 20260101-000009_gone.bron "$p")"
check "orphan seal is not a mismatch" "0" "$(field_of seal_mismatch "$p")"
grep -v '20260101-000009_gone.bron' "$p/manifest.bron" > "$p/m.tmp" && cat "$p/m.tmp" > "$p/manifest.bron" && rm -f "$p/m.tmp"
check "orphan seal lifted"    "ok"      "$(field_of verdict "$p")"

# -- 6e. two seals for one resin refuse, and the refusal lifts -------------------------------------
# Both copies may even agree; a catalog that states one fact twice has stopped being one record.
p=$(mkcellar duplicate_seal)
seal_into "$p" 20260101-000001_first.bron
check "duplicate seal verdict" "drifted" "$(field_of verdict "$p")"
check "duplicate seal count"   "1"       "$(field_of duplicate_seals "$p")"
check "duplicate seal named"   "yes"     "$(detail_has duplicate_seal 20260101-000001_first.bron "$p")"
sed '$d' "$p/manifest.bron" > "$p/m.tmp" && cat "$p/m.tmp" > "$p/manifest.bron" && rm -f "$p/m.tmp"
check "duplicate seal lifted"  "ok"      "$(field_of verdict "$p")"

# -- 6f. a seal the reader cannot parse is a seal the room does not have ---------------------------
# The safe direction: a short, upper-case, or three-field seal line falls into `unsealed` rather
# than being read as a claim that happens to hold.
p=$(mkcellar malformed_seal)
printf 'c\n' > "$p/20260101-000003_third.bron"
printf 'entry 20260101-000003_third.bron the third resin\n' >> "$p/manifest.bron"
printf 'seal 20260101-000003_third.bron deadbeef\n' >> "$p/manifest.bron"
check "short seal unread"      "1"       "$(field_of unsealed "$p")"
check "short seal refuses"     "drifted" "$(field_of verdict "$p")"
grep -v 'deadbeef' "$p/manifest.bron" > "$p/m.tmp" && cat "$p/m.tmp" > "$p/manifest.bron" && rm -f "$p/m.tmp"
printf 'seal 20260101-000003_third.bron %s TRAILING\n' \
  "$(sh "$SHA3" 256 "$p/20260101-000003_third.bron")" >> "$p/manifest.bron"
check "third-field seal unread" "1"      "$(field_of unsealed "$p")"
grep -v 'TRAILING' "$p/manifest.bron" > "$p/m.tmp" && cat "$p/m.tmp" > "$p/manifest.bron" && rm -f "$p/m.tmp"
seal_into "$p" 20260101-000003_third.bron
check "malformed seal lifted"  "ok"      "$(field_of verdict "$p")"

# -- 7. an absent room and an absent catalog answer misread, never zero ---------------------------
check "absent room verdict"    "misread" "$(field_of verdict "$PEN/no_such_room")"
check "absent room exit"       "2"       "$(exit_of "$PEN/no_such_room")"
p=$(mkcellar nocatalog); rm -f "$p/manifest.bron"
check "absent catalog verdict" "misread" "$(field_of verdict "$p")"
check "absent catalog exit"    "2"       "$(exit_of "$p")"

# -- 8. the detail listing is bounded, and says so ------------------------------------------------
p=$(mkcellar bounded)
i=10
while [ "$i" -lt 85 ]; do printf 'x\n' > "$p/20260101-0000$i""_bulk.bron"; i=$((i + 1)); done
check "bound truncation named" "64" "$(field_of uncatalogued_truncated_at "$p")"
shown=$(sh "$SCAN" "$p" 2>/dev/null | grep -c '^detail_uncatalogued=')
check "bound detail count"     "64" "$shown"
check "bound still refuses"    "drifted" "$(field_of verdict "$p")"

# -- 9. the pen is proven innocent ----------------------------------------------------------------
# A scan that always answers ok must fail the uncatalogued leg above; if it passes, this control
# proves nothing. The patch's landing is proven by cmp rather than by sed's exit code (REDS `%519`).
LIAR="$PEN/liar_scan.sh"
sed 's/^echo "verdict=drifted"$/echo "verdict=ok"/; s/^exit 1$/exit 0/' "$SCAN" > "$LIAR"
behaviors=$((behaviors + 1))
if ! test -s "$LIAR" || cmp -s "$SCAN" "$LIAR"; then
  # An unreadable source leaves an EMPTY copy, which differs from the original and would read as a
  # landed patch -- so emptiness is checked before difference. The control caught this in itself.
  echo "  FAIL innocence patch matched nothing -- the liar scan is empty or byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  p=$(mkcellar innocence)
  printf 'c\n' > "$p/20260101-000003_third.bron"
  check "liar scan says ok"     "ok" "$(field_of verdict "$p" "$LIAR")"
  check "liar scan exits clean" "0"  "$(exit_of "$p" "$LIAR")"
  check "real scan refuses it"  "drifted" "$(field_of verdict "$p")"
  # and again for the seal, since a liar that only waved through the elder gate would leave the
  # new one untested by the one leg that exists to test every gate at once
  q=$(mkcellar innocence_seal)
  printf 'a changed\n' > "$q/20260101-000001_first.bron"
  check "liar scan waves a mismatch" "ok" "$(field_of verdict "$q" "$LIAR")"
  check "real scan bites it"    "drifted" "$(field_of verdict "$q")"
fi

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
