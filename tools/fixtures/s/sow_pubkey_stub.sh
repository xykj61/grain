#!/bin/sh
# sow_pubkey_stub.sh -- replace real SSH public-key blobs with a placeholder.
#
# The seed content guard (sow_personal_scan.sh) refuses a real
# ssh public-key blob, so a tracked NixOS config that carries one used
# to be withheld whole. This pass keeps the file and swaps the blob for
# REPLACE_WITH_YOUR_PUBLIC_KEY, a token that does not match that guard.
# The match uses [[:space:]] so this file itself never contains the
# guarded `ssh-ed25519` + space + `AAAA` byte run. Armor blocks
# (BEGIN OPENSSH / PGP / RSA / EC KEY) stay a withhold in sow_project.sh
# -- this helper is public ssh lines only.
#
# Reads stdin, writes stdout. No file arguments.
set -eu

sed -E \
  -e 's/ssh-ed25519[[:space:]]AAAA[A-Za-z0-9+/=]+/ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY/g' \
  -e 's/ssh-rsa[[:space:]]AAAA[A-Za-z0-9+/=]+/ssh-rsa REPLACE_WITH_YOUR_PUBLIC_KEY/g'
