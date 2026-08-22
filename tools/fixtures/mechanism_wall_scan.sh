#!/bin/sh
# The mechanism wall, proven by doing rather than by reading the hook.
#
# Four planted messages meet `tools/hooks/commit-msg` exactly as git presents them:
#   - a long body written purely in image, which must be REFUSED
#   - the same change named plainly -- its function, its file, its parameter -- which must be
#     WELCOMED, because a wall that refuses good prose teaches an author to resent it
#   - an honestly-short body, which passes free; a pin has little mechanism to name and being
#     nagged for it would make the wall noise
#   - a refusal that must TEACH: naming the rule and the vocabulary it counted, and leaving the
#     author's own words untouched on disk
#
# Read-only: nothing is committed and no message in the tree is rewritten.
set -eu

ROOT="$(CDPATH= cd "$(dirname "$0")/../.." && pwd)"
HOOK=$ROOT/tools/hooks/commit-msg
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

test -x "$HOOK" || { echo "WALL_HOOK_PRESENT 0"; exit 1; }
echo "WALL_HOOK_PRESENT 1"

cat > "$WORK/metaphor" <<'MSG'
caravan: the wire before the memory, written once

A boundary written twenty times is a boundary twenty places may drift
across. The fall is exactly the carry less the reach, and the two
readings move apart by better than sixty to one, which is how a reader
tells a fold from a cost merely moved somewhere cheaper to count. The
ceiling comes down, keeping the six lines of headroom the discipline has
held all along, and the choir sings green at a hundred and seven. What
stood in many places now stands in one, and the ladder is lighter for it.
MSG

cat > "$WORK/mechanism" <<'MSG'
caravan: the wire before the memory, written once

The fifty-five-line body moved into one published function in
caravan/ladder_checks.rye, and each of the twenty rungs now calls it
through a three-line stub that hands its own type in, so the shared body
reaches every constant and error set through the rung that called it.
All twenty-three contract symbols already stood public, so this widened
no declaration anywhere on the ladder.

A boundary written twenty times is a boundary twenty places may drift
across; written once, it holds for every rung that reaches it.
MSG

cat > "$WORK/short" <<'MSG'
crux: pin the operator card to the lift

The Now line moves to the freshly landed round.
MSG

if sh "$HOOK" "$WORK/metaphor" >"$WORK/out" 2>&1; then
  echo "WALL_REFUSES_METAPHOR 0"
else
  echo "WALL_REFUSES_METAPHOR 1"
fi

if sh "$HOOK" "$WORK/mechanism" >/dev/null 2>&1; then
  echo "WALL_WELCOMES_MECHANISM 1"
else
  echo "WALL_WELCOMES_MECHANISM 0"
  sh "$HOOK" "$WORK/mechanism" 2>&1 | sed 's/^/  /'
fi

if sh "$HOOK" "$WORK/short" >/dev/null 2>&1; then
  echo "WALL_SPARES_SHORT 1"
else
  echo "WALL_SPARES_SHORT 0"
fi

# The refusal must teach: the rule by path, and the vocabulary it actually counted.
if grep -q "mechanism-sentence.md" "$WORK/out" && grep -q "Vocabulary counted:" "$WORK/out"; then
  echo "WALL_TEACHES 1"
else
  echo "WALL_TEACHES 0"
fi

# The ONE named exemption, proven both ways. The public seed's root commit describes a
# repository rather than a change, so it carries no mechanism to name -- and an ordinary
# commit must be unable to borrow that exemption by writing a thin body.
cat > "$WORK/seedroot" <<'MSG'
Grain OS -- initial public seed

A personal operating system in the Glow language: bounded, asserted,
custody-first. Clone it, build a module, run its witness, watch it go green.
And a second sentence of plain description, so the body is long enough that
an unexempted commit of this length and this vocabulary would be refused
outright by the wall standing above it, which is exactly the point.
MSG
if sh "$HOOK" "$WORK/seedroot" >/dev/null 2>&1; then
  echo "WALL_EXEMPTS_SEED_ROOT 1"
else
  echo "WALL_EXEMPTS_SEED_ROOT 0"
fi

cat > "$WORK/borrower" <<'MSG'
caravan: initial public seed

A personal operating system in the Glow language: bounded, asserted,
custody-first. Clone it, build a module, run its witness, watch it go green.
And a second sentence of plain description, so the body is long enough that
an unexempted commit of this length and this vocabulary would be refused
outright by the wall standing above it, which is exactly the point.
MSG
if sh "$HOOK" "$WORK/borrower" >/dev/null 2>&1; then
  echo "WALL_EXEMPTION_BORROWED 1"
else
  echo "WALL_EXEMPTION_BORROWED 0"
fi

before=$(cat "$WORK/metaphor")
sh "$HOOK" "$WORK/metaphor" >/dev/null 2>&1 || true
if test "$before" = "$(cat "$WORK/metaphor")"; then
  echo "WALL_MESSAGE_KEPT 1"
else
  echo "WALL_MESSAGE_KEPT 0"
fi
exit 0
