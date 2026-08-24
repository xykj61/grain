#!/bin/sh
# tools/fixtures/mycelium_map_roster_control.sh -- the map-roster guard, proven from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. This pen builds
# real directories holding real .rye files, real symlinks, and a real README.md, plants one fault at
# a time, and asks the scan what it reads -- so every gate is shown biting and every honest shape is
# shown passing free.
#
# Two of the fifteen carry the load this guard exists for. Case 7 DROPS a suffix row from the page
# and watches its companions go unreachable, which is what proves the rule is read from the README
# rather than recited in the scan; case 12 plants a two-suffix name over an UNNAMED middle and
# watches it bite, which is what proves derivation stays one deep and cannot be chained past a gap.
#
# Each case prints one line naming what was planted and whether it was bitten or left free. The
# tally at the end is what tools/m/mycelium_map_roster_witness.rish asserts on.
#
# Run from the repository root:  sh tools/fixtures/mycelium_map_roster_control.sh
set -eu

SCAN=tools/fixtures/mycelium_map_roster_scan.sh
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

fail=0
n=0

# build <dir> "<modules on disk>" "<names to map>" "<suffix rows>"
build() {
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d"
  for m in $2; do printf '// %s\n' "$m" > "$d/$m.rye"; done
  {
    echo "# pen map"
    echo
    echo "| Suffix | What it holds |"
    echo "|--------|---------------|"
    echo "| *(base)* | the primitive itself |"
    for s in $4; do printf '| `%s` | a companion shape |\n' "$s"; done
    echo
    for e in $3; do printf -- '- [`%s.rye`](%s.rye) -- holds a thing\n' "$e" "$e"; done
  } > "$d/README.md"
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

# 1 -- the honest shape, first, so every later bite means something.
build a "cord cord_bron purse" "cord purse" "_bron"
check "a map naming two bases, one companion reached by rule, reads clean at three" a ok "unreachable=0"

# 2 -- the gate this guard is named for.
build b "cord cord_bron orphan" "cord" "_bron"
check "a module reachable by neither name nor suffix counts against the gate" b red "unreachable=1"

# 3 -- the mirror.
build c "cord" "cord ghost" "_bron"
check "a map entry naming an absent module counts against the gate" c red "phantom=1"

# 4 -- two entries for one module may come to disagree.
build d "cord" "cord cord" "_bron"
check "one module named by two map entries counts against the gate" d red "duplicate_entries=1"

# 5 -- an entry naming two modules is trusted for neither.
build e "cord purse" "cord purse" "_bron"
printf -- '- [`cord.rye`](purse.rye) -- shows two names\n' >> "$PEN/e/README.md"
check "an entry whose text and target disagree counts against the gate" e red "mismatched_entries=1"

# 6 -- the rule doing its work: a companion never named directly.
build f "cord cord_bron cord_true cord_knot cord_fixture_gen cord_bench" "cord" "_bron _true _knot _fixture_gen _bench"
check "five companions reached by rule alone, none named, read clean" f ok "unreachable=0"

# 7 -- THE LOAD-BEARING CASE. The rule lives on the page, so dropping a row must bite.
build g "cord cord_bron cord_true" "cord" "_bron"
check "a suffix dropped from the table leaves its companions unreachable" g red "unreachable=1"

# 8 -- and the same page teaching a new shape must honor it, with no change to the scan.
build h "cord cord_relay" "cord" "_bron _relay"
check "a suffix added to the table honors its companions with no scan change" h ok "unreachable=0"

# 9 -- a citation of another room is not a roster entry.
build i "cord orphan" "cord" "_bron"
printf -- '- [`../tally/orphan.rye`](../tally/orphan.rye) -- another room\n' >> "$PEN/i/README.md"
check "a cross-directory link is read past and rosters nothing" i red "unreachable=1"

# 10 -- a meter over nothing must say so rather than report clean.
build j "" "" "_bron"
check "an empty directory reads as an empty corpus rather than clean" j red "verdict=empty_corpus"

# 11 -- one suffix deep, resolving through a base that is itself named.
build k "cord cord_knot cord_knot_bench" "cord cord_knot" "_bron _knot _bench"
check "a two-suffix name resolves when its middle is itself a named base" k ok "unreachable=0"

# 12 -- and refuses to chain past a middle nobody named.
build l "cord cord_knot_bench" "cord" "_bron _knot _bench"
check "a two-suffix name over an unnamed middle counts against the gate" l red "unreachable=1"

# 13 -- a seam symlink named in the map reads clean.
build m "cord" "cord borrowed" "_bron"
printf '// borrowed\n' > "$PEN/borrowed_source.rye"
ln -s ../borrowed_source.rye "$PEN/m/borrowed.rye"
check "a symlinked module named in the map reads clean" m ok "unreachable=0"

# 14 -- and an unnamed one bites, which is what proves symlinks are counted at all.
build n_dir "cord" "cord" "_bron"
ln -s ../borrowed_source.rye "$PEN/n_dir/borrowed.rye"
check "a symlinked module nobody named counts against the gate" n_dir red "unreachable=1"

# 15 -- a rule written ahead of its first companion is reported, never gated.
build o "cord cord_bron" "cord" "_bron _relay"
check "a seated suffix no module wears is reported and left free" o ok "unused_suffix=1"

echo "control_cases=$n"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=misread"
exit 1
