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
SHA3="$ROOT/tools/fixtures/sha3_256.sh"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

: > "$work/empty.bin"
printf 'abc' > "$work/abc.bin"
printf 'abd' > "$work/abd.bin"

empty=$(sh "$SHA3" "$work/empty.bin")
abc=$(sh "$SHA3" "$work/abc.bin")
abd=$(sh "$SHA3" "$work/abd.bin")

echo "empty=$empty"
echo "abc=$abc"
echo "length=${#abc}"

# The digest must reach stdout, or every $(...) around it reads the empty string -- which is
# exactly the failure that wrote a short manifest line and killed the reader of that line.
[ -n "$abc" ] && echo "capturable=yes" || echo "capturable=no"

if [ "$abc" != "$abd" ]; then echo "one_byte_changes_digest=yes"; else echo "one_byte_changes_digest=no"; fi

if command -v openssl >/dev/null 2>&1; then
  oss=$(openssl dgst -sha3-256 -r "$work/abc.bin" | awk '{print $1}')
  if [ "$oss" = "$abc" ]; then echo "openssl_parity=agrees"; else echo "openssl_parity=DISAGREES"; fi
else
  echo "openssl_parity=skipped_openssl_absent"
fi

if [ "$empty" = "a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a" ] \
&& [ "$abc" = "3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532" ] \
&& [ "$abc" != "$abd" ] && [ "${#abc}" -eq 64 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
