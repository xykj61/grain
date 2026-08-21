#!/bin/sh
# tools/fixtures/sha3_256.sh -- SHA3-256 of a file, from this tree's own Keccak.
#
# A thin wrapper over tools/fixtures/sha3.sh, kept because five Amphora and Cellar fixtures already
# call it by this name and references are promises. The reasoning lives in sha3.sh.
#
#   sh tools/fixtures/sha3_256.sh <path>
set -eu
exec sh "$(dirname "$0")/sha3.sh" 256 "$@"
