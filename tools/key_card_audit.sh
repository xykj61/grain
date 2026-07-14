#!/bin/bash
# key_card_audit.sh — audit the key-card inputs and outputs.
#
# POSIX-seam helper for tools/make_key_card.rish (orchestration stays in Rish;
# the shell does the sourcing + ssh-keygen/gpg/magick reads that Rish routes to
# a seam by design — see context/TAME_GUIDANCE.md on the .sh/.rish boundary).
#
#   sh tools/key_card_audit.sh pre    # confirm each declared key fingerprint
#                                      # matches the real key on this host
#   sh tools/key_card_audit.sh post   # confirm the output PNGs exist + are valid
#
# Exit 0 on pass, non-zero on any mismatch, so Rish can `assert result.ok`.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="${2:-$REPO/tools/key-card.conf}"
MODE="${1:-pre}"

[ -f "$CONF" ] || { echo "no config at $CONF — copy tools/key-card.conf.example"; exit 1; }
# shellcheck source=/dev/null
. "$CONF"

IM="magick"; command -v magick >/dev/null 2>&1 || IM="convert"

if [ "$MODE" = "pre" ]; then
  ok=1
  if [ -n "${KEY_SSH_CODEBERG:-}" ]; then
    if ssh-keygen -lf "$KEY_SSH_CODEBERG" 2>/dev/null | grep -qF "$FP_SSH_CODEBERG"; then
      echo "audit: Codeberg SSH fingerprint matches real key ($KEY_SSH_CODEBERG)"
    else echo "audit: Codeberg SSH fingerprint MISMATCH"; ok=0; fi
  else echo "audit: Codeberg SSH key path not declared — skipped"; fi

  if [ -n "${KEY_SSH_GITHUB:-}" ]; then
    if ssh-keygen -lf "$KEY_SSH_GITHUB" 2>/dev/null | grep -qF "$FP_SSH_GITHUB"; then
      echo "audit: GitHub SSH fingerprint matches real key ($KEY_SSH_GITHUB)"
    else echo "audit: GitHub SSH fingerprint MISMATCH"; ok=0; fi
  else echo "audit: GitHub SSH key path not declared — skipped"; fi

  if [ -n "${GPG_EMAIL:-}" ]; then
    want="$(printf '%s' "$FP_OPENPGP" | tr -d ' ')"
    got="$(gpg --fingerprint "$GPG_EMAIL" 2>/dev/null | tr -d ' \n')"
    if printf '%s' "$got" | grep -qF "$want"; then
      echo "audit: OpenPGP fingerprint matches real key ($GPG_EMAIL)"
    else echo "audit: OpenPGP fingerprint MISMATCH"; ok=0; fi
  else echo "audit: GPG email not declared — skipped"; fi

  [ "$ok" -eq 1 ] || { echo "audit: FAILED — a declared fingerprint does not match its key"; exit 1; }
  echo "audit: pre-generation checks passed"
  exit 0
fi

if [ "$MODE" = "post" ]; then
  land="$(ls "$REPO"/keys_*_"${HANDLE}"_landscape.png 2>/dev/null | head -1 || true)"
  port="$(ls "$REPO"/keys_*_"${HANDLE}"_portrait.png 2>/dev/null | head -1 || true)"
  [ -n "$land" ] && [ -n "$port" ] || { echo "audit: output PNGs missing for handle $HANDLE"; exit 1; }
  "$IM" identify -format '%m %wx%h\n' "$land" | grep -qx 'PNG 1365x1024' || { echo "audit: landscape wrong shape"; exit 1; }
  "$IM" identify -format '%m %wx%h\n' "$port" | grep -qx 'PNG 1024x1365' || { echo "audit: portrait wrong shape"; exit 1; }
  echo "audit: post-generation PNGs valid — $(basename "$land") + $(basename "$port")"
  exit 0
fi

echo "usage: key_card_audit.sh pre|post [conf]"; exit 1
