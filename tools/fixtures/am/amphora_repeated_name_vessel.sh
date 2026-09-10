#!/bin/sh
# tools/fixtures/am/amphora_repeated_name_vessel.sh -- craft a vessel that names one place twice.
#
# Every wall Amphora carries reads ONE cargo line at a time: the mark against the engine's two
# roots, the name against the containment and framing rules, the digest against the resin body it
# addresses. A listing that names `a.txt` on two lines, each carrying an honest digest for a
# different body, passes every one of them -- and the fault is the RELATION between the lines.
#
# Measured on metal `20260910` before a line changed: such a vessel answered
# `listing agrees count=2`, carried clean across a dock (`carry complete`), and restored through
# `restore resins proven count=2` and `restore files proven count=2` before refusing on the
# parent compare -- with the out-home already standing, holding ONE file named `a.txt` whose
# bytes were the other file's. Every digest was honest; the mapping was not.
#
# The craft opens the honest vessel's own seal, rewrites the SECOND cargo line's name to the
# first's, writes a matching listing, then seals and stamps again -- so the plant differs from the
# honest vessel in the name field alone.
#
# `--no-listing` writes the same repeat with NO `manifest ` lines in the head. That is the elder
# vessel shape -- poured before the Q11 listing, bytes frozen -- which `verify_manifest_agrees`
# answers as no claim rather than as a disagreement. It exists so the restore reader's own wall
# gets a leg of its own: the two walls stand in series, and the listing one refuses first, so
# without this shape nothing would tell a standing inner wall from a removed one.
#
#   sh tools/fixtures/am/amphora_repeated_name_vessel.sh <honest-vessel> <plant-vessel> [--no-listing]

set -e

honest="$1"
plant="$2"
listing="$3"
if [ -z "$honest" ] || [ -z "$plant" ]; then
  echo "amphora_repeated_name_vessel: name an honest vessel and a plant path" >&2
  exit 2
fi

pen=$(dirname "$plant")
plain="$pen/cargo-plain.txt"
amphora/bin/vessel-seal open "$honest" "$plain" >/dev/null 2>&1

first_name=$(sed -n '1p' "$plain" | cut -d' ' -f4-)
second_mark=$(sed -n '2p' "$plain" | cut -d' ' -f2)
second_digest=$(sed -n '2p' "$plain" | cut -d' ' -f3)
first_mark=$(sed -n '1p' "$plain" | cut -d' ' -f2)
first_digest=$(sed -n '1p' "$plain" | cut -d' ' -f3)

if [ -z "$first_name" ] || [ -z "$second_digest" ]; then
  echo "amphora_repeated_name_vessel: the honest vessel must carry two cargo lines" >&2
  exit 2
fi

{
  sed -n '/^# amphora vessel/,/^parent /p' "$honest"
  if [ "$listing" != "--no-listing" ]; then
    printf 'manifest %s %s %s\n' "$first_mark" "$first_digest" "$first_name"
    printf 'manifest %s %s %s\n' "$second_mark" "$second_digest" "$first_name"
  fi
  printf 'cargo %s %s %s\n' "$first_mark" "$first_digest" "$first_name"
  printf 'cargo %s %s %s\n' "$second_mark" "$second_digest" "$first_name"
} > "$plant"

amphora/bin/vessel-seal seal "$plant" >/dev/null 2>&1
amphora/bin/vessel-core sign "$plant" >/dev/null 2>&1

# Stated by the fixture that made it, so the witness reads a number rather than trusting a comment.
listed=2
if [ "$listing" = "--no-listing" ]; then listed=0; fi
printf 'repeated_name=%s cargo_lines=2 listing_lines=%s distinct_places=1\n' "$first_name" "$listed"
