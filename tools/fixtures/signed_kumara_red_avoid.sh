#!/usr/bin/env bash
# red-avoid scan for signed-Kumara guest — crypto_eddsa_ absent; crypto_ed25519_check ≥ 2
set -euo pipefail
g="${1:?guest tree}"
if [ ! -d "$g" ]; then
  echo HOLD
  exit 0
fi
if grep -R -n --include='*.c' --include='*.h' -F 'crypto_eddsa_' "$g" >/dev/null 2>&1; then
  echo BAD_EDDSA
  exit 0
fi
n="$(grep -R -n --include='*.c' --include='*.h' -F 'crypto_ed25519_check' "$g" 2>/dev/null | wc -l | tr -d ' ')"
if [ "${n}" -ge 2 ]; then
  echo OK
else
  echo "NEED_PAIR:${n}"
fi
