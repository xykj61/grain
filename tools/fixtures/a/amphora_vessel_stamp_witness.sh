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
grep -q '^stamp_sig ' "$home/vessel.kyri"
"$ROOT/amphora/bin/vessel-core" verify "$home/vessel.kyri" >/dev/null

sh "$ROOT/tools/fixtures/a/amphora_carry.sh" "$home" "$far"
sh "$ROOT/tools/fixtures/a/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome: flip one stamp_sig hex nibble -- scrub/verify must refuse.
sig_line=$(grep '^stamp_sig ' "$far/vessel.kyri")
# rewrite stamp_sig with a flipped first hex digit
first=$(printf '%s' "$sig_line" | awk '{print substr($2,1,1)}')
rest=$(printf '%s' "$sig_line" | awk '{print substr($2,2)}')
case "$first" in
  a) bad=b ;;
  *) bad=a ;;
esac
{
  grep -v '^stamp_sig ' "$far/vessel.kyri"
  printf 'stamp_sig %s%s\n' "$bad" "$rest"
} > "$far/vessel.kyri.bad"
mv "$far/vessel.kyri.bad" "$far/vessel.kyri"

if "$ROOT/amphora/bin/vessel-core" verify "$far/vessel.kyri" 2>/dev/null; then
  echo "FAIL tampered stamp_sig should not verify"
  exit 1
fi
echo "TAMPER refused"

# Unwelcome: a foreign grammar refuses the sign verb BEFORE it writes, so a vessel
# nobody understands never lands carrying a stamp_sig over bytes the signer could not read.
foreign="$home/foreign.bron"
cat > "$foreign" <<'EOF'
format amphora-v2
stamp 20260710.145843
shoulder amber-ring1-season
parent 0000000000000000000000000000000000000000000000000000000000000000
cargo plain-bytes cd416bd6cae889877c353fc9abe39daaff1668666049a8fd10974248d99d23ab hello.txt
EOF
cp "$foreign" "$foreign.before"
if "$ROOT/amphora/bin/vessel-core" sign "$foreign" 2>/dev/null; then
  echo "FAIL foreign grammar should not sign"
  exit 1
fi
if ! cmp -s "$foreign" "$foreign.before"; then
  echo "FAIL foreign grammar sign wrote the file before refusing"
  exit 1
fi
echo "FOREIGN refused"

echo "GREEN: Amphora vessel stamp — pour signed, scrub verified, tamper refused, foreign grammar refused"
