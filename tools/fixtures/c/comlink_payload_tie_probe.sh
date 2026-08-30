#!/bin/sh
# tools/fixtures/c/comlink_payload_tie_probe.sh -- the comptime tie, proven on metal both ways.
#
# WHY THIS EXISTS SEPARATELY FROM THE SCAN. The scan reads text, so it can prove a tie is WRITTEN
# and can never prove it HOLDS. Four fifths of the payload ceiling is decided inside the crypto
# library -- ChaCha20Poly1305's nonce and tag, Sha3_512's digest, Kumara's signature -- and no
# grep evaluates those. The compiler does, at comptime, which is why the tie is the reading that
# actually catches a wider signature moving the envelope.
#
# So this probe hands the question to the language. It copies comlink/ into a throwaway pen
# (dereferencing the symlinks that point into mantra/ and amphora/), and asks twice:
#
#   HOLDS    -- each tied module compiles as it stands, so `max_wire_payload <= wf.max_message`
#               is true against the real library widths rather than against a remembered 188.
#   REFUSES  -- the same tie inverted stops the build at comptime. A refusal proven only in the
#               passing direction cannot be told from a bypass, and a comptime block that is
#               never evaluated would pass this probe's first half in perfect silence.
#
# The pen is a copy, so the tree is never edited to prove this.
#
# WHAT IT READS
#   tied_modules   how many modules carry the tie
#   tie_holds      how many of those compile as they stand
#   tie_refuses    how many refuse at comptime once inverted
#   verdict        proven, or the first failure found
#
# USAGE
#   sh tools/fixtures/c/comlink_payload_tie_probe.sh
#
# Driven by tools/co/comlink_glow_tend_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"

tied='recall_sync_wire recall_tablecloth_query_wire'

for f in "$zig" "$rye"; do
  [ -x "$f" ] || { echo "verdict=toolchain_missing"; echo "detail: $f"; exit 1; }
done

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The pen dereferences symlinks on purpose: two of the three copying rooms live in mantra/ and are
# reached through a comlink/ face, and a pen holding dangling links would prove nothing.
cp -RL "$root/comlink" "$work/comlink"

tied_modules=0
tie_holds=0
tie_refuses=0
verdict=proven

for m in $tied; do
  src="$work/comlink/$m.rye"
  if [ ! -f "$src" ]; then
    verdict=module_missing
    echo "detail: $m is not in the pen"
    continue
  fi
  if ! grep -q 'assert(max_wire_payload <= wf\.max_message);' "$src"; then
    verdict=tie_absent
    echo "detail: $m carries no tie to invert"
    continue
  fi
  tied_modules=$((tied_modules + 1))

  # HOLDS -- as it stands.
  if env RYE_ZIG="$zig" "$rye" build-lib "$src" -lc -femit-bin="$work/$m.o" >"$work/$m.hold.log" 2>&1; then
    tie_holds=$((tie_holds + 1))
  else
    verdict=tie_does_not_hold
    echo "detail: $m does not compile with its tie as written"
  fi

  # REFUSES -- the same tie inverted. Rewritten through the original inode so the pen file keeps
  # the mode it was copied with (.claude/rules/exec-bit.md).
  sed 's/assert(max_wire_payload <= wf\.max_message);/assert(max_wire_payload > wf.max_message);/' \
    "$src" > "$src.tmp" && cat "$src.tmp" > "$src" && rm -f "$src.tmp"
  if env RYE_ZIG="$zig" "$rye" build-lib "$src" -lc -femit-bin="$work/$m.bad.o" >"$work/$m.bad.log" 2>&1; then
    verdict=inverted_tie_built
    echo "detail: $m built with its tie inverted -- the comptime block is not being evaluated"
  else
    if grep -q 'called at comptime here' "$work/$m.bad.log"; then
      tie_refuses=$((tie_refuses + 1))
    else
      verdict=refused_elsewhere
      echo "detail: $m refused for a reason other than the comptime tie"
    fi
  fi
done

echo "tied_modules=$tied_modules"
echo "tie_holds=$tie_holds"
echo "tie_refuses=$tie_refuses"

if [ "$verdict" = proven ]; then
  if [ "$tied_modules" -lt 2 ] \
    || [ "$tie_holds" -ne "$tied_modules" ] \
    || [ "$tie_refuses" -ne "$tied_modules" ]; then
    verdict=counts_disagree
  fi
fi

echo "verdict=$verdict"
[ "$verdict" = proven ] || exit 1
