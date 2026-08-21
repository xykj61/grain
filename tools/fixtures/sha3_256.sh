#!/bin/sh
# tools/fixtures/sha3_256.sh -- the SHA3-256 of a file, from this tree's own Keccak.
#
# WHY THIS SHIM. The Amphora and Cellar fixtures pinned `openssl dgst -sha3-256`, and openssl is
# absent from this pier -- so Amphora lap 2 could not run, and the fascia meter stayed silent
# behind it (REDS %112). The obvious substitution is the wrong one: `sha256sum` computes SHA-2 and
# SHA3-256 is Keccak. Different algorithms, not two spellings of one, and swapping them would
# silently change every content address in every manifest this tree has written.
#
# So the digest comes from `crypto/sha3_file.rye` -- authored Rye over Keccak-f[1600], studied
# clean-room from FIPS 202, computing exactly the algorithm the hash-tier spec already names for
# the Working tier. Same algorithm, same digests, no external dependency.
#
# openssl remains the INDEPENDENT ORACLE the spec asks for, wherever it is installed --
# `tools/sha3_file_witness.rish` checks our digests against it when present, and against published
# FIPS 202 answers always, so the parity claim rests on a public standard rather than on whichever
# tools a machine happens to carry.
#
# USAGE
#   sh tools/fixtures/sha3_256.sh <path>     # prints 64 lowercase hex characters
#
# Run from the repository root.

set -eu

file="${1:?name the file to digest}"
[ -f "$file" ] || { echo "sha3-256: no such file: $file" >&2; exit 1; }

# Resolved from THIS script's own location rather than from the working directory. Callers run
# from temp directories -- the Amphora witness pours into a mktemp root -- and a tool that finds
# its own binary only when someone happens to be standing in the repository is a tool that fails
# exactly where it is used.
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
BIN="$ROOT/crypto/bin/sha3-256"

# Built once and reused. The toolchain is one command away now (`sh tools/fetch-toolchain.sh`), so
# a missing binary is a build rather than a dead end.
if [ ! -x "$BIN" ]; then
  ZIG="$ROOT/vendor/zig-toolchain/zig"
  [ -x "$ZIG" ] || { echo "sha3-256: no toolchain -- run: sh tools/fetch-toolchain.sh" >&2; exit 1; }
  mkdir -p "$ROOT/crypto/bin"
  ( cd "$ROOT" && env RYE_ZIG="$ZIG" rye/bin/rye build crypto/sha3_file.rye -femit-bin=crypto/bin/sha3-256 ) >/dev/null 2>&1 \
    || { echo "sha3-256: could not build crypto/sha3_file.rye" >&2; exit 1; }
fi

out="$("$BIN" "$file")"

# invariant: a SHA3-256 digest is exactly sixty-four lowercase hex characters. A short or empty
# answer here is what produced the ORIGINAL failure -- an empty digest wrote a short manifest line,
# and the reader of that line then died on an unbound field. Refuse rather than pass it along.
case "$out" in
  [0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]*) ;;
  *) echo "sha3-256: refusing a malformed digest for $file" >&2; exit 1 ;;
esac
[ "${#out}" -eq 64 ] || { echo "sha3-256: digest was ${#out} characters, not 64, for $file" >&2; exit 1; }

printf '%s\n' "$out"
