#!/bin/sh
# sow_pubkey_stub.sh -- replace real SSH public-key blobs with a placeholder.
#
# The seed content guard (sow_personal_scan.sh) refuses any
# `ssh-(ed25519|rsa) AAAA` line, so a tracked NixOS config that carries a real
# authorizedKeys blob used to be withheld whole. This pass keeps the file and
# swaps the blob for REPLACE_WITH_YOUR_PUBLIC_KEY, a token that does not match
# that guard. Armor blocks (BEGIN OPENSSH / PGP / RSA / EC KEY) stay a withhold
# in sow_project.sh -- this helper is public ssh lines only.
#
# Reads stdin, writes stdout. No file arguments.
set -eu

sed -E \
  -e 's/ssh-ed25519 AAAA[A-Za-z0-9+/=]+/ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY/g' \
  -e 's/ssh-rsa AAAA[A-Za-z0-9+/=]+/ssh-rsa REPLACE_WITH_YOUR_PUBLIC_KEY/g'
