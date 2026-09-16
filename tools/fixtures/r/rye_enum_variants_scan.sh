#!/bin/sh
# tools/fixtures/r/rye_enum_variants_scan.sh -- read a Rye enum's declared variants, in order.
#
# WHAT THIS ANSWERS. Given a Rye source file and an enum name, it prints how many variants the
# enum declares and what they are called, in declaration order:
#
#   sh tools/fixtures/r/rye_enum_variants_scan.sh caravan/restart.rye Meaning
#   enum=Meaning
#   file=caravan/restart.rye
#   count=3
#   variants=answered stopped fallen
#   verdict=ok
#
# WHY IT EXISTS. `src/gate/gate-caravan-exit-meanings-eq-u32.glow` memorizes the number three and
# says in its own head that three is what `Meaning` declares. Nothing compared the two, because
# the gate law grammar in tools/fixtures/g/glow_gate_law_agree_scan.sh could point a `law` line
# only at a plain-integer `const`. That scan's header named an enum's variant count as one of the
# three homes the grammar would have to learn before its ratchet could fall again, and this is
# the reader that home needs. It is the sibling of tools/fixtures/r/rye_struct_fields_scan.sh,
# which answers the same question about a struct's fields, and it inherits that reader's shape,
# its modes, and the `///` lesson below.
#
# THE THREE DECLARATION SHAPES IT READS, each standing in the tree today rather than invented
# for symmetry. Measured 20260915 over 184 tracked Rye files carrying an enum declaration:
#
#   one line, bare        pub const Meaning = enum { answered, stopped, fallen };
#   one line, tagged      pub const InputKind = enum(u8) { key_down = 1, key_up = 2 };
#   many lines            const Path = enum {  ...  full,  ...  minimal,  ...  };
#
# A tagged variant carries `= <n>`, and the name is what stands before it. The tag type in
# `enum(u8)` is read past: it names the enum's backing integer rather than a variant.
#
# A COMMENT LINE IS READ PAST rather than treated as the end of the block -- a `///` doc line and
# a plain `//` note alike, on one clause, since every `///` line begins `//`. That is the lesson
# its struct sibling learned the hard way (`20260907`): a doc comment stood as a terminator
# there, so the better a structure was documented, the fewer members the reader saw.
# `aurora/src/deciding.rye` writes `Path` with a `///` line above each of its two variants, and a
# reader stopping at the first one would answer zero for an enum that declares two. The first
# draft here carried the two clauses separately, and removing the `///` one changed no reading at
# all -- which is how the overlap was found: a clause nothing can break is a clause doing no work.
#
# WHEN IT CANNOT ANSWER it says so rather than guessing, and exits 1 so a caller that trusts
# `count=` never reads a zero as an answer:
#   verdict=no_file      -- the named file is not there
#   verdict=no_enum      -- the file holds no `const <name> = enum` declaration
#   verdict=no_variants  -- the declaration stands and names no variant
#
# MODES. The default block is for a reader. The two narrow modes exist so a caller can compare
# exactly rather than by substring: `contains "count=3"` is satisfied by 30 as well as by 3.
#   (no flag)    the block above
#   --count      the variant count alone, one line
#   --variants   the space-joined variant names alone, one line
#
# WHAT IT DOES NOT REACH. A variant carrying a payload (`ok: u32`) is a tagged union rather than
# a plain enum, and this tree authors none inside a `= enum` declaration; such a line would be
# read as the end of the block rather than counted, which refuses rather than miscounts.
#
# Read by tools/fixtures/g/glow_gate_law_agree_scan.sh for a `law` line naming `<Enum>.variants`.
# Proven by tools/fixtures/r/rye_enum_variants_control.sh under
# tools/r/rye_enum_variants_witness.rish. Run from the repository root.

set -eu

mode="block"
case "${1:-}" in
  --count)    mode="count";    shift ;;
  --variants) mode="variants"; shift ;;
esac

file="${1:-}"
name="${2:-}"

if [ -z "$file" ] || [ -z "$name" ]; then
  echo "usage: rye_enum_variants_scan.sh [--count|--variants] <rye-file> <enum-name>" >&2
  exit 2
fi

emit() {
  # $1 variants, $2 count, $3 verdict
  case "$mode" in
    count)    echo "$2" ;;
    variants) echo "$1" ;;
    *)
      echo "enum=$name"
      echo "file=$file"
      echo "count=$2"
      echo "variants=$1"
      echo "verdict=$3"
      ;;
  esac
}

if [ ! -f "$file" ]; then
  emit "" 0 no_file
  exit 1
fi

# awk does the whole read. `found` tells "no declaration at all" apart from "a declaration
# naming nothing" -- two different faults that deserve two different words.
result=$(awk -v want="$name" '
  function add(v) {
    gsub(/^[ \t]+|[ \t]+$/, "", v)
    if (v == "") return
    variants = (count == 0) ? v : variants " " v
    count++
  }
  # Split a comma-separated run of variants, dropping any `= <n>` tag value.
  function spill(body,   n, i, parts) {
    n = split(body, parts, ",")
    for (i = 1; i <= n; i++) {
      sub(/=.*$/, "", parts[i])
      add(parts[i])
    }
  }
  BEGIN { found = 0; done = 0; open = 0; count = 0; variants = "" }
  done { next }
  !found {
    if ($0 !~ "^[ \t]*(pub[ \t]+)?const[ \t]+" want "[ \t]*=[ \t]*enum") next
    found = 1
    line = $0
    # Drop everything through the opening brace. The tag type in `enum(u8)` leaves with it.
    sub(/^[^{]*\{/, "", line)
    if (line ~ /\}/) {
      # One-line declaration: the variants are what stands before the closing brace.
      sub(/\}.*$/, "", line)
      spill(line)
      done = 1
    } else {
      open = 1
      spill(line)
    }
    next
  }
  {
    # Any comment line is read past -- a `///` doc line and a `//` note alike, since a `///`
    # line begins `//`. One clause rather than two that overlap.
    if ($0 ~ /^[ \t]*\/\//) next
    if ($0 ~ /^[ \t]*$/) next
    if ($0 ~ /^[ \t]*\}/) { done = 1; next }
    # A variant: an identifier, an optional `= <n>` tag value, a comma, and an optional `//` tail.
    if ($0 ~ /^[ \t]*[a-z_][a-zA-Z0-9_]*[ \t]*(=[ \t]*[^,]+)?,[ \t]*(\/\/.*)?$/) {
      line = $0
      sub(/[ \t]*(\/\/.*)?$/, "", line)
      sub(/,[ \t]*$/, "", line)
      sub(/=.*$/, "", line)
      add(line)
      next
    }
    done = 1
  }
  END { printf "%d\n%s\n%d\n", found, variants, count }
' "$file")

found=$(echo "$result" | sed -n '1p')
variants=$(echo "$result" | sed -n '2p')
count=$(echo "$result" | sed -n '3p')

if [ "$found" -eq 0 ]; then
  emit "$variants" "$count" no_enum
  exit 1
fi

if [ "$count" -eq 0 ]; then
  emit "$variants" "$count" no_variants
  exit 1
fi

emit "$variants" "$count" ok
