#!/bin/sh
# tools/fixtures/g/glow_decimal_law_scan.sh -- how many verdicts does Glow give one decimal literal?
#
# WHY THIS EXISTS. glow/rune_shop_gate.rye:522 carries a function whose own comment names a law:
#
#   /// STOA331: decimal literal to u32 -- refuses empty, leading zero (house parse law), overflow.
#
# It is the only reader in the language that holds it. Measured 20260909 and proven on metal, the
# same source text gets two different answers depending on which lowering path reads it:
#
#   ?:  (eq a b)  01  0     glow/rune_shop_gate.rye     refused, MalformedBody
#   =/  amount  007         glow/lower_multi.rye        GREEN, lowered `const amount: u32 = 7;`
#   =/  amount  03          glow/lower_compose.rye      GREEN, lowered `const amount: u32 = 3;`
#
# A house law declared in one of fourteen readers is a house law nobody can rely on. Which way it
# should fall -- Glow refuses a leading zero everywhere, or accepts one everywhere -- is a language
# custody ruling and stays Keaton's. This meter takes neither side: it counts how many DISTINCT
# verdicts the language gives one literal, and that number falls to one whichever way the ruling
# lands.
#
# THE LEXER IS NEUTRAL, AND THAT IS WHY THE SPLIT COULD HIDE. glow/tokens.rye scan_digits takes any
# run of digits and emits one `.decimal` token; nothing about a leading zero reaches the token
# stream. The disagreement lives entirely in the fourteen functions that turn that token's bytes
# into a u32, and no two of them are called from one place, so no test ever sat them side by side.
#
# WHAT IT READS. Every authored glow/*.rye outside the witnesses, walked one file-scope function at
# a time. A function is a SOURCE-DECIMAL READER when its body turns source bytes into an integer by
# either shape this tree writes:
#
#   parseInt     std.fmt.parseInt(u32, <slice of source>, 10)
#   digit_loop   a hand-written accumulator over `- '0'`
#
# Three exclusions, each for its own reason. A `//` comment line is not code. A line inside an
# `append_print` format string or a `\\` multiline literal is EMITTED Zig -- the desk it builds
# reads argv at runtime, which is a different subject from reading the programmer's own bytes. And
# a function that also tests 'a'..'f' is a HEX reader, where a leading zero is ordinary
# (`@ux0007` is two bytes) rather than a question -- glow/lower_face_lit.rye hex_nibble is the one.
#
# The readings below include one ratchet and one gate.
#
#   sources             authored glow/*.rye this scan walked
#   readers             source-decimal readers found, derived from the tree rather than listed
#   law_held            readers that refuse a leading zero
#   law_absent          readers that accept one
#   verdicts            distinct verdicts for one literal            -- RATCHET, falls to 1 either way
#   law_claimed_absent  a reader whose comment names the house parse law
#                       while its body lacks the check               -- GATED AT ZERO
#
# WHY verdicts IS THE RATCHET AND law_absent IS NOT. A ceiling on law_absent would presume the
# ruling: rule that Glow accepts leading zeros and the repair deletes the check from its one
# holder, taking law_absent from 13 to 14 and reddening this guard for landing the answer. The
# count of distinct verdicts falls to one under either ruling, so the meter can hold the fault
# still without deciding it.
#
# WHY law_claimed_absent IS GATED. glow/rune_assert.rye parse_decimal is glow/rune_shop_gate.rye
# parse_decimal_u32 byte for byte, minus the loop variable's name and minus the one line that
# refuses a leading zero. Copying a law's shape without its check is how this split reached
# fourteen readers in the first place, and copying its COMMENT too is the same move one step
# louder. That case is decidable today, stands at zero, and reds on the lap it arrives.
#
# WHAT THIS DOES NOT REACH. Whether a reader's verdict is the right one -- that is the ruling. Nor
# whether a fifteenth shape exists: a reader built from a lookup table matches neither pattern and
# would read as no reader at all rather than as an unclassified one. What holds that honest is the
# ratchet's own denominator, since a new reader accepting a leading zero leaves `verdicts` at two
# and shows up in `law_absent`, which is printed on every pass.
#
#   sh tools/fixtures/g/glow_decimal_law_scan.sh

set -u

LC_ALL=C
export LC_ALL

# Root by upward walk (seated 20260828): the letter fold moves this script's depth, so fixed
# ../.. arithmetic breaks. Git-free, so a pen copy outside a repository still resolves.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_gl_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/glow" ]; do
  _gl_steps=$((_gl_steps + 1))
  if [ "$_gl_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs tools/fixtures and glow)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

GLOW_DIR=${GLOW_DECIMAL_DIR:-glow}
VERDICTS_CEILING=${GLOW_DECIMAL_VERDICTS_CEILING:-2}

WORK=$(mktemp -d "${TMPDIR:-/tmp}/glow-decimal-law.XXXXXX") || exit 2
trap 'rm -rf "$WORK"' EXIT INT TERM

# The population: authored Glow compiler sources. A witness is a prover rather than a reader of
# programmer text, and its plants deliberately carry shapes this scan would count. glow/.cache/ and
# glow/bin/ hold LOWERED output -- 632 of the 699 *.rye under glow/ on this pier -- which is this
# compiler's product rather than its source, and counting a generated file's parseInt would read
# the lowering's own emitted argv reader as a fifteenth law-breaking hand.
find "$GLOW_DIR" -name '*.rye' -type f 2>/dev/null |
  grep -v '_witness\.rye$' |
  grep -v "^$GLOW_DIR/\.cache/" |
  grep -v "^$GLOW_DIR/bin/" |
  sort > "$WORK/sources"
sources=$(wc -l < "$WORK/sources" | tr -d ' ')

: > "$WORK/readers"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  awk -v F="$f" '
    /^(pub )?fn / {
      fn = $0; sub(/^(pub )?fn /, "", fn); sub(/\(.*/, "", fn)
      inbody = 1; reads = 0; law = 0; hex = 0; claims = 0; shape = ""
      next
    }
    inbody && /^}/ {
      if (reads && !hex)
        printf "%s\t%s\t%s\t%s\t%s\n", F, fn, shape, (law ? "refuse" : "accept"), (claims ? "claims" : "silent")
      inbody = 0
      next
    }
    inbody {
      line = $0
      sub(/^[ \t]+/, "", line)
      # A comment naming the house parse law is a CLAIM, read before the comment is skipped.
      if (line ~ /^\/\// && line ~ /house parse law/) { claims = 1; next }
      if (line ~ /^\/\//) next
      # Emitted Zig: the desk it builds reads argv at runtime, a different subject.
      if (line ~ /append_print/ || line ~ /^\\\\/) next
      if (line ~ /parseInt\(u(8|16|32|64)/) { reads = 1; shape = "parseInt" }
      if (line ~ /- .0./ && line ~ /'"'"'0'"'"'/) { reads = 1; shape = "digit_loop" }
      if (line ~ /is_hex_digit/ || line ~ /<= .f./ || line ~ /<= .F./) { hex = 1 }
      if (line ~ /\[0\] == .0./) { law = 1 }
    }
  ' "$f" >> "$WORK/readers"
done < "$WORK/sources"

# A doc comment sits ABOVE its fn, so a claim on the line before the header belongs to that fn.
# Re-read each source for a `house parse law` comment immediately preceding a fn, and mark it.
: > "$WORK/claims"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  awk -v F="$f" '
    /house parse law/ { pending = 1; next }
    /^(pub )?fn / {
      if (pending) { fn = $0; sub(/^(pub )?fn /, "", fn); sub(/\(.*/, "", fn); printf "%s\t%s\n", F, fn }
      pending = 0; next
    }
    { if ($0 !~ /^\/\//) pending = 0 }
  ' "$f" >> "$WORK/claims"
done < "$WORK/sources"

# Body comments were collected with their reader; merge them with doc claims once.
awk -F'\t' '$5 == "claims" { printf "%s\t%s\n", $1, $2 }' "$WORK/readers" >> "$WORK/claims"
sort -u "$WORK/claims" > "$WORK/claims.unique"
mv "$WORK/claims.unique" "$WORK/claims"

readers=$(wc -l < "$WORK/readers" | tr -d ' ')
awk -F'\t' '$4 == "refuse"' "$WORK/readers" > "$WORK/law_held"
awk -F'\t' '$4 == "accept"' "$WORK/readers" > "$WORK/law_absent"
law_held=$(wc -l < "$WORK/law_held" | tr -d ' ')
law_absent=$(wc -l < "$WORK/law_absent" | tr -d ' ')

verdicts=0
[ "$law_held" -gt 0 ] && verdicts=$((verdicts + 1))
[ "$law_absent" -gt 0 ] && verdicts=$((verdicts + 1))

# A reader whose comment names the law while its body lacks the check.
: > "$WORK/claimed_absent"
while IFS="$(printf '\t')" read -r cf cfn; do
  [ -n "${cf:-}" ] || continue
  if awk -F'\t' -v f="$cf" -v n="$cfn" '$1 == f && $2 == n && $4 == "accept" { found = 1 } END { exit !found }' "$WORK/readers"; then
    printf '%s\t%s\n' "$cf" "$cfn" >> "$WORK/claimed_absent"
  fi
done < "$WORK/claims"
law_claimed_absent=$(wc -l < "$WORK/claimed_absent" | tr -d ' ')

verdict=ok
if [ "$law_claimed_absent" -ne 0 ]; then
  verdict=law_claimed_absent
  echo "detail: a reader's comment names the house parse law and its body lets a leading zero through --"
  sed 's/^/  /' "$WORK/claimed_absent"
fi
if [ "$verdicts" -gt "$VERDICTS_CEILING" ]; then
  verdict=over_verdicts_ceiling
  echo "detail: $verdicts distinct verdicts for one decimal literal, past the ceiling of $VERDICTS_CEILING --"
  sed 's/^/  /' "$WORK/readers"
fi

echo "sources=$sources"
echo "readers=$readers"
echo "law_held=$law_held"
echo "law_absent=$law_absent"
echo "verdicts=$verdicts"
echo "verdicts_ceiling=$VERDICTS_CEILING"
echo "law_claimed_absent=$law_claimed_absent"
echo "verdict=$verdict"

[ "$verdict" = ok ] || exit 1
