#!/bin/sh
# tools/f/fetch-toolchain.sh -- the toolchain, in one command, before anything is built.
#
# WHY A PLAIN SHELL ENTRY POINT. This is the SECOND thing a newcomer runs, and Rishi does not
# exist yet -- it is a Rye program, and Rye compiles through the very toolchain this fetches. So
# the one command that starts everything cannot itself require anything this tree has built. Plain
# `sh`, `curl`, and `tar`, and nothing else.
#
# Once Rishi stands, `rishi/bin/rishi run tools/f/fetch_toolchain.rish` does the same work with the
# tree's own asserts around it. Both call the same scan, so both hold the same promise: nothing is
# extracted until the downloaded bytes match a checksum pinned in this repository.
#
#   sh tools/f/fetch-toolchain.sh          # fetch, verify, extract
#   sh tools/f/fetch-toolchain.sh plan     # say what it would do; touch nothing
#
# Run from the repository root.

set -eu
exec sh tools/fixtures/fetch_toolchain_scan.sh "$@"
