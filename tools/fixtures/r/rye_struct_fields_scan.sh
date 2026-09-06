#!/bin/sh
# tools/fixtures/r/rye_struct_fields_scan.sh -- read a Rye struct's declared fields, in order.
#
# WHAT THIS ANSWERS. Given a Rye source file and a struct name, it prints how many fields the
# struct declares and what they are called, in declaration order:
#
#   sh tools/fixtures/r/rye_struct_fields_scan.sh mantra/src/weave.rye Line
#   struct=Line
#   file=mantra/src/weave.rye
#   count=3
#   fields=text gen pos
#   verdict=ok
#
# WHY IT EXISTS (REDS %500). Four rostered tier-lap guards named `*-field-count` each declared
# that a structure "carries exactly N fields" and proved it with N `grep -Fq` calls for N field
# lines. A presence grep cannot see an N+1st field, and cannot see a reorder either -- though
# every one of those four refused with the words "missing or reordered". Two named movements of
# the Mantra arc were recorded as waiting on that pin: the identity gap, which wants a wider
# `Line`, and the diff anchor, which wants a wider `Diff`. The pin was not there. This scan reads
# the count and the order, so the placard's claim and the code can finally be compared.
#
# WHAT IT ASSUMES, stated rather than hidden. A struct declares its fields contiguously at the
# head of its body, one per line, each ending in a comma and optionally a trailing `//` comment.
# That is how every struct in `mantra/` is written and what Zig's own formatter produces. The
# scan stops at the first line under the opener that is not a field -- a blank line, a doc
# comment, a `pub fn`, or the closing brace -- so a method body is never read as a field list.
#
# WHEN IT CANNOT ANSWER it says so rather than guessing, and exits 1 so a caller that trusts
# `count=` never reads a zero as an answer:
#   verdict=no_file    -- the named file is not there
#   verdict=no_struct  -- the file holds no `pub const <name> = struct {` opener
#   verdict=no_fields  -- the opener stands and the line under it is already not a field
#
# MODES. The default block is for a reader. The two narrow modes exist so a caller can compare
# exactly rather than by substring: `contains "count=3"` is satisfied by 30 as well as by 3,
# which is this scan's own subject one turn down.
#   (no flag)   the block above
#   --count     the field count alone, one line
#   --fields    the space-joined field names alone, one line
#
# Read by tools/m/mantra_glow_tend_limb{1,2,3,4}_witness.rish.
# Proven by tools/fixtures/r/rye_struct_fields_control.sh under
# tools/r/rye_struct_fields_witness.rish. Run from the repository root.

set -eu

mode="block"
case "${1:-}" in
  --count)  mode="count";  shift ;;
  --fields) mode="fields"; shift ;;
esac

file="${1:-}"
name="${2:-}"

if [ -z "$file" ] || [ -z "$name" ]; then
  echo "usage: rye_struct_fields_scan.sh [--count|--fields] <rye-file> <struct-name>" >&2
  exit 2
fi

emit() {
  # $1 found, $2 fields, $3 count, $4 verdict
  case "$mode" in
    count)  echo "$3" ;;
    fields) echo "$2" ;;
    *)
      echo "struct=$name"
      echo "file=$file"
      echo "count=$3"
      echo "fields=$2"
      echo "verdict=$4"
      ;;
  esac
}

if [ ! -f "$file" ]; then
  emit 0 "" 0 no_file
  exit 1
fi

# awk does the whole read: find the opener, then walk fields until the first line that is not
# one. `found` tells "no opener at all" apart from "an opener with nothing under it" -- two
# different faults that deserve two different words.
result=$(awk -v want="$name" '
  BEGIN { found = 0; done = 0; count = 0; fields = "" }
  done { next }
  !found {
    if ($0 ~ "^pub const " want " = struct \\{$" || $0 ~ "^const " want " = struct \\{$") {
      found = 1
    }
    next
  }
  {
    # A field: leading space, a lowercase identifier, a colon, a type, a comma, and an
    # optional `//` tail -- several fields in mantra/ carry one.
    if ($0 ~ /^[ \t]+[a-z_][a-zA-Z0-9_]*[ \t]*:[ \t]*[^,]+,[ \t]*(\/\/.*)?$/) {
      line = $0
      sub(/^[ \t]+/, "", line)
      sub(/[ \t]*:.*$/, "", line)
      fields = (count == 0) ? line : fields " " line
      count++
      next
    }
    done = 1
  }
  END { printf "%d\n%s\n%d\n", found, fields, count }
' "$file")

found=$(echo "$result" | sed -n '1p')
fields=$(echo "$result" | sed -n '2p')
count=$(echo "$result" | sed -n '3p')

if [ "$found" -eq 0 ]; then
  emit "$found" "$fields" "$count" no_struct
  exit 1
fi

if [ "$count" -eq 0 ]; then
  emit "$found" "$fields" "$count" no_fields
  exit 1
fi

emit "$found" "$fields" "$count" ok
