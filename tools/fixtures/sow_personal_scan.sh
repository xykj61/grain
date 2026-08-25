#!/bin/sh
# sow_personal_scan.sh -- no `personal` path and no key material appears in the
# projected seed. Prints NO_PERSONAL or PERSONAL_BAD.
set -eu
bad=""
for p in $(grep -E '^personal ' template-manifest.bron | awk '{print $2}'); do
  [ -e "seed/$p" ] && bad="$bad $p"
done
# sub_exclude paths (whole or file-granular) must never appear in the seed either.
for p in $(grep -E '^sub_exclude ' template-manifest.bron | awk '{print $2}'); do
  [ -e "seed/$p" ] && bad="$bad $p"
done
keys=$(find seed \( -name 'keys_*' -o -name 'PUBKEYS.md' -o -name '*.pem' -o -name '*.key' -o -name '*.asc' -o -name '*.gpg' \) 2>/dev/null || true)
# Content guard -- embedded key material, whatever the file is named.
embedded=$(grep -rIlE 'ssh-(ed25519|rsa) AAAA|BEGIN (OPENSSH|PGP|RSA|EC) (PRIVATE|PUBLIC) KEY' seed 2>/dev/null || true)
if [ -z "$bad" ] && [ -z "$keys" ] && [ -z "$embedded" ]; then
  echo NO_PERSONAL
else
  echo PERSONAL_BAD
  [ -n "$bad" ] && echo "personal paths:$bad"
  [ -n "$keys" ] && echo "key files: $keys"
  [ -n "$embedded" ] && echo "embedded key material: $embedded"
fi
