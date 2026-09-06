#!/bin/sh
# sow_allow_reach_scan.sh -- an allowed room that ships nothing is counted, not trusted.
#
# WHY THIS EXISTS (REDS %485). `template-manifest.bron` is an allowlist: the seed ships only what an
# `allow` line names. On `20260906` a second filter inside `tools/fixtures/s/sow_project.sh` --
# `grep -vxE 'gratitude|vendor'`, a hard exclusion by NAME, running after the allowlist -- silently
# discarded an allowed room. The manifest read allow, the projection ran, and `sow_witness` answered
# GREEN, because a room that ships no bytes leaks no names. `ls seed/gratitude` read 0.
#
# So the gate is the OTHER direction from every existing seed guard. `sow_witness` asks *did
# anything private get out*; `seed_link` asks *does a shipped link land*. Neither can ask *did the
# thing we allowed actually arrive*, and a publish is exactly as wrong when a room is missing as
# when a name leaks -- quieter, and therefore worse.
#
#   sh tools/fixtures/s/sow_allow_reach_scan.sh
#
# Prints `allows=N shipped=N withheld_by_design=N empty=N`, one `empty:` line per silently-missing
# room and one `withheld:` line per loudly-withheld one. `empty` is the gate; zero is the only
# passing reading.
#
# WHAT IS NOT A FAULT, and why each is excluded rather than waived. A room whose every tracked file
# sits under a `sub_exclude` ships nothing BY DESIGN -- `linengrow` is the standing example. A path
# the field does not have cannot ship. A single-file `allow` is checked as a file rather than a
# directory, since `README.md` is a room of one. And -- the distinction this guard turns on -- a
# file the projector WITHHELD is absent LOUDLY: it stands in `.sow-withheld.log`, which is the
# fail-safe working rather than failing. The fault is absent AND unlogged. The first run of this
# scan found exactly that difference: `context/LEXICON.md` is allowed and never ships, because an
# identity string survives the scrub and defence in depth drops the copy. Reported here as
# `withheld_by_design`, never gated, and worth a lap of its own -- the seed's readers have no
# Lexicon and nothing said so.
#
# BOUNDS: the manifest's own allow list (106 lines on 20260906), one `git ls-files` per room.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

MANIFEST=${SOW_MANIFEST:-template-manifest.bron}
SEED=${SOW_SEED:-seed}

[ -f "$MANIFEST" ] || { echo "refused: no manifest at $MANIFEST"; exit 2; }
# A scan that reads nothing must refuse rather than report clean (REDS %170).
[ -d "$SEED" ] || { echo "refused: no projection at $SEED/ -- run tools/s/sow.rish first"; exit 2; }

SUBEX=$(grep -E '^sub_exclude ' "$MANIFEST" | awk '{print $2}' || true)
is_subex() {
  for x in $SUBEX; do
    case "$1" in "$x"|"$x"/*) return 0;; esac
  done
  return 1
}

allows=0
shipped=0
withheld=0
empty=0

# The projector's own logs, which are what tell a LOUD absence from a silent one.
LOGGED=""
for lg in "$SEED/.sow-withheld.log" "$SEED/.sow-excluded.log"; do
  [ -f "$lg" ] && LOGGED="$LOGGED
$(cat "$lg")"
done
is_logged() {
  printf '%s\n' "$LOGGED" | grep -qxF "$1"
}

for p in $(grep -E '^allow ' "$MANIFEST" | awk '{print $2}'); do
  allows=$((allows + 1))
  is_subex "$p" && continue                       # withheld whole, on purpose
  tracked=$(git ls-files -- "$p" | head -400)
  [ -n "$tracked" ] || continue                   # the field does not carry it

  # every tracked file withheld by sub-path is a room that ships nothing by design
  any_shippable=no
  for f in $tracked; do
    is_subex "$f" || { any_shippable=yes; break; }
  done
  [ "$any_shippable" = yes ] || continue

  if [ -f "$SEED/$p" ] || [ -n "$(find "$SEED/$p" -type f -print -quit 2>/dev/null)" ]; then
    shipped=$((shipped + 1))
  else
    # absent -- now ask whether the projector SAID so. A logged absence is the fail-safe.
    loud=no
    for f in $tracked; do
      is_logged "$f" && { loud=yes; break; }
    done
    if [ "$loud" = yes ]; then
      withheld=$((withheld + 1))
      echo "withheld: $p -- absent, and the projector logged why (defence in depth)"
    else
      empty=$((empty + 1))
      echo "empty: $p -- allowed, shippable, and absent with nothing logged"
    fi
  fi
done

echo "allows=$allows"
echo "shipped=$shipped"
echo "withheld_by_design=$withheld"
echo "empty=$empty"
