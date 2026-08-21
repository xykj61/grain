#!/bin/sh
# tools/fixtures/sha3_file_control.sh -- the digest tool, against published answers.
#
# The two vectors below are the FIPS 202 SHA3-256 known answers for the empty string and for the
# three bytes "abc". They are public, stable, and checkable by anyone against the standard -- which
# is the whole point: a tree cannot grade its own hash function.
#
# Driven by tools/sha3_file_witness.rish. Run from the repository root.

set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SHA3="$ROOT/tools/fixtures/sha3.sh"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

: > "$work/empty.bin"
printf 'abc' > "$work/abc.bin"
printf 'abd' > "$work/abd.bin"

empty=$(sh "$SHA3" 256 "$work/empty.bin")
abc=$(sh "$SHA3" 256 "$work/abc.bin")
abd=$(sh "$SHA3" 256 "$work/abd.bin")

# SHA3-512 carries the waymark draws and the registry seal, so it is checked here too rather than
# trusted because its 256-bit sibling passed. Two widths, two published answers.
empty512=$(sh "$SHA3" 512 "$work/empty.bin")
abc512=$(sh "$SHA3" 512 "$work/abc.bin")
stdin512=$(printf 'abc' | sh "$SHA3" 512 -)

echo "empty=$empty"
echo "abc=$abc"
echo "length=${#abc}"
echo "empty512=$empty512"
echo "abc512=$abc512"
echo "length512=${#abc512}"
if [ "$stdin512" = "$abc512" ]; then echo "stdin_matches_file=yes"; else echo "stdin_matches_file=no"; fi

# The digest must reach stdout, or every $(...) around it reads the empty string -- which is
# exactly the failure that wrote a short manifest line and killed the reader of that line.
[ -n "$abc" ] && echo "capturable=yes" || echo "capturable=no"

if [ "$abc" != "$abd" ]; then echo "one_byte_changes_digest=yes"; else echo "one_byte_changes_digest=no"; fi

# The hash-tier spec calls openssl the INDEPENDENT host oracle, so it is consulted wherever it can
# be found -- including the nix store, which is where this pier keeps it. Reported honestly when
# absent rather than silently skipped.
OSSL=$(command -v openssl || ls /run/current-system/sw/bin/openssl 2>/dev/null || ls /nix/store/*-openssl-*/bin/openssl 2>/dev/null | head -1)
if [ -n "${OSSL:-}" ] && [ -x "$OSSL" ]; then
  o256=$("$OSSL" dgst -sha3-256 "$work/abc.bin" | awk '{print $NF}')
  o512=$("$OSSL" dgst -sha3-512 "$work/abc.bin" | awk '{print $NF}')
  if [ "$o256" = "$abc" ] && [ "$o512" = "$abc512" ]; then
    echo "openssl_parity=agrees_both_widths"
  else
    echo "openssl_parity=DISAGREES"
  fi
else
  echo "openssl_parity=skipped_openssl_absent"
fi

if [ "$empty" = "a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a" ] \
&& [ "$abc" = "3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532" ] \
&& [ "$empty512" = "a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26" ] \
&& [ "$abc512" = "b751850b1a57168a5693cd924b6b096e08f621827444f70d884f5d0240d2712e10e116e9192af3c91a7ec57647e3934057340b4cf408d5a56592f8274eec53f0" ] \
&& [ "$stdin512" = "$abc512" ] && [ "${#abc512}" -eq 128 ] \
&& [ "$abc" != "$abd" ] && [ "${#abc}" -eq 64 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
