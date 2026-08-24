#!/bin/sh
# tools/fixtures/crypto_tool_declaration_scan.sh -- a declared crypto tool is a redirect, not an excuse.
#
# WHY. tools/cr/crypto_count_guard_witness.rish holds a bijection between crypto/*.rye and the
# per-file witnesses tools/cr/crypto_suite_witness.rish registers. crypto/sha3_digest.rye is a
# command-line program rather than a primitive, so the suite has no `GREEN crypto-<name>` line to
# read from it, and the bijection went RED on 20260824 while the guard itself stood off the standing
# roster -- unrun, so nobody heard it, for as long as it had been red (REDS %191).
#
# The repair declares the second class in tools/fixtures/crypto_tool_modules.txt. This scan is what
# stops that declaration from being a hole in the guard: each row is checked in three directions, so
# a redirect pointing nowhere reds exactly like an unproven file would.
#
# WHAT IT READS, and every reading is gated at zero by the witness.
#   declared        rows in the declaration (comments and blank lines dropped)
#   ghost_module    a declared module with no crypto/<name>.rye on disk
#   missing_witness a declared module whose proving witness is not a file
#   unrostered      a declared module whose proving guard is absent from the standing roster
#   malformed       a row that does not carry exactly three fields
#
# The third reading is the one this round exists for. A guard that is never run guards nothing, so a
# tool excused from the suite must name a proof a lap ACTUALLY RUNS -- and the roster is where the
# tree records that. Without it the declaration would launder an unproven file into a green count.
#
# USAGE
#   sh tools/fixtures/crypto_tool_declaration_scan.sh          # key=value census
#   sh tools/fixtures/crypto_tool_declaration_scan.sh list     # one fault per line
#
# Driven by tools/cr/crypto_count_guard_witness.rish. Proven both ways by
# tools/fixtures/crypto_tool_declaration_control.sh. Run from the repository root.
set -eu

MODE="${1:-census}"
DECL="${CRYPTO_TOOL_DECL:-tools/fixtures/crypto_tool_modules.txt}"
ROSTER="${CRYPTO_TOOL_ROSTER:-construction/standing-equipment.kyri}"
DIR="${CRYPTO_TOOL_DIR:-crypto}"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT INT TERM

if [ ! -f "$DECL" ]; then
  echo "verdict=no_declaration"
  echo "refused: no tool declaration at $DECL" >&2
  exit 1
fi

grep -vE '^[[:space:]]*(#|$)' "$DECL" > "$TMP/rows" || : > "$TMP/rows"
declared=$(wc -l < "$TMP/rows" | tr -d ' ')

: > "$TMP/faults"
malformed=0
ghost=0
missing=0
unrostered=0

while IFS= read -r row; do
  [ -n "$row" ] || continue
  n=$(printf '%s\n' "$row" | awk '{print NF}')
  if [ "$n" -ne 3 ]; then
    malformed=$((malformed + 1))
    echo "malformed: $row" >> "$TMP/faults"
    continue
  fi
  m=$(printf '%s\n' "$row" | awk '{print $1}')
  w=$(printf '%s\n' "$row" | awk '{print $2}')
  g=$(printf '%s\n' "$row" | awk '{print $3}')

  if [ ! -f "$DIR/$m.rye" ]; then
    ghost=$((ghost + 1))
    echo "ghost_module: $m names no $DIR/$m.rye" >> "$TMP/faults"
  fi
  if [ ! -f "$w" ]; then
    missing=$((missing + 1))
    echo "missing_witness: $m redirects to $w, which is not a file" >> "$TMP/faults"
  fi
  if ! grep -qxF "guard $g" "$ROSTER"; then
    unrostered=$((unrostered + 1))
    echo "unrostered: $m is proven by $g, which the standing roster does not name" >> "$TMP/faults"
  fi
done < "$TMP/rows"

if [ "$MODE" = "list" ]; then
  cat "$TMP/faults"
  exit 0
fi

faults=$((malformed + ghost + missing + unrostered))
echo "declared=$declared"
echo "malformed=$malformed"
echo "ghost_module=$ghost"
echo "missing_witness=$missing"
echo "unrostered=$unrostered"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=declaration_unsound"; fi
