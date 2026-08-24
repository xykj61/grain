#!/bin/sh
# tools/fixtures/caravan_ladder_roster_control.sh -- the ladder-roster guard, proven from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. This pen builds
# real directories holding real .rye files and a real LADDER.md, plants one fault at a time, and
# asks the scan what it reads -- so every gate is shown biting and every honest shape is shown
# passing free.
#
# Each case prints one line naming what was planted and whether it was bitten or left free. The
# tally at the end is what tools/ca/caravan_ladder_roster_witness.rish asserts on.
#
# Run from the repository root:  sh tools/fixtures/caravan_ladder_roster_control.sh
set -eu

SCAN=tools/fixtures/caravan_ladder_roster_scan.sh
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

fail=0
n=0

# Build a directory holding the named modules and a LADDER.md whose table names $2.
# build <dir> "<modules on disk>" "<rows to write>"
build() {
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d"
  for m in $2; do printf '// %s\n' "$m" > "$d/$m.rye"; done
  {
    echo "# pen ladder"
    echo
    echo "| Ring | File | Proves |"
    echo "|------|------|--------|"
    for r in $3; do printf '| %s | [`%s.rye`](%s.rye) | proves a thing |\n' "$r" "$r" "$r"; done
  } > "$d/LADDER.md"
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
build whole "seed twin chain" "seed twin chain"
check "an exact bijection over three modules reads clean" whole ok "bijection=yes"

# 2 -- the fault that named this guard: a module landed and no row followed.
build short "seed twin chain relent" "seed twin chain"
check "a module on disk with no row counts against the gate" short red "unrostered=1"

# 3 -- the mirror fault: a row outliving the module it names.
build ghost "seed twin" "seed twin chain"
check "a row naming an absent module counts against the gate" ghost red "phantom=1"

# 4 -- two rows for one module may disagree, so one module wears one row.
build twice "seed twin" "seed twin twin"
check "one module wearing two rows counts against the gate" twice red "duplicate_rows=1"

# 5 -- a row whose display text and target disagree names two modules and is trusted for neither.
build split "seed twin" "seed twin"
printf '| twin | [`twin.rye`](chain.rye) | proves a thing |\n' >> "$PEN/split/LADDER.md"
check "a row whose text and target disagree counts against the gate" split red "mismatched_rows=1"

# 6 -- the reading that would have called the short table complete. Prose beneath the table cites
# every module constantly, so a guard reading any `.rye` link would find them all and say nothing.
build prose "seed twin chain" "seed twin"
{
  echo
  echo "## Why the chain exists"
  echo
  echo 'The chain rung [`chain.rye`](chain.rye) orders startup, and [`chain.rye`](chain.rye) again.'
} >> "$PEN/prose/LADDER.md"
check "a module cited only in prose beneath the table stays unrostered" prose red "unrostered=1"

# 7 -- a ring name is free prose. `ipc buffer` names ipc_buffer.rye, and both spellings are right.
build spaced "seed ipc_buffer" "seed"
printf '| ipc buffer | [`ipc_buffer.rye`](ipc_buffer.rye) | proves a thing |\n' >> "$PEN/spaced/LADDER.md"
check "a ring name carrying a space still binds its module" spaced ok "bijection=yes"

# 8 -- a second table on the page counts the same way, which is how the four helpers are rostered.
build helpers "seed twin ladder_checks" "seed twin"
{
  echo
  echo "### The helpers"
  echo
  echo "| Helper | File | What it carries |"
  echo "|--------|------|-----------------|"
  printf '| ladder checks | [`ladder_checks.rye`](ladder_checks.rye) | the shared harness |\n'
} >> "$PEN/helpers/LADDER.md"
check "a row in a second table on the page rosters its module" helpers ok "bijection=yes"

# 9 -- the page itself going missing reads as every module unrostered rather than as clean.
build gone "seed twin" "seed twin"
rm -f "$PEN/gone/LADDER.md"
check "an absent page reads as unrostered rather than clean" gone red "unrostered=2"

# 10 -- a meter reading nothing must say so rather than report clean.
build hollow "" ""
check "an empty directory reads as an empty corpus rather than clean" hollow red "verdict=empty_corpus"

# 11 -- the delimiter row is punctuation, and names no module.
build delim "seed" "seed"
check "a table delimiter row names no module" delim ok "rows_in_table=1"

# 12 -- a module and its row leaving together troubles nothing, which is what keeps the guard from
# refusing an honest removal. Built at three and shrunk to two, both sides at once.
build shrunk "seed twin chain" "seed twin chain"
rm -f "$PEN/shrunk/chain.rye"
grep -v 'chain\.rye' "$PEN/shrunk/LADDER.md" > "$PEN/shrunk/LADDER.tmp"
cat "$PEN/shrunk/LADDER.tmp" > "$PEN/shrunk/LADDER.md"
rm -f "$PEN/shrunk/LADDER.tmp"
check "a module and its row leaving together read clean at two" shrunk ok "modules_on_disk=2"

echo "control_cases=$n"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=misread"
exit 1
