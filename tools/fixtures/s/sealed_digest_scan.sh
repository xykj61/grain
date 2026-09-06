#!/bin/sh
# sealed_digest_scan.sh -- a digest this tree records about its own bytes is a claim, and a claim
# nothing reads is prose.
#
# WHY. This tree seals its own artifacts in two algorithms and for two different reasons, and both
# are right. SHA3 is the tree's OWN hash -- the waymark registry is sealed SHA3-512, computed by
# `crypto/sha3_digest.rye` over authored Keccak, so no external binary is required to check it
# (REDS %112, %116). SHA-256 stays wherever an OUTSIDE party fixes the algorithm: a protocol that
# specifies it (Bitcoin, BIP39, base58check), a vendor publishing a checksum for a download, or a
# record deliberately checkable with the `sha256sum` that ships in coreutils, which is the property
# `mycelium/warrant_true.rye` names as *two tools, one answer*.
#
# So the open question is not WHICH hash. It is whether a recorded digest is ever compared against
# the bytes it claims to describe. Measured `20260906`: a 64-hex digest recorded in
# `tools/c/chatgpt-mind-rishi-adaptation.md` pins a file byte for byte, and the only place that
# digest appears is the sentence recording it -- so the pin could go false and nothing would say.
#
#   sh tools/fixtures/s/sealed_digest_scan.sh          # counts
#   SEALED_ROOT=<dir> sh tools/fixtures/s/sealed_digest_scan.sh   # the control's pen door
#   sh tools/fixtures/s/sealed_digest_scan.sh list     # one line per unread seal
#
# THE READING. A living tracked document that records a full-length digest (64 hex for SHA-256, 128
# for SHA3-512) AND names a path in the same paragraph is making a checkable claim. If no file under
# `tools/` mentions that digest, nothing checks it.
#
# WHAT IS NOT COUNTED, and why each is excluded rather than waived:
#   - dated testimony, and `date/`, `archive/`, `yonder/` rooms -- a log records what was true then
#   - `gratitude/`, `vendor/`, `external-research/` -- other people's numbers
#   - a public KEY or an address, which is not a digest of our bytes (`kumara/`, `surf/fixtures/`)
#   - a digest whose own document is the guard that reads it
#   - a digest ATTRIBUTED TO AN OUTSIDE PUBLISHER on its own line. The first run of this scan
#     reported one unread seal and it was GrapheneOS's published Pixel boot hash, checked once by a
#     hand against a physical device -- a number this tree can quote and can never recompute. A
#     guard demanding a checker for someone else's published value would be asking for a device in
#     a witness, which is why the attribution is read rather than the digest.
#
# BOUNDS: living tracked `.md`, `.kyri` and `.bron`; the first 400 such documents; one grep per
# digest found, capped at 64 digests, since a tree with more unread seals than that has a different
# problem than this scan can name.
set -eu

# ROOTED FROM THIS SCRIPT, with a named door for a pen. Resolving from `$0` is what keeps the
# reading independent of where a caller stands; without the door, a control could only ever
# measure the real tree and would prove nothing (the sibling lesson of `FLEET_HOME` and
# `SOW_SEED`).
root=${SEALED_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_DOCS=400
MAX_DIGESTS=64

work=$(mktemp -d "${TMPDIR:-/tmp}/sealed-digest.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files '*.md' '*.kyri' '*.bron' \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | grep -vE '^(gratitude|vendor|external-research|seed)/' \
  | grep -vE '^(kumara|surf/fixtures)/' \
  | head -"$MAX_DOCS" > "$work/docs.txt"

# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
if [ ! -s "$work/docs.txt" ]; then
  echo "refused: no living documents found -- the corpus every count below reads is empty" >&2
  exit 2
fi

: > "$work/seals.txt"
while IFS= read -r doc; do
  [ -f "$doc" ] || continue
  # a digest is only a SEAL when the same line names a path this tree writes
  grep -oE '\b[0-9a-f]{64}\b|\b[0-9a-f]{128}\b' "$doc" 2>/dev/null | while IFS= read -r d; do
    _line=$(grep -F "$d" "$doc" | head -1)
    # an outside publisher's number is quoted, never sealed by us
    case "$_line" in
      *published*|*publishes*|*upstream*|*"'s own"*|*vendor*) continue ;;
    esac
    if printf '%s' "$_line" | grep -qE '\.(rye|rish|sh|md|kyri|bron|brix|txt|glow|zip|img)\b|byte for byte|SHA-?256|SHA3'; then
      printf '%s\t%s\n' "$doc" "$d" >> "$work/seals.txt"
    fi
  done
done < "$work/docs.txt"

seals=$(sort -u "$work/seals.txt" | head -"$MAX_DIGESTS" | wc -l | tr -d ' ')
unread=0
: > "$work/unread.txt"
sort -u "$work/seals.txt" | head -"$MAX_DIGESTS" | while IFS="$(printf '\t')" read -r doc d; do
  [ -n "$d" ] || continue
  # read by something under tools/ that is NOT the recording document itself
  if git grep -lF "$d" -- 'tools/*' 2>/dev/null | grep -vxF "$doc" | grep -q .; then
    :
  else
    printf '%s\t%s\n' "$doc" "$d" >> "$work/unread.txt"
  fi
done
[ -f "$work/unread.txt" ] && unread=$(wc -l < "$work/unread.txt" | tr -d ' ')

if [ "$MODE" = list ]; then
  while IFS="$(printf '\t')" read -r doc d; do
    [ -n "$d" ] || continue
    printf 'unread: %s seals %.16s... and no guard reads it\n' "$doc" "$d"
  done < "$work/unread.txt"
fi

echo "seals=$seals"
echo "unread=$unread"
