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

# A cellar holding two resins, both catalogued. Every plant below starts from this.
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
check "noteless counted"      "1"  "$(field_of noteless_entries "$p")"
check "noteless not gated"    "ok" "$(field_of verdict "$p")"
check "noteless exit"         "0"  "$(exit_of "$p")"

# -- 6. a file one directory down is not a resin ---------------------------------------------------
p=$(mkcellar nested)
mkdir -p "$p/deeper"
printf 'd\n' > "$p/deeper/20260101-000004_buried.bron"
check "nested not counted"    "2"  "$(field_of resins "$p")"
check "nested verdict"        "ok" "$(field_of verdict "$p")"

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
fi

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
