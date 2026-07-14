#!/usr/bin/env bash
# pond_exit_bron_master_seal.sh — exit bron counts only when master-signed.
#
# Claude 20260712.213600: presence alone is not enough — an agent inside the
# jail could write and sandbox-sign the sentinel. The season flip is
# custody-grade: detached pond-supersede-exit.bron.asc must verify against
# master fingerprint 0646 2132… alone, in a keyring that holds only the
# master's public form (context/keys/gpg_signing_06462132.pub.asc).
#
# Modes:
#   --policy         master pubkey present · host gpg available (default)
#   --season-closed  bron and .asc absent · policy ready (scorecard sleep)
#   --require        bron + .asc present · VALIDSIG from master fpr only
#
# Shared by tools/cursor-jail.sh · tools/launch-zed.sh · scorecard witness.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MASTER_FPR="06462132D3E63B834F976E03A81D720B9235FA7A"
MASTER_PUB="${REPO_ROOT}/context/keys/gpg_signing_06462132.pub.asc"
EXIT_BRON="${REPO_ROOT}/bron-resins/pond-supersede-exit.bron"
EXIT_ASC="${EXIT_BRON}.asc"

mode="${1:---policy}"

policy_ready() {
  if [ ! -f "$MASTER_PUB" ]; then
    echo "REFUSE: missing master public key ${MASTER_PUB}" >&2
    return 1
  fi
  if ! command -v gpg >/dev/null 2>&1; then
    echo "REFUSE: host gpg not on PATH — master-seal verify needs it" >&2
    return 1
  fi
  echo "OK: master-seal policy ready · fpr ${MASTER_FPR} · pubkey ${MASTER_PUB}"
}

season_closed() {
  if [ -e "$EXIT_BRON" ] || [ -e "$EXIT_ASC" ]; then
    echo "REFUSE: ${EXIT_BRON} or .asc present while season claims closed — remove or claim exit properly" >&2
    return 1
  fi
  policy_ready
  echo "OK: season closed measured — exit bron and .asc absent"
}

require_master_seal() {
  if [ ! -s "$EXIT_BRON" ]; then
    echo "REFUSE: ENCLOSURE=pond while ${EXIT_BRON} is absent — season still closed." >&2
    return 1
  fi
  if [ ! -s "$EXIT_ASC" ]; then
    echo "REFUSE: ${EXIT_ASC} absent — exit bron counts only when master-signed." >&2
    return 1
  fi
  policy_ready >/dev/null

  local tmp status
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/pond-master-seal.XXXXXX")"
  # shellcheck disable=SC2064
  trap "rm -rf '${tmp}'" EXIT
  export GNUPGHOME="${tmp}"
  chmod 700 "${tmp}"
  gpg --batch --quiet --import "${MASTER_PUB}" >/dev/null 2>&1

  # status-fd 1: VALIDSIG carries the full fingerprint. trust-model always
  # so a lone pubkey keyring still reports cryptographic validity.
  status="$(
    gpg --batch --trust-model always --status-fd 1 \
      --verify "${EXIT_ASC}" "${EXIT_BRON}" 2>/dev/null || true
  )"
  if ! printf '%s\n' "${status}" | grep -F "VALIDSIG ${MASTER_FPR}" >/dev/null; then
    echo "REFUSE: ${EXIT_ASC} does not carry a valid master signature (${MASTER_FPR})." >&2
    echo "  Only the cold master key opens the season — sandbox signatures do not count." >&2
    return 1
  fi
  echo "OK: exit bron master-sealed · VALIDSIG ${MASTER_FPR}"
}

case "${mode}" in
  --policy) policy_ready ;;
  --season-closed) season_closed ;;
  --require) require_master_seal ;;
  *)
    echo "usage: $0 --policy | --season-closed | --require" >&2
    exit 2
    ;;
esac
