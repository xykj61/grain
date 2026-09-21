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
# AAAA must be followed by a base64 character: pedagogical `AAAA...`
# ellipses in dated guides are placeholders, not keys.
#
# THIRD-PARTY API SECRETS, added 20260920 (REDS: a real OpenRouter key was pasted
# into chat and asked after in the same breath -- "make sure our publish seed
# scripts keep this type of information scrubbed"). None of the patterns above
# reach a bearer token: they are SSH/PGP key SHAPES, and a service API key is a
# different shape entirely. Each pattern below names a real provider's own
# published prefix, followed by a length floor long enough that no illustrative
# placeholder (`sk-or-v1-...`, three literal dots) can match -- a placeholder
# stays clean by construction, a real key does not. Together AI's `tgp_v1_`
# prefix joined the same day, widened the moment a real Together key was
# confirmed live (`tgp_v1_...`, 50 characters total) -- the same reflex as the
# original OpenRouter widening, applied on sight rather than waited on.
API_SECRETS='sk-or-v1-[A-Fa-f0-9]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|sk-proj-[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9]{32,}|tgp_v1_[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|gho_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{10,}'
embedded=$(grep -rIlE "ssh-(ed25519|rsa) AAAA[A-Za-z0-9+/]|BEGIN (OPENSSH|PGP|RSA|EC) (PRIVATE|PUBLIC) KEY|$API_SECRETS" seed 2>/dev/null || true)
if [ -z "$bad" ] && [ -z "$keys" ] && [ -z "$embedded" ]; then
  echo NO_PERSONAL
else
  echo PERSONAL_BAD
  [ -n "$bad" ] && echo "personal paths:$bad"
  [ -n "$keys" ] && echo "key files: $keys"
  [ -n "$embedded" ] && echo "embedded key material: $embedded"
fi
