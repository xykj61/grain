#!/usr/bin/env sh
# amphora_vessel_stamp_witness.sh -- pour signed vessel, scrub verifies, tamper refuses.
set -eu
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
STAMP=20260710.145843

home=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$far"' EXIT

sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$SRC" "$home" "$STAMP"
grep -q '^stamp_sig ' "$home/vessel.bron"
"$ROOT/amphora/bin/vessel-core" verify "$home/vessel.bron" >/dev/null

sh "$ROOT/tools/fixtures/a/amphora_carry.sh" "$home" "$far"
sh "$ROOT/tools/fixtures/a/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome: flip one stamp_sig hex nibble -- scrub/verify must refuse.
sig_line=$(grep '^stamp_sig ' "$far/vessel.bron")
# rewrite stamp_sig with a flipped first hex digit
first=$(printf '%s' "$sig_line" | awk '{print substr($2,1,1)}')
rest=$(printf '%s' "$sig_line" | awk '{print substr($2,2)}')
case "$first" in
  a) bad=b ;;
  *) bad=a ;;
esac
{
  grep -v '^stamp_sig ' "$far/vessel.bron"
  printf 'stamp_sig %s%s\n' "$bad" "$rest"
} > "$far/vessel.bron.bad"
mv "$far/vessel.bron.bad" "$far/vessel.bron"

if "$ROOT/amphora/bin/vessel-core" verify "$far/vessel.bron" 2>/dev/null; then
  echo "FAIL tampered stamp_sig should not verify"
  exit 1
fi
echo "TAMPER refused"

echo "GREEN: Amphora vessel stamp — pour signed, scrub verified, tamper refused"
