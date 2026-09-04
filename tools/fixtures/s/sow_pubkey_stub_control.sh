#!/bin/sh
# sow_pubkey_stub_control.sh -- prove the stub both ways.
#
#   sh tools/fixtures/s/sow_pubkey_stub_control.sh
set -eu
here="$(cd "$(dirname "$0")" && pwd)"
stub="$here/sow_pubkey_stub.sh"

in='users.users.root.openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINotARealKey0000000000000000000000 alice@example"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQNotARealRsaBlob0000000000000000 bob@example"
];
# already a stub:
"ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY steward@example"
'

out=$(printf '%s\n' "$in" | sh "$stub")

printf '%s\n' "$out" | grep -q 'ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY alice@example' \
  || { echo "control: ed25519 blob must become the stub token" >&2; exit 1; }
printf '%s\n' "$out" | grep -q 'ssh-rsa REPLACE_WITH_YOUR_PUBLIC_KEY bob@example' \
  || { echo "control: rsa blob must become the stub token" >&2; exit 1; }
printf '%s\n' "$out" | grep -Eq 'ssh-(ed25519|rsa) AAAA' \
  && { echo "control: no AAAA blob may remain" >&2; exit 1; }
printf '%s\n' "$out" | grep -c 'REPLACE_WITH_YOUR_PUBLIC_KEY' | grep -qx 3 \
  || { echo "control: the already-stubbed line must pass through" >&2; exit 1; }

echo "control_cases=4"
echo "control_fail=0"
echo "control_verdict=ok"
