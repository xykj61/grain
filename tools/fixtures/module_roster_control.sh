#!/bin/sh
# tools/fixtures/module_roster_control.sh -- the module-roster guard, proven from both sides.
#
# ONE PEN, ANY DIRECTORY. This proves tools/fixtures/module_roster_scan.sh, which reads
# <DIR>/MODULES.md against the .rye files in <DIR>. Both witnesses that drive that scan --
# tools/i/image_module_roster_witness.rish and tools/l/lotus_module_roster_witness.rish -- assert
# on this one tally, since one mechanism wants one proof rather than one per directory.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. This pen builds
# real directories holding real .rye files and a real MODULES.md, plants one fault at a time, and
# asks the scan what it reads -- so every gate is shown biting and every honest shape is shown
# passing free.
#
# Each case prints one line naming what was planted and whether it was bitten or left free. The
# tally at the end is what both roster witnesses assert on.
#
# Run from the repository root:  sh tools/fixtures/module_roster_control.sh
set -eu

SCAN=tools/fixtures/module_roster_scan.sh
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

fail=0
n=0

# Build a directory holding the named modules and a MODULES.md whose table names $3.
# build <dir> "<modules on disk>" "<rows to write>"
build() {
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d"
  for m in $2; do printf '//! %s.rye -- does a thing\n' "$m" > "$d/$m.rye"; done
  {
    echo "# pen roster"
    echo
    echo "| Module | What it does |"
    echo "|---|---|"
    for r in $3; do printf '| [`%s.rye`](%s.rye) | does a thing |\n' "$r" "$r"; done
  } > "$d/MODULES.md"
}

# check <label> <dir> <expect ok|red> <key=value that must appear>
check() {
  n=$((n + 1))
  out=$(sh "$SCAN" census "$PEN/$2" 2>&1) && code=0 || code=$?
  want_ok=$3
  key=$4
  bad=0
  if [ "$want_ok" = ok ]; then
    [ "$code" -eq 0 ] || bad=1
  else
    [ "$code" -ne 0 ] || bad=1
  fi
  case "$out" in *"$key"*) ;; *) bad=1 ;; esac
  if [ "$bad" -eq 0 ]; then
    if [ "$want_ok" = ok ]; then echo "$n free: $1"; else echo "$n bitten: $1"; fi
  else
    fail=$((fail + 1))
    echo "$n MISREAD: $1 -- wanted $want_ok with $key, read code=$code"
    echo "$out" | sed 's/^/    /'
  fi
}

# 1 -- the honest shape, first, so a later bite means something.
build whole "qoi photos sprite" "qoi photos sprite"
check "an exact bijection over three modules reads clean" whole ok "bijection=yes"

# 2 -- the fault that named this guard: 117 modules landed and no row followed.
build short "qoi photos sprite watershed" "qoi photos sprite"
check "a module on disk with no row counts against the gate" short red "unrostered=1"

# 3 -- the mirror fault, and the one the departing page actually carried: a row naming a module
#      that lives in another directory. image/README.md named dexter_line.rye and
#      scooter_compose.rye, both of which stand in pond/apps/.
build ghost "qoi photos" "qoi photos dexter_line"
check "a row naming a module absent from this directory counts against the gate" ghost red "phantom=1"

# 4 -- two rows for one module may disagree, so one module wears one row.
build twice "qoi photos" "qoi photos photos"
check "one module wearing two rows counts against the gate" twice red "duplicate_rows=1"

# 5 -- a row whose display text and target disagree names two modules and is trusted for neither.
build split "qoi photos" "qoi photos"
printf '| [`photos.rye`](qoi.rye) | does a thing |\n' >> "$PEN/split/MODULES.md"
check "a row whose text and target disagree counts against the gate" split red "mismatched_rows=1"

# 6 -- the reading that would have called the short table complete. The arc pages beside this one
#      cite their modules in prose constantly, so a guard reading any `.rye` link would find them
#      all and say nothing. This is why the Module column is what is matched.
build prose "qoi photos watershed" "qoi photos"
{
  echo
  echo "## Why the watershed exists"
  echo
  echo 'The rung [`watershed.rye`](watershed.rye) separates touching blobs, and [`watershed.rye`](watershed.rye) again.'
} >> "$PEN/prose/MODULES.md"
check "a module cited only in prose beneath the table stays unrostered" prose red "unrostered=1"

# 7 -- a name carrying digits is a module here. font5x7_currency.rye is one of forty-eight, and a
#      class of [a-z_] alone would have read every one of them as absent from the table.
build digits "qoi font5x7_currency" "qoi font5x7_currency"
check "a module name carrying digits binds its row" digits ok "rows_in_table=2"

# 8 -- a seam symlink is a module a reader finds in this directory, so it wants a row like any
#      other. image/parse_int.rye and image/tally_copy.rye point into ../tally/.
build seam "qoi" "qoi tally_copy"
ln -s ../qoi.rye "$PEN/seam/tally_copy.rye"
check "a seam symlink counts as a module and its row rosters it" seam ok "modules_on_disk=2"

# 9 -- and the same symlink with no row is refused, so case 8 proves inclusion rather than silence.
build seam_short "qoi" "qoi"
ln -s ../qoi.rye "$PEN/seam_short/tally_copy.rye"
check "a seam symlink with no row counts against the gate" seam_short red "unrostered=1"

# 10 -- a second table on the page counts the same way, which is how twelve families are rostered.
build families "qoi photos color" "qoi photos"
{
  echo
  echo "## Color -- 1"
  echo
  echo "| Module | What it does |"
  echo "|---|---|"
  printf '| [`color.rye`](color.rye) | the open sRGB color algebra |\n'
} >> "$PEN/families/MODULES.md"
check "a row in a second table on the page rosters its module" families ok "bijection=yes"

# 11 -- the page itself going missing reads as every module unrostered rather than as clean.
build gone "qoi photos" "qoi photos"
rm -f "$PEN/gone/MODULES.md"
check "an absent page reads as unrostered rather than clean" gone red "unrostered=2"

# 12 -- a meter reading nothing must say so rather than report clean.
build hollow "" ""
check "an empty directory reads as an empty corpus rather than clean" hollow red "verdict=empty_corpus"

# 13 -- the delimiter row is punctuation, and names no module.
build delim "qoi" "qoi"
check "a table delimiter row names no module" delim ok "rows_in_table=1"

# 14 -- a module and its row leaving together troubles nothing, which is what keeps the guard from
#       refusing an honest removal. Built at three and shrunk to two, both sides at once.
build shrunk "qoi photos sprite" "qoi photos sprite"
rm -f "$PEN/shrunk/sprite.rye"
grep -v 'sprite\.rye' "$PEN/shrunk/MODULES.md" > "$PEN/shrunk/MODULES.tmp"
cat "$PEN/shrunk/MODULES.tmp" > "$PEN/shrunk/MODULES.md"
rm -f "$PEN/shrunk/MODULES.tmp"
check "a module and its row leaving together read clean at two" shrunk ok "modules_on_disk=2"

# 15 -- the departing shape, at scale: a page naming roughly half its directory. This is what
#       image/README.md read on 20260824, and the count is what makes the gap visible.
build half "a1 a2 a3 a4 a5 a6 a7 a8" "a1 a2 a3 a4"
check "a page naming half its directory counts every absentee" half red "unrostered=4"

# 16 -- a description carrying an escaped pipe still rosters its module. Ten lotus rows write an
#       absolute value as `y = \|x\|`, which is the correct Markdown for a literal pipe inside a
#       table cell, and a reading that stopped at the first pipe would call every one of them a
#       mismatch. The row regex anchors on the Module column's prefix, so the cell's own text is
#       read past -- proven here rather than assumed.
build piped "rectify" ""
printf '| [`rectify.rye`](rectify.rye) | the full-wave rectifier -- y = \\|x\\|, the plainest EVEN-harmonic generator |\n' >> "$PEN/piped/MODULES.md"
check "a row whose description carries an escaped pipe rosters its module" piped ok "bijection=yes"

echo "control_cases=$n"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=misread"
exit 1
