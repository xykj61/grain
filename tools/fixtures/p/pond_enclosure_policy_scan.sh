#!/usr/bin/env sh
# pond_enclosure_policy_scan.sh -- Pond reads an enclosure policy and marks it at receipt.
#
# WHAT THIS PROVES. Orbit one of the quest that retires ai-jail asks for two things: a planted
# policy round-trips, and a forbidden mount refuses BY NAME. Both are read here on metal, and
# every refusal is shown from both sides -- the plant refuses, and the same file with the plant
# removed returns to green. A refusal proven only in the passing direction cannot be told from a
# bypass, which is why the removal leg exists.
#
#   sh tools/fixtures/p/pond_enclosure_policy_scan.sh
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
BIN="$ROOT/pond/bin/enclosure-policy"
LIVE="$ROOT/pond/enclosure_policy.kyri"
REFUSE="$ROOT/tools/fixtures/p/pond_enclosure_policy_refuse.kyri"
HOLD="$ROOT/tools/fixtures/p/pond_enclosure_policy_hold.kyri"

# THE BUILD IS THIS SCAN'S OWN, EVERY RUN. This line read `if ! test -x "$BIN"` until `20260829`,
# so a binary built once stood forever and every later edit to pond/enclosure_policy.rye was
# invisible here. The lap that seated the `user` mark watched it happen: the new mark was refused as
# an unknown token by a build that predated it, and the SELFTEST leg above passed on those same
# stale bytes, so the scan reported a module that no longer existed. A guard that runs a build it
# did not make cannot tell you the source moved. That is REDS %334's family one step on -- there a
# witness named its build in a comment and ran the binary; here a scan made a build and never
# remade it. Measured on this pier `20260829`: the whole scan runs 1.4s from a deleted binary, of
# which the build is 0.8s -- so owning the build costs under a second and buys the one thing this
# reading exists for.
mkdir -p "$ROOT/pond/bin"
env RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}" \
  "$ROOT/rye/bin/rye" build "$ROOT/pond/enclosure_policy.rye" -femit-bin="$BIN"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# One helper, so every leg reads a verdict the same way by construction.
expect() {
  want_code=$1
  want_text=$2
  shift 2
  set +e
  out=$("$@" 2>&1)
  code=$?
  set -e
  test "$code" -eq "$want_code" || { echo "FAIL want exit $want_code got $code from: $*"; echo "$out"; exit 1; }
  echo "$out" | grep -q "$want_text" || { echo "FAIL missing '$want_text' from: $*"; echo "$out"; exit 1; }
}

expect 0 GREEN "$BIN" selftest
echo "SELFTEST ok every mark answers as its comment says"

# The honest policy of the lap running today round-trips whole and REFUSES, naming one line.
#
# This leg has moved twice, and each move was the record getting truer rather than the module
# getting worse. It read `verdict=place` until 20260828, because the record claimed `network off`
# for an enclosure whose network namespace is the host's own -- refuted on metal, REDS %329. It
# read `hold` for the rest of that day. Then the jail's own twenty-one default mounts were
# measured off `ai-jail --dry-run` and declared, and two of them refuse: a whole-`/sys` read-only
# map, which this module's roster refuses by name, and a read-write bind of the host's X11 socket
# directory under /tmp. Pond will not admit this enclosure as it stands, and the record now says
# so where an operator reads it.
#
# Naming the refusing declaration rather than counting refusals is what lets this leg catch a
# drift in any OTHER line: a third refusal, or a different first one, changes the message and
# fails here. The counts ride beside the name for the same reason -- a line that quietly stops
# refusing moves them. The place count moved 28 -> 30 on `20260830` when the door's second duty
# seated its two `env` lines. It also moved for a reason worth keeping named: until that lap the
# checker read the record into a buffer sized AT max_policy_len, and `readFile` fills a buffer
# rather than refusing -- so an 8,468-byte record read as 31 declarations of 34, with the half-line
# at the cut counted as a refusal of a declaration that does not exist. The reader takes one byte
# more than the bound now, so the length check that was unreachable by construction fires, and the
# TOOLONG leg below proves it from both sides.
expect 2 'forbidden declaration: map /sys' "$BIN" check "$LIVE"
expect 2 'place=30 hold=2 refuse=2' "$BIN" check "$LIVE"
echo "ROUNDTRIP ok pond/enclosure_policy.kyri reads whole; today's lap refuses on the enclosure's own /sys"

# A forbidden mount refuses, and the receipt names the mount rather than counting it.
expect 2 'forbidden declaration: map /home/youruser/.ssh' "$BIN" check "$REFUSE"
echo "REFUSE ok the key room is named, not merely counted"

# The removal direction: the same file without the plant returns to green, so the refusal is
# caused by the planted line rather than by anything else the fixture happens to carry.
grep -v '^map /home/youruser/\.ssh$' "$REFUSE" > "$pen/plant_removed.kyri"
expect 0 'verdict=place' "$BIN" check "$pen/plant_removed.kyri"
echo "REMOVAL ok the plant alone caused the refusal"

# The seated KVM lane holds for a word rather than refusing outright.
expect 1 'awaits a word: device /dev/kvm' "$BIN" check "$HOLD"
echo "HOLD ok the seated device lane waits for a word"

# An unknown mark is refused whole -- the wreck rule for types, read at the document level.
printf 'format pond-enclosure-policy-v1\nmap /nix/store\ntunnel /dev/net/tun\n' > "$pen/stranger.kyri"
expect 2 'forbidden declaration: tunnel /dev/net/tun' "$BIN" check "$pen/stranger.kyri"
echo "STRANGER ok an unknown mark refuses the whole policy"

# A record that declares no enclosure at all is refused rather than read as an empty permission.
printf '# only a header\nformat pond-enclosure-policy-v1\nname nothing-declared\n' > "$pen/empty.kyri"
set +e
"$BIN" check "$pen/empty.kyri" >/dev/null 2>&1
empty_code=$?
set -e
test "$empty_code" -ne 0 || { echo "FAIL an empty policy passed"; exit 1; }
echo "EMPTY ok a policy declaring nothing is refused"

# The single-declaration door an operator reaches for at the terminal.
expect 0 'verdict=place' "$BIN" explain map /nix/store
expect 1 'verdict=hold' "$BIN" explain device /dev/kvm
expect 2 'verdict=refuse' "$BIN" explain map /tmp
expect 2 'unknown declaration mark' "$BIN" explain tunnel /dev/net/tun
echo "EXPLAIN ok place, hold, refuse, and an unknown mark"

# The door's first duty, read at the same terminal door. Every branch of the `user` mark is shown
# here as well as inside the selftest, because this is where an operator meets it: `invoking` is
# what the launcher does and places; root refuses by either spelling; a bare uid holds, since no
# flag this launcher passes could set it; and a placeholder refuses, because in this mark the value
# is the whole claim rather than a structure a placeholder could keep.
expect 0 'verdict=place'  "$BIN" explain user invoking
expect 2 'verdict=refuse' "$BIN" explain user root
expect 2 'verdict=refuse' "$BIN" explain user 0
expect 1 'verdict=hold'   "$BIN" explain user 1000
expect 2 'verdict=refuse' "$BIN" explain user '<uid>'
echo "USER ok invoking places, root refuses by name and by number, a bare uid holds, a placeholder refuses"


# The door's second duty, read at the same terminal door. The value is one KEY=value assignment
# written the exec line's own way, and its value half reads as a search path so one rule serves a
# single directory and a four-element PATH alike. A key room refuses hardest here -- a pointer at
# custody material is still a pointer at custody material -- and an empty element refuses for free,
# since POSIX reads one as the current directory. A lowercase key HOLDS rather than refuses: it is a
# legal variable that the door guard's uppercase lift cannot see, so it is a claim nothing settles.
expect 0 'verdict=place'  "$BIN" explain env 'GH_CONFIG_DIR=/home/youruser/grain/.gh'
expect 0 'verdict=place'  "$BIN" explain env 'PATH=/run/current-system/sw/bin:/bin'
expect 2 'verdict=refuse' "$BIN" explain env 'SSH_AUTH_DIR=/home/youruser/.ssh'
expect 2 'verdict=refuse' "$BIN" explain env 'PATH=/bin::/usr/bin'
expect 2 'verdict=refuse' "$BIN" explain env 'GH_CONFIG_DIR'
expect 1 'verdict=hold'   "$BIN" explain env 'http_proxy=/bin'
echo "ENV ok a KEY=value places, a key room and an empty element refuse, a lowercase key holds"

# THE BOUND, PROVEN FROM BOTH SIDES ON REAL FILES. A record one byte past max_policy_len must
# refuse BY NAME, and the same record trimmed back under it must return to its ordinary verdict --
# a refusal proven only in the passing direction cannot be told from a bypass, and this one hid
# behind a buffer sized at the bound until `20260830`.
long="$pen/too-long.kyri"
head -c 8192 "$LIVE" > "$long"
printf '# %s\n' "$(awk 'BEGIN { while (i++ < 120) printf "x" }')" >> "$long"
expect 2 'is longer than max_policy_len=8192' "$BIN" check "$long"
head -c 8000 "$LIVE" > "$long"
expect 2 'verdict=refuse' "$BIN" check "$long"
echo "TOOLONG ok a record past the bound refuses by name, and one under it is read whole"

echo "GREEN: pond enclosure-policy -- policy as a value; the forbidden mount refused by name"
