#!/bin/sh
# Prove the door-count seam passing and refusing with real files in a throwaway pen.
set -eu

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM
mkdir -p "$PEN/caravan" "$PEN/tools/ca"
printf '// seed\n' > "$PEN/caravan/seed.rye"
printf '// twin\n' > "$PEN/caravan/twin.rye"
{
  echo '| Ring | File | Proves |'
  echo '|---|---|---|'
  echo '| seed | [`seed.rye`](seed.rye) | one |'
  echo '| twin | [`twin.rye`](twin.rye) | two |'
} > "$PEN/caravan/LADDER.md"
printf '# witness\n' > "$PEN/tools/ca/caravan_seed_witness.rish"
printf 'let witnesses = [ "tools/ca/caravan_seed_witness.rish" ]\n' > "$PEN/roster.rish"

write_door() {
  printf '**Status:** Checkable -- %s modules in this directory and %s registered witnesses in tools, measured today\n\n**[`LADDER.md`](LADDER.md)** holds the full table of all %s modules.\n' "$1" "$2" "$3" > "$PEN/caravan/README.md"
}
run_scan() {
  CARAVAN_DIR="$PEN/caravan" CARAVAN_README="$PEN/caravan/README.md" CARAVAN_TOOLS_DIR="$PEN/tools" CARAVAN_ROSTER_FILE="$PEN/roster.rish" sh tools/fixtures/c/caravan_door_count_scan.sh
}

write_door 2 1 2
run_scan >/dev/null
echo '1 free: measured module, witness, and ladder counts pass'
write_door 1 1 2
if run_scan >/dev/null 2>&1; then exit 1; fi
echo '2 bitten: a stale module count refuses'
write_door 2 2 2
if run_scan >/dev/null 2>&1; then exit 1; fi
echo '3 bitten: a stale witness count refuses'
write_door 2 1 1
if run_scan >/dev/null 2>&1; then exit 1; fi
echo '4 bitten: a stale ladder count refuses'
echo 'control_cases=4'
echo 'control_fail=0'
echo 'control_verdict=ok'
