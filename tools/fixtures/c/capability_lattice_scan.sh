#!/bin/sh
# tools/fixtures/c/capability_lattice_scan.sh -- is Caravan's privilege a line, or a lattice?
#
# WHAT THIS ANSWERS. Row 2 of active-designing/20260910-060204_the-bounded-torus-moonshots.md
# proposes reading the process graph in polar coordinates: radius is privilege -- 0 supervisor,
# 1 Pond, 2 desk, 3 wire -- angle is capability class, and a supervisor refuses any hop past a
# declared maximum. It rests on one assumption, written in its own words: "Privilege in Caravan is
# already ordered." Its falsifier reads -- a real supervised process needs a privilege sitting
# between two rings, which would show privilege is a lattice rather than a line. That falsifier
# names a measurement nobody had taken, and this takes it against the seated module rather than
# against a hypothetical process.
#
# WHERE THE ANSWER LIVES. caravan/capabilities.rye declares privilege as a bit per right --
# `pub const right_read: u8 = 1 << 0;` and its siblings -- and checks it in one function,
# `Rights.contains(have, need)`, returning `(have & need) == need`. That is subset containment, so
# the order on privilege is the subset order on a set of bits: the Boolean lattice, whose height is
# the number of rights and whose width is the widest antichain. This scan derives the bit width
# from those declarations rather than spelling it, so a sixth right lands in the reading on the lap
# it is written.
#
# THE TWO POPULATIONS, AND WHY BOTH. The FULL lattice over n rights is what the model must admit in
# principle. The SEATED masks are the composite rights sets this tree actually constructs today,
# read by grep over caravan/*.rye. A finding that holds only in principle is a forecast; one that
# holds over seated masks is an observation, so both are printed and the seated reading is the one
# the paper leans on.
#
# THE COMPARISON, spelled once. For an ordered pair of masks (a, b), the LATTICE admits the
# conferral a -> b when b is a subset of a -- which is exactly what `Rights.contains(a, b)` answers,
# and exactly the ceiling test `confer_word` applies at caravan/confer.rye. A RADIUS-only checker,
# holding privilege on a line, admits a -> b when b's radius is no greater than a's; the only
# rank function a graded lattice offers is the popcount, so that is the radius read here. The two
# disagree in one direction only, and naming which direction is the whole point: an over-admission
# is a supervisor granting a right nobody conferred.
#
# WHAT IT PRINTS. The derived rights and the lattice size; the seated mask census; the legal-hop
# counts under each model over both populations; the over- and under-admission counts; the widest
# antichain; and a verdict word, `lattice` or `line`, never a blank.
#
# WHAT IT DOES NOT REACH. Whether a supervisor SHOULD hold privilege on a line. This reads what the
# seated module means by privilege and prices one proposed replacement against it; the design
# question stays a design question.
#
# Run from anywhere -- the root is found by upward walk:
#   sh tools/fixtures/c/capability_lattice_scan.sh [--list]

set -eu

_cl_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_cl_steps=0
while [ ! -d "$_cl_root/rishi/bin" ] || [ ! -d "$_cl_root/tools/fixtures" ]; do
  _cl_steps=$((_cl_steps + 1))
  if [ "$_cl_steps" -gt 8 ] || [ "$_cl_root" = "/" ] || [ -z "$_cl_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _cl_root=$(dirname "$_cl_root")
done

# BOUNDS, each named and checked at the edge (TAME). The rights bound is DERIVED rather than
# typed: a right is one bit of the mask, and the mask's own integer type is declared beside it, so
# `u8` caps the rights at 8 and a wider type raises the cap by saying so in Rye. A ninth right
# cannot exist under `u8` whatever this file says, which is why the bound is read rather than
# written. The FULL-lattice figures are closed forms rather than a walk, so the run cost does not
# rise with the mask width at all; only the seated masks are enumerated, and `max_seated` bounds
# that. `max_mask_bits` is the ceiling on that derived number, kept at the widest integer a mask
# would plausibly take, so a declaration naming something wider refuses by name rather than
# producing a figure nobody checked.
max_mask_bits=64
max_seated=256
max_room_files=512

want_list=no
while [ $# -gt 0 ]; do
  case "$1" in
    --list) want_list=yes; shift ;;
    *) echo "refused: unknown argument '$1' -- takes --list" >&2; exit 2 ;;
  esac
done

cd "$_cl_root"

decl="${CAPABILITY_DECL:-caravan/capabilities.rye}"
room="${CAPABILITY_ROOM:-caravan}"

[ -f "$decl" ] || { echo "refused: no capability declaration at $decl" >&2; exit 1; }
[ -d "$room" ] || { echo "refused: no caravan room at $room" >&2; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

# --- the rights, derived from their own declarations ---------------------------------------------
# `pub const right_read: u8 = 1 << 0;` -- name, shift, and mask type, one per line, shift order
# kept. The type is captured because it is what bounds the run, and a room mixing two mask types
# has no single lattice to read, so that refuses by name rather than picking one.
sed -n 's/^[[:space:]]*pub const \(right_[a-z0-9_]*\):[[:space:]]*\(u[0-9][0-9]*\)[[:space:]]*=[[:space:]]*1[[:space:]]*<<[[:space:]]*\([0-9][0-9]*\).*$/\1 \3 \2/p' \
  "$decl" | sort -k2,2n > "$pen/rights.txt"

rights=$(wc -l < "$pen/rights.txt" | tr -d ' ')
[ "$rights" -ge 1 ] || { echo "refused: no right_ bit declarations read from $decl" >&2; exit 1; }

mask_types=$(awk '{ print $3 }' "$pen/rights.txt" | sort -u | wc -l | tr -d ' ')
[ "$mask_types" -eq 1 ] \
  || { echo "refused: $mask_types mask types among the right_ declarations -- one lattice wants one type" >&2; exit 1; }
mask_type=$(awk 'NR == 1 { print $3 }' "$pen/rights.txt")
mask_bits=${mask_type#u}
case "$mask_bits" in ''|*[!0-9]*) echo "refused: unreadable mask type '$mask_type'" >&2; exit 1 ;; esac
[ "$mask_bits" -ge 1 ] && [ "$mask_bits" -le "$max_mask_bits" ] \
  || { echo "refused: mask type $mask_type holds $mask_bits bits, outside 1..$max_mask_bits" >&2; exit 1; }
max_rights=$mask_bits
[ "$rights" -le "$max_rights" ] \
  || { echo "refused: $rights rights declared, past the $max_rights the mask type $mask_type holds" >&2; exit 1; }

# --- the seated masks, read from the room that constructs them -----------------------------------
# A composite is a run of right_ names joined by `|`, with or without the module qualifier. A single
# name is a mask too, and is counted: a one-bit mask is a real privilege a dependent may hold.
#
# THE DECLARATION LINES ARE READ PAST, and the reason is worth one sentence. `pub const right_net:
# u8 = 1 << 3;` mentions a right without CONSTRUCTING a mask from it, so counting it would seat a
# privilege the room never builds. It drops LINES rather than files, because the declaration file
# constructs real masks too -- `caravan/capabilities.rye:284` checks `right_net` in an assert.
#
# MEASURED, THE FILTER CHANGES NOTHING HERE, and saying so is the honest form. Every right Caravan
# declares is also used as a mask somewhere in the room today, so the seated count reads 10 with the
# filter and 10 without it. What the filter buys is a future one: a right declared and left unused
# would otherwise be seated as a privilege nobody built, and a lattice figure would move on a line
# that constructed nothing. The control proves it on a pen where the two readings DO part.
room_files=$(find "$room" -maxdepth 1 -name '*.rye' | wc -l | tr -d ' ')
[ "$room_files" -le "$max_room_files" ] \
  || { echo "refused: $room_files files in $room, past the bound of $max_room_files" >&2; exit 1; }

find "$room" -maxdepth 1 -name '*.rye' -print0 2>/dev/null \
  | xargs -0 grep -hv -E '^[[:space:]]*pub const right_[a-z0-9_]*:[[:space:]]*u[0-9]+[[:space:]]*=' 2>/dev/null \
  | grep -oE "(capabilities\.)?right_[a-z0-9_]+( *\| *(capabilities\.)?right_[a-z0-9_]+)*" \
  | sed 's/capabilities\.//g; s/ //g' \
  | sort -u > "$pen/seated_raw.txt" || true

# --- the reading ---------------------------------------------------------------------------------
awk -v want_list="$want_list" -v rights_file="$pen/rights.txt" \
    -v mask_type="$mask_type" -v max_rights="$max_rights" '
function bAND(x, y,   r, p) {
  r = 0; p = 1
  while (x > 0 || y > 0) {
    if ((x % 2) == 1 && (y % 2) == 1) r += p
    x = int(x / 2); y = int(y / 2); p *= 2
  }
  return r
}
function popcount(x,   c) { c = 0; while (x > 0) { c += x % 2; x = int(x / 2) } return c }
BEGIN {
  # the declared bits, by name
  n = 0
  while ((getline line < rights_file) > 0) {
    split(line, f, " ")
    bit[f[1]] = 2 ^ (f[2] + 0)
    order[++n] = f[1]
  }
  close(rights_file)
  lattice = 2 ^ n
}
# every seated composite, resolved to a mask value
{
  cnt = split($0, parts, "|")
  m = 0; known = 1
  for (i = 1; i <= cnt; i++) {
    if (parts[i] in bit) m += bit[parts[i]]        # a repeated bit would double, so add once
    else known = 0
  }
  if (!known) { unknown++; next }
  if (!(m in seen)) { seen[m] = 1; seated[++s] = m; label[m] = $0 }
}
END {
  printf "mask_type=%s\n", mask_type
  printf "rights_declared=%d\n", n
  printf "rights_headroom=%d\n", max_rights - n
  for (i = 1; i <= n; i++) printf "right %s bit=%d\n", order[i], bit[order[i]]
  printf "lattice_size=%d\n", lattice
  printf "masks_seated=%d\n", s
  printf "names_unresolved=%d\n", unknown + 0

  # --- the full lattice, by closed form ---------------------------------------------------------
  # Counting a 4^n walk is unnecessary: each figure has an exact expression in n, so the reading
  # costs n^2 rather than 4^n and stays available at any mask width. Every one is checked against
  # a brute-force enumeration in the control, which is where a closed form earns belief.
  #   ordered pairs, a != b                    4^n - 2^n
  #   b subset of a, a != b                    3^n - 2^n     (each bit: in both, in a only, in
  #                                                            neither -- three choices)
  #   incomparable, ordered                    4^n - 2*3^n + 2^n
  #   radius-legal, a != b                     sum over i >= j of C(n,i)*C(n,j), less the 2^n
  #                                            diagonal
  two = 2 ^ n; three = 3 ^ n; four = 4 ^ n
  fpairs = four - two
  fl = three - two
  finc = four - 2 * three + two
  for (i = 0; i <= n; i++) { c[i] = 1; for (k = 1; k <= i; k++) c[i] = c[i] * (n - k + 1) / k }
  fr = 0
  for (i = 0; i <= n; i++) for (j = 0; j <= i; j++) fr += c[i] * c[j]
  fr -= two
  fover = fr - fl
  funder = 0
  printf "full_pairs=%d\n", fpairs
  printf "full_lattice_legal=%d\n", fl
  printf "full_radius_legal=%d\n", fr
  printf "full_over_admitted=%d\n", fover
  printf "full_under_admitted=%d\n", funder
  printf "full_incomparable_unordered=%d\n", finc / 2

  # --- the seated masks: the same reading over what the tree actually constructs ---------------
  sl = 0; sr = 0; sover = 0; sunder = 0; sinc = 0; pairs = 0
  for (i = 1; i <= s; i++) for (j = 1; j <= s; j++) {
    a = seated[i]; b = seated[j]
    if (a == b) continue
    pairs++
    x = bAND(a, b)
    isSub = (x == b); isSup = (x == a)
    if (!isSub && !isSup) {
      sinc++
      if (want_list == "yes" && i < j)
        printf "incomparable %s || %s\n", label[a], label[b]
    }
    L = isSub; R = (popcount(b) <= popcount(a))
    if (L) sl++
    if (R) sr++
    if (R && !L) {
      sover++
      if (want_list == "yes")
        printf "over_admitted %s -> %s\n", label[a], label[b]
    }
    if (L && !R) sunder++
  }
  printf "seated_pairs=%d\n", pairs
  printf "seated_lattice_legal=%d\n", sl
  printf "seated_radius_legal=%d\n", sr
  printf "seated_over_admitted=%d\n", sover
  printf "seated_under_admitted=%d\n", sunder
  printf "seated_incomparable_unordered=%d\n", sinc / 2

  # the widest antichain of the full lattice is the middle binomial row, and it is the width a
  # single line would have to hold at one point -- printed because it is the size of the failure
  printf "widest_antichain=%d\n", c[int(n / 2)]

  # the verdict names which shape the SEATED masks take, never a blank: a population whose every
  # pair is comparable genuinely is a line, and row 2 would stand
  printf "verdict=%s\n", (sinc > 0 ? "lattice" : "line")
}
' "$pen/seated_raw.txt"
