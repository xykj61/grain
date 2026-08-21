#!/bin/sh
# tools/fixtures/sha3.sh -- SHA3-256 or SHA3-512, from this tree's own Keccak.
#
# WHY. The tree's digests were computed by `openssl dgst -sha3-256` and `-sha3-512`. openssl is
# reachable here only through a nix-store path this pier happens to carry, which is not a
# dependency anyone chose -- it is one that happened. `crypto/sha3_digest.rye` computes the same
# two algorithms over `crypto/sha3.rye`, authored Rye over Keccak-f[1600], clean-room from FIPS
# 202. Same algorithm, same digests, no external binary.
#
# THE ALGORITHM DOES NOT CHANGE, AND THAT IS THE WHOLE POINT. SHA3 is not SHA-2; `sha256sum` would
# have silently rewritten every content address in the tree (REDS %116). This substitutes one
# implementation of SHA3 for another, which is safe precisely because it is not a substitution of
# algorithm -- and the waymark registry witness re-derives every seated mark from its input, so a
# drift of even one digit would red on the lap it entered.
#
# openssl remains the INDEPENDENT ORACLE the hash-tier spec asks for, wherever it is installed:
# `tools/sha3_file_witness.rish` checks ours against the published FIPS 202 known-answer vectors
# always, and against openssl additionally when it is present.
#
# USAGE
#   sh tools/fixtures/sha3.sh 256 <path>     # 64 lowercase hex characters
#   sh tools/fixtures/sha3.sh 512 <path>     # 128 lowercase hex characters
#   sh tools/fixtures/sha3.sh 512 -          # hash standard input
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

bits="${1:?name the width: 256 or 512}"
file="${2:?name the file to digest, or - for standard input}"

case "$bits" in
  256) want=64 ;;
  512) want=128 ;;
  *) echo "sha3: width must be 256 or 512, not $bits" >&2; exit 1 ;;
esac

# Resolved from THIS script's own location rather than from the working directory. Callers run from
# temp directories -- the Amphora witness pours into a mktemp root -- and a tool that finds its own
# binary only when someone happens to be standing in the repository fails exactly where it is used.
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
BIN="$ROOT/crypto/bin/sha3-digest"

if [ ! -x "$BIN" ]; then
  ZIG="$ROOT/vendor/zig-toolchain/zig"
  [ -x "$ZIG" ] || { echo "sha3: no toolchain -- run: sh tools/fetch-toolchain.sh" >&2; exit 1; }
  mkdir -p "$ROOT/crypto/bin"
  ( cd "$ROOT" && env RYE_ZIG="$ZIG" rye/bin/rye build crypto/sha3_digest.rye -femit-bin=crypto/bin/sha3-digest ) >/dev/null 2>&1 \
    || { echo "sha3: could not build crypto/sha3_digest.rye" >&2; exit 1; }
fi

# Standard input is spooled to a file rather than taught to the digest tool. Several callers hash a
# short string -- a ladder name, a registry line -- and a temp file is a smaller thing to get right
# than a streaming path in a tool whose whole job is one answer.
spool=""
target="$file"
if [ "$file" = "-" ]; then
  spool="$(mktemp)"
  cat > "$spool"
  target="$spool"
fi
[ -f "$target" ] || { [ -n "$spool" ] && rm -f "$spool"; echo "sha3: no such file: $file" >&2; exit 1; }

out="$("$BIN" "$bits" "$target")"
[ -n "$spool" ] && rm -f "$spool"

# invariant: a digest is exactly its promised width in lowercase hex. An empty or short answer is
# what produced the failure this whole thread began with -- an empty digest wrote a short manifest
# line, and the reader of that line then died on a field that was not there. Refuse it here.
[ "${#out}" -eq "$want" ] || { echo "sha3: digest was ${#out} characters, not $want, for $file" >&2; exit 1; }
case "$out" in
  *[!0-9a-f]*) echo "sha3: refusing a non-hex digest for $file" >&2; exit 1 ;;
esac

printf '%s\n' "$out"
