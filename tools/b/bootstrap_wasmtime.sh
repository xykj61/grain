#!/bin/sh
# bootstrap_wasmtime.sh — seat wasmtime 31.0.0 for the receipt-verify seam.
#
# Resolve order: PATH first, then tools/.cache/wasmtime/wasmtime (gitignored pin).
# Network only when both are empty. Witnesses never call this for the wire.
#
# Digest fixture: tools/fixtures/wasmtime_31_0_0.sha256 — sha256 of the installed
# binary. First seating (fetch or first pin verify with no fixture) records TOFU
# loudly; later seatings assert.
#
#   sh tools/b/bootstrap_wasmtime.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

PIN_DIR="tools/.cache/wasmtime"
PIN="${PIN_DIR}/wasmtime"
FIXTURE="tools/fixtures/wasmtime_31_0_0.sha256"
VERSION="31.0.0"
BASE_URL="https://github.com/bytecodealliance/wasmtime/releases/download/v${VERSION}"

resolve() {
  if command -v wasmtime >/dev/null 2>&1; then
    command -v wasmtime
    return 0
  fi
  if [ -x "$PIN" ]; then
    printf '%s\n' "$PIN"
    return 0
  fi
  return 1
}

host_triple() {
  arch=$(uname -m)
  case "$(uname -s)" in
    Linux)
      case "$arch" in
        x86_64) printf 'x86_64-linux\n' ;;
        aarch64|arm64) printf 'aarch64-linux\n' ;;
        *) echo "bootstrap_wasmtime: unsupported Linux arch: ${arch}" >&2; exit 1 ;;
      esac
      ;;
    Darwin)
      case "$arch" in
        x86_64) printf 'x86_64-macos\n' ;;
        arm64|aarch64) printf 'aarch64-macos\n' ;;
        *) echo "bootstrap_wasmtime: unsupported macOS arch: ${arch}" >&2; exit 1 ;;
      esac
      ;;
    *)
      echo "bootstrap_wasmtime: unsupported OS: $(uname -s)" >&2
      exit 1
      ;;
  esac
}

digest_of() {
  sha256sum "$1" | awk '{print $1}'
}

assert_or_record() {
  path=$1
  got=$(digest_of "$path")
  if [ -f "$FIXTURE" ]; then
    want=$(tr -d '[:space:]' <"$FIXTURE")
    if [ "$got" != "$want" ]; then
      echo "bootstrap_wasmtime: RED digest mismatch for ${path}" >&2
      echo "  want: ${want}" >&2
      echo "  got:  ${got}" >&2
      exit 1
    fi
    echo "bootstrap_wasmtime: digest OK (${FIXTURE})"
  else
    mkdir -p "$(dirname "$FIXTURE")"
    printf '%s\n' "$got" >"$FIXTURE"
    echo "bootstrap_wasmtime: TOFU — recorded first digest to ${FIXTURE}"
    echo "bootstrap_wasmtime: digest ${got}"
  fi
}

print_seat() {
  path=$1
  ver=$("$path" --version 2>&1 | head -1)
  echo "bootstrap_wasmtime: resolved ${path}"
  echo "bootstrap_wasmtime: ${ver}"
}

if resolved=$(resolve); then
  assert_or_record "$resolved"
  print_seat "$resolved"
  exit 0
fi

triple=$(host_triple)
asset="wasmtime-v${VERSION}-${triple}.tar.xz"
url="${BASE_URL}/${asset}"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/bootstrap-wasmtime.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

echo "bootstrap_wasmtime: fetching ${url}"
curl -fsSL -o "${tmp}/${asset}" "$url"

mkdir -p "$PIN_DIR"
tar -xJf "${tmp}/${asset}" -C "$tmp"
# Release layout: wasmtime-v31.0.0-<triple>/wasmtime
extracted=$(find "$tmp" -type f -name wasmtime -perm -111 | head -1)
if [ -z "$extracted" ]; then
  echo "bootstrap_wasmtime: RED — no wasmtime binary inside ${asset}" >&2
  exit 1
fi
cp "$extracted" "$PIN"
chmod 755 "$PIN"
assert_or_record "$PIN"
print_seat "$PIN"
