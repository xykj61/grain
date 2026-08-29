#!/bin/sh
# tools/fixtures/c/constel_naming_scan.sh -- the Constel test-network naming law, read both ways.
#
#   sh tools/fixtures/c/constel_naming_scan.sh <names-file>
#
# A Constel name is a fake dev-network constellation stood up inside the jailed pier. Its one
# load-bearing promise is that it can NEVER parse as a real @p, so a copied dev command can never
# address a stranger's ship. The tree holds TWO independent proofs of that promise, and this scan
# reports both, per name.
#
#   digit    -- a digit anywhere. A real @p body after its ~ is lowercase letters and hyphens only,
#               drawn from a fixed 256-syllable table holding no digits, so a digit is proof.
#               The elder proof, seated 20260813.
#   vowel    -- no vowel anywhere. Every one of the 512 real syllables carries exactly one vowel and
#               `y` never appears in the table, so a vowel-free name can never be assembled from
#               them. The seated proof, 20260814, and the one constel/name.rye check_ship enforces.
#
# Either proof alone makes a name provably non-@p, so `verdict` gates their UNION -- a name safe by
# neither is the only unsafe name, and that gate never weakens. The two predicates admitting
# different sets is a second, quieter reading: `split` counts names one proof admits and the other
# refuses -- and it fires in BOTH directions, so `split_seated_refuses` counts digit-safe names the
# seated law turns away and `split_digit_absent` counts seated-lawful names carrying no digit. Those
# numbers are the tree's own drift between rooms, reported rather than gated, because closing the
# first means redrawing names ten pond/apps modules already seat.
#
# `admits_seated` mirrors constel/name.rye's check_constellation exactly -- bounds, alphabet,
# vowel-free, hyphen segments -- and `fault` carries that module's own NameError name, so the shell
# reading and the Rye reading speak one vocabulary.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md -- the scan carries the
# verdict; a caller checks status before trusting the lines.
#
# Law: active-designing/20260814-fill-constel-naming-law.md (seated, vowel-free)
#      active-designing/date/20260813/20260813-022222_constel-test-network-naming-law.md (elder, digit)
# Module: constel/name.rye -- the predicate this scan mirrors.
set -eu

if [ "$#" -ne 1 ]; then
  echo "detail: usage -- constel_naming_scan.sh <names-file>" 1>&2
  exit 2
fi
names=$1
if [ ! -f "$names" ]; then
  echo "detail: absent names file ($names)" 1>&2
  exit 2
fi

# The law's own bounds, spelled from constel/name.rye so a reader can compare them line for line.
max_ship_len=12            # name.rye max_ship_len
max_ships=8                # name.rye max_ships
max_constellation_bytes=64 # name.rye max_constellation_bytes
max_names=256              # this scan's own bound on how many lines it will read

# Mirror check_constellation: print the NameError a Rye caller would receive, or nothing when admitted.
seated_fault() {
  whole=$1
  [ -n "$whole" ] || { echo EmptyName; return; }
  [ "${#whole}" -le "$max_constellation_bytes" ] || { echo NameTooLong; return; }
  ships=0
  # Split on hyphens the way check_constellation walks segments.
  rest=$whole
  while :; do
    # check_constellation walks i to whole.len INCLUSIVE, so a trailing hyphen yields one more --
    # empty -- segment. `more` carries that final turn; without it "xnkg-" would admit silently.
    case $rest in
      *-*) seg=${rest%%-*}; rest=${rest#*-}; more=yes ;;
      *)   seg=$rest; rest=; more=no ;;
    esac
    [ -n "$seg" ] || { echo BadSegment; return; }
    [ "${#seg}" -le "$max_ship_len" ] || { echo NameTooLong; return; }
    # A vowel is refused by its own name, ahead of the alphabet, exactly as check_ship orders it.
    case $seg in
      *[aeiou]*) echo VowelPresent; return ;;
    esac
    case $seg in
      *[!bcdfghjklmnpqrstvwxyz0-9]*) echo BadCharacter; return ;;
    esac
    ships=$((ships + 1))
    [ "$ships" -le "$max_ships" ] || { echo NameTooLong; return; }
    [ "$more" = yes ] || break
  done
  echo ""
}

count=0
seated_admitted=0
digit_bearing=0
never_a_ship=0
split=0
split_seated_refuses=0
split_digit_absent=0
first_unsafe=""

while IFS= read -r line; do
  case "$line" in
    ''|\#*) continue ;;
  esac
  name=$line
  count=$((count + 1))
  if [ "$count" -gt "$max_names" ]; then
    echo "detail: names file past the scan bound ($max_names)" 1>&2
    echo "verdict=unbounded"
    exit 1
  fi

  if printf '%s' "$name" | grep -q '[0-9]'; then digit=yes; else digit=no; fi
  [ "$digit" = yes ] && digit_bearing=$((digit_bearing + 1))

  fault=$(seated_fault "$name")
  if [ -z "$fault" ]; then
    seated=yes
    seated_admitted=$((seated_admitted + 1))
    echo "name=$name digit=$digit admits_seated=$seated"
  else
    seated=no
    echo "name=$name digit=$digit admits_seated=$seated fault=$fault"
  fi

  # The union: either proof makes the name provably never a real @p.
  if [ "$digit" = yes ] || [ "$seated" = yes ]; then
    never_a_ship=$((never_a_ship + 1))
    # Safe, yet the two proofs disagree about admitting it -- the drift between rooms.
    if [ "$digit" != "$seated" ]; then
      split=$((split + 1))
      if [ "$seated" = no ]; then
        split_seated_refuses=$((split_seated_refuses + 1))
      else
        split_digit_absent=$((split_digit_absent + 1))
      fi
      echo "detail: split $name -- digit=$digit admits_seated=$seated"
    fi
  else
    if [ -z "$first_unsafe" ]; then first_unsafe=$name; fi
  fi
done < "$names"

echo "names=$count"
echo "seated_admitted=$seated_admitted"
echo "digit_bearing=$digit_bearing"
echo "never_a_ship=$never_a_ship"
echo "split=$split"
echo "split_seated_refuses=$split_seated_refuses"
echo "split_digit_absent=$split_digit_absent"
if [ -n "$first_unsafe" ]; then
  echo "verdict=unsafe first=$first_unsafe"
  exit 1
fi
echo "verdict=ok"
