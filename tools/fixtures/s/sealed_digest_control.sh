#!/bin/sh
# sealed_digest_control.sh -- the sealed-digest census proven on planted documents in a pen.
#
# Every refusal is planted and then LIFTED, because a gate proven only in the passing direction
# cannot be told from a gate that never fires.
#
#   sh tools/fixtures/s/sealed_digest_control.sh
#
# Prints `pass=N fail=N`. Bounded: 9 cases, one pen, one throwaway git repository.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan="$root/tools/fixtures/s/sealed_digest_scan.sh"
pen=${TMPDIR:-/tmp}/sealed-digest-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools" "$pen/context"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

D1=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
D2=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
D3=cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cd "$pen"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

ask() { SEALED_ROOT="$pen" sh "$scan" "${1:-count}" 2>&1; }

# A sealed digest nothing reads is the fault this census exists to name.
printf 'The elder module.rye is retained byte for byte. Its SHA-256 is `%s`.\n' "$D1" > context/sealed.md
git add -A >/dev/null; git commit -qm seed
out=$(ask list)
check "an unread seal is counted"        yes "$(has "$out" 'unread=1')"
check "and it is named"                  yes "$(has "$out" 'context/sealed.md seals')"
check "the seal itself is counted"       yes "$(has "$out" 'seals=1')"

# A guard that reads it lifts the fault.
mkdir -p tools/s
printf '#!/bin/sh\n# checks %s\n' "$D1" > tools/s/sealed_check.sh
git add -A >/dev/null; git commit -qm guard
out=$(ask)
check "a guard reading it clears the count" yes "$(has "$out" 'unread=0')"
check "and the seal still counts"           yes "$(has "$out" 'seals=1')"

# An outside publisher's quoted number is read past rather than demanded of a witness.
printf 'Matched against GrapheneOS published value `%s` for the device.\n' "$D2" > context/published.md
git add -A >/dev/null; git commit -qm published
out=$(ask)
check "a publisher's number is not a seal"  yes "$(has "$out" 'seals=1')"

# A digest with no path and no seal language beside it is a number, not a claim.
printf 'A key fingerprint stands here: %s\n' "$D3" > context/bare.md
git add -A >/dev/null; git commit -qm bare
out=$(ask)
check "a bare digest is not a seal"         yes "$(has "$out" 'seals=1')"

# Dated testimony records what was true then and is never gated.
mkdir -p context/date/20260101
printf 'The elder thing.rye SHA-256 is `%s`.\n' "$D3" > context/date/20260101/20260101-120000_note.md
git add -A >/dev/null; git commit -qm dated
out=$(ask)
check "dated testimony is read past"        yes "$(has "$out" 'unread=0')"

# A corpus of zero refuses rather than reporting clean (REDS %170).
rm -rf context tools
git add -A >/dev/null; git commit -qm empty
if SEALED_ROOT="$pen" sh "$scan" >/dev/null 2>&1; then
  check "an empty corpus refuses" refused accepted
else
  check "an empty corpus refuses" refused refused
fi

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
